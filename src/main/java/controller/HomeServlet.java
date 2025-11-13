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
import model.Category;
import model.Product;

/**
 *
 * @author Tran Tien Dat - CE190362
 */
@WebServlet(name = "HomeServlet", urlPatterns = {"/home"})
public class HomeServlet extends HttpServlet {

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
            out.println("<title>Servlet HomeServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet HomeServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

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

        String getActive = request.getParameter("active");
        int active = 0;
        if (getActive != null) {
            try {
                active = Integer.parseInt(getActive);
            } catch (NumberFormatException e) {
                active = 0; // fallback nếu người dùng nhập linh tinh
            }
        }
        BrandDAO bdao = new BrandDAO();
        List<Brand> listB = bdao.getAllBrand();

        ProductDAO dao = new ProductDAO();
        List<Product> list = dao.getAllProducts();
        List<Category> listC = dao.getAllCategories();
        if (active != 0) {
            List<Product> menu = dao.getProductsByCategory(active);
            request.setAttribute("listC", listC);
            request.setAttribute("listP", menu);
            request.setAttribute("listBrands", listB);
            request.getRequestDispatcher("/WEB-INF/home.jsp").forward(request, response);
            return;
        }
        request.setAttribute("listBrands", listB);
        request.setAttribute("listC", listC);
        request.setAttribute("listP", list);
        request.getRequestDispatcher("/WEB-INF/home.jsp").forward(request, response);
    }
}
