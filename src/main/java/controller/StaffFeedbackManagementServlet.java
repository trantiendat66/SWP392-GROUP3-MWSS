/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.FeedbackDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.FeedbackInfo;
import model.Reply;
import org.json.JSONObject;

/**
 *
 * @author Nguyen Thien Dat - CE190879 - 06/05/2005
 */
@WebServlet(name = "StaffFeedbackManagementServlet", urlPatterns = {"/staff/feedback/management"})
public class StaffFeedbackManagementServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet StaffFeedbackManagementServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet StaffFeedbackManagementServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String feedbackIdParam = request.getParameter("feedbackId");
        FeedbackDAO fd = new FeedbackDAO();
        if (feedbackIdParam == null) {
            response.getWriter().write("<p style='color:red'>Missing order ID</p>");
            return;
        }
        try {
            int feedbackId = Integer.parseInt(feedbackIdParam);
            FeedbackInfo fi = fd.getFeedbackByFeedbackId(feedbackId);
            Reply re = fd.getReplyById(feedbackId);
            PrintWriter out = response.getWriter();
            out.println("<div class='container-flex'>");
            out.println("<div class='row align-items-start'>");

            out.println("<div class='col-md-6'>");
            out.println("<div class='left' >");
            out.println("<p><strong>Order ID:</strong> " + fi.getOrderId() + "</p>");
            out.println("<p><strong>Customer:</strong> " + fi.getCustomerName() + "</p>");
            out.println("<p><strong>Date:</strong> " + fi.getCreateAt() + "</p>");
            out.println("<p><strong>Rating:</strong> " + fi.getRating() + "</p>");
            out.println("<p class='comment'><strong>Comment:</strong> " + fi.getComment() + "</p>");
            out.println("</div>");
            out.println("</div>");

            out.println("<div class='col-md-4' style='border-left: 2px solid #eee;'>");
            out.println("<div style='display: flex; flex-direction: column; align-items: center;'>");
            out.println("<div class='right'>");
            out.println("<div class='row' style='margin-bottom: 15px;'>");
            out.println("<img src='" + request.getContextPath() + "/assert/image/" + fi.getImage()
                    + "' alt='" + fi.getProductName() + "' style='width:300px;height:auto;margin:5px;display: block;'/>");
            out.println("</div>");
            out.println("</div>");
            out.println("</div>");
            out.println("<input type='hidden' name='feedback_id' value='" + feedbackId + "'>");
            out.println("<label class='form-label fw-semibold d-block text-start mb-2'>Comment</label>");
            out.println("<textarea name='comment' class='form-control fb-comment' rows='4' cols='500'");
            if (re.getContentReply() != null) {
                out.println("placeholder='" + re.getContentReply() + "'>");
            } else {
                out.println("placeholder='Enter your review (optional – please type in Vietnamese with diacritics)…'>");
            }
            out.println("</textarea>");
            out.println("<div class='form-text text-danger d-none comment-help'></div>");
            out.println("</div>");
            out.println("</div>");
        } catch (Exception e) {
            response.getWriter().write("<p style='color:red'>Error loading feedback detail.</p>");
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        boolean success = false;
        int feedbackId = Integer.parseInt(request.getParameter("feedback_id"));
        String contentReply = request.getParameter("comment");
        FeedbackDAO fd = new FeedbackDAO();
        success = fd.createReply(feedbackId, contentReply);
        response.setContentType("application/json");
        JSONObject json = new JSONObject();
        json.put("success", success);
        response.getWriter().write(json.toString());
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
