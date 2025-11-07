/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import dao.CartDAO;
import dao.ProductDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Cart;
import model.Customer;
import org.json.JSONObject;
import util.MoMoConfig;
import util.MoMoPaymentUtil;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Base64;
import java.util.List;

/**
 * Servlet xử lý tạo payment request tới MoMo
 * @author Oanh Nguyen
 */
@WebServlet(name = "MoMoPaymentServlet", urlPatterns = {"/momo/payment"})
public class MoMoPaymentServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("customer") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?next=cart");
            return;
        }
        Customer cus = (Customer) session.getAttribute("customer");

        String address = req.getParameter("shipping_address");
        String phone = req.getParameter("phone");
        if (phone == null || phone.isBlank()) {
            phone = cus.getPhone();
        }

        CartDAO cartDAO = new CartDAO();

        try {
            // Kiểm tra có buy-now pending hay không?
            Integer bnPid = (Integer) session.getAttribute("bn_pid");
            Integer bnQty = (Integer) session.getAttribute("bn_qty");
            boolean isBuyNow = (bnPid != null && bnQty != null && bnQty > 0);

            List<Cart> items;
            long totalAmount = 0;

            if (isBuyNow) {
                // Build list đơn hàng chỉ với sản phẩm buy-now
                int price = new ProductDAO().getCurrentPrice(bnPid);
                items = new java.util.ArrayList<>();
                items.add(new Cart(0, cus.getCustomer_id(), bnPid, price, bnQty));
                totalAmount = (long) price * bnQty;
            } else {
                // Checkout từ giỏ
                items = cartDAO.findItemsForCheckout(cus.getCustomer_id());
                for (Cart item : items) {
                    totalAmount += (long) item.getPrice() * item.getQuantity();
                }
            }

            if (items.isEmpty()) {
                session.setAttribute("error", "Your cart is empty.");
                resp.sendRedirect(req.getContextPath() + "/cart");
                return;
            }

            // Tạo orderId và requestId cho MoMo
            String momoOrderId = MoMoConfig.generateOrderId(cus.getCustomer_id());
            String requestId = MoMoConfig.generateRequestId();
            
            // Tạo orderInfo
            String orderInfo = "Payment for order " + momoOrderId;
            
            // Tạo extraData - lưu thông tin để xử lý sau khi callback
            // Format: customerId|phone|address|isBuyNow
            String extraData = cus.getCustomer_id() + "|" + phone + "|" + address + "|" + isBuyNow;
            // Encode base64 để tránh ký tự đặc biệt
            extraData = Base64.getEncoder().encodeToString(extraData.getBytes());

            // Gọi MoMo API
            JSONObject momoResponse = MoMoPaymentUtil.createPaymentRequest(
                    momoOrderId,
                    requestId,
                    totalAmount,
                    orderInfo,
                    extraData
            );

            // Kiểm tra response
            int resultCode = momoResponse.optInt("resultCode", -1);
            
            if (resultCode == 0) {
                // Success - redirect to MoMo payment page
                String payUrl = momoResponse.getString("payUrl");
                
                // Lưu momoOrderId vào session để tracking
                session.setAttribute("momo_order_id", momoOrderId);
                session.setAttribute("momo_request_id", requestId);
                
                resp.sendRedirect(payUrl);
            } else {
                // Failed
                String message = momoResponse.optString("message", "Unknown error");
                session.setAttribute("error", "MoMo payment error: " + message);
                resp.sendRedirect(req.getContextPath() + "/payment");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("error", "Database error: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/payment");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Payment error: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/payment");
        }
    }
}
