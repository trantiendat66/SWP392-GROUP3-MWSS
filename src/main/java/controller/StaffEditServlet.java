/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.StaffDAO;
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
@WebServlet(name = "StaffEditServlet", urlPatterns = {"/admin/staff/edit"})
public class StaffEditServlet extends HttpServlet {

    private boolean isValidEmail(String email) {
        return email != null && email.matches("^[\\w-.]+@([\\w-]+\\.)+[\\w-]{2,4}$");
    }

    private boolean isValidPhone(String phone) {
        return phone != null && phone.matches("^\\d{10,11}$");
    }

    private boolean isValidTextField(String input) {
        return input != null && input.matches("^[\\p{L}\\d\\s]+$") && !input.matches("^\\d+$");
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
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet StaffEditServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet StaffEditServlet at " + request.getContextPath() + "</h1>");
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

        String id_raw = request.getParameter("id");
        if (id_raw == null) {
            response.sendRedirect(request.getContextPath() + "/admin/staff");
            return;
        }
        int id = Integer.parseInt(id_raw);
        StaffDAO dao = new StaffDAO();
        Staff staff = dao.getStaffById(id);
        if (staff == null) {
            response.sendRedirect(request.getContextPath() + "/admin/staff");
            return;
        }
        request.setAttribute("staff", staff);
        request.getRequestDispatcher("/staff_edit.jsp").forward(request, response);
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
        int id = Integer.parseInt(request.getParameter("accountId"));

        StaffDAO dao = new StaffDAO();
        Staff oldStaff = dao.getStaffById(id);
        if (oldStaff == null) {
            response.sendRedirect(request.getContextPath() + "/admin/staff");
            return;
        }

        String email = request.getParameter("email").trim();
        String phone = request.getParameter("phone").trim();
        String position = request.getParameter("position").trim();
        String address = request.getParameter("address").trim();

        boolean hasError = false;
        if (email.isEmpty() || !email.matches("^[\\w-.]+@([\\w-]+\\.)+[\\w-]{2,4}$")) {
            request.setAttribute("emailError", "Please enter a valid email.");
            hasError = true;
        }
        if (phone.isEmpty() || !phone.matches("^\\d{10,11}$")) {
            request.setAttribute("phoneError", "Please enter a valid phone number (10-11 digits).");
            hasError = true;
        }
        if (position.isEmpty() || !position.matches("^[\\p{L}\\d\\s]+$") || position.matches("^\\d+$")) {
            request.setAttribute("positionError", "Position must contain at least one letter and can only contain letters, numbers and spaces (no numbers, no special characters).");
            hasError = true;
        }
        if (address.isEmpty() || !address.matches("^[\\p{L}\\d\\s]+$") || address.matches("^\\d+$")) {
            request.setAttribute("addressError", "Address must contain at least one letter and can only contain letters, numbers and spaces (no numbers, no special characters).");
            hasError = true;
        }

        if (hasError) {

            Staff staff = new Staff(id, oldStaff.getUserName(), oldStaff.getPassword(), email, phone, oldStaff.getRole(), position, address, oldStaff.getStatus());
            request.setAttribute("staff", staff);
            request.getRequestDispatcher("/staff_edit.jsp").forward(request, response);
            return;
        }

        Staff staff = new Staff(id, oldStaff.getUserName(), oldStaff.getPassword(), email, phone, oldStaff.getRole(), position, address, oldStaff.getStatus());
        dao.updateStaff(staff);
        response.sendRedirect(request.getContextPath() + "/admin/staff");
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
