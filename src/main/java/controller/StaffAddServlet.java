/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.StaffDAO;
import hashpw.MD5PasswordHasher;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Staff;

/**
 *
 * @author Tran Tien Dat - CE190362
 */
@WebServlet(name = "StaffAddServlet", urlPatterns = {"/admin/staff/add"})
public class StaffAddServlet extends HttpServlet {

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
            out.println("<title>Servlet StaffAddServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet StaffAddServlet at " + request.getContextPath() + "</h1>");
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
        request.getRequestDispatcher("/staff_add.jsp").forward(request, response);
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
        String username = request.getParameter("userName").trim();
        String password = request.getParameter("password");
        String email = request.getParameter("email").trim();
        String phone = request.getParameter("phone").trim();
        String role = request.getParameter("role").trim();
        String position = request.getParameter("position").trim();
        String address = request.getParameter("address").trim();
        String status = request.getParameter("status").trim();

        // Server-side validation
        String errorMessage = null;
        if (username.isEmpty() || username.length() < 2) {
            errorMessage = "Username must have at least 2 characters.";
        } else if (password == null || password.length() < 6) {
            errorMessage = "Password must have at least 6 characters.";
        } else if (email.isEmpty() || !email.matches("^[\\w-.]+@([\\w-]+\\.)+[\\w-]{2,4}$")) {
            errorMessage = "Please enter a valid email.";
        } else if (phone.isEmpty() || !phone.matches("^\\d{10,11}$")) {
            errorMessage = "Please enter a valid phone number (10-11 digits).";
        } else if (position.isEmpty()) {
            errorMessage = "Position cannot be empty.";
        } else if (address.isEmpty()) {
            errorMessage = "Address cannot be empty.";
        }

        if (errorMessage != null) {
            Staff staff = new Staff(0, username, "", email, phone, role, position, address, status);
            request.setAttribute("staff", staff);
            request.setAttribute("errorMessage", errorMessage);
            request.getRequestDispatcher("/staff_add.jsp").forward(request, response);
            return;
        }

        // Nếu hợp lệ
        String hashedPassword = MD5PasswordHasher.hashPassword(password);
        Staff staff = new Staff(0, username, hashedPassword, email, phone, role, position, address, status);

        StaffDAO dao = new StaffDAO();
        try {
            boolean success = dao.addStaff(staff);
            if (success) {
                request.getSession().setAttribute("successMessage", "Staff added successfully!");
                response.sendRedirect(request.getContextPath() + "/admin/staff");
            } else {
                request.setAttribute("staff", staff);
                request.setAttribute("errorMessage", "Failed to add staff. Please check input or try again.");
                request.getRequestDispatcher("/staff_add.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("staff", staff);
            request.setAttribute("errorMessage", "Error: " + e.getMessage());
            request.getRequestDispatcher("/staff_add.jsp").forward(request, response);
        }
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
