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
        
        ProductDAO dao = new ProductDAO();
        List<Product> products = dao.getAllProducts();
        request.setAttribute("products", products);
      
        AnalyticsDAO analyticsDAO = new AnalyticsDAO();
        long totalRevenue = analyticsDAO.getTotalRevenue();
        List<TopProduct> topProducts = analyticsDAO.getTop5Products();
        Map<String, Long> monthlyRevenue = analyticsDAO.getMonthlyRevenueChart();
        long currentMonthRevenue = analyticsDAO.getCurrentMonthRevenue();
        long currentYearRevenue = analyticsDAO.getCurrentYearRevenue();
        int totalCompletedOrders = analyticsDAO.getTotalCompletedOrders();
        int totalActiveCustomers = analyticsDAO.getTotalActiveCustomers();

        request.setAttribute("keyword", "");
        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("topProducts", topProducts);
        request.setAttribute("monthlyRevenue", monthlyRevenue);
        request.setAttribute("currentMonthRevenue", currentMonthRevenue);
        request.setAttribute("currentYearRevenue", currentYearRevenue);
        request.setAttribute("totalCompletedOrders", totalCompletedOrders);
        request.setAttribute("totalActiveCustomers", totalActiveCustomers);
        request.getRequestDispatcher("/WEB-INF/admin.jsp").forward(request, response);
    }
}
