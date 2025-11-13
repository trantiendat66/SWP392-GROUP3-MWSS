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
import java.sql.SQLException;
import java.util.Base64;
import java.util.List;

/**
 * Servlet handles return URL from MoMo (when user completes payment and gets redirected back)
 * @author Oanh Nguyen
 */
@WebServlet(name = "MoMoReturnServlet", urlPatterns = {"/momo/return"})
public class MoMoReturnServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        
        // Parse parameters from MoMo
        String partnerCode = req.getParameter("partnerCode");
        String orderId = req.getParameter("orderId");
        String requestId = req.getParameter("requestId");
        String amount = req.getParameter("amount");
        String orderInfo = req.getParameter("orderInfo");
        String orderType = req.getParameter("orderType");
        String transId = req.getParameter("transId");
        String resultCode = req.getParameter("resultCode");
        String message = req.getParameter("message");
        String payType = req.getParameter("payType");
        String responseTime = req.getParameter("responseTime");
        String extraData = req.getParameter("extraData");
        String signature = req.getParameter("signature");

        System.out.println("MoMo Return - OrderId: " + orderId + ", ResultCode: " + resultCode + ", Message: " + message);

        // Check resultCode
        if ("0".equals(resultCode)) {
            // Payment success - Fallback to create order at Return (used when IPN cannot reach localhost)
            try {
                if (session == null || session.getAttribute("customer") == null) {
                    resp.sendRedirect(req.getContextPath() + "/login.jsp?next=orders");
                    return;
                }

                Customer cus = (Customer) session.getAttribute("customer");

                // Get phone/address/isBuyNow info from extraData sent during payment request
                String phone = cus.getPhone();
                String address = null;
                boolean isBuyNow = false;
                try {
                    if (extraData != null && !extraData.isEmpty()) {
                        String decoded = new String(Base64.getDecoder().decode(extraData));
                        String[] parts = decoded.split("\\|");
                        // Format: customerId|phone|address|isBuyNow
                        if (parts.length >= 4) {
                            phone = parts[1];
                            address = parts[2];
                            isBuyNow = Boolean.parseBoolean(parts[3]);
                        }
                    }
                } catch (IllegalArgumentException ignore) {
                    // Cannot decode extraData -> use fallback below
                }

                if (address == null || address.isBlank()) {
                    // Fallback: if no address in extraData, get from old parameter if available
                    address = req.getParameter("shipping_address");
                    if (address == null) address = "";
                }

                CartDAO cartDAO = new CartDAO();
                OrderDAO orderDAO = new OrderDAO();

                List<Cart> items;
                if (isBuyNow) {
                    // Get buy-now item from session
                    Integer bnPid = (Integer) session.getAttribute("bn_pid");
                    Integer bnQty = (Integer) session.getAttribute("bn_qty");
                    if (bnPid == null || bnQty == null || bnQty <= 0) {
                        // No buy-now info -> return to payment for user to retry
                        session.setAttribute("error", "Không tìm thấy thông tin đơn buy-now để tạo đơn. Vui lòng thử lại.");
                        resp.sendRedirect(req.getContextPath() + "/payment");
                        return;
                    }
                    int price = new dao.ProductDAO().getCurrentPrice(bnPid);
                    items = new java.util.ArrayList<>();
                    items.add(new Cart(0, cus.getCustomer_id(), bnPid, price, bnQty));
                } else {
                    // Get items from cart
                    items = cartDAO.findItemsForCheckout(cus.getCustomer_id());
                }

                if (items == null || items.isEmpty()) {
                    session.setAttribute("error", "Không có sản phẩm để tạo đơn hàng.");
                    resp.sendRedirect(req.getContextPath() + "/cart");
                    return;
                }

                int dbOrderId = orderDAO.createOrder(
                        cus.getCustomer_id(),
                        phone,
                        address,
                        1, // already paid via MoMo
                        items
                );

                // Clean up state
                if (isBuyNow) {
                    session.removeAttribute("bn_pid");
                    session.removeAttribute("bn_qty");
                } else {
                    cartDAO.clearCart(cus.getCustomer_id());
                }
                session.removeAttribute("momo_order_id");
                session.removeAttribute("momo_request_id");

                session.setAttribute("flash_success", "Thanh toán thành công! Đơn hàng #" + dbOrderId + " đã được tạo. Mã giao dịch: " + transId);
                resp.sendRedirect(req.getContextPath() + "/order-success.jsp?orderId=" + dbOrderId);
                return;

            } catch (SQLException e) {
                e.printStackTrace();
                if (session != null) {
                    session.setAttribute("error", "Lỗi khi tạo đơn sau thanh toán: " + e.getMessage());
                }
                resp.sendRedirect(req.getContextPath() + "/payment");
                return;
            }
            
        } else if ("1006".equals(resultCode)) {
            // User cancelled/rejected transaction - KEEP session buy-now/cart for user to retry
            if (session != null) {
                // Only remove MoMo tracking, DO NOT remove bn_pid/bn_qty
                session.removeAttribute("momo_order_id");
                session.removeAttribute("momo_request_id");
                
                session.setAttribute("error", "Bạn đã hủy thanh toán MoMo. Vui lòng chọn phương thức thanh toán khác hoặc thử lại.");
            }
            resp.sendRedirect(req.getContextPath() + "/payment");
            
        } else if ("9000".equals(resultCode)) {
            // Transaction timeout - KEEP session for user to retry
            if (session != null) {
                // Only remove MoMo tracking, DO NOT remove bn_pid/bn_qty
                session.removeAttribute("momo_order_id");
                session.removeAttribute("momo_request_id");
                
                session.setAttribute("error", "Giao dịch đã hết hạn (quá 20 phút). Vui lòng tạo lại đơn hàng.");
            }
            resp.sendRedirect(req.getContextPath() + "/payment");
            
        } else {
            // Other errors - KEEP session for user to retry
            if (session != null) {
                // Only remove MoMo tracking, DO NOT remove bn_pid/bn_qty
                session.removeAttribute("momo_order_id");
                session.removeAttribute("momo_request_id");
                
                String errorMsg = "Thanh toán thất bại: " + message + " (Mã lỗi: " + resultCode + ")";
                session.setAttribute("error", errorMsg);
            }
            
            // Redirect to payment page for user to retry
            resp.sendRedirect(req.getContextPath() + "/payment");
        }
    }
}
