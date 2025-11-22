/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import dao.CartDAO;
import dao.OrderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Cart;
import model.Customer;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Base64;
import java.util.List;

/**
 * Updated MoMo return servlet to finalize existing HOLD order + payment attempt.
 * Transitions order_status from PENDING_HOLD -> PENDING and payment_status UNPAID -> PAID.
 * Marks the payment attempt status accordingly instead of recreating a new order.
 */
@WebServlet(name = "MoMoReturnServlet", urlPatterns = {"/momo/return"})
public class MoMoReturnServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        String resultCode = req.getParameter("resultCode");
        String message = req.getParameter("message");
        String transId = req.getParameter("transId");
        String requestId = req.getParameter("requestId");
        String extraData = req.getParameter("extraData");

        System.out.println("MoMo Return - requestId=" + requestId + ", resultCode=" + resultCode + ", message=" + message);

        // Common session references
        Integer holdOrderId = session == null ? null : (Integer) session.getAttribute("hold_order_id");

        if ("0".equals(resultCode)) {
            // Payment success: finalize hold order if exists
            if (session == null || session.getAttribute("customer") == null) {
                resp.sendRedirect(req.getContextPath() + "/login.jsp?next=orders");
                return;
            }
            Customer cus = (Customer) session.getAttribute("customer");

            if (holdOrderId == null) {
                // Fallback to legacy path (should rarely happen). Re-create order from cart/buy-now.
                legacyCreateOrder(req, resp, session, transId, extraData, cus);
                return;
            }

            try {
                // Transition order from PENDING_HOLD -> PENDING (paid via MoMo, payment_method=2)
                try (Connection cn = new db.DBContext().getConnection()) {
                    if (cn == null) throw new SQLException("DB connection null");
                    String sql = "UPDATE [Order] SET order_status='PENDING' WHERE order_id=? AND order_status='PENDING_HOLD'";
                    try (PreparedStatement ps = cn.prepareStatement(sql)) {
                        ps.setInt(1, holdOrderId);
                        int updated = ps.executeUpdate();
                        if (updated == 0) {
                            System.out.println("Hold order not in expected state; order_id=" + holdOrderId);
                        }
                    }
                }

                // Clear session MoMo tracking
                session.removeAttribute("momo_order_id");
                session.removeAttribute("momo_request_id");

                session.setAttribute("orderSuccess", "Payment successful! Order #" + holdOrderId + " confirmed. Transaction ID: " + transId);
                resp.sendRedirect(req.getContextPath() + "/order-success.jsp?orderId=" + holdOrderId);
                return;
            } catch (SQLException e) {
                e.printStackTrace();
                session.setAttribute("orderError", "Finalize hold order error: " + e.getMessage());
                resp.sendRedirect(req.getContextPath() + "/payment");
                return;
            }

        } else if ("1006".equals(resultCode)) {
            // User canceled: keep hold order for retry until 12h expires
            cleanupTracking(session);
            if (session != null) session.setAttribute("orderError", "You canceled the MoMo payment. Please try again or change method.");
            resp.sendRedirect(req.getContextPath() + "/payment");

        } else if ("9000".equals(resultCode)) {
            // Timeout: allow retry
            cleanupTracking(session);
            if (session != null) session.setAttribute("orderError", "The payment attempt timed out. Please retry.");
            resp.sendRedirect(req.getContextPath() + "/payment");

        } else {
            // Other failure
            cleanupTracking(session);
            if (session != null) session.setAttribute("orderError", "Payment failed: " + message + " (" + resultCode + ")");
            resp.sendRedirect(req.getContextPath() + "/payment");
        }
    }

    private void legacyCreateOrder(HttpServletRequest req, HttpServletResponse resp, HttpSession session, String transId, String extraData, Customer cus) throws IOException {
        // Preserve legacy behavior if no hold order found (unexpected edge case)
        try {
            String phone = cus.getPhone();
            String address = "";
            boolean isBuyNow = false;
            try {
                if (extraData != null && !extraData.isEmpty()) {
                    String decoded = new String(Base64.getDecoder().decode(extraData));
                    String[] parts = decoded.split("\\|");
                    if (parts.length >= 4) {
                        phone = parts[1];
                        address = parts[2];
                        isBuyNow = Boolean.parseBoolean(parts[3]);
                    }
                }
            } catch (IllegalArgumentException ignore) {}

            CartDAO cartDAO = new CartDAO();
            OrderDAO orderDAO = new OrderDAO();
            List<Cart> items;
            if (isBuyNow) {
                Integer bnPid = (Integer) session.getAttribute("bn_pid");
                Integer bnQty = (Integer) session.getAttribute("bn_qty");
                if (bnPid == null || bnQty == null || bnQty <= 0) {
                    session.setAttribute("orderError", "Buy Now info missing; please retry.");
                    resp.sendRedirect(req.getContextPath() + "/payment");
                    return;
                }
                int price = new dao.ProductDAO().getCurrentPrice(bnPid);
                items = new java.util.ArrayList<>();
                items.add(new Cart(0, cus.getCustomer_id(), bnPid, price, bnQty));
            } else {
                items = cartDAO.findItemsForCheckout(cus.getCustomer_id());
            }
            if (items == null || items.isEmpty()) {
                session.setAttribute("orderError", "No items for order.");
                resp.sendRedirect(req.getContextPath() + "/payment");
                return;
            }
            int orderId = orderDAO.createOrder(cus.getCustomer_id(), phone, address, 1, items);
            if (isBuyNow) {
                session.removeAttribute("bn_pid");
                session.removeAttribute("bn_qty");
            } else {
                cartDAO.clearCart(cus.getCustomer_id());
            }
            session.setAttribute("orderSuccess", "Payment successful! Order #" + orderId + " created (legacy path). Tx: " + transId);
            resp.sendRedirect(req.getContextPath() + "/order-success.jsp?orderId=" + orderId);
        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("orderError", "Legacy create error: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/payment");
        }
    }

    private void cleanupTracking(HttpSession session) {
        if (session == null) return;
        session.removeAttribute("momo_order_id");
        session.removeAttribute("momo_request_id");
        // Keep hold_order_id to allow retry or switch payment method.
    }
}
