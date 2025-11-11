/*
 * Document   : Pending Product Servlet
 * Created on : Jan 20, 2025
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
import model.Cart;
import model.Customer;
import model.Product;

/**
 * Pending Product Servlet - Xử lý sản phẩm tạm thời sau khi đăng nhập
 * @author Dang Vi Danh - CE19687
 */
@WebServlet(name = "PendingProductServlet", urlPatterns = {"/pending-product"})
public class PendingProductServlet extends HttpServlet {

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
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    private void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Customer customer = (Customer) session.getAttribute("customer");

        if (customer == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        
        if ("add".equals(action)) {
            addPendingProduct(request, response, customer);
        } else if ("check".equals(action)) {
            checkPendingProduct(request, response);
        } else {
            response.sendRedirect("home");
        }
    }

    private void addPendingProduct(HttpServletRequest request, HttpServletResponse response, Customer customer)
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
                    out.print("{\"success\": false, \"message\": \"Insufficient stock. Only " + product.getQuantityProduct() + " items left.\"}");
                    out.flush();
                    return;
                }
                
                // Kiểm tra nếu sản phẩm đã có trong giỏ hàng, tính tổng số lượng
                Cart existingCart = cartDAO.getCartItem(customer.getCustomer_id(), productId);
                boolean capped = false;
                int remainingAllowable = product.getQuantityProduct();
                if (existingCart != null) {
                    int currentInCart = existingCart.getQuantity();
                    remainingAllowable = product.getQuantityProduct() - currentInCart;
                    if (remainingAllowable <= 0) {
                        response.setContentType("application/json");
                        PrintWriter out = response.getWriter();
                        out.print("{\"success\": false, \"message\": \"You already have the maximum available quantity in your cart.\"}");
                        out.flush();
                        return;
                    }
                    if (quantity > remainingAllowable) {
                        quantity = remainingAllowable;
                        capped = true;
                    }
                }
                
                boolean success = cartDAO.addToCart(customer.getCustomer_id(), productId, product.getPrice(), quantity);
                
                response.setContentType("application/json");
                PrintWriter out = response.getWriter();
                if (success) {
                    if (capped) {
                        out.print("{\"success\": true, \"message\": \"Added limited quantity due to stock. Added " + quantity + " item(s).\"}");
                    } else {
                        out.print("{\"success\": true, \"message\": \"Product added to cart successfully!\"}");
                    }
                } else {
                    out.print("{\"success\": false, \"message\": \"An error occurred while adding the product to the cart.\"}");
                }
                out.flush();
            } else {
                response.setContentType("application/json");
                PrintWriter out = response.getWriter();
                out.print("{\"success\": false, \"message\": \"Product not found.\"}");
                out.flush();
            }
        } catch (NumberFormatException e) {
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            out.print("{\"success\": false, \"message\": \"Invalid input data.\"}");
            out.flush();
        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            out.print("{\"success\": false, \"message\": \"An unexpected error occurred.\"}");
            out.flush();
        }
    }

    private void checkPendingProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        out.print("{\"success\": true, \"message\": \"Pending product check successful.\"}");
        out.flush();
    }
}
