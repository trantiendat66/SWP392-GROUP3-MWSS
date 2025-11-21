<%-- 
    Document   : import_list
    Created on : Nov 13, 2025, 3:06:04 AM
    Author     : hau
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/include/header.jsp" %>
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
                <li><a class="nav-link" href="${pageContext.request.contextPath}/admin/staff">Staff Management</a></li>
                <li><a class="nav-link active" href="${pageContext.request.contextPath}/listimportinventory">Import Management</a></li>
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
            <div class="mb-3 d-flex justify-content-between align-items-center">
                <h3>Import Inventory Management</h3>
                <a href="addimportinventory" class="btn btn-primary">Add New Import</a>
            </div>
            <c:if test="${not empty sessionScope.success}">
                <div class="alert alert-success text-center">
                    ${sessionScope.success}
                </div>
                <c:remove var="success" scope="session"/>
            </c:if>
            <c:if test="${not empty sessionScope.error}">
                <div class="alert alert-danger text-center">
                    ${sessionScope.error}
                </div>
                <c:remove var="error" scope="session"/>
            </c:if>
            <div style="max-height: 500px; overflow-y: auto;">
                <table class="table table-striped">
                    <thead class="table-dark" style="position: sticky; top: 0; z-index: 1;">
                        <tr>
                            <th>ImportID</th>
                            <th>Total import price</th>
                            <th>Total quantity</th>
                            <th>Supplier</th>
                            <th>Import Date</th>
                            <th>Created At</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="i" items="${importList}">
                            <tr>
                                <td>${i.importInvetoryId}</td>
                                <td>${i.totalImportPrice}</td>
                                <td>${i.totalImportQuantity}</td>
                                <td>${i.supplier}</td>
                                <td>${i.importDate}</td>
                                <td>${i.importAt}</td>
                                <td>
                                    <a href="importinventorydetail?id=${i.importInvetoryId}">
                                        <c:choose>
                                            <c:when test="${i.importStatus}">
                                                <span class="badge bg-success">Imported successfully</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-danger">Not import</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </a>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${!i.importStatus}">
                                            <a href="editimportinventory?id=${i.importInvetoryId}" class="btn btn-sm btn-outline-primary me-2">Edit</a>
                                            <form action="deleteimportinventory" method="post" style="display:inline" onsubmit="return confirm('Delete this import permanently?');">
                                                <input type="hidden" name="id" value="${i.importInvetoryId}">
                                                <button type="submit" class="btn btn-sm btn-outline-danger">Delete</button>
                                            </form>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted">Locked</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </main>
    </div>
</div>
<jsp:include page="/WEB-INF/include/footer.jsp" />
