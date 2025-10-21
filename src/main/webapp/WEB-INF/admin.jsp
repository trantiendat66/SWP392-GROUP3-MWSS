<%--
    Document   : Admin Dashboard JSP
    Created on : Jan 20, 2025
    Author     : Dang Vi Danh - CE19687
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Product" %>
<%@ page import="model.Staff" %>
<%@ include file="/WEB-INF/include/header.jsp" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    // Kiểm tra session - Admin phải đăng nhập
    Staff staff = (Staff) session.getAttribute("staff");
    if (staff == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
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
            background-color: #dc3545;
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
        .status-order.completed{
            color:#00cc33;
            font-weight:700;
        }
        .status-order.cancelled{
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
        .icon.delete{
            background:#dc3545;
            color:#fff;
            border:1px solid #dc3545
        }
        .icon.add{
            background:#28a745;
            color:#fff;
            border:1px solid #28a745
        }
        .icon.manage{
            background:#6f42c1;
            color:#fff;
            border:1px solid #6f42c1
        }
        #popupModal {
            max-width:900px;
            margin:0 auto;
            background:#fff;
            border-radius:8px;
            box-shadow:0 2px 6px rgba(0,0,0,0.1);
            display: inline-flex;
            overflow:hidden;
        }
        .left {
            width: 50%;
            padding:30px;
            background:linear-gradient(180deg,#ffffff,#f7f9fb);
        }
        .right {
            flex:1;
            padding:30px 40px;
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
                <div class="name"><%= (staff != null ? staff.getUserName() : "Admin")%></div>
                <div class="status small">ADMIN</div>
            </div>
            <button class="nav-link active" id="pill-product" data-bs-toggle="pill" data-bs-target="#v-pills-product" type="button" role="tab" aria-controls="v-pills-products" aria-selected="true">Product Management</button>
            <button class="nav-link" id="pill-order" data-bs-toggle="pill" data-bs-target="#v-pills-order" type="button" role="tab" aria-controls="v-pills-profile" aria-selected="false">Order Management</button>
            <button class="nav-link" id="pill-staff" data-bs-toggle="pill" data-bs-target="#v-pills-staff" type="button" role="tab" aria-controls="v-pills-staff" aria-selected="false">Staff Management</button>
            <button class="nav-link" id="pill-customer" data-bs-toggle="pill" data-bs-target="#v-pills-customer" type="button" role="tab" aria-controls="v-pills-customer" aria-selected="false">Customer Management</button>
            <button class="nav-link" id="pill-analytics" data-bs-toggle="pill" data-bs-target="#v-pills-analytics" type="button" role="tab" aria-controls="v-pills-analytics" aria-selected="false">Analytics & Reports</button>
            <button class="nav-link" id="pill-profile" data-bs-toggle="pill" data-bs-target="#v-pills-profile" type="button" role="tab" aria-controls="v-pills-settings" aria-selected="false">Profile Management</button>
        </div>

        <div class="tab-content" id="v-pills-tabContent">

            <div class="tab-pane fade show active" id="v-pills-product" role="tabpanel" aria-labelledby="v-pills-product-tab" tabindex="0">
                <section class="main" aria-label="Product management">
                    <div class="row mb-3 align-items-center">
                        <div class="col-md-8">
                            <h3>Product Management</h3>
                            <form action="${pageContext.request.contextPath}/admin" method="GET" class="d-flex">
                                <input type="text" 
                                       name="keyword" 
                                       class="form-control me-2" 
                                       placeholder="Search by product name..." 
                                       value="${param.keyword != null ? param.keyword : ''}"
                                       aria-label="Search">
                                <button type="submit" class="btn btn-primary">Search</button>
                            </form>
                        </div>
                        <div class="col-md-4 text-end">
                            <button class="icon add" title="Add Product" aria-label="Thêm sản phẩm mới">
                                ➕ Add Product
                            </button>
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
                                    <th>Brand</th>
                                    <th>Price (VND)</th>
                                    <th>Quantity</th>
                                    <th style="text-align:center">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% List<Product> products = (List<Product>) request.getAttribute("products"); %>
                                <% if (products != null && !products.isEmpty()) {
                                    for (Product p : products) { %>
                                        <tr>
                                            <td class="product-id"><%= p.getProductId() %></td>
                                            <td><%= p.getProductName() %></td>
                                            <td><%= p.getBrand() %></td>
                                            <td><%= p.getPrice() %></td>
                                            <td><%= p.getQuantityProduct() %></td>
                                            <td>
                                                <div class="right-actions" role="group" aria-label="Actions">
                                                    <a href="viewproductdetail?id=<%=p.getProductId()%>" class="icon view1" title="View Detail" aria-label="Xem chi tiết sản phẩm">
                                                        👁
                                                    </a>
                                                    <button class="icon edit" title="Edit" aria-label="Sửa sản phẩm">
                                                        ✏️
                                                    </button>
                                                    <button class="icon delete" title="Delete" aria-label="Xóa sản phẩm">
                                                        🗑️
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                <%  }
                                } else { %>
                                    <tr>
                                        <td colspan="6" style="text-align: center;">No products found in the database.</td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </section>
            </div>

            <!-- Order Management Tab -->
            <div class="tab-pane fade" id="v-pills-order" role="tabpanel" aria-labelledby="v-pills-order-tab" tabindex="-1">
                <section class="main" aria-label="Order management">
                    <h4 id="title">Order Management</h4>
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
                                <tr>
                                    <td colspan="6" style="text-align: center;">No orders found in the database.</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </section>
            </div>

            <!-- Staff Management Tab -->
            <div class="tab-pane fade" id="v-pills-staff" role="tabpanel" aria-labelledby="v-pills-staff-tab" tabindex="-1">
                <section class="main" aria-label="Staff management">
                    <div class="row mb-3 align-items-center">
                        <div class="col-md-8">
                            <h4 id="title">Staff Management</h4>
                        </div>
                        <div class="col-md-4 text-end">
                            <button class="icon add" title="Add Staff" aria-label="Thêm nhân viên mới">
                                ➕ Add Staff
                            </button>
                        </div>
                    </div>
                    <div class="listStaff" role="region" aria-labelledby="staff-title">
                        <table aria-describedby="staff-desc">
                            <thead>
                                <tr>
                                    <th>Staff ID</th>
                                    <th>Name</th>
                                    <th>Email</th>
                                    <th>Role</th>
                                    <th>Status</th>
                                    <th style="text-align:center">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td colspan="6" style="text-align: center;">No staff found in the database.</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </section>
            </div>

            <!-- Customer Management Tab -->
            <div class="tab-pane fade" id="v-pills-customer" role="tabpanel" aria-labelledby="v-pills-customer-tab" tabindex="-1">
                <section class="main" aria-label="Customer management">
                    <div class="row mb-3 align-items-center">
                        <div class="col-md-8">
                            <h4 id="title">Customer Management</h4>
                        </div>
                        <div class="col-md-4 text-end">
                            <button class="icon manage" title="Export Data" aria-label="Xuất dữ liệu khách hàng">
                                📊 Export Data
                            </button>
                        </div>
                    </div>
                    <div class="listCustomers" role="region" aria-labelledby="customers-title">
                        <table aria-describedby="customers-desc">
                            <thead>
                                <tr>
                                    <th>Customer ID</th>
                                    <th>Name</th>
                                    <th>Email</th>
                                    <th>Phone</th>
                                    <th>Registration Date</th>
                                    <th style="text-align:center">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td colspan="6" style="text-align: center;">No customers found in the database.</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </section>
            </div>

            <!-- Analytics & Reports Tab -->
            <div class="tab-pane fade" id="v-pills-analytics" role="tabpanel" aria-labelledby="v-pills-analytics-tab" tabindex="-1">
                <section class="main" aria-label="Analytics and reports">
                    <h4 id="title">Analytics & Reports</h4>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="card">
                                <div class="card-body">
                                    <h5 class="card-title">Sales Overview</h5>
                                    <p class="card-text">View sales statistics and trends</p>
                                    <button class="icon manage" title="View Sales Report">📈 Sales Report</button>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="card">
                                <div class="card-body">
                                    <h5 class="card-title">Inventory Report</h5>
                                    <p class="card-text">Check stock levels and inventory status</p>
                                    <button class="icon manage" title="View Inventory Report">📦 Inventory Report</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>
            </div>

            <!-- Profile Management Tab -->
            <div class="tab-pane fade" id="v-pills-profile" role="tabpanel" aria-labelledby="v-pills-profile-tab" tabindex="-1">
                <section class="main" aria-label="Profile management">
                    <h4 id="title">Profile Management</h4>
                    <div class="card">
                        <div class="card-body">
                            <h5 class="card-title">Admin Profile</h5>
                            <p class="card-text">Manage your admin account settings</p>
                            <button class="icon edit" title="Edit Profile" aria-label="Chỉnh sửa thông tin cá nhân">
                                ✏️ Edit Profile
                            </button>
                        </div>
                    </div>
                </section>
            </div>
        </div>
    </div>
    
    <script>
        // Sidebar active handling
        document.querySelectorAll('.nav-link').forEach(item => {
            item.addEventListener('click', () => {
                document.querySelectorAll('.nav-link').forEach(i => i.classList.remove('active'));
                item.classList.add('active');
            });
        });

        // Example: action button handlers
        document.querySelectorAll('.icon.edit').forEach(btn => {
            btn.addEventListener('click', (e) => {
                const tr = e.target.closest('tr');
                if (!tr) return;
                const id = tr.querySelector('.product-id')?.textContent || 'Unknown';
                alert('Edit product: ' + id);
            });
        });

        document.querySelectorAll('.icon.delete').forEach(btn => {
            btn.addEventListener('click', (e) => {
                const tr = e.target.closest('tr');
                if (!tr) return;
                const id = tr.querySelector('.product-id')?.textContent || 'Unknown';
                if (confirm('Are you sure you want to delete product: ' + id + '?')) {
                    alert('Delete product: ' + id);
                }
            });
        });

        document.querySelectorAll('.icon.add').forEach(btn => {
            btn.addEventListener('click', (e) => {
                alert('Add new item');
            });
        });
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js" integrity="sha384-j1CDi7MgGQ12Z7Qab0qlWQ/Qqz24Gc6BM0thvEMVjHnfYGF0rmFCozFSxQBxwHKO" crossorigin="anonymous"></script>
</body>
</html>
<jsp:include page="/WEB-INF/include/footer.jsp" />


