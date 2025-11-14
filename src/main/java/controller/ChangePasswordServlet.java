/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.CustomerDAO;
import dao.StaffDAO;
import hashpw.MD5PasswordHasher;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Customer;
import model.Staff;

/**
 *
 * @author hau
 */
@WebServlet(name = "ChangePasswordServlet", urlPatterns = {"/change_password"})
public class ChangePasswordServlet extends HttpServlet {

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
            out.println("<title>Servlet ChangePasswordServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ChangePasswordServlet at " + request.getContextPath() + "</h1>");
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
        request.getRequestDispatcher("change_password.jsp").forward(request, response);
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
        HttpSession session = request.getSession(false);
        Customer c = (Customer) session.getAttribute("customer");
        CustomerDAO dao = new CustomerDAO();
        StaffDAO sdao = new StaffDAO();
        Staff s = (Staff) session.getAttribute("staff");

        String oldPass = request.getParameter("oldPassword");
        String newPass = request.getParameter("newPassword");
        String confirmPass = request.getParameter("confirmPassword");
        
         if (oldPass == null || oldPass.trim().isEmpty()
            || newPass == null || newPass.trim().isEmpty()
            || confirmPass == null || confirmPass.trim().isEmpty()) {

        request.setAttribute("error", "All fields are required.");
        request.getRequestDispatcher("change_password.jsp").forward(request, response);
        return;
    }

        // Kiểm tra Customer
        if (c != null) {
            // Mã hóa MD5 pass cũ để so sánh
            String oldPassMD5 = MD5PasswordHasher.hashPassword(oldPass);
            if (!c.getPassword().equals(oldPassMD5)) {
                request.setAttribute("error", "Old password is incorrect");
                request.getRequestDispatcher("change_password.jsp").forward(request, response);
                return;
            }

            if (!newPass.equals(confirmPass)) {
                request.setAttribute("error", "New password and confirm password do not match");
                request.getRequestDispatcher("change_password.jsp").forward(request, response);
                return;
            }
            // Mã hóa mật khẩu mới
            String newPassMD5 = MD5PasswordHasher.hashPassword(newPass);
            dao.updatePasswordById(c.getCustomer_id(), newPassMD5);
            HttpSession ses = request.getSession();
ses.setAttribute("successMessage", "Password updated successfully!");
            response.sendRedirect("profile");
            return;
        }

        // Kiểm tra Staff
        if (s != null) {
            // Mã hóa MD5 pass cũ để so sánh
            String oldPassMD5 = MD5PasswordHasher.hashPassword(oldPass);
            if (!s.getPassword().equals(oldPassMD5)) {
                request.setAttribute("error", "Old password is incorrect");
                request.getRequestDispatcher("change_password.jsp").forward(request, response);
                return;
            }

            if (!newPass.equals(confirmPass)) {
                request.setAttribute("error", "New password and confirm password do not match");
                request.getRequestDispatcher("change_password.jsp").forward(request, response);
                return;
            }
            // Mã hóa mật khẩu mới
            String newPassMD5 = MD5PasswordHasher.hashPassword(newPass);
            sdao.updatePasswordById(s.getAccountId(), newPassMD5);
            HttpSession ses = request.getSession();
ses.setAttribute("successMessage", "Password updated successfully!");
            response.sendRedirect("staff_profile");
            return;
        }

        response.sendRedirect("login.jsp");
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
