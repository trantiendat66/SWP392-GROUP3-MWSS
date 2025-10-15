<%-- 
    Document   : Cart Page
    Created on : Jan 10, 2025
    Author     : Dang Vi Danh - CE19687
--%>

<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ include file="/WEB-INF/include/header.jsp" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<div class="container my-4">

    <!-- flash / error -->
    <c:if test="${not empty requestScope.error}">
        <div class="alert alert-danger">${requestScope.error}</div>
    </c:if>
    <c:if test="${not empty sessionScope.flash_success}">
        <div class="alert alert-success">${sessionScope.flash_success}</div>
        <c:remove var="flash_success" scope="session"/>
    </c:if>

    <h3 class="mb-3">Giỏ hàng của bạn</h3>

    <c:choose>
        <c:when test="${not empty cartItems}">
            <div class="row g-4">
                <div class="col-lg-8">
                    <div class="table-responsive">
                        <table class="table align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th style="width:70px;">Ảnh</th>
                                    <th>Sản phẩm</th>
                                    <th class="text-end">Giá</th>
                                    <th class="text-center" style="width:120px;">Số lượng</th>
                                    <th class="text-end">Thành tiền</th>
                                    <th class="text-center" style="width:80px;">Xoá</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:set var="grand" value="0" scope="page"/>
                                <c:forEach var="item" items="${cartItems}">
                                    <tr>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty item.productImage}">
                                                    <img src="${ctx}/assert/image/${item.productImage}" class="img-thumbnail" style="width:64px;height:64px;object-fit:cover">
                                                </c:when>
                                                <c:otherwise>
                                                    <img src="${ctx}/assert/image/no-image.png" class="img-thumbnail" style="width:64px;height:64px;object-fit:cover">
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <div class="fw-semibold">${fn:escapeXml(item.productName)}</div>
                                            <small class="text-muted">Brand: ${fn:escapeXml(item.brand)}</small>
                                        </td>
                                        <td class="text-end text-danger">${item.price} VNĐ</td>
                                        <td class="text-center">${item.quantity}</td>
                                        <td class="text-end fw-semibold">${item.totalPrice} VNĐ</td>
                                        <td class="text-center">
                                            <form action="${ctx}/cart" method="get">
                                                <input type="hidden" name="action" value="remove">
                                                <input type="hidden" name="cartId" value="${item.cartId}">
                                                <button type="submit" class="btn btn-sm btn-outline-danger">
                                                    <i class="bi bi-trash"></i>
                                                </button>
                                            </form>
                                        </td>
                                    </tr>
                                    <c:set var="grand" value="${grand + item.totalPrice}" scope="page"/>
                                </c:forEach>
                            </tbody>
                            <tfoot>
                                <tr>
                                    <th colspan="4" class="text-end">Tổng cộng:</th>
                                    <th class="text-end text-danger fs-5">${grand} VNĐ</th>
                                    <th></th>
                                </tr>
                            </tfoot>
                        </table>
                    </div>

                    <a href="${ctx}/" class="btn btn-outline-secondary">
                        ← Tiếp tục mua sắm
                    </a>
                </div>

                <!-- Summary + Checkout -->
                <div class="col-lg-4">
                    <div class="card">
                        <div class="card-body">
                            <h5 class="card-title mb-3">Thanh toán</h5>

                            <c:choose>
                                <c:when test="${not empty sessionScope.customer}">
                                    <form action="${ctx}/order/create-from-cart" method="post">
                                        <div class="mb-2">
                                            <label class="form-label">Số điện thoại</label>
                                            <input type="text" name="phone" value="${sessionScope.customer.phone}"
                                                   class="form-control" placeholder="Số điện thoại">
                                        </div>

                                        <div class="mb-2">
                                            <label class="form-label">Địa chỉ nhận hàng</label>
                                            <input type="text" name="shipping_address" class="form-control" placeholder="Địa chỉ nhận hàng" required>
                                        </div>

                                        <div class="mb-3">
                                            <label class="form-label">Phương thức thanh toán</label>
                                            <select name="payment_method" class="form-select">
                                                <option value="0">Thanh toán khi nhận (COD)</option>
                                                <option value="1">VNPAY (sắp có)</option>
                                                <option value="1">MOMO (sắp có)</option>
                                            </select>
                                        </div>

                                        <button type="submit" class="btn btn-primary w-100"
                                                <c:if test="${grand == 0}">disabled</c:if>>
                                                    Đặt hàng
                                                </button>
                                        </form>
                                </c:when>

                                <c:otherwise>
                                    <a class="btn btn-outline-primary w-100"
                                       href="${ctx}/login.jsp?next=cart">
                                        Đăng nhập để đặt hàng
                                    </a>
                                </c:otherwise>
                            </c:choose>

                            <hr>
                            <div class="d-flex justify-content-between">
                                <span>Tổng tiền hàng</span>
                                <strong class="text-danger">${grand} VNĐ</strong>
                            </div>
                            <small class="text-muted d-block mt-2">Phí vận chuyển sẽ tính ở bước sau (nếu áp dụng).</small>
                        </div>
                    </div>
                </div>
            </div>
        </c:when>

        <c:otherwise>
            <div class="alert alert-info">Giỏ hàng của bạn đang trống.</div>
            <a href="${ctx}/" class="btn btn-primary mt-2">Mua sắm ngay</a>
        </c:otherwise>
    </c:choose>
</div>

<%@ include file="/WEB-INF/include/footer.jsp" %>
