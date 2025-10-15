/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import db.DBContext;
import model.Cart;

import java.sql.*;
import java.util.*;

/**
 *
 * @author Oanh Nguyen
 */
public class OrderDAO {

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

}
