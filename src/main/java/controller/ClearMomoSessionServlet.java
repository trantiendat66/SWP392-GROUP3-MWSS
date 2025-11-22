package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Clears MoMo payment tracking attributes from session after a successful payment.
 * Called via AJAX from momo-payment.jsp once polling detects success.
 */
@WebServlet(name = "ClearMomoSessionServlet", urlPatterns = {"/api/momo-clear"})
public class ClearMomoSessionServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null) {
            session.removeAttribute("momo_order_id");
            session.removeAttribute("momo_request_id");
            session.removeAttribute("momo_pay_url");
            session.removeAttribute("momo_qr_url");
            session.removeAttribute("momo_deeplink");
            session.removeAttribute("total_amount");
            session.removeAttribute("hold_order_id"); // remove hold tracking after success
        }
        resp.setContentType("application/json;charset=UTF-8");
        resp.getWriter().write("{\"cleared\":true}");
    }
}
