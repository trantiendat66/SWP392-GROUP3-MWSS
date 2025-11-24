<%-- 
    Document   : Cart Page
    Created on : Jan 10, 2025
    Author     : Dang Vi Danh - CE19687
--%>

<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@ include file="/WEB-INF/include/header.jsp" %>
<head>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</head>

<style>
    .cart-container {
        max-width: 1600px;
        margin: 0 auto;
        padding: 20px;
    }

    .cart-item {
        border: 1px solid #e0e0e0;
        border-radius: 8px;
        padding: 20px;
        margin-bottom: 20px;
        background: white;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }

    .cart-item-out-of-stock {
        opacity: 0.6;
        background: #f8f9fa;
        border-color: #dc3545;
    }

    .cart-item-out-of-stock .quantity-btn.disabled,
    .cart-item-out-of-stock .quantity-input.disabled {
        opacity: 0.5;
        cursor: not-allowed;
        background: #e9ecef;
    }

    .cart-item-image {
        width: 100px;
        height: 100px;
        object-fit: cover;
        border-radius: 8px;
    }

    .quantity-btn {
        width: 35px;
        height: 35px;
        border: 1px solid #ddd;
        background: white;
        border-radius: 4px;
        display: flex;
        align-items: center;
        justify-content: center;
        cursor: pointer;
        transition: all 0.2s;
    }

    .quantity-btn:hover {
        background: #f8f9fa;
        border-color: #007bff;
    }

    .quantity-input {
        width: 60px;
        text-align: center;
        border: 1px solid #ddd;
        border-radius: 4px;
        padding: 8px;
    }

    .btn-cart-action {
        padding: 8px 16px;
        border-radius: 4px;
        border: none;
        cursor: pointer;
        transition: all 0.2s;
    }

    .btn-remove {
        background: #dc3545;
        color: white;
    }

    .btn-remove:hover {
        background: #c82333;
    }

    .btn-clear {
        background: #6c757d;
        color: white;
    }

    .btn-clear:hover {
        background: #5a6268;
    }

    .btn-checkout {
        background: #28a745;
        color: white;
        width: 100%;
        padding: 12px;
        font-size: 1.1rem;
    }

    .btn-checkout:hover {
        background: #218838;
    }

    .price-display {
        font-size: 1.1rem;
        font-weight: bold;
        color: #dc3545;
        white-space: nowrap;
    }

    .total-price {
        font-size: 1.5rem;
        font-weight: bold;
        color: #28a745;
        white-space: nowrap;
    }

    /* 👇 Thêm phần mới để xếp hàng ngang */
    .cart-item-actions {
        display: flex;
        align-items: center;
        justify-content: flex-start;
        gap: 16px;
        flex-wrap: nowrap;
        margin-top: 8px;
    }

    .cart-item-actions .price-display,
    .cart-item-actions .total-price {
        margin: 0;
        white-space: nowrap;
    }

    .cart-item-actions .quantity-controls {
        display: flex;
        align-items: center;
        gap: 8px;
    }

    .cart-summary {
        background: #f8f9fa;
        border-radius: 8px;
        padding: 20px;
        position: sticky;
        top: 20px;
    }

    @media (max-width: 768px) {
        .cart-item-actions {
            flex-wrap: wrap;
            gap: 10px;
        }
    }
</style>

<div class="cart-container">
    <div class="row">
        <div class="col-12">
            <h2 class="mb-4">
                <i class="bi bi-cart"></i> Your Cart
                <c:if test="${not empty cartItems}">
                    <span class="badge bg-primary ms-2">${cartItemCount} Product(s)</span>
                </c:if>
            </h2>
        </div>
    </div>

    <!-- Thông báo khi cart được điều chỉnh do stock thay đổi -->
    <c:if test="${not empty cartAdjusted && cartAdjusted == true}">
        <div class="alert alert-warning alert-dismissible fade show" role="alert">
            <i class="bi bi-exclamation-triangle-fill me-2"></i>
            <strong>Cart Updated:</strong> 
            <c:choose>
                <c:when test="${adjustedCount == 1}">
                    One item in your cart has been adjusted due to stock changes.
                </c:when>
                <c:otherwise>
                    ${adjustedCount} items in your cart have been adjusted due to stock changes.
                </c:otherwise>
            </c:choose>
            Please review your cart before checkout.
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <c:choose>
        <c:when test="${empty cartItems}">
            <!-- Empty Cart -->
            <div class="empty-cart text-center">
                <i class="bi bi-cart-x display-4 text-muted"></i>
                <h3>Your cart is empty</h3>
                <p class="text-muted">You have no items in your cart.</p>
                <a href="${pageContext.request.contextPath}/home" class="btn btn-primary">
                    <i class="bi bi-house"></i> Continue Shopping
                </a>
            </div>
        </c:when>

        <c:otherwise>
            <div class="row">
                <!-- Cart Items -->
                <div class="col-lg-8">
                    <c:forEach var="item" items="${cartItems}">
                        <c:set var="isOutOfStock" value="${item.availableQuantity <= 0 || item.quantity <= 0}" />
                        <div class="cart-item ${isOutOfStock ? 'cart-item-out-of-stock' : ''}" id="cart-item-${item.cartId}">
                            <div class="row align-items-center">
                                <div class="col-md-2 col-3">
                                    <img src="${pageContext.request.contextPath}/assert/image/${item.productImage}" 
                                         alt="${item.productName}" 
                                         class="cart-item-image ${isOutOfStock ? 'opacity-50' : ''}">
                                </div>

                                <div class="col-md-10 col-9 product-col">
                                    <h5 class="mb-1 ${isOutOfStock ? 'text-muted' : ''}">${item.productName}</h5>
                                    <p class="text-muted mb-1">${item.brand}</p>

                                    <!-- Thông báo out of stock -->
                                    <c:if test="${isOutOfStock}">
                                        <div class="alert alert-warning py-2 px-3 mb-2" style="font-size: 0.85rem;">
                                            <i class="bi bi-exclamation-triangle-fill me-1"></i>
                                            <strong>Out of Stock:</strong> This item is currently unavailable and has been removed from your order total.
                                        </div>
                                    </c:if>

                                    <p class="mb-2">
                                        <small class="text-muted">
                                            <strong>Stock:</strong> 
                                            <span class="badge ${item.availableQuantity > 0 ? 'bg-success' : 'bg-danger'}">
                                                ${item.availableQuantity} item(s)
                                            </span>
                                        </small>
                                    </p>

                                    <div class="cart-item-actions">
                                        <!-- Giá -->
                                        <p class="price-display mb-0 ${isOutOfStock ? 'text-muted text-decoration-line-through' : ''}">
                                            <fmt:formatNumber value="${item.price}" type="number"/> VND
                                        </p>

                                        <!-- Số lượng -->
                                        <div class="quantity-controls">
                                            <button class="quantity-btn ${isOutOfStock ? 'disabled' : ''}" 
                                                    data-cart-id="${item.cartId}" 
                                                    data-action="decrease"
                                                    ${isOutOfStock ? 'disabled' : ''}>
                                                <i class="bi bi-dash"></i>
                                            </button>
                                            <input type="number" 
                                                   class="quantity-input ${isOutOfStock ? 'disabled' : ''}" 
                                                   id="quantity-${item.cartId}"
                                                   value="${item.quantity}" 
                                                   min="0" 
                                                   max="${item.availableQuantity}"
                                                   data-cart-id="${item.cartId}"
                                                   data-max-quantity="${item.availableQuantity}"
                                                   data-unit-price="${item.price}"
                                                   ${isOutOfStock ? 'disabled' : ''}>
                                            <button class="quantity-btn ${isOutOfStock ? 'disabled' : ''}" 
                                                    data-cart-id="${item.cartId}" 
                                                    data-action="increase"
                                                    ${isOutOfStock ? 'disabled' : ''}>
                                                <i class="bi bi-plus"></i>
                                            </button>
                                        </div>

                                        <!-- Tổng tiền -->
                                        <p class="total-price mb-0 ${isOutOfStock ? 'text-muted text-decoration-line-through' : ''}" 
                                           id="total-${item.cartId}" 
                                           data-total-value="${isOutOfStock ? 0 : item.totalPrice}">
                                            <c:choose>
                                                <c:when test="${isOutOfStock}">
                                                    <span class="text-muted">0 VND</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <fmt:formatNumber value="${item.totalPrice}" type="number"/> VND
                                                </c:otherwise>
                                            </c:choose>
                                        </p>

                                        <!-- Nút xóa -->
                                        <button class="btn-cart-action btn-remove" 
                                                data-cart-id="${item.cartId}"
                                                title="Remove item">
                                            <i class="bi bi-trash"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>

                    <!-- Clear Cart Button -->
                    <div class="text-end mb-3">
                        <button class="btn-cart-action btn-clear" onclick="clearCart()">
                            <i class="bi bi-trash"></i> Clear All
                        </button>
                    </div>
                </div>

                <!-- Cart Summary -->
                <div class="col-lg-4">
                    <div class="cart-summary">
                        <h4 class="mb-3">Order Summary</h4>

                        <div class="d-flex justify-content-between mb-2">
                            <span>Number of Items:</span>
                            <span id="total-items">
                                <c:set var="activeItemCount" value="0" />
                                <c:forEach var="item" items="${cartItems}">
                                    <c:if test="${item.availableQuantity > 0 && item.quantity > 0}">
                                        <c:set var="activeItemCount" value="${activeItemCount + item.quantity}" />
                                    </c:if>
                                </c:forEach>
                                ${activeItemCount}
                            </span>
                        </div>

                        <div class="d-flex justify-content-between mb-3">
                            <span>Total Amount:</span>
                            <span class="total-price" id="cart-total">
                                <fmt:formatNumber value="${totalAmount}" type="number"/> VND
                            </span>
                        </div>

                        <hr>

                        <button class="btn-checkout" onclick="checkout()">
                            <i class="bi bi-credit-card"></i> Payment
                        </button>

                        <div class="mt-3">
                            <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-secondary w-100">
                                <i class="bi bi-arrow-left"></i> Continue Shopping
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        updateCartTotal(); // tính tổng khi load trang

        // Buttons increase/decrease
        document.querySelectorAll('.quantity-btn').forEach(button => {
            button.addEventListener('click', function () {
                if (this.classList.contains('disabled') || this.disabled)
                    return;

                const cartId = this.getAttribute('data-cart-id');
                const action = this.getAttribute('data-action');
                const quantityInput = document.getElementById('quantity-' + cartId);
                if (quantityInput.disabled)
                    return;

                let currentQuantity = parseInt(quantityInput.value);
                if (action === 'increase')
                    currentQuantity += 1;
                else if (action === 'decrease')
                    currentQuantity -= 1;

                updateQuantity(cartId, currentQuantity);
            });
        });

        // Manual input change
        document.querySelectorAll('.quantity-input').forEach(input => {
            input.setAttribute('data-old-value', input.value);
            input.addEventListener('change', function () {
                const cartId = this.getAttribute('data-cart-id');
                const newQuantity = parseInt(this.value);
                updateQuantity(cartId, newQuantity);
            });
        });

        // Remove buttons
        document.querySelectorAll('.btn-remove').forEach(button => {
            button.addEventListener('click', function () {
                const cartId = this.getAttribute('data-cart-id');
                removeFromCart(cartId);
            });
        });
    });

    function updateQuantity(cartId, newQuantity) {
        const quantityInput = document.getElementById('quantity-' + cartId);
        const maxQuantity = parseInt(quantityInput.getAttribute('data-max-quantity'));
        const oldQuantity = parseInt(quantityInput.value) || 1;
        const totalElement = document.getElementById('total-' + cartId);
        const oldTotalValue = parseInt(totalElement.getAttribute('data-total-value')) || 0;

        if (newQuantity < 1) {
            removeFromCart(cartId);
            return;
        }

        if (newQuantity > maxQuantity) {
            showMessage('Quantity cannot exceed ' + maxQuantity + ' items remaining in stock', 'error');
            quantityInput.value = quantityInput.getAttribute('data-old-value') || 1;
            return;
        }

        // Cập nhật tổng tiền item ngay
        const unitPrice = parseInt(quantityInput.getAttribute('data-unit-price'));
        const newTotal = unitPrice * newQuantity;
        totalElement.setAttribute('data-total-value', newTotal);
        totalElement.textContent = new Intl.NumberFormat('vi-VN').format(newTotal) + ' VND';

        quantityInput.value = newQuantity;
        quantityInput.setAttribute('data-old-value', newQuantity);

        // Cập nhật tổng tiền và số lượng cart
        updateCartTotal();

        // Gọi server để update
        fetch('${pageContext.request.contextPath}/cart?action=update&cartId=' + cartId + '&quantity=' + newQuantity, {
            method: 'GET'
        })
                .then(response => response.json())
                .then(data => {
                    if (!data.success) {
                        showMessage(data.message, 'error');
                        // rollback nếu lỗi
                        quantityInput.value = oldQuantity;
                        quantityInput.setAttribute('data-old-value', oldQuantity);
                        totalElement.setAttribute('data-total-value', oldTotalValue);
                        totalElement.textContent = new Intl.NumberFormat('vi-VN').format(oldTotalValue) + ' VND';
                        updateCartTotal();
                    } else {
                        updateCartCount(); // update badge header
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    showMessage('An error occurred while updating.', 'error');
                    quantityInput.value = oldQuantity;
                    quantityInput.setAttribute('data-old-value', oldQuantity);
                    totalElement.setAttribute('data-total-value', oldTotalValue);
                    totalElement.textContent = new Intl.NumberFormat('vi-VN').format(oldTotalValue) + ' VND';
                    updateCartTotal();
                });
    }

    function removeFromCart(cartId) {
        if (confirm('Are you sure you want to remove this item from your cart?')) {
            fetch('${pageContext.request.contextPath}/cart?action=remove&cartId=' + cartId, {
                method: 'GET'
            })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            const cartItem = document.getElementById('cart-item-' + cartId);
                            if (cartItem)
                                cartItem.remove();
                            updateCartTotal();
                            checkEmptyCart();
                            showMessage(data.message, 'success');
                            updateCartCount();
                        } else {
                            showMessage(data.message, 'error');
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        showMessage('An error occurred while removing item.', 'error');
                    });
        }
    }

    function updateCartTotal() {
        let total = 0;
        let itemCount = 0;

        document.querySelectorAll('[id^="total-"]').forEach(element => {
            const elementId = element.getAttribute('id');
            if (elementId === 'total-items' || elementId === 'cart-total')
                return;

            const cartItem = element.closest('.cart-item');
            if (cartItem && cartItem.classList.contains('cart-item-out-of-stock'))
                return;

            const totalValue = parseInt(element.getAttribute('data-total-value')) || 0;
            total += totalValue;

            const quantityInput = document.getElementById('quantity-' + elementId.replace('total-', ''));
            if (quantityInput)
                itemCount += parseInt(quantityInput.value) || 0;
        });

        document.getElementById('cart-total').textContent = new Intl.NumberFormat('vi-VN').format(total) + ' VND';
        const totalItemsElement = document.getElementById('total-items');
        if (totalItemsElement)
            totalItemsElement.textContent = itemCount;

        // Update badge header
        updateCartCount();
    }

    function checkEmptyCart() {
        const cartItems = document.querySelectorAll('.cart-item');
        if (cartItems.length === 0)
            location.reload();
    }

    function checkout() {
        window.location.href = '${pageContext.request.contextPath}/payment';
    }

    function showMessage(message, type) {
        if (window.showToast) {
            window.showToast(message, type);
            return;
        }
        const notification = document.getElementById('cart-notification');
        if (notification) {
            const palette = {success: '#198754', error: '#dc3545', info: '#0d6efd', warning: '#f59f00'};
            notification.textContent = message || '';
            notification.style.background = palette[type] || palette.info;
            notification.style.display = 'block';
            clearTimeout(window.cartNotificationTimeout);
            window.cartNotificationTimeout = setTimeout(() => {
                notification.style.display = 'none';
            }, 3000);
            return;
        }
        console.log('Cart notification:', message);
    }

    function updateCartCount() {
        fetch('${pageContext.request.contextPath}/cart?action=count', {method: 'GET'})
                .then(response => response.json())
                .then(data => {
                    const cartBadge = document.getElementById('cart-count');
                    if (cartBadge) {
                        cartBadge.textContent = data.count;
                        if (data.count > 0) {
                            cartBadge.style.display = 'block';
                            cartBadge.className = 'position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger cart-badge';
                        } else
                            cartBadge.style.display = 'none';
                    }
                })
                .catch(error => console.error('Error updating cart count:', error));
    }

    function clearCart() {
        if (confirm('Are you sure you want to clear all items from your cart?')) {
            fetch('${pageContext.request.contextPath}/cart?action=clear', {method: 'GET'})
                    .then(response => response.json())
                    .then(data => {
                        if (data.success)
                            location.reload();
                        else
                            showMessage(data.message, 'error');
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        showMessage('An error occurred while clearing the cart.', 'error');
                    });
        }
    }
</script>


<jsp:include page="/WEB-INF/include/footer.jsp" />


