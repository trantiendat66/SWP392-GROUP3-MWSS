<%-- 
    Document   : profile
    Created on : Oct 10, 2025, 1:45:23 PM
    Author     : hau
--%>

<%@ page import="model.Customer,model.Staff" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    String ctx = request.getContextPath();
    Customer c = (Customer) request.getAttribute("user");
    String name = c != null ? c.getCustomer_name() : "-";
    String status = c != null ? c.getAccount_status() : "";
%>
<%@ include file="/WEB-INF/include/header.jsp" %>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <style>
            .profile-page {
                font-family: Arial, sans-serif;
                background:#f4f6f8;
                padding:30px 0;
                display:flex;
                justify-content:center;
                align-items:flex-start;
                min-height:60vh;
            }
            .profile-card {
                max-width:900px;
                background:#fff;
                border-radius:8px;
                box-shadow:0 2px 6px rgba(0,0,0,0.1);
                display:flex;
                flex-direction:row;
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
            .info-row {
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
            .profile-page .btn {
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
        <div class="profile-page">
        <div class="profile-card">
            <div class="left">
                 <img src="${pageContext.request.contextPath}/assert/avatar/default-user.svg"
                     alt="Avatar" class="avatar"
                     onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/assert/image/account.jpg'" />
                <div class="name"><%= name%></div>
                <div class="status"><%= status%></div>
            </div>

            <div class="right">
                <h2>Customer Profile</h2>

                <div class="info-row"><div class="label">User Name</div><div class="value"><%= c.getCustomer_name()%></div></div>
                <div class="info-row"><div class="label">Phone</div><div class="value"><%= c.getPhone()%></div></div>
                <div class="info-row"><div class="label">Email</div><div class="value"><%= c.getEmail()%></div></div>
                <div class="info-row"><div class="label">Address</div><div class="value"><%= c.getAddress()%></div></div>
                <div class="info-row"><div class="label">Date of Birth</div><div class="value"><%= (c.getDob() != null ? c.getDob().toString() : "-")%></div></div>
                <div class="info-row"><div class="label">Gender</div><div class="value"><%= c.getGender()%></div></div>
                <div class="info-row"><div class="label">Account Status</div><div class="value"><%= c.getAccount_status()%></div></div>

                <div class="actions">
                    <a href="<%= ctx%>/edit_profile" class="btn btn-edit">Edit Profile</a>
                    <a href="<%= ctx%>/change_password" class="btn btn-password">Change Password</a>
                    <a href="<%= ctx%>/orders?tab=placed" class="btn btn-order">Order History</a>
                    <a href="<%= ctx%>/home" class="btn btn-back">Back</a>
                </div>
                <% 
    String msg = (String) session.getAttribute("successMessage");
    if (msg != null) { 
%>
    <p style="color:green; margin-bottom:10px;"><%= msg %></p>
<%
        session.removeAttribute("successMessage"); 
    }
%>
            </div>
        </div>
        </div>

        <c:if test="${not empty sessionScope.updateStatus}">
            <c:set var="upd" value="${sessionScope.updateStatus}"/>
            <c:remove var="updateStatus" scope="session"/>
            <script>
                Swal.fire({
                    icon: '${upd eq "success" ? "success" : "error"}',
                    title: '${upd eq "success" ? "Updated!" : "Update Failed!"}',
                    text: '${upd eq "success" ? "Your profile has been updated successfully." : "Something went wrong. Please try again."}',
                    timer: 2000,
                    showConfirmButton: false
                });
            </script>
        </c:if>
<jsp:include page="/WEB-INF/include/footer.jsp" />

