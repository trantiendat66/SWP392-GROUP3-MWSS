<%-- 
    Document   : profile
    Created on : Oct 10, 2025, 1:45:23 PM
    Author     : hau
--%>

<%@ page import="model.Customer,model.Staff" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    String ctx = request.getContextPath();
    Object user = request.getAttribute("user");
    String type = (String) request.getAttribute("userType");

    String avatarPath = ctx + "/images/2.jpg"; // mặc định
    String name = "-";
    String status = "";

    if ("customer".equals(type)) {
        Customer c = (Customer) user;
        if (c != null && c.getImage() != null && !c.getImage().isEmpty()) {
            avatarPath = ctx + "/" + c.getImage();
        }
        name = c != null ? c.getCustomer_name() : "-";
        status = c != null ? c.getAccount_status() : "";
    } else if ("staff".equals(type)) {
        Staff s = (Staff) user;
        name = s != null ? s.getUserName() : "-";
        status = s != null ? s.getStatus() : "";
    }
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
            }
            .card {
                max-width:900px;
                margin:0 auto;
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
            .btn-back {
                background:#eee;
                color:#333;
                margin-left:8px;
            }
            .btn-password {
                background:#43a047;
                color:white;
                margin-left:8px;
            }
            .small {
                font-size:13px;
                color:#666;
            }
        </style>
    </head>
    <body>
        <div class="card">
            <div class="left">
                <img src="<%= avatarPath%>" alt="Avatar" class="avatar" />
                <div class="name"><%= name%></div>
                <div class="status small"><%= status%></div>
            </div>

            <div class="right">
                <h2><%= "staff".equals(type) ? "Staff Profile" : "Customer Profile"%></h2>

                <% if ("staff".equals(type)) {
                        Staff s = (Staff) user;%>
                <div class="row"><div class="label">User Name</div><div class="value"><%= s.getUserName()%></div></div>
                <div class="row"><div class="label">Email</div><div class="value"><%= s.getEmail()%></div></div>
                <div class="row"><div class="label">Phone</div><div class="value"><%= s.getPhone()%></div></div>
                <div class="row"><div class="label">Role</div><div class="value"><%= s.getRole()%></div></div>
                <div class="row"><div class="label">Position</div><div class="value"><%= s.getPosition()%></div></div>
                <div class="row"><div class="label">Address</div><div class="value"><%= s.getAddress()%></div></div>
                <div class="row"><div class="label">Status</div><div class="value"><%= s.getStatus()%></div></div>

                <% } else {
                    Customer c = (Customer) user;%>
                <div class="row"><div class="label">User Name</div><div class="value"><%= c.getCustomer_name()%></div></div>
                <div class="row"><div class="label">Phone</div><div class="value"><%= c.getPhone()%></div></div>
                <div class="row"><div class="label">Email</div><div class="value"><%= c.getEmail()%></div></div>
                <div class="row"><div class="label">Address</div><div class="value"><%= c.getAddress()%></div></div>
                <div class="row"><div class="label">Date of Birth</div><div class="value"><%= (c.getDob() != null ? c.getDob().toString() : "-")%></div></div>
                <div class="row"><div class="label">Gender</div><div class="value"><%= c.getGender()%></div></div>
                <div class="row"><div class="label">Account Status</div><div class="value"><%= c.getAccount_status()%></div></div>
                    <% }%>

                <div class="actions">
                    <% if ("staff".equals(type)) {%>
                    <a href="<%= ctx%>/edit_staff_profile" class="btn btn-edit">Edit Profile</a>
                    <% } else {%>
                    <a href="<%= ctx%>/edit_profile" class="btn btn-edit">Edit Profile</a>
                    <% } %>
                    
<!--                    <a href="<%= ctx%>/edit_profile" class="btn btn-edit">Edit Profile</a>-->
                    
                    <a href="<%= ctx%>/change_password" class="btn btn-password">Change Password</a>
                    <% if ("staff".equals(type)) {%>
                    <a href="<%= ctx%>/staffcontrol" class="btn btn-back">Back</a>
                    <% } else {%>
                    <a href="<%= ctx%>/home" class="btn btn-back">Back</a>
                    <% } %>
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

