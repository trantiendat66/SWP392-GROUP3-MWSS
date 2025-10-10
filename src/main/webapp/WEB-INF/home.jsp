<%-- 
    Document   : home
    Created on : Oct 10, 2025, 10:54:09 AM
    Author     : Tran Tien Dat - CE190362
--%>

<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@ include file="/WEB-INF/include/header.jsp" %>

<div class="row">
    <c:if test="${empty productList}">
        <div class="col-12">
            <p>Không có sản phẩm.</p>
        </div>
    </c:if>

    <c:forEach var="p" items="${productList}">
        <div class="col-lg-3 col-md-4 col-sm-6 mb-4">
            <div class="card h-100">
                <c:choose>
                    <c:when test="${not empty p.image}">
                        <img src="${pageContext.request.contextPath}/${p.image}" class="card-img-top" alt="${p.product_name}" style="height:200px; object-fit:cover;">
                    </c:when>
                    <c:otherwise>
                        <img src="${pageContext.request.contextPath}/assert/image/no-image.png" class="card-img-top" alt="no-image" style="height:200px; object-fit:cover;">
                    </c:otherwise>
                </c:choose>
                <div class="card-body d-flex flex-column">
                    <h6 class="card-title">${p.product_name}</h6>
                    <p class="mb-1 text-muted">${p.brand}</p>
                    <p class="fw-bold text-danger">${p.price} VNĐ</p>
                    <div class="mt-auto">
                        <a href="${pageContext.request.contextPath}/product-detail?pid=${p.product_id}" class="btn btn-sm btn-primary">Xem chi tiết</a>
                    </div>
                </div>
            </div>
        </div>
    </c:forEach>
</div>

<jsp:include page="/WEB-INF/include/footer.jsp" />

