<%-- 
    Document   : edit_staff_profile
    Created on : Nov 10, 2025, 8:43:17 PM
    Author     : hau
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Add Import Inventory</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
        <style>
            body {
                background-color: #f8f9fa;
            }
            .form-container {
                max-width: 900px;
                margin: 30px auto;
                padding: 25px;
                background: white;
                border-radius: 12px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.1);
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
                                <td><input type="number" name="importPrice" class="form-control" min="1" required></td>
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
                    <input type="date" name="importDate" class="form-control" required>
                </div>


                <div class="text-end">
                    <button type="submit" class="btn btn-primary btn-submit">Submit Import</button>
                    <a href="listimportinventory" class="btn btn-secondary">Cancel</a>
                </div>
            </form>
        </div>

        <script>
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

            function addRow() {
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
            }

            function removeRow(btn) {
                const row = btn.closest('tr');
                const tableBody = document.getElementById('importTable').getElementsByTagName('tbody')[0];
                if (tableBody.rows.length > 1) {
                    row.remove();
                    // ⚡ Gọi lại để cập nhật danh sách disable
                    updateProductOptions();
                }
            }

            // Gắn sự kiện ban đầu cho select có sẵn khi trang load
            document.querySelectorAll('select[name="productId"]').forEach(select => {
                select.addEventListener('change', updateProductOptions);
            });
        </script>
    </body>
</html>
