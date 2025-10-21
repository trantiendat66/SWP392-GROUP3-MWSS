<%-- 
    Document   : staff_detail
    Created on : Oct 21, 2025, 2:23:01 PM
    Author     : Tran Tien Dat - CE190362
--%>

<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="model.Staff" %>
<%@ include file="/WEB-INF/include/header.jsp" %>

<style>
    .staff-detail {
        padding:22px;
        max-width:900px;
        margin:0 auto;
    }
    .detail-card {
        background:#fff;
        border-radius:10px;
        padding:20px;
        box-shadow:0 8px 26px rgba(20,20,20,0.04);
        display:flex;
        gap:30px;
        align-items:flex-start;
        flex-wrap: wrap; 
    }
    .detail-card > div:first-child {
        flex: 0 0 250px;
    }
    .detail-card > div:last-child {
        flex: 1;                     
        display: flex;
        flex-direction: column;
        justify-content: flex-start;
        margin-left: 80px;          
    }
    .controls {
        margin-top: 16px;
        display: flex;
        justify-content: flex-end;   
        gap: 16px;
    }

    .controls a.btn-primary,
    .controls a.btn-ghost {
        padding: 12px 12px;         
        font-size: 16px;  
    }

    .detail-avatar {
        width:100%;
        max-width:250px;
        height:auto;
        aspect-ratio:1/1;
        object-fit:cover;
        border-radius:10px;
        border:1px solid #e8eaee;
    }
    .detail-table td.label {
        width:150px;
        font-weight:700;
        color:#6c757d;
        padding-right:12px;
    }
    .detail-table td.value {
        color:#212529;
    }

    .label {
        color:#6c757d;
        font-weight:700;
        width:160px;
    }
    .value {
        color:#212529;
    }
    .controls {
        margin-top:14px;
        display:flex;
        gap:10px;
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
    .btn-primary {
        background:#0d6efd;
        color:#fff;
        padding:8px 12px;
        border-radius:8px;
        text-decoration:none;
        font-weight:700;
    }
    
    @media (max-width:720px) {
        .detail-card {
            flex-direction:column;
            align-items:stretch;
        }
        .label {
            width:120px;
            display:block;
        }
    }
</style>

<div class="staff-detail">
    <h2>Staff Details</h2>

    <%
        Staff s = (Staff) request.getAttribute("staff");
        if (s == null) {
    %>
    <div style="padding:12px;background:#fff3cd;border:1px solid #ffeeba;border-radius:8px;">Không tìm thấy staff.</div>
    <%
    } else {
    %>

    <div class="detail-card" role="region" aria-label="Thông tin staff">
        <div>
            <img class="detail-avatar" src="${pageContext.request.contextPath}/assert/image/<%= s.getAccountId()%>.jpg"
                 alt="<%= s.getUserName()%>" onerror="this.src='${pageContext.request.contextPath}/assert/image/staff.png'"/>
        </div>
        <div style="flex:1;">
            <table class="detail-table">
                <tr><td class="label">ID</td><td class="value"><%= s.getAccountId()%></td></tr>
                <tr><td class="label">Username</td><td class="value"><%= s.getUserName() == null ? "-" : s.getUserName()%></td></tr>
                <tr><td class="label">Email</td><td class="value"><%= s.getEmail() == null ? "-" : s.getEmail()%></td></tr>
                <tr><td class="label">Phone</td><td class="value"><%= s.getPhone() == null ? "-" : s.getPhone()%></td></tr>
                <tr><td class="label">Role</td><td class="value"><%= s.getRole() == null ? "-" : s.getRole()%></td></tr>
                <tr><td class="label">Position</td><td class="value"><%= s.getPosition() == null ? "-" : s.getPosition()%></td></tr>
                <tr><td class="label">Address</td><td class="value"><%= s.getAddress() == null ? "-" : s.getAddress()%></td></tr>
                <tr><td class="label">Status</td><td class="value"><%= s.getStatus() == null ? "-" : s.getStatus()%></td></tr>
            </table>

            <div class="controls">
                <a href="${pageContext.request.contextPath}/admin/staff/edit?id=<%= s.getAccountId()%>" class="btn-primary">Edit</a>
                <a href="${pageContext.request.contextPath}/admin/staff" class="btn-ghost">Back to list</a>
            </div>
        </div>
    </div>

    <% }%>
</div>

<%@ include file="/WEB-INF/include/footer.jsp" %>
