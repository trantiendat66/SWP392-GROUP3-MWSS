/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.CartDAO;
import dao.OrderDAO;
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

/**
 *
 * @author Oanh Nguyen
 */
@WebServlet(name = "OrderBuyNowServlet", urlPatterns = {"/order/buy-now"})
public class OrderBuyNowServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("customer") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?next=" + req.getHeader("Referer"));
            return;
        }
        Customer cus = (Customer) session.getAttribute("customer");

        int productId = Integer.parseInt(req.getParameter("product_id"));
        int qty = Math.max(1, Integer.parseInt(req.getParameter("quantity")));

        ProductDAO productDAO = new ProductDAO();
        CartDAO cartDAO = new CartDAO();

        try {
            // Lấy giá hiện tại rồi add vào giỏ
            int price = productDAO.getCurrentPrice(productId);
            boolean ok = cartDAO.addToCart(cus.getCustomer_id(), productId, price, qty);

            if (ok) {
                session.setAttribute("flash_success", "Đã thêm vào giỏ. Vui lòng nhập địa chỉ và chọn hình thức thanh toán để đặt hàng.");
            } else {
                session.setAttribute("error", "Không thể thêm sản phẩm vào giỏ.");
            }
            // Điều hướng sang giỏ hàng để người dùng điền địa chỉ + thanh toán
            resp.sendRedirect(req.getContextPath() + "/cart");
        } catch (SQLException e) {
            session.setAttribute("error", e.getMessage());
            // quay lại trang trước
            String back = req.getHeader("Referer");
            if (back == null) {
                back = req.getContextPath() + "/";
            }
            resp.sendRedirect(back);
        }
    }
}
