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
                                    <th class="text-end">Unit Price</th>
                                    <th class="text-end">Total</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="item" items="${cartItems}">
                                    <tr>
                                        <td>
                                            <img src="${ctx}/assert/image/${item.productImage}" class="img-thumbnail"
                                                 style="width:64px;height:64px;object-fit:cover" alt="${item.productName}">
                                        </td>
                                        <td>
                                            <div class="fw-semibold">${item.productName}</div>
                                            <small class="text-muted">Brand: ${item.brand}</small>
                                        </td>
                                        <td class="text-center">${item.quantity}</td>
                                        <td class="text-end text-muted"><fmt:formatNumber value="${item.price}" type="number"/> VND</td>
                                        <td class="text-end fw-semibold"><fmt:formatNumber value="${item.totalPrice}" type="number"/> VND</td>
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

                            <form action="${ctx}/order/create-from-cart" method="post">
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
                                    <label class="form-label">Payment Method</label>
                                    <select name="payment_method" class="form-select">
                                        <option value="0">COD (Cash on Delivery)</option>
                                        <option value="1">Paid Online</option>
                                    </select>
                                </div>

                                <button type="submit" class="btn btn-primary w-100">Confirm Order</button>
                            </form>

                            <hr>
                            <div class="d-flex justify-content-between">
                                <span>Subtotal</span>
                                <strong class="text-danger">
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

<%@ include file="/WEB-INF/include/footer.jsp" %>
