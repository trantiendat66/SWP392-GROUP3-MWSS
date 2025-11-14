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

    <!-- Buy-now banner: direct single item purchase not yet in cart -->
    <c:if test="${not empty sessionScope.bn_pid}">
        <div class="alert alert-warning d-flex justify-content-between align-items-center">
            <div>
                <strong>Buy now:</strong> You are buying one item directly (not yet in cart).
                If you go back or cancel, the item will be added to your cart.
            </div>
            <form action="${ctx}/payment/cancel-buynow" method="post" class="ms-3">
                <button type="submit" class="btn btn-sm btn-outline-dark">Cancel Direct Purchase</button>
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
                                        <td class="text-center">${item.quantity}</td>
                                        <td class="text-end text-muted price-col"><fmt:formatNumber value="${item.price}" type="number"/> VND</td>
                                        <td class="text-end fw-semibold total-col"><fmt:formatNumber value="${item.totalPrice}" type="number"/> VND</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                            <tfoot>
                                <tr>
                                    <th colspan="4" class="text-end">Total:</th>
                                    <th class="text-end text-danger fs-5">
                                        <fmt:formatNumber value="${totalAmount}" type="number"/> VND
                                    </th>
                                </tr>
                            </tfoot>
                        </table>
                    </div>

                    <!-- Nút quay lại:
                         - Nếu đang buy-now (sessionScope.bn_pid có) => POST /payment/cancel-buynow để add vào giỏ rồi về /cart
                         - Ngược lại => chỉ link về /cart -->
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
                                </div>

                                <button id="submitBtn" type="submit" class="btn btn-primary w-100">Place Order</button>
                            </form>

                            <hr>
                            <div class="d-flex justify-content-between">
                                <span>Order Total</span>
                                <strong class="text-danger">
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
            } else {
                // COD
                orderForm.action = '${ctx}/order/create-from-cart';
                submitBtn.textContent = 'Place Order';
            }
        }

        if (paymentMethodSelect) {
            paymentMethodSelect.addEventListener('change', applyPaymentTarget);
            // Initialize on first load
            applyPaymentTarget();
        }
    });
</script>
<%@ include file="/WEB-INF/include/footer.jsp" %>
