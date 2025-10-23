<%-- 
    Document   : staff_list
    Created on : Oct 21, 2025, 2:22:46 PM
    Author     : Tran Tien Dat - CE190362
--%>

<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Staff" %>
<%@ include file="/WEB-INF/include/header.jsp" %>

<style>
    /* Staff list styles (self-contained, nhẹ) */
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
        font-size: 30px;
        font-weight: 700;
        color: #dc3545;       
        margin-bottom: 20px;   
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
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

    /* Avatar */
    .staff-avatar {
        width:66px;
        height:66px;
        border-radius:6px;
        object-fit:cover;
        border:1px solid #e6e9ee;
    }

    /* Actions */
    .action-links {
        display:flex;
        gap:8px;
        justify-content:center;
        align-items:center;
    }

    .btn-ghost {
        background-color: #dc3545;
        color: white;
        border: 1px solid #dc3545;
        padding: 8px 16px;
        border-radius: 6px;
        text-decoration: none;
        font-weight: 600;
        cursor: pointer;
    }
    .action-links a, .action-links button {
        padding: 6px 12px;
        border-radius: 6px;
        font-weight: 600;
        text-decoration: none;
        cursor: pointer;
        border: none;
        min-width: 60px;
        text-align: center;
        transition: none;
    }


    .action-view {
        background-color: #0d6efd;
        color: white;
    }
    .action-edit {
        background-color: #e0a800;
        color: white;
    }
    .action-delete {
        background-color: #dc3545;
        color: white;
    }


    /* Responsive */
    @media (max-width: 880px) {
        .staff-hero {
            flex-direction:column;
            align-items:stretch;
            gap:8px;
        }
        .staff-table th:nth-child(3), .staff-table td:nth-child(3) {
            display:none;
        } /* hide email on small */
    }
</style>

<div class="staff-page">
    <div class="staff-hero">
        <h2>Staff Management</h2>
        <div>
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn-ghost">Back to dashboard</a>
            <a href="${pageContext.request.contextPath}/admin/staff/add" class="btn-primary">Add staff</a>
        </div>
    </div>

    <%-- flash simple --%>
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
                    <th style="width:72px;"></th>
                    <th style="width:80px">ID</th>
                    <th>Email</th>
                    <th>Username</th>
                    <th style="width:120px">Role</th>
                    <th style="width:90px">Status</th>
                    <th style="width:140px; text-align:center">Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    List<Staff> staffList = (List<Staff>) request.getAttribute("staffList");
                    if (staffList != null && !staffList.isEmpty()) {
                        for (Staff s : staffList) {
                %>
                <tr>
                    <td>
                        <img class="staff-avatar" src="${pageContext.request.contextPath}/assert/image/<%= (s.getAccountId())%>.jpg"
                             alt="<%= s.getUserName()%>" onerror="this.src='${pageContext.request.contextPath}/assert/image/staff.png'"/>
                    </td>
                    <td><%= s.getAccountId()%></td>
                    <td><%= s.getEmail() == null || s.getEmail().isEmpty() ? "-" : s.getEmail()%></td>
                    <td><%= s.getUserName() == null ? "-" : s.getUserName()%></td>
                    <td><%= s.getRole() == null ? "-" : s.getRole()%></td>
                    <td><%= s.getStatus() == null ? "-" : s.getStatus()%></td>
                    <td style="text-align:center">
                        <div class="action-links" role="group" aria-label="actions for staff <%= s.getAccountId()%>">
                            <a class="action-view" href="${pageContext.request.contextPath}/admin/staff/detail?id=<%= s.getAccountId()%>">View</a>
                            <form method="post" action="${pageContext.request.contextPath}/admin/staff/delete" style="display:inline;">
                                <input type="hidden" name="id" value="<%= s.getAccountId()%>"/>
                                <button class="action-delete" type="submit" onclick="return confirm('Delete staff #<%= s.getAccountId()%> ?');">Delete</button>
                            </form>
                        </div>
                    </td>
                </tr>
                <%      }
                } else { %>
                <tr><td colspan="7" style="text-align:center;padding:18px;">No staff found.</td></tr>
                <% }%>
            </tbody>
        </table>
    </div>
</div>

<%@ include file="/WEB-INF/include/footer.jsp" %>
