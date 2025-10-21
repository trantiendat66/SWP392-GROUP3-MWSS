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
                    out.print("{\"success\": true, \"message\": \"Sản phẩm đã được thêm vào giỏ hàng thành công!\"}");
                } else {
                    out.print("{\"success\": false, \"message\": \"Có lỗi xảy ra khi thêm sản phẩm vào giỏ hàng\"}");
                }
                out.flush();
            } else {
                response.setContentType("application/json");
                PrintWriter out = response.getWriter();
                out.print("{\"success\": false, \"message\": \"Sản phẩm không tồn tại\"}");
                out.flush();
            }
        } catch (NumberFormatException e) {
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            out.print("{\"success\": false, \"message\": \"Dữ liệu đầu vào không hợp lệ\"}");
            out.flush();
        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            out.print("{\"success\": false, \"message\": \"Có lỗi xảy ra\"}");
            out.flush();
        }
    }

    private void checkPendingProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        out.print("{\"success\": true, \"message\": \"Kiểm tra sản phẩm tạm thời thành công\"}");
        out.flush();
    }
}
