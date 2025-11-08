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
@WebServlet(name = "ProductAddServlet", urlPatterns = {"/addproduct"})
public class ProductAddServlet extends HttpServlet {

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
            out.println("<title>Servlet ProductAddServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ProductAddServlet at " + request.getContextPath() + "</h1>");
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
        // Hiển thị trang thêm sản phẩm
        RequestDispatcher rd = request.getRequestDispatcher("/add_product.jsp");
        rd.forward(request, response);

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
        // Luôn đặt setCharacterEncoding đầu tiên để đảm bảo parseParameter đúng
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        Map<String, String> errors = new HashMap<>();
        try {

            String productName = request.getParameter("product_name");
            String brand = request.getParameter("brand");
            String origin = request.getParameter("origin");
            String genderParam = request.getParameter("gender");
            boolean gender = "1".equals(genderParam) || "true".equalsIgnoreCase(genderParam);
            String priceStr = request.getParameter("price");
            String quantityStr = request.getParameter("quantity_product");
            String categoryStr = request.getParameter("category_id");

            int accountId = 1;

            String image = request.getParameter("image");
            String description = request.getParameter("description");
            String warranty = request.getParameter("warranty");
            String machine = request.getParameter("machine");
            String glass = request.getParameter("glass");
            String dialDiameter = request.getParameter("dial_diameter");
            String bezel = request.getParameter("bezel");
            String strap = request.getParameter("strap");
            String dialColor = request.getParameter("dial_color");
            String function = request.getParameter("function");
            
            // Translation for validation messages
            if (productName == null || productName.trim().isEmpty()) {
                errors.put("productNameError", "Product name cannot be left blank."); // Tên sản phẩm không được để trống.
            }
            if (brand == null || brand.trim().isEmpty()) {
                errors.put("brandError", "Brand cannot be left blank."); // Thương hiệu không được để trống.
            }
            if (origin == null || origin.trim().isEmpty()) {
                errors.put("originError", "Origin cannot be left blank."); // Xuất xứ không được để trống.
            }
            if (priceStr == null || priceStr.trim().isEmpty()) {
                errors.put("priceError", "Product price cannot be left blank."); // Giá sản phẩm không được để trống.
            }
            if (quantityStr == null || quantityStr.trim().isEmpty()) {
                errors.put("quantityError", "Quantity cannot be left blank."); // Số lượng không được để trống.
            }
            if (categoryStr == null || categoryStr.trim().isEmpty()) {
                errors.put("categoryError", "Category cannot be left blank."); // Danh mục không được để trống.
            }
            if (image == null || image.trim().isEmpty()) {
                errors.put("imageError", "Please enter the image name or path."); // Vui lòng nhập tên hoặc đường dẫn hình ảnh.
            }
            if (description == null || description.trim().isEmpty()) {
                errors.put("descriptionError", "Description cannot be left blank."); // Mô tả không được để trống.
            }
            if (warranty == null || warranty.trim().isEmpty()) {
                errors.put("warrantyError", "Please enter warranty information."); // Vui lòng nhập thông tin bảo hành.
            }
            if (machine == null || machine.trim().isEmpty()) {
                errors.put("machineError", "Please enter machine information."); // Vui lòng nhập thông tin bộ máy.
            }
            if (glass == null || glass.trim().isEmpty()) {
                errors.put("glassError", "Please enter the glass type."); // Vui lòng nhập loại kính.
            }
            if (dialDiameter == null || dialDiameter.trim().isEmpty()) {
                errors.put("dialDiameterError", "Please enter the dial diameter."); // Vui lòng nhập đường kính mặt đồng hồ.
            }
            if (bezel == null || bezel.trim().isEmpty()) {
                errors.put("bezelError", "Please enter the bezel material."); // Vui lòng nhập chất liệu viền.
            }
            if (strap == null || strap.trim().isEmpty()) {
                errors.put("strapError", "Please enter the strap type."); // Vui lòng nhập loại dây đeo.
            }
            if (dialColor == null || dialColor.trim().isEmpty()) {
                errors.put("dialColorError", "Please enter the dial color."); // Vui lòng nhập màu mặt đồng hồ.
            }

            // 🟥 Nếu có bất kỳ lỗi rỗng nào → quay lại form
            if (!errors.isEmpty()) {
                request.setAttribute("errors", errors);
                RequestDispatcher rd = request.getRequestDispatcher("/add_product.jsp");
                rd.forward(request, response);
                return;
            }

            // 🟦 Chuyển sang dạng số
            int price, quantity, categoryId;
            try {
                price = Integer.parseInt(priceStr);
                quantity = Integer.parseInt(quantityStr);
                categoryId = Integer.parseInt(categoryStr);
            } catch (NumberFormatException e) {
                errors.put("numberError", "Price, quantity, and category must be valid numbers."); // Giá, số lượng và danh mục phải là số hợp lệ.
                request.setAttribute("errors", errors);
                RequestDispatcher rd = request.getRequestDispatcher("/add_product.jsp");
                rd.forward(request, response);
                return;
            }

            // 🟩 Kiểm tra logic hợp lệ
            if (price <= 0) {
                errors.put("priceError", "Price must be greater than 0."); // Giá phải lớn hơn 0.
            }
            if (quantity < 0) {
                errors.put("quantityError", "Quantity cannot be negative."); // Số lượng không được âm.
            }
            if (categoryId <= 0) {
                errors.put("categoryError", "Category ID must be greater than 0."); // ID danh mục phải lớn hơn 0.
            }
            
            // If there are logic errors, return to the form
            if (!errors.isEmpty()) {
                request.setAttribute("errors", errors);
                RequestDispatcher rd = request.getRequestDispatcher("/add_product.jsp");
                rd.forward(request, response);
                return;
            }

            Product p = new Product();
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
            dao.addProduct(p);
            
            // Translation for success message
            request.getSession().setAttribute("successMessage", "Successfully added product \"" + productName + "\"!"); // Thêm sản phẩm thành công!
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");

        } catch (NumberFormatException e) {
            e.printStackTrace();
            // Translation for error message
            request.setAttribute("error", "Input data error: Price, Quantity, or Category ID is invalid."); // Lỗi dữ liệu đầu vào: Giá, Số lượng, hoặc ID Danh mục không hợp lệ.
            RequestDispatcher rd = request.getRequestDispatcher("/add_product.jsp");
            rd.forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            // Translation for error message
            request.setAttribute("error", "Database error when adding product. Please check the log or try again. Error: " + e.getMessage()); // Lỗi cơ sở dữ liệu khi thêm sản phẩm.
            RequestDispatcher rd = request.getRequestDispatcher("/add_product.jsp");
            rd.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            // Translation for error message
            request.setAttribute("error", "Unknown system error: " + e.getMessage()); // Lỗi hệ thống không xác định:
            RequestDispatcher rd = request.getRequestDispatcher("/add_product.jsp");
            rd.forward(request, response);
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
