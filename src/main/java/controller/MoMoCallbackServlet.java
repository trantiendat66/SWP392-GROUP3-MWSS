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
import org.json.JSONObject;
import util.MoMoPaymentUtil;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.Base64;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Servlet xử lý IPN callback từ MoMo
 * @author Oanh Nguyen
 */
@WebServlet(name = "MoMoCallbackServlet", urlPatterns = {"/momo/callback"})
public class MoMoCallbackServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        
        try (PrintWriter out = resp.getWriter()) {
            // Đọc JSON body từ MoMo
            StringBuilder sb = new StringBuilder();
            BufferedReader reader = req.getReader();
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
            
            String requestBody = sb.toString();
            System.out.println("MoMo IPN received: " + requestBody);
            
            JSONObject callbackData = new JSONObject(requestBody);
            
            // Parse callback data
            String partnerCode = callbackData.optString("partnerCode");
            String orderId = callbackData.optString("orderId");
            String requestId = callbackData.optString("requestId");
            long amount = callbackData.optLong("amount");
            String orderInfo = callbackData.optString("orderInfo");
            String orderType = callbackData.optString("orderType");
            String transId = callbackData.optString("transId");
            int resultCode = callbackData.optInt("resultCode");
            String message = callbackData.optString("message");
            String payType = callbackData.optString("payType");
            long responseTime = callbackData.optLong("responseTime");
            String extraData = callbackData.optString("extraData");
            String signature = callbackData.optString("signature");
            
            // Verify signature
            Map<String, String> params = new HashMap<>();
            params.put("accessKey", callbackData.optString("accessKey"));
            params.put("amount", String.valueOf(amount));
            params.put("extraData", extraData);
            params.put("message", message);
            params.put("orderId", orderId);
            params.put("orderInfo", orderInfo);
            params.put("orderType", orderType);
            params.put("partnerCode", partnerCode);
            params.put("payType", payType);
            params.put("requestId", requestId);
            params.put("responseTime", String.valueOf(responseTime));
            params.put("resultCode", String.valueOf(resultCode));
            params.put("transId", String.valueOf(transId));
            
            boolean isValidSignature = MoMoPaymentUtil.verifySignature(params, signature);
            
            if (!isValidSignature) {
                System.out.println("Invalid signature from MoMo!");
                JSONObject response = new JSONObject();
                response.put("status", "error");
                response.put("message", "Invalid signature");
                out.print(response.toString());
                return;
            }
            
            // Kiểm tra resultCode
            if (resultCode == 0) {
                // Payment success - tạo order
                try {
                    // Decode extraData
                    String decodedExtraData = new String(Base64.getDecoder().decode(extraData));
                    String[] parts = decodedExtraData.split("\\|");
                    
                    if (parts.length < 4) {
                        throw new Exception("Invalid extraData format");
                    }
                    
                    int customerId = Integer.parseInt(parts[0]);
                    String phone = parts[1];
                    String address = parts[2];
                    boolean isBuyNow = Boolean.parseBoolean(parts[3]);
                    
                    // Tạo order trong database
                    CartDAO cartDAO = new CartDAO();
                    OrderDAO orderDAO = new OrderDAO();
                    
                    List<Cart> items = null;
                    if (isBuyNow) {
                        // Lấy thông tin buy-now từ session (nếu còn)
                        // Hoặc parse từ extraData nếu cần
                        // Tạm thời skip vì không có session trong IPN
                        System.out.println("Buy-now order via IPN - need to handle separately");
                        // TODO: Store buy-now info in database table for IPN processing
                        items = new java.util.ArrayList<>(); // Empty list để tránh lỗi
                    } else {
                        items = cartDAO.findItemsForCheckout(customerId);
                    }
                    
                    if (items == null || items.isEmpty()) {
                        throw new Exception("No items to create order");
                    }
                    
                    // Tạo order với payment_method = 1 (đã thanh toán)
                    int dbOrderId = orderDAO.createOrder(
                            customerId,
                            phone,
                            address,
                            1, // Đã thanh toán qua MoMo
                            items
                    );
                    
                    // Clear cart nếu không phải buy-now
                    if (!isBuyNow) {
                        cartDAO.clearCart(customerId);
                    }
                    
                    System.out.println("Order created successfully: " + dbOrderId + " for MoMo order: " + orderId);
                    
                    // Response success to MoMo
                    JSONObject response = new JSONObject();
                    response.put("status", "success");
                    response.put("message", "Order created");
                    out.print(response.toString());
                    
                } catch (SQLException e) {
                    e.printStackTrace();
                    System.out.println("Database error: " + e.getMessage());
                    JSONObject response = new JSONObject();
                    response.put("status", "error");
                    response.put("message", e.getMessage());
                    out.print(response.toString());
                } catch (Exception e) {
                    e.printStackTrace();
                    System.out.println("Error processing order: " + e.getMessage());
                    JSONObject response = new JSONObject();
                    response.put("status", "error");
                    response.put("message", e.getMessage());
                    out.print(response.toString());
                }
            } else {
                // Payment failed
                System.out.println("Payment failed with resultCode: " + resultCode);
                JSONObject response = new JSONObject();
                response.put("status", "failed");
                response.put("message", message);
                out.print(response.toString());
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            JSONObject response = new JSONObject();
            response.put("status", "error");
            response.put("message", e.getMessage());
            try (PrintWriter out = resp.getWriter()) {
                out.print(response.toString());
            }
        }
    }
}
