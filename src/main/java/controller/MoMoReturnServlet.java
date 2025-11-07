/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

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

        System.out.println("MoMo Return - OrderId: " + orderId + ", ResultCode: " + resultCode);

        // Kiểm tra resultCode
        if ("0".equals(resultCode)) {
            // Payment success
            if (session != null) {
                // Xóa thông tin buy-now và momo tracking
                session.removeAttribute("bn_pid");
                session.removeAttribute("bn_qty");
                session.removeAttribute("momo_order_id");
                session.removeAttribute("momo_request_id");
                
                session.setAttribute("flash_success", 
                    "Payment successful! Your order has been created. Transaction ID: " + transId);
            }
            
            // Redirect đến trang success (giả sử có order-success.jsp)
            resp.sendRedirect(req.getContextPath() + "/orders?tab=placed");
            
        } else {
            // Payment failed or cancelled
            if (session != null) {
                String errorMsg = "Payment failed: " + message + " (Code: " + resultCode + ")";
                session.setAttribute("error", errorMsg);
            }
            
            // Redirect về trang payment để user có thể thử lại
            resp.sendRedirect(req.getContextPath() + "/payment");
        }
    }
}
