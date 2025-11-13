package controller;

import dao.ProductDAO;
import model.Product;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "ViewProductDetailServlet", urlPatterns = {"/viewproductdetail"})
public class ViewProductDetailServlet extends HttpServlet {

    private static final String VIEW_PAGE = "/WEB-INF/viewproductdetail.jsp";
    private static final String STAFF_PAGE_REDIRECT = "/staff";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        try {
            String productIdStr = request.getParameter("id");
            if (productIdStr == null || productIdStr.isEmpty()) {
                response.sendRedirect(request.getContextPath() + STAFF_PAGE_REDIRECT);
                return;
            }

            int productId = Integer.parseInt(productIdStr);

            ProductDAO productDAO = new ProductDAO();
            Product product = productDAO.getProductById(productId); 

            if (product != null) {
                
                request.setAttribute("viewproductdetail", product);
                request.getRequestDispatcher(VIEW_PAGE).forward(request, response);
            } else {
              
                request.setAttribute("viewproductdetail", null); 
                request.getRequestDispatcher(VIEW_PAGE).forward(request, response);
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + STAFF_PAGE_REDIRECT);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi Server: " + e.getMessage());
        }
    }
}
