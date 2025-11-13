/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import dao.CustomerDAO;
import hashpw.MD5PasswordHasher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 *
 * @author Oanh Nguyen
 */

@WebServlet(name = "VerifyOtpController", urlPatterns = {"/verify"})
public class VerifyOtpController extends HttpServlet {

    private static final int MAX_ATTEMPTS = 5;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (req.getSession().getAttribute("fp_email") == null) {
            resp.sendRedirect(req.getContextPath() + "/forgot");
            return;
        }
        req.getRequestDispatcher("/verify_otp.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession ss = req.getSession(false);
        if (ss == null || ss.getAttribute("fp_email") == null) {
            resp.sendRedirect(req.getContextPath() + "/forgot");
            return;
        }

        String email = ((String) ss.getAttribute("fp_email"));
        String otpHash = (String) ss.getAttribute("fp_otp_hash"); // MD5 đã lưu ở Forgot
        Long exp = (Long) ss.getAttribute("fp_exp");
        Integer attempts = (Integer) ss.getAttribute("fp_attempts");
        if (attempts == null) {
            attempts = 0;
        }

        String otp = req.getParameter("otp");
        String newPass = req.getParameter("password");
        String confirm = req.getParameter("confirm");

        StringBuilder err = new StringBuilder();
        if (otp == null || !otp.matches("^\\d{6}$")) {
            err.append("Invalid OTP format.<br/>");
        }
        if (newPass == null || newPass.length() < 6) {
            err.append("Password must be at least 6 characters.<br/>");
        }
        if (confirm == null || !confirm.equals(newPass)) {
            err.append("Password confirmation does not match.<br/>");
        }
        long now = System.currentTimeMillis();
        if (exp == null || now > exp) {
            err.append("OTP expired. Please request a new one.<br/>");
        }
        if (attempts >= MAX_ATTEMPTS) {
            err.append("Too many incorrect attempts. Request a new OTP.<br/>");
        }
        if (otpHash == null) {
            err.append("Session invalid. Please request a new OTP.<br/>");
        }

        if (err.length() > 0) {
            req.setAttribute("error", err.toString());
            req.getRequestDispatcher("/verify_otp.jsp").forward(req, resp);
            return;
        }

        try {
            // ✅ So khớp OTP bằng MD5
            String otpInputMd5 = MD5PasswordHasher.hashPassword(otp);
            boolean otpOK = otpInputMd5.equalsIgnoreCase(otpHash);
            if (!otpOK) {
                ss.setAttribute("fp_attempts", attempts + 1);
                req.setAttribute("error", "Incorrect OTP.");
                req.getRequestDispatcher("/verify_otp.jsp").forward(req, resp);
                return;
            }

            // ✅ Hash mật khẩu mới bằng MD5 (đồng bộ hệ thống hiện tại)
            String md5Pass = MD5PasswordHasher.hashPassword(newPass);

            CustomerDAO cdao = new CustomerDAO();
            boolean ok = cdao.updatePasswordByEmail(email, md5Pass);
            if (!ok) {
                req.setAttribute("error", "Failed to update password.");
                req.getRequestDispatcher("/verify_otp.jsp").forward(req, resp);
                return;
            }

            // Dọn session OTP
            ss.removeAttribute("fp_email");
            ss.removeAttribute("fp_otp_hash");
            ss.removeAttribute("fp_exp");
            ss.removeAttribute("fp_attempts");
            ss.removeAttribute("otp_ttl_min");
            ss.removeAttribute("fp_last_sent");

            // (tuỳ chọn) Invalidate toàn bộ session nếu muốn
            // ss.invalidate();
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Internal error. Please try again.");
            req.getRequestDispatcher("/verify_otp.jsp").forward(req, resp);
        }
    }
}
