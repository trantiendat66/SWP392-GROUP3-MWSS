package controller;

import dao.OrderDAO;
import dao.ProductDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Order;
import model.OrderDetail;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.List;

/**
 * Auto-cancel expired PENDING_HOLD orders and restore inventory.
 * Called via AJAX from orders-table.jsp when countdown reaches 0.
 */
@WebServlet(name = "AutoCancelHoldServlet", urlPatterns = {"/api/auto-cancel-hold"})
public class AutoCancelHoldServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json;charset=UTF-8");
        
        String orderIdParam = req.getParameter("orderId");
        int orderId = 0;
        try {
            orderId = Integer.parseInt(orderIdParam);
        } catch (Exception e) {
            resp.getWriter().write("{\"success\":false,\"message\":\"Invalid orderId\"}");
            return;
        }
        
        try {
            OrderDAO orderDAO = new OrderDAO();
            Order order = orderDAO.getOrderByOrderId(orderId);
            
            if (order == null || order.getOrder_id() == 0) {
                resp.getWriter().write("{\"success\":false,\"message\":\"Order not found\"}");
                return;
            }
            
            // Only cancel if still in PENDING_HOLD state
            if (!"PENDING_HOLD".equals(order.getOrder_status())) {
                resp.getWriter().write("{\"success\":false,\"message\":\"Order not in PENDING_HOLD state\"}");
                return;
            }
            
            // Get order details to restore stock
            List<OrderDetail> details = orderDAO.getOrderDetailsByOrderId(orderId);
            ProductDAO productDAO = new ProductDAO();
            
            // Restore inventory for each product
            for (OrderDetail detail : details) {
                productDAO.restoreStock(detail.getProduct_id(), detail.getQuantity());
            }
            
            // Update order status to CANCELLED
            orderDAO.updateOrderStatus(orderId, "CANCELLED");
            
            System.out.println("Auto-cancelled expired hold order #" + orderId + ", restored stock for " + details.size() + " items");
            
            try (PrintWriter out = resp.getWriter()) {
                out.printf("{\"success\":true,\"orderId\":%d,\"message\":\"Order auto-cancelled, stock restored\"}", orderId);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            resp.getWriter().write("{\"success\":false,\"message\":\"Database error: " + e.getMessage().replace("\"", "'") + "\"}");
        } catch (Exception e) {
            e.printStackTrace();
            resp.getWriter().write("{\"success\":false,\"message\":\"Error: " + e.getMessage().replace("\"", "'") + "\"}");
        }
    }
}
