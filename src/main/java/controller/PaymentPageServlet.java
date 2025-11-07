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

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("customer") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?next=payment");
            return;
        }
        Customer cus = (Customer) session.getAttribute("customer");

        CartDAO cartDAO = new CartDAO();
        // controller/PaymentPageServlet.java
        try {
            Integer bnPid = (Integer) session.getAttribute("bn_pid");
            Integer bnQty = (Integer) session.getAttribute("bn_qty");

            if (bnPid != null && bnQty != null && bnQty > 0) {
                // ---- CHẾ ĐỘ BUY-NOW (không đụng DB cart) ----
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
                // ---- CHẾ ĐỘ CART ----
                List<Cart> items = cartDAO.findItemsForCheckout(cus.getCustomer_id());
                int total = 0, count = 0;
                for (Cart it : items) {
                    total += it.getTotalPrice();
                    count += it.getQuantity();
                }

                req.setAttribute("paymentMode", "CART");
                req.setAttribute("cartItems", items);
                req.setAttribute("totalAmount", total);
                req.setAttribute("cartItemCount", count);
            }

            req.getRequestDispatcher("/payment.jsp").forward(req, resp);
        } catch (SQLException e) {
            req.setAttribute("error", e.getMessage());
            req.getRequestDispatcher("/cart.jsp").forward(req, resp);
        }
    }
}
