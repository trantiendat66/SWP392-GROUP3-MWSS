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
 * Servlet handles creating payment request to MoMo
 * @author Oanh Nguyen
 */
@WebServlet(name = "MoMoPaymentServlet", urlPatterns = {"/momo/payment"})
public class MoMoPaymentServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        System.out.println("=== MoMoPaymentServlet: doPost called ===");
        
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("customer") == null) {
            System.out.println("Session null or customer not logged in");
            resp.sendRedirect(req.getContextPath() + "/login.jsp?next=cart");
            return;
        }
        Customer cus = (Customer) session.getAttribute("customer");
        System.out.println("Customer ID: " + cus.getCustomer_id());

        String address = req.getParameter("shipping_address");
        String phone = req.getParameter("phone");
        System.out.println("Address: " + address + ", Phone: " + phone);
        
        if (phone == null || phone.isBlank()) {
            phone = cus.getPhone();
        }

        CartDAO cartDAO = new CartDAO();

        try {
            // Check if there's a pending buy-now
            Integer bnPid = (Integer) session.getAttribute("bn_pid");
            Integer bnQty = (Integer) session.getAttribute("bn_qty");
            boolean isBuyNow = (bnPid != null && bnQty != null && bnQty > 0);

            List<Cart> items;
            long totalAmount = 0;

            if (isBuyNow) {
                // Build order list with only buy-now product
                int price = new ProductDAO().getCurrentPrice(bnPid);
                items = new java.util.ArrayList<>();
                items.add(new Cart(0, cus.getCustomer_id(), bnPid, price, bnQty));
                totalAmount = (long) price * bnQty;
            } else {
                // Checkout from cart
                items = cartDAO.findItemsForCheckout(cus.getCustomer_id());
                for (Cart item : items) {
                    totalAmount += (long) item.getPrice() * item.getQuantity();
                }
            }

            if (items.isEmpty()) {
                System.out.println("Cart is empty");
                session.setAttribute("error", "Your cart is empty.");
                resp.sendRedirect(req.getContextPath() + "/cart");
                return;
            }

            System.out.println("Total amount: " + totalAmount + " VND");
            
            // Generate orderId and requestId for MoMo
            String momoOrderId = MoMoConfig.generateOrderId(cus.getCustomer_id());
            String requestId = MoMoConfig.generateRequestId();
            
            System.out.println("MoMo OrderId: " + momoOrderId);
            System.out.println("RequestId: " + requestId);
            
            // Create orderInfo
            String orderInfo = "Payment for order " + momoOrderId;
            
            // Create extraData - save info for callback processing
            // Format: customerId|phone|address|isBuyNow
            String extraData = cus.getCustomer_id() + "|" + phone + "|" + address + "|" + isBuyNow;
            // Encode base64 to avoid special characters
            extraData = Base64.getEncoder().encodeToString(extraData.getBytes());

        System.out.println("Calling MoMo API...");
            
        // Build dynamic base URL to match the actual deployed context path
        String baseUrl = req.getScheme() + "://" + req.getServerName()
            + (req.getServerPort() == 80 || req.getServerPort() == 443 ? "" : ":" + req.getServerPort())
            + req.getContextPath();
        String redirectUrl = baseUrl + "/momo/return";
        String ipnUrl = baseUrl + "/momo/callback";

        System.out.println("Computed redirectUrl: " + redirectUrl);
        System.out.println("Computed ipnUrl: " + ipnUrl);
            
        // Call MoMo API with dynamic URL (matches current context)
        JSONObject momoResponse = MoMoPaymentUtil.createPaymentRequest(
            momoOrderId,
            requestId,
            totalAmount,
            orderInfo,
            extraData,
            redirectUrl,
            ipnUrl
        );

            // Check response
            int resultCode = momoResponse.optInt("resultCode", -1);
            System.out.println("MoMo API Result Code: " + resultCode);
            
            if (resultCode == 0) {
                // Success - redirect to MoMo payment page
                String payUrl = momoResponse.getString("payUrl");
                System.out.println("Success! Redirecting to: " + payUrl);
                
                // Save momoOrderId to session for tracking
                session.setAttribute("momo_order_id", momoOrderId);
                session.setAttribute("momo_request_id", requestId);
                
                resp.sendRedirect(payUrl);
            } else {
                // Failed
                String message = momoResponse.optString("message", "Unknown error");
                System.out.println("MoMo API Error: " + message);
                session.setAttribute("error", "MoMo payment error: " + message);
                resp.sendRedirect(req.getContextPath() + "/payment");
            }

        } catch (SQLException e) {
            System.out.println("SQLException in MoMoPaymentServlet:");
            e.printStackTrace();
            session.setAttribute("error", "Database error: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/payment");
        } catch (Exception e) {
            System.out.println("Exception in MoMoPaymentServlet:");
            e.printStackTrace();
            session.setAttribute("error", "Payment error: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/payment");
        }
    }
}
