<%-- 
    Document   : Staff
    Created on : Oct 15, 2025, 10:29:09 AM
    Author     : Nguyen Thien Dat - CE190879 - 06/05/2005
--%>
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
            .order-id{
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
            .icon.view{
                background:#fff;
                color:#111;
                border:1px solid #111
            }
            .icon.view1{
                background:#fff;
                color:#111;
                border:1px solid #111
            }
            .icon.edit{
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
                    <img src="./assert/image/trikhue.jpg" alt="Avatar" class="avatar" />
                    <div class="name"><%= (t != null ? t.getUserName() : "Hỏng Cóa Tên")%></div>
                    <div class="status small"><%= (t != null ? t.getRole() : "None")%></div>
                </div>
                <button class="nav-link active" id="pill-product" data-bs-toggle="pill" data-bs-target="#v-pills-product" type="button" role="tab" aria-controls="v-pills-products" aria-selected="true">Product Management</button>
                <button class="nav-link" id="pill-order" data-bs-toggle="pill" data-bs-target="#v-pills-order" type="button" role="tab" aria-controls="v-pills-order" aria-selected="false">Order Management</button>
                <button class="nav-link" id="pill-rate-feedback" data-bs-toggle="pill" data-bs-target="#v-pills-rate-feedback" type="button" role="tab" aria-controls="v-pills-messages" aria-selected="false">Rate And Feedback Management</button>
                <button class="nav-link" id="pill-profile" data-bs-toggle="pill" data-bs-target="#v-pills-profile" type="button" role="tab" aria-controls="v-pills-settings" aria-selected="false">Profile Management</button>
            </div>

            <div class="tab-content" id="v-pills-tabContent">

                <div class="tab-pane fade show active" id="v-pills-product" role="tabpanel" aria-labelledby="v-pills-product-tab" tabindex="0">
                    <section class="main" aria-label="Product management">
                        <div class="row mb-3 align-items-center">
                            <div class="col-md-8">
                                <h3>Product List</h3>
                                <button id="toggleFilterBtn" type="button" class="btn btn-outline-secondary" data-bs-toggle="modal" data-bs-target="#filterModal">
                                    <i class="bi bi-funnel"></i> Filter
                                </button>
                                <form action="${pageContext.request.contextPath}/staffcontrol" method="GET" class="d-flex">
                                    <input type="text" 
                                           name="keyword" 
                                           class="form-control me-2" 
                                           placeholder="Search by product name..." 
                                           value="${param.keyword != null ? param.keyword : ''}"
                                           aria-label="Search">
                                    <button type="submit" class="btn btn-primary">Search</button>
                                </form>
                                <!-- Filter Modal -->
                                <div class="modal fade" id="filterModal" tabindex="-1" aria-labelledby="filterModalLabel" aria-hidden="true">
                                    <div class="modal-dialog modal-dialog-centered">
                                        <div class="modal-content">

                                            <div class="modal-header">
                                                <h5 class="modal-title" id="filterModalLabel">Filter Products</h5>
                                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                            </div>

                                            <form action="${pageContext.request.contextPath}/staffcontrol" method="GET">
                                                <div class="modal-body">
                                                    <!-- Brand -->
                                                    <div class="mb-3">
                                                        <label class="form-label fw-bold">Brand</label>
                                                        <select name="brand" class="form-select">
                                                            <option value="">All Brands</option>
                                                            <option value="Casio" ${param.brand == 'Casio' ? 'selected' : ''}>Casio</option>
                                                            <option value="Citizen" ${param.brand == 'Citizen' ? 'selected' : ''}>Citizen</option>
                                                            <option value="Rolex" ${param.brand == 'Rolex' ? 'selected' : ''}>Rolex</option>
                                                            <option value="Omega" ${param.brand == 'Omega' ? 'selected' : ''}>Omega</option>
                                                        </select>
                                                    </div>

                                                    <!-- Gender -->
                                                    <div class="mb-3">
                                                        <label class="form-label fw-bold">Gender</label>
                                                        <select name="gender" class="form-select">
                                                            <option value="">All Genders</option>
                                                            <option value="1" ${param.gender == '1' ? 'selected' : ''}>Nam</option>
                                                            <option value="0" ${param.gender == '0' ? 'selected' : ''}>Nữ</option>
                                                        </select>
                                                    </div>

                                                    <!-- Price Range -->
                                                    <div class="mb-3">
                                                        <label class="form-label fw-bold">Price Range</label>
                                                        <select name="priceRange" class="form-select">
                                                            <option value="">All Prices</option>
                                                            <option value="0-2000000" ${param.priceRange == '0-2000000' ? 'selected' : ''}>Dưới 2 triệu</option>
                                                            <option value="2000000-4000000" ${param.priceRange == '2000000-4000000' ? 'selected' : ''}>2 - 4 triệu</option>
                                                            <option value="4000000-10000000" ${param.priceRange == '4000000-10000000' ? 'selected' : ''}>4 - 10 triệu</option>
                                                            <option value="10000000-40000000" ${param.priceRange == '10000000-40000000' ? 'selected' : ''}>10 - 40 triệu</option>
                                                            <option value="40000000-100000000" ${param.priceRange == '40000000-100000000' ? 'selected' : ''}>40 - 100 triệu</option>
                                                            <option value="100000000+" ${param.priceRange == '100000000+' ? 'selected' : ''}>Trên 100 triệu</option>
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
                                        <th>Product ID</th>
                                        <th>Product Name</th>
                                        <th>Machine</th>
                                        <th>Price (VNĐ)</th>
                                        <th>Quantity</th>
                                        <th style="text-align:center">Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty requestScope.listProducts}">
                                            <c:forEach var="p" items="${requestScope.listProducts}">
                                                <tr>
                                                    <td class="product-id">${p.productId}</td>
                                                    <td>${p.productName}</td>
                                                    <td>${p.machine}</td>
                                                    <td class="text-end text-muted"><fmt:formatNumber value="${p.price}" type="number"/></td>
                                                    <td>${p.quantityProduct}</td>
                                                    <td>
                                                        <div class="right-actions" role="group" aria-label="Actions">

                                                            <a href="viewproductdetail?id=${p.productId}" class="icon view1" title="View Detail" aria-label="Xem chi tiết sản phẩm">
                                                                👁
                                                            </a>

                                                            <%-- 
                                                            <button class="icon edit" title="Edit" aria-label="Sửa sản phẩm">
                                                                <svg width="16" height="16" viewBox="0 0 24 24" fill="none"><path d="M3 21h3l11-11-3-3L3 18v3z" stroke="#111" stroke-width="1.4" stroke-linecap="round" stroke-linejoin="round"/><path d="M14 7l3 3" stroke="#111" stroke-width="1.4" stroke-linecap="round" stroke-linejoin="round"/></svg>
                                                            </button> 
                                                            --%>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="6" style="text-align: center;">No products found in the database.</td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                    </section>
                </div>

                <!--ở dưới đây làm order List cấm tk nào ko phận sự vào(ㆆ_ㆆ)-->

                <div class="tab-pane fade" id="v-pills-order" role="tabpanel" aria-labelledby="v-pills-order-tab" tabindex="-1">
                    <section class="main" aria-label="Order management">
                        <h4 id="title">Order List</h4>
                        <div class="listOrders" role="region" aria-labelledby="orders-title">
                            <table aria-describedby="orders-desc">
                                <thead>
                                    <tr>
                                        <th>Order ID</th>
                                        <th>Customer Name</th>
                                        <th>Order Date</th>
                                        <th>Status</th>
                                        <th>Total (VNĐ)</th>
                                        <th style="text-align:center">Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty requestScope.listOrders}">
                                            <c:forEach var="o" items="${requestScope.listOrders}">
                                                <tr>
                                                    <td class="order-id">${o.order_id}</td>
                                                    <td>${o.customer_name}</td>
                                                    <td><span class="date-pill">${o.order_date}</span></td>
                                                    <td><span class="status-order ${fn:toLowerCase(o.order_status)}">${o.order_status}</span></td>
                                                    <td class="text-end text-muted"><fmt:formatNumber value="${o.total_amount}" type="number"/></td>
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
                        <!-- Popup View -->
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

                        <!-- Popup Edit -->
                        <form action="orderdetail" method="post">
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
                                            <button type="submit" id="applyStatus" class="btn btn-primary btn-sm">Apply</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </section>

                </div>
                <div class="tab-pane fade" id="v-pills-messages" role="tabpanel" aria-labelledby="v-pills-messages-tab" tabindex="0">...</div>
                <div class="tab-pane fade" id="v-pills-settings" role="tabpanel" aria-labelledby="v-pills-settings-tab" tabindex="0">...</div>
            </div>
        </div>
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

            document.querySelectorAll('.icon.edit').forEach(editBtw => {
                editBtw.addEventListener('click', (e) => {
                    const orderId = e.currentTarget.value;
                    const status = e.currentTarget.getAttribute('data-status');
                    document.getElementById('orderIdInput').value = orderId;
                    const select = document.getElementById('order-status');
                    select.value = status;
                    const modal = new bootstrap.Modal(document.getElementById('editStatusPopup'));
                    modal.show();
                });
            });
        </script>
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const activeTab = "<%= request.getAttribute("activeTab") != null ? request.getAttribute("activeTab") : ""%>";
                console.log("ActiveTab:", activeTab);

                if (activeTab === "order") {
                    const trigger = document.querySelector('[data-bs-target="#v-pills-order"]');
                    if (trigger) {
                        const tab = new bootstrap.Tab(trigger);
                        tab.show();
                        console.log("Tab Order shown");
                    } else {
                        console.log("Không tìm thấy trigger tab order");
                    }
                }
            });
        </script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js" integrity="sha384-j1CDi7MgGQ12Z7Qab0qlWQ/Qqz24Gc6BM0thvEMVjHnfYGF0rmFCozFSxQBxwHKO" crossorigin="anonymous"></script>
    </body>
</html>
<jsp:include page="/WEB-INF/include/footer.jsp" />
