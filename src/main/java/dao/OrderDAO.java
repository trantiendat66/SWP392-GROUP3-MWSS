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
import model.OrderItemRow;

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

            //Lấy staffId đã loại trừ admin=1 + có fallback
            int staffId = resolveDefaultAccountId(cn);

            int orderId;

            // Dùng VALUES + param thay vì subquery
            String sqlOrder
                    = "INSERT INTO [Order](account_id, customer_id, phone, order_date, "
                    + "                    order_status, shipping_address, payment_method, total_amount) "
                    + "VALUES (?, ?, ?, GETDATE(), N'PENDING', ?, ?, ?)";

            try (PreparedStatement ps = cn.prepareStatement(sqlOrder, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, staffId);
                ps.setInt(2, customerId);
                ps.setString(3, phone);
                ps.setString(4, shippingAddress);
                ps.setInt(5, paymentStatusBit);  // BIT 0/1
                ps.setLong(6, total);
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
            String sqlStock = "UPDATE Product SET quantity = quantity - ? "
                    + "WHERE product_id=? AND quantity >= ?";
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
     * Chọn 1 staff ACTIVE có số đơn đang xử lý ít nhất, NHƯNG loại trừ
     * account_id = 1 (admin). Nếu không có staff nào khác 1: - Thử lấy bất kỳ
     * staff nào khác 1. - Nếu vẫn không có, seed 1 nhân viên mặc định (không
     * phải admin) và dùng ID đó.
     */
    private int resolveDefaultAccountId(Connection cn) throws SQLException {
        // 1) Ưu tiên staff ACTIVE (≠1) có ít đơn PENDING/CONFIRMED/SHIPPING nhất
        final String pickActiveNotAdmin
                = "SELECT TOP 1 s.account_id "
                + "FROM Staff s "
                + "WHERE s.[status] = N'ACTIVE' AND s.account_id <> 1 "
                + "ORDER BY ("
                + "   SELECT COUNT(*) FROM [Order] o "
                + "   WHERE o.account_id = s.account_id "
                + "     AND o.order_status IN (N'PENDING',N'CONFIRMED',N'SHIPPING')"
                + ") ASC, s.account_id ASC";

        try (PreparedStatement ps = cn.prepareStatement(pickActiveNotAdmin); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }

        // 2) Không có ACTIVE (≠1) -> lấy bất kỳ staff nào khác 1
        final String pickAnyNotAdmin
                = "SELECT TOP 1 account_id FROM Staff WHERE account_id <> 1 ORDER BY account_id";
        try (PreparedStatement ps = cn.prepareStatement(pickAnyNotAdmin); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }

        // 3) Không có staff nào khác 1 -> seed một staff mặc định (không phải admin) và dùng ID đó
        final String seedOperator
                = "INSERT INTO Staff(user_name,[password],email,phone,role,[position],[address],[status]) "
                + "VALUES (?,?,?,?,?,?,?,?)";
        try (PreparedStatement ps = cn.prepareStatement(seedOperator, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, "seed_operator");
            ps.setString(2, "seed@123");                 // nhớ hash nếu hệ thống đang hash password
            ps.setString(3, "operator@example.com");
            ps.setString(4, "0900000000");
            ps.setString(5, "STAFF");                    // không phải ADMIN
            ps.setString(6, "Operator");
            ps.setString(7, "-");
            ps.setString(8, "ACTIVE");
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);                 // ID mới (≠1 nếu bảng trống trước đó)
                }
            }
        }

        throw new SQLException("Không thể xác định account_id (đã loại trừ admin=1).");
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
                + ",od.[quantity]\n"
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

    public boolean updateOrderStatus(int order_id, String order_status) {

        boolean success = false;
        String sql;
        if (order_status.equals("DELIVERED")) {
            sql = "UPDATE [Order] SET order_status = ?, delivered_at = GETDATE() WHERE order_id = ?";
        } else {
            sql = "UPDATE [Order] SET order_status = ?, delivered_at = NULL WHERE order_id = ?";
        }
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, order_status);
            ps.setInt(2, order_id);
            success = ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return success;
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
        sql.append("SELECT ")
                .append("  o.order_id, ")
                .append("  c.customer_name, ")
                .append("  o.phone, ")
                .append("  CONVERT(varchar(19), o.order_date, 120) AS order_date, ")
                .append("  o.order_status, ")
                .append("  o.shipping_address, ")
                .append("  o.payment_method, ")
                .append("  o.total_amount, ")
                .append("  o.delivered_at ")
                .append("FROM [Order] o ")
                .append("JOIN Customer c ON c.customer_id = o.customer_id ")
                .append("WHERE o.customer_id = ? AND o.order_status IN (");

        for (int i = 0; i < statuses.length; i++) {
            sql.append("?");
            if (i < statuses.length - 1) {
                sql.append(",");
            }
        }
        sql.append(") ");

        // Sắp xếp: nếu đã giao thì theo delivered_at, ngược lại theo order_date
        sql.append("ORDER BY ")
                .append("  CASE WHEN o.order_status = 'DELIVERED' AND o.delivered_at IS NOT NULL ")
                .append("       THEN o.delivered_at ELSE o.order_date END DESC, ")
                .append("  o.order_id DESC");

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
                    o.setPayment_method(rs.getBoolean("payment_method") ? 1 : 0);
                    o.setTotal_amount(rs.getBigDecimal("total_amount"));

                    // >>> NEW: gán delivered_at nếu có
                    java.sql.Timestamp ts = rs.getTimestamp("delivered_at");
                    if (ts != null) {
                        o.setDelivered_at(new java.util.Date(ts.getTime()));
                    }

                    list.add(o);
                }
            }
            return list;
        }
    }

//    // ====== Hàm tiện ích (tuỳ dùng) ======
//    public List<Order> findPlacedOrders(int customerId) throws SQLException {
//        return findOrdersByStatuses(customerId, "PENDING", "CONFIRMED");
//    }
//
//    public List<Order> findShippingOrders(int customerId) throws SQLException {
//        return findOrdersByStatuses(customerId, "SHIPPING");
//    }
//
//    public List<Order> findDeliveredOrders(int customerId) throws SQLException {
//        return findOrdersByStatuses(customerId, "DELIVERED");
//    }
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

    /**
     * Lấy map<orderId, List<OrderItemRow>> cho danh sách orderIds.
     */
    public Map<Integer, List<OrderItemRow>> findItemsWithPidByOrderIds(List<Integer> orderIds) throws SQLException {
        Map<Integer, List<OrderItemRow>> map = new HashMap<>();
        if (orderIds == null || orderIds.isEmpty()) {
            return map;
        }

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT od.order_id, od.product_id, p.product_name, p.image, ")
                .append("       od.quantity, od.unit_price, (od.quantity * od.unit_price) AS total_price ")
                .append("FROM OrderDetail od ")
                .append("JOIN Product p ON p.product_id = od.product_id ")
                .append("WHERE od.order_id IN (");
        for (int i = 0; i < orderIds.size(); i++) {
            if (i > 0) {
                sql.append(',');
            }
            sql.append('?');
        }
        sql.append(')');

        try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < orderIds.size(); i++) {
                ps.setInt(i + 1, orderIds.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int orderId = rs.getInt("order_id");
                    OrderItemRow row = new OrderItemRow(
                            orderId,
                            rs.getInt("product_id"),
                            rs.getString("product_name"),
                            rs.getString("image"),
                            rs.getInt("quantity"),
                            rs.getBigDecimal("unit_price"),
                            rs.getBigDecimal("total_price")
                    );
                    map.computeIfAbsent(orderId, k -> new ArrayList<>()).add(row);
                }
            }
        }
        return map;
    }

    /**
     * Trả về set "orderId:productId" đủ điều kiện đánh giá: -
     * Order.order_status = 'DELIVERED' - delivered_at NOT NULL và delivered_at
     * >= GETDATE()-3 - Chưa có feedback của customer cho product đó kể từ
     * delivered_at
     */
    public Set<String> findEligibleFeedbackKeys(int customerId, List<Integer> orderIds) throws SQLException {
        Set<String> keys = new HashSet<>();
        if (orderIds == null || orderIds.isEmpty()) {
            return keys;
        }

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT od.order_id, od.product_id ")
                .append("FROM [Order] o ")
                .append("JOIN OrderDetail od ON od.order_id = o.order_id ")
                .append("WHERE o.order_id IN (");
        for (int i = 0; i < orderIds.size(); i++) {
            if (i > 0) {
                sql.append(',');
            }
            sql.append('?');
        }
        sql.append(") AND o.order_status = 'DELIVERED' ")
                .append("AND o.delivered_at IS NOT NULL ")
                .append("AND o.delivered_at >= DATEADD(DAY, -3, GETDATE()) ")
                .append("AND NOT EXISTS ( ")
                .append("  SELECT 1 FROM Feedback f ")
                .append("  WHERE f.customer_id = ? ")
                .append("    AND f.product_id = od.product_id ")
                .append("    AND f.create_at >= o.delivered_at ")
                .append(")");

        try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int idx = 1;
            for (Integer id : orderIds) {
                ps.setInt(idx++, id);
            }
            ps.setInt(idx, customerId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String key = rs.getInt("order_id") + ":" + rs.getInt("product_id");
                    keys.add(key);
                }
            }
        }
        return keys;
    }

    /*
    Đơn thuộc về khách đang đăng nhập

    Đơn có trạng thái DELIVERED

    Trong đơn có product_id đó (tồn tại trong OrderDetail)

    delivered_at không null và trong 3 ngày (tính tới hiện tại)
     */
    public boolean canReview(int customerId, int orderId, int productId) throws SQLException {
        String sql
                = "SELECT 1 "
                + "FROM [Order] o "
                + "JOIN OrderDetail od ON od.order_id = o.order_id "
                + "WHERE o.order_id = ? AND o.customer_id = ? AND od.product_id = ? "
                + "  AND o.order_status = 'DELIVERED' "
                + "  AND o.delivered_at IS NOT NULL "
                + "  AND DATEDIFF(DAY, o.delivered_at, GETDATE()) BETWEEN 0 AND 3";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ps.setInt(2, customerId);
            ps.setInt(3, productId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }
}
