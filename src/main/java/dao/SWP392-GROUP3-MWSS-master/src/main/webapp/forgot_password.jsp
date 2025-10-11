<%-- 
    Document   : forgot_password
    Created on : Oct 11, 2025, 9:15:55 PM
    Author     : Oanh Nguyen
--%>

<%@ page contentType="text/html; charset=UTF-8" %>
<%
  String ctx = request.getContextPath();
  String err = (String) request.getAttribute("error");
  String info = (String) request.getAttribute("info");
  String email = request.getParameter("email")==null?"":request.getParameter("email");
%>
<!DOCTYPE html>
<html><head><meta charset="UTF-8"><title>Forgot Password</title>
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
            .note{
                background:#e0f2fe;
                color:#0369a1;
                padding:10px;
                border-radius:8px;
                margin:12px 0
            }
            .err{
                background:#fee2e2;
                color:#b91c1c;
                padding:10px;
                border-radius:8px;
                margin:12px 0
            }
            .link{
                font-size:14px;
                margin-top:12px
            }
        </style></head>
    <body>
        <div class="box">
            <h2>Resend Email Confirmation</h2>
            <% if (info != null) { %><div class="note"><%=info%></div><% } %>
            <% if (err  != null) { %><div class="err"><%=err%></div><% } %>
            <form method="post" action="<%=ctx%>/forgot">
                <label>Email</label>
                <input type="email" name="email" value="<%=email%>" required style="margin:8px 0 16px">
                <button class="btn" type="submit">Send OTP Email</button>
            </form>
            <div class="link">Already have an OTP? <a href="<%=ctx%>/verify">Enter here</a></div>
        </div>
    </body></html>
