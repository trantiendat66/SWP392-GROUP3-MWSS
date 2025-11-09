/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import db.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.FeedbackInfo;
import model.FeedbackView;
import model.Reply;

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
        String sql = "SELECT f.feedback_id, f.rating, f.comment, f.create_at, c.customer_name, f.hidden "
                + "FROM Feedback f JOIN Customer c ON c.customer_id = f.customer_id "
                + "WHERE f.product_id = ? ORDER BY f.create_at DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                List<FeedbackView> list = new ArrayList<>();
                while (rs.next()) {
                    FeedbackView v = new FeedbackView(
                            rs.getInt("feedback_id"),
                            rs.getInt("rating"),
                            rs.getString("comment"),
                            rs.getTimestamp("create_at"),
                            rs.getString("customer_name"),
                            rs.getBoolean("hidden")
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
            SELECT f.feedback_id,
                   c.customer_name,
                   f.rating,
                   f.comment,
                   f.create_at,
                   f.hidden
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
                    v.setFeedbackId(rs.getInt("feedback_id"));
                    v.setCustomerName(rs.getString("customer_name"));
                    v.setRating(rs.getInt("rating"));
                    v.setComment(rs.getString("comment"));
                    Timestamp ts = rs.getTimestamp("create_at");
                    v.setCreateAt(ts != null ? new java.util.Date(ts.getTime()) : null);
                    v.setHidden(rs.getBoolean("hidden"));
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
//<<<<<<< Upstream, based on origin/master

    /**
     * Lấy thông tin feedback để edit (kiểm tra quyền sở hữu) Trả về Map với
     * key: feedback_id, customer_id, order_id, product_id, rating, comment,
     * create_at
     */
    public Map<String, Object> getFeedbackForEdit(int feedbackId, int customerId) throws SQLException {
        String sql = "SELECT f.feedback_id, f.customer_id, f.order_id, f.product_id, "
                + "f.rating, f.comment, f.create_at, o.delivered_at "
                + "FROM Feedback f "
                + "JOIN [Order] o ON o.order_id = f.order_id "
                + "WHERE f.feedback_id = ? AND f.customer_id = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, feedbackId);
            ps.setInt(2, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("feedback_id", rs.getInt("feedback_id"));
                    map.put("customer_id", rs.getInt("customer_id"));
                    map.put("order_id", rs.getInt("order_id"));
                    map.put("product_id", rs.getInt("product_id"));
                    map.put("rating", rs.getInt("rating"));
                    map.put("comment", rs.getString("comment"));
                    map.put("create_at", rs.getTimestamp("create_at"));
                    map.put("delivered_at", rs.getTimestamp("delivered_at"));
                    return map;
                }
            }
        }
        return null;
    }

    /**
     * Cập nhật feedback (chỉ rating và comment)
     */
    public boolean updateFeedback(int feedbackId, int customerId, int rating, String comment) throws SQLException {
        String sql = "UPDATE Feedback SET rating = ?, comment = ? "
                + "WHERE feedback_id = ? AND customer_id = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, rating);
            ps.setString(2, comment);
            ps.setInt(3, feedbackId);
            ps.setInt(4, customerId);

            int rows = ps.executeUpdate();
            return rows > 0;
        }
    }

    /**
     * Xóa feedback
     */
    public boolean deleteFeedback(int feedbackId, int customerId) throws SQLException {
        String sql = "DELETE FROM Feedback WHERE feedback_id = ? AND customer_id = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, feedbackId);
            ps.setInt(2, customerId);

            int rows = ps.executeUpdate();
            return rows > 0;
        }
    }

    /**
     * Kiểm tra có thể edit/delete feedback không (trong vòng 3 ngày từ
     * delivered_at)
     */
    public boolean canEditOrDeleteFeedback(int feedbackId, int customerId) throws SQLException {
        String sql = "SELECT 1 FROM Feedback f "
                + "JOIN [Order] o ON o.order_id = f.order_id "
                + "WHERE f.feedback_id = ? AND f.customer_id = ? "
                + "  AND o.order_status = 'DELIVERED' "
                + "  AND o.delivered_at IS NOT NULL "
                + "  AND DATEDIFF(DAY, o.delivered_at, GETDATE()) BETWEEN 0 AND 3";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, feedbackId);
            ps.setInt(2, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    /**
     * Lấy thông tin feedback theo customer và danh sách orderIds Trả về Map:
     * key = "orderId:productId", value = Map{feedback_id, rating, comment,
     * canEdit}
     */
    public Map<String, Map<String, Object>> getFeedbackByCustomerAndOrders(
            int customerId, Collection<Integer> orderIds) throws SQLException {

        Map<String, Map<String, Object>> result = new HashMap<>();
        if (orderIds == null || orderIds.isEmpty()) {
            return result;
        }

        StringBuilder in = new StringBuilder();
        int n = orderIds.size();
        for (int i = 0; i < n; i++) {
            if (i > 0) {
                in.append(",");
            }
            in.append("?");
        }

        String sql = "SELECT f.feedback_id, f.order_id, f.product_id, f.rating, f.comment, "
                + "o.delivered_at, "
                + "CASE WHEN DATEDIFF(DAY, o.delivered_at, GETDATE()) BETWEEN 0 AND 3 "
                + "     THEN 1 ELSE 0 END AS can_edit "
                + "FROM Feedback f "
                + "JOIN [Order] o ON o.order_id = f.order_id "
                + "WHERE f.customer_id = ? AND f.order_id IN (" + in + ")";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            int idx = 1;
            ps.setInt(idx++, customerId);
            for (Integer oid : orderIds) {
                ps.setInt(idx++, oid);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int orderId = rs.getInt("order_id");
                    int productId = rs.getInt("product_id");
                    String key = orderId + ":" + productId;

                    Map<String, Object> fbInfo = new HashMap<>();
                    fbInfo.put("feedback_id", rs.getInt("feedback_id"));
                    fbInfo.put("rating", rs.getInt("rating"));
                    fbInfo.put("comment", rs.getString("comment"));
                    fbInfo.put("can_edit", rs.getInt("can_edit") == 1);

                    result.put(key, fbInfo);
                }
            }
        }
        return result;
    }

    public boolean createReply(int feedbackId, String reply) {
        boolean success = false;
        String sql = "INSERT INTO Reply(feedback_id, account_id, customer_id, content_reply)\n"
                + "SELECT f.feedback_id, f.account_id, f.customer_id, ? \n"
                + "FROM Feedback f\n"
                + "WHERE feedback_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, reply);
            ps.setInt(2, feedbackId);
            success = ps.executeUpdate() > 0;
        } catch (SQLException s) {
            System.out.println(s.getMessage());
        }
        return success;
    }

    public Reply getReplyById(int feedbackId) {
        Reply re = new Reply();
        String sql = "SELECT TOP 1 *\n"
                + "FROM Reply r\n"
                + "WHERE r.feedback_id = ? "
                + "ORDER BY rep_id DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql);) {
            ps.setInt(1, feedbackId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    re.setFeedbackId(feedbackId);
                    re.setRepId(rs.getInt("rep_id"));
                    re.setAccountId(rs.getInt("account_id"));
                    re.setCustomerId(rs.getInt("customer_id"));
                    re.setContentReply(rs.getString("content_reply"));
                }
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return re;
    }

    public List<Reply> getReplyByProductId(int productId) throws SQLException {
        String sql = """
           SELECT r.*
            FROM Reply r
            JOIN Feedback f ON f.feedback_id = r.feedback_id
            Where f.product_id = ?
            ORDER BY rep_id DESC
        """;

        List<Reply> list = new ArrayList<>();
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Reply r = new Reply();
                    r.setRepId(rs.getInt("rep_id"));
                    r.setFeedbackId(rs.getInt("feedback_id"));
                    r.setAccountId(rs.getInt("account_id"));
                    r.setCustomerId(rs.getInt("customer_id"));
                    r.setContentReply(rs.getString("content_reply"));
                    list.add(r);
                }
            }
        }
        return list;
    }

    public boolean hideFeedback(int feedbackId) {
        String sql = "UPDATE Feedback SET hidden = CASE WHEN hidden = 1 THEN 0 ELSE 1 END WHERE feedback_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, feedbackId);
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return false;
    }

    public List<FeedbackView> getAllFeedback() {
        List<FeedbackView> list = new ArrayList<>();
        String sql = "SELECT f.feedback_id, c.customer_name, p.product_name, f.rating, f.comment, f.create_at\n"
                + "FROM Feedback f\n"
                + "JOIN Customer c ON c.customer_id = f.customer_id\n"
                + "JOIN [Product] p ON p.product_id = f.product_id\n"
                + "ORDER BY f.create_at DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql);) {
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
}
