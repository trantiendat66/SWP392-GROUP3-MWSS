/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.OrderDAO;
import dao.ProductDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;
import model.Order;
import model.Product;
import model.Staff;

/**
 *
 * @author Tran Tien Dat - CE190362
 */
@WebServlet(name = "SearchServlet", urlPatterns = {"/search"})
public class SearchServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet SearchServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet SearchServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

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

        String getAcctive = request.getParameter("active") == null ? "" : request.getParameter("active");
        String keyword = request.getParameter("keyword");
        if (keyword != null) {
            keyword = keyword.trim();
        }

        ///Search for Order
        if (getAcctive.equals("order")) {
            OrderDAO oDao = new OrderDAO();
            List<Order> allOrder = oDao.getAllOrder();
            if (allOrder == null) {
                allOrder = new ArrayList<>();
            }
            request.setAttribute("listAllOrder", allOrder);
            List<Order> searchOrder;
            if (keyword == null || keyword.isEmpty()) {
                searchOrder = allOrder;
                request.setAttribute("keyword", keyword);
            } else {
                searchOrder = oDao.getOrderBySearch(keyword);
                if (searchOrder == null) {
                    searchOrder = new ArrayList<>();
                }
                request.setAttribute("keyword", keyword);
            }
            request.setAttribute("activeTab", "order");
            request.setAttribute("listOrders", searchOrder);
        } else {
            ///Search Product
            ProductDAO dao = new ProductDAO();
            List<Product> allProducts = dao.getAllProducts();
            if (allProducts == null) {
                allProducts = new ArrayList<>();
            }
            request.setAttribute("listAll", allProducts);
            List<Product> searchResult;
            if (keyword == null || keyword.isEmpty()) {
                searchResult = allProducts;
                request.setAttribute("keyword", "");
            } else {
                searchResult = dao.searchProducts(keyword);
                if (searchResult == null) {
                    searchResult = new ArrayList<>();
                }
                request.setAttribute("keyword", keyword);
            }
            request.setAttribute("activeTab", "product");
            request.setAttribute("listP", searchResult);
            request.setAttribute("listProducts", searchResult);
            request.setAttribute("products", searchResult);
        }

        switch (role) {
            case "ADMIN":
                request.getRequestDispatcher("/WEB-INF/admin.jsp").forward(request, response);
                break;
            case "STAFF":
                if (staff != null) {
                    request.setAttribute("staff", staff);
                }
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
