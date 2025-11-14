<%-- 
    Document   : staff_profile
    Created on : Oct 21, 2025, 9:35:14 AM
    Author     : hau
--%>

<%@page import="model.Staff"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String ctx = request.getContextPath();
    Staff s = (Staff) request.getAttribute("user");

    String name = (s != null) ? s.getUserName() : "-";
    String status = (s != null) ? s.getStatus() : "-";
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Profile</title>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <style>
         body {
                font-family: Arial, sans-serif;
                background: #f4f6f8;
                padding: 30px;
                display: flex;
                justify-content: center;
                align-items: center;
                min-height: 90vh;
            }
            .card {
                width: 550px;
                background: #fff;
                border-radius: 10px;
                box-shadow: 0 3px 8px rgba(0,0,0,0.1);
                padding: 40px;
            }
            h2 {
                text-align: center;
                color: #1976d2;
                margin-bottom: 25px;
            }
            .info {
                margin-bottom: 15px;
            }
            .row {
                display: flex;
                justify-content: center;  /* Đẩy toàn hàng ra giữa */
                align-items: center;
                padding: 4px 0;
                border-bottom: 1px solid #eee;
            }
            .row-inner {
                display: flex;
                width: 55%; /* Chiều rộng vừa phải để gom nội dung vào giữa */
            }
            .label {
                width: 150px;
                color: #555;
                font-weight: 600;
                text-align: left;
            }
            .value {
                flex: 1;
                color: #222;
                text-align: left;
                margin-left: 25px;
            }
            .actions {
                margin-top: 25px;
                display: flex;
                justify-content: center;
                flex-wrap: wrap;
                gap: 12px;
            }
            .btn {
                padding: 10px 18px;
                border-radius: 6px;
                text-decoration: none;
                font-weight: 600;
                transition: 0.2s;
            }
            .btn:hover {
                opacity: 0.9;
            }
            .btn-edit {
                background: #1976d2;
                color: #fff;
            }
            .btn-password {
                background: #43a047;
                color: #fff;
            }
            .btn-back {
                background: #eee;
                color: #333;
            }
        </style>
    </head>
    <body>
        <div class="card">
            <h2>Staff Profile</h2>

            <% if (s != null) {%>
            <div class="info">
                <div class="row"><div class="row-inner"><div class="label">User Name:</div><div class="value"><%= s.getUserName()%></div></div></div>
                <div class="row"><div class="row-inner"><div class="label">Email:</div><div class="value"><%= s.getEmail()%></div></div></div>
                <div class="row"><div class="row-inner"><div class="label">Phone:</div><div class="value"><%= s.getPhone()%></div></div></div>
                <div class="row"><div class="row-inner"><div class="label">Role:</div><div class="value"><%= s.getRole()%></div></div></div>
                <div class="row"><div class="row-inner"><div class="label">Position:</div><div class="value"><%= s.getPosition()%></div></div></div>
                <div class="row"><div class="row-inner"><div class="label">Address:</div><div class="value"><%= s.getAddress()%></div></div></div>
                <div class="row"><div class="row-inner"><div class="label">Status:</div><div class="value"><%= s.getStatus()%></div></div></div>
            </div>
            <% } else { %>
            <p style="text-align:center;color:#888;">No staff information available.</p>
            <% }%>

            <div class="actions">
                <a href="<%= ctx%>/edit_staff_profile" class="btn btn-edit">Edit Profile</a>
                <a href="<%= ctx%>/change_password" class="btn btn-password">Change Password</a>
                <a href="<%= ctx%>/staffcontrol" class="btn btn-back">Back</a>
            </div>
        </div>
            <% 
    String successMessage = (String) session.getAttribute("successMessage");
    if (successMessage != null) {
        session.removeAttribute("successMessage");
%>
<script>
    Swal.fire({
        icon: 'success',
        title: 'Success!',
        text: '<%= successMessage %>',
        timer: 2000,
        showConfirmButton: false
    });
</script>
<% } %>


        <% String updateStatus = (String) session.getAttribute("updateStatus");
        if (updateStatus != null) {
            session.removeAttribute("updateStatus"); %>
        <script>
            <% if ("success".equals(updateStatus)) { %>
        Swal.fire({
            icon: 'success',
            title: 'Updated!',
            text: 'Your profile has been updated successfully.',
            timer: 2000,
            showConfirmButton: false
        });
            <% } else { %>
        Swal.fire({
            icon: 'error',
            title: 'Update Failed!',
            text: 'Something went wrong. Please try again.',
            timer: 2000,
            showConfirmButton: false
        });
            <% } %>
        </script>
        <% }%>
    </body>
</html>
