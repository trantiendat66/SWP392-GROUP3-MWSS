/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.OrderDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.json.JSONObject;
import java.util.List;
import model.Order;
import model.OrderDetail;

/**
 *
 * @author Nguyen Thien Dat - CE190879 - 06/05/2005
 */
@WebServlet(name = "OrderDetailServlet", urlPatterns = {"/orderdetail"})
public class OrderDetailServlet extends HttpServlet {

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
            out.println("<title>Servlet OrderDetailServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet OrderDetailServlet at " + request.getContextPath() + "</h1>");
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
        String orderIdParam = request.getParameter("orderIdV");
        if (orderIdParam == null) {
            response.getWriter().write("<p style='color:red'>Missing order ID</p>");
            return;
        }

        try {
            int orderId = Integer.parseInt(orderIdParam);
            OrderDAO orderDAO = new OrderDAO();
            Order order = orderDAO.getOrderByOrderId(orderId);
            List<OrderDetail> orderP = orderDAO.getOrderDetailByOrderId(orderId);
            response.setContentType("text/html;charset=UTF-8");
            PrintWriter out = response.getWriter();
            java.text.NumberFormat nf = java.text.NumberFormat.getInstance(new java.util.Locale("en", "US"));
            out.println("<div class='container-flex'>");
            out.println("<div class='row align-items-start'>");

            out.println("<div class='col-md-6'>");
            out.println("<div class='left' >");
            out.println("<p><strong>Order ID:</strong> " + orderId + "</p>");
            out.println("<p><strong>Customer:</strong> " + escapeHtml(order.getCustomer_name()) + "</p>");
            out.println("<p><strong>Date:</strong> " + escapeHtml(order.getOrder_date()) + "</p>");
            out.println("<p><strong>Phone:</strong> " + escapeHtml(order.getPhone()) + "</p>");
            out.println("<p><strong>Address:</strong> " + escapeHtml(order.getShipping_address()) + "</p>");
            out.println("<p><strong>Status:</strong> " + escapeHtml(order.getOrder_status()) + "</p>");
            String formattedTotal = nf.format(order.getTotal_amount());
            out.println("<p><strong>Total:</strong><span style='color:green;font-weight:bold;'> " + formattedTotal + " VND</p>");
            out.println("</div>");
            out.println("</div>");
            out.println("<div class='col-md-4' style='border-left: 2px solid #eee;'>");
            out.println("<div style='display: flex; flex-direction: column; align-items: center;'>");
            out.println("<div class='right'>");
            for (OrderDetail od : orderP) {
                out.println("<div class='row' style='margin-bottom: 15px;'>");
                out.println("<img src='" + request.getContextPath() + "/assert/image/" + escapeHtml(od.getImage())
                        + "' alt='" + escapeHtml(od.getProduct_name()) + "' style='width:200px;height:auto;margin:5px;'/>");
                out.println("<div><strong>Product: </strong>" + escapeHtml(od.getProduct_name()) + "</div>");
                out.println("<div><strong>Quantity: </strong>" + od.getQuantity() + "</div>");
                String formattedUnit = nf.format(od.getUnit_price());
                String formattedLineTotal = nf.format(od.getTotal_price());
                out.println("<div><strong>Price: </strong>" + formattedUnit + " VND</div>");
                out.println("<div><strong>Total: </strong><span style='color:#007bff;'>" + formattedLineTotal + " VND</div>");
                out.println("</div>");
            }
            out.println("</div>");
            out.println("</div>");
            out.println("</div>");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("<p style='color:red'>Error loading order detail.</p>");
        }
    }

    private String escapeHtml(String s) {
        if (s == null) {
            return "";
        }
        return s.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#x27;");
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
        OrderDAO dao = new OrderDAO();
        int id = Integer.parseInt(request.getParameter("id"));
        String status = request.getParameter("status");
        String currentStatus = dao.getOrderStatus(id);
        String message = null;
        if ("CANCELLED".equalsIgnoreCase(currentStatus)) {
            success = false;
            message = "Đơn hàng đã bị hủy và không thể chỉnh sửa.";
        } else {
            success = dao.updateOrderStatus(id, status);
            if (!success) {
                message = "Không thể cập nhật trạng thái đơn hàng.";
            }
        }

        response.setContentType("application/json");
        JSONObject json = new JSONObject();
        json.put("success", success);
        json.put("orderStatus", status);
        if (message != null) {
            json.put("message", message);
        }
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
