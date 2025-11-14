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

        // Load danh sách sản phẩm
        ProductDAO dao = new ProductDAO();
        List<Product> products = dao.getAllProducts();
        request.setAttribute("products", products);

        // Nếu Admin → load đầy đủ Analytics (Revenue + Top products + Chart + Monthly + Year…)
        if ("Admin".equalsIgnoreCase(role)) {

            // Gọi hàm nạp dữ liệu phân tích dùng chung
            AdminDataServlet.loadAnalytics(request);

            // Đặt tab hiện tại
            request.setAttribute("activeTab", "product");

            // Forward về admin.jsp
            request.getRequestDispatcher("/WEB-INF/admin.jsp").forward(request, response);
            return;
        }

        // Nếu Staff
        if ("Staff".equalsIgnoreCase(role)) {
            request.getRequestDispatcher("/WEB-INF/staff.jsp").forward(request, response);
            return;
        }

        // Nếu Customer
        request.getRequestDispatcher("/WEB-INF/home.jsp").forward(request, response);
    }
}
