/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import dao.FeedbackDAO;
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
import model.OrderItemRow;

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
        Customer cus = (session != null) ? (Customer) session.getAttribute("customer") : null;
        if (cus == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?next=orders");
            return;
        }

        String tab = req.getParameter("tab");
        if (tab == null) {
            tab = "placed";
        }
        req.setAttribute("activeTab", tab);

        OrderDAO orderDAO = new OrderDAO();

        try {

            List<Order> ordersPlaced = orderDAO.findOrdersByStatuses(
                    cus.getCustomer_id(), "PENDING", "CONFIRMED");
            List<Order> ordersShipping = orderDAO.findOrdersByStatuses(
                    cus.getCustomer_id(), "SHIPPING");
            List<Order> ordersDelivered = orderDAO.findOrdersByStatuses(
                    cus.getCustomer_id(), "DELIVERED");

            req.setAttribute("ordersPlaced", ordersPlaced);
            req.setAttribute("ordersShipping", ordersShipping);
            req.setAttribute("ordersDelivered", ordersDelivered);

            // Gom orderIds để lấy items + eligible feedback keys
            List<Integer> orderIds = new ArrayList<>();
            for (Order o : ordersPlaced) {
                orderIds.add(o.getOrder_id());
            }
            for (Order o : ordersShipping) {
                orderIds.add(o.getOrder_id());
            }
            for (Order o : ordersDelivered) {
                orderIds.add(o.getOrder_id());
            }

            Map<Integer, List<OrderItemRow>> itemsMap
                    = orderDAO.findItemsWithPidByOrderIds(orderIds);
            req.setAttribute("itemsMap", itemsMap);

            // === FEEDBACK (NEW): map các productId mà customer đã từng đánh giá ===
            // Mục tiêu: hiện chữ "Đã đánh giá" thay vì nút đánh giá
            if (itemsMap != null && !itemsMap.isEmpty()) {
                Set<Integer> allProductIds = new HashSet<>();
                for (List<OrderItemRow> rows : itemsMap.values()) {
                    if (rows == null) {
                        continue;
                    }
                    for (OrderItemRow r : rows) {
                        allProductIds.add(r.getProductId());
                    }
                }
                if (!allProductIds.isEmpty()) {
                    FeedbackDAO fbDAO = new FeedbackDAO();
                    Map<Integer, Boolean> reviewedMap
                            = fbDAO.findReviewedProductIds(cus.getCustomer_id(), allProductIds);
                    req.setAttribute("reviewedMap", reviewedMap);
                } else {
                    req.setAttribute("reviewedMap", Collections.emptyMap());
                }
            } else {
                req.setAttribute("reviewedMap", Collections.emptyMap());
            }
            // === END FEEDBACK (NEW) ===

            Set<String> eligibleKeys
                    = orderDAO.findEligibleFeedbackKeys(cus.getCustomer_id(), orderIds);
            req.setAttribute("eligibleKeys", eligibleKeys);

            req.getRequestDispatcher("/order-list.jsp").forward(req, resp);
        } catch (SQLException e) {
            req.setAttribute("error", "Không tải được danh sách đơn hàng: " + e.getMessage());
            req.getRequestDispatcher("/order-list.jsp").forward(req, resp);
        }
    }
}
