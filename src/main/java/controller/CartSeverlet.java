/*
 * Document   : Cart Servlet
 * Created on : Jan 10, 2025
 * Author     : Dang Vi Danh - CE19687
 */
package controller;

import dao.CartDAO;
import dao.ProductDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Customer;
import model.Product;

/**
 * Cart Servlet - Controller for Cart operations
 * Handles all cart-related HTTP requests and responses
 * @author Dang Vi Danh - CE19687
 */
@WebServlet(name = "CartServlet", urlPatterns = {"/cart"})
public class CartServlet extends HttpServlet {

    private CartDAO cartDAO;
    private ProductDAO productDAO;

    @Override
    public void init() throws ServletException {
        cartDAO = new CartDAO();
        productDAO = new ProductDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "view";
        }

        HttpSession session = request.getSession();
        Customer customer = (Customer) session.getAttribute("customer");

        if (customer == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        switch (action) {
            case "view":
                viewCart(request, response, customer);
                break;
            case "add":
                addToCart(request, response, customer);
                break;
            case "update":
                updateCart(request, response, customer);
                break;
            case "remove":
                removeFromCart(request, response, customer);
                break;
            case "clear":
                clearCart(request, response, customer);
                break;
            case "count":
                getCartCount(request, response, customer);
                break;
            default:
                viewCart(request, response, customer);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    private void viewCart(HttpServletRequest request, HttpServletResponse response, Customer customer)
            throws ServletException, IOException {
        try {
            var cartItems = cartDAO.getCartByCustomerId(customer.getCustomer_id());
            int totalAmount = cartDAO.getCartTotal(customer.getCustomer_id());
            
            request.setAttribute("cartItems", cartItems);
            request.setAttribute("totalAmount", totalAmount);
            request.setAttribute("cartItemCount", cartItems.size());
            
            request.getRequestDispatcher("WEB-INF/cart.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("home");
        }
    }

    private void addToCart(HttpServletRequest request, HttpServletResponse response, Customer customer)
            throws ServletException, IOException {
        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            
            Product product = productDAO.getProductById(productId);
            if (product != null) {
                boolean success = cartDAO.addToCart(customer.getCustomer_id(), productId, product.getPrice(), quantity);
                
                if (success) {
                    // Trả về JSON response cho AJAX
                    response.setContentType("application/json");
                    PrintWriter out = response.getWriter();
                    out.print("{\"success\": true, \"message\": \"Đã thêm sản phẩm vào giỏ hàng\"}");
                    out.flush();
                } else {
                    response.setContentType("application/json");
                    PrintWriter out = response.getWriter();
                    out.print("{\"success\": false, \"message\": \"Có lỗi xảy ra khi thêm sản phẩm\"}");
                    out.flush();
                }
            } else {
                response.setContentType("application/json");
                PrintWriter out = response.getWriter();
                out.print("{\"success\": false, \"message\": \"Sản phẩm không tồn tại\"}");
                out.flush();
            }
        } catch (NumberFormatException e) {
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            out.print("{\"success\": false, \"message\": \"Dữ liệu không hợp lệ\"}");
            out.flush();
        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            out.print("{\"success\": false, \"message\": \"Có lỗi xảy ra\"}");
            out.flush();
        }
    }

    private void updateCart(HttpServletRequest request, HttpServletResponse response, Customer customer)
            throws ServletException, IOException {
        try {
            int cartId = Integer.parseInt(request.getParameter("cartId"));
            int newQuantity = Integer.parseInt(request.getParameter("quantity"));
            
            if (newQuantity <= 0) {
                // Nếu số lượng <= 0, xóa item khỏi giỏ hàng
                boolean success = cartDAO.removeFromCart(cartId);
                response.setContentType("application/json");
                PrintWriter out = response.getWriter();
                if (success) {
                    out.print("{\"success\": true, \"message\": \"Đã xóa sản phẩm khỏi giỏ hàng\"}");
                } else {
                    out.print("{\"success\": false, \"message\": \"Có lỗi xảy ra khi xóa sản phẩm\"}");
                }
                out.flush();
            } else {
                boolean success = cartDAO.updateCartQuantity(cartId, newQuantity);
                response.setContentType("application/json");
                PrintWriter out = response.getWriter();
                if (success) {
                    out.print("{\"success\": true, \"message\": \"Đã cập nhật số lượng\"}");
                } else {
                    out.print("{\"success\": false, \"message\": \"Có lỗi xảy ra khi cập nhật\"}");
                }
                out.flush();
            }
        } catch (NumberFormatException e) {
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            out.print("{\"success\": false, \"message\": \"Dữ liệu không hợp lệ\"}");
            out.flush();
        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            out.print("{\"success\": false, \"message\": \"Có lỗi xảy ra\"}");
            out.flush();
        }
    }

    private void removeFromCart(HttpServletRequest request, HttpServletResponse response, Customer customer)
            throws ServletException, IOException {
        try {
            int cartId = Integer.parseInt(request.getParameter("cartId"));
            boolean success = cartDAO.removeFromCart(cartId);
            
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            if (success) {
                out.print("{\"success\": true, \"message\": \"Đã xóa sản phẩm khỏi giỏ hàng\"}");
            } else {
                out.print("{\"success\": false, \"message\": \"Có lỗi xảy ra khi xóa sản phẩm\"}");
            }
            out.flush();
        } catch (NumberFormatException e) {
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            out.print("{\"success\": false, \"message\": \"Dữ liệu không hợp lệ\"}");
            out.flush();
        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            out.print("{\"success\": false, \"message\": \"Có lỗi xảy ra\"}");
            out.flush();
        }
    }

    private void clearCart(HttpServletRequest request, HttpServletResponse response, Customer customer)
            throws ServletException, IOException {
        try {
            boolean success = cartDAO.clearCart(customer.getCustomer_id());
            
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            if (success) {
                out.print("{\"success\": true, \"message\": \"Đã xóa tất cả sản phẩm khỏi giỏ hàng\"}");
            } else {
                out.print("{\"success\": false, \"message\": \"Có lỗi xảy ra khi xóa giỏ hàng\"}");
            }
            out.flush();
        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            out.print("{\"success\": false, \"message\": \"Có lỗi xảy ra\"}");
            out.flush();
        }
    }

    private void getCartCount(HttpServletRequest request, HttpServletResponse response, Customer customer)
            throws ServletException, IOException {
        try {
            int count = cartDAO.getCartItemCount(customer.getCustomer_id());
            
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            out.print("{\"count\": " + count + "}");
            out.flush();
        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            out.print("{\"count\": 0}");
            out.flush();
        }
    }
}
