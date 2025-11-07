/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package util;

/**
 * MoMo Payment Configuration
 * @author Oanh Nguyen
 */
public class MoMoConfig {
    
    // MoMo Test Environment
    public static final String PARTNER_CODE = "MOMOBKUN20180529";
    public static final String ACCESS_KEY = "klm05TvNBzhg7h7j";
    public static final String SECRET_KEY = "at67qH6mk8w5Y1nAyMoYKMWACiEi2bsa";
    public static final String ENDPOINT = "https://test-payment.momo.vn/v2/gateway/api/create";
    
    // Request type
    public static final String REQUEST_TYPE = "payWithMethod";
    
    // IPN URL and Return URL (cần config theo domain của bạn)
    // Khi deploy production, thay localhost bằng domain thật
    public static final String IPN_URL = "http://localhost:8080/SWP_MWSS-V1.0/momo/callback";
    public static final String RETURN_URL = "http://localhost:8080/SWP_MWSS-V1.0/momo/return";
    
    // Auto capture
    public static final boolean AUTO_CAPTURE = true;
    
    // Language
    public static final String LANG = "vi";
    
    /**
     * Tạo orderId duy nhất cho MoMo
     * Format: MOMO_{timestamp}_{customerId}
     */
    public static String generateOrderId(int customerId) {
        return "MOMO_" + System.currentTimeMillis() + "_" + customerId;
    }
    
    /**
     * Tạo requestId duy nhất
     * Format: REQ_{timestamp}
     */
    public static String generateRequestId() {
        return "REQ_" + System.currentTimeMillis();
    }
}
