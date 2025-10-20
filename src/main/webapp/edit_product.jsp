<%-- 
    Document   : edit_product
    Created on : Oct 20, 2025, 9:37:37 AM
    Author     : Tran Tien Dat - CE190362
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="model.Product" %>
<%
    Product product = (Product) request.getAttribute("product");
    if (product == null) {
        response.sendRedirect(request.getContextPath() + "/home");
        return;
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Edit Product</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body>
        <jsp:include page="/WEB-INF/include/header.jsp" />
        <div class="container mt-4 mb-4">
            <h2 class="mb-3">Edit Product - ${product.productName}</h2>
            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/editproduct" method="post" class="card p-4 shadow-sm">
                <input type="hidden" name="product_id" value="${product.productId}" />

                <div class="row mb-3">
                    <div class="col-md-6">
                        <label class="form-label">Product Name</label>
                        <input type="text" name="product_name" class="form-control" value="${product.productName}" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Price</label>
                        <input type="number" name="price" class="form-control" value="${product.price}" required>
                    </div>
                </div>

                <div class="row mb-3">
                    <div class="col-md-4">
                        <label class="form-label">Brand</label>
                        <input type="text" name="brand" class="form-control" value="${product.brand}">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Origin</label>
                        <input type="text" name="origin" class="form-control" value="${product.origin}">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Category ID</label>
                        <input type="number" name="category_id" class="form-control" value="${product.categoryId}">
                    </div>
                </div>

                <div class="row mb-3">
                    <div class="col-md-4">
                        <label class="form-label">Gender</label>
                        <select name="gender" class="form-select">
                            <option value="true" ${product.gender ? 'selected' : ''}>Nam</option>
                            <option value="false" ${!product.gender ? 'selected' : ''}>Nữ</option>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Account ID</label>
                        <input type="number" name="account_id" class="form-control" value="${product.accountId}">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Quantity</label>
                        <input type="number" name="quantity_product" class="form-control" value="${product.quantityProduct}" required>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label">Image (filename or URL)</label>
                    <input type="text" name="image" class="form-control" value="${product.image}">
                </div>

                <div class="mb-3">
                    <label class="form-label">Description</label>
                    <textarea name="description" class="form-control" rows="3">${product.description}</textarea>
                </div>

                <div class="row mb-3">
                    <div class="col-md-4">
                        <label class="form-label">Warranty</label>
                        <input type="text" name="warranty" class="form-control" value="${product.warranty}">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Machine</label>
                        <input type="text" name="machine" class="form-control" value="${product.machine}">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Glass</label>
                        <input type="text" name="glass" class="form-control" value="${product.glass}">
                    </div>
                </div>

                <div class="row mb-3">
                    <div class="col-md-4">
                        <label class="form-label">Dial Diameter</label>
                        <input type="text" name="dial_diameter" class="form-control" value="${product.dialDiameter}">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Bezel</label>
                        <input type="text" name="bezel" class="form-control" value="${product.bezel}">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Strap</label>
                        <input type="text" name="strap" class="form-control" value="${product.strap}">
                    </div>
                </div>

                <div class="row mb-3">
                    <div class="col-md-6">
                        <label class="form-label">Dial Color</label>
                        <input type="text" name="dial_color" class="form-control" value="${product.dialColor}">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Function</label>
                        <input type="text" name="function" class="form-control" value="${product.function}">
                    </div>
                </div>

                <div class="text-center">
                    <button type="submit" class="btn btn-primary px-4">Save changes</button>
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-secondary px-4">Cancel</a>
                </div>
            </form>
        </div>

        <jsp:include page="/WEB-INF/include/footer.jsp" />
    </body>
</html>