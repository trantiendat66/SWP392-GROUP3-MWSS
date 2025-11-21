package controller;

import dao.OrderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import model.Customer;

@WebServlet(name = "CancelOrderServlet", urlPatterns = {"/order/cancel"})
public class CancelOrderServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Customer customer = (session != null) ? (Customer) session.getAttribute("customer") : null;
        if (customer == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?next=orders");
            return;
        }

        String orderIdRaw = request.getParameter("orderId");
        if (orderIdRaw == null) {
            session.setAttribute("orderError", "Không xác định được đơn hàng để hủy.");
            response.sendRedirect(request.getContextPath() + "/orders?tab=placed");
            return;
        }

        try {
            int orderId = Integer.parseInt(orderIdRaw);
            OrderDAO dao = new OrderDAO();
            boolean cancelled = dao.cancelPendingOrder(orderId, customer.getCustomer_id());
            if (cancelled) {
                session.setAttribute("orderSuccess", "Đơn hàng #" + orderId + " đã được hủy thành công.");
            } else {
                session.setAttribute("orderError", "Đơn hàng không thể hủy (có thể đã được xử lý).");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("orderError", "Mã đơn hàng không hợp lệ.");
        } catch (SQLException e) {
            session.setAttribute("orderError", "Không thể hủy đơn hàng: " + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/orders?tab=placed");
    }
}

