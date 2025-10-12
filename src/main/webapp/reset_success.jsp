<%-- 
    Document   : reset_success
    Created on : Oct 11, 2025, 9:16:44 PM
    Author     : Oanh Nguyen
--%>

<%@ page contentType="text/html; charset=UTF-8" %>
<%
  String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html><head><meta charset="UTF-8"><title>Password Reset</title>
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
                padding:24px;
                text-align:center
            }
            .btn{
                display:inline-block;
                padding:10px 16px;
                border-radius:8px;
                background:#1d4ed8;
                color:#fff;
                text-decoration:none;
                font-weight:700
            }
        </style></head>
    <body>
        <div class="box">
            <h2>Password reset successfully 🎉</h2>
            <p>You can now log in with your new password.</p>
            <a class="btn" href="<%=ctx%>/login">Go to Login</a>
        </div>
    </body></html>
