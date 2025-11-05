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
        
        AnalyticsDAO analyticsDAO = new AnalyticsDAO(); 
        long totalRevenue = analyticsDAO.getTotalRevenue();
        List<TopProduct> topProducts = analyticsDAO.getTop5Products();
        Map<String, Long> monthlyRevenue = analyticsDAO.getMonthlyRevenueChart();
        
        long currentMonthRevenue = analyticsDAO.getCurrentMonthRevenue();
        long currentYearRevenue = analyticsDAO.getCurrentYearRevenue();
        int totalCompletedOrders = analyticsDAO.getTotalCompletedOrders();
        int totalActiveCustomers = analyticsDAO.getTotalActiveCustomers();
        
        request.setAttribute("products", products);
        request.setAttribute("keyword", keyword);
        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("topProducts", topProducts);
        request.setAttribute("monthlyRevenue", monthlyRevenue);
        request.setAttribute("currentMonthRevenue", currentMonthRevenue);
        request.setAttribute("currentYearRevenue", currentYearRevenue);
        request.setAttribute("totalCompletedOrders", totalCompletedOrders);
        request.setAttribute("totalActiveCustomers", totalActiveCustomers);
        
        System.out.println("AdminDashboardServlet: keyword=" + keyword + ", products found=" + (products == null ? 0 : products.size()));
        request.setAttribute("products", products);
        request.setAttribute("keyword", keyword);
        request.getRequestDispatcher("/WEB-INF/admin.jsp").forward(request, response);
    }
}


