/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.CartDAO;
import dao.OrderDAO;
import dao.ProductDAO;
import model.Cart;
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

        int productId = 0;
        int qty = 1;
        try {
            String pidStr = req.getParameter("product_id");
            String qtyStr = req.getParameter("quantity");
            productId = pidStr != null ? Integer.parseInt(pidStr) : 0;
            qty = qtyStr != null ? Math.max(1, Integer.parseInt(qtyStr)) : 1;
        } catch (NumberFormatException nfe) {
            // ignore, defaults applied
        }

        // Detailed logging of incoming parameters to help debug quantity issues
        System.out.println("=== OrderBuyNowServlet ===");
        System.out.println("Request parameters:");
        req.getParameterMap().forEach((k, v) -> System.out.println("  " + k + " = " + java.util.Arrays.toString(v)));
        System.out.println("Parsed productId=" + productId + ", quantity=" + qty);

        // Kiểm tra sản phẩm có tồn tại và còn hàng không
        ProductDAO productDAO = new ProductDAO();
        model.Product product = productDAO.getProductById(productId);
        
        if (product == null) {
            session.setAttribute("errorMessage", "Product not found");
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }
        
        if (product.getQuantityProduct() <= 0) {
            session.setAttribute("errorMessage", "Product is out of stock");
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }

        // Kiểm tra số lượng không vượt quá stock
        if (qty > product.getQuantityProduct()) {
            System.out.println("Quantity exceeded stock, adjusting from " + qty + " to " + product.getQuantityProduct());
            qty = product.getQuantityProduct();
        }

        // ĐÁNH DẤU Buy-Now đang chờ thanh toán (KHÔNG thêm vào cart)
        // Sử dụng số lượng mà user đã chọn
        session.setAttribute("bn_pid", productId);
        session.setAttribute("bn_qty", qty);
        
        System.out.println("Set session bn_pid=" + productId + ", bn_qty=" + qty);

        // tới trang payment
        resp.sendRedirect(req.getContextPath() + "/payment?bn=1");
    }
}
