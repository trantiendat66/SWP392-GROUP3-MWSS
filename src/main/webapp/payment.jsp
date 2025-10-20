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

    <h3 class="mb-3">Xác nhận thanh toán</h3>

    <!-- Banner buy-now: đang mua nhanh, chưa thêm vào giỏ -->
    <c:if test="${not empty sessionScope.bn_pid}">
        <div class="alert alert-warning d-flex justify-content-between align-items-center">
            <div>
                <strong>Buy now:</strong> Bạn đang mua nhanh 1 sản phẩm (chưa thêm vào giỏ).
                Nếu bạn quay lại hoặc hủy, sản phẩm sẽ được thêm vào giỏ hàng của bạn.
            </div>
            <form action="${ctx}/payment/cancel-buynow" method="post" class="ms-3">
                <button type="submit" class="btn btn-sm btn-outline-dark">Hủy mua nhanh</button>
            </form>
        </div>
    </c:if>

    <c:choose>
        <c:when test="${empty cartItems}">
            <div class="alert alert-info">Giỏ hàng trống. Vui lòng thêm sản phẩm trước khi thanh toán.</div>
            <a href="${ctx}/home" class="btn btn-primary">Tiếp tục mua sắm</a>
        </c:when>

        <c:otherwise>
            <div class="row g-4">
                <!-- Tóm tắt giỏ / buy-now -->
                <div class="col-lg-8">
                    <div class="table-responsive">
                        <table class="table align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th style="width:70px;">Ảnh</th>
                                    <th>Sản phẩm</th>
                                    <th class="text-center" style="width:120px;">Số lượng</th>
                                    <th class="text-end">Đơn giá</th>
                                    <th class="text-end">Thành tiền</th>
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
                                        <td class="text-end text-muted"><fmt:formatNumber value="${item.price}" type="number"/> VNĐ</td>
                                        <td class="text-end fw-semibold"><fmt:formatNumber value="${item.totalPrice}" type="number"/> VNĐ</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                            <tfoot>
                                <tr>
                                    <th colspan="4" class="text-end">Tổng cộng:</th>
                                    <th class="text-end text-danger fs-5">
                                        <fmt:formatNumber value="${totalAmount}" type="number"/> VNĐ
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
                                <button type="submit" class="btn btn-outline-secondary">← Quay lại giỏ hàng</button>
                            </form>
                        </c:when>
                        <c:otherwise>
                            <a href="${ctx}/cart" class="btn btn-outline-secondary">← Quay lại giỏ hàng</a>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Form giao hàng & thanh toán -->
                <div class="col-lg-4">
                    <div class="card">
                        <div class="card-body">
                            <h5 class="card-title mb-3">Thông tin giao hàng</h5>

                            <form action="${ctx}/order/create-from-cart" method="post">
                                <div class="mb-2">
                                    <label class="form-label">Số điện thoại</label>
                                    <input type="text" name="phone" value="${sessionScope.customer.phone}"
                                           class="form-control" placeholder="Số điện thoại">
                                </div>

                                <div class="mb-2">
                                    <label class="form-label">Địa chỉ nhận hàng</label>
                                    <input type="text" name="shipping_address" class="form-control"
                                           placeholder="Địa chỉ nhận hàng" required>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Thanh toán</label>
                                    <select name="payment_method" class="form-select">
                                        <option value="0">COD (chưa thanh toán)</option>
                                        <option value="1">Đã thanh toán online</option>
                                    </select>
                                </div>

                                <button type="submit" class="btn btn-primary w-100">Xác nhận đặt hàng</button>
                            </form>

                            <hr>
                            <div class="d-flex justify-content-between">
                                <span>Tổng tiền hàng</span>
                                <strong class="text-danger">
                                    <fmt:formatNumber value="${totalAmount}" type="number"/> VNĐ
                                </strong>
                            </div>
                            <small class="text-muted d-block mt-2">Phí vận chuyển sẽ tính ở bước sau (nếu áp dụng).</small>
                        </div>
                    </div>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<%@ include file="/WEB-INF/include/footer.jsp" %>
