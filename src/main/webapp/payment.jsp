<%-- 
    Document   : payment
    Created on : Oct 16, 2025, 12:29:54 PM
    Author     : Oanh Nguyen
--%>

<%-- payment.jsp: Xác nhận thanh toán --%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt" %>
<%@ include file="/WEB-INF/include/header.jsp" %>
<head>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <style>
        .payment-table th,
        .payment-table td {
            vertical-align: middle;
        }

        .payment-table .product-col {
            min-width: 260px;
        }

        .payment-table .qty-col {
            width: 140px;
        }

        .payment-table .price-col,
        .payment-table .total-col {
            min-width: 180px;
            white-space: nowrap;
        }
    </style>
</head>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<div class="container my-4">
    <c:if test="${not empty requestScope.error}">
        <div class="alert alert-danger">${requestScope.error}</div>
    </c:if>
    <!-- Hiển thị lỗi từ session (ví dụ redirect từ MoMoReturnServlet) rồi xóa để tránh hiển thị lại -->
    <c:if test="${not empty sessionScope.error}">
        <div class="alert alert-danger">${sessionScope.error}</div>
        <c:remove var="error" scope="session"/>
    </c:if>
    <c:if test="${not empty sessionScope.flash_success}">
        <div class="alert alert-success">${sessionScope.flash_success}</div>
        <c:remove var="flash_success" scope="session"/>
    </c:if>

    <h3 class="mb-3">Payment Confirmation</h3>

    <c:choose>
        <c:when test="${empty cartItems}">
            <div class="alert alert-info">Your cart is empty. Please add products before checkout.</div>
            <a href="${ctx}/home" class="btn btn-primary">Continue Shopping</a>
        </c:when>

        <c:otherwise>
            <div class="row g-4">
                <!-- Tóm tắt giỏ / buy-now -->
                <div class="col-lg-8">
                    <div class="table-responsive">
                        <table class="table align-middle payment-table">
                            <thead class="table-light">
                                <tr>
                                    <th style="width:70px;">Image</th>
                                    <th class="product-col">Product</th>
                                    <th class="text-center qty-col">Quantity</th>
                                    <th class="text-end price-col">Unit Price</th>
                                    <th class="text-end total-col">Subtotal</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="item" items="${cartItems}">
                                    <tr>
                                        <td>
                                            <img src="${ctx}/assert/image/${item.productImage}" class="img-thumbnail"
                                                 style="width:64px;height:64px;object-fit:cover" alt="${item.productName}">
                                        </td>
                                        <td class="product-col">
                                            <div class="fw-semibold">${item.productName}</div>
                                            <small class="text-muted">Brand: ${item.brand}</small>
                                        </td>
                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${not empty sessionScope.bn_pid}">
                                                    <!-- Buy Now mode: cho phép chỉnh số lượng -->
                                                    <div class="d-flex align-items-center justify-content-center gap-2">
                                                        <input type="number" 
                                                               class="form-control form-control-sm buynow-qty-input" 
                                                               style="width:80px; text-align:center;"
                                                               value="${item.quantity}" 
                                                               min="1" 
                                                               max="${item.availableQuantity}"
                                                               data-product-id="${item.productId}"
                                                               data-unit-price="${item.price}">
                                                        <span class="text-muted">/ ${item.availableQuantity}</span>
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <!-- Cart mode: chỉ hiển thị -->
                                                    ${item.quantity}
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-end text-muted price-col"><fmt:formatNumber value="${item.price}" type="number"/> VND</td>
                                        <td class="text-end fw-semibold total-col buynow-subtotal" data-unit-price="${item.price}">
                                            <fmt:formatNumber value="${item.totalPrice}" type="number"/> VND
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                            <tfoot>
                                <tr>
                                    <th colspan="4" class="text-end">Total:</th>
                                    <th class="text-end text-danger fs-5" id="payment-total">
                                        <fmt:formatNumber value="${totalAmount}" type="number"/> VND
                                    </th>
                                </tr>
                            </tfoot>
                        </table>
                    </div>

                    <!-- Nút quay lại:
                         - Nếu đang buy-now (sessionScope.bn_pid có) => POST /payment/cancel-buynow để về /home (không thêm vào giỏ)
                         - Ngược lại => chỉ link về /cart -->
                    <c:choose>
                        <c:when test="${not empty sessionScope.bn_pid}">
                            <form action="${ctx}/payment/cancel-buynow" method="post" class="d-inline">
                                <button type="submit" class="btn btn-outline-secondary">← Back to Home</button>
                            </form>
                        </c:when>
                        <c:otherwise>
                            <a href="${ctx}/cart" class="btn btn-outline-secondary">← Back to Cart</a>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Form giao hàng & thanh toán -->
                <div class="col-lg-4">
                    <div class="card">
                        <div class="card-body">
                            <h5 class="card-title mb-3">Shipping Information</h5>

                            <form id="orderForm" action="${ctx}/order/create-from-cart" method="post">
                                <div class="mb-2">
                                     <label class="form-label">Phone Number</label>
                                     <input type="text" name="phone" value="${sessionScope.customer.phone}"
                                         class="form-control" placeholder="Phone number">
                                </div>

                                <div class="mb-2">
                                     <label class="form-label">Shipping Address</label>
                                     <input type="text" name="shipping_address" class="form-control"
                                         placeholder="Shipping address" required>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Payment</label>
                                    <select id="payment-method-select" name="payment_method" class="form-select">
                                        <option value="0">COD (Cash on Delivery)</option>
                                        <option value="2">MoMo Payment (Online)</option>
                                    </select>
                                    <div id="momo-warning" class="alert alert-warning mt-2 py-2 px-3 d-none" style="font-size: .85rem;">
                                        Lưu ý: Đơn hàng thanh toán qua <strong>MoMo</strong> sẽ không thể hủy sau khi đặt.
                                    </div>
                                </div>

                                <button id="submitBtn" type="submit" class="btn btn-primary w-100">Place Order</button>
                            </form>

                            <hr>
                            <div class="d-flex justify-content-between">
                                <span>Order Total</span>
                                <strong class="text-danger" id="order-total-sidebar">
                                    <fmt:formatNumber value="${totalAmount}" type="number"/> VND
                                </strong>
                            </div>
                            <small class="text-muted d-block mt-2">Shipping fee will be calculated later (if applicable).</small>
                        </div>
                    </div>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<script>
    // Switch form target between COD and MoMo based on selected payment method
    document.addEventListener('DOMContentLoaded', function() {
        const orderForm = document.getElementById('orderForm');
        const paymentMethodSelect = document.getElementById('payment-method-select');
        const submitBtn = document.getElementById('submitBtn');

        function applyPaymentTarget() {
            const selectedMethod = paymentMethodSelect ? paymentMethodSelect.value : '0';
            if (!orderForm || !submitBtn) return;
            if (selectedMethod === '2') {
                // MoMo payment
                orderForm.action = '${ctx}/momo/payment';
                submitBtn.textContent = 'Pay with MoMo';
                document.getElementById('momo-warning')?.classList.remove('d-none');
            } else {
                // COD
                orderForm.action = '${ctx}/order/create-from-cart';
                submitBtn.textContent = 'Place Order';
                document.getElementById('momo-warning')?.classList.add('d-none');
            }
        }

        if (paymentMethodSelect) {
            paymentMethodSelect.addEventListener('change', applyPaymentTarget);
            // Initialize on first load
            applyPaymentTarget();
        }

        // Xử lý chỉnh số lượng khi Buy Now
        const buyNowQtyInputs = document.querySelectorAll('.buynow-qty-input');
        if (buyNowQtyInputs.length > 0) {
            buyNowQtyInputs.forEach(input => {
                input.addEventListener('change', function() {
                    const qty = parseInt(this.value) || 1;
                    const maxQty = parseInt(this.getAttribute('max')) || 1;
                    const unitPrice = parseInt(this.getAttribute('data-unit-price')) || 0;
                    const productId = this.getAttribute('data-product-id');
                    
                    // Validate số lượng
                    let finalQty = qty;
                    if (finalQty < 1) {
                        finalQty = 1;
                        this.value = 1;
                    }
                    if (finalQty > maxQty) {
                        finalQty = maxQty;
                        this.value = maxQty;
                    }

                    // Cập nhật subtotal
                    const subtotal = finalQty * unitPrice;
                    const subtotalCell = this.closest('tr').querySelector('.buynow-subtotal');
                    if (subtotalCell) {
                        subtotalCell.textContent = subtotal.toLocaleString('vi-VN') + ' VND';
                    }

                    // Cập nhật tổng tiền
                    updateTotalAmount();

                    // Gửi request cập nhật số lượng lên server
                    updateBuyNowQuantity(productId, finalQty);
                });
            });
        }

        function updateTotalAmount() {
            const subtotals = document.querySelectorAll('.buynow-subtotal');
            let total = 0;
            subtotals.forEach(cell => {
                const text = cell.textContent.replace(/[^\d]/g, '');
                total += parseInt(text) || 0;
            });
            const totalCell = document.getElementById('payment-total');
            if (totalCell) {
                totalCell.textContent = total.toLocaleString('vi-VN') + ' VND';
            }
            // Cập nhật Order Total trong sidebar
            const orderTotalSidebar = document.getElementById('order-total-sidebar');
            if (orderTotalSidebar) {
                orderTotalSidebar.textContent = total.toLocaleString('vi-VN') + ' VND';
            }
        }

        function updateBuyNowQuantity(productId, qty) {
            const formData = new FormData();
            formData.append('action', 'update-buynow-qty');
            formData.append('qty', qty);

            fetch('${ctx}/payment', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                if (!data.success) {
                    console.error('Failed to update quantity:', data.message);
                    // Reload trang để đồng bộ lại
                    window.location.reload();
                }
            })
            .catch(error => {
                console.error('Error updating quantity:', error);
            });
        }
    });
</script>
<%@ include file="/WEB-INF/include/footer.jsp" %>
