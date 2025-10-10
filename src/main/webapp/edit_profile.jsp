<%-- 
    Document   : editprofile
    Created on : Oct 10, 2025, 1:46:03 PM
    Author     : hau
--%>

<%@page import="model.Customer"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Customer c = (Customer) request.getAttribute("customer");
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Edit Profile</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background:#f4f6f8;
                padding:30px;
            }
            .container {
                max-width:800px;
                margin:0 auto;
                background:#fff;
                padding:20px;
                border-radius:8px;
                box-shadow:0 2px 6px rgba(0,0,0,0.08);
            }
            label {
                display:block;
                margin-top:10px;
                font-weight:600;
                color:#333;
            }
            input[type="text"], input[type="email"], input[type="date"], select, textarea {
                width:90%;
                padding:8px 10px;
                margin-top:6px;
                border:1px solid #ddd;
                border-radius:6px;
            }
            input[type="name"], input[type="address"], input[type="password"], input[type="image"], select, textarea {
                width:95%;
                padding:8px 10px;
                margin-top:6px;
                border:1px solid #ddd;
                border-radius:6px;
            }
            .row {
                display:flex;
                gap:12px;
            }
            .col {
                flex:1;
            }
            .btn {
                margin-top:14px;
                padding:10px 16px;
                border-radius:6px;
                border:none;
                font-weight:600;
                cursor:pointer;
            }
            .btn-save {
                background:#2e7d32;
                color:#fff;
            }
            .btn-cancel {
                background:#eee;
                color:#333;
                margin-left:8px;
            }
            .avatar-preview {
                width:100px;
                height:100px;
                border-radius:50%;
                object-fit:cover;
                margin-top:10px;
            }
            .error {
                color:#b00020;
                margin-top:10px;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h2>Edit Profile</h2>
            <form method="post" action="<%=ctx%>/edit_profile">
                <input type="hidden" name="customerID" value="<%= (c != null ? c.getCustomer_id() : "")%>" />
                <label>User Name</label>
                <input type="name" name="customer_name" value="<%= (c != null ? c.getCustomer_name() : "")%>" required />

                <div class="row">
                    <div class="col">
                        <label>Phone</label>
                        <input type="text" name="phone" value="<%= (c != null ? c.getPhone() : "")%>" />
                    </div>
                    <div class="col">
                        <label>Email</label>
                        <input type="email" name="email" value="<%= (c != null ? c.getEmail() : "")%>" />
                    </div>
                </div>

                <label>Address</label>
                <input type="address" name="address" value="<%= (c != null ? c.getAddress() : "")%>" />

                <label>Password</label>
                <input type="password" name="password" value="<%= (c != null ? c.getPassword() : "")%>" />

                <div class="row">
                    <div class="col">
                        <label>Date of Birth</label>
                        <input type="date" name="dob" value="<%= (c != null && c.getDob() != null ? c.getDob().toString() : "")%>" />
                    </div>
                    <div class="col">
                        <label>Gender</label>
                        <select name="gender">
                            <option value="Male"  <%= (c != null && "Male".equalsIgnoreCase(c.getGender()) ? "selected" : "")%>>Male</option>
                            <option value="Female" <%= (c != null && "Female".equalsIgnoreCase(c.getGender()) ? "selected" : "")%>>Female</option>
                        </select>
                    </div>
                </div>
                <label>Avatar path (optional)</label>
                <input type="image" name="image" value="<%= (c != null ? c.getImage() : "images/2.jpg")%>" />
                <img src="<%= (c != null && c.getImage() != null && !c.getImage().isEmpty() ? (c.getImage().startsWith("/") ? ctx + c.getImage() : (c.getImage().startsWith("http") ? c.getImage() : ctx + "/" + c.getImage())) : ctx + "/images/2.jpg")%>" alt="image" class="image-preview"/>

                <div>
                    <button type="submit" class="btn btn-save">Save</button>
                    <a href="<%=ctx%>/profile" class="btn btn-cancel" style="text-decoration:none; display:inline-block; padding:10px 14px; border-radius:6px;">Cancel</a>
                </div>
            </form>
        </div>
    </body>
</html>
