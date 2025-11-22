/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 *
 * @author Oanh Nguyen
 */
@WebServlet(name = "PaymentCancelBuyNowServlet", urlPatterns = {"/payment/cancel-buynow"})
public class PaymentCancelBuyNowServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("customer") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?next=home");
            return;
        }

        // Xóa thông tin buy-now khỏi session
        session.removeAttribute("bn_pid");
        session.removeAttribute("bn_qty");

        // Không thêm sản phẩm vào cart, chỉ redirect về home
        resp.sendRedirect(req.getContextPath() + "/home");
    }
}
