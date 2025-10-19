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
import jakarta.servlet.http.HttpSession;
import model.Staff;

/**
 *
 * @author hau
 */

@WebServlet(name = "EditStaffProfileServlet", urlPatterns = {"/edit_staff_profile"})
public class EditStaffProfileServlet extends HttpServlet {

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
            out.println("<title>Servlet EditStaffProfileServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet EditStaffProfileServlet at " + request.getContextPath() + "</h1>");
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
        if (session == null || session.getAttribute("staff") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Staff loggedInStaff = (Staff) session.getAttribute("staff");
        StaffDAO dao = new StaffDAO();
        Staff staff = dao.getStaffById(loggedInStaff.getAccountId());

        request.setAttribute("staff", staff);
        request.getRequestDispatcher("/edit_staff_profile.jsp").forward(request, response);
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

        HttpSession session = request.getSession(false);
        Staff loggedInStaff = (Staff) session.getAttribute("staff");
        StaffDAO dao = new StaffDAO();
        Staff s = dao.getStaffById(loggedInStaff.getAccountId());

        // ===== VALIDATE INPUT =====
        String username = request.getParameter("username");
        if (username == null || !username.matches("[a-zA-Z\\s]+")) {
            request.setAttribute("nameError", "Name can only contain letters.");
            request.setAttribute("staff", s);
            request.getRequestDispatcher("edit_staff_profile.jsp").forward(request, response);
            return;
        }

        String phone = request.getParameter("phone");
        if (phone == null || !phone.matches("^0\\d{9}$")) {
            request.setAttribute("phoneError", "Phone must be exactly 10 digits and only numbers.");
            request.setAttribute("staff", s);
            request.getRequestDispatcher("edit_staff_profile.jsp").forward(request, response);
            return;
        }

        String email = request.getParameter("email");
        if (email == null || !email.matches("^[\\w._%+-]+@[\\w.-]+\\.[A-Za-z]{2,}$")) {
            request.setAttribute("emailError", "Invalid email format.");
            request.setAttribute("staff", s);
            request.getRequestDispatcher("edit_staff_profile.jsp").forward(request, response);
            return;
        }

        String address = request.getParameter("address");
        if (address == null || address.trim().isEmpty()) {
            request.setAttribute("addressError", "Address cannot be blank.");
            request.setAttribute("staff", s);
            request.getRequestDispatcher("edit_staff_profile.jsp").forward(request, response);
            return;
        }

        // ====== UPDATE DATA ======
        s.setUserName(username);
        s.setPhone(phone);
        s.setEmail(email);
        s.setAddress(address);

        boolean ok = dao.updateStaff(s);
        if (ok) session.setAttribute("updateStatus", "success");
        else session.setAttribute("updateStatus", "error");

        session.setAttribute("staff", s);
        response.sendRedirect(request.getContextPath() + "/profile");
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
