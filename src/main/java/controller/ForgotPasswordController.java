/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import dao.CustomerDAO;
import hashpw.MD5PasswordHasher;
import jakarta.mail.MessagingException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.security.SecureRandom;
import org.mindrot.jbcrypt.BCrypt;
import utils.EmailUtil;

/**
 *
 * @author Oanh Nguyen
 */
@WebServlet(name = "ForgotPasswordController", urlPatterns = {"/forgot"})
public class ForgotPasswordController extends HttpServlet {

    // ✔ OTP 6 số, hết hạn 5 phút
    private static final int OTP_TTL_MIN = 5;
    // ✔ Chống spam resend 60 giây
    private static final int RESEND_COOLDOWN_SEC = 60;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/forgot_password.jsp").forward(req, resp);
    }

    private String generateOtp() {
        SecureRandom r = new SecureRandom();
        int n = r.nextInt(900000) + 100000; // 6 digits
        return String.valueOf(n);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email = req.getParameter("email");
        if (email == null || !email.matches("^[\\w._%+-]+@[\\w.-]+\\.[A-Za-z]{2,}$")) {
            req.setAttribute("error", "Please enter a valid email.");
            req.getRequestDispatcher("/forgot_password.jsp").forward(req, resp);
            return;
        }

        try {
            CustomerDAO cdao = new CustomerDAO();
            // ✔ Không tiết lộ email có/không
            if (!cdao.existsByEmail(email)) {
                req.setAttribute("info", "If the email is registered, an OTP has been sent.");
                req.getRequestDispatcher("/forgot_password.jsp").forward(req, resp);
                return;
            }

            HttpSession ss = req.getSession(true);

            // ✔ Resend cooldown
            Long last = (Long) ss.getAttribute("fp_last_sent");
            long now = System.currentTimeMillis();
            if (last != null && now - last < RESEND_COOLDOWN_SEC * 1000L) {
                long wait = (RESEND_COOLDOWN_SEC * 1000L - (now - last)) / 1000L;
                req.setAttribute("error", "Please wait " + wait + "s before requesting a new OTP.");
                req.getRequestDispatcher("/forgot_password.jsp").forward(req, resp);
                return;
            }

            // OTP 6 số + hash
            String otp = generateOtp();
            String otpHash = MD5PasswordHasher.hashPassword(otp); // ✔ Lưu HASH, không lưu thô

            // Nội dung email
            String html = """
                <div style="font-family:Arial;line-height:1.6">
                  <h3>Password Reset OTP</h3>
                  <p>Your OTP is:</p>
                  <div style="font-size:24px;font-weight:700">%s</div>
                  <p>This OTP will expire in %d minutes.</p>
                  <p>If you didn't request this, you can ignore this email.</p>
                </div>
            """.formatted(otp, OTP_TTL_MIN);

            // ✔ BẮT MessagingException NGAY TẠI ĐÂY
            try {
                EmailUtil mail = new EmailUtil(getServletContext());
                mail.send(email, "Your OTP for password reset", html);
            } catch (MessagingException me) {
                me.printStackTrace();
                req.setAttribute("error", "Could not send OTP email. Please try again.");
                req.getRequestDispatcher("/forgot_password.jsp").forward(req, resp);
                return;
            }

            // ✔ Mỗi lần yêu cầu mới -> vô hiệu hoá OTP cũ bằng cách GHI ĐÈ session
            ss.setAttribute("fp_email", email);
            ss.setAttribute("fp_otp_hash", otpHash);
            ss.setAttribute("fp_exp", now + OTP_TTL_MIN * 60_000L); // TTL 5'
            ss.setAttribute("fp_attempts", 0);                      // ✔ reset số lần sai
            ss.setAttribute("fp_last_sent", now);
            ss.setAttribute("otp_ttl_min", OTP_TTL_MIN);

            resp.sendRedirect(req.getContextPath() + "/verify");
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Could not process your request. Please try again.");
            req.getRequestDispatcher("/forgot_password.jsp").forward(req, resp);
        }
    }
}
