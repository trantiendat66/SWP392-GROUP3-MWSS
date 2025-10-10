/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.CustomerDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.Date;
import model.Customer;

/**
 *
 * @author hau
 */
@WebServlet(name = "EditProfileServlet", urlPatterns = {"/edit_profile"})
public class EditProfileServlet extends HttpServlet {

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
            out.println("<title>Servlet EditProfileServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet EditProfileServlet at " + request.getContextPath() + "</h1>");
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
    private static final int TEST_CUSTOMER_ID = 2;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        CustomerDAO dao = new CustomerDAO();
        Customer customer = dao.getCustomerById(TEST_CUSTOMER_ID);
        request.setAttribute("customer", customer);
        request.getRequestDispatcher("/edit_profile.jsp").forward(request, response);
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
        CustomerDAO dao = new CustomerDAO();
        Customer customer = dao.getCustomerById(TEST_CUSTOMER_ID);
        request.setAttribute("customer", customer);

        String customer_name = request.getParameter("customer_name");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String address = request.getParameter("address");
        String password = request.getParameter("password");
        String dateOfBirthStr = request.getParameter("dob");
        String genderParam = request.getParameter("gender");
//        String account_status = request.getParameter("account_status");
        String image = request.getParameter("image"); // hiện để test (path) - nếu null, ta có thể set default

        Date dob = null;
        if (dateOfBirthStr != null && !dateOfBirthStr.isEmpty()) {
            try {
                // expected format yyyy-MM-dd from input type=date
                dob = Date.valueOf(dateOfBirthStr);
            } catch (IllegalArgumentException ex) {
                // ignore - null giữ nguyên
                dob = null;
            }
        }

        Customer c = dao.getCustomerById(TEST_CUSTOMER_ID);
        if (c != null) {
            c.setCustomer_name(customer_name);
            c.setPhone(phone);
            c.setEmail(email);
            c.setAddress(address);
            c.setPassword(password);
            if (dob != null) {
                c.setDob(dob);
            }
            String genderValue = null;
            if ("Male".equals(genderParam)) {
                genderValue = "0";
            } else if ("Female".equals(genderParam)) {
                genderValue = "1";
            }
            c.setGender(genderValue);
            if (image == null || image.trim().isEmpty()) {
                // giữ nguyên avatar hiện có hoặc set mặc định
                if (c.getImage() == null || c.getImage().trim().isEmpty()) {
                    c.setImage("images/2.jpg");
                }
            } else {
                c.setImage(image);
            }

            boolean ok = dao.updateCustomer(c);
            if (ok) {
                request.getSession().setAttribute("updateStatus", "success");
            } else {
                request.getSession().setAttribute("updateStatus", "error");
            }
        } else {
            request.getSession().setAttribute("updateStatus", "error");
        }

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
