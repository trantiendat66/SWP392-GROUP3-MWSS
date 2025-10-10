<%-- 
    Document   : product-view
    Created on : Oct 10, 2025, 10:54:41 AM
    Author     : Tran Tien Dat - CE190362
--%>

<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@ include file="/WEB-INF/include/header.jsp" %>

<c:choose>
    <c:when test="${empty product}">
        <div class="alert alert-warning">Sản phẩm không tồn tại.</div>
    </c:when>
    <c:otherwise>
        <div class="row">
            <div class="col-md-5">
                <c:choose>
                    <c:when test="${not empty product.image}">
                        <img src="${pageContext.request.contextPath}/${product.image}" alt="${product.product_name}" class="img-fluid rounded">
                    </c:when>
                    <c:otherwise>
                        <img src="${pageContext.request.contextPath}/assert/image/no-image.png" alt="no-image" class="img-fluid rounded">
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="col-md-7">
                <h2>${product.product_name}</h2>
                <p class="text-muted">Thương hiệu: ${product.brand} — Xuất xứ: ${product.origin}</p>
                <p class="fw-bold text-danger fs-4">${product.price} VNĐ</p>

                <form action="${pageContext.request.contextPath}/cart/add" method="post" class="d-flex align-items-center mb-3">
                    <input type="hidden" name="pid" value="${product.product_id}">
                    <input type="number" name="quantity" value="1" min="1" class="form-control me-2" style="width:100px;">
                    <button type="submit" class="btn btn-success">Thêm vào giỏ</button>
                </form>

                <hr>
                <h5>Mô tả</h5>
                <p><c:out value="${product.description}" /></p>

                <h5>Thông số</h5>
                <ul>
                    <li><strong>Bảo hành:</strong> ${product.warranty}</li>
                    <li><strong>Máy:</strong> ${product.machine}</li>
                    <li><strong>Kính:</strong> ${product.glass}</li>
                    <li><strong>Đường kính mặt:</strong> ${product.dial_diameter}</li>
                    <li><strong>Vành:</strong> ${product.bezel}</li>
                    <li><strong>Dây:</strong> ${product.strap}</li>
                    <li><strong>Màu mặt:</strong> ${product.dial_color}</li>
                    <li><strong>Chức năng:</strong> ${product.function}</li>
                    <li><strong>Số lượng tồn:</strong> ${product.quantity_product}</li>
                </ul>

            </div>
        </div>
    </c:otherwise>
</c:choose>

<jsp:include page="/WEB-INF/include/footer.jsp" />

