<%-- 
    Document   : Staff
    Created on : Oct 15, 2025, 10:29:09 AM
    Author     : Nguyen Thien Dat - CE190879 - 06/05/2005
--%>
<%@page import="model.Product"%>
<%-- File: /WEB-INF/staff.jsp --%>
<%@page import="java.util.List"%>
<%@page import="model.Order"%>
<%@page import="model.OrderDetail"%>
<%@page import="model.Staff"%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/include/header.jsp" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt" %>

<%
    Staff t = (Staff) request.getAttribute("staff");
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html>
    <head>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <style>
            body {
                font-family: Arial, sans-serif;
                background:#f4f6f8;
                margin: 0;
                padding: 0;
                display: flex;
                flex-direction: column;
                min-height: 100vh;
            }
            .d-flex.align-items-start {
                flex-grow: 1;
                padding: 20px;
            }
            .card {
                width:240px;
                margin:0 auto;
                background:#fff;
                border-radius:8px;
                box-shadow:0 2px 6px rgba(0,0,0,0.1);
                display:flex;
                padding-bottom: 10px;
                overflow:hidden;
            }
            .avatar {
                width:160px;
                height:160px;
                margin-bottom:16px;
                margin-top:16px;
                border-radius:50%;
                object-fit:cover;
                border:6px solid #fff;
                box-shadow:0 2px 6px rgba(0,0,0,0.1);
                background:#ddd;
                align-self: center;
            }
            .name {
                font-size:20px;
                margin-top:12px;
                font-weight:700;
                text-align: center;
            }
            .status {
                color:white;
                margin-top:6px;
                font-weight: 600;
                background-color: black;
                text-align: center;
                padding:4px 8px;
                border-radius:6px;
                font-size:16px;
                margin-top:6px;
                width: 40%;
                margin: 0 auto;
                display:inline-block;
            }
            .nav-link{
                box-shadow:0 2px 6px rgba(0,0,0,0.1);
                color: black;
                width: 80%;
                margin: 5px auto;
                background: #fff;
            }

            #title{
                margin:0 0 12px 0;
                font-size:18px;
                font-weight: 900;
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
            .icon.viewf{
                background:#fff;
                color:#111;
                border:1px solid #111
            }
            .icon.view1{
                background:#fff;
                color:#111;
                border:1px solid #111
            }
            .icon.edit,
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
            .listProducts,
            .listFeedbacks{
                max-height: 400px;
                overflow-y: auto;
                overflow-y: auto;
                overflow-x: hidden;
                display: inline-block;
                border: 1px solid #ddd;
            }

            .listOrders table,
            .listProducts table,
            .listFeedbacks table{
                width: 100%;
                border-collapse: collapse;
            }

            .listOrders thead th,
            .listProducts thead th,
            .listFeedbacks thead th{
                position: sticky;
                top: 0;
                background-color: #f8f9fa;
                z-index: 2;
                text-align: left;
                padding: 8px;
            }

            .listOrders td,
            .listProducts td,
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
    </head>
    <body>  
        <div class="d-flex align-items-start">
            <div class="nav flex-column nav-pills me-3" id="v-pills-tab" role="tablist" aria-orientation="vertical">
                <div class="card">
                    <img src="./assert/image/account.jpg" alt="Avatar" class="avatar" />
                    <div class="status small"><%= (t != null ? t.getRole() : "None")%></div>
                </div>

                <a class="nav-link ${requestScope.activeTab eq 'product' ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/staffcontrol?active=product">Product Management</a>

                <a class="nav-link ${requestScope.activeTab eq 'order' ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/staffcontrol?active=order">Order Management</a>

                <a class="nav-link ${requestScope.activeTab eq 'feedback' ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/staffcontrol?active=feedback">Feedback Management</a>
            </div>
            <main class="main-content" aria-label="Admin main content">
                <div class="tab-content" id="v-pills-tabContent">
                    <c:choose>
                        <c:when test="${requestScope.activeTab == 'product'}">
                            <div class="row mb-3 align-items-center">
                                <div class="col-md-8">
                                    <h3>Product List</h3>
                                    <form action="${pageContext.request.contextPath}/search" method="GET" 
                                          class="d-flex align-items-center gap-2">
                                        <input type="text" 
                                               name="keyword" 
                                               class="form-control flex-grow-1" 
                                               placeholder="Search by name..." 
                                               value="${param.keyword != null ? param.keyword : ''}"
                                               aria-label="Search">
                                        <button type="submit" class="btn btn-primary px-4">Search</button>
                                        <button id="toggleFilterBtn" type="button" 
                                                class="btn btn-outline-secondary d-inline-flex align-items-center px-4" 
                                                data-bs-toggle="modal" data-bs-target="#filterModal">
                                            <i class="bi bi-funnel"></i> Filter
                                        </button>
                                    </form>

                                    <div class="modal fade" id="filterModal" tabindex="-1" aria-labelledby="filterModalLabel" aria-hidden="true">
                                        <div class="modal-dialog modal-dialog-centered">
                                            <div class="modal-content">

                                                <div class="modal-header">
                                                    <h5 class="modal-title" id="filterModalLabel">Filter Products</h5>
                                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                </div>

                                                <form action="${pageContext.request.contextPath}/filterServlet" method="GET">
                                                    <input type="hidden" name="active" value="staff">
                                                    <div class="modal-body">
                                                        <!-- Brand -->
                                                        <div class="mb-3">
                                                            <label class="form-label fw-bold">Brand</label>
                                                            <select name="brand" class="form-select">
                                                                <option value="">All Brands</option>
                                                                <c:forEach var="brand" items="${requestScope.listBrands}">
                                                                    <option value="${brand.brandName}" ${param.brand == brand.brandName ? 'selected' : ''}>${brand.brandName}</option>
                                                                </c:forEach>
                                                            </select>
                                                        </div>


                                                        <div class="mb-3">
                                                            <label class="form-label fw-bold">Gender</label>
                                                            <select name="gender" class="form-select">
                                                                <option value="">All Genders</option>
                                                                <option value="1" ${param.gender == '1' ? 'selected' : ''}>Male</option>
                                                                <option value="0" ${param.gender == '0' ? 'selected' : ''}>Female</option>
                                                            </select>
                                                        </div>


                                                        <div class="mb-3">
                                                            <label class="form-label fw-bold">Price Range</label>
                                                            <select name="priceRange" class="form-select">
                                                                <option value="">All Prices</option>
                                                                <option value="0-2000000" ${param.priceRange == '0-2000000' ? 'selected' : ''}>0 - 2 million</option>
                                                                <option value="2000000-4000000" ${param.priceRange == '2000000-4000000' ? 'selected' : ''}>2 - 4 million</option>
                                                                <option value="4000000-6000000" ${param.priceRange == '4000000-6000000' ? 'selected' : ''}>4 - 6 million</option>
                                                                <option value="6000000-8000000" ${param.priceRange == '6000000-8000000' ? 'selected' : ''}>6 - 8 million</option>
                                                                <option value="8000000-10000000" ${param.priceRange == '8000000-10000000' ? 'selected' : ''}>8 - 10 million</option>
                                                                <option value="10000000-20000000" ${param.priceRange == '10000000-20000000' ? 'selected' : ''}>10 - 20 million</option>
                                                                <option value="20000000-40000000" ${param.priceRange == '20000000-40000000' ? 'selected' : ''}>20 - 40 million</option>
                                                                <option value="40000000-100000000" ${param.priceRange == '40000000-100000000' ? 'selected' : ''}>40 - 100 million</option>
                                                                <option value="100000000+" ${param.priceRange == '100000000+' ? 'selected' : ''}>Above 100 million</option>
                                                            </select>
                                                        </div>
                                                    </div>

                                                    <div class="modal-footer">
                                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                                        <button type="submit" class="btn btn-success">Apply Filter</button>
                                                    </div>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="table-responsive">
                                <table class="table table-striped">
                                </table>
                            </div>
                            <div class="listProducts" role="region" aria-labelledby="products-title">
                                <table aria-describedby="products-desc">
                                    <thead>
                                        <tr>
                                            <th>Product Image</th>
                                            <th>Product ID</th>
                                            <th>Product Name</th>
                                            <th>Machine</th>
                                            <th>Price (VND)</th>
                                            <th>Quantity</th>
                                            <th style="text-align:center">Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${not empty requestScope.listProducts}">
                                                <c:forEach var="p" items="${requestScope.listProducts}">
                                                    <tr>
                                                        <td style="width:96px;">
                                                            <c:set var="imgPath">
                                                                <c:choose>
                                                                    <c:when test="${not empty p.image}">
                                                                        ${pageContext.request.contextPath}/assert/image/${p.image}
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        ${pageContext.request.contextPath}/assert/image/watch1.jpg
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </c:set>

                                                            <img class="product-image"
                                                                 src="${imgPath}"
                                                                 alt="${fn:escapeXml(p.productName)}"
                                                                 onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/assert/image/watch1.jpg';"
                                                                 style="width:64px; height:64px; object-fit:cover; border-radius:6px;">
                                                        </td>

                                                        <td class="product-id">${p.productId}</td>
                                                        <td>${fn:escapeXml(p.productName)}</td>
                                                        <td>${fn:escapeXml(p.machine)}</td>
                                                        <td class="text-end text-muted"><fmt:formatNumber value="${p.price}" type="number"/></td>
                                                        <td>${p.quantityProduct}</td>
                                                        <td>
                                                            <div class="right-actions" role="group" aria-label="Actions">
                                                                <a href="${pageContext.request.contextPath}/viewproductdetail?id=${p.productId}" class="icon view1" title="View Detail" aria-label="Xem chi tiết sản phẩm">👁</a>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:when>

                                            <c:otherwise>
                                                <tr>
                                                    <td colspan="7" style="text-align:center;">No products found in the database.</td>
                                                </tr>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>

                                </table>
                            </div>
                        </c:when>

                        <c:when test="${requestScope.activeTab == 'order'}">
                            <h4 id="title">Order List</h4>
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
                                                        <td class="order-id"style="text-align: center">${o.order_id}</td>
                                                        <td>${o.customer_name}</td>
                                                        <td><span class="date-pill">${o.order_date}</span></td>
                                                        <td><span class="status-order ${fn:toLowerCase(o.order_status)}">${o.order_status}</span></td>
                                                        <td class="text-left text-muted"><fmt:formatNumber value="${o.total_amount}" type="number"/></td>
                                                        <td><div class="right-actions">
                                                                <form action="orderdetail">
                                                                    <button class="icon view" type="button" name="orderIdV" value="${o.order_id}" title="View" aria-label="Xem">👁</button>
                                                                    <button class="icon edit" type="button" name="orderIdE" value="${o.order_id}" data-status="${o.order_status}" title="Edit" aria-label="Sửa">✏️</button>
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

                        <c:when test="${requestScope.activeTab == 'feedback'}">
                            <h4 id="title">Rate And Feedback Management</h4>
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
                                                                <form action="orderdetail">
                                                                    <button class="icon hide" type="button" name="feedbackIdV" value="${o.feedbackId}" title="hide" aria-label="Hide">👁</button>
                                                                    <button class="icon reply" type="button" name="feedbackIdR" value="${o.feedbackId}" data-status="${o.feedbackId}" title="Reply" aria-label="Reply">✍️️</button>
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

                            <div class="modal fade" id="feedbackDetailModal" tabindex="-1" aria-labelledby="feedbackDetailLabel" aria-hidden="true">
                                <div class="modal-dialog modal-dialog-centered"id="popupModal">
                                    <div class="modal-content bg-light text-black" >
                                        <div class="modal-header">
                                            <h5 class="modal-title" id="feedbackDetailLabel">Reply Feedback</h5>
                                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                                        </div>
                                        <form id="replyForm">
                                            <div class="modal-body">

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
                    </c:choose>
            </main>
        </div>

        <script>
            let currentOrderId = null;
            let currentRow = null;

            document.querySelectorAll('.icon.edit').forEach(function (editBtn) {
                editBtn.addEventListener('click', function (e) {
                    const orderId = this.value;
                    const status = this.getAttribute('data-status');
                    document.getElementById('orderIdInput').value = orderId;

                    const select = document.getElementById('order-status');
                    select.value = status;

                    const modal = new bootstrap.Modal(document.getElementById('editStatusPopup'));
                    currentRow = $(this).closest("tr");
                    currentOrderId = currentRow.data("id");
                    modal.show();
                });
            });

            // Khi nhấn Apply → gửi AJAX để update
            $("#applyStatus").click(function () {
                const newStatus = $("#order-status").val();

                $.ajax({
                    url: "orderdetail", // Servlet URL
                    method: "POST",
                    data: {id: currentOrderId, status: newStatus},
                    success: function (response) {
                        // response là JSON do Servlet trả về
                        if (response.success) {
                            // ✅ Cập nhật UI ngay tại chỗ
                            currentRow.find(".status-order").removeClass("pending shipping delivered cancelled").addClass(response.orderStatus.toLowerCase()).text(response.orderStatus);
                            alert("Cập nhật thành công!");
                        } else {
                            alert("Lỗi khi cập nhật!");
                        }
                    },
                    error: function () {
                        alert("Không thể kết nối server!");
                    }
                });
            });
        </script>
        <script>
            // Sidebar active handling
            document.querySelectorAll('.nav-item').forEach(item => {
                item.addEventListener('click', () => {
                    document.querySelectorAll('.nav-item').forEach(i => i.classList.remove('active'));
                    item.classList.add('active');
                    // In a real app you'd route or update content here
                });
            });

            // Example: action button handlers (just demo)
            document.querySelectorAll('.icon.view').forEach(viewBtn => {
                viewBtn.addEventListener('click', (e) => {
                    const orderId = viewBtn.value;
                    console.log("Fetching order detail for ID:", orderId);

                    fetch('orderdetail?orderIdV=' + orderId, {method: 'GET'})
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
            //button mở popup feedbackDetail
            document.querySelectorAll('.icon.reply').forEach(fbBtn => {
                fbBtn.addEventListener('click', (e) => {
                    const feedbackId = fbBtn.value;
                    console.log("Fetching order detail for ID:", feedbackId);

                    fetch('staff/feedback/management?feedbackId=' + feedbackId, {method: 'GET'})
                            .then(response => response.text())
                            .then(html => {
                                document.querySelector('#feedbackDetailModal .modal-body').innerHTML = html;
                                const modal = new bootstrap.Modal(document.getElementById('feedbackDetailModal'));
                                modal.show();
                            })
                            .catch(err => {
                                console.error('Error loading feedback detail:', err);
                                alert('Không thể tải chi tiết đơn hàng.');
                            });
                });
            });

            $(document).on("submit", "#replyForm", function (e) {
                e.preventDefault(); // Ngăn reload

                $.ajax({
                    url: "staff/feedback/management",
                    method: "POST",
                    data: $(this).serialize(),
                    success: function (response) {
                        if (response.success) {
                            alert("✅ Gửi phản hồi thành công!");
                            $("#feedbackDetailModal").modal("hide");
                        } else {
                            alert("❌ Lỗi: " + (response.message || "Không thể gửi phản hồi."));
                        }
                    },
                    error: function () {
                        alert("⚠️ Không thể kết nối server!");
                    }
                });
            });

            document.addEventListener("DOMContentLoaded", function () {
                const hideButtons = document.querySelectorAll(".icon.hide");

                hideButtons.forEach(btn => {
                    btn.addEventListener("click", function () {
                        const feedbackId = this.value;

                        fetch("staffcontrol", {
                            method: "POST",
                            headers: {"Content-Type": "application/x-www-form-urlencoded"},
                            body: "feedbackId=" + feedbackId
                        })
                                .then(res => res.json())
                                .then(data => {
                                    if (data.success) {
                                        // Toggle CSS hoặc text để báo đã ẩn/hiện
                                        this.classList.toggle("hidden-active");
                                        this.title = this.classList.contains("hidden-active") ? "Unhide" : "Hide";
                                        this.textContent = this.classList.contains("hidden-active") ? "👁️‍🗨️" : "👁";
                                    } else {
                                        alert("Failed to update feedback status!");
                                    }
                                });
                    });
                });
            });
        </script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js" integrity="sha384-j1CDi7MgGQ12Z7Qab0qlWQ/Qqz24Gc6BM0thvEMVjHnfYGF0rmFCozFSxQBxwHKO" crossorigin="anonymous"></script>
    </body>
</html>
<jsp:include page="/WEB-INF/include/footer.jsp" />
