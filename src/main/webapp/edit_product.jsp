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
        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
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
                        <input type="text" name="product_name" class="form-control" value="${product.productName}">
                        <c:if test="${not empty errors.productNameError}">
                            <div class="text-danger small mt-1">${errors.productNameError}</div>
                        </c:if>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Price</label>
                        <input type="number" name="price" class="form-control" value="${product.price}">
                        <c:if test="${not empty errors.priceError}">
                            <div class="text-danger small mt-1">${errors.priceError}</div>
                        </c:if>
                    </div>
                </div>

                <div class="row mb-3">
                    <div class="col-md-4">
                        <label class="form-label">Brand</label>
                        <input type="text" name="brand" class="form-control" value="${product.brand}">
                        <c:if test="${not empty errors.brandError}">
                            <div class="text-danger small mt-1">${errors.brandError}</div>
                        </c:if>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Origin</label>
                        <input type="text" name="origin" class="form-control" value="${product.origin}">
                        <c:if test="${not empty errors.originError}">
                            <div class="text-danger small mt-1">${errors.originError}</div>
                        </c:if>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Category ID</label>
                        <input type="number" name="category_id" class="form-control" value="${product.categoryId}">
                        <c:if test="${not empty errors.categoryError}">
                            <div class="text-danger small mt-1">${errors.categoryError}</div>
                        </c:if>
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
                        <label class="form-label">Import Inventory ID</label>
                        <input type="number" name="import_inventory_id" class="form-control" value="${product.importInvetoryId}">
                        <c:if test="${not empty errors.importInvetoryError}">
                            <div class="text-danger small mt-1">${errors.importInvetoryError}</div>
                        </c:if>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Quantity</label>
                        <input type="number" name="quantity_product" class="form-control" value="${product.quantityProduct}">
                        <c:if test="${not empty errors.quantityError}">
                            <div class="text-danger small mt-1">${errors.quantityError}</div>
                        </c:if>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label">Image (filename or URL)</label>
                    <input type="text" name="image" class="form-control" value="${product.image}">
                    <c:if test="${not empty errors.imageError}">
                        <div class="text-danger small mt-1">${errors.imageError}</div>
                    </c:if>
                </div>

                <div class="mb-3">
                    <label class="form-label">Description</label>
                    <textarea name="description" class="form-control" rows="3">${product.description}</textarea>
                    <c:if test="${not empty errors.descriptionError}">
                        <div class="text-danger small mt-1">${errors.descriptionError}</div>
                    </c:if>
                </div>

                <div class="row mb-3">
                    <div class="col-md-4">
                        <label class="form-label">Warranty</label>
                        <input type="text" name="warranty" class="form-control" value="${product.warranty}">
                        <c:if test="${not empty errors.warrantyError}">
                            <div class="text-danger small mt-1">${errors.warrantyError}</div>
                        </c:if>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Machine</label>
                        <input type="text" name="machine" class="form-control" value="${product.machine}">
                        <c:if test="${not empty errors.machineError}">
                            <div class="text-danger small mt-1">${errors.machineError}</div>
                        </c:if>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Glass</label>
                        <input type="text" name="glass" class="form-control" value="${product.glass}">
                        <c:if test="${not empty errors.glassError}">
                            <div class="text-danger small mt-1">${errors.glassError}</div>
                        </c:if>
                    </div>
                </div>

                <div class="row mb-3">
                    <div class="col-md-4">
                        <label class="form-label">Dial Diameter</label>
                        <input type="text" name="dial_diameter" class="form-control" value="${product.dialDiameter}">
                        <c:if test="${not empty errors.dialDiameterError}">
                            <div class="text-danger small mt-1">${errors.dialDiameterError}</div>
                        </c:if>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Bezel</label>
                        <input type="text" name="bezel" class="form-control" value="${product.bezel}">
                        <c:if test="${not empty errors.bezelError}">
                            <div class="text-danger small mt-1">${errors.bezelError}</div>
                        </c:if>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Strap</label>
                        <input type="text" name="strap" class="form-control" value="${product.strap}">
                        <c:if test="${not empty errors.strapError}">
                            <div class="text-danger small mt-1">${errors.strapError}</div>
                        </c:if>
                    </div>
                </div>

                <div class="row mb-3">
                    <div class="col-md-6">
                        <label class="form-label">Dial Color</label>
                        <input type="text" name="dial_color" class="form-control" value="${product.dialColor}">
                        <c:if test="${not empty errors.dialColorError}">
                            <div class="text-danger small mt-1">${errors.dialColorError}</div>
                        </c:if>
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