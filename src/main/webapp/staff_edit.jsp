<%-- 
    Document   : staff_edit
    Created on : Nov 7, 2025
    Author     : Tran Tien Dat - CE190362
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Staff" %>
<%@ include file="/WEB-INF/include/header.jsp" %>

<%
    Staff s = (Staff) request.getAttribute("staff");
    if (s == null) {
        response.sendRedirect(request.getContextPath() + "/admin/staff");
        return;
    }
%>

<style>
    .page-wrap {
        padding: 0;
        min-height: calc(100vh - 60px);
    }

    .main-container {
        display: flex;
        gap: 0;
        min-height: calc(100vh - 60px);
        align-items: stretch;
    }

    .sidebar {
        width: 280px;
        background-color: white;
        display: flex;
        flex-direction: column;
        border-radius: 0;
        box-shadow: 2px 0 5px rgba(0,0,0,0.1);
    }

    .profile-card {
        padding: 24px;
        text-align: center;
        border-bottom: 1px solid #e0e0e0;
    }

    .profile-avatar {
        width: 80px;
        height: 80px;
        border-radius: 50%;
        margin-bottom: 12px;
    }

    .profile-role {
        font-size: 14px;
        color: #666;
        text-transform: uppercase;
    }

    .nav-menu {
        list-style: none;
        padding: 0;
        margin: 0;
        flex: 1;
    }

    .nav-link {
        display: block;
        padding: 16px 24px;
        color: #333;
        text-decoration: none;
        transition: background-color 0.2s;
    }

    .nav-link:hover {
        background-color: #f5f5f5;
    }

    .nav-link.active {
        background-color: #007bff;
        color: white;
    }

    .main-content {
        flex: 1;
        margin: 10px;
        background-color: #f8f9fa;
        border-radius: 8px;
        padding: 24px;
        overflow-y: auto;
    }

    .staff-page {
        max-width: 100%;
        margin: 0;
        padding: 0;
        font-family: "Inter", "Segoe UI", Tahoma, sans-serif;
    }
    .page-header h2 {
        font-size: 28px;
        font-weight: 700;
        margin-bottom: 22px;
        color: #1e293b;
    }

    .form-card {
        background: #ffffff;
        padding: 28px;
        border-radius: 14px;
        border: 1px solid #e2e8f0;
        box-shadow: 0px 6px 22px rgba(0, 0, 0, 0.07);
        animation: fadeIn .45s ease;
    }
    @keyframes fadeIn {
        from {
            opacity:0;
            transform:translateY(10px);
        }
        to {
            opacity:1;
            transform:translateY(0);
        }
    }
    .form-row {
        display: grid;
        grid-template-columns: repeat(2, 1fr);
        gap: 22px;
        margin-bottom: 18px;
    }
    .form-group label {
        font-weight: 600;
        margin-bottom: 8px;
        display: block;
        color: #1e293b;
    }
    .form-group input,
    .form-group select,
    .form-group textarea {
        width: 100%;
        padding: 12px 14px;
        border-radius: 8px;
        border: 1px solid #cbd5e1;
        background: #f8fafc;
        font-size: 15px;
        transition: .25s;
    }
    .form-group input:focus,
    .form-group textarea:focus,
    .form-group select:focus {
        border-color: #3b82f6;
        background: #fff;
        outline: none;
        box-shadow: 0 0 0 4px rgba(59,130,246,0.15);
    }
    textarea {
        min-height: 90px;
        resize: vertical;
    }
    .btn-actions {
        display: flex;
        justify-content: flex-end;
        gap: 14px;
        margin-top: 12px;
    }
    .btn-primary {
        background: #3b82f6;
        border: none;
        padding: 11px 24px;
        font-size: 15px;
        border-radius: 8px;
        color: #fff;
        cursor: pointer;
        font-weight: 600;
        transition: .25s;
    }
    .btn-primary:hover {
        background: #2563eb;
        transform: translateY(-1px);
    }
    .btn-ghost {
        padding: 11px 24px;
        border: 1px solid #cbd5e1;
        border-radius: 8px;
        background: #f8fafc;
        color: #334155;
        text-decoration: none;
        font-weight: 500;
        transition: .25s;
    }
    .btn-ghost:hover {
        background: #e2e8f0;
    }
    @media (max-width: 650px) {
        .form-row {
            grid-template-columns: 1fr;
        }
    }
</style>

<div class="page-wrap">
    <div class="main-container">
        <aside class="sidebar">
            <div class="profile-card">
                <img class="profile-avatar" src="${pageContext.request.contextPath}/assert/avatar/account.jpg" alt="Profile">
                <div class="profile-role">${sessionScope.staff.role}</div>
            </div>
            <ul class="nav-menu">
                <li><a class="nav-link" href="${pageContext.request.contextPath}/product">Product Management</a></li>
                <li><a class="nav-link" href="${pageContext.request.contextPath}/staffcontrol?active=admino">Order Management</a></li>
                <li><a class="nav-link" href="${pageContext.request.contextPath}/staffcontrol?active=admin">Ratings & Feedback</a></li>
                <li><a class="nav-link" href="${pageContext.request.contextPath}/admin/customerlist">Customer Management</a></li>
                <li><a class="nav-link active" href="${pageContext.request.contextPath}/admin/staff">Staff Management</a></li>
                <li><a class="nav-link" href="${pageContext.request.contextPath}/listimportinventory">Import Management</a></li>
            </ul>
        </aside>
        <main class="main-content">
            <div class="staff-page">
    <div class="page-header">
        <h2>Edit Staff</h2>
    </div>

    <div class="form-card" role="form">
        <form method="post" action="${pageContext.request.contextPath}/admin/staff/edit">

            <input type="hidden" name="accountId" value="<%= s.getAccountId()%>" />

            <div class="form-row">
                <div class="form-group">
                    <label for="userName">Username</label>
                    <input id="userName" name="userName" type="text"
                           value="<%= s.getUserName()%>"
                           readonly />
                </div>
                <div class="form-group">
                    <label for="password">Password</label>
                    <input id="password" type="text"
                           value="<%= s.getPassword() != null ? s.getPassword() : ""%>"
                           readonly
                           style="background:#f1f5f9; color:#475569;" />
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="email">Email</label>
                    <input id="email" name="email" type="email" value="<%= s.getEmail()%>" />
                </div>
                <div class="form-group">
                    <label for="phone">Phone</label>
                    <input id="phone" name="phone" type="text" value="<%= s.getPhone()%>" />
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="role">Role</label>
                    <select id="role" name="role">
                        <option value="Admin" <%= "Admin".equals(s.getRole()) ? "selected" : ""%>>Admin</option>
                        <option value="Staff" <%= "Staff".equals(s.getRole()) ? "selected" : ""%>>Staff</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="position">Position</label>
                    <input id="position" name="position" type="text" value="<%= s.getPosition()%>" />
                </div>
            </div>

            <div class="form-row">
                <div class="form-group" style="grid-column:1 / -1;">
                    <label for="address">Address</label>
                    <textarea id="address" name="address"><%= s.getAddress()%></textarea>
                </div>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label for="status">Status</label>
                    <select id="status" name="status">
                        <option value="Active" <%= "Active".equals(s.getStatus()) ? "selected" : ""%>>Active</option>
                        <option value="Inactive" <%= "Inactive".equals(s.getStatus()) ? "selected" : ""%>>Inactive</option>
                    </select>
                </div>
            </div>

            <div class="btn-actions">
                <a class="btn-ghost" href="${pageContext.request.contextPath}/admin/staff">Cancel</a>
                <button type="submit" class="btn-primary">Update</button>
            </div>

        </form>
            </div>
        </main>
    </div>
</div>

<%@ include file="/WEB-INF/include/footer.jsp" %>
