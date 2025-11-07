/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.ProductDAO;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;
import model.Product;

/**
 *
 * @author Tran Tien Dat - CE190362
 */
@WebServlet(name = "ProductEditServlet", urlPatterns = {"/editproduct"})
public class ProductEditServlet extends HttpServlet {

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
            out.println("<title>Servlet ProductEditServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ProductEditServlet at " + request.getContextPath() + "</h1>");
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
        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            return;
        }

        try {
            int id = Integer.parseInt(idParam);
            ProductDAO dao = new ProductDAO();
            Product p = dao.getById(id);

            if (p == null) {
                request.getSession().setAttribute("errorMessage", "Product #" + id + " not found"); // Không tìm thấy sản phẩm
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                return;
            }

            request.setAttribute("product", p);
            RequestDispatcher rd = request.getRequestDispatcher("/edit_product.jsp");
            rd.forward(request, response);

        } catch (NumberFormatException | SQLException ex) {
            ex.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Error loading product: " + ex.getMessage()); // Lỗi khi tải sản phẩm:
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        }
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
        Map<String, String> errors = new HashMap<>();

        // Lấy dữ liệu
        int productId = Integer.parseInt(request.getParameter("product_id"));
        String productName = trim(request.getParameter("product_name"));
        String brand = trim(request.getParameter("brand"));
        String origin = trim(request.getParameter("origin"));
        String genderParam = request.getParameter("gender");
        String priceStr = trim(request.getParameter("price"));
        String quantityStr = trim(request.getParameter("quantity_product"));
        String categoryStr = trim(request.getParameter("category_id"));
        String accountStr = trim(request.getParameter("account_id"));
        String image = trim(request.getParameter("image"));
        String description = trim(request.getParameter("description"));
        String warranty = trim(request.getParameter("warranty"));
        String machine = trim(request.getParameter("machine"));
        String glass = trim(request.getParameter("glass"));
        String dialDiameter = trim(request.getParameter("dial_diameter"));
        String bezel = trim(request.getParameter("bezel"));
        String strap = trim(request.getParameter("strap"));
        String dialColor = trim(request.getParameter("dial_color"));
        String function = trim(request.getParameter("function"));

        // Kiểm tra rỗng
        if (productName.isEmpty()) {
            errors.put("productNameError", "Product name cannot be left blank"); // Không được bỏ trống tên sản phẩm
        }
        if (brand.isEmpty()) {
            errors.put("brandError", "Brand cannot be left blank"); // Không được bỏ trống thương hiệu
        }
        if (origin.isEmpty()) {
            errors.put("originError", "Origin cannot be left blank"); // Không được bỏ trống xuất xứ
        }
        if (priceStr.isEmpty()) {
            errors.put("priceError", "Price cannot be left blank"); // Không được bỏ trống giá
        }
        if (quantityStr.isEmpty()) {
            errors.put("quantityError", "Quantity cannot be left blank"); // Không được bỏ trống số lượng
        }
        if (categoryStr.isEmpty()) {
            errors.put("categoryError", "Category ID cannot be left blank"); // Không được bỏ trống mã danh mục
        }
        if (accountStr.isEmpty()) {
            errors.put("accountError", "Account ID cannot be left blank"); // Không được bỏ trống mã tài khoản
        }
        if (image.isEmpty()) {
            errors.put("imageError", "Please enter the image name or path."); // Vui lòng nhập tên hoặc đường dẫn hình ảnh.
        }
        if (description.isEmpty()) {
            errors.put("descriptionError", "Description cannot be left blank."); // Mô tả không được để trống.
        }
        if (warranty.isEmpty()) {
            errors.put("warrantyError", "Please enter warranty information."); // Vui lòng nhập thông tin bảo hành.
        }
        if (machine.isEmpty()) {
            errors.put("machineError", "Please enter machine information."); // Vui lòng nhập thông tin bộ máy.
        }
        if (glass.isEmpty()) {
            errors.put("glassError", "Please enter the glass type."); // Vui lòng nhập loại kính.
        }
        if (dialDiameter.isEmpty()) {
            errors.put("dialDiameterError", "Please enter the dial diameter."); // Vui lòng nhập đường kính mặt đồng hồ.
        }
        if (bezel.isEmpty()) {
            errors.put("bezelError", "Please enter the bezel material."); // Vui lòng nhập chất liệu viền.
        }
        if (strap.isEmpty()) {
            errors.put("strapError", "Please enter the strap type."); // Vui lòng nhập loại dây đeo.
        }
        if (dialColor.isEmpty()) {
            errors.put("dialColorError", "Please enter the dial color."); // Vui lòng nhập màu mặt đồng hồ.
        }
        if (function.isEmpty()) {
            errors.put("functionError", "Please enter the product function."); // Vui lòng nhập chức năng của sản phẩm.
        }

        int price = 0, quantity = 0, categoryId = 0, accountId = 0;
        boolean gender = "true".equalsIgnoreCase(genderParam);

        try {
            price = Integer.parseInt(priceStr);
            if (price <= 0) {
                errors.put("priceError", "Price cannot be negative");
            }
        } catch (NumberFormatException e) {
            errors.put("priceError", "Price must be a valid number");
        }

        try {
            quantity = Integer.parseInt(quantityStr);
            if (quantity < 0) {
                errors.put("quantityError", "Quantity cannot be negative");
            }
        } catch (NumberFormatException e) {
            errors.put("quantityError", "Quantity must be a valid number");
        }

        try {
            categoryId = Integer.parseInt(categoryStr);
            if (categoryId <= 0) {
                errors.put("categoryError", "Category ID cannot be negative");
            }
        } catch (NumberFormatException e) {
            errors.put("categoryError", "Category ID must be a valid number");
        }

        try {
            accountId = Integer.parseInt(accountStr);
            if (accountId <= 0) {
                errors.put("accountError", "Account ID cannot be negative");
            }
        } catch (NumberFormatException e) {
            errors.put("accountError", "Account ID must be a valid number");
        }

        // Nếu có lỗi → quay lại trang edit_product.jsp
        if (!errors.isEmpty()) {
            Product p = new Product();
            p.setProductId(productId);
            p.setProductName(productName);
            p.setBrand(brand);
            p.setOrigin(origin);
            p.setGender(gender);
            p.setPrice(price);
            p.setQuantityProduct(quantity);
            p.setCategoryId(categoryId);
            p.setAccountId(accountId);
            p.setImage(image);
            p.setDescription(description);
            p.setWarranty(warranty);
            p.setMachine(machine);
            p.setGlass(glass);
            p.setDialDiameter(dialDiameter);
            p.setBezel(bezel);
            p.setStrap(strap);
            p.setDialColor(dialColor);
            p.setFunction(function);

            request.setAttribute("product", p);
            request.setAttribute("errors", errors);

            RequestDispatcher rd = request.getRequestDispatcher("/edit_product.jsp");
            rd.forward(request, response);
            return;
        }

        // Nếu không có lỗi → cập nhật DB
        try {
            Product p = new Product();
            p.setProductId(productId);
            p.setProductName(productName);
            p.setBrand(brand);
            p.setOrigin(origin);
            p.setGender(gender);
            p.setPrice(price);
            p.setQuantityProduct(quantity);
            p.setCategoryId(categoryId);
            p.setAccountId(accountId);
            p.setImage(image);
            p.setDescription(description);
            p.setWarranty(warranty);
            p.setMachine(machine);
            p.setGlass(glass);
            p.setDialDiameter(dialDiameter);
            p.setBezel(bezel);
            p.setStrap(strap);
            p.setDialColor(dialColor);
            p.setFunction(function);

            ProductDAO dao = new ProductDAO();
            dao.updateProduct(p);

            request.getSession().setAttribute("successMessage", "Product updated successfully!"); // Cập nhật sản phẩm thành công!
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        } catch (SQLException ex) {
            ex.printStackTrace();
            request.setAttribute("error", "Database error: " + ex.getMessage()); // Lỗi cơ sở dữ liệu:
            RequestDispatcher rd = request.getRequestDispatcher("/edit_product.jsp");
            rd.forward(request, response);
        }
    }

    private String trim(String s) {
        return s == null ? "" : s.trim();
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
