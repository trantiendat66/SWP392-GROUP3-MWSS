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

/**
 *
 * @author Tran Tien Dat - CE190362
 */
@WebServlet(name = "ProductServlet", urlPatterns = {"/product"})
public class ProductServlet extends HttpServlet {
    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">

    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
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

        // Nếu Admin load đầy đủ Analytics (Revenue + Top products + Chart + Monthly + Year…)
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
