<%-- /WEB-INF/admin.jsp
     Admin Dashboard (v2: formatted price + VNĐ + larger titles)
--%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Product" %>
<%@ page import="model.TopProduct" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/include/header.jsp" %>

<style>
    html, body {
        margin: 0;
        padding: 0;
        background: #f5f7fb;
        overflow-x: hidden;
    }
    /* Layout */
    .page-wrap {
        padding: 10px; /* tăng khoảng cách 2 bên tổng thể */
        background: #f5f7fb;
    }
    .main-container {
        display: flex;
        gap: 10px; /* rộng ra 1 chút */
        align-items: flex-start;
        width: 100%;
        max-width: 1500px; /* giới hạn chiều ngang để nội dung bự nhưng trung tâm */
        margin: 0 auto; /* căn giữa */
        overflow: hidden
    }
    /* Sidebar */
    .sidebar {
        width: 300px; /* to hơn */
        min-width: 220px;
        max-width: 320px;
        background: #fff;
        padding: 22px;
        box-shadow: 2px 0 8px rgba(0,0,0,0.03);
        border-radius: 8px;
        flex-shrink: 0;
        position: relative;
    }
    /* Profile card */
    .profile-card {
        text-align: center;
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
        font-size: 13px;
        color: #6c757d;
        margin-top: 4px;
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
</style>
<!-- MAIN PAGE CONTENT -->
<div class="page-wrap">
    <div class="main-container" role="main">
        <!-- SIDEBAR -->
        <aside class="sidebar" aria-label="Admin sidebar">
            <div class="profile-card">
                <img class="profile-avatar"
                     src="${pageContext.request.contextPath}/assert/image/trikhue.jpg"
                     alt="avatar"
                     onerror="this.src='${pageContext.request.contextPath}/assert/image/watch1.jpg'"/>
                <c:choose>
                    <c:when test="${not empty sessionScope.staff}">
                        <div class="profile-name">${sessionScope.staff.userName}</div>
                        <div class="profile-role">${sessionScope.staff.role}</div>
                    </c:when>
                    <c:otherwise>
                        <div class="profile-name">Guest</div>
                    </c:otherwise>
                </c:choose>
            </div>
            <ul class="nav-menu">
                <li><a class="nav-link active" href="${pageContext.request.contextPath}/admin/dashboard">Product Management</a></li>
                <li><a class="nav-link" href="${pageContext.request.contextPath}/admin/orders">Order Management</a></li>
                <li><a class="nav-link" href="#">Ratings & Feedback</a></li>
                <li><a class="nav-link" href="${pageContext.request.contextPath}/admin/customerlist">Customer Management</a></li>
                <li><a class="nav-link" href="${pageContext.request.contextPath}/admin/staff">Staff Management</a></li>
            </ul>
            <button id="logoutBtn" style="margin-top:18px;padding:12px;border-radius:8px;border:none;background:#dc3545;color:#fff;cursor:pointer;width:100%;">Logout</button>
        </aside>

        <!-- CONTENT -->
        <main class="main-content" aria-label="Admin main content">
            <c:choose>
                <c:when test="${requestScope.activeTab == 'customer'}">
                    <div class="controls">
                        <div class="page-title">Customer Management</div>
                    </div>

                    <div class="table-container">
                        <table class="table" aria-describedby="customer-list">
                            <thead>
                                <tr>
                                    <th style="min-width:60px;">#</th>
                                    <th>Email</th>
                                    <th>Password</th>
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
                                                <td>${c.password}</td>
                                                <td style="text-align:center;">

                                                    <%--VIEW--%>
                                                    <a href="customerdetail?id=${c.customer_id}" class="btn btn-sm btn-info" title="View Details" style="margin: 2px 1px;">
                                                        <i class="fa fa-eye"></i> View
                                                    </a>

                                                    <%-- EDIT--%>
                                                    <%--Thêm địa chỉ để edit trong admin Customer Management --%>
                                                    <a href="?id=${c.customer_id}&action=edit" class="btn btn-sm btn-warning" title="Edit Customer" style="margin: 2px 1px;">
                                                        <i class="fa fa-edit"></i> Edit
                                                    </a>

                                                    <%--DELETE--%>
                                                    <a href="deletecustomer?id=${c.customer_id}" 
                                                       onclick="return confirm('Xóa? ${c.customer_name} (${c.email})?')"
                                                       class="btn btn-sm btn-danger" title="Delete Customer" style="margin: 2px 1px;">
                                                        <i class="fa fa-trash"></i> Delete

                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="4" style="text-align:center;padding:18px;">
                                                Éo có khách hàng nào cả ok?.
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
                                                     style="width: 180px; height: 180px; object-fit: cover; border-radius: 8px; border: 1px solid #ddd;" />
                                            </c:when>
                                            <c:otherwise>

                                                <div style="width: 180px; height: 180px; line-height: 180px; margin: 0 auto; border: 1px solid #ddd; border-radius: 8px;">
                                                    <i class="fa fa-user-circle fa-5x" style="color: #ccc;"></i>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>


                                    <h5 style="margin: 0; padding: 0;">${c.customer_name}</h5>
                                    <p class="text-muted">Customer #${c.customer_id}</p>
                                </div>
                                <div class="col-md-8 detail-info">
                                    <h4 class="mb-4" style="border-bottom: 1px solid #eee; padding-bottom: 10px;">General Information</h4>
                                    <div class="row">
                                        <div class="col-sm-6">
                                            <p><strong>Full Name:</strong> ${c.customer_name}</p>
                                            <p><strong>Email:</strong> ${c.email}</p>
                                            <p><strong>Phone:</strong> ${c.phone}</p>
                                            <p><strong>Date of Birth:</strong> ${c.dob}</p>
                                        </div>
                                        <div class="col-sm-6">
                                            <p><strong>Address:</strong> ${c.address}</p>
                                            <p><strong>Gender:</strong> ${c.gender}</p>
                                            <p><strong>Status:</strong> ${c.account_status}</p>
                                        </div>
                                    </div>
                                    <div style="margin-top: 30px; border-top: 1px solid #eee; padding-top: 20px;">
                                        <a href="customerprofile?id=${c.customer_id}&action=edit" class="btn btn-primary" style="margin-right: 10px;">
                                            <i class="fa fa-edit"></i> Edit
                                        </a>
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
                            Éo có thằng nào cả! 
                        </div>
                    </c:if>
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
                                        out.print(String.format("%,d", totalRevenue) + " VNĐ");
                                    } else {
                                        out.print("0 VNĐ");
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
                        <form action="${pageContext.request.contextPath}/admin/dashboard" method="GET" class="d-flex flex-grow-1 me-2">
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
                                    <th>Price(VNĐ)</th>
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

<jsp:include page="/WEB-INF/include/footer.jsp" />
