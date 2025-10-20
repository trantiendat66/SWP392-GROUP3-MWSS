/*
 * Document   : Admin Dashboard Servlet
 * Created on : Jan 20, 2025
 * Author     : Dang Vi Danh - CE19687
 */
package controller;

import dao.ProductDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.Product;
import model.Staff;

@WebServlet(name = "AdminDashboardServlet", urlPatterns = {"/admin/dashboard"})
public class AdminDashboardServlet extends HttpServlet {

    /**
     * Xử lý GET request - Hiển thị trang admin dashboard
     * 
     * @param request HTTP request
     * @param response HTTP response
     * @throws ServletException nếu có lỗi servlet
     * @throws IOException nếu có lỗi I/O
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        // Kiểm tra session - Admin phải đăng nhập
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("staff") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Kiểm tra role - Chỉ Admin mới được truy cập
        Staff staff = (Staff) session.getAttribute("staff");
        if (staff.getRole() == null || !"Admin".equalsIgnoreCase(staff.getRole())) {
            response.sendRedirect(request.getContextPath() + "/staffcontrol");
            return;
        }

        // Lấy danh sách tất cả sản phẩm từ database
        ProductDAO productDAO = new ProductDAO();
        List<Product> products = productDAO.getAllProducts();
        request.setAttribute("products", products);
        
        // Forward đến trang admin.jsp để hiển thị
        request.getRequestDispatcher("/WEB-INF/admin.jsp").forward(request, response);
    }
}


