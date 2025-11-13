<%-- 
    Document   : forgot_password
    Created on : Oct 11, 2025, 9:15:55 PM
    Author     : Oanh Nguyen
--%>

<%@ page contentType="text/html; charset=UTF-8" %>
<%
  String ctx  = request.getContextPath();
  String err  = (String) request.getAttribute("error");
  String info = (String) request.getAttribute("info");
  String email = request.getParameter("email")==null?"":request.getParameter("email");
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Forgot Password - WatchStore</title>
        <style>
            /* ===== Background (giống login/register) ===== */
            body{
                margin:0;
                padding:0;
                height:100vh;
                background:url("${pageContext.request.contextPath}/assert/image/login-bg.jpg") no-repeat center center fixed;
                background-size:cover;
                display:flex;
                justify-content:center;
                align-items:center;
                font-family:"Poppins", Arial, sans-serif;
            }
            /* ===== Container ===== */
            .auth-container{
                text-align:center;
                color:#fff;
                padding:60px 0;
            }
            h2{
                display:block;
                width:440px;
                margin:0 auto 18px;
                font-size:26px;
                font-weight:700;
                text-shadow:0 0 8px rgba(0,0,0,.6);
            }
            /* ===== Box ===== */
            .input-box{
                background:rgba(20,20,20,.9);
                padding:40px 45px;
                border-radius:14px;
                width:440px;
                text-align:left;
                box-shadow:0 0 25px rgba(0,0,0,.6);
                margin:12px auto 0;
            }
            .field{
                margin-bottom:16px;
            }
            label{
                display:block;
                margin-bottom:6px;
                font-size:13px;
                color:rgba(255,255,255,.85);
                font-weight:600;
            }
            input{
                width:100%;
                padding:12px;
                border:none;
                border-radius:6px;
                background:rgba(255,255,255,.15);
                color:#fff;
                font-size:14px;
                outline:none;
                box-sizing:border-box;
            }
            input::placeholder{
                color:rgba(255,255,255,.6);
            }
            button{
                width:100%;
                padding:13px;
                border:none;
                border-radius:6px;
                background:#e50914;
                color:#fff;
                font-size:15px;
                font-weight:bold;
                cursor:pointer;
                transition:background .3s;
            }
            button:hover{
                background:#b00610;
            }
            .links{
                display:flex;
                justify-content:space-between;
                margin-top:20px;
                font-size:13px;
                width:440px;
                margin-left:auto;
                margin-right:auto;
            }
            .links a{
                color:#ccc;
                text-decoration:none;
                transition:color .3s;
            }
            .links a:hover{
                color:#fff;
            }
            .note{
                background:rgba(14,165,233,.15);
                color:#bae6fd;
                border:1px solid rgba(14,165,233,.35);
                padding:10px 12px;
                border-radius:8px;
                margin-bottom:12px;
                font-size:14px;
            }
            .error{
                color:#ff6666;
                background:rgba(255,102,102,.15);
                border:1px solid rgba(255,102,102,.35);
                padding:10px 12px;
                border-radius:8px;
                margin-bottom:12px;
                font-size:14px;
            }
        </style>
    </head>
    <body>

        <form action="<%=ctx%>/forgot" method="post" accept-charset="UTF-8">
            <div class="auth-container">
                <h2>Resend Email Confirmation</h2>

                <div class="input-box">
                    <% if (info != null) { %><div class="note"><%= info %></div><% } %>
                    <% if (err  != null) { %><div class="error"><%= err  %></div><% } %>

                    <div class="field">
                        <label>Email</label>
                        <input type="email" name="email" value="<%=email%>" placeholder="your@email.com" required>
                    </div>

                    <button type="submit">Send OTP Email</button>
                </div>

                <div class="links">
                    <a href="<%=ctx%>/verify">Already have an OTP?</a>
                    <a href="<%=ctx%>/login">Back to Login</a>
                </div>
            </div>
        </form>

    </body>
</html>
