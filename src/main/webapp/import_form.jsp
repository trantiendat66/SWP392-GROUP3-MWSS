<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/include/header.jsp" %>

<style>
            html, body { margin: 0; padding: 0; background: #f5f7fb; overflow-x: hidden; height: 100%; }
            .page-wrap { padding: 0; background: #f5f7fb; min-height: calc(100vh - 60px); }
            .main-container { display: flex; gap: 0; align-items: stretch; width: 100%; min-height: calc(100vh - 60px); overflow: hidden; }
            .sidebar { width: 280px; min-width: 280px; background: #fff; padding: 22px; box-shadow: 2px 0 8px rgba(0,0,0,0.03); border-radius: 0; flex-shrink: 0; position: relative; display: flex; flex-direction: column; }
            .profile-card { text-align: center; margin-bottom: 18px; }
            .profile-avatar { width: 72px; height: 72px; border-radius: 50%; object-fit: cover; display: inline-block; border: 2px solid #e9ecef; background: #f0f0f0; }
            .profile-role { display: block; background-color: #000; color: #fff; font-size: 18px; font-weight: 700; padding: 8px 16px; border-radius: 6px; margin-top: 10px; width: fit-content; margin-left: auto; margin-right: auto; }
            .nav-menu { list-style: none; padding: 0; margin: 12px 0 0 0; }
            .nav-menu li { margin-bottom: 10px; }
            .nav-link { display: block; padding: 10px 14px; border-radius: 8px; color: #333; text-decoration: none; font-weight: 600; }
            .nav-link.active, .nav-link:hover { background: #dc3545; color: white; }
            .main-content { background: white; margin: 10px; border-radius: 8px; flex: 1 1 auto; padding: 24px; box-shadow: 0 2px 14px rgba(0,0,0,0.04); min-width: 0; overflow-x: auto; }
            .form-container {
                max-width: 100%;
                margin: 0;
                padding: 0;
                background: transparent;
                border-radius: 0;
                box-shadow: none;
            }
            #importTable thead {
                position: sticky;
                top: 0;
                background: #343a40;
                color: white;
                z-index: 1;
            }
            #importTable tbody tr td {
                vertical-align: middle;
            }
            .btn-add, .btn-submit {
                min-width: 120px;
            }
            .table-container {
                max-height: 300px;
                overflow-y: auto;
            }
        </style>
    </head>
    <body>
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
                    </ul>
                </aside>
                <main class="main-content">
                    <div class="form-container">

            <h2 class="mb-4 text-center">Add Import Inventory</h2>

            <form action="addimportinventory" method="post">
                <!-- Supplier -->
                <div class="mb-4">
                    <label class="form-label fw-bold">Supplier:</label>
                    <input type="text" name="supplier" class="form-control" placeholder="Enter supplier name" required>
                </div>

                <!-- Table sản phẩm -->
                <div class="table-container mb-3">
                    <table class="table table-striped table-bordered" id="importTable">
                        <thead>
                            <tr>
                                <th style="width: 40%;">Product</th>
                                <th style="width: 25%;">Import Price</th>
                                <th style="width: 25%;">Quantity</th>
                                <th style="width: 10%;">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>
                                    <select name="productId" class="form-select" required>
                                        <option value="" selected disabled>--Select--</option>
                                        <c:forEach var="p" items="${products}">
                                            <option value="${p.productId}">${p.productName}</option>
                                        </c:forEach>
                                    </select>
                                </td>
                                <td><input type="number" name="importPrice" class="form-control" min="0" required></td>
                                <td><input type="number" name="importQuantity" class="form-control" min="1" required></td>
                                <td>
                                    <button type="button" class="btn btn-danger btn-sm" onclick="removeRow(this)">Remove</button>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <!-- Nút Add Product -->
                <div class="mb-4 text-end">
                    <button type="button" class="btn btn-success btn-add" onclick="addRow()">Add Product</button>
                </div>

                <!-- Import Date -->
                <div class="mb-4">
                    <label class="form-label fw-bold">Import Date:</label>
                    <input type="date" id="importDate" name="importDate" class="form-control" required>
                    <small class="text-muted">Import date must be today or in the future</small>
                </div>


                <div class="text-end">
                    <button type="submit" class="btn btn-primary btn-submit">Submit Import</button>
                    <a href="listimportinventory" class="btn btn-secondary">Cancel</a>
                </div>
            </form>
        </div>

        <script>
            document.addEventListener('DOMContentLoaded', function() {
                function updateProductOptions() {
                    const selects = document.querySelectorAll('select[name="productId"]');
                    const selectedValues = Array.from(selects)
                            .map(s => s.value)
                            .filter(v => v);

                    selects.forEach(select => {
                        const currentValue = select.value;
                        Array.from(select.options).forEach(option => {
                            if (option.value === "")
                                return; // giữ --Select--
                            // Disable nếu sản phẩm đã được chọn ở select khác
                            option.disabled = selectedValues.includes(option.value) && option.value !== currentValue;
                        });
                    });
                }

                window.addRow = function() {
                    const tableBody = document.getElementById('importTable').getElementsByTagName('tbody')[0];
                    const firstRow = tableBody.rows[0];

                    // clone hàng đầu tiên
                    const newRow = firstRow.cloneNode(true);

                    // reset input
                    newRow.querySelectorAll('input').forEach(input => input.value = '');

                    // reset select và gắn sự kiện
                    newRow.querySelectorAll('select').forEach(select => {
                        select.selectedIndex = 0;
                        select.addEventListener('change', updateProductOptions);
                    });

                    tableBody.appendChild(newRow);

                    // ⚡ Gọi lại để cập nhật danh sách disable ngay
                    updateProductOptions();
                };

                window.removeRow = function(btn) {
                    const row = btn.closest('tr');
                    const tableBody = document.getElementById('importTable').getElementsByTagName('tbody')[0];
                    if (tableBody.rows.length > 1) {
                        row.remove();
                        // ⚡ Gọi lại để cập nhật danh sách disable
                        updateProductOptions();
                    }
                };

                // Gắn sự kiện ban đầu cho select có sẵn khi trang load
                document.querySelectorAll('select[name="productId"]').forEach(select => {
                    select.addEventListener('change', updateProductOptions);
                });

                // Set min date to today
                const importDateInput = document.getElementById('importDate');
                if (importDateInput) {
                    const today = new Date().toISOString().split('T')[0];
                    importDateInput.setAttribute('min', today);
                }

                // Validate on submit
                const form = document.querySelector('form');
                if (form) {
                    form.addEventListener('submit', function(e) {
                        const dateInput = document.getElementById('importDate');
                        if (dateInput) {
                            const selectedDate = new Date(dateInput.value);
                            const today = new Date();
                            today.setHours(0, 0, 0, 0);
                            if (selectedDate < today) {
                                e.preventDefault();
                                alert('Import date cannot be in the past. Please select today or a future date.');
                                dateInput.focus();
                            }
                        }
                    });
                }
            });
        </script>
                    </div>
                </main>
            </div>
        </div>
        <jsp:include page="/WEB-INF/include/footer.jsp" />
    </body>
</html>
