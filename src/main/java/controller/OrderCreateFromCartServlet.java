/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dao.CartDAO;
import dao.OrderDAO;
import dao.ProductDAO;
import jakarta.servlet.http.*;

import java.sql.SQLException;
import java.util.List;

import model.Cart;
import model.Customer;

/**
 *
 * @author Oanh Nguyen
 */
@WebServlet(name = "OrderCreateFromCartServlet", urlPatterns = {"/order/create-from-cart"})
public class OrderCreateFromCartServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("customer") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?next=cart");
            return;
        }
        Customer cus = (Customer) session.getAttribute("customer");

        String address = req.getParameter("shipping_address");
        String phone = req.getParameter("phone");
        if (phone == null || phone.isBlank()) {
            phone = cus.getPhone();
        }

        // payment_method gửi từ form là "0" hoặc "1"
        String methodParam = req.getParameter("payment_method");
        int paymentBit = "1".equals(methodParam) ? 1 : 0; // 0 = COD (chưa thanh toán)

        CartDAO cartDAO = new CartDAO();
        OrderDAO orderDAO = new OrderDAO();

        try {
            // Có buy-now pending hay không?
            Integer bnPid = (Integer) session.getAttribute("bn_pid");
            Integer bnQty = (Integer) session.getAttribute("bn_qty");
            boolean isBuyNow = (bnPid != null && bnQty != null && bnQty > 0);

            List<Cart> items;

            if (isBuyNow) {
                // 👉 KHÔNG add vào giỏ. Build list đơn hàng chỉ với sản phẩm buy-now.
                int price = new ProductDAO().getCurrentPrice(bnPid);
                items = new java.util.ArrayList<>();
                items.add(new Cart(0, cus.getCustomer_id(), bnPid, price, bnQty));
            } else {
                // Checkout từ giỏ ⇒ lấy toàn bộ item trong giỏ
                items = cartDAO.findItemsForCheckout(cus.getCustomer_id());
            }

            int orderId = orderDAO.createOrder(
                    cus.getCustomer_id(),
                    phone,
                    address,
                    paymentBit, // truyền BIT
                    items
            );

            // Dọn state buy-now (nếu có)
            session.removeAttribute("bn_pid");
            session.removeAttribute("bn_qty");

            // 👉 Chỉ clear giỏ khi checkout từ giỏ
            if (!isBuyNow) {
                cartDAO.clearCart(cus.getCustomer_id());
            }

            session.setAttribute("flash_success", "Order #" + orderId + " created successfully!");
            resp.sendRedirect(req.getContextPath() + "/order-success.jsp?orderId=" + orderId);

        } catch (SQLException e) {
            // Nếu lỗi và có buy-now pending: đẩy sản phẩm vào giỏ rồi quay lại giỏ
            Integer pid = (Integer) session.getAttribute("bn_pid");
            Integer qty = (Integer) session.getAttribute("bn_qty");
            if (pid != null && qty != null && qty > 0) {
                try {
                    int price = new ProductDAO().getCurrentPrice(pid);
                    cartDAO.addToCart(cus.getCustomer_id(), pid, price, qty);
                    session.removeAttribute("bn_pid");
                    session.removeAttribute("bn_qty");
                    session.setAttribute("error", "Payment failed, the product has been added to your cart.");
                    resp.sendRedirect(req.getContextPath() + "/cart");
                    return;
                } catch (SQLException ex) {
                    // fallthrough
                }
            }
            req.setAttribute("error", e.getMessage());
            req.getRequestDispatcher("/payment.jsp").forward(req, resp);
        }
    }

}
