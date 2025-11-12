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
    .staff-page {
        padding: 22px;
        max-width:1200px;
        margin: 0 auto;
    }
    .staff-hero {
        display:flex;
        justify-content:space-between;
        align-items:center;
        gap:12px;
        margin-bottom:18px;
    }
    .staff-hero h2 {
        font-size:30px;
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

<div class="staff-page">
    <div class="staff-hero">
        <h2>Staff Management</h2>
        <div style="display: flex; flex-wrap: wrap; align-items: center; gap: 12px; margin-bottom: 16px;">
            <form action="${pageContext.request.contextPath}/admin/staff/search" 
                  method="get" 
                  style="display: flex; flex-grow: 1; gap: 8px; min-width: 250px;">
                <input type="text" name="keyword" placeholder="Search staff by phone" 
                       value="${param.keyword}" 
                       style="flex-grow: 1; padding: 8px 10px; border-radius: 6px; border: 1px solid #bbb;">
                <button type="submit" 
                        style="padding: 8px 14px; border-radius: 6px; font-weight: 600; background-color: #007bff; color: white; border: none;">
                    Search
                </button>
            </form>

            <a href="${pageContext.request.contextPath}/admin/staff/add" 
               class="btn btn-success" 
               style="padding: 8px 14px; border-radius: 6px; font-weight: 600;"> Add Staff
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

<%@ include file="/WEB-INF/include/footer.jsp" %>