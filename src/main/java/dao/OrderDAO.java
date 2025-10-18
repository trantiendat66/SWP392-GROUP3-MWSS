/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import db.DBContext;
import java.math.BigDecimal;
import model.Cart;

import java.sql.*;
import java.util.*;
import model.Order;
import model.OrderDetail;

/**
 *
 * @author Oanh Nguyen
 */
public class OrderDAO extends DBContext {

    /**
     * Tạo đơn hàng từ danh sách item. - Insert Order (PENDING) + OrderDetail -
     * Trừ kho bằng UPDATE có điều kiện (đủ hàng mới trừ) - Tất cả trong
     * transaction
     */
    public int createOrder(int customerId, String phone, String shippingAddress,
            int paymentStatusBit, List<Cart> items) throws SQLException {
        if (items == null || items.isEmpty()) {
            throw new SQLException("Giỏ hàng rỗng.");
        }

        // Gộp sản phẩm trùng productId
        Map<Integer, Cart> byProduct = new LinkedHashMap<>();
        long total = 0;
        for (Cart it : items) {
            byProduct.merge(it.getProductId(), it, (a, b) -> {
                a.setQuantity(a.getQuantity() + b.getQuantity());
                return a;
            });
        }
        for (Cart it : byProduct.values()) {
            total += (long) it.getPrice() * it.getQuantity();
        }

        try (Connection cn = new DBContext().getConnection()) {
            if (cn == null) {
                throw new SQLException("Không kết nối được DB.");
            }
            cn.setAutoCommit(false);
            cn.setTransactionIsolation(Connection.TRANSACTION_READ_COMMITTED);

//            int orderId;
//
//            // 1) Tạo Order
//            String sqlOrder = "INSERT INTO [Order](account_id, customer_id, phone, order_date, "
//                    + "order_status, shipping_address, payment_method, total_amount) "
//                    + "VALUES (NULL, ?, ?, GETDATE(), N'PENDING', ?, ?, ?)";
//            try (PreparedStatement ps = cn.prepareStatement(sqlOrder, Statement.RETURN_GENERATED_KEYS)) {
//                ps.setInt(1, customerId);
//                ps.setString(2, phone);
//                ps.setString(3, shippingAddress);
//                ps.setString(4, paymentMethod);
//                ps.setLong(5, total);
//                ps.executeUpdate();
//                try (ResultSet rs = ps.getGeneratedKeys()) {
//                    if (!rs.next()) {
//                        throw new SQLException("Không lấy được order_id.");
//                    }
//                    orderId = rs.getInt(1);
//                }
//            }
            // --- THAY thế toàn bộ block tạo Order cũ ---
            int orderId;

            // Chèn Order: account_id lấy trực tiếp từ Staff ACTIVE
            String sqlOrder
                    = "INSERT INTO [Order](account_id, customer_id, phone, order_date, "
                    + "                    order_status, shipping_address, payment_method, total_amount) "
                    + "SELECT (SELECT TOP 1 s.account_id\n"
                    + "   FROM Staff s\n"
                    + "  WHERE s.[status]=N'ACTIVE'\n"
                    + "  ORDER BY (SELECT COUNT(*) \n"
                    + "              FROM [Order] o\n"
                    + "             WHERE o.account_id = s.account_id\n"
                    + "               AND o.order_status IN (N'PENDING',N'CONFIRMED',N'SHIPPING')) ASC,\n"
                    + "           s.account_id ASC), "
                    + "       ?, ?, GETDATE(), N'PENDING', ?, ?, ?";

            try (PreparedStatement ps = cn.prepareStatement(sqlOrder, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, customerId);
                ps.setString(2, phone);
                ps.setString(3, shippingAddress);
                ps.setInt(4, paymentStatusBit);   // <-- BIT: 0 hoặc 1
                ps.setLong(5, total);
                ps.executeUpdate();
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (!rs.next()) {
                        throw new SQLException("Không lấy được order_id.");
                    }
                    orderId = rs.getInt(1);
                }
            }

            // 2) Insert OrderDetail
            String sqlDetail = "INSERT INTO OrderDetail(order_id, product_id, quantity, unit_price, total_price) "
                    + "VALUES (?,?,?,?,?)";
            try (PreparedStatement ps = cn.prepareStatement(sqlDetail)) {
                for (Cart it : byProduct.values()) {
                    ps.setInt(1, orderId);
                    ps.setInt(2, it.getProductId());
                    ps.setInt(3, it.getQuantity());
                    ps.setInt(4, it.getPrice());
                    ps.setLong(5, (long) it.getPrice() * it.getQuantity());
                    ps.addBatch();
                }
                ps.executeBatch();
            }

            // 3) Trừ kho có điều kiện
            List<Integer> failed = new ArrayList<>();
            String sqlStock = "UPDATE Product SET quantity_product = quantity_product - ? "
                    + "WHERE product_id=? AND quantity_product >= ?";
            try (PreparedStatement ps = cn.prepareStatement(sqlStock)) {
                for (Cart it : byProduct.values()) {
                    ps.setInt(1, it.getQuantity());
                    ps.setInt(2, it.getProductId());
                    ps.setInt(3, it.getQuantity());
                    int affected = ps.executeUpdate();
                    if (affected == 0) {
                        failed.add(it.getProductId());
                    }
                }
            }

            if (!failed.isEmpty()) {
                // Lấy tên để báo lỗi
                String names = getProductNames(cn, failed);
                cn.rollback();
                throw new SQLException("Không đủ hàng cho: " + names);
            }

            cn.commit();
            return orderId;
        }
    }

    private String getProductNames(Connection cn, List<Integer> ids) throws SQLException {
        if (ids.isEmpty()) {
            return "";
        }
        StringBuilder in = new StringBuilder();
        for (int i = 0; i < ids.size(); i++) {
            if (i > 0) {
                in.append(",");
            }
            in.append("?");
        }
        String sql = "SELECT product_name FROM Product WHERE product_id IN (" + in + ")";
        try (PreparedStatement ps = cn.prepareStatement(sql)) {
            for (int i = 0; i < ids.size(); i++) {
                ps.setInt(i + 1, ids.get(i));
            }
            List<String> names = new ArrayList<>();
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    names.add(rs.getNString(1));
                }
            }
            return String.join(", ", names);
        }
    }

    /**
     * Chọn 1 staff ACTIVE có số đơn đang xử lý ít nhất. Trạng thái đang xử lý:
     * PENDING, CONFIRMED, SHIPPING (tùy enum của bạn). Nếu chưa có staff ->
     * seed 'seed_admin' và dùng ID đó.
     */
    private int resolveDefaultAccountId(Connection cn) throws SQLException {
        // Ưu tiên staff ACTIVE có ít đơn đang làm nhất
        String pick
                = "SELECT TOP 1 s.account_id "
                + "FROM Staff s "
                + "WHERE s.[status] = N'ACTIVE' "
                + "ORDER BY ("
                + "   SELECT COUNT(*) FROM [Order] o "
                + "   WHERE o.account_id = s.account_id "
                + "     AND o.order_status IN (N'PENDING',N'CONFIRMED',N'SHIPPING')"
                + ") ASC, s.account_id ASC";

        try (PreparedStatement ps = cn.prepareStatement(pick); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }

        // Không có staff ACTIVE -> thử lấy bất kỳ staff nào
        try (PreparedStatement ps = cn.prepareStatement("SELECT TOP 1 account_id FROM Staff ORDER BY account_id"); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }

        // Không có staff nào -> seed 1 user mặc định
        String ins = "INSERT INTO Staff(user_name,[password],email,phone,role,[position],[address],[status]) "
                + "VALUES (?,?,?,?,?,?,?,?)";
        try (PreparedStatement ps = cn.prepareStatement(ins, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, "seed_admin");
            ps.setString(2, "seed@123");
            ps.setString(3, "admin@example.com");
            ps.setString(4, "0900000000");
            ps.setString(5, "ADMIN");
            ps.setString(6, "Product Owner");
            ps.setString(7, "-");
            ps.setString(8, "ACTIVE");
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        throw new SQLException("Không thể xác định account_id cho đơn hàng.");
    }

    public List<Order> getOrderByIdStaff(int accountId) {
        List<Order> listOrders = new ArrayList<>();
        String sql = "SELECT \n"
                + "	o.order_id,\n"
                + "	c.customer_name,\n"
                + "	o.phone,\n"
                + "	o.order_date,\n"
                + "	o.order_status,\n"
                + "	o.shipping_address,\n"
                + "	o.payment_method,\n"
                + "	o.total_amount\n"
                + "FROM [Order] o\n"
                + "JOIN Customer c ON c.customer_id = o.customer_id\n"
                + "Where o.account_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, accountId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int order_id = rs.getInt("order_id");
                    String customer_name = rs.getString("customer_name");
                    String phone = rs.getString("phone");
                    String order_date = rs.getString("order_date");
                    String order_status = rs.getString("order_status");
                    String shipping_address = rs.getString("shipping_address");
                    int payment_method = rs.getInt("payment_method");
                    BigDecimal total_amount = rs.getBigDecimal("total_amount");

                    listOrders.add(new Order(order_id, customer_name, phone, order_date, order_status, shipping_address, payment_method, total_amount));
                }
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return listOrders;
    }

    public Order getOrderByOrderId(int order_id) {
        Order order = new Order();
        String sql = "SELECT \n"
                + "	o.order_id,\n"
                + "	c.customer_name,\n"
                + "	o.phone,\n"
                + "	o.order_date,\n"
                + "	o.order_status,\n"
                + "	o.shipping_address,\n"
                + "	o.payment_method,\n"
                + "	o.total_amount\n"
                + "FROM [Order] o\n"
                + "JOIN Customer c ON c.customer_id = o.customer_id\n"
                + "Where o.order_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, order_id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    order.setOrder_id(order_id);
                    order.setCustomer_name(rs.getString("customer_name"));
                    order.setPhone(rs.getString("phone"));
                    order.setOrder_date(rs.getString("order_date"));
                    order.setOrder_status(rs.getString("order_status"));
                    order.setShipping_address(rs.getString("shipping_address"));
                    order.setPayment_method(rs.getInt("payment_method"));
                    order.setTotal_amount(rs.getBigDecimal("total_amount"));
                }
            }
        } catch (SQLException e) {
            System.err.println("getOrderInfo error: SQLState=" + e.getSQLState() + ", Code=" + e.getErrorCode());
            e.printStackTrace();
        }
        return order;
    }

    public List<OrderDetail> getOrderDetailByOrderId(int order_id) {
        List<OrderDetail> listOD = new ArrayList<>();
        String sql = "SELECT p.product_name\n"
                + ",[quantity]\n"
                + ",[unit_price]\n"
                + ",[total_price]\n"
                + ",p.[image]\n"
                + "  FROM [dbo].[OrderDetail] od\n"
                + "  JOIN [Product] p ON p.product_id = od.product_id\n"
                + "  Where [order_id] = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, order_id);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String product_name = rs.getString("product_name");
                    int quantity = rs.getInt("quantity");
                    BigDecimal unit_price = rs.getBigDecimal("unit_price");
                    BigDecimal total_price = rs.getBigDecimal("total_price");
                    String image = rs.getString("image");

                    listOD.add(new OrderDetail(product_name, quantity, unit_price, total_price, image));
                }
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return listOD;
    }

    /**
     * Lấy danh sách đơn theo 1..n trạng thái cho 1 customer. Ví dụ:
     * findOrdersByStatuses(5, "PENDING", "CONFIRMED") findOrdersByStatuses(5,
     * "SHIPPING") findOrdersByStatuses(5, "DELIVERED")
     */
    public List<Order> findOrdersByStatuses(int customerId, String... statuses) throws SQLException {
        if (statuses == null || statuses.length == 0) {
            statuses = new String[]{"PENDING", "CONFIRMED", "SHIPPING", "DELIVERED"};
        }

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT o.order_id, c.customer_name, o.phone, ")
                // chuyển datetime -> string theo model bạn
                .append("       CONVERT(varchar(19), o.order_date, 120) AS order_date, ")
                .append("       o.order_status, o.shipping_address, o.payment_method, o.total_amount ")
                .append("FROM [Order] o ")
                .append("JOIN Customer c ON c.customer_id = o.customer_id ")
                .append("WHERE o.customer_id = ? AND o.order_status IN (");
        for (int i = 0; i < statuses.length; i++) {
            sql.append("?");
            if (i < statuses.length - 1) {
                sql.append(",");
            }
        }
        sql.append(") ORDER BY o.order_date DESC, o.order_id DESC");

        try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            ps.setInt(1, customerId);
            for (int i = 0; i < statuses.length; i++) {
                ps.setString(2 + i, statuses[i]);
            }

            List<Order> list = new ArrayList<>();
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order o = new Order();
                    o.setOrder_id(rs.getInt("order_id"));
                    o.setCustomer_name(rs.getString("customer_name"));
                    o.setPhone(rs.getString("phone"));
                    o.setOrder_date(rs.getString("order_date"));
                    o.setOrder_status(rs.getString("order_status"));
                    o.setShipping_address(rs.getString("shipping_address"));
                    // bit -> int 0/1 theo model hiện tại của bạn
                    o.setPayment_method(rs.getBoolean("payment_method") ? 1 : 0);
                    o.setTotal_amount(rs.getBigDecimal("total_amount"));
                    list.add(o);
                }
            }
            return list;
        }
    }

    // ====== Hàm tiện ích (tuỳ dùng) ======
    public List<Order> findPlacedOrders(int customerId) throws SQLException {
        return findOrdersByStatuses(customerId, "PENDING", "CONFIRMED");
    }

    public List<Order> findShippingOrders(int customerId) throws SQLException {
        return findOrdersByStatuses(customerId, "SHIPPING");
    }

    public List<Order> findDeliveredOrders(int customerId) throws SQLException {
        return findOrdersByStatuses(customerId, "DELIVERED");
    }

    /**
     * Lấy chi tiết sản phẩm của 1 đơn (phục vụ accordion ở trang /orders)
     */
    public List<OrderDetail> findOrderDetails(int orderId) throws SQLException {
        String sql
                = "SELECT p.product_name, d.quantity, "
                + "       CAST(d.unit_price AS DECIMAL(12,2)) AS unit_price, "
                + "       CAST(d.total_price AS DECIMAL(12,2)) AS total_price, "
                + "       p.image "
                + "FROM [OrderDetail] d "
                + "JOIN Product p ON p.product_id = d.product_id "
                + "WHERE d.order_id = ? "
                + "ORDER BY d.product_id";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            List<OrderDetail> list = new ArrayList<>();
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderDetail it = new OrderDetail();
                    it.setProduct_name(rs.getString("product_name"));
                    it.setQuantity(rs.getInt("quantity"));
                    it.setUnit_price(rs.getBigDecimal("unit_price"));
                    it.setTotal_price(rs.getBigDecimal("total_price"));
                    it.setImage(rs.getString("image"));
                    list.add(it);
                }
            }
            return list;
        }
    }
}
