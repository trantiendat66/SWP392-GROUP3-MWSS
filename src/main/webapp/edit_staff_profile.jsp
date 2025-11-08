<%-- 
    Document   : edit_staff_profile
    Created on : Oct 19, 2025, 8:43:17 PM
    Author     : hau
--%>

<%@page import="model.Staff"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Staff s = (Staff) request.getAttribute("staff");
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Edit Staff Profile</title>
        <style>
            body {
                font-family: Arial;
                background:#f4f6f8;
                padding:30px;
            }
            .container {
                max-width:800px;
                margin:auto;
                background:#fff;
                padding:20px;
                border-radius:8px;
                box-shadow:0 2px 6px rgba(0,0,0,0.08);
            }
            label {
                display:block;
                margin-top:10px;
                font-weight:600;
            }
            input, textarea {
                width:95%;
                padding:8px;
                margin-top:6px;
                border:1px solid #ddd;
                border-radius:6px;
            }
            .error {
                color:red;
                margin-top:5px;
            }
            .btn {
                padding:10px 16px;
                border:none;
                border-radius:6px;
                cursor:pointer;
                margin-top:14px;
            }
            .btn-save {
                background:green;
                color:#fff;
            }
            .btn-cancel {
                background:#ccc;
                color:#333;
            }
            .avatar-preview {
                width:100px;
                height:100px;
                border-radius:50%;
                object-fit:cover;
                margin-top:10px;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h2>Edit Staff Profile</h2>
            <form method="post" action="<%=ctx%>/edit_staff_profile">
                <label>Username</label>
                <input type="text" name="username" value="<%= (s != null ? s.getUserName() : "")%>" readonly/>

                <label>Phone</label>
                <input type="text" name="phone" value="<%= (s != null ? s.getPhone() : "")%>"/>
                <% if (request.getAttribute("phoneError") != null) {%>
                <p class="error"><%= request.getAttribute("phoneError")%></p>
                <% }%>

                <label>Email</label>
                <input type="email" name="email" value="<%= (s != null ? s.getEmail() : "")%>"/>
                <% if (request.getAttribute("emailError") != null) {%>
                <p class="error"><%= request.getAttribute("emailError")%></p>
                <% }%>

                <label>Address</label>
                <input type="text" name="address" value="<%= (s != null ? s.getAddress() : "")%>"/>
                <% if (request.getAttribute("addressError") != null) {%>
                <p class="error"><%= request.getAttribute("addressError")%></p>
                <% }%>

                <button type="submit" class="btn btn-save">Save</button>
                <a href="<%=ctx%>/staff_profile" class="btn btn-cancel">Cancel</a>
            </form>
        </div>
    </body>
</html>
