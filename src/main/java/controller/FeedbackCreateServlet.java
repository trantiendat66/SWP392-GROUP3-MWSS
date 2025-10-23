/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import dao.FeedbackDAO;
import dao.OrderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import model.Customer;

/**
 *
 * @author Oanh Nguyen
 */
@WebServlet(name = "FeedbackCreateServlet", urlPatterns = {"/feedback/create"})
public class FeedbackCreateServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("customer") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?next=orders?tab=delivered");
            return;
        }
        Customer cus = (Customer) session.getAttribute("customer");

        // Lấy tham số từ form
        int orderId, productId, rating;
        String comment = req.getParameter("comment");
        try {
            orderId = Integer.parseInt(req.getParameter("order_id"));
            productId = Integer.parseInt(req.getParameter("product_id"));
            rating = Integer.parseInt(req.getParameter("rating"));
        } catch (Exception ex) {
            session.setAttribute("error", "Dữ liệu không hợp lệ.");
            resp.sendRedirect(req.getContextPath() + "/orders?tab=delivered");
            return;
        }
        if (rating < 1 || rating > 5) {
            session.setAttribute("error", "Điểm đánh giá không hợp lệ.");
            resp.sendRedirect(req.getContextPath() + "/orders?tab=delivered");
            return;
        }
        if (rating < 5) {
            if (comment == null || comment.trim().isEmpty()) {
                session.setAttribute("error", "Vui lòng nhập lý do khi đánh giá dưới 5★.");
                resp.sendRedirect(req.getContextPath() + "/orders?tab=delivered");
                return;
            }
        }
        if (comment == null) {
            comment = "";
        }
        comment = comment.trim();

        OrderDAO orderDAO = new OrderDAO();
        FeedbackDAO fbDAO = new FeedbackDAO();

        try {
            // 1) Kiểm tra điều kiện được phép đánh giá
            boolean allowed = orderDAO.canReview(cus.getCustomer_id(), orderId, productId);
            if (!allowed) {
                session.setAttribute("error",
                        "Đơn hàng không đủ điều kiện để đánh giá (không thuộc bạn, chưa giao, hoặc đã quá 3 ngày).");
                resp.sendRedirect(req.getContextPath() + "/orders?tab=delivered");
                return;
            }

            // 2) Không cho đánh giá trùng
            if (fbDAO.hasFeedback(cus.getCustomer_id(), orderId, productId)) {
                session.setAttribute("error", "Bạn đã đánh giá sản phẩm này cho đơn hàng này rồi.");
                resp.sendRedirect(req.getContextPath() + "/orders?tab=delivered");
                return;
            }

            // 3) Lưu feedback
            fbDAO.createFeedback(cus.getCustomer_id(), orderId, productId, rating, comment);

            session.setAttribute("flash_success", "Cảm ơn bạn! Đánh giá đã được ghi nhận.");
            // quay về tab ĐÃ GIAO
            resp.sendRedirect(req.getContextPath() + "/orders?tab=delivered");

        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("error", "Có lỗi khi lưu đánh giá: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/orders?tab=delivered");
        }
    }
}
