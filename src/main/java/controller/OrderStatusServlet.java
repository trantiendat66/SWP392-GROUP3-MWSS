package controller;

import dao.OrderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Order;

import java.io.IOException;
import java.io.PrintWriter;

/**
 * Simple JSON endpoint to query current order_status for an order.
 * Used by momo-payment.jsp to poll and update UI when payment completes.
 */
@WebServlet(name = "OrderStatusServlet", urlPatterns = {"/api/order-status"})
public class OrderStatusServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json;charset=UTF-8");
        String orderIdParam = req.getParameter("orderId");
        int orderId = 0;
        try {
            orderId = Integer.parseInt(orderIdParam);
        } catch (Exception ignore) {}

        String status = "UNKNOWN";
        if (orderId > 0) {
            try {
                OrderDAO dao = new OrderDAO();
                Order o = dao.getOrderByOrderId(orderId);
                if (o != null && o.getOrder_id() > 0) {
                    status = o.getOrder_status();
                }
            } catch (Exception e) {
                status = "ERROR";
            }
        }

        boolean success = !"PENDING_HOLD".equals(status) && !"UNKNOWN".equals(status) && !"ERROR".equals(status);

        try (PrintWriter out = resp.getWriter()) {
            out.printf("{\"orderId\":%d,\"orderStatus\":\"%s\",\"success\":%s}", orderId, status, success);
        }
    }
}
