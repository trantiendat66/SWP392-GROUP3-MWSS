<%-- 
    Document   : profile
    Created on : Oct 10, 2025, 1:45:23 PM
    Author     : hau
--%>

<%@ page import="model.Customer,model.Staff" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    String ctx = request.getContextPath();
    Customer c = (Customer) request.getAttribute("user");

    String avatarPath = ctx + "/image/2.jpg"; // ảnh mặc định
    if (c != null && c.getImage() != null && !c.getImage().isEmpty()) {
        avatarPath = ctx + "/" + c.getImage();
    }

    String name = c != null ? c.getCustomer_name() : "-";
    String status = c != null ? c.getAccount_status() : "";
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
                background:#f4f6f8;
                padding:30px;
                display:flex;
                justify-content:center;
                align-items:center;
                min-height:80vh;
            }
            .card {
                max-width:900px;
                background:#fff;
                border-radius:8px;
                box-shadow:0 2px 6px rgba(0,0,0,0.1);
                display:flex;
                overflow:hidden;
            }
            .left {
                width:320px;
                padding:30px;
                background:linear-gradient(180deg,#ffffff,#f7f9fb);
                text-align:center;
            }
            .avatar {
                width:160px;
                height:160px;
                border-radius:50%;
                object-fit:cover;
                border:6px solid #fff;
                box-shadow:0 2px 6px rgba(0,0,0,0.1);
                background:#ddd;
            }
            .name {
                font-size:20px;
                margin-top:12px;
                font-weight:700;
            }
            .status {
                color:#777;
                margin-top:6px;
                font-size:14px;
            }
            .right {
                flex:1;
                padding:30px 40px;
            }
            .row {
                display:flex;
                margin-bottom:14px;
            }
            .label {
                width:170px;
                color:#555;
                font-weight:600;
            }
            .value {
                color:#222;
            }
            .actions {
                margin-top:20px;
                display:flex;
                flex-wrap:nowrap;
                gap:10px;
                justify-content:center;
            }
            .btn {
                display:inline-block;
                padding:10px 16px;
                border-radius:6px;
                text-decoration:none;
                font-weight:600;
            }
            .btn-edit {
                background:#1976d2;
                color:#fff;
            }
            .btn-password {
                background:#43a047;
                color:white;
            }
            .btn-order{
                background:#E8C920;
                color:#fff;
            }
            .btn-back {
                background:#eee;
                color:#333;
            }
        </style>
    </head>
    <body>
        <div class="card">
            <div class="left">
                <img src="<%= avatarPath%>" alt="Avatar" class="avatar" />
                <div class="name"><%= name%></div>
                <div class="status"><%= status%></div>
            </div>

            <div class="right">
                <h2>Customer Profile</h2>

                <div class="row"><div class="label">User Name</div><div class="value"><%= c.getCustomer_name()%></div></div>
                <div class="row"><div class="label">Phone</div><div class="value"><%= c.getPhone()%></div></div>
                <div class="row"><div class="label">Email</div><div class="value"><%= c.getEmail()%></div></div>
                <div class="row"><div class="label">Address</div><div class="value"><%= c.getAddress()%></div></div>
                <div class="row"><div class="label">Date of Birth</div><div class="value"><%= (c.getDob() != null ? c.getDob().toString() : "-")%></div></div>
                <div class="row"><div class="label">Gender</div><div class="value"><%= c.getGender()%></div></div>
                <div class="row"><div class="label">Account Status</div><div class="value"><%= c.getAccount_status()%></div></div>

                <div class="actions">
                    <a href="<%= ctx%>/edit_profile" class="btn btn-edit">Edit Profile</a>
                    <a href="<%= ctx%>/change_password" class="btn btn-password">Change Password</a>
                    <a href="<%= ctx%>/orders?tab=placed" class="btn btn-order">Order History</a>
                    <a href="<%= ctx%>/home" class="btn btn-back">Back</a>
                </div>
            </div>
        </div>

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

