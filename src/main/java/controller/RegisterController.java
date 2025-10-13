/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.CustomerDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.sql.Date;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import model.Customer;
import org.mindrot.jbcrypt.BCrypt;

/**
 *
 * @author Oanh Nguyen
 */
@MultipartConfig
@WebServlet(name = "RegisterController", urlPatterns = {"/RegisterController"})
public class RegisterController extends HttpServlet {

    private static final String UPLOAD_DIR = "uploads";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    private String saveImage(HttpServletRequest request, Part part) throws IOException {
        if (part == null || part.getSize() == 0) {
            return null;
        }
        String fileName = System.currentTimeMillis() + "_" + part.getSubmittedFileName();
        String appPath = request.getServletContext().getRealPath("");
        File uploadDir = new File(appPath, UPLOAD_DIR);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
        File file = new File(uploadDir, fileName);
        part.write(file.getAbsolutePath());
        return request.getContextPath() + "/" + UPLOAD_DIR + "/" + fileName;
    }

    private java.util.Date parseDob(String dobStr) {
        if (dobStr == null || dobStr.isBlank()) {
            return null;
        }
        try {
            return new SimpleDateFormat("yyyy-MM-dd").parse(dobStr);
        } catch (ParseException e) {
            return null;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String name = request.getParameter("customer_name");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String address = request.getParameter("address");
        String password = request.getParameter("password");
        String confirm = request.getParameter("confirm_password");
        String gender = request.getParameter("gender");
        String dobStr = request.getParameter("dob");
        Part imagePart = null;
        try {
            imagePart = request.getPart("image");
        } catch (Exception ignored) {
        }

        // Chuẩn hóa số điện thoại
        if (phone != null && phone.matches("^\\+84\\d{9}$")) {
            phone = "0" + phone.substring(3);
        }

        StringBuilder err = new StringBuilder();
        if (name == null || name.isBlank()) {
            err.append("Name is required.<br/>");
        }
        if (email == null || !email.matches("^[\\w._%+-]+@[\\w.-]+\\.[A-Za-z]{2,}$")) {
            err.append("Invalid email.<br/>");
        }
        if (phone == null || !phone.matches("^0\\d{9}$")) {
            err.append("Invalid phone number (10 digits).<br/>");
        }
        if (password == null || password.length() < 6) {
            err.append("Password must be at least 6 characters.<br/>");
        }
        if (confirm == null || !confirm.equals(password)) {
            err.append("Password confirmation does not match.<br/>");
        }
        if (dobStr == null || dobStr.isBlank()) {
            err.append("Date of birth is required.<br/>");
        }
        if (gender == null || !(gender.equalsIgnoreCase("Male") || gender.equalsIgnoreCase("Female"))) {
            err.append("Gender is required (Male/Female).<br/>");
        }

        if (err.length() > 0) {
            request.setAttribute("error", err.toString());
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        try {
            CustomerDAO dao = new CustomerDAO();

            if (dao.existsByEmail(email)) {
                request.setAttribute("error", "Email already exists.");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                return;
            }
            if (dao.existsByPhone(phone)) {
                request.setAttribute("error", "Phone already exists.");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                return;
            }

            String hash = BCrypt.hashpw(password, BCrypt.gensalt(12));
            String imagePath = saveImage(request, imagePart);

            Customer c = new Customer();
            c.setCustomer_name(name);
            c.setPhone(phone);
            c.setEmail(email);
            c.setAddress(address);
            c.setPassword(hash);
            c.setDob((Date) parseDob(dobStr));
            c.setGender(gender);
            c.setAccount_status("ACTIVE");
            c.setImage(imagePath);

            int id = dao.insert(c);
            if (id > 0) {
                response.sendRedirect(request.getContextPath() + "/register_success.jsp");
            } else {
                request.setAttribute("error", "Register failed. Please try again.");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Internal error: " + e.getMessage());
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }
}
