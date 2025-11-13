/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.FeedbackDAO;
import dao.OrderDAO;
import dao.StaffDAO;
import dao.ProductDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import model.Staff;
import model.Product;
import java.util.List;
import model.FeedbackView;
import model.Order;

/**
 *
 * @author Nguyen Thien Dat - CE190879 - 06/05/2005
 */
@WebServlet(name = "StaffControlServlet", urlPatterns = {"/staffcontrol"})
public class StaffControlServlet extends HttpServlet {

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
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null || (session.getAttribute("staff") == null && session.getAttribute("admin") == null)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Staff loggedInCustomer = null;

        // Nếu là nhân viên
        if (session.getAttribute("staff") != null) {
            loggedInCustomer = (Staff) session.getAttribute("staff");
        } // Nếu là admin
        else if (session.getAttribute("admin") != null) {
            loggedInCustomer = (Staff) session.getAttribute("admin");
        }
        String getActive = request.getParameter("active") == null ? "staff" : request.getParameter("active");

        StaffDAO staffDAO = new StaffDAO();
        Staff staff = staffDAO.getStaffByEmail(loggedInCustomer.getEmail());
        request.setAttribute("staff", staff);
        try {
            ProductDAO productDAO = new ProductDAO();
            List<Product> listProducts;

            String keyword = request.getParameter("keyword");
            String brand = request.getParameter("brand");
            String gender = request.getParameter("gender");
            String priceRange = request.getParameter("priceRange");
            int minPrice = 0;
            int maxPrice = 0;

            if (priceRange != null && !priceRange.isEmpty()) {
                if (priceRange.contains("-")) {
                    String[] parts = priceRange.split("-");
                    minPrice = Integer.parseInt(parts[0]);
                    maxPrice = Integer.parseInt(parts[1]);
                } else if (priceRange.endsWith("+")) {
                    minPrice = Integer.parseInt(priceRange.replace("+", ""));
                    maxPrice = 0; // 0 nghĩa là không giới hạn trên
                }
            }

            if ((brand != null && !brand.isEmpty())
                    || (gender != null && !gender.isEmpty())
                    || (priceRange != null && !priceRange.isEmpty())) {

                listProducts = productDAO.filterProducts(brand, gender, minPrice, maxPrice);
                request.setAttribute("brand", brand);
                request.setAttribute("gender", gender);
                request.setAttribute("priceRange", priceRange);
            } else if (keyword != null && !keyword.trim().isEmpty()) {
                String trimmedKeyword = keyword.trim();
                request.setAttribute("keyword", trimmedKeyword);

                if (trimmedKeyword.length() >= 2) {

                    listProducts = productDAO.searchProducts(trimmedKeyword);
                } else {

                    listProducts = new ArrayList<>();
                }
            } else {

                listProducts = productDAO.getAllProducts();
                request.setAttribute("keyword", "");
            }
            request.setAttribute("listProducts", listProducts);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading product data.");
        }

        if (getActive.equals("order")) {
            OrderDAO orderDao = new OrderDAO();
            List<Order> listOrders = orderDao.getOrderByIdStaff(staff.getAccountId());
            request.setAttribute("activeTab", "order");
            request.setAttribute("listOrders", listOrders);
        } else if (getActive.equals("feedback")) {
            FeedbackDAO feedbackDao = new FeedbackDAO();
            List<FeedbackView> listFeedbacks = feedbackDao.getFeedbackByStaffId(staff.getAccountId());
            request.setAttribute("activeTab", "feedback");
            request.setAttribute("listFeedbacks", listFeedbacks);
        } else {
            ProductDAO productDAO = new ProductDAO();
            List<Product> listProducts = productDAO.getAllProducts();
            request.setAttribute("activeTab", "product");
            request.setAttribute("listProducts", listProducts);
        }
//        else if (getActive.equals("product")) {
//            ProductDAO productDAO = new ProductDAO();
//            List<Product> listProducts = productDAO.getAllProducts();
//            request.setAttribute("activeTab", "product");
//            request.setAttribute("listProducts", listProducts);
//        }

        if (getActive.equals("admin")) {
            FeedbackDAO feedbackDao = new FeedbackDAO();
            List<FeedbackView> listFeedbacks = feedbackDao.getAllFeedback();
            request.setAttribute("listFeedbacks", listFeedbacks);
            request.setAttribute("activeTab", "feedback");
            request.getRequestDispatcher("/WEB-INF/admin.jsp").forward(request, response);
        } else if (getActive.equals("admino")) {
            OrderDAO orderDao = new OrderDAO();
            List<Order> listOrders = orderDao.getAllOrder();
            request.setAttribute("listOrders", listOrders);
            request.setAttribute("activeTab", "order");
            request.getRequestDispatcher("/WEB-INF/admin.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/WEB-INF/staff.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        FeedbackDAO dao = new FeedbackDAO();
        int feedbackId = Integer.parseInt(request.getParameter("feedbackId"));
        boolean success = dao.hideFeedback(feedbackId);

        response.setContentType("application/json");
        response.getWriter().write("{\"success\": " + success + "}");
    }

    @Override
    public String getServletInfo() {
        return "Controls Staff Dashboard access and loads initial data (Staff profile, Product List)";
    }

}
