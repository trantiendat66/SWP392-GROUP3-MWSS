<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="model.Staff" %>
<%@ include file="/WEB-INF/include/header.jsp" %>

<%
    Staff s = (Staff) request.getAttribute("staff");
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

    .page-head {
        display:flex;
        align-items:center;
        justify-content:space-between;
        gap:12px;
        margin-bottom:14px;
    }
    .page-head h2 {
        font-size:26px;
        color:#dc3545;
        margin:0;
        font-weight:700;
    }

    .detail-card {
        background:#fff;
        border-radius:10px;
        padding:20px;
        box-shadow:0 8px 26px rgba(20,20,20,0.04);
        display:block;
        max-width: 900px;
        margin:0 auto;
    }
    .detail-table {
        width:100%;
        border-collapse:collapse;
        margin-top:6px;
    }
    .detail-table td {
        padding:10px 8px;
        vertical-align:top;
        font-size:14px;
        border-bottom: 1px dashed #f1f3f5;
    }
    .detail-table td.label {
        width:160px;
        color:#6c757d;
        font-weight:700;
        padding-right:18px;
        white-space:nowrap;
    }
    .detail-table td.value {
        color:#222;
        word-break:break-word;
    }

    .badge {
        display:inline-block;
        padding:6px 10px;
        border-radius:999px;
        font-size:13px;
        font-weight:700;
        color:#fff;
        min-width:80px;
        text-align:center;
    }
    .badge-active {
        background:#28a745;
    }
    .badge-inactive {
        background:#dc3545;
    }
    .badge-unknown {
        background:#6c757d;
    }

    .button-group {
        display:flex;
        justify-content:center;
        gap:12px;
        margin-top:22px;
        flex-wrap:wrap;
    }
    .btn {
        padding:10px 16px;
        border-radius:8px;
        font-weight:700;
        text-decoration:none;
        cursor:pointer;
        border:none;
        font-size:14px;
        min-width:110px;
        text-align:center;
    }
    .btn-back {
        background:#0d6efd;
        color:#fff;
    }
    .btn-back:hover {
        background:#0b59d4;
    }

    @media (max-width:720px) {
        .page-head {
            flex-direction:column;
            align-items:flex-start;
            gap:8px;
        }
        .detail-table td.label {
            width:120px;
            display:block;
            font-size:13px;
        }
        .button-group {
            justify-content:stretch;
        }
        .btn {
            flex:1;
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
            </ul>
        </aside>

        <main class="main-content">
            <div class="staff-page">
                <div class="page-head">
                    <h2>Staff Details</h2>
                </div>

                <%
                    if (s == null) {
                %>
                <div style="padding:12px;background:#fff3cd;border:1px solid #ffeeba;border-radius:8px;">
                    Staff not found.
                </div>
                <%
                } else {
                    String status = s.getStatus();
                    String badgeClass = "badge-unknown";
                    if (status != null) {
                        if ("active".equalsIgnoreCase(status) || "available".equalsIgnoreCase(status) || "enabled".equalsIgnoreCase(status)) {
                            badgeClass = "badge-active";
                        } else if ("inactive".equalsIgnoreCase(status) || "disabled".equalsIgnoreCase(status) || "blocked".equalsIgnoreCase(status)) {
                            badgeClass = "badge-inactive";
                        }
                    }
                %>

                <div class="detail-card" role="region" aria-label="Staff Information">
                    <table class="detail-table" role="table" aria-label="Staff details table">
                        <tr><td class="label">ID</td><td class="value"><%= s.getAccountId()%></td></tr>
                        <tr><td class="label">Username</td><td class="value"><%= s.getUserName() == null ? "-" : s.getUserName()%></td></tr>
                        <tr><td class="label">Email</td><td class="value"><%= s.getEmail() == null ? "-" : s.getEmail()%></td></tr>
                        <tr><td class="label">Phone</td><td class="value"><%= s.getPhone() == null ? "-" : s.getPhone()%></td></tr>
                        <tr><td class="label">Role</td><td class="value"><%= s.getRole() == null ? "-" : s.getRole()%></td></tr>
                        <tr><td class="label">Position</td><td class="value"><%= s.getPosition() == null ? "-" : s.getPosition()%></td></tr>
                        <tr><td class="label">Address</td><td class="value"><%= s.getAddress() == null ? "-" : s.getAddress()%></td></tr>
                        <tr><td class="label">Status</td>
                            <td class="value">
                                <span class="badge <%= badgeClass%>"><%= (s.getStatus() == null || s.getStatus().isEmpty()) ? "Unknown" : s.getStatus()%></span>
                            </td>
                        </tr>
                    </table>

                    <div class="button-group" aria-label="navigation buttons">
                        <a href="${pageContext.request.contextPath}/admin/staff" class="btn btn-back">Back to list</a>
                    </div>
                </div>

                <% }%>
            </div>
        </main>
    </div>
</div>

<%@ include file="/WEB-INF/include/footer.jsp" %>