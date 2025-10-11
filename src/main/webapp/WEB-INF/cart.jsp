<%-- 
    Document   : Cart Page
    Created on : Jan 10, 2025
    Author     : Dang Vi Danh - CE19687
--%>

<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@ include file="/WEB-INF/include/header.jsp" %>

<style>
    .cart-container {
        max-width: 1200px;
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
    
    .cart-item-image {
        width: 100px;
        height: 100px;
        object-fit: cover;
        border-radius: 8px;
    }
    
    .quantity-controls {
        display: flex;
        align-items: center;
        gap: 10px;
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
    
    .cart-summary {
        background: #f8f9fa;
        border-radius: 8px;
        padding: 20px;
        position: sticky;
        top: 20px;
    }
    
    .empty-cart {
        text-align: center;
        padding: 60px 20px;
    }
    
    .empty-cart i {
        font-size: 4rem;
        color: #6c757d;
        margin-bottom: 20px;
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
        font-size: 1.2rem;
        font-weight: bold;
        color: #dc3545;
    }
    
    .total-price {
        font-size: 1.5rem;
        font-weight: bold;
        color: #28a745;
    }
    
    @media (max-width: 768px) {
        .cart-item {
            padding: 15px;
        }
        
        .cart-item-image {
            width: 80px;
            height: 80px;
        }
        
        .quantity-controls {
            flex-direction: column;
            gap: 5px;
        }
    }
</style>

<div class="cart-container">
    <div class="row">
        <div class="col-12">
            <h2 class="mb-4">
                <i class="bi bi-cart"></i> Giỏ hàng của bạn
                <c:if test="${not empty cartItems}">
                    <span class="badge bg-primary ms-2">${cartItemCount} sản phẩm</span>
                </c:if>
            </h2>
        </div>
    </div>

    <c:choose>
        <c:when test="${empty cartItems}">
            <!-- Empty Cart -->
            <div class="empty-cart">
                <i class="bi bi-cart-x"></i>
                <h3>Giỏ hàng trống</h3>
                <p class="text-muted">Bạn chưa có sản phẩm nào trong giỏ hàng.</p>
                <a href="${pageContext.request.contextPath}/home" class="btn btn-primary">
                    <i class="bi bi-house"></i> Tiếp tục mua sắm
                </a>
            </div>
        </c:when>
        
        <c:otherwise>
            <div class="row">
                <!-- Cart Items -->
                <div class="col-lg-8">
                    <c:forEach var="item" items="${cartItems}">
                        <div class="cart-item" id="cart-item-${item.cartId}">
                            <div class="row align-items-center">
                                <div class="col-md-2 col-3">
                                    <img src="${pageContext.request.contextPath}/assert/image/${item.productImage}" 
                                         alt="${item.productName}" 
                                         class="cart-item-image">
                                </div>
                                
                                <div class="col-md-4 col-9">
                                    <h5 class="mb-1">${item.productName}</h5>
                                    <p class="text-muted mb-1">${item.brand}</p>
                                    <p class="price-display mb-0">
                                        <fmt:formatNumber value="${item.price}" type="number"/> VNĐ
                                    </p>
                                </div>
                                
                                <div class="col-md-3 col-6">
                                    <div class="quantity-controls">
                                        <button class="quantity-btn" data-cart-id="${item.cartId}" data-action="decrease">
                                            <i class="bi bi-dash"></i>
                                        </button>
                                        <input type="number" 
                                               class="quantity-input" 
                                               id="quantity-${item.cartId}"
                                               value="${item.quantity}" 
                                               min="1" 
                                               max="99"
                                               data-cart-id="${item.cartId}">
                                        <button class="quantity-btn" data-cart-id="${item.cartId}" data-action="increase">
                                            <i class="bi bi-plus"></i>
                                        </button>
                                    </div>
                                </div>
                                
                                <div class="col-md-2 col-3 text-end">
                                    <p class="total-price mb-1" id="total-${item.cartId}">
                                        <fmt:formatNumber value="${item.totalPrice}" type="number"/> VNĐ
                                    </p>
                                </div>
                                
                                <div class="col-md-1 col-3 text-end">
                                    <button class="btn-cart-action btn-remove" 
                                            data-cart-id="${item.cartId}"
                                            title="Xóa sản phẩm">
                                        <i class="bi bi-trash"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                    
                    <!-- Clear Cart Button -->
                    <div class="text-end mb-3">
                        <button class="btn-cart-action btn-clear" onclick="clearCart()">
                            <i class="bi bi-trash"></i> Xóa tất cả
                        </button>
                    </div>
                </div>
                
                <!-- Cart Summary -->
                <div class="col-lg-4">
                    <div class="cart-summary">
                        <h4 class="mb-3">Tóm tắt đơn hàng</h4>
                        
                        <div class="d-flex justify-content-between mb-2">
                            <span>Số sản phẩm:</span>
                            <span id="total-items">${cartItemCount}</span>
                        </div>
                        
                        <div class="d-flex justify-content-between mb-3">
                            <span>Tổng tiền:</span>
                            <span class="total-price" id="cart-total">
                                <fmt:formatNumber value="${totalAmount}" type="number"/> VNĐ
                            </span>
                        </div>
                        
                        <hr>
                        
                        <button class="btn-checkout" onclick="checkout()">
                            <i class="bi bi-credit-card"></i> Thanh toán
                        </button>
                        
                        <div class="mt-3">
                            <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-secondary w-100">
                                <i class="bi bi-arrow-left"></i> Tiếp tục mua sắm
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<script>
    // Event listeners cho các nút điều khiển số lượng
    document.addEventListener('DOMContentLoaded', function() {
        // Nút tăng/giảm số lượng
        document.querySelectorAll('.quantity-btn').forEach(button => {
            button.addEventListener('click', function() {
                const cartId = this.getAttribute('data-cart-id');
                const action = this.getAttribute('data-action');
                const quantityInput = document.getElementById('quantity-' + cartId);
                let currentQuantity = parseInt(quantityInput.value);
                
                if (action === 'increase') {
                    currentQuantity += 1;
                } else if (action === 'decrease') {
                    currentQuantity -= 1;
                }
                
                updateQuantity(cartId, currentQuantity);
            });
        });
        
        // Input số lượng
        document.querySelectorAll('.quantity-input').forEach(input => {
            input.addEventListener('change', function() {
                const cartId = this.getAttribute('data-cart-id');
                const newQuantity = parseInt(this.value);
                updateQuantity(cartId, newQuantity);
            });
        });
        
        // Nút xóa sản phẩm
        document.querySelectorAll('.btn-remove').forEach(button => {
            button.addEventListener('click', function() {
                const cartId = this.getAttribute('data-cart-id');
                removeFromCart(cartId);
            });
        });
    });
    
    // Cập nhật số lượng sản phẩm
    function updateQuantity(cartId, newQuantity) {
        if (newQuantity < 1) {
            removeFromCart(cartId);
            return;
        }
        
        fetch('${pageContext.request.contextPath}/cart?action=update&cartId=' + cartId + '&quantity=' + newQuantity, {
            method: 'GET'
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                // Cập nhật UI
                document.getElementById('quantity-' + cartId).value = newQuantity;
                
                // Tính lại tổng tiền cho item này
                const priceElement = document.querySelector('#total-' + cartId);
                const currentTotalText = priceElement.textContent.replace(/[^\d]/g, '');
                const currentTotal = parseInt(currentTotalText);
                const currentQuantity = parseInt(document.getElementById('quantity-' + cartId).value);
                const price = currentQuantity > 0 ? currentTotal / currentQuantity : 0;
                const total = price * newQuantity;
                document.getElementById('total-' + cartId).textContent = 
                    new Intl.NumberFormat('vi-VN').format(total) + ' VNĐ';
                
                // Cập nhật tổng tiền giỏ hàng
                updateCartTotal();
                
                showMessage(data.message, 'success');
            } else {
                showMessage(data.message, 'error');
            }
        })
        .catch(error => {
            console.error('Error:', error);
            showMessage('Có lỗi xảy ra khi cập nhật', 'error');
        });
    }
    
    // Xóa sản phẩm khỏi giỏ hàng
    function removeFromCart(cartId) {
        if (confirm('Bạn có chắc chắn muốn xóa sản phẩm này khỏi giỏ hàng?')) {
            fetch('${pageContext.request.contextPath}/cart?action=remove&cartId=' + cartId, {
                method: 'GET'
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    // Xóa item khỏi UI
                    document.getElementById('cart-item-' + cartId).remove();
                    
                    // Cập nhật tổng tiền
                    updateCartTotal();
                    
                    // Kiểm tra nếu giỏ hàng trống
                    checkEmptyCart();
                    
                    showMessage(data.message, 'success');
                } else {
                    showMessage(data.message, 'error');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showMessage('Có lỗi xảy ra khi xóa sản phẩm', 'error');
            });
        }
    }
    
    // Xóa tất cả sản phẩm
    function clearCart() {
        if (confirm('Bạn có chắc chắn muốn xóa tất cả sản phẩm khỏi giỏ hàng?')) {
            fetch('${pageContext.request.contextPath}/cart?action=clear', {
                method: 'GET'
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    // Reload trang để hiển thị giỏ hàng trống
                    location.reload();
                } else {
                    showMessage(data.message, 'error');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showMessage('Có lỗi xảy ra khi xóa giỏ hàng', 'error');
            });
        }
    }
    
    // Kiểm tra giỏ hàng trống
    function checkEmptyCart() {
        const cartItems = document.querySelectorAll('.cart-item');
        if (cartItems.length === 0) {
            location.reload();
        }
    }
    
    // Cập nhật tổng tiền giỏ hàng
    function updateCartTotal() {
        // Tính tổng từ tất cả items còn lại
        let total = 0;
        document.querySelectorAll('[id^="total-"]').forEach(element => {
            const priceText = element.textContent.replace(/[^\d]/g, '');
            total += parseInt(priceText);
        });
        
        document.getElementById('cart-total').textContent = 
            new Intl.NumberFormat('vi-VN').format(total) + ' VNĐ';
    }
    
    // Thanh toán
    function checkout() {
        // TODO: Implement checkout functionality
        alert('Chức năng thanh toán đang được phát triển!');
    }
    
    // Hiển thị thông báo
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
        
        // Tự động ẩn sau 3 giây
        setTimeout(() => {
            const alert = document.querySelector('.alert');
            if (alert) {
                alert.remove();
            }
        }, 3000);
    }
</script>

<jsp:include page="/WEB-INF/include/footer.jsp" />

