<%-- 
    Document   : import_list
    Created on : Nov 13, 2025, 3:06:04 AM
    Author     : hau
--%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/include/header.jsp" %>
<div class="mb-3 text-end">
    <a href="addimportinventory" class="btn btn-primary mt-3">Add New Import</a>
</div>
<div style="max-height: 500px; overflow-y: auto;">
    <c:if test="${not empty sessionScope.success}">
        <div class="alert alert-success text-center">
            ${sessionScope.success}
        </div>
        <c:remove var="success" scope="session"/>
    </c:if>
    <table class="table table-striped">
        <thead class="table-dark" style="position: sticky; top: 0; z-index: 1;">
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
                        <a href="importinventorydetail?id=${i.importInvetoryId}">
                            <c:choose>
                                <c:when test="${i.importStatus}">
                                    <span class="badge bg-success">Imported successfully</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-danger">Not import</span>
                                </c:otherwise>
                            </c:choose>
                        </a>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>
<div class="mt-3 mb-3 text-end">
    <a href="admin/dashboard" class="btn btn-secondary">Back</a>
</div>
<jsp:include page="/WEB-INF/include/footer.jsp" />
