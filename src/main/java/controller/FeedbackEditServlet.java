/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import dao.FeedbackDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.Map;
import model.Customer;

/**
 *
 * @author Oanh Nguyen
 */
@WebServlet(name = "FeedbackEditServlet", urlPatterns = {"/feedback/edit"})
public class FeedbackEditServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("customer") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?next=orders?tab=delivered");
            return;
        }
        Customer cus = (Customer) session.getAttribute("customer");

        int feedbackId;
        try {
            feedbackId = Integer.parseInt(req.getParameter("id"));
        } catch (Exception e) {
            session.setAttribute("error", "Invalid feedback ID.");
            resp.sendRedirect(req.getContextPath() + "/orders?tab=delivered");
            return;
        }

        FeedbackDAO fbDAO = new FeedbackDAO();
        try {
            // Kiểm tra quyền sở hữu và thời gian
            if (!fbDAO.canEditOrDeleteFeedback(feedbackId, cus.getCustomer_id())) {
                session.setAttribute("error", "You cannot edit this feedback (not yours or more than 3 days old).");
                resp.sendRedirect(req.getContextPath() + "/orders?tab=delivered");
                return;
            }

            // Lấy thông tin feedback
            Map<String, Object> feedback = fbDAO.getFeedbackForEdit(feedbackId, cus.getCustomer_id());
            if (feedback == null) {
                session.setAttribute("error", "Feedback not found.");
                resp.sendRedirect(req.getContextPath() + "/orders?tab=delivered");
                return;
            }

            // Đưa thông tin vào request để hiển thị form
            req.setAttribute("feedback", feedback);
            req.getRequestDispatcher("/edit_feedback.jsp").forward(req, resp);

        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("error", "An error occurred: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/orders?tab=delivered");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("customer") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?next=orders?tab=delivered");
            return;
        }
        Customer cus = (Customer) session.getAttribute("customer");

        int feedbackId, rating;
        String comment;
        try {
            feedbackId = Integer.parseInt(req.getParameter("feedback_id"));
            rating = Integer.parseInt(req.getParameter("rating"));
            comment = req.getParameter("comment");
        } catch (Exception e) {
            session.setAttribute("error", "Invalid data.");
            resp.sendRedirect(req.getContextPath() + "/orders?tab=delivered");
            return;
        }

        // Validate rating
        if (rating < 1 || rating > 5) {
            session.setAttribute("error", "Invalid rating score.");
            resp.sendRedirect(req.getContextPath() + "/orders?tab=delivered");
            return;
        }

        // Validate comment if rating < 5
        if (rating < 5) {
            if (comment == null || comment.trim().isEmpty()) {
                session.setAttribute("error", "Please provide a reason when rating below 5★.");
                resp.sendRedirect(req.getContextPath() + "/feedback/edit?id=" + feedbackId);
                return;
            }
        }

        if (comment == null) {
            comment = "";
        }
        comment = comment.trim();

        FeedbackDAO fbDAO = new FeedbackDAO();
        try {
            // Kiểm tra quyền và thời gian
            if (!fbDAO.canEditOrDeleteFeedback(feedbackId, cus.getCustomer_id())) {
                session.setAttribute("error", "You cannot edit this feedback (not yours or more than 3 days old).");
                resp.sendRedirect(req.getContextPath() + "/orders?tab=delivered");
                return;
            }

            // Cập nhật feedback
            boolean success = fbDAO.updateFeedback(feedbackId, cus.getCustomer_id(), rating, comment);
            if (success) {
                session.setAttribute("flash_success", "Your feedback has been updated successfully.");
            } else {
                session.setAttribute("error", "Failed to update feedback.");
            }

            resp.sendRedirect(req.getContextPath() + "/orders?tab=delivered");

        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("error", "An error occurred: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/orders?tab=delivered");
        }
    }
}
