<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
        width: 100%;
        min-height: calc(100vh - 60px);
    }
    .sidebar {
        width: 280px;
        background: #fff;
        padding: 22px;
        box-shadow: 2px 0 8px rgba(0,0,0,0.03);
        border-radius: 0;
        display: flex;
        flex-direction: column;
        gap: 10px;
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
        border: 2px solid #e9ecef;
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
        color: #fff;
        border-color: #dc3545;
    }
    .main-content {
        background: white;
        margin: 10px;
        border-radius: 8px;
        flex: 1;
        padding: 24px;
        box-shadow: 0 2px 14px rgba(0,0,0,0.04);
    }
    .table-container {
        max-height: 320px;
        overflow-y: auto;
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
            <h2 class="mb-4 text-center">Edit Import Inventory #${inventory.importInvetoryId}</h2>

            <c:if test="${not empty sessionScope.error}">
                <div class="alert alert-danger">
                    ${sessionScope.error}
                </div>
                <c:remove var="error" scope="session"/>
            </c:if>

            <form action="editimportinventory" method="post">
                <input type="hidden" name="inventoryId" value="${inventory.importInvetoryId}"/>
                <div class="mb-4">
                    <!-- Viết tạm chờ thêm database -->
                    <label class="form-label fw-bold">Supplier:</label>
                    <select name="supplier" class="form-control" required>
                        <option value="" disabled>-- Select Supplier --</option>
                        <c:set var="currentSupplier" value="${inventory.supplier}"/>
                        <c:set var="suppliers" value="${fn:split('DWatch Authentic,Đăng Quang Watch,Boss Luxury,Galle Watch,PNJ Watch4', ',')}"/>
                        <c:forEach var="supplierItem" items="${suppliers}">
                            <option value="${supplierItem}" <c:if test="${supplierItem == currentSupplier}">selected</c:if>>${supplierItem}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="table-container mb-3">
                    <table class="table table-striped table-bordered" id="importTable">
                        <thead>
                            <tr>
                                <th>Product</th>
                                <th>Import Price</th>
                                <th>Quantity</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty details}">
                                    <c:forEach var="detail" items="${details}">
                                        <tr>
                                            <td>
                                                <select name="productId" class="form-select" required>
                                                    <option value="" disabled>--Select--</option>
                                                    <c:forEach var="p" items="${products}">
                                                        <option value="${p.productId}" <c:if test="${p.productId == detail.productId}">selected</c:if>>${p.productName}</option>
                                                    </c:forEach>
                                                </select>
                                            </td>
                                            <td><input type="number" name="importPrice" class="form-control" min="0" value="${detail.importProductPrice}" required></td>
                                            <td><input type="number" name="importQuantity" class="form-control" min="1" value="${detail.importQuantity}" required></td>
                                            <td><button type="button" class="btn btn-danger btn-sm" onclick="removeRow(this)">Remove</button></td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td>
                                            <select name="productId" class="form-select" required>
                                                <option value="" disabled selected>--Select--</option>
                                                <c:forEach var="p" items="${products}">
                                                    <option value="${p.productId}">${p.productName}</option>
                                                </c:forEach>
                                            </select>
                                        </td>
                                        <td><input type="number" name="importPrice" class="form-control" min="0" required></td>
                                        <td><input type="number" name="importQuantity" class="form-control" min="1" required></td>
                                        <td><button type="button" class="btn btn-danger btn-sm" onclick="removeRow(this)">Remove</button></td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>

                <div class="mb-4 text-end">
                    <button type="button" class="btn btn-success" onclick="addRow()">Add Product</button>
                </div>

                <div class="mb-4">
                    <label class="form-label fw-bold">Import Date:</label>
                    <input type="date" id="importDate" name="importDate" class="form-control" value="${inventory.importDate}" required>
                    <small class="text-muted">Import date must be today or in the future</small>
                </div>

                <div class="text-end">
                    <button type="submit" class="btn btn-primary">Update Import</button>
                    <a href="listimportinventory" class="btn btn-secondary">Cancel</a>
                </div>
            </form>
        </main>
    </div>
</div>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        function updateProductOptions() {
            const selects = document.querySelectorAll('select[name="productId"]');
            const selectedValues = Array.from(selects).map(s => s.value).filter(v => v);
            selects.forEach(select => {
                const currentValue = select.value;
                Array.from(select.options).forEach(option => {
                    if (!option.value) {
                        return;
                    }
                    option.disabled = selectedValues.includes(option.value) && option.value !== currentValue;
                });
            });
        }

        window.addRow = function () {
            const tableBody = document.getElementById('importTable').querySelector('tbody');
            const templateRow = tableBody.rows[0].cloneNode(true);
            templateRow.querySelectorAll('input').forEach(input => input.value = '');
            templateRow.querySelectorAll('select').forEach(select => {
                select.selectedIndex = 0;
                select.addEventListener('change', updateProductOptions);
            });
            tableBody.appendChild(templateRow);
            updateProductOptions();
        };

        window.removeRow = function (btn) {
            const tableBody = document.getElementById('importTable').querySelector('tbody');
            if (tableBody.rows.length > 1) {
                btn.closest('tr').remove();
                updateProductOptions();
            }
        };

        document.querySelectorAll('select[name="productId"]').forEach(select => {
            select.addEventListener('change', updateProductOptions);
        });
        updateProductOptions();

        const importDateInput = document.getElementById('importDate');
        if (importDateInput) {
            const today = new Date().toISOString().split('T')[0];
            importDateInput.setAttribute('min', today);
        }
    });
</script>
<jsp:include page="/WEB-INF/include/footer.jsp" />

