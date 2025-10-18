/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import dao.OrderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;
import java.util.*;

import model.Customer;
import model.Order;
import model.OrderDetail;

/**
 *
 * @author Oanh Nguyen
 */
@WebServlet(name = "OrderListServlet", urlPatterns = {"/orders"})
public class OrderListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("customer") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?next=orders");
            return;
        }
        Customer cus = (Customer) session.getAttribute("customer");

        String tab = req.getParameter("tab"); // placed | shipping | delivered
        if (tab == null || tab.isBlank()) {
            tab = "placed";
        }

        OrderDAO dao = new OrderDAO();
        try {
            List<Order> placed = dao.findPlacedOrders(cus.getCustomer_id());
            List<Order> shipping = dao.findShippingOrders(cus.getCustomer_id());
            List<Order> delivered = dao.findDeliveredOrders(cus.getCustomer_id());

            // Nạp chi tiết cho từng đơn vào map (để JSP truy cập nhanh)
            Map<Integer, List<OrderDetail>> itemsMap = new LinkedHashMap<>();
            for (Order o : placed) {
                itemsMap.put(o.getOrder_id(), dao.findOrderDetails(o.getOrder_id()));
            }
            for (Order o : shipping) {
                itemsMap.put(o.getOrder_id(), dao.findOrderDetails(o.getOrder_id()));
            }
            for (Order o : delivered) {
                itemsMap.put(o.getOrder_id(), dao.findOrderDetails(o.getOrder_id()));
            }

            req.setAttribute("ordersPlaced", placed);
            req.setAttribute("ordersShipping", shipping);
            req.setAttribute("ordersDelivered", delivered);
            req.setAttribute("itemsMap", itemsMap);
            req.setAttribute("activeTab", tab);

            req.getRequestDispatcher("/order-list.jsp").forward(req, resp);
        } catch (SQLException e) {
            req.setAttribute("error", e.getMessage());
            req.getRequestDispatcher("/order-list.jsp").forward(req, resp);
        }
    }
}
