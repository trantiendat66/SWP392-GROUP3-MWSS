<%-- 
    Document   : import_form
    Created on : Nov 13, 2025, 2:31:14 AM
    Author     : hau
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Add Import Inventory</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    </head>
    <body class="p-4">
        <h2 class="mb-4">Add Import Inventory</h2>

        <form action="addimportinventory" method="post">
            <div class="mb-3">
                <label class="form-label">Supplier:</label>
                <input type="text" name="supplier" class="form-control" required>
            </div>
            <table class="table" id="importTable">
                <thead>
                    <tr>
                        <th style="width: 40%;">Product</th>
                        <th style="width: 25%;">Import Price</th>
                        <th style="width: 25%;">Quantity</th>
                        <th style="width: 5%;">Action</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>
                            <select name="productId" class="form-select" required>
                                <c:forEach var="p" items="${products}">
                                    <option value="${p.productId}">${p.productName}</option>
                                </c:forEach>
                            </select>
                        </td>
                        <td><input type="number" name="importPrice" class="form-control" required></td>
                        <td><input type="number" name="importQuantity" class="form-control" required></td>
                        <td><button type="button" onclick="removeRow(this)">Remove</button></td>
                    </tr>
                </tbody>
            </table>
            <button type="button" onclick="addRow()">Add Product</button>
            <br/><br/>
            <label>Import Date:</label>
            <input type="date" name="importDate" required>
            <button type="submit">Submit Import</button>
        </form>

        <script>
            function addRow() {
                const tableBody = document.getElementById('importTable').getElementsByTagName('tbody')[0];
                const firstRow = tableBody.rows[0];

                // clone row
                const newRow = firstRow.cloneNode(true);

                // reset tất cả input
                newRow.querySelectorAll('input').forEach(input => input.value = '');

                // reset select về giá trị mặc định (option đầu tiên)
                newRow.querySelectorAll('select').forEach(select => select.selectedIndex = 0);

                tableBody.appendChild(newRow);
            }
            function removeRow(btn) {
                const row = btn.parentNode.parentNode;
                const table = document.getElementById('importTable').getElementsByTagName('tbody')[0];
                if (table.rows.length > 1)
                    row.remove();
            }
        </script>
