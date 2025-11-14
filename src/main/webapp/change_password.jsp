<%-- 
    Document   : change_password
    Created on : Oct 15, 2025, 9:54:07 AM
    Author     : hau
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Change Password</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background: #f4f4f9;
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
                margin: 0;
            }
            .container {
                background: white;
                padding: 30px;
                border-radius: 10px;
                box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
                width: 400px;
                text-align: center;
            }
            h2 {
                margin-bottom: 20px;
            }
            label {
                display: block;
                text-align: left;
                margin: 10px 0 5px;
                font-weight: bold;
            }
            input[type="password"] {
                width: 100%;
                padding: 10px;
                margin-bottom: 15px;
                border: 1px solid #ccc;
                border-radius: 5px;
            }
            button {
                width: 100%;
                padding: 10px;
                background: #007bff;
                color: white;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                font-size: 16px;
            }
            button:hover {
                background: #0056b3;
            }
            .link {
                display: block;
                margin-top: 10px;
                text-decoration: none;
                color: #333;
            }
            .error {
                color: red;
                margin-top: 10px;
            }
        </style>
    </head>
    <body>
        <%
            String ctx = request.getContextPath();
            String cancelLink = ctx + "/profile"; // mặc định là customer
            if (session.getAttribute("staff") != null) {
                cancelLink = ctx + "/staff_profile"; // nếu là staff thì đổi
            }
        %>
        <div class="container">
            <h2>Change Password</h2>
            <form action="change_password" method="post">
                <label>Old Password</label>
                <input type="password" name="oldPassword" >

                <label>New Password</label>
                <input type="password" name="newPassword" >

                <label>Confirm New Password</label>
                <input type="password" name="confirmPassword" >

                <button type="submit">Update Password</button>
                <a class="link" href="<%= cancelLink %>">Cancel</a>
            </form>

            <% if (request.getAttribute("error") != null) {%>
            <p class="error"><%= request.getAttribute("error")%></p>
            <% }%>
        </div>
    </body>
</html>