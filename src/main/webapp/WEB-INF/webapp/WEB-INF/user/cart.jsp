<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="container">
    <h2 class="mb-4 fw-bold text-center">YOUR CART</h2>

    <c:choose>
        <c:when test="${not empty carts}">
            <!-- Nút Delete All góc phải -->
            <div class="row mb-3">
                <div class="col-12 d-flex justify-content-end">
                    <a href="javascript:void(0);" 
                       class="btn btn-danger btn-sm d-flex align-items-center gap-1 px-3 py-1 rounded"
                       onclick="showDeleteModal('${pageContext.request.contextPath}/cart?action=clear', true)">
                        <i class="fa fa-trash-alt"></i>
                        <span>Delete All</span>
                    </a>
                </div>
            </div>
            <div class="list-group">
                <c:forEach var="cart" items="${carts}">
                    <div class="row cart-item shadow-sm">
                        <div class="col-md-2 text-center">
                            <img src="${pageContext.request.contextPath}/upload/${cart.product.imageUrl}" alt="${cart.product.name}">
                        </div>
                        <div class="col-md-6">
                            <h5 class="mb-1">${cart.product.name}</h5>
                            <strong class="text-danger">Price: <fmt:formatNumber value=" ${cart.product.price}" pattern="#,##0"/> VNĐ</strong>
                            <p class="mb-1 text-muted">Quantity: ${cart.quantity}</p>
                        </div>

                        <div class="col-md-4 d-flex justify-content-end align-items-center gap-2 cart-buttons">
                            <!-- Nút xem chi tiết -->
                            <a href="${pageContext.request.contextPath}/product?id=${cart.product.productId}" 
                               class="btn btn-outline-info btn-sm d-flex align-items-center gap-1 px-3 py-1 rounded">
                                <i class="fa fa-info-circle"></i>
                                <span>Details</span>
                            </a>


                            <!-- Nút xóa từng sản phẩm -->
                            <a href="javascript:void(0);" 
                               class="btn btn-outline-danger btn-sm d-flex align-items-center gap-1 px-3 py-1 rounded"
                               onclick="showDeleteModal('${pageContext.request.contextPath}/cart?action=delete&cartId=${cart.cartId}')">
                                <i class="fa fa-trash"></i>
                                <span>Delete</span>
                            </a>

                            <!-- Nút mua ngay -->
                            <a href="${pageContext.request.contextPath}/order-confirm?productId=${cart.product.productId}&quantity=${cart.quantity}" 
                               class="btn btn-success btn-sm d-flex align-items-center gap-1 px-3 py-1 rounded text-white">
                                <i class="fa fa-shopping-cart"></i>
                                <span>Buy</span>
                            </a>
                        </div>
                    </div>

                    <!-- Modal Xác nhận xóa -->
                    <div class="modal fade" id="confirmDeleteModal" tabindex="-1" aria-labelledby="confirmDeleteLabel" aria-hidden="true">
                        <div class="modal-dialog modal-dialog-centered">
                            <div class="modal-content">
                                <div class="modal-body">
                                    Are you sure you want to delete this item?
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                    <a id="confirmDeleteBtn" href="#" class="btn btn-danger">Yes, Delete</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:when>

        <c:otherwise>
            <div class="card address-card shadow text-center mt-5 py-5 w-100">
                <h5 class="text-muted">No Cart Found</h5>
                <p class="text-muted">You have not add any products yet.</p>
            </div>
        </c:otherwise>
    </c:choose>

    <%@include file="/WEB-INF/include/btn-to-top.jsp" %>
</div>
