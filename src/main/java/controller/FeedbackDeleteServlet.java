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
import model.Customer;

/**
 *
 * @author Oanh Nguyen
 */
@WebServlet(name = "FeedbackDeleteServlet", urlPatterns = {"/feedback/delete"})
public class FeedbackDeleteServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("customer") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?next=orders?tab=delivered");
            return;
        }
        Customer cus = (Customer) session.getAttribute("customer");

        int feedbackId;
        try {
            feedbackId = Integer.parseInt(req.getParameter("feedback_id"));
        } catch (Exception e) {
            session.setAttribute("error", "Invalid feedback ID.");
            resp.sendRedirect(req.getContextPath() + "/orders?tab=delivered");
            return;
        }

        FeedbackDAO fbDAO = new FeedbackDAO();
        try {
            // Kiểm tra quyền và thời gian
            if (!fbDAO.canEditOrDeleteFeedback(feedbackId, cus.getCustomer_id())) {
                session.setAttribute("error", "You cannot delete this feedback (not yours or more than 3 days old).");
                resp.sendRedirect(req.getContextPath() + "/orders?tab=delivered");
                return;
            }

            // Xóa feedback
            boolean success = fbDAO.deleteFeedback(feedbackId, cus.getCustomer_id());
            if (success) {
                session.setAttribute("flash_success", "Your feedback has been deleted successfully.");
            } else {
                session.setAttribute("error", "Failed to delete feedback.");
            }

            resp.sendRedirect(req.getContextPath() + "/orders?tab=delivered");

        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("error", "An error occurred: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/orders?tab=delivered");
        }
    }
}
