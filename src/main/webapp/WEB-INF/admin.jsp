<%-- /WEB-INF/admin.jsp
     Admin Dashboard (v2: formatted price + VNĐ + larger titles)
--%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Product" %>
<%@ page import="model.TopProduct" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/include/header.jsp" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<style>
    html, body {
        margin: 0;
        padding: 0;
        background: #f5f7fb;
        overflow-x: hidden;
        height: 100%;
    }
    /* Layout */
    .page-wrap {
        padding: 0; /* loại bỏ padding để sidebar sát lề */
        background: #f5f7fb;
        min-height: calc(100vh - 60px); /* trừ đi chiều cao header */
    }
    .main-container {
        display: flex;
        gap: 0; /* loại bỏ gap để sidebar sát lề */
        align-items: stretch;
        width: 100%;
        min-height: calc(100vh - 60px); /* trừ chiều cao header */
        overflow: hidden;
    }
    /* Sidebar */
    .sidebar {
        width: 280px;
        min-width: 280px;
        background: #fff;
        padding: 22px;
        box-shadow: 2px 0 8px rgba(0,0,0,0.03);
        border-radius: 0; /* loại bỏ border-radius để sát lề */
        flex-shrink: 0;
        position: relative;
        display: flex;
        flex-direction: column;
    }
    .profile-card {
        text-align: center;    /* căn giữa toàn bộ bên trong */
        margin-bottom: 18px;
    }
    .profile-avatar {
        width: 72px;            /* to hơn */
        height: 72px;
        border-radius: 50%;
        object-fit: cover;
        display: inline-block;
        border: 2px solid #e9ecef;
        background: #f0f0f0;
    }
    .profile-name {
        font-size: 16px;
        font-weight: 700;
        margin-top: 8px;
    }
    .profile-role {
        display: block;         /* bắt buộc xuống dòng, nằm dưới avatar */
        background-color: #000; /* khung màu đen */
        color: #fff;            /* chữ trắng */
        font-size: 18px;        /* chữ to */
        font-weight: 700;
        padding: 8px 16px;      /* giãn đều bên trong */
        border-radius: 6px;     /* bo nhẹ góc */
        margin-top: 10px;       /* cách avatar một chút */
        width: fit-content;     /* khung vừa chữ */
        margin-left: auto;      /* căn giữa theo chiều ngang */
        margin-right: auto;
    }

    /* Nav */
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
        padding: 10px 14px; /* to hơn */
        border-radius: 8px;
        color: #333;
        text-decoration: none;
        font-weight: 600;
    }
    .nav-link.active, .nav-link:hover {
        background: #dc3545;
        color: white;
    }
    /* Main content */
    .main-content {
        background: white;
        margin: 10px;
        border-radius: 8px;
        flex: 1 1 auto;
        padding: 24px;
        border-radius: 10px;
        box-shadow: 0 2px 14px rgba(0,0,0,0.04);
        min-width: 0; /* allow shrink */
        overflow-x: auto;
    }
    /* Top controls row */
    .controls {
        display: flex;
        justify-content: space-between;
        align-items: center;
        gap: 12px;
        margin-bottom: 14px;
    }
    .page-title {
        font-size: 18px;
        font-weight: 700;
    }
    .add-product-btn {
        padding: 10px 14px;
        border-radius: 8px;
        border: none;
        cursor: pointer;
        font-weight: 700;
        background: #28a745;
        color: #fff;
        box-shadow: 0 2px 6px rgba(0,0,0,0.06);
    }
    .add-product-btn:hover {
        transform: translateY(-1px);
    }

    /* stats row */
    .stats-grid {
        display:grid;
        grid-template-columns:1fr 1fr;
        gap:14px;
        margin-bottom:18px;
    }
    .stat-card {
        padding:16px;
        border-radius:8px;
        background:#fff;
        box-shadow:0 1px 6px rgba(0,0,0,0.03);
    }
    /* Table & product images */
    .table-container {
        overflow-x: auto;
    }
    .table {
        width: 100%;
        border-collapse: collapse;
        min-width: 800px; /* để table đc rộng hơn */
    }
    .table th, .table td {
        padding: 14px 14px; /* tăng padding để cảm giác bự hơn */
        border-bottom: 1px solid #eee;
        font-size: 15px; /* to hơn */
        vertical-align: middle;
    }
    .table th {
        background: #fafafa;
        text-align: left;
        font-weight: 700;
    }
    .table td.product-price {
        white-space: nowrap;
        min-width: 100px;
    }

    /* Product image: larger thumbnail */
    .product-image {
        width: 72px;
        height: 72px;
        object-fit: cover;
        border-radius: 8px;
        border: 1px solid #ddd;
        display: block;
    }
    /* Action buttons (nằm ngang, rõ ràng hơn) */
    .action-btn {
        min-width: 36px;
        height: 36px;
        border: none;
        border-radius: 6px;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        cursor: pointer;
        font-size: 15px;
        margin: 0 6px;
        vertical-align: middle;
    }
    .edit-btn {
        background: #007bff;
        color: #fff;
    }
    .delete-btn {
        background: #dc3545;
        color: #fff;
    }
    .view-btn {
        background: #17a2b8;
        color: #fff;
    }
    .table td.actions-cell {
        white-space: nowrap;
        text-align: center;
        width: 200px;
    }

    /* Responsive: stack sidebar above content on small screens */
    @media (max-width: 900px) {
        .main-container {
            flex-direction: column;
        }
        .sidebar {
            width: 100%;
            max-width: none;
            display: block;
        }
        .main-content {
            margin-top: 12px;
        }
        .table {
            min-width: 100%;
        }
    }

    /* Table styles */
    table{
        width:100%;
        border-collapse: inherit;
        font-size:16px;
        min-width:980px;
        box-shadow:0 2px 6px rgba(0,0,0,0.1);
    }
    thead th{
        text-align:left;
        padding:10px;
        background:#fff;
        border-bottom:2px solid #222;
        font-weight:700;
        font-size:13px;
    }
    tbody td{
        padding:12px 10px;
        border-bottom:1px solid rgba(0,0,0,0.08);
        vertical-align:middle;
    }
    tbody tr:hover td{
        background: rgba(139,92,246,0.04)
    }
    .order-id,
    .feedbackId{
        font-weight:700;
        color:#333
    }
    .date-pill{
        display:inline-block;
        padding:6px 8px;
        border-radius:20px;
        background:#f0f0f0;
        font-size:13px;
        color:#333;
    }
    .status-order{
        padding:6px 10px;
        border-radius:16px;
        font-weight:600;
        font-size:13px;
        display:inline-block;
        min-width:84px;
        text-align:center;
        border-radius:20px;
        background:#f0f0f0;
    }
    .status-order.pending{
        color:black;
        font-weight:700;
    }
    .status-order.shipping{
        color:#00cc33;
        font-weight:700;
    }
    .status-order.delivered{
        color:red;
        font-weight:700;
    }

    .right-actions{
        min-width: 80px;
        display:flex;
        gap:10px;
        justify-content:center
    }
    .icon {
        width:34px;
        height:34px;
        border-radius:50%;
        display:inline-flex;
        align-items:center;
        justify-content:center;
        background:#111;
        color:#fff;
        font-size:14px;
        cursor:pointer;
        border:1px solid rgba(0,0,0,0.08);
    }
    .icon.view,
    .icon.hide,
    .icon.reply{
        background:#fff;
        color:#111;
        border:1px solid #111
    }
    .container-flex {
        display: flex;
        min-height: 100%;
    }
    #popupModal {
        max-width: 880px;
        width: 100%;
        border-radius: 8px;
        box-shadow: 0 2px 6px rgba(0,0,0,0.1);
        overflow: hidden;
    }
    .left {
        flex: 5;
        padding:50px;
        background:linear-gradient(180deg,#ffffff,#f7f9fb);
    }
    .right {
        flex: 1;
        margin-left: 20px;
    }

    .listOrders,
    .listFeedbacks{
        max-height: 400px;
        overflow-y: auto;
        overflow-x: auto;
        border: 1px solid #ddd;
    }

    .listOrders thead th,
    .listFeedbacks thead th{
        position: sticky;
        top: 0;
        background-color: #f8f9fa;
        z-index: 2;
        text-align: left;
        padding: 8px;
    }
    .listOrders td,
    .listFeedbacks td{
        padding: 8px;
        border-top: 1px solid #eee;
        border-left: 1px solid #eee;
    }
    .comment {
        display: block;
        max-width: 400px;
        overflow: hidden;       /* ẩn phần dư */
    }
    @media (max-width:980px){
        table{
            min-width:680px
        }
    }
    @media (max-width:760px){
        table{
            min-width:0;
            font-size:13px
        }
    }
</style>
<!-- MAIN PAGE CONTENT -->
<div class="page-wrap">
    <div class="main-container" role="main">
        <!-- SIDEBAR -->
        <aside class="sidebar" aria-label="Admin sidebar">
            <div class="profile-card">
                <img class="profile-avatar"
                     src="${pageContext.request.contextPath}/assert/image/account.jpg"
                     alt="avatar"
                     onerror="this.src='${pageContext.request.contextPath}/assert/image/watch1.jpg'"/>
                <c:choose>
                    <c:when test="${not empty sessionScope.staff}">
                        <div class="profile-role">${sessionScope.staff.role}</div>
                    </c:when>
                    <c:otherwise>
                        <div class="profile-name">Guest</div>
                    </c:otherwise>
                </c:choose>
            </div>
            <ul class="nav-menu">
                <li>
                    <a class="nav-link ${requestScope.activeTab == null || requestScope.activeTab == 'product' ? 'active' : ''}" 
                       href="${pageContext.request.contextPath}/product">Product Management</a>
                </li>
                <li>
                    <a class="nav-link ${requestScope.activeTab == 'order' ? 'active' : ''}" 
                       href="${pageContext.request.contextPath}/staffcontrol?active=admino">Order Management</a>
                </li>
                <li>
                    <a class="nav-link ${requestScope.activeTab == 'feedback' ? 'active' : ''}" 
                       href="${pageContext.request.contextPath}/staffcontrol?active=admin">Ratings & Feedback</a>
                </li>
                <li>
                    <a class="nav-link ${requestScope.activeTab == 'customer' ? 'active' : ''}" 
                       href="${pageContext.request.contextPath}/admin/customerlist">Customer Management</a>
                </li>
                <li>
                    <a class="nav-link ${requestScope.activeTab == 'staff' ? 'active' : ''}" 
                       href="${pageContext.request.contextPath}/admin/staff">Staff Management</a>
                </li>
                <li>
                    <a class="nav-link ${requestScope.activeTab == 'staff' ? 'active' : ''}" 
                       href="${pageContext.request.contextPath}/listimportinventory">Import Management</a>
                </li>
            </ul>

            <button id="logoutBtn" style="margin-top:18px;padding:12px;border-radius:8px;border:none;background:#dc3545;color:#fff;cursor:pointer;width:100%;">Logout</button>
        </aside>

        <!-- CONTENT -->
        <main class="main-content" aria-label="Admin main content">
            <c:choose>

                <c:when test="${requestScope.activeTab == 'customer'}">
                    <div class="controls">
                        <div class="page-title">Customer Management</div>
                        <form action="${pageContext.request.contextPath}/admin/customerlist" method="get" style="display:flex; gap:10px; align-items:center;">
                            <input type="text" name="keyword" placeholder="Search customer by email" 
                                   value="${param.keyword}"
                                   style="padding:6px 10px; border-radius:6px; border:1px solid #bbb;">
                            <button type="submit" class="btn btn-primary">Search</button>
                            <a href="${pageContext.request.contextPath}/admin/customerlist" class="btn btn-secondary" style="text-decoration:none;">Reset
                            </a>
                        </form>
                    </div>

                    <div class="table-container">
                        <table class="table" aria-describedby="customer-list">
                            <thead>
                                <tr>
                                    <th style="min-width:60px;">#</th>
                                    <th>Email</th>
                                    <th>Name</th>   <%-- hoặc Customer Name --%>
                                    <th style="min-width: 210px; text-align: center;">Action</th>
                                </tr>
                            </thead>

                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty listCustomers}">
                                        <c:forEach var="c" items="${listCustomers}" varStatus="st">
                                            <tr>
                                                <td>${st.index + 1}</td>
                                                <td>${c.email}</td>
                                                <td>${c.customer_name}</td>
                                                <td style="text-align:center;">

                                                    <%--VIEW--%>
                                                    <a href="customerdetail?id=${c.customer_id}" class="btn btn-sm btn-info" title="View Details" style="margin: 2px 1px;">
                                                        <i class="fa fa-eye"></i> View
                                                    </a>

                                                    <%-- EDIT--%>                                                   
                                                    <a href="${pageContext.request.contextPath}/edit_customer?id=${c.customer_id}"
                                                       class="btn btn-sm btn-warning" title="Edit Customer" style="margin: 2px 1px;">
                                                        <i class="fa fa-edit"></i> Edit
                                                    </a>
<!--                                                    <%--DELETE--%>
                                                    <a href="deletecustomer?id=${c.customer_id}" 
                                                       onclick="return confirm('Xóa? ${c.customer_name} (${c.email})?')"
                                                       class="btn btn-sm btn-danger" title="Delete Customer" style="margin: 2px 1px;">
                                                        <i class="fa fa-trash"></i> Delete

                                                    </a>-->
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="4" style="text-align:center;padding:18px;">
                                                No customer found in the database.
                                            </td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>                
                </c:when>

                <c:when test="${requestScope.activeTab == 'customerDetail'}">
                    <div class="controls">
                        <div class="page-title">Customer Detail <i class="fa fa-eye" style="color:#007bff;"></i></div>
                    </div>

                    <c:set var="c" value="${requestScope.customerDetail}" />

                    <c:if test="${c != null}">
                        <div class="customer-detail-card card shadow" style="padding: 20px;">
                            <div class="row">
                                <div class="col-md-4 text-center">
                                    <div class="detail-avatar" style="margin-bottom: 20px;">
                                        <c:choose>
                                            <c:when test="${c.image != null && c.image != ''}">
                                                <img src="${pageContext.request.contextPath}/${c.image}" 
                                                     alt="Customer Avatar" 
                                                     style="width: 180px; height: 180px; object-fit: cover; border-radius: 8px; border: 1px solid #ddd;"
                                                     onerror="this.src='${pageContext.request.contextPath}/assert/avatar/default-user.svg'"/>
                                            </c:when>
                                            <c:otherwise>
                                                <img src="${pageContext.request.contextPath}/assert/avatar/default-user.svg" 
                                                     alt="Default Avatar"
                                                     style="width: 180px; height: 180px; object-fit: cover; border-radius: 8px; border: 1px solid #ddd;"/>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>


                                    <h5 style="margin: 0; padding: 0;">${c.customer_name}</h5>
                                    <p class="text-muted">Customer #${c.customer_id}</p>
                                    <c:choose>
                                        <c:when test="${c.account_status == 'Active'}">
                                            <span style="display:inline-block; padding:6px 14px; background:#28a745; color:white; border-radius:6px; font-weight:600;">
                                                Active
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="display:inline-block; padding:6px 14px; background:#dc3545; color:white; border-radius:6px; font-weight:600;">
                                                Inactive
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="col-md-8 detail-info">
                                    <h4 class="mb-4" style="border-bottom: 1px solid #eee; padding-bottom: 10px;">General Information</h4>
                                    <div class="row">
                                        <div class="col-sm-6">
                                            <p><strong>Full Name:</strong> ${c.customer_name}</p>
                                            <p><strong>Email:</strong> ${c.email}</p>
                                            <p><strong>Phone:</strong> ${c.phone}</p>

                                        </div>
                                        <div class="col-sm-6">
                                            <p><strong>Date of Birth:</strong> ${c.dob}</p>
                                            <p><strong>Address:</strong> ${c.address}</p>
                                            <p><strong>Gender:</strong> ${c.gender}</p>                                           
                                        </div>
                                    </div>
                                    <div style="margin-top: 30px; border-top: 1px solid #eee; padding-top: 20px;">
                                        <a href="customerlist" class="btn btn-danger">
                                            <i class="fa fa-arrow-left"></i> Back to List
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:if>
                    <c:if test="${c == null}">
                        <div class="alert alert-danger">
                            No customer found in the database. 
                        </div>
                    </c:if>
                </c:when>
                <c:when test="${requestScope.activeTab == 'feedback'}">
                    <div class="controls">
                        <div class="page-title">Rating And Feedback Management</div>
                    </div>
                    <div class="listFeedbacks" role="region" aria-labelledby="feedbacks-title">
                        <table aria-describedby="orders-desc">
                            <thead>
                                <tr>
                                    <th>Feedback ID</th>
                                    <th>Customer</th>
                                    <th>Product</th>
                                    <th>Rating</th>
                                    <th>Feedback</th>
                                    <th>Date</th>
                                    <th style="text-align:center">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty requestScope.listFeedbacks}">
                                        <c:forEach var="o" items="${requestScope.listFeedbacks}">
                                            <tr data-id="${o.feedbackId}">
                                                <td class="feedbackId" style="text-align: center">${o.feedbackId}</td>
                                                <td>${o.customerName}</td>
                                                <td>${o.product}</td>
                                                <td class="text-center" style="color: tomato; font-weight:700;">${o.rating}/5</td>
                                                <td>${o.comment}</td>
                                                <td><span class="date-pill">${o.createAt}</span></td>
                                                <td><div class="right-actions">
                                                        <button class="icon hide ${o.hidden ? 'hidden-active' : ''}" type="button" name="feedbackIdV" value="${o.feedbackId}" title="hide" aria-label="Hide">${o.hidden == true ? '<i class="bi bi-eye-slash"></i>' :'<i class="bi bi-eye"></i>'}</button>
                                                        <button class="icon reply" type="button" name="feedbackIdR" value="${o.feedbackId}" data-status="${o.feedbackId}" title="Reply" aria-label="Reply">✍️️</button>
                                                    </div></td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="6" style="text-align: center;">No orders found in the database.</td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>

                            </tbody>
                        </table>
                    </div>
                    <!-- Popup View -->
                    <div class="modal fade" id="feedbackDetailModal" tabindex="-1" aria-labelledby="feedbackDetailLabel" aria-hidden="true">
                        <div class="modal-dialog modal-dialog-centered" id="popupModal">
                            <div class="modal-content bg-light text-black" >
                                <div class="modal-header">
                                    <h5 class="modal-title" id="feedabckDetailLabel">Reply Feedback</h5>
                                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                                </div>
                                <form action="${pageContext.request.contextPath}/staff/feedback/management?active=admin" method="POST" id="replyForm">
                                    <div class="modal-body">
                                        <!--chứa popup từ servlet-->
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Close</button>
                                        <button type="submit" id="applyReply" class="btn btn-primary btn-sm">Apply</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </c:when>

                <c:when test="${requestScope.activeTab eq 'order'}">
                    <div class="page-title">Orders Management</div>
                    <div class="d-flex align-items-center mb-3">
                        <form action="${pageContext.request.contextPath}/search" method="GET" class="d-flex flex-grow-1 me-2">
                            <input type="hidden" name="active" value="order">
                            <input type="text" 
                                   name="keyword" 
                                   class="form-control me-2 flex-grow-1"
                                   placeholder="Search by name..." 
                                   value="${param.keyword != null ? param.keyword : ''}"
                                   aria-label="Search">
                            <button type="submit" class="btn btn-primary me-2">Search</button>
                        </form>
                    </div>
                    <div class="listOrders" role="region" aria-labelledby="orders-title">
                        <table aria-describedby="orders-desc">
                            <thead>
                                <tr>
                                    <th>Order ID</th>
                                    <th>Customer Name</th>
                                    <th>Order Date</th>
                                    <th>Status</th>
                                    <th>Total (VND)</th>
                                    <th style="text-align:center">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty requestScope.listOrders}">
                                        <c:forEach var="o" items="${requestScope.listOrders}">
                                            <tr data-id="${o.order_id}">
                                                <td class="order-id" style="text-align: center">${o.order_id}</td>
                                                <td>${o.customer_name}</td>
                                                <td><span class="date-pill">${o.order_date}</span></td>
                                                <td><span class="status-order ${fn:toLowerCase(o.order_status)}">${o.order_status}</span></td>
                                                <td class="text-left text-muted"><fmt:formatNumber value="${o.total_amount}" type="number"/>${o.total_amount}</td>
                                        <td><div class="right-actions">
                                                <form action="orderdetail">
                                                    <button class="icon view" type="button" name="orderIdV" value="${o.order_id}" title="View" aria-label="Xem">👁</button>

                                                    <button class="icon edit" type="button" name="orderIdE" value="${o.order_id}"
                                                            data-status="${o.order_status}" title="Edit" aria-label="Sửa"
                                                            ${(o.order_status == 'DELIVERED' || o.order_status == 'CANCELLED') ? "disabled" : ""}>✏️</button>
                                                </form>
                                            </div></td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="6" style="text-align: center;">No orders found in the database.</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>

                            </tbody>
                        </table>
                    </div>

                    <div class="modal fade" id="orderDetailModal" tabindex="-1" aria-labelledby="orderDetailLabel" aria-hidden="true">
                        <div class="modal-dialog modal-dialog-centered"id="popupModal">
                            <div class="modal-content bg-light text-black" >
                                <div class="modal-header">
                                    <h5 class="modal-title" id="orderDetailLabel">Order Detail</h5>
                                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                                </div>
                                <div class="modal-body">
                                    <!--chứa popup từ servlet-->
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Close</button>
                                </div>
                            </div>
                        </div>
                    </div>


                    <div class="modal fade" id="editStatusPopup" tabindex="-1" aria-labelledby="editStatusLabel" aria-hidden="true">
                        <div class="modal-dialog editPopup modal-dialog-centered">
                            <div class="modal-content bg-light text-black" id="popupEdit">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="editStatusLabel">Edit Status</h5>
                                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                                </div>

                                <div class="modal-body">
                                    <input type="hidden" id="orderIdInput" name="orderId" />
                                    <select class="form-select" id="order-status" name="order-status">
                                        <option value="PENDING">PENDING</option>
                                        <option value="SHIPPING">SHIPPING</option>
                                        <option value="DELIVERED">DELIVERED</option>
                                    </select> 

                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Close</button>
                                    <button id="applyStatus" class="btn btn-primary btn-sm">Apply</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:when>

                <c:otherwise>
                    <div class="controls">
                        <div class="page-title">Product Management</div>
                    </div>

                    <!-- stats row -->
                    <div class="stats-grid">
                        <div class="stat-card">
                            <div style="font-weight:700; font-size:20px;">Total Revenue</div>
                            <div style="font-size:22px;color:#28a745;margin-top:10px;">
                                <%
                                    Long totalRevenue = (Long) request.getAttribute("totalRevenue");
                                    if (totalRevenue != null) {
                                        out.print(String.format("%,d", totalRevenue) + " VND");
                                    } else {
                                        out.print("0 VND");
                                    }
                                %>
                            </div>
                        </div>
                        <div class="stat-card">
                            <div style="font-weight:700; font-size:20px;">Top Products</div>
                            <ul style="margin-top:8px; padding-left:0; list-style:none;">
                                <%
                                    List<TopProduct> topProducts = (List<TopProduct>) request.getAttribute("topProducts");
                                    if (topProducts != null && !topProducts.isEmpty()) {
                                        for (TopProduct tp : topProducts) {
                                %>
                                <li style="display:flex; justify-content:space-between; padding:8px 0; border-bottom:1px solid #f2f2f2;">
                                    <span><%= tp.getProductName()%></span>
                                    <span style="color:#6c757d"><%= tp.getTotalSold()%> sold</span>
                                </li>
                                <%      }
                                } else { %>
                                <li>No sales data</li>
                                    <% } %>
                            </ul>
                        </div>
                    </div>
                    <div class="d-flex align-items-center mb-3">
                        <form action="${pageContext.request.contextPath}/search" method="GET" class="d-flex flex-grow-1 me-2">
                            <input type="text" 
                                   name="keyword" 
                                   class="form-control me-2 flex-grow-1"
                                   placeholder="Search by name..." 
                                   value="${param.keyword != null ? param.keyword : ''}"
                                   aria-label="Search">
                            <button type="submit" class="btn btn-primary me-2">Search</button>
                        </form>
                        <button class="btn btn-success" id="addProductBtn">Add New Product</button>
                    </div>

                    <%-- Simple flash (no hide, no JS) --%>
                    <%
                        String successMessage = (String) session.getAttribute("successMessage");
                        String errorMessage = (String) session.getAttribute("errorMessage");
                        if (successMessage != null) {
                    %>
                    <div style="color: #155724; background: #d4edda; border: 1px solid #c3e6cb; padding:8px 12px; border-radius:6px; margin-bottom:12px; font-weight:600;">
                        <%= successMessage%>
                    </div>
                    <%
                        session.removeAttribute("successMessage");
                    } else if (errorMessage != null) {
                    %>
                    <div style="color: #721c24; background: #f8d7da; border: 1px solid #f5c6cb; padding:8px 12px; border-radius:6px; margin-bottom:12px; font-weight:600;">
                        <%= errorMessage%>
                    </div>
                    <%
                            session.removeAttribute("errorMessage");
                        }
                    %>

                    <!-- product table -->
                    <div class="table-container">

                        <table class="table" aria-describedby="product-list">
                            <thead>
                                <tr>
                                    <th style="width:96px;">Product Image</th>
                                    <th>Product ID</th>
                                    <th>Product Name</th>
                                    <th>Brand</th>
                                    <th>Category</th>
                                    <th>Price(VND)</th>
                                    <th>Quantity</th>
                                    <th style="text-align:center; min-width:160px;">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    List<Product> products = (List<Product>) request.getAttribute("products");
                                    if (products != null && !products.isEmpty()) {
                                        for (Product p : products) {
                                %>
                                <tr>
                                    <td style="width:96px;">
                                        <img class="product-image"
                                             src="${pageContext.request.contextPath}/assert/image/<%= p.getImage()%>"
                                             alt="<%= p.getProductName()%>"
                                             onerror="this.src='${pageContext.request.contextPath}/assert/image/watch1.jpg'"/>
                                    </td>
                                    <td class="product-id"><%= p.getProductId()%></td>
                                    <td class="product-name"><%= p.getProductName()%></td>
                                    <td class="product-brand"><%= p.getBrand()%></td>
                                    <td><%= p.isGender() ? "Men" : "Women"%></td>
                                    <td class="product-price"><%= String.format(java.util.Locale.US, "%,d", p.getPrice())%> </td>
                                    <td class="product-stock"><%= p.getQuantityProduct()%></td>
                                    <td class="actions-cell">
                                        <button class="action-btn view-btn" data-id="<%= p.getProductId()%>" title="View Details">👁️</button>
                                        <button class="action-btn edit-btn" data-id="<%= p.getProductId()%>" title="Edit">✏️</button>
                                        <button class="action-btn delete-btn" data-id="<%= p.getProductId()%>" title="Delete">🗑️</button>
                                    </td>

                                </tr>
                                <%      }
                                } else { %>
                                <tr><td colspan="8" style="text-align:center;padding:18px;">No products found in the database.</td></tr>
                                <% }%>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </main>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        const logoutBtn = document.getElementById('logoutBtn');
        if (logoutBtn) {
            logoutBtn.addEventListener('click', function () {
                if (confirm('Are you sure you want to logout?')) {
                    window.location.href = '${pageContext.request.contextPath}/logout';
                }
            });
        }

        const addBtn = document.getElementById('addProductBtn');
        if (addBtn) {
            addBtn.addEventListener('click', function () {
                window.location.href = '${pageContext.request.contextPath}/addproduct';
            });
        }

        document.querySelectorAll('.view-btn').forEach(btn => {
            btn.addEventListener('click', e => {
                const id = btn.getAttribute('data-id') || '';
                if (!id) {
                    alert('Missing product id');
                    return;
                }
                window.location.href = '${pageContext.request.contextPath}/viewproductdetail?id=' + encodeURIComponent(id);
            });
        });

        document.querySelectorAll('.edit-btn').forEach(btn => {
            btn.addEventListener('click', e => {
                const id = btn.getAttribute('data-id') || '';
                if (!id) {
                    alert('Missing product id');
                    return;
                }
                window.location.href = '${pageContext.request.contextPath}/editproduct?id=' + encodeURIComponent(id);
            });
        });

        document.querySelectorAll('.delete-btn').forEach(btn => {
            btn.addEventListener('click', e => {
                const id = btn.getAttribute('data-id') || '';
                if (!id) {
                    alert('Missing product id');
                    return;
                }
                if (!confirm('Delete product: ' + id + '?'))
                    return;

                const form = document.createElement('form');
                form.method = 'post';
                form.action = '${pageContext.request.contextPath}/deleteproduct';
                const input = document.createElement('input');
                input.type = 'hidden';
                input.name = 'id';
                input.value = id;
                form.appendChild(input);
                document.body.appendChild(form);
                form.submit();
            });
        });
    });
</script>
<script>

    document.querySelectorAll('.icon.view').forEach(viewBtn => {
        viewBtn.addEventListener('click', (e) => {
            const orderId = viewBtn.value;
            console.log("Fetching order detail for ID:", orderId);

            fetch('${pageContext.request.contextPath}/orderdetail?orderIdV=' + orderId, {method: 'GET'})
                    .then(response => response.text())
                    .then(html => {
                        document.querySelector('#orderDetailModal .modal-body').innerHTML = html;
                        const modal = new bootstrap.Modal(document.getElementById('orderDetailModal'));
                        modal.show();
                    })
                    .catch(err => {
                        console.error('Error loading order detail:', err);
                        alert('Không thể tải chi tiết đơn hàng.');
                    });
        });
    });

    document.querySelectorAll('.icon.reply').forEach(fbBtn => {
        fbBtn.addEventListener('click', (e) => {
            const feedbackId = fbBtn.value;
            console.log("Fetching order detail for ID:", feedbackId);

            fetch('${pageContext.request.contextPath}/staff/feedback/management?feedbackId=' + feedbackId, {method: 'GET'})
                    .then(response => response.text())
                    .then(html => {
                        document.querySelector('#feedbackDetailModal .modal-body').innerHTML = html;
                        const modal = new bootstrap.Modal(document.getElementById('feedbackDetailModal'));
                        modal.show();

                        const modalEl = document.getElementById('feedbackDetailModal');
                        modalEl.addEventListener('hidden.bs.modal', () => {
                            fbBtn.disabled = false;   // Enable nút
                        }, {once: true});
                    })
                    .catch(err => {
                        console.error('Error loading feedback detail:', err);
                        alert('Không thể tải chi tiết đơn hàng.');
                    });
        });
    });

    document.addEventListener("DOMContentLoaded", function () {
        const hideButtons = document.querySelectorAll(".icon.hide");

        hideButtons.forEach(btn => {
            btn.addEventListener("click", function () {
                const feedbackId = this.value;

                fetch("${pageContext.request.contextPath}/staffcontrol", {
                    method: "POST",
                    headers: {"Content-Type": "application/x-www-form-urlencoded"},
                    body: "feedbackId=" + feedbackId
                })
                        .then(res => res.json())
                        .then(data => {
                            if (data.success) {

                                this.classList.toggle("hidden-active");
                                this.title = this.classList.contains("hidden-active") ? "Unhide" : "Hide";
                                this.innerHTML = this.classList.contains("hidden-active") ? "<i class='bi bi-eye-slash'></i>" : "<i class='bi bi-eye'></i>";
                            } else {
                                alert("Failed to update feedback status!");
                            }
                        });
            });
        });
    });
</script>

<script>
    let currentOrderId = null;
    let currentRow = null;
    let modal = null;
    document.querySelectorAll('.icon.edit').forEach(function (editBtn) {
        editBtn.addEventListener('click', function (e) {
            const orderId = this.value;
            const status = this.getAttribute('data-status');
            document.getElementById('orderIdInput').value = orderId;

            const select = document.getElementById('order-status');
            select.value = status;

            modal = new bootstrap.Modal(document.getElementById('editStatusPopup'));
            currentRow = $(this).closest("tr");
            currentOrderId = currentRow.data("id");
            modal.show();
        });
    });


    $("#applyStatus").click(function () {
        const newStatus = $("#order-status").val();

        $.ajax({
            url: "${pageContext.request.contextPath}/orderdetail", // Servlet URL
            method: "POST",
            data: {id: currentOrderId, status: newStatus},
            success: function (response) {

                if (response.success) {

                    currentRow.find(".status-order").removeClass("pending shipping delivered cancelled").addClass(response.orderStatus.toLowerCase()).text(response.orderStatus);
                    alert("Cập nhật thành công!");
                    modal.hide();
                } else {
                    alert("Lỗi khi cập nhật!");
                }
            },
            error: function () {
                alert("Không thể kết nối server!");
            }
        });
    });

    document.addEventListener("DOMContentLoaded", function () {
        const statusSelect = document.getElementById("order-status");
        let previousValue = statusSelect.value;

        statusSelect.addEventListener("change", function () {
            const newValue = this.value;

            if (newValue === "DELIVERED") {
                const confirmResult = confirm("Bạn có chắc chắn muốn đánh dấu đơn hàng là DELIVERED không?");

                if (!confirmResult) {

                    this.value = previousValue;
                    return;
                }
            }


            previousValue = newValue;
        });
    });
</script>

<jsp:include page="/WEB-INF/include/footer.jsp" />
