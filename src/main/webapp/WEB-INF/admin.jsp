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
    .page-wrap {
        padding: 10px;
        background: #f5f7fb;
    }
    .main-container {
        display: flex;
        gap: 10px;
        align-items: flex-start;
        max-width: 1500px;
        margin: 0 auto;
    }
    .sidebar {
        width: 300px;
        min-width: 220px;
        max-width: 320px;
        background: #fff;
        padding: 22px;
        box-shadow: 2px 0 8px rgba(0,0,0,0.04);
        border-radius: 8px;
        flex-shrink: 0;
        position: relative;
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
        flex: 1 1 auto;
        padding: 24px;
        border-radius: 10px;
        box-shadow: 0 2px 14px rgba(0,0,0,0.04);
        min-width: 0;
    }
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
    .stats-grid {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 14px;
        margin-bottom: 18px;
    }
    .stat-card {
        padding: 16px;
        border-radius: 8px;
        background: #fff;
        box-shadow: 0 1px 6px rgba(0,0,0,0.03);
    }
    .table-container {
        overflow-x: auto;
    }
    .table {
        width: 100%;
        border-collapse: collapse;
        min-width: 800px;
    }
    .table th, .table td {
        padding: 14px 14px;
        border-bottom: 1px solid #eee;
        font-size: 15px;
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
    .product-image {
        width: 72px;
        height: 72px;
        object-fit: cover;
        border-radius: 8px;
        border: 1px solid #ddd;
        display: block;
    }
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
    .edit-btn { background: #007bff; color: #fff; }
    .delete-btn { background: #dc3545; color: #fff; }
    .view-btn { background: #17a2b8; color: #fff; }
    .table td.actions-cell {
        white-space: nowrap;
        text-align: center;
        width: 200px;
    }
    @media (max-width: 900px) {
        .main-container { flex-direction: column; }
        .sidebar { width: 100%; max-width: none; display: block; }
        .main-content { margin-top: 12px; }
        .table { min-width: 100%; }
    }
</style>

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
                <li><a class="nav-link" href="#">Customer Management</a></li>
                <li><a class="nav-link" href="${pageContext.request.contextPath}/admin/staff">Staff Management</a></li>
            </ul>
            <button id="logoutBtn" style="margin-top:18px;padding:12px;border-radius:8px;border:none;background:#dc3545;color:#fff;cursor:pointer;width:100%;">Logout</button>
        </aside>

        <!-- CONTENT -->
        <main class="main-content" aria-label="Admin main content">
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

            <div style="text-align: right;">
                <button class="add-product-btn" id="addProductBtn">Add New Product</button>
            </div>

            <%
                String successMessage = (String) session.getAttribute("successMessage");
                String errorMessage = (String) session.getAttribute("errorMessage");
                if (successMessage != null) {
            %>
            <div style="color:#155724;background:#d4edda;border:1px solid #c3e6cb;padding:8px 12px;border-radius:6px;margin-bottom:12px;font-weight:600;">
                <%= successMessage%>
            </div>
            <%
                session.removeAttribute("successMessage");
            } else if (errorMessage != null) {
            %>
            <div style="color:#721c24;background:#f8d7da;border:1px solid #f5c6cb;padding:8px 12px;border-radius:6px;margin-bottom:12px;font-weight:600;">
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
                            <th></th>
                            <th>Product ID</th>
                            <th>Product Name</th>
                            <th>Brand</th>
                            <th>Category</th>
                            <th>Price (VNĐ)</th>
                            <th>Stock</th>
                            <th style="text-align:center">Actions</th>
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
                                     src="${pageContext.request.contextPath}/assert/image/<%= p.getImage() %>"
                                     alt="<%= p.getProductName()%>"
                                     onerror="this.src='${pageContext.request.contextPath}/assert/image/watch1.jpg'"/>
                            </td>
                            <td class="product-id"><%= p.getProductId()%></td>
                            <td class="product-name"><%= p.getProductName()%></td>
                            <td class="product-brand"><%= p.getBrand()%></td>
                            <td><%= p.isGender() ? "Men" : "Women"%></td>
                            <td class="product-price"><%= String.format(java.util.Locale.US, "%,d", p.getPrice())%> </td>  <%-- Nếu để muốn sử dụng dấu , thay vì dấu . thì phải sử dụng locale mỹ --%>
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
                        <% } %>
                    </tbody>
                </table>
            </div>
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
                if (!id) { alert('Missing product id'); return; }
                window.location.href = '${pageContext.request.contextPath}/viewproductdetail?id=' + encodeURIComponent(id);
            });
        });

        document.querySelectorAll('.edit-btn').forEach(btn => {
            btn.addEventListener('click', e => {
                const id = btn.getAttribute('data-id') || '';
                if (!id) { alert('Missing product id'); return; }
                window.location.href = '${pageContext.request.contextPath}/editproduct?id=' + encodeURIComponent(id);
            });
        });

        document.querySelectorAll('.delete-btn').forEach(btn => {
            btn.addEventListener('click', e => {
                const id = btn.getAttribute('data-id') || '';
                if (!id) { alert('Missing product id'); return; }
                if (!confirm('Delete product: ' + id + '?')) return;

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
