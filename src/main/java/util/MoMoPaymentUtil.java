/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package util;

import org.json.JSONObject;
import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URI;
import java.nio.charset.StandardCharsets;
import java.util.Map;

/**
 * MoMo Payment Utility
 * @author Oanh Nguyen
 */
public class MoMoPaymentUtil {
    
    /**
     * Tạo chữ ký HMAC SHA256
     */
    public static String hmacSHA256(String data, String secretKey) throws Exception {
        Mac hmacSha256 = Mac.getInstance("HmacSHA256");
        SecretKeySpec secretKeySpec = new SecretKeySpec(secretKey.getBytes(StandardCharsets.UTF_8), "HmacSHA256");
        hmacSha256.init(secretKeySpec);
        byte[] hash = hmacSha256.doFinal(data.getBytes(StandardCharsets.UTF_8));
        
        // Convert byte array to hex string
        StringBuilder hexString = new StringBuilder();
        for (byte b : hash) {
            String hex = Integer.toHexString(0xff & b);
            if (hex.length() == 1) {
                hexString.append('0');
            }
            hexString.append(hex);
        }
        return hexString.toString();
    }
    
    /**
     * Tạo payment request tới MoMo
     * @return JSONObject chứa payUrl và các thông tin khác
     */
    public static JSONObject createPaymentRequest(
        String orderId,
        String requestId,
        long amount,
        String orderInfo,
        String extraData) throws Exception {
        
        // Tính thời gian hết hạn: 20 phút kể từ bây giờ (timestamp in milliseconds)
        long orderExpireTime = System.currentTimeMillis() + (20 * 60 * 1000);
        
        // Build raw signature
    String rawSignature = "accessKey=" + MoMoConfig.ACCESS_KEY
                + "&amount=" + amount
                + "&extraData=" + extraData
        + "&ipnUrl=" + MoMoConfig.IPN_URL
                + "&orderId=" + orderId
                + "&orderInfo=" + orderInfo
                + "&partnerCode=" + MoMoConfig.PARTNER_CODE
        + "&redirectUrl=" + MoMoConfig.RETURN_URL
                + "&requestId=" + requestId
                + "&requestType=" + MoMoConfig.REQUEST_TYPE;
        
        System.out.println("Raw signature: " + rawSignature);
        
        // Generate signature
        String signature = hmacSHA256(rawSignature, MoMoConfig.SECRET_KEY);
        
        // Build JSON request body
        JSONObject requestBody = new JSONObject();
        requestBody.put("partnerCode", MoMoConfig.PARTNER_CODE);
        requestBody.put("partnerName", "Watch Shop");
        requestBody.put("storeId", "WatchShopStore");
        requestBody.put("requestId", requestId);
        requestBody.put("amount", amount);
        requestBody.put("orderId", orderId);
        requestBody.put("orderInfo", orderInfo);
    requestBody.put("redirectUrl", MoMoConfig.RETURN_URL);
    requestBody.put("ipnUrl", MoMoConfig.IPN_URL);
        requestBody.put("lang", MoMoConfig.LANG);
        requestBody.put("extraData", extraData);
        requestBody.put("requestType", MoMoConfig.REQUEST_TYPE);
        requestBody.put("signature", signature);
        requestBody.put("autoCapture", MoMoConfig.AUTO_CAPTURE);
        requestBody.put("orderExpireTime", orderExpireTime); // Thêm 20 phút timeout
        
        System.out.println("Request body: " + requestBody.toString());
        System.out.println("Order expire time: " + orderExpireTime + " (20 minutes from now)");
        
        // Send POST request to MoMo
        URI uri = new URI(MoMoConfig.ENDPOINT);
        HttpURLConnection conn = (HttpURLConnection) uri.toURL().openConnection();
        conn.setDoOutput(true);
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/json");
        
        try (OutputStream os = conn.getOutputStream()) {
            byte[] input = requestBody.toString().getBytes(StandardCharsets.UTF_8);
            os.write(input, 0, input.length);
        }
        
        // Read response
        int responseCode = conn.getResponseCode();
        System.out.println("MoMo Response Code: " + responseCode);
        
        BufferedReader in = new BufferedReader(
                new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8));
        String inputLine;
        StringBuilder response = new StringBuilder();
        
        while ((inputLine = in.readLine()) != null) {
            response.append(inputLine);
        }
        in.close();
        
        System.out.println("MoMo Response: " + response.toString());
        
        return new JSONObject(response.toString());
    }

    /**
     * Overload: create payment request with dynamic redirect and ipn urls.
     * Useful when context path differs between environments (e.g., /SWP_MWSS vs /SWP_MWSS-V1.0).
     */
    public static JSONObject createPaymentRequest(
            String orderId,
            String requestId,
            long amount,
            String orderInfo,
            String extraData,
            String redirectUrl,
            String ipnUrl) throws Exception {

        // Build raw signature using provided URLs
        String rawSignature = "accessKey=" + MoMoConfig.ACCESS_KEY
                + "&amount=" + amount
                + "&extraData=" + extraData
                + "&ipnUrl=" + ipnUrl
                + "&orderId=" + orderId
                + "&orderInfo=" + orderInfo
                + "&partnerCode=" + MoMoConfig.PARTNER_CODE
                + "&redirectUrl=" + redirectUrl
                + "&requestId=" + requestId
                + "&requestType=" + MoMoConfig.REQUEST_TYPE;

        System.out.println("Raw signature: " + rawSignature);

        String signature = hmacSHA256(rawSignature, MoMoConfig.SECRET_KEY);

        JSONObject requestBody = new JSONObject();
        requestBody.put("partnerCode", MoMoConfig.PARTNER_CODE);
        requestBody.put("partnerName", "Watch Shop");
        requestBody.put("storeId", "WatchShopStore");
        requestBody.put("requestId", requestId);
        requestBody.put("amount", amount);
        requestBody.put("orderId", orderId);
        requestBody.put("orderInfo", orderInfo);
        requestBody.put("redirectUrl", redirectUrl);
        requestBody.put("ipnUrl", ipnUrl);
        requestBody.put("lang", MoMoConfig.LANG);
        requestBody.put("extraData", extraData);
        requestBody.put("requestType", MoMoConfig.REQUEST_TYPE);
        requestBody.put("signature", signature);
        requestBody.put("autoCapture", MoMoConfig.AUTO_CAPTURE);

        System.out.println("Request body: " + requestBody.toString());

        java.net.URI uri = new java.net.URI(MoMoConfig.ENDPOINT);
        java.net.HttpURLConnection conn = (java.net.HttpURLConnection) uri.toURL().openConnection();
        conn.setDoOutput(true);
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/json");

        try (java.io.OutputStream os = conn.getOutputStream()) {
            byte[] input = requestBody.toString().getBytes(java.nio.charset.StandardCharsets.UTF_8);
            os.write(input, 0, input.length);
        }

        int responseCode = conn.getResponseCode();
        System.out.println("MoMo Response Code: " + responseCode);

        java.io.BufferedReader in = new java.io.BufferedReader(
                new java.io.InputStreamReader(conn.getInputStream(), java.nio.charset.StandardCharsets.UTF_8));
        String inputLine;
        StringBuilder response = new StringBuilder();

        while ((inputLine = in.readLine()) != null) {
            response.append(inputLine);
        }
        in.close();

        System.out.println("MoMo Response: " + response.toString());

        return new org.json.JSONObject(response.toString());
    }
    
    /**
     * Verify callback signature from MoMo
     */
    public static boolean verifySignature(Map<String, String> params, String receivedSignature) {
        try {
            String rawSignature = "accessKey=" + params.get("accessKey")
                    + "&amount=" + params.get("amount")
                    + "&extraData=" + params.get("extraData")
                    + "&message=" + params.get("message")
                    + "&orderId=" + params.get("orderId")
                    + "&orderInfo=" + params.get("orderInfo")
                    + "&orderType=" + params.get("orderType")
                    + "&partnerCode=" + params.get("partnerCode")
                    + "&payType=" + params.get("payType")
                    + "&requestId=" + params.get("requestId")
                    + "&responseTime=" + params.get("responseTime")
                    + "&resultCode=" + params.get("resultCode")
                    + "&transId=" + params.get("transId");
            
            String calculatedSignature = hmacSHA256(rawSignature, MoMoConfig.SECRET_KEY);
            return calculatedSignature.equals(receivedSignature);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
