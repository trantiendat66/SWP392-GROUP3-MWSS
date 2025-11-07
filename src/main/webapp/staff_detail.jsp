<%-- 
    Document   : staff_detail
    Created on : Oct 21, 2025, 2:23:01 PM
    Author     : Tran Tien Dat - CE190362
--%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="model.Staff" %>
<%@ include file="/WEB-INF/include/header.jsp" %>

<style>
    .staff-detail {
        padding: 22px;
        max-width: 920px;
        margin: 0 auto;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
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
    .page-sub {
        color:#6c757d;
        font-size:14px;
        margin-top:6px;
    }

    .detail-card {
        background:#fff;
        border-radius:10px;
        padding:20px;
        box-shadow:0 8px 26px rgba(20,20,20,0.04);
        display:block;
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

    /* status badge */
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

    /* buttons */
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
    .btn-cancel {
        background:#6c757d;
        color:#fff;
    }
    .btn-cancel:hover {
        background:#5c636a;
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

<div class="staff-detail">
    <div class="page-head">
        <div>
            <h2>Staff Details</h2>
        </div>
        <div style="display:flex; gap:8px; align-items:center;">
        </div>
    </div>

    <%
        Staff s = (Staff) request.getAttribute("staff");
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
            } else {
                badgeClass = "badge-unknown";
            }
        }
    %>

    <div class="detail-card" role="region" aria-label="Staff Information">
        <table class="detail-table" role="table" aria-label="Staff details table">
            <tr>
                <td class="label">ID</td>
                <td class="value"><%= s.getAccountId()%></td>
            </tr>
            <tr>
                <td class="label">Username</td>
                <td class="value"><%= s.getUserName() == null ? "-" : s.getUserName()%></td>
            </tr>
            <tr>
                <td class="label">Email</td>
                <td class="value"><%= s.getEmail() == null ? "-" : s.getEmail()%></td>
            </tr>
            <tr>
                <td class="label">Phone</td>
                <td class="value"><%= s.getPhone() == null ? "-" : s.getPhone()%></td>
            </tr>
            <tr>
                <td class="label">Role</td>
                <td class="value"><%= s.getRole() == null ? "-" : s.getRole()%></td>
            </tr>
            <tr>
                <td class="label">Position</td>
                <td class="value"><%= s.getPosition() == null ? "-" : s.getPosition()%></td>
            </tr>
            <tr>
                <td class="label">Address</td>
                <td class="value"><%= s.getAddress() == null ? "-" : s.getAddress()%></td>
            </tr>
            <tr>
                <td class="label">Status</td>
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

<%@ include file="/WEB-INF/include/footer.jsp" %>