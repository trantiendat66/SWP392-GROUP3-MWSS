<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt" %>
<%@ include file="/WEB-INF/include/header.jsp" %>
<head>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<c:choose>
    <c:when test="${empty product}">
        <div class="container"><div class="alert alert-warning">Product does not exist.</div></div>
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
                    <p class="text-muted">Brand: ${product.brand} — Origin: ${product.origin}</p>

                    <h3 class="text-danger"><fmt:formatNumber value="${product.price}" type="number"/> VND</h3>

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

                    <h5>Description</h5>
                    <p><c:out value="${product.description}" /></p>

                    <h5>Specifications</h5>
                    <ul>
                        <li><strong>Warranty:</strong> ${product.warranty}</li>
                        <li><strong>Machine:</strong> ${product.machine}</li>
                        <li><strong>Glass:</strong> ${product.glass}</li>
                        <li><strong>Dial diameter:</strong> ${product.dialDiameter}</li>
                        <li><strong>Bezel:</strong> ${product.bezel}</li>
                        <li><strong>Strap:</strong> ${product.strap}</li>
                        <li><strong>Dial color:</strong> ${product.dialColor}</li>
                        <li><strong>Functions:</strong> ${product.function}</li>
                        <li><strong>Gender:</strong> <c:out value="${product.gender ? 'Nam' : 'Nữ'}" /></li>
                    </ul>
                </div>
            </div>

        </div>

        <!-- Product Reviews -->
        <!-- === Ratings Summary & Reviews === -->
        <div class="container my-5" id="ratings">
            <c:set var="ratingCount" value="${empty ratingCount ? 0 : ratingCount}" />
            <c:set var="ratingAvg"   value="${empty ratingAvg   ? 0 : ratingAvg}" />
            <c:set var="star5" value="${empty star5 ? 0 : star5}" />
            <c:set var="star4" value="${empty star4 ? 0 : star4}" />
            <c:set var="star3" value="${empty star3 ? 0 : star3}" />
            <c:set var="star2" value="${empty star2 ? 0 : star2}" />
            <c:set var="star1" value="${empty star1 ? 0 : star1}" />

            <!-- phần trăm cho progress bar -->
            <c:set var="pct5" value="${ratingCount > 0 ? (star5 * 100.0) / ratingCount : 0}" />
            <c:set var="pct4" value="${ratingCount > 0 ? (star4 * 100.0) / ratingCount : 0}" />
            <c:set var="pct3" value="${ratingCount > 0 ? (star3 * 100.0) / ratingCount : 0}" />
            <c:set var="pct2" value="${ratingCount > 0 ? (star2 * 100.0) / ratingCount : 0}" />
            <c:set var="pct1" value="${ratingCount > 0 ? (star1 * 100.0) / ratingCount : 0}" />

            <h3 class="mb-3">Product Ratings
                <small class="text-muted">(${ratingCount} reviews)</small>
            </h3>

            <div class="row g-4 align-items-center rating-summary-card">
                <!-- Cột trái: điểm trung bình -->
                <div class="col-12 col-md-4 text-center">
                    <div class="display-4 fw-bold mb-1">
                        <fmt:formatNumber value="${ratingAvg}" minFractionDigits="1" maxFractionDigits="1"/>
                    </div>
                    <div class="stars-avg mb-2">
                        <span class="bg"></span>
                        <!-- chiều rộng sao cam = ratingAvg * 20 (%) -->
                        <span class="fg" style="width:${ratingAvg * 20}%"></span>
                        <c:set var="roundedAvg" value="${(ratingAvg + 0.5) div 1}" />
                    </div>


                    <div class="text-muted">Average</div>
                </div>

                <!-- Cột phải: phân bố sao (REPLACED) -->
                <div class="col-12 col-md-8">
                    <!-- 5 sao -->
                    <div class="rating-row">
                        <div class="stars">
                            <c:forEach begin="1" end="5" var="s">
                                <span class="star on">&#9733;</span>
                            </c:forEach>
                        </div>
                        <div class="progress flex-grow-1">
                            <div class="progress-bar" role="progressbar" style="width:${pct5}%"></div>
                        </div>
                        <span class="count">${star5}</span>
                    </div>

                    <!-- 4 sao -->
                    <div class="rating-row">
                        <div class="stars">
                            <c:forEach begin="1" end="5" var="s">
                                <span class="star ${s <= 4 ? 'on' : ''}">&#9733;</span>
                            </c:forEach>
                        </div>
                        <div class="progress flex-grow-1">
                            <div class="progress-bar" role="progressbar" style="width:${pct4}%"></div>
                        </div>
                        <span class="count">${star4}</span>
                    </div>

                    <!-- 3 sao -->
                    <div class="rating-row">
                        <div class="stars">
                            <c:forEach begin="1" end="5" var="s">
                                <span class="star ${s <= 3 ? 'on' : ''}">&#9733;</span>
                            </c:forEach>
                        </div>
                        <div class="progress flex-grow-1">
                            <div class="progress-bar" role="progressbar" style="width:${pct3}%"></div>
                        </div>
                        <span class="count">${star3}</span>
                    </div>

                    <!-- 2 sao -->
                    <div class="rating-row">
                        <div class="stars">
                            <c:forEach begin="1" end="5" var="s">
                                <span class="star ${s <= 2 ? 'on' : ''}">&#9733;</span>
                            </c:forEach>
                        </div>
                        <div class="progress flex-grow-1">
                            <div class="progress-bar" role="progressbar" style="width:${pct2}%"></div>
                        </div>
                        <span class="count">${star2}</span>
                    </div>

                    <!-- 1 sao -->
                    <div class="rating-row">
                        <div class="stars">
                            <c:forEach begin="1" end="5" var="s">
                                <span class="star ${s <= 1 ? 'on' : ''}">&#9733;</span>
                            </c:forEach>
                        </div>
                        <div class="progress flex-grow-1">
                            <div class="progress-bar" role="progressbar" style="width:${pct1}%"></div>
                        </div>
                        <span class="count">${star1}</span>
                    </div>
                </div>

            </div>

            <!-- Danh sách từng đánh giá -->
            <div class="mt-4">
                <c:choose>
                    <c:when test="${empty productReviews}">
                        <div class="alert alert-info mb-0">There are no reviews for this product.</div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="rv" items="${productReviews}">
                            <div class="card mb-3">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between">
                                        <div class="fw-semibold">${rv.customerName}</div>
                                        <small class="text-muted">
                                            <fmt:formatDate value="${rv.createAt}" pattern="yyyy-MM-dd HH:mm"/>
                                        </small>
                                    </div>
                                    <div class="text-warning mb-2">
                                        <c:forEach begin="1" end="5" var="s">
                                            <c:choose>
                                                <c:when test="${s <= rv.rating}">
                                                    <span class="text-warning">&#9733;</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">&#9734;</span>  <%-- sao rỗng, thêm class ở đây --%>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:forEach>
                                    </div>

                                    <c:if test="${not empty rv.comment}">
                                        <p class="mb-0">${rv.comment}</p>
                                    </c:if>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <style>
            .rating-summary-card .progress {
                height: 10px;
                background: #e9ecef;
            }
            .rating-summary-card .progress-bar {
                background: #f59f00;
            } /* màu vàng cam */
            .rating-row {
                display:flex;
                align-items:center;
                gap:.75rem;
                margin-bottom:.5rem;
            }
            .rating-row .label {
                width: 48px;
                text-align:right;
                font-weight:600;
            }
            .rating-row .count {
                width: 28px;
                text-align:right;
                color:#6c757d;
            }
            .rating-stars {
                font-size: 20px;
                color: #f59f00;
                letter-spacing:2px;
            }

            /* --- Sao trung bình đổ màu (overlay) --- */
            .stars-avg{
                position:relative;
                display:inline-block;
                font-size:32px;
                line-height:1;
                letter-spacing:2px;
            }
            .stars-avg .bg::before{
                content:"★★★★★";
                color:#e5e7eb;
            }   /* nền xám */
            .stars-avg .fg{
                position:absolute;
                inset:0 auto 0 0;
                overflow:hidden;
                white-space:nowrap;
                color:#f59f00;                      /* vàng cam */
            }
            .stars-avg .fg::before{
                content:"★★★★★";
            }
            @media (max-width:576px){
                .stars-avg{
                    font-size:28px
                }
            }
            .rating-row{
                display:flex;
                align-items:center;
                gap:.75rem;
                margin-bottom:.5rem;
            }
            .rating-row .stars{
                width:110px;
                display:flex;
                gap:2px;
                justify-content:flex-start;
            }
            .star{
                color:#c0c7d1;
                font-size:18px;
                line-height:1;
            }
            .star.on{
                color:#f59f00;
            }          /* sao vàng */
            .rating-row .count{
                width:28px;
                text-align:right;
                color:#6c757d;
                font-weight:600;
            }

        </style>

    </c:otherwise>
</c:choose>

<script>

    function addToCart(productId) {
        if (!isLoggedIn()) {
            showLoginRequired('To add a product to the cart, you must log in first');
            return;
        }

        const quantity = document.getElementById('quantity-input').value;
        const maxQuantity = parseInt('${product.quantityProduct}');

        if (quantity < 1) {
            alert('Quantity must be greater than 0');
            return;
        }

        if (quantity > maxQuantity) {
            alert('Quantity cannot exceed ' + maxQuantity + ' items left in stock');
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
                    showMessage('An error occurred while adding the product to the cart', 'error');
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
                        <strong>Login required!</strong><br>
                        <small>${message}</small>
                    </div>
                </div>
                <div class="mt-2">
                    <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-primary btn-sm me-2">
                        <i class="bi bi-box-arrow-in-right"></i> Login
                    </a>
                    <button type="button" class="btn btn-outline-secondary btn-sm" onclick="this.closest('.alert').remove()">
                        <i class="bi bi-x"></i> Close
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
            showLoginRequired('To purchase a product, you must log in first');
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
