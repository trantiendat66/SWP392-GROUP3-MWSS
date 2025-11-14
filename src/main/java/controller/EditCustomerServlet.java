package controller;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
import dao.CustomerDAO;
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
        String view = "/admin_edit_customer.jsp";

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

        String idFromForm = request.getParameter("customerID");
        if (idFromForm == null || idFromForm.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/customerlist");
            return;
        }

        Customer c = dao.getCustomerById(Integer.parseInt(idFromForm));
        if (c == null) {
            response.sendRedirect(request.getContextPath() + "/admin/customerlist");
            return;
        }

        String customer_name = request.getParameter("customer_name");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String address = request.getParameter("address");
        String dateOfBirthStr = request.getParameter("dob");
        String genderParam = request.getParameter("gender");
        String accountStatus = request.getParameter("account_status");

        c.setCustomer_name(customer_name);
        c.setPhone(phone);
        c.setEmail(email);
        c.setAddress(address);
        c.setAccount_status(accountStatus);

        if ("Male".equalsIgnoreCase(genderParam)) {
            c.setGender("0");
        } else if ("Female".equalsIgnoreCase(genderParam)) {
            c.setGender("1");
        }

        boolean hasError = false;

        if (customer_name == null || !customer_name.matches("[a-zA-Z\\s]+")) {
            request.setAttribute("nameError", "Name can only contain letters.");
            hasError = true;
        }

        if (phone == null || !phone.matches("^0\\d{9}$")) {
            request.setAttribute("phoneError", "Phone must be exactly 10 digits and only numbers.");
            hasError = true;
        }

        if (email == null || !email.matches("^[\\w._%+-]+@gmail\\.com$")) {
            request.setAttribute("emailError",
                    "Email must be a valid Gmail address (vd: user@gmail.com).");
            request.setAttribute("customer", c);
            request.getRequestDispatcher("/admin_edit_customer.jsp").forward(request, response);
            return;
        }

        if (address == null || address.trim().isEmpty()) {
            request.setAttribute("addressError", "Address cannot be blank.");
            hasError = true;
        }

        Date dob = null;
        if (dateOfBirthStr == null || dateOfBirthStr.isEmpty()) {
            request.setAttribute("dobError", "Date of birth cannot be blank.");
            hasError = true;
        } else {
            try {
                dob = Date.valueOf(dateOfBirthStr);
                c.setDob(dob);
            } catch (IllegalArgumentException ex) {
                request.setAttribute("dobError", "Invalid date of birth.");
                hasError = true;
            }
        }
        if (hasError) {
            request.setAttribute("customer", c);
            request.getRequestDispatcher(view).forward(request, response);
            return;
        }

        boolean ok = dao.updateCustomer(c);
        if (ok) {
            session.setAttribute("updateStatus", "success");
        } else {
            session.setAttribute("updateStatus", "error");
        }

        response.sendRedirect(request.getContextPath() + "/admin/customerlist");
    }

    // ====== HÀM MÃ HOÁ MD5 ======
//    private String md5(String input) {
//        try {
//            MessageDigest md = MessageDigest.getInstance("MD5");
//            byte[] messageDigest = md.digest(input.getBytes("UTF-8"));
//            BigInteger no = new BigInteger(1, messageDigest);
//            String hashtext = no.toString(16);
//            while (hashtext.length() < 32) {
//                hashtext = "0" + hashtext;
//            }
//            return hashtext;
//        } catch (Exception e) {
//            throw new RuntimeException(e);
//        }
//    }
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
