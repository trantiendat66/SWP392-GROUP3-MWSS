<%-- 
    Document   : verify_otp
    Created on : Oct 11, 2025, 9:16:26 PM
    Author     : Oanh Nguyen
--%>

<%@ page contentType="text/html; charset=UTF-8" %>
<%
  String ctx = request.getContextPath();
  String err = (String) request.getAttribute("error");
  String email = (String) session.getAttribute("fp_email");
  Integer ttl = (Integer) session.getAttribute("otp_ttl_min");
  if (ttl == null) ttl = 5;
%>
<!DOCTYPE html>
<html><head><meta charset="UTF-8"><title>Verify OTP</title>
        <style>
            body{
                font-family:Arial;
                background:#f4f6f8;
                margin:0
            }
            .box{
                max-width:520px;
                margin:60px auto;
                background:#fff;
                border-radius:12px;
                box-shadow:0 8px 24px rgba(0,0,0,.08);
                padding:24px
            }
            h2{
                color:#1d4ed8;
                margin-top:0
            }
            label{
                font-weight:600
            }
            input{
                width:100%;
                padding:12px;
                border:1px solid #e5e7eb;
                border-radius:8px
            }
            .grid{
                display:grid;
                grid-template-columns:1fr 1fr;
                gap:12px
            }
            .btn{
                width:100%;
                padding:12px;
                border:0;
                border-radius:10px;
                background:#1d4ed8;
                color:#fff;
                font-weight:700;
                cursor:pointer
            }
            .err{
                background:#fee2e2;
                color:#b91c1c;
                padding:10px;
                border-radius:8px;
                margin:12px 0
            }
            .timer{
                font-size:14px;
                color:#334155;
                margin-bottom:8px
            }
        </style>
        <script>
    let remain = <%=ttl * 60%>; // giây
    function tick() {
        const el = document.getElementById('timer');
        if (!el)
            return;
        if (remain <= 0) {
            el.textContent = "OTP expired. Please request a new OTP.";
            return;
        }
        const m = Math.floor(remain / 60), s = remain % 60;
        el.textContent = `OTP expires in ${m}:${s.toString().padStart(2,'0')}`;
        remain--;
        setTimeout(tick, 1000);
    }
    window.onload = tick;
        </script>
    </head>
    <body>
        <div class="box">
            <h2>Verify OTP</h2>
            <div class="timer" id="timer"></div>
            <p>Email: <b><%= email==null?"(unknown)":email %></b></p>
            <% if (err != null) { %><div class="err"><%=err%></div><% } %>

            <form method="post" action="<%=ctx%>/verify">
                <label>OTP</label>
                <input type="text" name="otp" maxlength="6" placeholder="6-digit OTP" required style="margin:8px 0 16px">
                <div class="grid">
                    <div>
                        <label>New Password</label>
                        <input type="password" name="password" required>
                    </div>
                    <div>
                        <label>Confirm Password</label>
                        <input type="password" name="confirm" required>
                    </div>
                </div>
                <div style="margin-top:16px">
                    <button class="btn" type="submit">Reset Password</button>
                </div>
            </form>

            <div style="margin-top:12px;font-size:14px">
                Didn’t get OTP? Go back to <a href="<%=ctx%>/forgot">send again</a>.
            </div>
        </div>
    </body></html>

