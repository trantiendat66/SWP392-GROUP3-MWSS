package controller;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
import dao.CustomerDAO;
import hashpw.MD5PasswordHasher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Date;
import java.security.MessageDigest;
import java.math.BigInteger;
import model.Customer;
import model.Staff;

/**
 *
 * @author Cola
 */
@WebServlet(name = "EditCustomerServlet", urlPatterns = {"/edit_customer"})
public class EditCustomerServlet extends HttpServlet {

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
            out.println("<title>Servlet EditCustomerServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet EditCustomerServlet at " + request.getContextPath() + "</h1>");
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
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Staff staff = (Staff) session.getAttribute("staff");
        if (staff == null || !"Admin".equalsIgnoreCase(staff.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/customerlist");
            return;
        }

        CustomerDAO dao = new CustomerDAO();
        Customer customer = dao.getCustomerById(Integer.parseInt(idParam));
        if (customer == null) {
            response.sendRedirect(request.getContextPath() + "/admin/customerlist");
            return;
        }

        request.setAttribute("customer", customer);
        request.getRequestDispatcher("/admin_edit_customer.jsp")
                .forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // 1. Check login + quyền Admin
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Staff staff = (Staff) session.getAttribute("staff");
        if (staff == null || !"Admin".equalsIgnoreCase(staff.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        CustomerDAO dao = new CustomerDAO();

        // 2. Lấy id customer từ form
        String idFromForm = request.getParameter("customerID");
        if (idFromForm == null || idFromForm.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/customerlist");
            return;
        }

        int customerId = Integer.parseInt(idFromForm);
        Customer c = dao.getCustomerById(customerId);
        if (c == null) {
            response.sendRedirect(request.getContextPath() + "/admin/customerlist");
            return;
        }

        // 3. Chỉ lấy 2 field: status + password
        String accountStatus = request.getParameter("account_status");
        String rawPassword = request.getParameter("password");

        // Validate status
        if (accountStatus == null || accountStatus.trim().isEmpty()) {
            request.setAttribute("statusError", "Please choose account status.");
            request.setAttribute("customer", c);
            request.getRequestDispatcher("/admin_edit_customer.jsp").forward(request, response);
            return;
        }

        String statusTrim = accountStatus.trim();

        // Hash password nếu có nhập
        String hashedPassword = null;
        if (rawPassword != null && !rawPassword.trim().isEmpty()) {
            hashedPassword = MD5PasswordHasher.hashPassword(rawPassword.trim());
            if (hashedPassword == null) {
                request.setAttribute("statusError", "Error while hashing password. Please try again.");
                request.setAttribute("customer", c);
                request.getRequestDispatcher("/admin_edit_customer.jsp").forward(request, response);
                return;
            }
        }

        // 4. Gọi DAO mới để update
        boolean ok = dao.updateCustomerStatusAndPassword(customerId, hashedPassword, statusTrim);

        if (ok) {
            session.setAttribute("updateStatus", "success");
        } else {
            session.setAttribute("updateStatus", "error");
        }

        response.sendRedirect(request.getContextPath() + "/admin/customerlist");
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
