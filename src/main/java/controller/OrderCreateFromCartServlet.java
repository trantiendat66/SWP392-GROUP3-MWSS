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
        int paymentBit = "1".equals(methodParam) ? 1 : 0; // mặc định 0 = COD/chưa thanh toán

        CartDAO cartDAO = new CartDAO();
        OrderDAO orderDAO = new OrderDAO();

        try {
            List<Cart> items = cartDAO.findItemsForCheckout(cus.getCustomer_id());
            int orderId = orderDAO.createOrder(
                    cus.getCustomer_id(),
                    phone,
                    address,
                    paymentBit, // <-- truyền BIT
                    items
            );
            cartDAO.clearCart(cus.getCustomer_id());

            session.setAttribute("flash_success", "Tạo đơn hàng #" + orderId + " thành công!");
            resp.sendRedirect(req.getContextPath() + "/order-success.jsp?orderId=" + orderId);
        } catch (SQLException e) {
            req.setAttribute("error", e.getMessage());
            req.getRequestDispatcher("/WEB-INF/cart.jsp").forward(req, resp);
        }
    }
}
