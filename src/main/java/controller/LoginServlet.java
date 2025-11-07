/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.CustomerDAO;
import dao.StaffDAO;
import hashpw.MD5PasswordHasher;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.PrintWriter;
import model.Customer;
import model.Staff;

/**
 *
 * @author Nguyen Phi Thuong
 */
@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

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
            out.println("<title>Servlet NewServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet NewServlet at " + request.getContextPath() + "</h1>");
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

        // Kiểm tra đã có session hoạt động chưa
        if (session != null) {
            // Nếu là Customer đã đăng nhập
            if (session.getAttribute("customer") != null) {
                response.sendRedirect(request.getContextPath() + "/home");
                return;
            }
            // Nếu là Staff đã đăng nhập
            if (session.getAttribute("staff") != null) {
                // Chuyển hướng Staff đến trang quản trị chung
                Staff staff = (Staff) session.getAttribute("staff");
                if ("Admin".equalsIgnoreCase(staff.getRole())) {
                    // Admin được chuyển đến trang admin dashboard
                    response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                } else {
                    // Staff thông thường được chuyển đến trang staff control
                    response.sendRedirect(request.getContextPath() + "/staff/orders");
                }
                return;
            }
        }
        // Nếu chưa đăng nhập, chuyển hướng đến trang login.jsp
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    /**
     *
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        CustomerDAO customerDao = new CustomerDAO();
        StaffDAO staffDao = new StaffDAO();

        boolean isAuthenticated = false;
        Object user = null;
        String redirectPath = null;
        String sessionKey = null;

        // --- BƯỚC 1: THỬ ĐĂNG NHẬP VỚI VAI TRÒ KHÁCH HÀNG (CUSTOMER) ---
        Customer customer = customerDao.getCustomerByEmail(email);

        if (customer != null) {

            // ✅ NEW: kiểm tra trạng thái tài khoản trước khi xác thực mật khẩu
            if ("Inactive".equalsIgnoreCase(customer.getAccount_status())) {
                request.setAttribute("error", "Your account has been locked.");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
                return;
            }

            String storedHashedPassword = customer.getPassword();
            isAuthenticated = MD5PasswordHasher.checkPassword(password, storedHashedPassword);

            if (isAuthenticated) {
                user = customer;
                sessionKey = "customer";
                // Kiểm tra có sản phẩm tạm thời không (thông qua parameter hoặc session)
                String hasPendingProduct = request.getParameter("hasPendingProduct");
                if ("true".equals(hasPendingProduct)) {
                    redirectPath = request.getContextPath() + "/pending-product";
                } else {
                    redirectPath = request.getContextPath() + "/home";
                }
            }
        }

        // --- BƯỚC 2: NẾU KHÔNG PHẢI KHÁCH HÀNG, THỬ ĐĂNG NHẬP VỚI VAI TRÒ NHÂN VIÊN (STAFF) ---
        if (!isAuthenticated) {
            Staff staff = staffDao.getStaffByEmail(email);

            if (staff != null) {
                String storedHashedPassword = staff.getPassword();
                isAuthenticated = MD5PasswordHasher.checkPassword(password, storedHashedPassword);

                if (isAuthenticated) {
                    user = staff;
                    sessionKey = "staff"; // Key session cho Staff

                    // PHÂN QUYỀN CHUYỂN HƯỚNG DỰA TRÊN ROLE
                    if ("Admin".equalsIgnoreCase(staff.getRole())) {
                        // Admin được chuyển đến trang admin dashboard (có đầy đủ quyền quản lý sản phẩm)
                        redirectPath = request.getContextPath() + "/admin/dashboard";
                    } else {
                        // Staff thông thường được chuyển đến trang staff control (quyền hạn chế)
                        redirectPath = request.getContextPath() + "/staffcontrol";
                    }
                }
            }
        }

        // --- BƯỚC 3: XỬ LÝ KẾT QUẢ ĐĂNG NHẬP ---
        if (isAuthenticated) {
            HttpSession session = request.getSession();

            // Đặt đối tượng (Customer HOẶC Staff) vào session
            session.setAttribute(sessionKey, user);

            response.sendRedirect(redirectPath);
        } else {
            // Đăng nhập thất bại (sai email hoặc mật khẩu)
            request.setAttribute("error", "Invalid email or password!");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }

}
