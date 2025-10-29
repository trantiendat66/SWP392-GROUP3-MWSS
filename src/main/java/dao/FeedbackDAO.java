/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import db.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.FeedbackInfo;
import model.FeedbackView;

/**
 *
 * @author Oanh Nguyen
 */
public class FeedbackDAO extends DBContext {

    public FeedbackDAO() {
        super();
    }

    /**
     * Kiểm tra đã đánh giá chưa (1 khách, 1 đơn, 1 sản phẩm)
     */
    public boolean hasFeedback(int customerId, int orderId, int productId) throws SQLException {
        String sql = "SELECT 1 FROM Feedback WHERE customer_id = ? AND order_id = ? AND product_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ps.setInt(2, orderId);
            ps.setInt(3, productId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    /**
     * Tạo feedback mới
     */
    /**
     * Lưu feedback: - Lấy account_id từ Order (theo order_id) để chèn vào
     * Feedback - Chỉ cho phép nếu đơn thuộc về customer, đã DELIVERED, còn
     * trong 3 ngày - Chặn trùng: nếu khách đã đánh giá sản phẩm này rồi thì
     * không chèn nữa (phiên bản không có order_id trong Feedback) Trả về true
     * nếu chèn thành công.
     */
    public boolean createFeedback(int customerId, int orderId, int productId, int rating, String comment)
            throws SQLException {

        String sql
                = "INSERT INTO Feedback (order_id,account_id, customer_id, product_id, rating, comment, create_at) \n"
                + "SELECT o.order_id, o.account_id, ?, ?, ?, ?, GETDATE()\n"
                + "FROM [Order] o\n"
                + "WHERE o.order_id = ?\n"
                + "  AND o.customer_id = ?\n"
                + "  AND o.order_status = 'DELIVERED'\n"
                + "  AND o.delivered_at IS NOT NULL\n"
                + "  AND DATEDIFF(DAY, o.delivered_at, GETDATE()) <= 3\n"
                + // chặn trùng nếu khách đã từng review sản phẩm này
                "  AND NOT EXISTS (\n"
                + "        SELECT 1 FROM Feedback f\n"
                + "        WHERE f.customer_id = ? AND f.product_id = ?\n"
                + "  )";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            int i = 1;
            ps.setInt(i++, customerId);
            ps.setInt(i++, productId);
            ps.setInt(i++, rating);
            ps.setString(i++, comment);
            ps.setInt(i++, orderId);
            ps.setInt(i++, customerId);
            ps.setInt(i++, customerId);
            ps.setInt(i++, productId);

            int rows = ps.executeUpdate();
            return rows > 0;
        }
    }

    // (Tuỳ chọn) Lấy danh sách feedback theo product để show ở product detail
    public List<FeedbackView> listByProduct(int productId) throws SQLException {
        String sql = "SELECT f.rating, f.comment, f.create_at, c.customer_name "
                + "FROM Feedback f JOIN Customer c ON c.customer_id = f.customer_id "
                + "WHERE f.product_id = ? ORDER BY f.create_at DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                List<FeedbackView> list = new ArrayList<>();
                while (rs.next()) {
                    FeedbackView v = new FeedbackView(
                            rs.getInt("rating"),
                            rs.getString("comment"),
                            rs.getTimestamp("create_at"),
                            rs.getString("customer_name")
                    );
                    list.add(v);
                }
                return list;
            }
        }
    }

    /**
     * Sản phẩm nào của customer đã đánh giá? -> Map<productId, true>
     */
    public Map<Integer, Boolean> findReviewedProductIds(int customerId,
            Collection<Integer> productIds)
            throws SQLException {
        Map<Integer, Boolean> map = new HashMap<>();
        if (productIds == null || productIds.isEmpty()) {
            return map;
        }

        StringBuilder in = new StringBuilder();
        int n = productIds.size();
        for (int i = 0; i < n; i++) {
            if (i > 0) {
                in.append(",");
            }
            in.append("?");
        }

        String sql = "SELECT DISTINCT product_id FROM Feedback "
                + "WHERE customer_id = ? AND product_id IN (" + in + ")";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            int idx = 1;
            ps.setInt(idx++, customerId);
            for (Integer pid : productIds) {
                ps.setInt(idx++, pid);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    map.put(rs.getInt(1), Boolean.TRUE);
                }
            }
        }
        return map;
    }

    /**
     * Lấy danh sách review của 1 sản phẩm để render product detail
     */
    public List<FeedbackView> getFeedbackByProduct(int productId) throws SQLException {
        String sql = """
            SELECT c.customer_name,
                   f.rating,
                   f.comment,
                   f.create_at
            FROM Feedback f
            JOIN Customer c ON c.customer_id = f.customer_id
            WHERE f.product_id = ?
            ORDER BY f.create_at DESC
        """;

        List<FeedbackView> list = new ArrayList<>();
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    FeedbackView v = new FeedbackView();
                    v.setCustomerName(rs.getString("customer_name"));
                    v.setRating(rs.getInt("rating"));
                    v.setComment(rs.getString("comment"));
                    Timestamp ts = rs.getTimestamp("create_at");
                    v.setCreateAt(ts != null ? new java.util.Date(ts.getTime()) : null);
                    list.add(v);
                }
            }
        }
        return list;
    }

    /**
     * Đếm số lượng đánh giá của sản phẩm
     */
    public int getRatingCount(int productId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Feedback WHERE product_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    /**
     * Điểm trung bình của sản phẩm
     */
    public double getAverageRating(int productId) throws SQLException {
        String sql = "SELECT AVG(CAST(rating AS float)) FROM Feedback WHERE product_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                double avg = rs.next() ? rs.getDouble(1) : 0.0;
                return Double.isNaN(avg) ? 0.0 : avg;
            }
        }
    }

    // Đếm phân bố sao cho 1 sản phẩm
    public int[] getStarDistribution(int productId) throws SQLException {
        String sql = """
        SELECT
           SUM(CASE WHEN rating = 5 THEN 1 ELSE 0 END) AS s5,
           SUM(CASE WHEN rating = 4 THEN 1 ELSE 0 END) AS s4,
           SUM(CASE WHEN rating = 3 THEN 1 ELSE 0 END) AS s3,
           SUM(CASE WHEN rating = 2 THEN 1 ELSE 0 END) AS s2,
           SUM(CASE WHEN rating = 1 THEN 1 ELSE 0 END) AS s1,
           COUNT(*) AS total
        FROM Feedback
        WHERE product_id = ?
    """;
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                int[] dist = new int[6]; // [0]=total, [1]=s1..[5]=s5
                if (rs.next()) {
                    dist[5] = rs.getInt("s5");
                    dist[4] = rs.getInt("s4");
                    dist[3] = rs.getInt("s3");
                    dist[2] = rs.getInt("s2");
                    dist[1] = rs.getInt("s1");
                    dist[0] = rs.getInt("total");
                }
                return dist;
            }
        }
    }
    public List<FeedbackView> getFeedbackByStaffId(int account_id) {
        List<FeedbackView> list = new ArrayList<>();
        String sql = "SELECT f.feedback_id, c.customer_name, p.product_name, f.rating, f.comment, f.create_at\n"
                + "FROM Feedback f\n"
                + "JOIN Customer c ON c.customer_id = f.customer_id\n"
                + "JOIN [Product] p ON p.product_id = f.product_id\n"
                + "Where f.account_id = ?"
                + "ORDER BY f.create_at DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql);) {
            ps.setInt(1, account_id);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String customerName = rs.getString("customer_name");
                    String productName = rs.getString("product_name");
                    int rating = rs.getInt("rating");
                    String feedback = rs.getString("comment");
                    Timestamp date = rs.getTimestamp("create_at");
                    int feedbackId = rs.getInt("feedback_id");
                    list.add(new FeedbackView(rating, feedback, date, customerName, productName, feedbackId));
                }
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return list;
    }

    public FeedbackInfo getFeedbackByFeedbackId(int feedback_id) {
        FeedbackInfo fi = new FeedbackInfo();
        String sql = "SELECT f.account_id, c.customer_id, p.image, p.product_name, f.order_id, c.customer_name, f.rating, f.create_at, f.comment\n"
                + "FROM Feedback f\n"
                + "JOIN Customer c ON c.customer_id = f.customer_id\n"
                + "JOIN [Product] p ON p.product_id = f.product_id\n"
                + "WHERE f.feedback_id = ?;";
        try (PreparedStatement ps = conn.prepareStatement(sql);) {
            ps.setInt(1, feedback_id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    fi.setFeedbackId(feedback_id);
                    fi.setAccountId(rs.getInt("account_id"));
                    fi.setCustomerId(rs.getInt("customer_id"));
                    fi.setImage(rs.getString("image"));
                    fi.setProductName(rs.getString("product_name"));
                    fi.setOrderId(rs.getInt("order_id"));
                    fi.setCustomerName("customer_name");
                    fi.setRating(rs.getInt("rating"));
                    fi.setCreateAt(rs.getTimestamp("create_at"));
                    fi.setComment(rs.getString("comment"));
                }
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return fi;
    }   

}
