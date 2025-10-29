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
    String source = (String) request.getAttribute("source");
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
            <form method="post" action="<%=ctx%>/edit_profile" enctype="multipart/form-data">
                <input type="hidden" name="" value="<%= (c != null ? c.getCustomer_id() : "")%>" /> <!-- customerID -->
                <label>User Name</label>
                <input type="name" name="customer_name" value="<%= (c != null ? c.getCustomer_name() : "")%>" />
                <% if (request.getAttribute("nameError") != null) {%>
                <p class="error"><%= request.getAttribute("nameError")%></p>
                <% }%>

                <div class="row">
                    <div class="col">
                        <label>Phone</label>
                        <input type="text" name="phone" value="<%= (c != null ? c.getPhone() : "")%>"/>
                        <% if (request.getAttribute("phoneError") != null) {%>
                        <p class="error"><%= request.getAttribute("phoneError")%></p>
                        <% }%>
                    </div>
                    <div class="col">
                        <label>Email</label>
                        <input type="email" name="email" value="<%= (c != null ? c.getEmail() : "")%>" />
                        <% if (request.getAttribute("emailError") != null) {%>
                        <p class="error"><%= request.getAttribute("emailError")%></p>
                        <% }%>
                    </div>
                </div>

                <label>Address</label>
                <input type="address" name="address" value="<%= (c != null ? c.getAddress() : "")%>" />
                <% if (request.getAttribute("addressError") != null) {%>
                <p class="error"><%= request.getAttribute("addressError")%></p>
                <% }%>


                <div class="row">
                    <div class="col">
                        <label>Date of Birth</label>
                        <input type="date" name="dob" value="<%= (c != null && c.getDob() != null ? c.getDob().toString() : "")%>"/>
                        <% if (request.getAttribute("dobError") != null) {%>
                        <p class="error"><%= request.getAttribute("dobError")%></p>
                        <% }%>
                    </div>
                    <div class="col">
                        <label>Gender</label>
                        <select name="gender">
                            <option value="Male"  <%= (c != null && "Male".equalsIgnoreCase(c.getGender()) ? "selected" : "")%>>Male</option>
                            <option value="Female" <%= (c != null && "Female".equalsIgnoreCase(c.getGender()) ? "selected" : "")%>>Female</option>
                        </select>
                    </div>
                </div>
                <%
                    String avatarPath;
                    if (c != null && c.getImage() != null && !c.getImage().isEmpty()) {

                        if (c.getImage().startsWith("http")) {
                            avatarPath = c.getImage();
                        }
                        else {
                            avatarPath = ctx + "/" + c.getImage();
                        }
                    } else {
                        avatarPath = ctx + "/assert/avatar/avatar_md.jpg";
                    }
                    String avatarWithVersion = avatarPath + "?v=" + System.currentTimeMillis();
                %>
                <label>Avatar (Upload)</label>
                <input type="file" name="image" accept="image/*" onchange="previewImage(event)">
                <img id="preview" class="avatar-preview" src="<%=avatarWithVersion%>">
                <script>
                    function previewImage(event) {
                        const reader = new FileReader();
                        reader.onload = function () {
                            document.getElementById('preview').src = reader.result;
                        };
                        reader.readAsDataURL(event.target.files[0]);
                    }
                </script>
                <div>
                    <button type="submit" class="btn btn-save">Save</button>
                    <% if ("admin".equals(source)) {%> <!-- * -->
                    <a href="<%=ctx%>/admin/customerlist" class="btn btn-cancel" 
                       style="text-decoration:none; display:inline-block; padding:10px 14px; border-radius:6px;">Cancel</a>
                    <% } else {%>
                    <a href="<%=ctx%>/profile" class="btn btn-cancel" 
                       style="text-decoration:none; display:inline-block; padding:10px 14px; border-radius:6px;">Cancel</a>
                    <% }%>
                </div>
            </form>
        </div>
    </body>
</html>
