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
import model.Product;

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
            // Nếu lỗi và có buy-now pending: cố gắng thêm sản phẩm vào giỏ với giới hạn tồn kho
            Integer pid = (Integer) session.getAttribute("bn_pid");
            Integer qty = (Integer) session.getAttribute("bn_qty");
            if (pid != null && qty != null && qty > 0) {
                try {
                    ProductDAO pdao = new ProductDAO();
                    Product product = pdao.getProductById(pid);
                    if (product != null) {
                        int stock = product.getQuantityProduct();
                        Cart existing = cartDAO.getCartItem(cus.getCustomer_id(), pid);
                        int already = existing != null ? existing.getQuantity() : 0;
                        int remaining = stock - already;
                        if (remaining <= 0) {
                            session.setAttribute("error", "Payment failed; cart already at maximum stock for this product.");
                        } else {
                            int addQty = Math.min(qty, remaining);
                            cartDAO.addToCart(cus.getCustomer_id(), pid, product.getPrice(), addQty);
                            if (addQty < qty) {
                                session.setAttribute("error", "Payment failed; only " + addQty + " added due to stock limit.");
                            } else {
                                session.setAttribute("error", "Payment failed; product added to your cart.");
                            }
                        }
                    } else {
                        session.setAttribute("error", "Payment failed; product not found.");
                    }
                    session.removeAttribute("bn_pid");
                    session.removeAttribute("bn_qty");
                    resp.sendRedirect(req.getContextPath() + "/cart");
                    return;
                } catch (Exception ex) {
                    session.setAttribute("error", "Payment failed; could not move product to cart.");
                    session.removeAttribute("bn_pid");
                    session.removeAttribute("bn_qty");
                    resp.sendRedirect(req.getContextPath() + "/cart");
                    return;
                }
            }
            req.setAttribute("error", e.getMessage());
            req.getRequestDispatcher("/payment.jsp").forward(req, resp);
        }
    }

}
