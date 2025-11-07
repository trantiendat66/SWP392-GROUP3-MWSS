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

        Staff staff = new Staff(
                id,
                oldStaff.getUserName(),
                oldStaff.getPassword(),
                request.getParameter("email"),
                request.getParameter("phone"),
                request.getParameter("role"),
                request.getParameter("position"),
                request.getParameter("address"),
                request.getParameter("status")
        );

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
