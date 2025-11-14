package controller;

import dao.ProductDAO;
import dao.AnalyticsDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.Product;
import model.Staff;

@WebServlet(name = "ProductServlet", urlPatterns = {"/product"})
public class ProductServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String role = null;

        if (session != null && session.getAttribute("staff") != null) {
            role = ((Staff) session.getAttribute("staff")).getRole();
        } else if (session != null && session.getAttribute("customer") != null) {
            role = "Customer";
        }

        ProductDAO dao = new ProductDAO();
        List<Product> products = dao.getAllProducts();
        request.setAttribute("products", products);

        // 🔥 Thêm phần này để Load lại Revenue + Top Product khi quay lại Product Management
        if ("Admin".equalsIgnoreCase(role)) {
            AnalyticsDAO analytics = new AnalyticsDAO();
            long totalRevenue = analytics.getTotalRevenue();
            List<model.TopProduct> topProducts = analytics.getTop5Products();

            request.setAttribute("totalRevenue", totalRevenue);
            request.setAttribute("topProducts", topProducts);

            // Đặt Product Management làm tab active
            request.setAttribute("activeTab", "product");
        }

        if ("Admin".equalsIgnoreCase(role)) {
            request.getRequestDispatcher("/WEB-INF/admin.jsp").forward(request, response);
        } else if ("Staff".equalsIgnoreCase(role)) {
            request.getRequestDispatcher("/WEB-INF/staff.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/WEB-INF/home.jsp").forward(request, response);
        }
    }
}
