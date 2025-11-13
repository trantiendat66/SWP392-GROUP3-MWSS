<%-- 
    Document   : import_list
    Created on : Nov 13, 2025, 3:06:04 AM
    Author     : hau
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <title>Import Inventory List</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    </head>
    <body class="p-4">
        <h2 class="mb-4">Import Inventory Records</h2>

       <table class="table table-striped">
    <thead>
        <tr>
            <th>ImportID</th>
            <th>Total import price</th>
            <th>Total quantity</th>
            <th>Supplier</th>
            <th>Import Date</th>
            <th>Created At</th>
            <th>Status</th>
        </tr>
    </thead>
    <tbody>
        <c:forEach var="i" items="${importList}">
            <tr>
                <td>${i.importInvetoryId}</td>
                <td>${i.totalImportPrice}</td>
                <td>${i.totalImportQuantity}</td>
                <td>${i.supplier}</td>
                <td>${i.importDate}</td>
                <td>${i.importAt}</td>
                <td>
                    <c:choose>
                            <c:when test="${i.importStatus}">Imported</c:when>
                        <c:otherwise>Not import</c:otherwise>
                    </c:choose>
                </td>
            </tr>
        </c:forEach>
    </tbody>
</table>

        <a href="addimportinventory" class="btn btn-primary mt-3">Add New Import</a>
    </body>
</html>
