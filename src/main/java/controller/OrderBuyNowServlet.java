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

        // ĐÁNH DẤU Buy-Now đang chờ thanh toán (KHÔNG thêm vào cart)
        session.setAttribute("bn_pid", productId);
        session.setAttribute("bn_qty", qty);

        // tới trang payment
        resp.sendRedirect(req.getContextPath() + "/payment?bn=1");
    }
}
