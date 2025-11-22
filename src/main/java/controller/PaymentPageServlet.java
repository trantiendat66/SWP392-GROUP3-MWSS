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
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Cart;
import model.Customer;
import model.Product;

/**
 *
 * @author Oanh Nguyen
 */
@WebServlet(name = "PaymentPageServlet", urlPatterns = {"/payment"})
public class PaymentPageServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        System.out.println("=== PaymentPageServlet: doGet called ===");

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("customer") == null) {
            System.out.println("Session null or customer not logged in");
            resp.sendRedirect(req.getContextPath() + "/login.jsp?next=payment");
            return;
        }
        Customer cus = (Customer) session.getAttribute("customer");
        System.out.println("Customer ID: " + cus.getCustomer_id());

        CartDAO cartDAO = new CartDAO();
        // controller/PaymentPageServlet.java
        try {
            Integer bnPid = (Integer) session.getAttribute("bn_pid");
            Integer bnQty = (Integer) session.getAttribute("bn_qty");
            String bnParam = req.getParameter("bn");
            boolean isBuyNow = "1".equals(bnParam) && bnPid != null;
            
            // Khi vào trang payment với buy now, luôn reset số lượng về 1
            if (isBuyNow && bnPid != null) {
                bnQty = 1; // Luôn bắt đầu với số lượng 1
                session.setAttribute("bn_qty", bnQty);
            }
            
            isBuyNow = isBuyNow && bnQty != null && bnQty > 0;

            System.out.println("bn_pid from session: " + bnPid);
            System.out.println("bn_qty from session: " + bnQty);

            if (isBuyNow) {
                // ---- CHẾ ĐỘ BUY-NOW (không đụng DB cart) ----
                System.out.println("Mode: BUY_NOW");
                // Tạo danh sách hiển thị từ Product (1 item)
                ProductDAO pdao = new ProductDAO();
                Product p = pdao.getById(bnPid);                 // nếu chưa có, thêm hàm getById; hoặc tự viết query nhỏ
                int price = pdao.getCurrentPrice(bnPid);

                List<Cart> view = new ArrayList<>();
                Cart buyNowCart = new Cart(0, ((Customer) session.getAttribute("customer")).getCustomer_id(),
                        bnPid, price, bnQty,
                        p.getProductName(), p.getImage(), p.getBrand());
                buyNowCart.setAvailableQuantity(p.getQuantityProduct());
                view.add(buyNowCart);

                int total = price * bnQty;

                req.setAttribute("paymentMode", "BUY_NOW");
                req.setAttribute("cartItems", view);      // tái dụng biến để JSP hiển thị
                req.setAttribute("totalAmount", total);
                req.setAttribute("cartItemCount", bnQty);
            } else {
                // Không phải buy-now => đảm bảo trạng thái buy-now cũ không làm ảnh hưởng checkout từ giỏ
                if (bnParam == null || !"1".equals(bnParam)) {
                    session.removeAttribute("bn_pid");
                    session.removeAttribute("bn_qty");
                }
                // ---- CHẾ ĐỘ CART ----
                System.out.println("Mode: CART");
                List<Cart> items = cartDAO.findItemsForCheckout(cus.getCustomer_id());
                System.out.println("Cart items count: " + items.size());
                int total = 0, count = 0;
                for (Cart it : items) {
                    total += it.getTotalPrice();
                    count += it.getQuantity();
                }

                req.setAttribute("paymentMode", "CART");
                req.setAttribute("cartItems", items);
                req.setAttribute("totalAmount", total);
                req.setAttribute("cartItemCount", count);
                System.out.println("Total amount: " + total + ", Item count: " + count);
            }

            System.out.println("Forwarding to payment.jsp");
            req.getRequestDispatcher("/payment.jsp").forward(req, resp);
        } catch (SQLException e) {
            System.out.println("SQLException: " + e.getMessage());
            e.printStackTrace();
            req.setAttribute("error", e.getMessage());
            req.getRequestDispatcher("/cart.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Xử lý cập nhật buy-now quantity
        String action = req.getParameter("action");
        if ("update-buynow-qty".equals(action)) {
            HttpSession session = req.getSession(false);
            if (session == null || session.getAttribute("customer") == null) {
                resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                resp.setContentType("application/json");
                resp.getWriter().write("{\"success\": false, \"message\": \"Unauthorized\"}");
                return;
            }

            Integer bnPid = (Integer) session.getAttribute("bn_pid");
            if (bnPid == null) {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                resp.setContentType("application/json");
                resp.getWriter().write("{\"success\": false, \"message\": \"No buy-now product\"}");
                return;
            }

            try {
                int newQty = Integer.parseInt(req.getParameter("qty"));
                if (newQty < 1) {
                    newQty = 1;
                }

                // Kiểm tra số lượng sản phẩm trong kho
                ProductDAO productDAO = new ProductDAO();
                Product product = productDAO.getProductById(bnPid);
                if (product != null && newQty > product.getQuantityProduct()) {
                    resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    resp.setContentType("application/json");
                    resp.getWriter().write("{\"success\": false, \"message\": \"Quantity exceeds available stock\"}");
                    return;
                }

                // Cập nhật số lượng trong session
                session.setAttribute("bn_qty", newQty);

                // Tính lại tổng tiền
                try {
                    int price = productDAO.getCurrentPrice(bnPid);
                    int totalAmount = price * newQty;

                    resp.setContentType("application/json");
                    resp.getWriter().write("{\"success\": true, \"message\": \"Quantity updated\", \"totalAmount\": " + totalAmount + "}");
                } catch (SQLException e) {
                    resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                    resp.setContentType("application/json");
                    resp.getWriter().write("{\"success\": false, \"message\": \"Database error\"}");
                    e.printStackTrace();
                }

//                resp.setContentType("application/json");
//                resp.getWriter().write("{\"success\": true, \"message\": \"Quantity updated\", \"totalAmount\": " + totalAmount + "}");
            } catch (NumberFormatException e) {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                resp.setContentType("application/json");
                resp.getWriter().write("{\"success\": false, \"message\": \"Invalid quantity\"}");
            }
            return;
        }

        // Nếu không phải action update-buynow-qty, redirect về GET
        doGet(req, resp);
    }
}
