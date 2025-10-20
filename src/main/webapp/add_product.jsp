<%-- 
    Document   : add_product
    Created on : Oct 20, 2025, 9:37:18 AM
    Author     : Tran Tien Dat - CE190362
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Add New Product</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body>

        <jsp:include page="/WEB-INF/include/header.jsp" />

        <div class="container mt-5 mb-5">
            <h2 class="text-center mb-4">Add New Product</h2>

            <form action="${pageContext.request.contextPath}/addproduct" 
                  method="post"
                  class="card p-4 shadow-lg">

                <div class="row mb-3">
                    <div class="col-md-6">
                        <label class="form-label fw-bold">Product Name</label>
                        <input type="text" name="product_name" class="form-control" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-bold">Price (VND)</label>
                        <input type="number" name="price" class="form-control" required>
                    </div>
                </div>

                <div class="row mb-3">
                    <div class="col-md-6">
                        <label class="form-label fw-bold">Brand</label>
                        <input type="text" name="brand" class="form-control">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-bold">Origin</label>
                        <input type="text" name="origin" class="form-control">
                    </div>
                </div>

                <div class="row mb-3">
                    <div class="col-md-6">
                        <label class="form-label fw-bold">Category ID</label>
                        <input type="number" name="category_id" class="form-control" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-bold">Account ID (Admin)</label>
                        <input type="number" name="account_id" class="form-control" value="1">
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label fw-bold">Gender</label>
                    <select name="gender" class="form-select">
                        <option value="true">Male</option>
                        <option value="false">Female</option>
                    </select>
                </div>

                <div class="row mb-3">
                    <div class="col-md-8">
                        <label class="form-label fw-bold">Image (filename or URL)</label>
                        <input type="text" name="image" class="form-control" placeholder="e.g. product1.jpg">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label fw-bold">Quantity</label>
                        <input type="number" name="quantity_product" class="form-control" required>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label fw-bold">Warranty</label>
                    <input type="text" name="warranty" class="form-control" placeholder="e.g. 2 years">
                </div>

                <div class="row mb-3">
                    <div class="col-md-4">
                        <label class="form-label fw-bold">Machine</label>
                        <input type="text" name="machine" class="form-control">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label fw-bold">Glass</label>
                        <input type="text" name="glass" class="form-control">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label fw-bold">Dial Diameter</label>
                        <input type="text" name="dial_diameter" class="form-control">
                    </div>
                </div>

                <div class="row mb-3">
                    <div class="col-md-4">
                        <label class="form-label fw-bold">Bezel</label>
                        <input type="text" name="bezel" class="form-control">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label fw-bold">Strap</label>
                        <input type="text" name="strap" class="form-control">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label fw-bold">Dial Color</label>
                        <input type="text" name="dial_color" class="form-control">
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label fw-bold">Function</label>
                    <input type="text" name="function" class="form-control">
                </div>

                <div class="mb-3">
                    <label class="form-label fw-bold">Description</label>
                    <textarea name="description" class="form-control" rows="3"></textarea>
                </div>

                <div class="text-center">
                    <button type="submit" class="btn btn-success px-5">Add Product</button>
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-secondary px-4">Cancel</a>
                </div>
            </form>
        </div>

        <jsp:include page="/WEB-INF/include/footer.jsp" />

    </body>
</html>