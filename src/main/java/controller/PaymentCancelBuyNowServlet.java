/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.Customer;
import dao.CartDAO;
import dao.ProductDAO;
import model.Cart;
import model.Product;

/**
 *
 * @author Oanh Nguyen
 */
@WebServlet(name = "PaymentCancelBuyNowServlet", urlPatterns = {"/payment/cancel-buynow"})
public class PaymentCancelBuyNowServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("customer") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?next=cart");
            return;
        }
        Customer cus = (Customer) session.getAttribute("customer");

        Integer pid = (Integer) session.getAttribute("bn_pid");
        Integer qty = (Integer) session.getAttribute("bn_qty");
        session.removeAttribute("bn_pid");
        session.removeAttribute("bn_qty");

        if (pid != null && qty != null && qty > 0) {
            try {
                CartDAO cartDAO = new CartDAO();
                ProductDAO productDAO = new ProductDAO();
                Product product = productDAO.getProductById(pid);
                if (product == null || product.getQuantityProduct() <= 0) {
                    session.setAttribute("error", "Product is out of stock; nothing was added.");
                } else {
                    Cart existing = cartDAO.getCartItem(cus.getCustomer_id(), pid);
                    int already = existing != null ? existing.getQuantity() : 0;
                    int stock = product.getQuantityProduct();
                    int remaining = stock - already;
                    if (remaining <= 0) {
                        session.setAttribute("flash_success", "Cart already has maximum stock (" + already + ").");
                    } else {
                        int addQty = Math.min(qty, remaining);
                        cartDAO.addToCart(cus.getCustomer_id(), pid, product.getPrice(), addQty);
                        if (addQty < qty) {
                            session.setAttribute("flash_success", "Added only " + addQty + " item(s) due to stock limit (now " + (already + addQty) + ").");
                        } else {
                            session.setAttribute("flash_success", "Added " + addQty + " item(s) to cart (now " + (already + addQty) + ").");
                        }
                    }
                }
            } catch (Exception ex) {
                session.setAttribute("error", "Failed to add canceled buy-now product to cart.");
            }
        }
        resp.sendRedirect(req.getContextPath() + "/cart");
    }
}
