<%-- 
    Document   : product-list
    Created on : Oct 13, 2025, 9:30:50 PM
    Author     : Nguyen Thien Dat - CE190879 - 06/05/2005
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

    <div class="row g-4">
        <c:choose>
            <c:when test="${not empty listP}">
                <c:forEach var="p" items="${listP}">
                    <div class="col-lg-3 col-md-4 col-sm-6">
                        <div class="card product-card h-100">
                            <c:choose>
                                <c:when test="${not empty p.image}">
                                    <img src="${pageContext.request.contextPath}/assert/image/${p.image}"
                                         class="card-img-top product-media"
                                         alt="${p.productName}" />
                                </c:when>
                                <c:otherwise>
                                    <img src="${pageContext.request.contextPath}/assert/image/no-image.png"
                                         class="card-img-top product-media"
                                         alt="no-image" />
                                </c:otherwise>
                            </c:choose>

                            <div class="card-body d-flex flex-column">
                                <h5 class="card-title text-center">${p.productName}</h5>
                                <p class="text-center text-muted mb-1">${p.brand}</p>
                                <p class="text-center fw-bold text-danger mb-3">${p.price} VNĐ</p>

                                <div class="mt-auto text-center">
                                    <a href="${pageContext.request.contextPath}/product-view?pid=${p.productId}" class="btn btn-primary btn-sm me-2">Details</a>
                                    <button class="btn btn-success btn-sm" onclick="addToCartFromHome(${p.productId})">
                                        <i class="bi bi-cart-plus"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <p class="text-center text-muted">Không tìm thấy sản phẩm phù hợp.</p>
            </c:otherwise>
        </c:choose>
    </div>
</html>
