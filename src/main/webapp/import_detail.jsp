<%-- 
    Document   : import_detail.jsp
    Created on : Nov 13, 2025, 9:52:57 PM
    Author     : Cola
--%>


<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Import Inventory Detail</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    </head>
    <body class="p-4">
        <h2 class="mb-4">Import Inventory Detail</h2>

        <c:set var="inv" value="${inventory}" />

        <div class="mb-3">
            <p><strong>Import ID:</strong> ${inv.importInvetoryId}</p>
            <p><strong>Supplier:</strong> ${inv.supplier}</p>
            <p><strong>Import Date:</strong> ${inv.importDate}</p>
            <p><strong>Created At:</strong> ${inv.importAt}</p>
            <p><strong>Total Quantity:</strong> ${inv.totalImportQuantity}</p>
            <p><strong>Total Import Price:</strong> ${inv.totalImportPrice}</p>
            <div class="d-flex align-items-center gap-3 mb-4">

                <label class="form-label mb-0"><strong>Status:</strong></label>

                <c:choose>
                    <c:when test="${!inv.importStatus}">
                        <form action="updateimportstatus" method="post" class="d-flex align-items-center gap-2">
                            <input type="hidden" name="id" value="${inv.importInvetoryId}">

                            <select name="status" class="form-select" style="width: fit-content; min-width: max-content;">
                                <option value="0" selected>Not import</option>
                                <option value="1">Imported successfully</option>
                            </select>

                            <button type="submit" class="btn btn-success">Save</button>
                        </form>
                    </c:when>
                    <c:otherwise>
                        <select class="form-select" style="width: fit-content; min-width: max-content;" disabled>
                            <option value="1" selected>Imported successfully</option>
                        </select>
                    </c:otherwise>

                </c:choose>

            </div>

        </div>

        <h4>Imported Products</h4>
        <table class="table table-striped">
            <thead>
                <tr>
                    <th>#</th>
                    <th>Product</th>
                    <th>Import Price</th>
                    <th>Quantity</th>
                    <th>Subtotal</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="p" items="${products}" varStatus="st">
                    <tr>
                        <td>${st.index + 1}</td>
                        <td>${p.productName}</td>
                        <td>${p.importProductPrice}</td>
                        <td>${p.importQuantity}</td>
                        <td>${p.importProductPrice * p.importQuantity}</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <a href="listimportinventory" class="btn btn-secondary mt-3">Back to list</a>
    </body>
</html>
