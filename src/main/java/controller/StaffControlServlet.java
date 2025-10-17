/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.OrderDAO;
import dao.StaffDAO;
import dao.ProductDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Staff;
import model.Product;
import java.util.List;
import model.Order;
import model.OrderDetail;

/**
 *
 * @author Nguyen Thien Dat - CE190879 - 06/05/2005
 */
@WebServlet(name = "StaffControlServlet", urlPatterns = {"/staffcontrol"})
public class StaffControlServlet extends HttpServlet {

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
        // Giữ nguyên logic processRequest hoặc chuyển hướng đến doGet/doPost nếu cần.
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("staff") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Staff loggedInCustomer = (Staff) session.getAttribute("staff");

        // 1. Tải lại dữ liệu Staff (đã có)
        StaffDAO staffDAO = new StaffDAO();
        Staff staff = staffDAO.getStaffByEmail(loggedInCustomer.getEmail());
        request.setAttribute("staff", staff);

        // 🛑 BỔ SUNG LOGIC LOAD DANH SÁCH SẢN PHẨM 🛑
        try {
            ProductDAO productDAO = new ProductDAO();
            // Lấy danh sách sản phẩm (Product List)
            List<Product> listProducts = productDAO.getAllProducts();

            // Đặt danh sách vào request để JSP hiển thị
            request.setAttribute("listProducts", listProducts);
        } catch (Exception e) {
            // Log lỗi hoặc đặt thông báo lỗi nếu cần
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading product data.");
        }

//        Khu này là ListOrder cho thằng Staff quản lý Okela 👈(ﾟヮﾟ👈)
        try {
            OrderDAO orderDao = new OrderDAO();
            List<Order> listOrders = orderDao.getOrderByIdStaff(staff.getAccountId());
            request.setAttribute("listOrders", listOrders);
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
//        Khu này là getOrder để hiện một order cho thằng Staff quản lý Okela 👈(ﾟヮﾟ👈)
        try {
            OrderDAO orderDetailDao = new OrderDAO();
            Order orderDetail = orderDetailDao.getOrderByOrderId(0);
            request.setAttribute("orderDetail", orderDetail);
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
//        Khu này là getProductInOrder để hiện một product list trong order cho thằng Staff quản lý Okela 👈(ﾟヮﾟ👈)
        try {
            OrderDAO listPIO = new OrderDAO();
            List<OrderDetail> orderP = listPIO.getOrderDetailByOrderId(0);
            request.setAttribute("orderP", orderP);
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        // 2. Forward đến JSP
        request.getRequestDispatcher("/WEB-INF/staff.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response); // Thường gọi lại doGet nếu không có xử lý POST cụ thể
    }

    @Override
    public String getServletInfo() {
        return "Controls Staff Dashboard access and loads initial data (Staff profile, Product List)";
    }

}
