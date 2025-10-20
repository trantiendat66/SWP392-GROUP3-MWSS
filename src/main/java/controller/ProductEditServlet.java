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
                request.getSession().setAttribute("errorMessage", "Không tìm thấy sản phẩm #" + id);
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                return;
            }

            request.setAttribute("product", p);
            RequestDispatcher rd = request.getRequestDispatcher("/edit_product.jsp");
            rd.forward(request, response);

        } catch (NumberFormatException | SQLException ex) {
            ex.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Lỗi khi tải sản phẩm: " + ex.getMessage());
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

        try {
            int productId = Integer.parseInt(request.getParameter("product_id"));
            String productName = trim(request.getParameter("product_name"));
            String brand = trim(request.getParameter("brand"));
            String origin = trim(request.getParameter("origin"));
            boolean gender = "true".equalsIgnoreCase(request.getParameter("gender"));
            int price = Integer.parseInt(trim(request.getParameter("price")));
            int quantity = Integer.parseInt(trim(request.getParameter("quantity_product")));
            int categoryId = Integer.parseInt(trim(request.getParameter("category_id")));
            int accountId = Integer.parseInt(trim(request.getParameter("account_id")));

            String image = trim(request.getParameter("image"));
            if (image == null) {
                image = "";
            }

            String description = trim(request.getParameter("description"));
            String warranty = trim(request.getParameter("warranty"));
            String machine = trim(request.getParameter("machine"));
            String glass = trim(request.getParameter("glass"));
            String dialDiameter = trim(request.getParameter("dial_diameter"));
            String bezel = trim(request.getParameter("bezel"));
            String strap = trim(request.getParameter("strap"));
            String dialColor = trim(request.getParameter("dial_color"));
            String function = trim(request.getParameter("function"));

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
            request.getSession().setAttribute("successMessage", "Cập nhật sản phẩm thành công!");
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");

        } catch (NumberFormatException e) {
            e.printStackTrace();
            request.setAttribute("error", "Dữ liệu số không hợp lệ.");
            RequestDispatcher rd = request.getRequestDispatcher("/edit_product.jsp");
            rd.forward(request, response);

        } catch (SQLException ex) {
            ex.printStackTrace();
            request.setAttribute("error", "Lỗi cơ sở dữ liệu: " + ex.getMessage());
            RequestDispatcher rd = request.getRequestDispatcher("/edit_product.jsp");
            rd.forward(request, response);

        } catch (Exception ex) {
            ex.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống: " + ex.getMessage());
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
