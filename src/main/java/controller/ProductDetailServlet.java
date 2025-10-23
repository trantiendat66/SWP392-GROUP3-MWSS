/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.ProductDAO;
import dao.FeedbackDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Product;
import model.Customer;
import model.FeedbackView;
import java.util.Map;
import java.util.List;

/**
 *
 * @author Tran Tien Dat - CE190362
 */
@WebServlet(name = "ProductDetailServlet", urlPatterns = {"/productdetail"})
public class ProductDetailServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet ProductDetailServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ProductDetailServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        System.out.println("ProductDetailServlet called with id=" + idStr); // debug

        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing product id");
            return;
        }

        int id;
        try {
            id = Integer.parseInt(idStr.trim());
        } catch (NumberFormatException ex) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid product id");
            return;
        }

        ProductDAO dao = new ProductDAO();
        Product product = dao.getProductById(id);

        if (product == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Product not found");
            return;
        }

        // === BỔ SUNG: nạp feedback để hiển thị ở productdetail.jsp ===
        try {
            // === Feedback: nạp dữ liệu hiển thị ở productdetail.jsp ===
            FeedbackDAO fbDAO = new FeedbackDAO();

            // 1) Danh sách đánh giá để render
            List<FeedbackView> productReviews = fbDAO.getFeedbackByProduct(id);
            request.setAttribute("productReviews", productReviews);

            // 2) Tổng số đánh giá & điểm trung bình
            int ratingCount = fbDAO.getRatingCount(id);
            double ratingAvg = fbDAO.getAverageRating(id);
            request.setAttribute("ratingCount", ratingCount);
            request.setAttribute("ratingAvg", ratingAvg);

            // 3) Khách hiện tại đã review sản phẩm này chưa? (để khoá nút nếu cần)
            HttpSession session = request.getSession(false);
            Customer cus = (session != null) ? (Customer) session.getAttribute("customer") : null;
            boolean hasReviewed = false;
            if (cus != null) {
                Map<Integer, Boolean> reviewed
                        = fbDAO.findReviewedProductIds(cus.getCustomer_id(), java.util.List.of(id));
                hasReviewed = reviewed.getOrDefault(id, Boolean.FALSE);
            }
            request.setAttribute("hasReviewed", hasReviewed);

        } catch (Exception ex) {
            // không làm gián đoạn trang chi tiết nếu lỗi feedback
            request.setAttribute("feedbackError", ex.getMessage());
        }
        // === END BỔ SUNG ===

        request.setAttribute("product", product);
        request.getRequestDispatcher("/WEB-INF/productdetail.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}
