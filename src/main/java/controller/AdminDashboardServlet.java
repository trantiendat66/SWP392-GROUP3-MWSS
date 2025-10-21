/*
 * Document   : Admin Dashboard Servlet
 * Created on : Jan 20, 2025
 * Author     : Dang Vi Danh - CE19687
 */
package controller;

import dao.ProductDAO;
import dao.AnalyticsDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import model.Product;
import model.Staff;
import model.TopProduct;

@WebServlet(name = "AdminDashboardServlet", urlPatterns = {"/admin/dashboard"})
public class AdminDashboardServlet extends HttpServlet {

   
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

        // Lấy danh sách sản phẩm từ database (có thể có tìm kiếm)
        ProductDAO productDAO = new ProductDAO();
        String keyword = request.getParameter("keyword");
        List<Product> products;
        
        if (keyword != null && !keyword.trim().isEmpty()) {
            products = productDAO.searchProducts(keyword.trim());
        } else {
            products = productDAO.getAllProducts();
        }
        
        // Lấy dữ liệu thống kê động
        AnalyticsDAO analyticsDAO = new AnalyticsDAO();
        
        // Tính tổng doanh thu
        long totalRevenue = analyticsDAO.getTotalRevenue();
        
        // Lấy top 5 sản phẩm bán chạy
        List<TopProduct> topProducts = analyticsDAO.getTop5Products();
        
        // Lấy dữ liệu biểu đồ doanh thu theo tháng
        Map<String, Long> monthlyRevenue = analyticsDAO.getMonthlyRevenueChart();
        
        // Lấy các thống kê khác
        long currentMonthRevenue = analyticsDAO.getCurrentMonthRevenue();
        long currentYearRevenue = analyticsDAO.getCurrentYearRevenue();
        int totalCompletedOrders = analyticsDAO.getTotalCompletedOrders();
        int totalActiveCustomers = analyticsDAO.getTotalActiveCustomers();
        
        // Set attributes cho JSP
        request.setAttribute("products", products);
        request.setAttribute("keyword", keyword);
        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("topProducts", topProducts);
        request.setAttribute("monthlyRevenue", monthlyRevenue);
        request.setAttribute("currentMonthRevenue", currentMonthRevenue);
        request.setAttribute("currentYearRevenue", currentYearRevenue);
        request.setAttribute("totalCompletedOrders", totalCompletedOrders);
        request.setAttribute("totalActiveCustomers", totalActiveCustomers);
        
        // Forward đến trang admin.jsp để hiển thị
        request.getRequestDispatcher("/WEB-INF/admin.jsp").forward(request, response);
    }
}


