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
<%@ include file="/WEB-INF/include/header.jsp" %>
        <style>
            .edit-profile-page {
                font-family: Arial, sans-serif;
                background:#f4f6f8;
                padding:24px 0;
                min-height:60vh;
            }
            .profile-box {
                max-width:800px;
                margin:0 auto;
                background:#fff;
                padding:20px;
                border-radius:8px;
                box-shadow:0 2px 6px rgba(0,0,0,0.08);
            }
            .edit-profile-page label {
                display:block;
                margin-top:10px;
                font-weight:600;
                color:#333;
            }
            .edit-profile-page input[type="text"],
            .edit-profile-page input[type="email"],
            .edit-profile-page input[type="date"],
            .edit-profile-page select,
            .edit-profile-page textarea {
                width:90%;
                padding:8px 10px;
                margin-top:6px;
                border:1px solid #ddd;
                border-radius:6px;
            }
            .edit-profile-page input[type="name"],
            .edit-profile-page input[type="address"],
            .edit-profile-page input[type="password"],
            .edit-profile-page input[type="image"],
            .edit-profile-page select,
            .edit-profile-page textarea {
                width:95%;
                padding:8px 10px;
                margin-top:6px;
                border:1px solid #ddd;
                border-radius:6px;
            }
            .edit-profile-page .row {
                display:flex;
                gap:12px;
            }
            .edit-profile-page .col {
                flex:1;
            }
            .edit-profile-page .btn {
                margin-top:14px;
                padding:10px 16px;
                border-radius:6px;
                border:none;
                font-weight:600;
                cursor:pointer;
            }
            .edit-profile-page .btn-save {
                background:#2e7d32;
                color:#fff;
            }
            .edit-profile-page .btn-cancel {
                background:#eee;
                color:#333;
                margin-left:8px;
            }
            .edit-profile-page .avatar-preview {
                width:100px;
                height:100px;
                border-radius:50%;
                object-fit:cover;
                margin-top:10px;
            }
            .edit-profile-page .error {
                color:#b00020;
                margin-top:10px;
            }
        </style>
        <div class="edit-profile-page">
        <div class="profile-box">
            <h2>Edit Profile</h2>
            <form method="post" action="<%=ctx%>/edit_profile" enctype="multipart/form-data">
                <input type="hidden" name="customerID" value="<%= (c != null ? c.getCustomer_id() : "")%>" />
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
                    model.Staff staffUser = (model.Staff) session.getAttribute("staff");
                    boolean isAdmin = (staffUser != null && "Admin".equalsIgnoreCase(staffUser.getRole()));
                %>

                <% if (isAdmin) {%>
                <label>Account Status</label>
                <select name="account_status" style="width:95%; padding:8px 10px; border:1px solid #ddd; border-radius:6px;">
                    <option value="Active"   <%= ("Active".equalsIgnoreCase(c.getAccount_status()) ? "selected" : "")%>>Active</option>
                    <option value="Inactive" <%= ("Inactive".equalsIgnoreCase(c.getAccount_status()) ? "selected" : "")%>>Inactive</option>
                </select>
                <% } %>
                <div>
                    <button type="submit" class="btn btn-save">Save</button>

                    <% if (isAdmin) {%>
                    <a href="<%= ctx%>/admin/customerlist" class="btn btn-cancel">Cancel</a>
                    <% } else {%>
                    <a href="<%= ctx%>/profile" class="btn btn-cancel">Cancel</a>
                    <% }%>
                </div>
                <% if (request.getAttribute("noChangeError") != null) { %>
    <p class="error"><%= request.getAttribute("noChangeError") %></p>
<% } %>

            </form>
        </div>
        </div>
    <jsp:include page="/WEB-INF/include/footer.jsp" />
