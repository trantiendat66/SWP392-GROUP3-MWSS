<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Staff" %>
<%@ include file="/WEB-INF/include/header.jsp" %>

<%
    Staff s = (Staff) request.getAttribute("staff");
    if (s == null) {
        response.sendRedirect(request.getContextPath() + "/admin/staff");
        return;
    }

    String emailError = (String) request.getAttribute("emailError");
    String phoneError = (String) request.getAttribute("phoneError");
    String positionError = (String) request.getAttribute("positionError");
    String addressError = (String) request.getAttribute("addressError");
%>

<style>
    html, body {
        margin: 0;
        padding: 0;
        background: #f5f7fb;
        overflow-x: hidden;
        height: 100%;
    }
    .page-wrap {
        padding: 0;
        background: #f5f7fb;
        min-height: calc(100vh - 60px);
    }
    .main-container {
        display: flex;
        gap: 0;
        align-items: stretch;
        width: 100%;
        min-height: calc(100vh - 60px);
        overflow: hidden;
    }
    .sidebar {
        width: 280px;
        min-width: 280px;
        background: #fff;
        padding: 22px;
        box-shadow: 2px 0 8px rgba(0,0,0,0.03);
        border-radius: 0;
        flex-shrink: 0;
        position: relative;
        display: flex;
        flex-direction: column;
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
        margin: 10px;
        border-radius: 8px;
        flex: 1 1 auto;
        padding: 24px;
        box-shadow: 0 2px 14px rgba(0,0,0,0.04);
        min-width: 0;
        overflow-x: auto;
    }
    .staff-page {
        padding: 0;
        max-width: 100%;
        margin: 0;
        font-family:'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    }

    .page-header h2 {
        font-size: 24px;
        font-weight: 700;
        color: #dc3545;
        margin-bottom: 20px;
    }
    .form-card {
        background: #fff;
        padding: 28px;
        border-radius: 14px;
        border: 1px solid #e2e8f0;
        box-shadow: 0 6px 22px rgba(0,0,0,0.07);
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
    .form-group input, .form-group select, .form-group textarea {
        width: 100%;
        padding: 12px 14px;
        border-radius: 8px;
        border: 1px solid #cbd5e1;
        background: #f8fafc;
        font-size: 15px;
        transition: .25s;
    }
    .form-group input:focus, .form-group select:focus, .form-group textarea:focus {
        border-color: #3b82f6;
        background: #fff;
        outline: none;
        box-shadow: 0 0 0 4px rgba(59,130,246,0.15);
    }
    textarea {
        min-height: 90px;
        resize: vertical;
    }
    .field-error {
        color: #dc2626;
        font-size: 13px;
        margin-top: 4px;
    }

    .btn-actions {
        display: flex;
        justify-content: flex-end;
        gap: 14px;
        margin-top: 12px;
    }
    .btn-primary {
        background:#28a745;
        color:#fff;
        padding:11px 24px;
        border-radius:8px;
        font-weight:600;
        border:none;
        cursor:pointer;
        transition:.25s;
    }
    .btn-primary:hover {
        background:#218838;
        transform: translateY(-1px);
    }
    .btn-ghost {
        background:#dc3545;
        color:#fff;
        padding:11px 24px;
        border-radius:8px;
        text-decoration:none;
        font-weight:600;
        border:none;
        cursor:pointer;
    }
    .btn-ghost:hover {
        background:#c82333;
    }

    @media (max-width:650px) {
        .form-row {
            grid-template-columns: 1fr;
        }
    }
</style>

<div class="page-wrap">
    <div class="main-container">
        <aside class="sidebar">
            <div class="profile-card">
                <img class="profile-avatar" src="${pageContext.request.contextPath}/assert/image/account.jpg" alt="avatar"/>
                <c:choose>
                    <c:when test="${not empty sessionScope.staff}">
                        <div class="profile-role">${sessionScope.staff.role}</div>
                    </c:when>
                    <c:otherwise>
                        <div class="profile-role">Guest</div>
                    </c:otherwise>
                </c:choose>
            </div>
            <ul class="nav-menu">
                <li><a class="nav-link" href="${pageContext.request.contextPath}/product">Product Management</a></li>
                <li><a class="nav-link" href="${pageContext.request.contextPath}/staffcontrol?active=admino">Order Management</a></li>
                <li><a class="nav-link" href="${pageContext.request.contextPath}/staffcontrol?active=admin">Ratings & Feedback</a></li>
                <li><a class="nav-link" href="${pageContext.request.contextPath}/admin/customerlist">Customer Management</a></li>
                <li><a class="nav-link active" href="${pageContext.request.contextPath}/admin/staff">Staff Management</a></li>
                <li><a class="nav-link" href="${pageContext.request.contextPath}/listimportinventory">Import Management</a></li>
                <li style="margin-top:18px;">
                    <form method="post" action="${pageContext.request.contextPath}/logout" style="display:inline;width:100%;">
                        <button type="submit"
                                onclick="return confirm('Are you sure you want to logout?');"
                                style="width:100%;padding:12px;border-radius:8px;border:none;background:#dc3545;color:#fff;cursor:pointer;font-weight:600;">
                            Logout
                        </button>
                    </form>
                </li>
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
                                <input id="userName" name="userName" type="text" value="<%= s.getUserName()%>" readonly />
                            </div>
                            <div class="form-group">
                                <label for="password">Password</label>
                                <input id="password" type="text" value="<%= s.getPassword() != null ? s.getPassword() : ""%>" readonly style="background:#f1f5f9; color:#475569;" />
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="email">Email</label>
                                <input id="email" name="email" type="email" value="<%= s.getEmail()%>" />
                                <% if (emailError != null) {%>
                                <div class="field-error"><%= emailError%></div>
                                <% }%>
                            </div>
                            <div class="form-group">
                                <label for="phone">Phone</label>
                                <input id="phone" name="phone" type="text" value="<%= s.getPhone()%>" />
                                <% if (phoneError != null) {%>
                                <div class="field-error"><%= phoneError%></div>
                                <% }%>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="role">Role</label>
                                <input id="role" name="role" type="text" value="Staff" readonly style="background:#f1f5f9; color:#475569;" />
                                <input type="hidden" name="role" value="Staff" />
                            </div>
                            <div class="form-group">
                                <label for="position">Position</label>
                                <input id="position" name="position" type="text" value="<%= s.getPosition()%>" />
                                <% if (positionError != null) {%>
                                <div class="field-error"><%= positionError%></div>
                                <% }%>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group" style="grid-column:1 / -1;">
                                <label for="address">Address</label>
                                <textarea id="address" name="address"><%= s.getAddress()%></textarea>
                                <% if (addressError != null) {%>
                                <div class="field-error"><%= addressError%></div>
                                <% }%>
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
            </div>
        </main>
    </div>
</div>

<%@ include file="/WEB-INF/include/footer.jsp" %>