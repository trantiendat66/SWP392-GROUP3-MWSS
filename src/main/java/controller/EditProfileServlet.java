/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.CustomerDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.nio.file.Paths;
import java.sql.Date;
import model.Customer;

/**
 *
 * @author hau
 */
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)
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
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        CustomerDAO dao = new CustomerDAO();

//Nhánh Admin: cho phép mở sửa theo id từ Customer Management
        model.Staff staff = (model.Staff) session.getAttribute("staff");
        if (staff != null && "Admin".equalsIgnoreCase(staff.getRole())) {
            String idParam = request.getParameter("id"); // ?id=...
            if (idParam == null || idParam.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/admin/customerlist");
                return;
            }
            Customer customer = dao.getCustomerById(Integer.parseInt(idParam));
            if (customer == null) {
                response.sendRedirect(request.getContextPath() + "/admin/customerlist");
                return;
            }
            request.setAttribute("customer", customer);
            request.getRequestDispatcher("/edit_profile.jsp").forward(request, response);
            return;
        }

// ✅ Nhánh Customer: giữ nguyên luồng cũ
        Customer loggedInCustomer = (Customer) session.getAttribute("customer");
        if (loggedInCustomer == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        Customer customer = dao.getCustomerById(loggedInCustomer.getCustomer_id());
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
        HttpSession session = request.getSession(false);

// Nếu Admin: cập nhật theo customerID từ form
        model.Staff staff = (model.Staff) session.getAttribute("staff");
        Customer c;
        if (staff != null && "Admin".equalsIgnoreCase(staff.getRole())) {
            String idFromForm = request.getParameter("customerID");
            c = dao.getCustomerById(Integer.parseInt(idFromForm));
        } else {
            //  Customer tự cập nhật chính mình (giữ nguyên)
            Customer loggedInCustomer = (Customer) session.getAttribute("customer");
            c = dao.getCustomerById(loggedInCustomer.getCustomer_id());
        }

        String customer_name = request.getParameter("customer_name");
        if (customer_name == null || !customer_name.matches("[a-zA-Z\\s]+")) {
            request.setAttribute("nameError", "Name can only contain letters.");
            request.setAttribute("customer", c);
            request.getRequestDispatcher("edit_profile.jsp").forward(request, response);
            return;
        }
        String phone = request.getParameter("phone");
        if (phone == null || !phone.matches("^0\\d{9}$")) {
            request.setAttribute("phoneError", "Phone must be exactly 10 digits and only numbers.");
            request.setAttribute("customer", c);
            request.getRequestDispatcher("edit_profile.jsp").forward(request, response);
            return;
        }
        String email = request.getParameter("email");
        if (email == null || !email.matches("^[\\w._%+-]+@[\\w.-]+\\.[A-Za-z]{2,}$")) {
            request.setAttribute("emailError", "Email cannot be blank and must have @ and domain extension (eg .com, .vn ...).");
            request.setAttribute("customer", c);
            request.getRequestDispatcher("edit_profile.jsp").forward(request, response);
            return;
        }
        String address = request.getParameter("address");
        if (address == null || address.trim().isEmpty()) {
            request.setAttribute("addressError", "Address cannot be blank.");
            request.setAttribute("customer", c);
            request.getRequestDispatcher("edit_profile.jsp").forward(request, response);
            return;
        }

        String dateOfBirthStr = request.getParameter("dob");
        String genderParam = request.getParameter("gender");
        String image = request.getParameter("image");

        Part filePart = request.getPart("image");
        String fileName = null;
        if (filePart != null && filePart.getSize() > 0) {
            fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        }
        String uploadPath = "C:\\Users\\hau\\SWP392-GROUP3-MWSS\\src\\main\\webapp\\assert\\avatar";

        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdir();
        }
        Date dob = null;
        if (dateOfBirthStr != null && !dateOfBirthStr.isEmpty()) {
            try {
                dob = Date.valueOf(dateOfBirthStr);
            } catch (IllegalArgumentException ex) {
                dob = null;
            }
        } else {
            request.setAttribute("dobError", "Address cannot be blank.");
            request.setAttribute("customer", c);
            request.getRequestDispatcher("edit_profile.jsp").forward(request, response);
            return;
        }

        if (c != null) {
            c.setCustomer_name(customer_name);
            c.setPhone(phone);
            c.setEmail(email);
            c.setAddress(address);

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
            if (fileName != null && !fileName.isEmpty()) {
                // Có upload ảnh mới
                filePart.write(uploadPath + File.separator + fileName);
                c.setImage("assert/avatar/" + fileName);
            } else {
                // Không upload ảnh mới
                if (c.getImage() == null || c.getImage().trim().isEmpty()) {
                    // Nếu chưa có ảnh trong DB → gán ảnh mặc định
                    c.setImage("assert/avatar/avatar_md.jpg");
                } else {
                    // Nếu đã có ảnh cũ → giữ nguyên
                    c.setImage(c.getImage());
                }
            }
            // Chỉ Admin mới được đổi trạng thái tài khoản
            if (staff != null && "Admin".equalsIgnoreCase(staff.getRole())) {
                String accountStatus = request.getParameter("account_status"); // từ <select name="account_status">
                if (accountStatus != null && !accountStatus.trim().isEmpty()) {
                    c.setAccount_status(accountStatus.trim()); // "Active" | "Inactive"
                }
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
        if (staff != null && "Admin".equalsIgnoreCase(staff.getRole())) {
            //  Admin cập nhật xong quay về danh sách khách hàng
            response.sendRedirect(request.getContextPath() + "/admin/customerlist");
        } else {
            //  Customer: giữ lại session và về profile của mình
            session.setAttribute("customer", c);
            response.sendRedirect(request.getContextPath() + "/profile");
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
