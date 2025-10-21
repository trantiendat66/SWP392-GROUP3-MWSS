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
 * @author Dang Vi Danh
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

    // Hiển thị giỏ hàng của khách hàng
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

    // Thêm sản phẩm vào giỏ hàng
    private void addToCart(HttpServletRequest request, HttpServletResponse response, Customer customer)
            throws ServletException, IOException {
        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            
            Product product = productDAO.getProductById(productId);
            if (product != null) {
                // Kiểm tra số lượng sản phẩm trong kho
                if (quantity > product.getQuantityProduct()) {
                    response.setContentType("application/json");
                    PrintWriter out = response.getWriter();
                    out.print("{\"success\": false, \"message\": \"Số lượng sản phẩm trong kho không đủ. Chỉ còn " + product.getQuantityProduct() + " sản phẩm\"}");
                    out.flush();
                    return;
                }
                
                // Kiểm tra nếu sản phẩm đã có trong giỏ hàng, tính tổng số lượng
                Cart existingCart = cartDAO.getCartItem(customer.getCustomer_id(), productId);
                if (existingCart != null) {
                    int totalQuantity = existingCart.getQuantity() + quantity;
                    if (totalQuantity > product.getQuantityProduct()) {
                        response.setContentType("application/json");
                        PrintWriter out = response.getWriter();
                        out.print("{\"success\": false, \"message\": \"Tổng số lượng vượt quá số lượng trong kho. Chỉ còn " + product.getQuantityProduct() + " sản phẩm\"}");
                        out.flush();
                        return;
                    }
                }
                
                boolean success = cartDAO.addToCart(customer.getCustomer_id(), productId, product.getPrice(), quantity);
                
                response.setContentType("application/json");
                PrintWriter out = response.getWriter();
                if (success) {
                    // Lấy số lượng sản phẩm mới trong giỏ hàng
                    int newCartCount = cartDAO.getCartItemCount(customer.getCustomer_id());
                    
                    // Trả về JSON response cho AJAX với thông báo tiếng Anh
                    out.print("{\"success\": true, \"message\": \"Product added to cart successfully!\", \"cartCount\": " + newCartCount + "}");
                } else {
                    out.print("{\"success\": false, \"message\": \"Error occurred while adding product to cart\"}");
                }
                out.flush();
            } else {
                response.setContentType("application/json");
                PrintWriter out = response.getWriter();
                out.print("{\"success\": false, \"message\": \"Product not found\"}");
                out.flush();
            }
        } catch (NumberFormatException e) {
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            out.print("{\"success\": false, \"message\": \"Invalid input data\"}");
            out.flush();
        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            out.print("{\"success\": false, \"message\": \"An unexpected error occurred\"}");
            out.flush();
        }
    }

    // Cập nhật số lượng sản phẩm trong giỏ hàng
    private void updateCart(HttpServletRequest request, HttpServletResponse response, Customer customer)
            throws ServletException, IOException {
        try {
            int cartId = Integer.parseInt(request.getParameter("cartId"));
            int newQuantity = Integer.parseInt(request.getParameter("quantity"));
            
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();

            if (newQuantity <= 0) {
                // Nếu số lượng <= 0, xóa item khỏi giỏ hàng
                boolean success = cartDAO.removeFromCart(cartId);
                if (success) {
                    out.print("{\"success\": true, \"message\": \"Item removed from cart\"}");
                } else {
                    out.print("{\"success\": false, \"message\": \"Error occurred while removing item\"}");
                }
            } else {
                // Kiểm tra số lượng sản phẩm trong kho trước khi cập nhật
                Cart cartItem = cartDAO.getCartItemById(cartId);
                if (cartItem != null) {
                    Product product = productDAO.getProductById(cartItem.getProductId());
                    if (product != null && newQuantity > product.getQuantityProduct()) {
                        out.print("{\"success\": false, \"message\": \"Số lượng sản phẩm trong kho không đủ. Chỉ còn " + product.getQuantityProduct() + " sản phẩm\"}");
                        out.flush();
                        return;
                    }
                }
                
                boolean success = cartDAO.updateCartQuantity(cartId, newQuantity);
                if (success) {
                    out.print("{\"success\": true, \"message\": \"Quantity updated successfully\"}");
                } else {
                    out.print("{\"success\": false, \"message\": \"Error occurred while updating quantity\"}");
                }
            }
            out.flush();
        } catch (NumberFormatException e) {
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            out.print("{\"success\": false, \"message\": \"Invalid input data\"}");
            out.flush();
        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            out.print("{\"success\": false, \"message\": \"An unexpected error occurred\"}");
            out.flush();
        }
    }

    // Xóa một sản phẩm khỏi giỏ hàng
    private void removeFromCart(HttpServletRequest request, HttpServletResponse response, Customer customer)
            throws ServletException, IOException {
        try {
            int cartId = Integer.parseInt(request.getParameter("cartId"));
            boolean success = cartDAO.removeFromCart(cartId);
            
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            if (success) {
                out.print("{\"success\": true, \"message\": \"Item removed from cart\"}");
            } else {
                out.print("{\"success\": false, \"message\": \"Error occurred while removing item\"}");
            }
            out.flush();
        } catch (NumberFormatException e) {
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            out.print("{\"success\": false, \"message\": \"Invalid input data\"}");
            out.flush();
        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            out.print("{\"success\": false, \"message\": \"An unexpected error occurred\"}");
            out.flush();
        }
    }

    // Xóa toàn bộ giỏ hàng
    private void clearCart(HttpServletRequest request, HttpServletResponse response, Customer customer)
            throws ServletException, IOException {
        try {
            boolean success = cartDAO.clearCart(customer.getCustomer_id());
            
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            if (success) {
                out.print("{\"success\": true, \"message\": \"All items removed from cart\"}");
            } else {
                out.print("{\"success\": false, \"message\": \"Error occurred while clearing cart\"}");
            }
            out.flush();
        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            out.print("{\"success\": false, \"message\": \"An unexpected error occurred\"}");
            out.flush();
        }
    }

    // Lấy tổng số lượng sản phẩm trong giỏ hàng
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
