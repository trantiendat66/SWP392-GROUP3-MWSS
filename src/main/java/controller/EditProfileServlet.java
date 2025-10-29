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
import model.Staff; //* thêm để xử lý admin
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
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        CustomerDAO dao = new CustomerDAO();
        Customer customer = null; //* thêm

        Staff staff = (Staff) session.getAttribute("staff"); //* nếu admin đăng nhập
        if (staff != null && "Admin".equalsIgnoreCase(staff.getRole())) { //* nếu là admin
            String id = request.getParameter("id"); //* lấy id customer
            if (id != null) {
                customer = dao.getCustomerById(Integer.parseInt(id)); //* lấy thông tin khách hàng cần edit
                request.setAttribute("source", "admin"); //* để JSP biết đang là admin
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/customerlist"); //* không có id thì quay lại danh sách khách hàng
                return;
            }
        } else { //* nếu không phải admin (là customer)
            Customer loggedInCustomer = (Customer) session.getAttribute("customer");
            if (loggedInCustomer == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
            // Load lại dữ liệu từ DB để có dữ liệu mới nhất
            customer = dao.getCustomerById(loggedInCustomer.getCustomer_id());
            request.setAttribute("source", "customer"); //* để JSP biết đang là customer
        }

        request.setAttribute("customer", customer);
        request.getRequestDispatcher("/edit_profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        CustomerDAO dao = new CustomerDAO();
        HttpSession session = request.getSession(false);

        // Customer loggedInCustomer = (Customer) session.getAttribute("customer");
        // Customer c = dao.getCustomerById(loggedInCustomer.getCustomer_id());
        Staff staff = (Staff) session.getAttribute("staff"); //* thêm
        Customer c; //* thay vì cố định là customer

        if (staff != null && "Admin".equalsIgnoreCase(staff.getRole())) { //* nếu là admin thì lấy id từ form
            String id = request.getParameter("id");
            c = dao.getCustomerById(Integer.parseInt(id));
        } else { //* ngược lại là customer
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
        String uploadPath = getServletContext().getRealPath("/") + "assert/image";

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
            request.setAttribute("dobError", "Date of birth cannot be blank."); //* sửa thông báo lỗi cho đúng
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
            // Nếu có upload ảnh mới
            if (fileName != null && !fileName.isEmpty()) {
                filePart.write(uploadPath + File.separator + fileName);
                c.setImage("assert/image/" + fileName); // Cập nhật ảnh mới
            } else {
                // Không upload ảnh mới → giữ ảnh cũ
                c.setImage(c.getImage());
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

        // session.setAttribute("customer", c);
        // response.sendRedirect(request.getContextPath() + "/profile");
        if (staff != null && "Admin".equalsIgnoreCase(staff.getRole())) { //* nếu là admin
            response.sendRedirect(request.getContextPath() + "/admin/customerlist"); //* quay về danh sách khách hàng
        } else { //* nếu là customer
            session.setAttribute("customer", c);
            response.sendRedirect(request.getContextPath() + "/profile");
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
