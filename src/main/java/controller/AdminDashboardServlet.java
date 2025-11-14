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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Kiểm tra session (chỉ admin mới vào được)
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("staff") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Staff staff = (Staff) session.getAttribute("staff");
        if (staff.getRole() == null || !"Admin".equalsIgnoreCase(staff.getRole())) {
            response.sendRedirect(request.getContextPath() + "/staffcontrol");
            return;
        }

        // Load danh sách sản phẩm để hiển thị trong admin.jsp
        ProductDAO dao = new ProductDAO();
        List<Product> products = dao.getAllProducts();
        request.setAttribute("products", products);

        // Load toàn bộ dữ liệu thống kê thông qua AdminDataServlet
        AdminDataServlet.loadAnalytics(request);

        // Đánh dấu Dashboard là tab đang active
        request.setAttribute("activeTab", "product");


        // Forward sang admin.jsp
        request.getRequestDispatcher("/WEB-INF/admin.jsp").forward(request, response);
    }
}
