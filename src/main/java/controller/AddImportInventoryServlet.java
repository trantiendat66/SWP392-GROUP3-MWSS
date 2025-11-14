/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.ImportInventoryDAO;
import dao.ImportProductDAO;
import dao.ProductDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.Date;
import java.time.LocalDate;
import java.util.List;
import model.ImportInventory;
import model.ImportProduct;
import model.Product;

/**
 *
 * @author hau
 */
@WebServlet(name = "AddImportInventoryServlet", urlPatterns = {"/addimportinventory"})
public class AddImportInventoryServlet extends HttpServlet {

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
            out.println("<title>Servlet AddImportInventoryServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AddImportInventoryServlet at " + request.getContextPath() + "</h1>");
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
         ProductDAO productDAO = new ProductDAO();
        List<Product> products = productDAO.getAllProductsForImport();
        request.setAttribute("products", products);
        request.getRequestDispatcher("import_form.jsp").forward(request, response);
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
     try {
            // Lấy dữ liệu từ form
            String[] productIds = request.getParameterValues("productId");
            String[] prices = request.getParameterValues("importPrice");
            String[] quantities = request.getParameterValues("importQuantity");
            String supplier = request.getParameter("supplier");
            String importDateStr = request.getParameter("importDate");
            Date importDate = Date.valueOf(importDateStr);
            Date importAt = Date.valueOf(LocalDate.now());

            // Validate import date must not be in the past
            LocalDate selectedDate = LocalDate.parse(importDateStr);
            LocalDate today = LocalDate.now();
            if (selectedDate.isBefore(today)) {
                throw new IllegalArgumentException("Import date cannot be in the past. Please select today or a future date.");
            }

            int totalPrice = 0;
            int totalQuantity = 0;

            for (int i = 0; i < productIds.length; i++) {
                int price = Integer.parseInt(prices[i]);
                int quantity = Integer.parseInt(quantities[i]);
                totalPrice += price * quantity;
                totalQuantity += quantity;
            }

            // ✅ 1. Lưu phiếu nhập tổng
            ImportInventoryDAO inventoryDAO = new ImportInventoryDAO();
            ImportInventory inv = new ImportInventory(totalPrice, importAt, importDate, totalQuantity, supplier);
            int newInventoryId = inventoryDAO.insertImportInventory(inv);

            // ✅ 2. Lưu từng sản phẩm vào ImportProduct
            if (newInventoryId > 0) {
                ImportProductDAO productDAO = new ImportProductDAO();
                for (int i = 0; i < productIds.length; i++) {
                    int productId = Integer.parseInt(productIds[i]);
                    int price = Integer.parseInt(prices[i]);
                    int quantity = Integer.parseInt(quantities[i]);

                    ImportProduct detail = new ImportProduct(newInventoryId, productId, price, quantity);
                    productDAO.insertImportProduct(detail);
                }
            }

            response.sendRedirect("listimportinventory");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Error: " + e.getMessage());
            request.getRequestDispatcher("import_form.jsp").forward(request, response);
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
