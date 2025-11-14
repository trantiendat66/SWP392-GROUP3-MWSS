<%-- 
    Document   : staff_list
    Created on : Oct 21, 2025, 2:22:46 PM
    Author     : Tran Tien Dat - CE190362
--%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Staff" %>
<%@ include file="/WEB-INF/include/header.jsp" %>

<style>
    html, body { margin: 0; padding: 0; background: #f5f7fb; overflow-x: hidden; height: 100%; }
    .page-wrap { padding: 0; background: #f5f7fb; min-height: calc(100vh - 60px); }
    .main-container { display: flex; gap: 0; align-items: stretch; width: 100%; min-height: calc(100vh - 60px); overflow: hidden; }
    .sidebar { width: 280px; min-width: 280px; background: #fff; padding: 22px; box-shadow: 2px 0 8px rgba(0,0,0,0.03); border-radius: 0; flex-shrink: 0; position: relative; display: flex; flex-direction: column; }
    .profile-card { text-align: center; margin-bottom: 18px; }
    .profile-avatar { width: 72px; height: 72px; border-radius: 50%; object-fit: cover; display: inline-block; border: 2px solid #e9ecef; background: #f0f0f0; }
    .profile-role { display: block; background-color: #000; color: #fff; font-size: 18px; font-weight: 700; padding: 8px 16px; border-radius: 6px; margin-top: 10px; width: fit-content; margin-left: auto; margin-right: auto; }
    .nav-menu { list-style: none; padding: 0; margin: 12px 0 0 0; }
    .nav-menu li { margin-bottom: 10px; }
    .nav-link { display: block; padding: 10px 14px; border-radius: 8px; color: #333; text-decoration: none; font-weight: 600; }
    .nav-link.active, .nav-link:hover { background: #dc3545; color: white; }
    .main-content { background: white; margin: 10px; border-radius: 8px; flex: 1 1 auto; padding: 24px; box-shadow: 0 2px 14px rgba(0,0,0,0.04); min-width: 0; overflow-x: auto; }
    .staff-page {
        padding: 0;
        max-width: 100%;
        margin: 0;
    }
    .staff-hero {
        display:flex;
        justify-content:space-between;
        align-items:center;
        gap:12px;
        margin-bottom:18px;
    }
    .staff-hero h2 {
        font-size:24px;
        font-weight:700;
        color:#dc3545;
        margin-bottom:20px;
        font-family:'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    }
    .btn-primary {
        background:#28a745;
        color:#fff;
        padding:8px 14px;
        border-radius:8px;
        text-decoration:none;
        font-weight:700;
        box-shadow:0 4px 12px rgba(40,167,69,0.12);
    }
    .btn-ghost {
        background-color:#dc3545;
        color:white;
        border:1px solid #dc3545;
        padding:8px 16px;
        border-radius:6px;
        text-decoration:none;
        font-weight:600;
        cursor:pointer;
    }
    .flash {
        padding:10px 12px;
        border-radius:8px;
        margin-bottom:12px;
        font-weight:600;
    }
    .flash-success {
        background:#e6ffed;
        color:#155724;
        border:1px solid #c3e6cb;
    }
    .flash-error {
        background:#fff1f0;
        color:#721c24;
        border:1px solid #f5c6cb;
    }

    /* Table */
    .staff-table {
        width:100%;
        border-collapse:collapse;
        background:#fff;
        border-radius:10px;
        overflow:hidden;
        box-shadow:0 6px 20px rgba(20,20,20,0.04);
    }
    .staff-table thead {
        background:#f8f9fa;
    }
    .staff-table th, .staff-table td {
        padding:12px 14px;
        text-align:left;
        font-size:14px;
        border-bottom:1px solid #f1f3f5;
        vertical-align:middle;
    }
    .staff-table th {
        font-weight:700;
        color:#444;
    }
    .staff-table tbody tr:hover {
        background:#fbfbfb;
    }

    /* Actions */
    .action-links {
        display:flex;
        gap:6px;
        justify-content:center;
    }

    .action-links a,
    .action-links button {
        padding:6px 10px;
        border-radius:6px;
        font-size:13px;
        border:none;
        cursor:pointer;
        font-weight:600;
        min-width:50px;
        text-decoration:none;
        color:white;
    }

    .action-view {
        background:#0d6efd;
    }
    .action-view:hover {
        background:#0b59d4;
    }

    .action-edit {
        background:#ffc107;
        color:#333;
    }
    .action-edit:hover {
        background:#e0a800;
    }

    .action-delete {
        background:#dc3545;
    }
    .action-delete:hover {
        background:#c82333;
    }

    @media (max-width:880px) {
        .staff-hero {
            flex-direction:column;
            align-items:stretch;
        }
        .staff-table th:nth-child(2), .staff-table td:nth-child(2) {
            display:none;
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
    <div class="staff-hero">
        <h2>Staff Management</h2>
        <div style="display: flex; flex-wrap: wrap; align-items: center; gap: 12px; margin-bottom: 16px;">
            <form action="${pageContext.request.contextPath}/admin/staff/search" method="get" style="display: flex; flex-grow: 1; gap: 8px; min-width: 250px;">
                <input type="text" name="keyword" placeholder="Search staff by phone" value="${param.keyword}" style="flex-grow: 1; padding: 8px 10px; border-radius: 6px; border: 1px solid #bbb;">
                <button type="submit" style="padding: 8px 14px; border-radius: 6px; background-color: #007bff; color: white; font-weight: 600; border: none; cursor: pointer;"> Search
                </button>
            </form>
            <a href="${pageContext.request.contextPath}/admin/staff/add" style="padding: 8px 14px; border-radius: 6px; font-weight: 600;background-color: #28a745; color: white; text-decoration: none; border: none; cursor: pointer;">Add Staff
            </a>
        </div>
    </div>

    <%-- Flash messages --%>
    <%
        String successMessage = (String) session.getAttribute("successMessage");
        String errorMessage = (String) session.getAttribute("errorMessage");
        if (successMessage != null) {
    %>
    <div class="flash flash-success"><%= successMessage%></div>
    <%
        session.removeAttribute("successMessage");
    } else if (errorMessage != null) {
    %>
    <div class="flash flash-error"><%= errorMessage%></div>
    <%
            session.removeAttribute("errorMessage");
        }
    %>

    <div style="overflow-x:auto;">
        <table class="staff-table" role="table" aria-label="Staff list">
            <thead>
                <tr>
                    <th style="width:80px;">ID</th>
                    <th>Email</th>
                    <th>Phone</th>
                    <th>Username</th>
                    <th style="width:120px;">Role</th>
                    <th style="width:90px;">Status</th>
                    <th style="width:140px; text-align:center;">Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    List<Staff> staffList = (List<Staff>) request.getAttribute("staffList");
                    if (staffList != null && !staffList.isEmpty()) {
                        for (Staff s : staffList) {
                %>
                <tr>
                    <td><%= s.getAccountId()%></td>
                    <td><%= (s.getEmail() == null || s.getEmail().isEmpty()) ? "-" : s.getEmail()%></td>
                    <td><%= s.getPhone() == null ? "-" : s.getPhone()%></td>
                    <td><%= s.getUserName() == null ? "-" : s.getUserName()%></td>
                    <td><%= s.getRole() == null ? "-" : s.getRole()%></td>
                    <td><%= s.getStatus() == null ? "-" : s.getStatus()%></td>
                    <td style="text-align:center;">
                        <div class="action-links">
                            <a class="action-view" href="${pageContext.request.contextPath}/admin/staff/detail?id=<%= s.getAccountId()%>">View</a>
                            <a class="action-edit" href="${pageContext.request.contextPath}/admin/staff/edit?id=<%= s.getAccountId()%>">Edit</a>
                            <form method="post" action="${pageContext.request.contextPath}/admin/staff/delete" style="display:inline;">
                                <input type="hidden" name="id" value="<%= s.getAccountId()%>"/>
                                <button class="action-delete" type="submit" onclick="return confirm('Are you sure you want to delete employee <%= s.getUserName()%> ?');">Delete</button>
                            </form>
                        </div>
                    </td>
                </tr>
                <%
                    }
                } else {
                %>
                <tr><td colspan="6" style="text-align:center; padding:18px;">No staff found.</td></tr>
                <% }%>
            </tbody>
        </table>
    </div>
            </div>
        </main>
    </div>
</div>

<%@ include file="/WEB-INF/include/footer.jsp" %>