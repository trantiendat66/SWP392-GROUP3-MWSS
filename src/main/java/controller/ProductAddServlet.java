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
            if (productName == null || productName.trim().isEmpty()) {
                errors.put("productNameError", "Tên sản phẩm không được để trống.");
            }
            if (brand == null || brand.trim().isEmpty()) {
                errors.put("brandError", "Thương hiệu không được để trống.");
            }
            if (origin == null || origin.trim().isEmpty()) {
                errors.put("originError", "Xuất xứ không được để trống.");
            }
            if (priceStr == null || priceStr.trim().isEmpty()) {
                errors.put("priceError", "Giá sản phẩm không được để trống.");
            }
            if (quantityStr == null || quantityStr.trim().isEmpty()) {
                errors.put("quantityError", "Số lượng không được để trống.");
            }
            if (categoryStr == null || categoryStr.trim().isEmpty()) {
                errors.put("categoryError", "Danh mục không được để trống.");
            }
            if (image == null || image.trim().isEmpty()) {
                errors.put("imageError", "Vui lòng nhập tên hoặc đường dẫn hình ảnh.");
            }
            if (description == null || description.trim().isEmpty()) {
                errors.put("descriptionError", "Mô tả không được để trống.");
            }
            if (warranty == null || warranty.trim().isEmpty()) {
                errors.put("warrantyError", "Vui lòng nhập thông tin bảo hành.");
            }
            if (machine == null || machine.trim().isEmpty()) {
                errors.put("machineError", "Vui lòng nhập thông tin bộ máy.");
            }
            if (glass == null || glass.trim().isEmpty()) {
                errors.put("glassError", "Vui lòng nhập loại kính.");
            }
            if (dialDiameter == null || dialDiameter.trim().isEmpty()) {
                errors.put("dialDiameterError", "Vui lòng nhập đường kính mặt đồng hồ.");
            }
            if (bezel == null || bezel.trim().isEmpty()) {
                errors.put("bezelError", "Vui lòng nhập chất liệu viền.");
            }
            if (strap == null || strap.trim().isEmpty()) {
                errors.put("strapError", "Vui lòng nhập loại dây đeo.");
            }
            if (dialColor == null || dialColor.trim().isEmpty()) {
                errors.put("dialColorError", "Vui lòng nhập màu mặt đồng hồ.");
            }
            if (function == null || function.trim().isEmpty()) {
                errors.put("functionError", "Vui lòng nhập chức năng của sản phẩm.");
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
                errors.put("numberError", "Giá, số lượng và danh mục phải là số hợp lệ.");
                request.setAttribute("errors", errors);
                RequestDispatcher rd = request.getRequestDispatcher("/add_product.jsp");
                rd.forward(request, response);
                return;
            }

            // 🟩 Kiểm tra logic hợp lệ
            if (price <= 0) {
                errors.put("priceError", "Giá phải lớn hơn 0.");
            }
            if (quantity < 0) {
                errors.put("quantityError", "Số lượng không được âm.");
            }
            if (categoryId <= 0) {
                errors.put("categoryError", "ID danh mục phải lớn hơn 0.");
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
            request.getSession().setAttribute("successMessage", "Thêm sản phẩm \"" + productName + "\" thành công!");
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");

        } catch (NumberFormatException e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi dữ liệu đầu vào: Giá, Số lượng, hoặc ID Danh mục không hợp lệ.");
            RequestDispatcher rd = request.getRequestDispatcher("/add_product.jsp");
            rd.forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi cơ sở dữ liệu khi thêm sản phẩm. Vui lòng kiểm tra log hoặc thử lại. Lỗi: " + e.getMessage());
            RequestDispatcher rd = request.getRequestDispatcher("/add_product.jsp");
            rd.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống không xác định: " + e.getMessage());
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
