f<%-- 
    Document   : admin_edit_customer
    Created on : Nov 14, 2025, 3:28:15 PM
    Author     : Cola
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Customer" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/include/header.jsp" %>

<%
    Customer customer = (Customer) request.getAttribute("customer");
    String ctx = request.getContextPath();
%>

<style>
    html, body {
        margin: 0;
        padding: 0;
        background: #f5f7fb;
        overflow-x: hidden;
    }
    .page-wrap {
        padding: 10px;
        background: #f5f7fb;
    }
    .main-container {
        display: flex;
        gap: 10px;
        align-items: flex-start;
        width: 100%;
        max-width: 1500px;
        margin: 0 auto;
        overflow: hidden;
    }
    .sidebar {
        width: 300px;
        min-width: 220px;
        max-width: 320px;
        background: #fff;
        padding: 22px;
        box-shadow: 2px 0 8px rgba(0,0,0,0.03);
        border-radius: 8px;
        flex-shrink: 0;
        position: relative;
    }
    .profile-card {
        text-align: center;
        margin-bottom: 18px;
    }
    .profile-avatar {
        width: 72px;
        height: 72px;
        border-radius: 50%;
        object-fit: cover;
        display: inline-block;
        border: 2px solid #e9ecef;
        background: #f0f0f0;
    }
    .profile-role {
        display: block;
        background-color: #000;
        color: #fff;
        font-size: 18px;
        font-weight: 700;
        padding: 8px 16px;
        border-radius: 6px;
        margin-top: 10px;
        width: fit-content;
        margin-left: auto;
        margin-right: auto;
    }
    .profile-name {
        font-size: 16px;
        font-weight: 700;
        margin-top: 8px;
    }
    .nav-menu {
        list-style: none;
        padding: 0;
        margin: 12px 0 0 0;
    }
    .nav-menu li {
        margin-bottom: 10px;
    }
    .nav-link {
        display: block;
        padding: 10px 14px;
        border-radius: 8px;
        color: #333;
        text-decoration: none;
        font-weight: 600;
    }
    .nav-link.active, .nav-link:hover {
        background: #dc3545;
        color: white;
    }
    .main-content {
        background: white;
        flex: 1 1 auto;
        padding: 24px;
        border-radius: 10px;
        box-shadow: 0 2px 14px rgba(0,0,0,0.04);
        min-width: 0;
        overflow-x: auto;
    }
    .controls {
        display: flex;
        justify-content: space-between;
        align-items: center;
        gap: 12px;
        margin-bottom: 18px;
    }
    .page-title {
        font-size: 18px;
        font-weight: 700;
    }
    .btn {
        display: inline-block;
        padding: 9px 18px;
        border-radius: 6px;
        border: none;
        cursor: pointer;
        font-size: 14px;
        font-weight: 600;
    }
    .btn-primary {
        background: #1976d2;
        color: #fff;
    }
    .btn-secondary {
        background: #e0e0e0;
        color: #333;
    }
    .btn-link {
        text-decoration: none;
    }
    .card {
        background:#fff;
        border-radius:10px;
        box-shadow:0 2px 8px rgba(0,0,0,0.04);
        padding:20px 22px;
    }
    .card-title {
        font-size:16px;
        font-weight:700;
        margin-bottom:14px;
        border-bottom:1px solid #eee;
        padding-bottom:8px;
    }
    .form-row {
        display:flex;
        gap:16px;
        margin-bottom:14px;
    }
    .form-group {
        flex:1;
        display:flex;
        flex-direction:column;
    }
    .form-group label {
        font-weight:600;
        font-size:14px;
        margin-bottom:4px;
        color:#333;
    }
    .form-group input,
    .form-group select {
        padding:8px 10px;
        border-radius:6px;
        border:1px solid #ddd;
        font-size:14px;
    }
    .form-group input:focus,
    .form-group select:focus {
        outline:none;
        border-color:#1976d2;
        box-shadow:0 0 0 2px rgba(25,118,210,0.15);
    }
    .error {
        color:#c62828;
        font-size:13px;
        margin-top:4px;
    }
    .card-footer-actions {
        margin-top:18px;
        display:flex;
        justify-content:flex-end;
        gap:10px;
    }

    @media (max-width: 900px) {
        .main-container {
            flex-direction: column;
        }
        .sidebar {
            width: 100%;
            max-width: none;
            display: block;
        }
        .main-content {
            margin-top: 12px;
        }
    }
</style>

<div class="page-wrap">
    <div class="main-container" role="main">

        <!-- MAIN CONTENT -->
        <main class="main-content" aria-label="Admin main content">
            <div class="controls">
                <div class="page-title">
                    Edit Customer
                </div>
            </div>

            <div class="card">
                <form method="post" action="<%=ctx%>/edit_customer">
                    <input type="hidden" name="customerID"
                           value="<%= (customer != null ? customer.getCustomer_id() : "")%>" />

                    <!-- Name -->
                    <div class="form-row">
                        <div class="form-group">
                            <label>User Name</label>
                            <input type="text" name="customer_name"
                                   value="<%= (customer != null ? customer.getCustomer_name() : "")%>" />
                            <% if (request.getAttribute("nameError") != null) {%>
                            <div class="error"><%= request.getAttribute("nameError")%></div>
                            <% }%>
                        </div>
                    </div>

                    <!-- Phone + Email -->
                    <div class="form-row">
                        <div class="form-group">
                            <label>Phone</label>
                            <input type="text" name="phone"
                                   value="<%= (customer != null ? customer.getPhone() : "")%>"/>
                            <% if (request.getAttribute("phoneError") != null) {%>
                            <div class="error"><%= request.getAttribute("phoneError")%></div>
                            <% }%>
                        </div>
                        <div class="form-group">
                            <label>Email</label>
                            <input type="email" name="email"
                                   value="<%= (customer != null ? customer.getEmail() : "")%>" />
                            <% if (request.getAttribute("emailError") != null) {%>
                            <div class="error"><%= request.getAttribute("emailError")%></div>
                            <% }%>
                        </div>
                    </div>



                    <!-- New Password (admin nhập để đổi, sẽ được hash MD5 ở servlet) -->
<!--                    <div class="form-row">
                        <div class="form-group">
                            <label>New Password</label>
                            <input type="password" name="password"
                                   placeholder="Leave blank to keep current password" />
                        </div>
                    </div>-->


                    <!-- Address -->
                    <div class="form-row">
                        <div class="form-group">
                            <label>Address</label>
                            <input type="text" name="address"
                                   value="<%= (customer != null ? customer.getAddress() : "")%>" />
                            <% if (request.getAttribute("addressError") != null) {%>
                            <div class="error"><%= request.getAttribute("addressError")%></div>
                            <% }%>
                        </div>
                    </div>

                    <!-- DOB + Gender -->
                    <div class="form-row">
                        <div class="form-group">
                            <label>Date of Birth</label>
                            <input type="date" name="dob"
                                   value="<%= (customer != null && customer.getDob() != null ? customer.getDob().toString() : "")%>"/>
                            <% if (request.getAttribute("dobError") != null) {%>
                            <div class="error"><%= request.getAttribute("dobError")%></div>
                            <% }%>
                        </div>
                        <div class="form-group">
                            <label>Gender</label>
                            <select name="gender">
                                <option value="Male"  <%= (customer != null && "0".equals(customer.getGender()) ? "selected" : "")%>>Male</option>
                                <option value="Female" <%= (customer != null && "1".equals(customer.getGender()) ? "selected" : "")%>>Female</option>
                            </select>
                        </div>
                    </div>

                    <!-- Account Status -->
                    <div class="form-row">
                        <div class="form-group">
                            <label>Account Status</label>
                            <select name="account_status">
                                <option value="Active"
                                        <%= (customer != null && "Active".equalsIgnoreCase(customer.getAccount_status()) ? "selected" : "")%>>
                                    Active
                                </option>
                                <option value="Inactive"
                                        <%= (customer != null && "Inactive".equalsIgnoreCase(customer.getAccount_status()) ? "selected" : "")%>>
                                    Inactive
                                </option>
                            </select>
                        </div>
                    </div>

                    <div class="card-footer-actions">
                        <a href="<%=ctx%>/admin/customerlist" class="btn btn-secondary btn-link">Cancel</a>
                        <button type="submit" class="btn btn-primary">Save changes</button>
                    </div>
                </form>
            </div>
        </main>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        const logoutBtn = document.getElementById('logoutBtn');
        if (logoutBtn) {
            logoutBtn.addEventListener('click', function () {
                if (confirm('Are you sure you want to logout?')) {
                    window.location.href = '<%=ctx%>/logout';
                }
            });
        }
    });
</script>


<jsp:include page="/WEB-INF/include/footer.jsp" />
