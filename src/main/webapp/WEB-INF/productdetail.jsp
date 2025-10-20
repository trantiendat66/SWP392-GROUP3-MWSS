<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@ include file="/WEB-INF/include/header.jsp" %>
<head>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<c:choose>
    <c:when test="${empty product}">
        <div class="container"><div class="alert alert-warning">Sản phẩm không tồn tại.</div></div>
    </c:when>
    <c:otherwise>
        <div class="container product-details py-4">
            <div class="row">
                <div class="col-md-6">
                    <img src="${pageContext.request.contextPath}/assert/image/${product.image}" 
                         class="img-fluid rounded mb-3" alt="${product.productName}">
                </div>

                <div class="col-md-6">
                    <h2>${product.productName}</h2>
                    <p class="text-muted">Thương hiệu: ${product.brand} — Xuất xứ: ${product.origin}</p>
                    <h3 class="text-danger">${product.price} VNĐ</h3>

                    <div class="d-flex align-items-center mb-3">
                        <input type="number" id="quantity-input" value="1" min="1"
                               class="form-control me-2" style="width:100px;">
                        <button type="button" class="btn btn-danger btn-lg me-2" 
                                onclick="addToCart(${product.productId})">
                            <i class="fas fa-cart-plus"></i> Add to cart
                        </button>

                        <button type="button" class="btn btn-primary btn-lg" 
                                onclick="buyNow(${product.productId})">
                            <i class="fas fa-shopping-cart"></i> Buy Now
                        </button>

                    </div>
                    <!-- FORM ẨN: Buy Now -> /order/buy-now (không thêm vào cart) -->
                    <form id="buyNowForm" action="${pageContext.request.contextPath}/order/buy-now" method="post" style="display:none;">
                        <input type="hidden" name="product_id" value="${product.productId}">
                        <input type="hidden" name="quantity" id="buyNowQty" value="1">
                    </form>

                    <hr>

                    <h5>Mô tả</h5>
                    <p><c:out value="${product.description}" /></p>

                    <h5>Thông số kỹ thuật</h5>
                    <ul>
                        <li><strong>Bảo hành:</strong> ${product.warranty}</li>
                        <li><strong>Máy:</strong> ${product.machine}</li>
                        <li><strong>Kính:</strong> ${product.glass}</li>
                        <li><strong>Đường kính mặt:</strong> ${product.dialDiameter}</li>
                        <li><strong>Vành bezel:</strong> ${product.bezel}</li>
                        <li><strong>Dây:</strong> ${product.strap}</li>
                        <li><strong>Màu mặt:</strong> ${product.dialColor}</li>
                        <li><strong>Chức năng:</strong> ${product.function}</li>
                        <li><strong>Số lượng còn:</strong> ${product.quantityProduct}</li>
                        <li><strong>Giới tính:</strong> <c:out value="${product.gender ? 'Nam' : 'Nữ'}" /></li>
                    </ul>
                </div>
            </div>

        </div>

        <!-- Product Reviews -->
        <div class="container my-5">
            <h3>Đánh giá sản phẩm</h3>
            <c:if test="${empty productReviews}">
                <p>Chưa có đánh giá nào cho sản phẩm này.</p>
            </c:if>
            <c:forEach var="review" items="${productReviews}">
                <div class="card mb-3">
                    <div class="card-body">
                        <h5 class="card-title">${review.username}</h5>
                        <h6 class="card-subtitle mb-2 text-muted">${review.date}</h6>
                        <p class="card-text">${review.comment}</p>
                        <p class="card-text"><strong>Rating:</strong> ${review.rating}/5</p>
                    </div>
                </div>
            </c:forEach>
        </div>
    </c:otherwise>
</c:choose>

<script>
    // Giữ nguyên toàn bộ phần script addToCart / showMessage / updateCartCount
    function addToCart(productId) {
        const quantity = document.getElementById('quantity-input').value;
        if (quantity < 1) {
            alert('Số lượng phải lớn hơn 0');
            return;
        }
        fetch('${pageContext.request.contextPath}/cart?action=add&productId=' + productId + '&quantity=' + quantity, {
            method: 'GET'
        })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        showMessage(data.message, 'success');
                        updateCartCount();
                    } else {
                        showMessage(data.message, 'error');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    showMessage('Có lỗi xảy ra khi thêm sản phẩm vào giỏ hàng', 'error');
                });
    }

    function showMessage(message, type) {
        const alertClass = type === 'success' ? 'alert-success' : 'alert-danger';
        const alertHtml = `
            <div class="alert ${alertClass} alert-dismissible fade show position-fixed" 
                 style="top: 20px; right: 20px; z-index: 9999;">
    ${message}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        `;
        document.body.insertAdjacentHTML('beforeend', alertHtml);
        setTimeout(() => {
            const alert = document.querySelector('.alert');
            if (alert)
                alert.remove();
        }, 3000);
    }

    function updateCartCount() {
        fetch('${pageContext.request.contextPath}/cart?action=count', {method: 'GET'})
                .then(response => response.json())
                .then(data => {
                    const cartBadge = document.querySelector('.cart-badge');
                    if (cartBadge)
                        cartBadge.textContent = data.count;
                })
                .catch(error => console.error('Error updating cart count:', error));
    }
</script>

<script>
  function buyNow(productId) {
    // lấy số lượng hiện trên trang
    var qtyEl = document.getElementById('quantity-input');
    var qty = qtyEl ? parseInt(qtyEl.value, 10) : 1;
    if (!qty || qty < 1) qty = 1;

    // set vào input hidden và submit form ẩn tới /order/buy-now
    document.getElementById('buyNowQty').value = qty;
    document.getElementById('buyNowForm').submit();
  }
</script>

<jsp:include page="/WEB-INF/include/footer.jsp" />
