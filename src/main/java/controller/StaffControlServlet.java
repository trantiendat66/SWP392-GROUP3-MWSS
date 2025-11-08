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
import model.OrderDetail;

/**
 *
 * @author Nguyen Thien Dat - CE190879 - 06/05/2005
 */
@WebServlet(name = "StaffControlServlet", urlPatterns = {"/staffcontrol"})
public class StaffControlServlet extends HttpServlet {

    private String generateSearchStringFromSubstrings(String input, int size) {
        StringBuilder sb = new StringBuilder();
        String cleanInput = input.replaceAll("\\s+", "");
        if (cleanInput.length() < size) {
            return "";
        }
        for (int i = 0; i <= cleanInput.length() - size; i++) {
            if (i > 0) {
                sb.append(" ");
            }
            sb.append(cleanInput.substring(i, i + size));
        }
        return sb.toString();
    }

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

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("staff") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Staff loggedInCustomer = (Staff) session.getAttribute("staff");

        // 1. Tải lại dữ liệu Staff (đã có)
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

            // Nếu có filter
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

                // Đảm bảo từ khóa hợp lệ (ít nhất 2 ký tự sau khi bỏ khoảng trắng)
                if (trimmedKeyword.length() >= 2) {
                    // KHÔNG dùng generateSearchStringFromSubstrings. 
                    // Gửi từ khóa gốc vào DAO để nó tìm kiếm LIKE '%keyword%'
                    listProducts = productDAO.searchProducts(trimmedKeyword);
                } else {
                    // Từ khóa quá ngắn (ví dụ: "a"), trả về danh sách rỗng
                    listProducts = new ArrayList<>();
                }
            } else {
                // Không có từ khóa, tải tất cả sản phẩm
                listProducts = productDAO.getAllProducts();
                request.setAttribute("keyword", "");
            }

            request.setAttribute("listProducts", listProducts);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading product data.");
        }

//        Khu này là ListOrder cho thằng Staff quản lý Okela 👈(ﾟヮﾟ👈)
        try {
            OrderDAO orderDao = new OrderDAO();
            List<Order> listOrders = orderDao.getOrderByIdStaff(staff.getAccountId());
            request.setAttribute("listOrders", listOrders);
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        //        Khu này là ListFeedback cho thằng Staff quản lý Okela 👈(ﾟヮﾟ👈)
        try {
            FeedbackDAO feedbackDao = new FeedbackDAO();
            List<FeedbackView> listFeedbacks = feedbackDao.getFeedbackByStaffId(staff.getAccountId());
            request.setAttribute("listFeedbacks", listFeedbacks);
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        // 2. Forward đến JSP
        request.getRequestDispatcher("/WEB-INF/staff.jsp").forward(request, response);
        String activeTab = (String) request.getSession().getAttribute("activeTab");
        if (activeTab != null) {
            request.setAttribute("activeTab", activeTab);
            request.getSession().removeAttribute("activeTab");
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
