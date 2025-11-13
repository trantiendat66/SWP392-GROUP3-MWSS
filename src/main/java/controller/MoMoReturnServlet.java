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
 * Servlet xử lý return URL từ MoMo (khi user hoàn tất thanh toán và được redirect về)
 * @author Oanh Nguyen
 */
@WebServlet(name = "MoMoReturnServlet", urlPatterns = {"/momo/return"})
public class MoMoReturnServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        
        // Parse parameters từ MoMo
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

        // Kiểm tra resultCode
        if ("0".equals(resultCode)) {
            // Payment success - Fallback tạo đơn tại Return (dùng khi IPN không tới được localhost)
            try {
                if (session == null || session.getAttribute("customer") == null) {
                    resp.sendRedirect(req.getContextPath() + "/login.jsp?next=orders");
                    return;
                }

                Customer cus = (Customer) session.getAttribute("customer");

                // Lấy thông tin phone/address/isBuyNow từ extraData đã gửi đi lúc tạo yêu cầu thanh toán
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
                    // Không giải mã được extraData -> dùng fallback dưới
                }

                if (address == null || address.isBlank()) {
                    // Fallback: nếu không có địa chỉ trong extraData, lấy từ tham số cũ nếu có
                    address = req.getParameter("shipping_address");
                    if (address == null) address = "";
                }

                CartDAO cartDAO = new CartDAO();
                OrderDAO orderDAO = new OrderDAO();

                List<Cart> items;
                if (isBuyNow) {
                    // Lấy item buy-now từ session
                    Integer bnPid = (Integer) session.getAttribute("bn_pid");
                    Integer bnQty = (Integer) session.getAttribute("bn_qty");
                    if (bnPid == null || bnQty == null || bnQty <= 0) {
                        // Không còn thông tin buy-now -> quay về payment để user thử lại
                        session.setAttribute("error", "Không tìm thấy thông tin đơn buy-now để tạo đơn. Vui lòng thử lại.");
                        resp.sendRedirect(req.getContextPath() + "/payment");
                        return;
                    }
                    int price = new dao.ProductDAO().getCurrentPrice(bnPid);
                    items = new java.util.ArrayList<>();
                    items.add(new Cart(0, cus.getCustomer_id(), bnPid, price, bnQty));
                } else {
                    // Lấy item từ giỏ
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
                        1, // đã thanh toán qua MoMo
                        items
                );

                // Dọn state
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
            // User cancelled/rejected transaction - GIỮ LẠI session buy-now/cart để user thử lại
            if (session != null) {
                // Chỉ xóa tracking MoMo, KHÔNG xóa bn_pid/bn_qty
                session.removeAttribute("momo_order_id");
                session.removeAttribute("momo_request_id");
                
                session.setAttribute("error", "Bạn đã hủy thanh toán MoMo. Vui lòng chọn phương thức thanh toán khác hoặc thử lại.");
            }
            resp.sendRedirect(req.getContextPath() + "/payment");
            
        } else if ("9000".equals(resultCode)) {
            // Transaction timeout - GIỮ LẠI session để user thử lại
            if (session != null) {
                // Chỉ xóa tracking MoMo, KHÔNG xóa bn_pid/bn_qty
                session.removeAttribute("momo_order_id");
                session.removeAttribute("momo_request_id");
                
                session.setAttribute("error", "Giao dịch đã hết hạn (quá 20 phút). Vui lòng tạo lại đơn hàng.");
            }
            resp.sendRedirect(req.getContextPath() + "/payment");
            
        } else {
            // Other errors - GIỮ LẠI session để user thử lại
            if (session != null) {
                // Chỉ xóa tracking MoMo, KHÔNG xóa bn_pid/bn_qty
                session.removeAttribute("momo_order_id");
                session.removeAttribute("momo_request_id");
                
                String errorMsg = "Thanh toán thất bại: " + message + " (Mã lỗi: " + resultCode + ")";
                session.setAttribute("error", errorMsg);
            }
            
            // Redirect về trang payment để user có thể thử lại
            resp.sendRedirect(req.getContextPath() + "/payment");
        }
    }
}
