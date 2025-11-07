<%-- 
    Document   : payment
    Created on : Oct 16, 2025, 12:29:54 PM
    Author     : Oanh Nguyen
--%>

<%-- payment.jsp: Payment confirmation --%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt" %>
<%@ include file="/WEB-INF/include/header.jsp" %>
<head>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<div class="container my-4">
    <c:if test="${not empty requestScope.error}">
        <div class="alert alert-danger">${requestScope.error}</div>
    </c:if>
    <c:if test="${not empty sessionScope.flash_success}">
        <div class="alert alert-success">${sessionScope.flash_success}</div>
        <c:remove var="flash_success" scope="session"/>
    </c:if>

    <h3 class="mb-3">Payment Confirmation</h3>

    <!-- Buy-now banner: currently buying quickly, not added to cart yet -->
    <c:if test="${not empty sessionScope.bn_pid}">
        <div class="alert alert-warning d-flex justify-content-between align-items-center">
            <div>
                <strong>Buy now:</strong> You are buying one product quickly (not yet added to the cart).
                If you go back or cancel, the product will be added to your shopping cart.
            </div>
            <form action="${ctx}/payment/cancel-buynow" method="post" class="ms-3">
                <button type="submit" class="btn btn-sm btn-outline-dark">Cancel Buy Now</button>
            </form>
        </div>
    </c:if>

    <c:choose>
        <c:when test="${empty cartItems}">
            <div class="alert alert-info">Your cart is empty. Please add products before checkout.</div>
            <a href="${ctx}/home" class="btn btn-primary">Continue Shopping</a>
        </c:when>

        <c:otherwise>
            <div class="row g-4">
                <!-- Cart / Buy-now summary -->
                <div class="col-lg-8">
                    <div class="table-responsive">
                        <table class="table align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th style="width:70px;">Image</th>
                                    <th>Product</th>
                                    <th class="text-center" style="width:120px;">Quantity</th>
                                    <th class="text-center" style="width:120px;">Stock</th>
                                    <th class="text-end">Unit Price</th>
                                    <th class="text-end">Total</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="item" items="${cartItems}">
                                    <tr class="${item.quantity > item.availableQuantity ? 'table-warning' : ''}" 
                                        id="row-${item.cartId > 0 ? item.cartId : item.productId}">
                                        <td>
                                            <img src="${ctx}/assert/image/${item.productImage}" class="img-thumbnail"
                                                 style="width:64px;height:64px;object-fit:cover" alt="${item.productName}">
                                        </td>
                                        <td>
                                            <div class="fw-semibold">${item.productName}</div>
                                            <small class="text-muted">Brand: ${item.brand}</small>
                                            <div class="text-danger small mt-1" 
                                                 id="stock-warning-${item.cartId > 0 ? item.cartId : item.productId}"
                                                 style="display: ${item.quantity > item.availableQuantity ? 'block' : 'none'};">
                                                <i class="bi bi-exclamation-triangle"></i> 
                                                <span id="stock-warning-text-${item.cartId > 0 ? item.cartId : item.productId}">
                                                    Số lượng đặt (${item.quantity}) vượt quá số lượng còn trong kho (${item.availableQuantity})
                                                </span>
                                            </div>
                                        </td>
                                        <td class="text-center">
                                            <div class="d-flex align-items-center justify-content-center gap-1">
                                                <button class="btn btn-sm btn-outline-secondary quantity-btn-decrease" 
                                                        data-item-id="${item.cartId > 0 ? item.cartId : item.productId}"
                                                        data-product-id="${item.productId}"
                                                        data-mode="${paymentMode}"
                                                        style="width: 30px; height: 30px; padding: 0;">
                                                    <i class="bi bi-dash"></i>
                                                </button>
                                                <input type="number" 
                                                       class="form-control form-control-sm quantity-input-payment text-center" 
                                                       value="${item.quantity}" 
                                                       min="1" 
                                                       max="${item.availableQuantity}"
                                                       data-item-id="${item.cartId > 0 ? item.cartId : item.productId}"
                                                       data-product-id="${item.productId}"
                                                       data-price="${item.price}"
                                                       data-available="${item.availableQuantity}"
                                                       data-mode="${paymentMode}"
                                                       style="width: 60px;"
                                                       id="qty-${item.cartId > 0 ? item.cartId : item.productId}">
                                                <button class="btn btn-sm btn-outline-secondary quantity-btn-increase" 
                                                        data-item-id="${item.cartId > 0 ? item.cartId : item.productId}"
                                                        data-product-id="${item.productId}"
                                                        data-mode="${paymentMode}"
                                                        style="width: 30px; height: 30px; padding: 0;">
                                                    <i class="bi bi-plus"></i>
                                                </button>
                                            </div>
                                            <small class="text-danger d-block mt-1" 
                                                   id="qty-error-${item.cartId > 0 ? item.cartId : item.productId}" 
                                                   style="display: none; font-size: 0.75rem;"></small>
                                        </td>
                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${item.availableQuantity > 0}">
                                                    <span class="badge bg-success">${item.availableQuantity}</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-danger">Out of Stock</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-end text-muted"><fmt:formatNumber value="${item.price}" type="number"/> VND</td>
                                        <td class="text-end fw-semibold" id="total-${item.cartId > 0 ? item.cartId : item.productId}">
                                            <fmt:formatNumber value="${item.totalPrice}" type="number"/> VND
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                            <tfoot>
                                <tr>
                                    <th colspan="5" class="text-end">Total:</th>
                                    <th class="text-end text-danger fs-5" id="grand-total">
                                        <fmt:formatNumber value="${totalAmount}" type="number"/> VND
                                    </th>
                                </tr>
                            </tfoot>
                        </table>
                    </div>

                    <!-- Back button:
                         - If currently in buy-now (sessionScope.bn_pid exists) => POST /payment/cancel-buynow to add to cart and return to /cart
                         - Otherwise => just link back to /cart -->
                    <c:choose>
                        <c:when test="${not empty sessionScope.bn_pid}">
                            <form action="${ctx}/payment/cancel-buynow" method="post" class="d-inline">
                                <button type="submit" class="btn btn-outline-secondary">← Back to Cart</button>
                            </form>
                        </c:when>
                        <c:otherwise>
                            <a href="${ctx}/cart" class="btn btn-outline-secondary">← Back to Cart</a>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Shipping & Payment form -->
                <div class="col-lg-4">
                    <div class="card">
                        <div class="card-body">
                            <h5 class="card-title mb-3">Shipping Information</h5>
                            
                            <c:set var="hasStockIssue" value="false" />
                            <c:forEach var="item" items="${cartItems}">
                                <c:if test="${item.quantity > item.availableQuantity}">
                                    <c:set var="hasStockIssue" value="true" />
                                </c:if>
                            </c:forEach>
                            
                            <c:if test="${hasStockIssue}">
                                <div class="alert alert-warning mb-3">
                                    <i class="bi bi-exclamation-triangle"></i>
                                    <strong>Cảnh báo:</strong> Một số sản phẩm trong giỏ hàng có số lượng vượt quá số lượng còn trong kho. 
                                    Vui lòng quay lại giỏ hàng để điều chỉnh số lượng trước khi đặt hàng.
                                </div>
                            </c:if>

                            <form action="${ctx}/order/create-from-cart" method="post" id="orderForm">
                                <div class="mb-2">
                                    <label class="form-label">Phone Number</label>
                                    <input type="text" name="phone" value="${sessionScope.customer.phone}"
                                           class="form-control" placeholder="Phone number" id="phone-input">
                                </div>

                                <div class="mb-2">
                                    <label class="form-label">Shipping Address</label>
                                    <input type="text" name="shipping_address" class="form-control"
                                           placeholder="Shipping address" required id="address-input">
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Payment Method</label>
                                    <select name="payment_method" class="form-select" id="payment-method-select">
                                        <option value="0">COD (Cash on Delivery)</option>
                                        <option value="2">MoMo Wallet</option>
                                    </select>
                                    <small class="text-muted">
                                        <i class="bi bi-info-circle"></i> 
                                        Select MoMo to pay instantly with MoMo e-wallet
                                    </small>
                                </div>

                                <button type="submit" class="btn btn-primary w-100" id="btnConfirmOrder" ${hasStockIssue ? 'disabled' : ''}>
                                    <span id="btn-text">Confirm Order</span>
                                </button>
                            </form>
                            
                            <c:if test="${hasStockIssue}">
                                <div class="alert alert-info mt-2 mb-0">
                                    <small>Vui lòng quay lại <a href="${ctx}/cart">giỏ hàng</a> để cập nhật số lượng sản phẩm.</small>
                                </div>
                            </c:if>

                            <hr>
                            <div class="d-flex justify-content-between">
                                <span>Subtotal</span>
                                <strong class="text-danger" id="subtotal-amount">
                                    <fmt:formatNumber value="${totalAmount}" type="number"/> VND
                                </strong>
                            </div>
                            <small class="text-muted d-block mt-2">Shipping fee will be calculated in the next step (if applicable).</small>
                        </div>
                    </div>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<script>
    // Ngăn submit form nếu có vấn đề về stock
    document.addEventListener('DOMContentLoaded', function() {
        const orderForm = document.getElementById('orderForm');
        const paymentMethodSelect = document.getElementById('payment-method-select');
        const btnText = document.getElementById('btn-text');
        
        // Xử lý khi thay đổi payment method
        if (paymentMethodSelect) {
            paymentMethodSelect.addEventListener('change', function() {
                const selectedMethod = this.value;
                if (selectedMethod === '2') {
                    // MoMo payment
                    btnText.textContent = 'Pay with MoMo';
                    orderForm.action = '${ctx}/momo/payment';
                } else {
                    // COD
                    btnText.textContent = 'Confirm Order';
                    orderForm.action = '${ctx}/order/create-from-cart';
                }
            });
        }
        
        if (orderForm) {
            orderForm.addEventListener('submit', function(e) {
                const btnConfirmOrder = document.getElementById('btnConfirmOrder');
                if (btnConfirmOrder && btnConfirmOrder.disabled) {
                    e.preventDefault();
                    alert('Vui lòng quay lại giỏ hàng để điều chỉnh số lượng sản phẩm trước khi đặt hàng.');
                    return false;
                }
                
                // Validate shipping address and phone
                const phone = document.getElementById('phone-input').value.trim();
                const address = document.getElementById('address-input').value.trim();
                
                if (!phone || !address) {
                    e.preventDefault();
                    alert('Vui lòng nhập đầy đủ số điện thoại và địa chỉ giao hàng.');
                    return false;
                }
            });
        }
        
        // Xử lý nút tăng/giảm số lượng
        document.querySelectorAll('.quantity-btn-increase, .quantity-btn-decrease').forEach(btn => {
            btn.addEventListener('click', function() {
                const itemId = this.getAttribute('data-item-id');
                const productId = this.getAttribute('data-product-id');
                const mode = this.getAttribute('data-mode');
                const input = document.getElementById('qty-' + itemId);
                let currentQty = parseInt(input.value) || 1;
                
                if (this.classList.contains('quantity-btn-increase')) {
                    currentQty += 1;
                } else if (this.classList.contains('quantity-btn-decrease')) {
                    currentQty -= 1;
                }
                
                if (currentQty < 1) currentQty = 1;
                
                updateQuantity(itemId, productId, currentQty, mode);
            });
        });
        
        // Xử lý khi người dùng nhập trực tiếp
        document.querySelectorAll('.quantity-input-payment').forEach(input => {
            input.addEventListener('change', function() {
                const itemId = this.getAttribute('data-item-id');
                const productId = this.getAttribute('data-product-id');
                const mode = this.getAttribute('data-mode');
                const newQty = parseInt(this.value) || 1;
                updateQuantity(itemId, productId, newQty, mode);
            });
            
            input.addEventListener('input', function() {
                const itemId = this.getAttribute('data-item-id');
                const available = parseInt(this.getAttribute('data-available'));
                const currentQty = parseInt(this.value) || 0;
                const errorMsg = document.getElementById('qty-error-' + itemId);
                
                if (currentQty > available) {
                    errorMsg.textContent = 'Tối đa ' + available;
                    errorMsg.style.display = 'block';
                    this.classList.add('is-invalid');
                } else {
                    errorMsg.style.display = 'none';
                    this.classList.remove('is-invalid');
                }
            });
        });
    });
    
    function updateQuantity(itemId, productId, newQty, mode) {
        const input = document.getElementById('qty-' + itemId);
        const available = parseInt(input.getAttribute('data-available'));
        const price = parseInt(input.getAttribute('data-price'));
        const errorMsg = document.getElementById('qty-error-' + itemId);
        
        // Validate
        if (newQty < 1) {
            newQty = 1;
        }
        
        if (newQty > available) {
            showMessage('Số lượng không được vượt quá ' + available + ' sản phẩm còn trong kho', 'error');
            input.value = available;
            newQty = available;
            errorMsg.style.display = 'none';
            input.classList.remove('is-invalid');
        } else {
            errorMsg.style.display = 'none';
            input.classList.remove('is-invalid');
        }
        
        input.value = newQty;
        
        // Cập nhật cảnh báo stock
        const warningDiv = document.getElementById('stock-warning-' + itemId);
        const warningText = document.getElementById('stock-warning-text-' + itemId);
        const row = document.getElementById('row-' + itemId);
        
        if (newQty > available) {
            if (warningDiv) {
                warningDiv.style.display = 'block';
                if (warningText) {
                    warningText.textContent = 'Số lượng đặt (' + newQty + ') vượt quá số lượng còn trong kho (' + available + ')';
                }
            }
            if (row) {
                row.classList.add('table-warning');
            }
        } else {
            if (warningDiv) {
                warningDiv.style.display = 'none';
            }
            if (row) {
                row.classList.remove('table-warning');
            }
        }
        
        // Cập nhật tổng tiền cho item
        const total = price * newQty;
        const totalElement = document.getElementById('total-' + itemId);
        if (totalElement) {
            totalElement.textContent = new Intl.NumberFormat('en-US').format(total) + ' VND';
        }
        
        // Cập nhật tổng tiền chung
        updateGrandTotal();
        
        // Cập nhật trong cart hoặc session
        if (mode === 'CART') {
            // Cập nhật trong cart
            fetch('${ctx}/cart?action=update&cartId=' + itemId + '&quantity=' + newQty, {
                method: 'GET'
            })
            .then(response => response.json())
            .then(data => {
                if (!data.success) {
                    showMessage(data.message || 'Có lỗi xảy ra khi cập nhật số lượng', 'error');
                    // Reload để lấy giá trị đúng
                    location.reload();
                } else {
                    // Cập nhật lại hasStockIssue check và reload để cập nhật UI
                    checkStockIssues();
                    // Reload sau 500ms để cập nhật cảnh báo và UI
                    setTimeout(() => {
                        location.reload();
                    }, 500);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showMessage('Có lỗi xảy ra khi cập nhật số lượng', 'error');
            });
        } else if (mode === 'BUY_NOW') {
            // Cập nhật session bn_qty thông qua PaymentPageServlet
            const formData = new URLSearchParams();
            formData.append('action', 'update-buynow-qty');
            formData.append('qty', newQty);
            
            fetch('${ctx}/payment', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: formData.toString()
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    checkStockIssues();
                    // Reload sau 500ms để cập nhật cảnh báo và UI
                    setTimeout(() => {
                        location.reload();
                    }, 500);
                } else {
                    showMessage(data.message || 'Có lỗi xảy ra khi cập nhật số lượng', 'error');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showMessage('Có lỗi xảy ra khi cập nhật số lượng', 'error');
            });
        }
    }
    
    function updateGrandTotal() {
        let grandTotal = 0;
        document.querySelectorAll('[id^="total-"]').forEach(element => {
            if (element.id !== 'grand-total' && element.id !== 'subtotal-amount') {
                const priceText = element.textContent.replace(/[^\d]/g, '');
                grandTotal += parseInt(priceText) || 0;
            }
        });
        
        const grandTotalElement = document.getElementById('grand-total');
        const subtotalElement = document.getElementById('subtotal-amount');
        
        if (grandTotalElement) {
            grandTotalElement.textContent = new Intl.NumberFormat('en-US').format(grandTotal) + ' VND';
        }
        if (subtotalElement) {
            subtotalElement.textContent = new Intl.NumberFormat('en-US').format(grandTotal) + ' VND';
        }
    }
    
    function checkStockIssues() {
        let hasIssue = false;
        document.querySelectorAll('.quantity-input-payment').forEach(input => {
            const qty = parseInt(input.value) || 0;
            const available = parseInt(input.getAttribute('data-available'));
            if (qty > available) {
                hasIssue = true;
            }
        });
        
        const btnConfirmOrder = document.getElementById('btnConfirmOrder');
        if (btnConfirmOrder) {
            if (hasIssue) {
                btnConfirmOrder.disabled = true;
            } else {
                btnConfirmOrder.disabled = false;
            }
        }
    }
    
    function showMessage(message, type) {
        const alertClass = type === 'success' ? 'alert-success' : 'alert-danger';
        const alertHtml = `
            <div class="alert ${alertClass} alert-dismissible fade show position-fixed" 
                 style="top: 20px; right: 20px; z-index: 9999; max-width: 400px;">
                ${message}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        `;
        document.body.insertAdjacentHTML('beforeend', alertHtml);
        setTimeout(() => {
            const alert = document.querySelector('.alert');
            if (alert) {
                alert.remove();
            }
        }, 3000);
    }
</script>

<%@ include file="/WEB-INF/include/footer.jsp" %>
