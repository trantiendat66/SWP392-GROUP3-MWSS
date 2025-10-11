<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/WEB-INF/include/header.jsp" %>

<c:choose>
    <c:when test="${empty product}">
        <div class="container"><div class="alert alert-warning">Sản phẩm không tồn tại.</div></div>
    </c:when>
    <c:otherwise>
        <div class="container product-details py-4">
            <div class="row">
                <div class="col-md-6">
                    <c:choose>
                        <c:when test="${not empty product.video}">
                            <video controls class="w-100 mb-3" poster="${pageContext.request.contextPath}/assert/image/${product.image}">
                                <source src="${pageContext.request.contextPath}/assert/video/${product.video}" type="video/mp4">
                                Your browser does not support the video tag.
                            </video>
                        </c:when>
                        <c:otherwise>
                            <img src="${pageContext.request.contextPath}/assert/image/${product.image}" class="img-fluid rounded mb-3" alt="${product.productName}">
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="col-md-6">
                    <h2>${product.productName}</h2>
                    <p class="text-muted">Thương hiệu: ${product.brand} — Xuất xứ: ${product.origin}</p>
                    <h3 class="text-danger">${product.price} VNĐ</h3>

                    <form action="${pageContext.request.contextPath}/cart/add" method="post" class="d-flex align-items-center mb-3">
                        <input type="hidden" name="pid" value="${product.productId}">
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
                        <li><strong>Đường kính:</strong> ${product.dialDiameter}</li>
                        <li><strong>Dây:</strong> ${product.strap}</li>
                        <li><strong>Màu mặt:</strong> ${product.dialColor}</li>
                    </ul>
                </div>
            </div>
        </div>
    </c:otherwise>
</c:choose>

<jsp:include page="/WEB-INF/include/footer.jsp" />
