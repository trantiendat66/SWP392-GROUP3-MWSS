<%-- 
    Document   : productdetail
    Purpose    : Trang chi tiết sản phẩm + Buy Now + Add to cart
--%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ include file="/WEB-INF/include/header.jsp" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<div class="container my-4">
    <!-- flash / error -->
    <c:if test="${not empty requestScope.error}">
        <div class="alert alert-danger">${requestScope.error}</div>
    </c:if>
    <c:if test="${not empty sessionScope.flash_success}">
        <div class="alert alert-success">${sessionScope.flash_success}</div>
        <c:remove var="flash_success" scope="session"/>
    </c:if>

    <!-- product content -->
    <c:choose>
        <c:when test="${not empty product}">
            <div class="row g-4">
                <div class="col-md-5">
                    <c:choose>
                        <c:when test="${not empty product.image}">
                            <img class="img-fluid rounded shadow-sm"
                                 src="${ctx}/assert/image/${product.image}"
                                 alt="${fn:escapeXml(product.productName)}">
                        </c:when>
                        <c:otherwise>
                            <img class="img-fluid rounded shadow-sm"
                                 src="${ctx}/assert/image/no-image.png"
                                 alt="no-image">
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="col-md-7">
                    <h3 class="mb-1">${fn:escapeXml(product.productName)}</h3>
                    <p class="text-muted mb-2">Brand: ${fn:escapeXml(product.brand)}</p>
                    <h4 class="text-danger mb-3">${product.price} VNĐ</h4>

                    <div class="mb-3">
                        <small class="text-secondary">Origin:</small> ${fn:escapeXml(product.origin)} |
                        <small class="text-secondary">Gender:</small> <c:out value="${product.gender ? 'Male/Unisex' : 'Female'}"/>
                    </div>

                    <p class="mb-3">${fn:escapeXml(product.description)}</p>

                    <!-- Quantity -->
                    <div class="d-flex align-items-center mb-3" style="max-width:220px;">
                        <label for="qty" class="me-2 mb-0">Số lượng</label>
                        <input type="number" id="qty" name="qty" min="1" value="1" class="form-control">
                    </div>

                    <!-- Actions: Buy now + Add to cart -->
                    <div class="d-flex align-items-center gap-2">
                        <!-- BUY NOW -->
                        <form action="${ctx}/order/buy-now" method="post" class="d-inline" id="buyNowForm">
                            <input type="hidden" name="product_id" value="${product.productId}">
                            <input type="hidden" name="quantity" id="buyNowQty" value="1">
                            <button type="submit" class="btn btn-danger">Buy now</button>
                        </form>


                        <!-- ADD TO CART (nếu bạn có CartController dạng ?action=add) -->
                        <form action="${ctx}/cart" method="get" class="d-inline">
                            <input type="hidden" name="action" value="add">
                            <input type="hidden" name="productId" value="${product.productId}">
                            <input type="hidden" name="quantity" id="addCartQty" value="1">
                            <button type="submit" class="btn btn-success">
                                <i class="bi bi-cart-plus"></i> Add to cart
                            </button>
                        </form>

                        <!-- Back -->
                        <a href="${ctx}/" class="btn btn-outline-secondary">Quay lại</a>
                    </div>

                    <small class="d-block mt-3 text-muted">
                        Kho hiện tại: ${product.quantityProduct}
                    </small>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <div class="alert alert-warning">Không tìm thấy sản phẩm.</div>
        </c:otherwise>
    </c:choose>
</div>

<script>
    // Đồng bộ số lượng từ input hiển thị sang hai form ẩn (buy-now & add-to-cart)
    (function () {
        const qty = document.getElementById('qty');
        const buyNowQty = document.getElementById('buyNowQty');
        const addCartQty = document.getElementById('addCartQty');
        if (!qty)
            return;
        const sync = () => {
            const val = Math.max(1, parseInt(qty.value || '1', 10));
            if (buyNowQty)
                buyNowQty.value = val;
            if (addCartQty)
                addCartQty.value = val;
        };
        qty.addEventListener('change', sync);
        qty.addEventListener('input', sync);
        sync();
    })();
</script>

<%@ include file="/WEB-INF/include/footer.jsp" %>
