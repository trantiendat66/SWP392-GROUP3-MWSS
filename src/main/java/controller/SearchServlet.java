package controller;

import dao.BrandDAO;
import dao.OrderDAO;
import dao.ProductDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import model.Brand;
import model.Order;
import model.Product;
import model.Staff;

@WebServlet(name = "SearchServlet", urlPatterns = {"/search"})
public class SearchServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Object sessionUser = null;

        if (session != null) {
            sessionUser = session.getAttribute("staff");
            if (sessionUser == null) {
                sessionUser = session.getAttribute("user");
            }
        }

        String role = "CUSTOMER";
        Staff staff = null;

        if (sessionUser instanceof Staff) {
            staff = (Staff) sessionUser;
            if (staff.getRole() != null) {
                role = staff.getRole().toUpperCase();
            } else {
                role = "STAFF";
            }
        }

        String getActive = request.getParameter("active") == null ? "" : request.getParameter("active");
        String keyword = request.getParameter("keyword");
        if (keyword != null) {
            keyword = keyword.trim();
        }

        // ==============================
        // Nếu là Admin → luôn load Analytics
        // ==============================
        if ("ADMIN".equals(role)) {
            AdminDataServlet.loadAnalytics(request);
        }

        // ==============================
        // SEARCH ORDER
        // ==============================
        if (getActive.equals("order")) {

            OrderDAO oDao = new OrderDAO();
            List<Order> allOrder = oDao.getAllOrder();
            if (allOrder == null) allOrder = new ArrayList<>();

            List<Order> searchOrder;

            if (keyword == null || keyword.isEmpty()) {
                searchOrder = allOrder;
            } else {
                searchOrder = oDao.getOrderBySearch(keyword);
                if (searchOrder == null) searchOrder = new ArrayList<>();
            }

            request.setAttribute("keyword", keyword);
            request.setAttribute("activeTab", "order");
            request.setAttribute("listOrders", searchOrder);

        } else {
            // ==============================
            // SEARCH PRODUCT
            // ==============================
            ProductDAO dao = new ProductDAO();
            BrandDAO bdao = new BrandDAO();

            List<Brand> listB = bdao.getAllBrand();
            List<Product> allProducts = dao.getAllProducts();
            if (allProducts == null) allProducts = new ArrayList<>();

            List<Product> searchResult;

            if (keyword == null || keyword.isEmpty()) {
                searchResult = allProducts;
            } else {
                searchResult = dao.searchProducts(keyword);
                if (searchResult == null) searchResult = new ArrayList<>();
            }

            request.setAttribute("keyword", keyword);
            request.setAttribute("activeTab", "product");
            request.setAttribute("listBrands", listB);
            request.setAttribute("products", searchResult);
            request.setAttribute("listProducts", searchResult);
            request.setAttribute("listP", searchResult);
        }

        // ==============================
        // FORWARD THEO ROLE
        // ==============================
        switch (role) {
            case "ADMIN":
                request.getRequestDispatcher("/WEB-INF/admin.jsp").forward(request, response);
                break;

            case "STAFF":
                request.setAttribute("staff", staff);
                request.getRequestDispatcher("/WEB-INF/staff.jsp").forward(request, response);
                break;

            default:
                request.getRequestDispatcher("/WEB-INF/home.jsp").forward(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
