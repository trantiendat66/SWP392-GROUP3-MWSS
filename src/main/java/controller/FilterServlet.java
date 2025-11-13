/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.BrandDAO;
import dao.ProductDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Brand;
import model.Product;

/**
 *
 * @author Nguyen Thien Dat - CE190879 - 06/05/2005
 */
@WebServlet(name = "FilterServlet", urlPatterns = {"/filterServlet"})
public class FilterServlet extends HttpServlet {

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
            out.println("<title>Servlet FilterServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet FilterServlet at " + request.getContextPath() + "</h1>");
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
        String brand = request.getParameter("brand");
        String gender = request.getParameter("gender");
        String priceRange = request.getParameter("priceRange");
        String getActive = request.getParameter("active") == null ? "" : request.getParameter("active");

        int minPrice = 0;
        int maxPrice = 0;
        if (priceRange != null && !priceRange.isEmpty()) {
            if (priceRange.contains("-")) {
                String[] parts = priceRange.split("-");
                try {
                    minPrice = Integer.parseInt(parts[0]);
                    maxPrice = Integer.parseInt(parts[1]);
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                }
            } else if (priceRange.endsWith("+")) {
                try {
                    minPrice = Integer.parseInt(priceRange.replace("+", ""));
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                }
            }
        }

        ProductDAO dao = new ProductDAO();
        List<Product> list = dao.filterProducts(brand, gender, minPrice, maxPrice);
        if (getActive.equals("staff")) {
            BrandDAO bdao = new BrandDAO();
            List<Brand> listB = bdao.getAllBrand();
            request.setAttribute("listBrands", listB);
            request.setAttribute("listProducts", list);
            request.setAttribute("brand", brand);
            request.setAttribute("gender", gender);
            request.setAttribute("priceRange", priceRange);
            request.setAttribute("activeTab", "product");
            request.getRequestDispatcher("/WEB-INF/staff.jsp").forward(request, response);
            return;
        }
        if (list == null || list.isEmpty()) {
            request.getRequestDispatcher("/partials/product-list.jsp").forward(request, response);
        } else {
            request.setAttribute("listP", list);
            request.setAttribute("brand", brand);
            request.setAttribute("gender", gender);
            request.setAttribute("priceRange", priceRange);
            request.getRequestDispatcher("/partials/product-list.jsp").forward(request, response);
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
        processRequest(request, response);
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
