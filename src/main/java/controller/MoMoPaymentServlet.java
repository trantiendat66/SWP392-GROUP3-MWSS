/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import dao.CartDAO;
import dao.ProductDAO;
import dao.OrderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Cart;
import model.Customer;
import org.json.JSONObject;
import util.MoMoConfig;
import util.MoMoPaymentUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.Map;

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
            
            // ====== CREATE / REUSE HOLD ORDER ======
            OrderDAO orderDAO = new OrderDAO();
            Integer holdOrderId = (Integer) session.getAttribute("hold_order_id");
            boolean reuseHold = false;
            if (holdOrderId != null) {
                // Simple verification could be added (status still PENDING_HOLD & not expired)
                reuseHold = true; // assume valid; refine later if needed
            }

            if (!reuseHold) {
                // Create new hold order (reserve stock): order_status=PENDING_HOLD, payment_method=2 (MoMo), payment_status=UNPAID
                int newId = createHoldOrder(orderDAO, cus.getCustomer_id(), phone, address, isBuyNow, items);
                holdOrderId = newId;
                session.setAttribute("hold_order_id", holdOrderId);
                // Clear cart / buy-now since already reserved
                if (isBuyNow) {
                    // remove buy-now markers
                    session.removeAttribute("bn_pid");
                    session.removeAttribute("bn_qty");
                } else {
                    cartDAO.clearCart(cus.getCustomer_id());
                }
            }

            // Generate orderId and requestId for MoMo (MoMo's own identifiers)
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
                // Success - get QR code URL and deeplink
                String payUrl = momoResponse.getString("payUrl");
                String qrCodeUrl = momoResponse.optString("qrCodeUrl", "");
                String deeplink = momoResponse.optString("deeplink", payUrl);
                
                System.out.println("Success! PayUrl: " + payUrl);
                System.out.println("QR Code URL: " + qrCodeUrl);
                
                // Save MoMo tracking + URLs for display
                session.setAttribute("momo_order_id", momoOrderId);
                session.setAttribute("momo_request_id", requestId);
                session.setAttribute("momo_pay_url", payUrl);
                session.setAttribute("momo_qr_url", qrCodeUrl);
                session.setAttribute("momo_deeplink", deeplink);
                session.setAttribute("total_amount", totalAmount);
                
                // Redirect to intermediate page with countdown
                resp.sendRedirect(req.getContextPath() + "/momo-payment.jsp");
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

    private int createHoldOrder(OrderDAO orderDAO, int customerId, String phone, String address, boolean isBuyNow, List<Cart> items) throws SQLException {
        // Reuse existing create logic: temporarily mimic createOrder but custom status & payment
        // Insert order header
        long total = 0;
        Map<Integer, Cart> merged = new LinkedHashMap<>();
        for (Cart it : items) {
            merged.merge(it.getProductId(), it, (a,b)->{a.setQuantity(a.getQuantity()+b.getQuantity());return a;});
        }
        for (Cart it : merged.values()) total += (long) it.getPrice() * it.getQuantity();

        try (Connection cn = new db.DBContext().getConnection()) {
            if (cn == null) throw new SQLException("Cannot connect DB");
            cn.setAutoCommit(false);
            cn.setTransactionIsolation(Connection.TRANSACTION_READ_COMMITTED);

            // staff id resolution simplified: reuse method via reflection or duplicate minimal logic
            int staffId = resolveStaffFallback(cn);

            int orderId;
            // Tạo đơn PENDING_HOLD, dùng order_date để tính hết hạn (order_date + 12h)
            String sqlOrder = "INSERT INTO [Order](account_id, customer_id, phone, order_date, order_status, shipping_address, payment_method, total_amount) " +
                    "VALUES(?, ?, ?, GETDATE(), 'PENDING_HOLD', ?, 2, ?)";
            try (PreparedStatement ps = cn.prepareStatement(sqlOrder, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, staffId);
                ps.setInt(2, customerId);
                ps.setString(3, phone);
                ps.setString(4, address == null ? "" : address);
                ps.setLong(5, total);
                ps.executeUpdate();
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (!rs.next()) throw new SQLException("No order id generated");
                    orderId = rs.getInt(1);
                }
            }

            String sqlDetail = "INSERT INTO OrderDetail(order_id, product_id, quantity, unit_price) VALUES(?,?,?,?)";
            try (PreparedStatement ps = cn.prepareStatement(sqlDetail)) {
                for (Cart it : merged.values()) {
                    ps.setInt(1, orderId);
                    ps.setInt(2, it.getProductId());
                    ps.setInt(3, it.getQuantity());
                    ps.setInt(4, it.getPrice());
                    ps.addBatch();
                }
                ps.executeBatch();
            }

            // Reserve stock
            String sqlStock = "UPDATE Product SET product_quantity = product_quantity - ? WHERE product_id=? AND product_quantity >= ?";
            List<Integer> fail = new ArrayList<>();
            try (PreparedStatement ps = cn.prepareStatement(sqlStock)) {
                for (Cart it : merged.values()) {
                    ps.setInt(1, it.getQuantity());
                    ps.setInt(2, it.getProductId());
                    ps.setInt(3, it.getQuantity());
                    if (ps.executeUpdate()==0) fail.add(it.getProductId());
                }
            }
            if (!fail.isEmpty()) {
                cn.rollback();
                throw new SQLException("Insufficient stock for products: " + fail);
            }
            cn.commit();
            return orderId;
        }
    }

    private int resolveStaffFallback(Connection cn) throws SQLException {
        // Simplified copy of logic from OrderDAO.resolveDefaultAccountId
        String pickActiveNotAdmin = "SELECT TOP 1 s.account_id FROM Staff s WHERE s.[status] = N'ACTIVE' AND s.account_id <> 1 ORDER BY s.account_id";
        try (PreparedStatement ps = cn.prepareStatement(pickActiveNotAdmin); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        }
        // fallback any not admin
        try (PreparedStatement ps = cn.prepareStatement("SELECT TOP 1 account_id FROM Staff WHERE account_id <> 1 ORDER BY account_id"); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        }
        // final: seed one staff
        String seed = "INSERT INTO Staff(user_name,[password],email,phone,role,[position],[address],[status]) VALUES(?,?,?,?,?,?,?,?)";
        try (PreparedStatement ps = cn.prepareStatement(seed, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, "seed_operator");
            ps.setString(2, "seed@123");
            ps.setString(3, "operator@example.com");
            ps.setString(4, "0900000000");
            ps.setString(5, "STAFF");
            ps.setString(6, "Operator");
            ps.setString(7, "-");
            ps.setString(8, "ACTIVE");
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        throw new SQLException("Cannot resolve staff id for hold order");
    }
}
