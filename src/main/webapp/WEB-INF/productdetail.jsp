<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt" %>
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

                    <h3 class="text-danger"><fmt:formatNumber value="${product.price}" type="number"/> VNĐ</h3>

                    <div class="d-flex align-items-center mb-3">
                        <input type="number" id="quantity-input" value="1" min="1" max="${product.quantityProduct}"
                               class="form-control me-2" style="width:100px;">
                        <button type="button" class="btn btn-danger btn-lg me-2" 
                                onclick="addToCart('${product.productId}')">
                            <i class="fas fa-cart-plus"></i> Add to cart
                        </button>

                        <button type="button" class="btn btn-primary btn-lg" 
                                onclick="buyNow('${product.productId}')">
                            <i class="fas fa-shopping-cart"></i> Buy Now
                        </button>

                    </div>

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
                        <li><strong>Giới tính:</strong> <c:out value="${product.gender ? 'Nam' : 'Nữ'}" /></li>
                    </ul>
                </div>
            </div>

        </div>

        <!-- Product Reviews -->
        <div class="container my-5">
            <h3>Đánh giá sản phẩm</h3>

            <!-- Tóm tắt nhanh: trung bình/đếm nếu có, mặc định 0/0 -->
            <p class="text-muted mb-3">
                Điểm trung bình:
                <strong>
                    <c:choose>
                        <c:when test="${not empty ratingAvg}">
                            <fmt:formatNumber value="${ratingAvg}" maxFractionDigits="1"/>
                        </c:when>
                        <c:otherwise>0</c:otherwise>
                    </c:choose>
                    / 5
                </strong>
                &nbsp;•&nbsp; Số lượt:
                <strong><c:out value="${empty ratingCount ? 0 : ratingCount}"/></strong>
            </p>

            <c:if test="${empty productReviews}">
                <p>Chưa có đánh giá nào cho sản phẩm này.</p>
            </c:if>

            <c:forEach var="review" items="${productReviews}">
                <div class="card mb-3">
                    <div class="card-body">
                        <!-- Tên người dùng: ưu tiên customerName, fallback username nếu trang cũ truyền -->
                        <h5 class="card-title">
                            <c:out value="${empty review.customerName ? review.username : review.customerName}"/>
                        </h5>

                        <!-- Ngày: ưu tiên createAt (java.util.Date/Timestamp), fallback date (string cũ) -->
                        <h6 class="card-subtitle mb-2 text-muted">
                            <c:choose>
                                <c:when test="${not empty review.createAt}">
                                    <fmt:formatDate value="${review.createAt}" pattern="yyyy-MM-dd HH:mm"/>
                                </c:when>
                                <c:otherwise>
                                    <c:out value="${review.date}"/>
                                </c:otherwise>
                            </c:choose>
                        </h6>

                        <p class="card-text"><c:out value="${review.comment}"/></p>
                        <p class="card-text">
                            <strong>Rating:</strong>
                            <c:out value="${review.rating}"/>/5
                        </p>
                    </div>
                </div>
            </c:forEach>
        </div>
    </c:otherwise>
</c:choose>

<script>

    function addToCart(productId) {
        if (!isLoggedIn()) {
            showLoginRequired('Để thêm sản phẩm vào giỏ hàng, bạn cần đăng nhập trước');
            return;
        }

        const quantity = document.getElementById('quantity-input').value;
        const maxQuantity = parseInt('${product.quantityProduct}');

        if (quantity < 1) {
            alert('Số lượng phải lớn hơn 0');
            return;
        }

        if (quantity > maxQuantity) {
            alert('Số lượng không được vượt quá ' + maxQuantity + ' sản phẩm còn lại trong kho');
            return;
        }

        fetch('${pageContext.request.contextPath}/cart?action=add&productId=' + productId + '&quantity=' + quantity, {
            method: 'GET'
        })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        showMessage(data.message, 'success');
                        if (typeof updateCartCount === 'function') {
                            updateCartCount();
                        }
                    } else {
                        if (data.redirect) {
                            showLoginRequired(data.message);
                        } else {
                            showMessage(data.message, 'error');
                        }
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

    // Function để cập nhật số lượng giỏ hàng
    function updateCartCount() {
        fetch('${pageContext.request.contextPath}/cart?action=count', {
            method: 'GET'
        })
                .then(response => response.json())
                .then(data => {
                    const cartBadge = document.getElementById('cart-count');
                    if (cartBadge) {
                        cartBadge.textContent = data.count;
                        // Chỉ hiển thị badge khi có sản phẩm trong giỏ hàng
                        if (data.count > 0) {
                            cartBadge.style.display = 'block';
                            cartBadge.className = 'position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger cart-badge';
                        } else {
                            cartBadge.style.display = 'none';
                        }
                    }
                })
                .catch(error => {
                    console.error('Error updating cart count:', error);
                });
    }

    // Function kiểm tra đăng nhập
    function isLoggedIn() {
        // Kiểm tra xem có session customer không
    <c:choose>
        <c:when test="${not empty sessionScope.customer}">
        return true;
        </c:when>
        <c:otherwise>
        return false;
        </c:otherwise>
    </c:choose>
    }

    // Function hiển thị thông báo yêu cầu đăng nhập
    function showLoginRequired(message) {
        // Lưu thông tin sản phẩm vào localStorage để sử dụng sau khi đăng nhập
        const productInfo = {
            productId: '${product.productId}',
            productName: '${product.productName}',
            price: '${product.price}',
            image: '${product.image}',
            quantity: document.getElementById('quantity-input').value,
            timestamp: new Date().getTime()
        };

        // Lưu vào localStorage
        localStorage.setItem('pendingProduct', JSON.stringify(productInfo));

        const alertHtml = `
            <div class="alert alert-warning alert-dismissible fade show position-fixed" 
                 style="top: 20px; right: 20px; z-index: 9999; max-width: 400px;">
                <div class="d-flex align-items-center">
                    <i class="bi bi-exclamation-triangle-fill me-2"></i>
                    <div>
                        <strong>Yêu cầu đăng nhập!</strong><br>
                        <small>${message}</small>
                    </div>
                </div>
                <div class="mt-2">
                    <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-primary btn-sm me-2">
                        <i class="bi bi-box-arrow-in-right"></i> Đăng nhập
                    </a>
                    <button type="button" class="btn btn-outline-secondary btn-sm" onclick="this.closest('.alert').remove()">
                        <i class="bi bi-x"></i> Đóng
                    </button>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        `;
        document.body.insertAdjacentHTML('beforeend', alertHtml);

        // Tự động ẩn sau 10 giây
        setTimeout(() => {
            const alert = document.querySelector('.alert-warning');
            if (alert) {
                alert.remove();
            }
        }, 10000);
    }
</script>

<script>
    function buyNow(productId) {
        // Kiểm tra đăng nhập trước
        if (!isLoggedIn()) {
            showLoginRequired('Để mua sản phẩm, bạn cần đăng nhập trước');
            return;
        }

        // lấy số lượng hiện trên trang
        var qtyEl = document.getElementById('quantity-input');
        var qty = qtyEl ? parseInt(qtyEl.value, 10) : 1;
        if (!qty || qty < 1)
            qty = 1;

        // set vào input hidden và submit form ẩn tới /order/buy-now
        document.getElementById('buyNowQty').value = qty;
        document.getElementById('buyNowForm').submit();
    }
</script>

<jsp:include page="/WEB-INF/include/footer.jsp" />
