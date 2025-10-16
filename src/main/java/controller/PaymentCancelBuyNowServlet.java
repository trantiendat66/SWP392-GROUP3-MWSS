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
import model.Customer;

/**
 *
 * @author Oanh Nguyen
 */
@WebServlet(name="PaymentCancelBuyNowServlet", urlPatterns={"/payment/cancel-buynow"})
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
                int price = new ProductDAO().getCurrentPrice(pid);
                new CartDAO().addToCart(cus.getCustomer_id(), pid, price, qty);
                session.setAttribute("flash_success", "Đã thêm sản phẩm vào giỏ hàng.");
            } catch (SQLException e) {
                session.setAttribute("error", "Không thể thêm vào giỏ: " + e.getMessage());
            }
        }
        resp.sendRedirect(req.getContextPath() + "/cart");
    }
}
