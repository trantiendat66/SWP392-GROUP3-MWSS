package controller;

import dao.OrderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Order;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Date;

/**
 * Servlet cho phép khách hàng chuyển đơn hàng PENDING_HOLD sang thanh toán COD.
 * Chỉ áp dụng cho đơn chưa hết hạn (order_date + 12h).
 * Chuyển order_status từ PENDING_HOLD -> PENDING, payment_method từ 2 (MoMo) -> 0 (COD).
 */
@WebServlet(name = "SwitchToCODServlet", urlPatterns = {"/order/switch-to-cod"})
public class SwitchToCODServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("customer") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?next=orders");
            return;
        }

        String orderIdParam = req.getParameter("orderId");
        if (orderIdParam == null || orderIdParam.isBlank()) {
            session.setAttribute("orderError", "Missing order ID for switch to COD.");
            resp.sendRedirect(req.getContextPath() + "/orders");
            return;
        }

        int orderId;
        try {
            orderId = Integer.parseInt(orderIdParam);
        } catch (NumberFormatException e) {
            session.setAttribute("orderError", "Invalid order ID.");
            resp.sendRedirect(req.getContextPath() + "/orders");
            return;
        }

        try {
            OrderDAO orderDAO = new OrderDAO();
            Order order = orderDAO.getOrderByOrderId(orderId);

            if (order == null || order.getOrder_id() == 0) {
                session.setAttribute("orderError", "Order not found.");
                resp.sendRedirect(req.getContextPath() + "/orders");
                return;
            }

            // Must be in PENDING_HOLD state
            if (!"PENDING_HOLD".equals(order.getOrder_status())) {
                session.setAttribute("orderError", "Order is not in hold state. Cannot switch to COD.");
                resp.sendRedirect(req.getContextPath() + "/orders");
                return;
            }

            // Check not expired: order_date + 12h
            try {
                String orderDateStr = order.getOrder_date(); // format: "yyyy-MM-dd HH:mm:ss"
                java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                Date orderDate = sdf.parse(orderDateStr);
                Date holdExpires = new Date(orderDate.getTime() + 12 * 60 * 60 * 1000); // +12h
                if (new Date().after(holdExpires)) {
                    session.setAttribute("orderError", "Hold reservation has expired (12h). Cannot switch to COD.");
                    resp.sendRedirect(req.getContextPath() + "/orders");
                    return;
                }
            } catch (Exception e) {
                // Parse error, allow switch
                System.out.println("Could not parse order_date for expiry check: " + e.getMessage());
            }

            // Perform switch: status -> PENDING, payment_method -> 0 (COD)
            try (Connection cn = new db.DBContext().getConnection()) {
                if (cn == null) throw new SQLException("DB connection null");

                String sqlOrder = "UPDATE [Order] SET order_status='PENDING', payment_method=0 "
                        + "WHERE order_id=? AND order_status='PENDING_HOLD'";
                try (PreparedStatement ps = cn.prepareStatement(sqlOrder)) {
                    ps.setInt(1, orderId);
                    int updated = ps.executeUpdate();
                    if (updated == 0) {
                        session.setAttribute("orderError", "Order state changed. Cannot switch to COD now.");
                        resp.sendRedirect(req.getContextPath() + "/orders");
                        return;
                    }
                }

                // Clear session MoMo tracking
                session.removeAttribute("hold_order_id");
                session.removeAttribute("momo_order_id");
                session.removeAttribute("momo_request_id");

                session.setAttribute("orderSuccess", "Payment method switched to Cash on Delivery for order #" + orderId + ".");
                resp.sendRedirect(req.getContextPath() + "/orders");

            } catch (SQLException e) {
                e.printStackTrace();
                session.setAttribute("orderError", "Database error switching to COD: " + e.getMessage());
                resp.sendRedirect(req.getContextPath() + "/orders");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("orderError", "Error loading order: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/orders");
        }
    }
}
