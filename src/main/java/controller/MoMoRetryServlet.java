package controller;

import dao.OrderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Customer;
import model.Order;
import org.json.JSONObject;
import util.MoMoConfig;
import util.MoMoPaymentUtil;

import java.io.IOException;
import java.util.Date;

/**
 * Servlet cho phép khách hàng thử lại thanh toán MoMo cho đơn hàng PENDING_HOLD chưa hết hạn.
 * Kiểm tra order_date + 12h để xác định hết hạn, redirect sang MoMo QR.
 */
@WebServlet(name = "MoMoRetryServlet", urlPatterns = {"/momo/retry"})
public class MoMoRetryServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("customer") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?next=orders");
            return;
        }
        Customer cus = (Customer) session.getAttribute("customer");

        String orderIdParam = req.getParameter("orderId");
        if (orderIdParam == null || orderIdParam.isBlank()) {
            session.setAttribute("orderError", "Missing order ID for retry.");
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

            // Verify ownership + order state
            if (order == null || order.getOrder_id() == 0) {
                session.setAttribute("orderError", "Order not found.");
                resp.sendRedirect(req.getContextPath() + "/orders");
                return;
            }

            // Must be PENDING_HOLD
            if (!"PENDING_HOLD".equals(order.getOrder_status())) {
                session.setAttribute("orderError", "Order is not in hold state.");
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
                    session.setAttribute("orderError", "Hold reservation has expired (12h). Cannot retry payment.");
                    resp.sendRedirect(req.getContextPath() + "/orders");
                    return;
                }
            } catch (Exception e) {
                // Parse error, allow retry
                System.out.println("Could not parse order_date for expiry check: " + e.getMessage());
            }

            // Generate new requestId for this retry attempt
            String newRequestId = MoMoConfig.generateRequestId();
            String momoOrderId = MoMoConfig.generateOrderId(cus.getCustomer_id());

            // Build MoMo payment request
            long totalAmount = order.getTotal_amount().longValue();
            String orderInfo = "Retry payment for order #" + orderId;
            String extraData = ""; // minimal

            String baseUrl = req.getScheme() + "://" + req.getServerName()
                    + (req.getServerPort() == 80 || req.getServerPort() == 443 ? "" : ":" + req.getServerPort())
                    + req.getContextPath();
            String redirectUrl = baseUrl + "/momo/return";
            String ipnUrl = baseUrl + "/momo/callback";

            JSONObject momoResponse = MoMoPaymentUtil.createPaymentRequest(
                    momoOrderId,
                    newRequestId,
                    totalAmount,
                    orderInfo,
                    extraData,
                    redirectUrl,
                    ipnUrl
            );

            int resultCode = momoResponse.optInt("resultCode", -1);
            if (resultCode == 0) {
                String payUrl = momoResponse.getString("payUrl");
                String qrCodeUrl = momoResponse.optString("qrCodeUrl", "");
                String deeplink = momoResponse.optString("deeplink", payUrl);
                
                // Update session tracking
                session.setAttribute("hold_order_id", orderId);
                session.setAttribute("momo_order_id", momoOrderId);
                session.setAttribute("momo_request_id", newRequestId);
                session.setAttribute("momo_pay_url", payUrl);
                session.setAttribute("momo_qr_url", qrCodeUrl);
                session.setAttribute("momo_deeplink", deeplink);
                session.setAttribute("total_amount", totalAmount);

                // Redirect to intermediate page with countdown
                resp.sendRedirect(req.getContextPath() + "/momo-payment.jsp");
            } else {
                String message = momoResponse.optString("message", "Unknown error");
                session.setAttribute("orderError", "MoMo retry error: " + message);
                resp.sendRedirect(req.getContextPath() + "/orders");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("orderError", "Error during retry: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/orders");
        }
    }
}
