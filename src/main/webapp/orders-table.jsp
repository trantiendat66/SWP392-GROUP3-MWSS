<%--  
    Document   : orders-table
    Created on : Oct 18, 2025, 12:35:39 PM
    Author     : Oanh Nguyen
--%>

<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<c:set var="title" value="${param.title}" />
<c:set var="listAttr" value="${param.listAttr}" />
<c:set var="orders" value="${requestScope[listAttr]}" />
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<h5 class="mb-3">${title}</h5>

<c:choose>
    <c:when test="${empty orders}">
        <div class="alert alert-info">Không có đơn hàng.</div>
    </c:when>
    <c:otherwise>
        <div class="accordion" id="acc-${listAttr}">
            <c:forEach var="o" items="${orders}">
                <div class="accordion-item mb-2">
                    <h2 class="accordion-header" id="h-${listAttr}-${o.order_id}">
                        <button class="accordion-button collapsed" type="button"
                                data-bs-toggle="collapse"
                                data-bs-target="#c-${listAttr}-${o.order_id}">
                            <div class="w-100">
                                <div class="d-flex justify-content-between">
                                    <span>
                                        <strong>#${o.order_id}</strong> •
                                        <%-- HIỂN THỊ NGÀY: nếu DELIVERED và có delivered_at thì dùng delivered_at, ngược lại dùng order_date (String) --%>
                                        <c:choose>
                                            <c:when test="${o.order_status eq 'DELIVERED' and o.delivered_at ne null}">
                                                <fmt:formatDate value="${o.delivered_at}" pattern="yyyy-MM-dd HH:mm:ss"/>
                                            </c:when>
                                            <c:otherwise>
                                                ${o.order_date}
                                            </c:otherwise>
                                        </c:choose>
                                        <span class="badge bg-secondary ms-2">${o.order_status}</span>
                                    </span>
                                    <span class="text-danger">
                                        <fmt:formatNumber value="${o.total_amount}" type="number"/> VNĐ
                                    </span>
                                </div>
                                <small class="text-muted">
                                    ${o.shipping_address} | ${o.phone} |
                                    Thanh toán: <c:out value="${o.payment_method == 1 ? 'Đã thanh toán' : 'COD'}"/>
                                </small>
                            </div>
                        </button>
                    </h2>

                    <div id="c-${listAttr}-${o.order_id}" class="accordion-collapse collapse"
                         data-bs-parent="#acc-${listAttr}">
                        <div class="accordion-body p-0">
                            <table class="table mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th style="width:70px;">Ảnh</th>
                                        <th>Sản phẩm</th>
                                        <th class="text-center" style="width:100px;">SL</th>
                                        <th class="text-end">Đơn giá</th>
                                        <th class="text-end">Thành tiền</th>
                                            <%-- FEEDBACK: thêm cột "Đánh giá" --%>
                                        <th class="text-end" style="width:140px;">Đánh giá</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="it" items="${itemsMap[o.order_id]}">
                                        <tr>
                                            <td>
                                                <img src="${ctx}/assert/image/${it.image}"
                                                     class="img-thumbnail"
                                                     style="width:60px;height:60px;object-fit:cover"
                                                     alt="${it.productName}">
                                            </td>
                                            <td>${it.productName}</td>
                                            <td class="text-center">${it.quantity}</td>
                                            <td class="text-end"><fmt:formatNumber value="${it.unitPrice}" type="number"/> VNĐ</td>
                                            <td class="text-end"><fmt:formatNumber value="${it.totalPrice}" type="number"/> VNĐ</td>

                                            <td class="text-end">
                                                <c:set var="__pid" value="${it.productId}" />
                                                <c:set var="__key" value="${o.order_id}:${__pid}" />

                                                <c:choose>
                                                    <c:when test="${not empty eligibleKeys && eligibleKeys.contains(__key)}">
                                                        <button type="button"
                                                                class="btn btn-sm btn-outline-primary"
                                                                data-bs-toggle="modal"
                                                                data-bs-target="#fbModal-${o.order_id}-${__pid}">
                                                            Đánh giá
                                                        </button>

                                                        <!-- Modal -->
                                                        <div class="modal fade" id="fbModal-${o.order_id}-${__pid}" tabindex="-1" aria-hidden="true">
                                                            <div class="modal-dialog">
                                                                <div class="modal-content">
                                                                    <div class="modal-header">
                                                                        <h5 class="modal-title">Đánh giá sản phẩm</h5>
                                                                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                                    </div>
                                                                    <div class="modal-body">
                                                                        <form action="${ctx}/feedback/create" method="post" class="feedback-form">
                                                                            <input type="hidden" name="order_id" value="${o.order_id}">
                                                                            <input type="hidden" name="product_id" value="${__pid}">

                                                                            <div class="mb-2">
                                                                                <label class="form-label">Đánh giá</label>
                                                                                <div class="d-flex gap-2">
                                                                                    <label><input type="radio" name="rating" value="5" checked> 5★</label>
                                                                                    <label><input type="radio" name="rating" value="4"> 4★</label>
                                                                                    <label><input type="radio" name="rating" value="3"> 3★</label>
                                                                                    <label><input type="radio" name="rating" value="2"> 2★</label>
                                                                                    <label><input type="radio" name="rating" value="1"> 1★</label>
                                                                                </div>
                                                                            </div>

                                                                            <div class="mb-2">
                                                                                <label class="form-label">Nhận xét
                                                                                    <small class="text-muted comment-req d-none">(bắt buộc nếu &lt; 5★)</small>
                                                                                </label>
                                                                                <textarea name="comment" class="form-control" rows="3"></textarea>
                                                                                <div class="form-text text-danger d-none comment-help"></div>
                                                                            </div>

                                                                            <button type="submit" class="btn btn-primary">Gửi đánh giá</button>
                                                                        </form>
                                                                    </div>
                                                                    <div class="modal-footer">
                                                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                                                                        <button type="submit" class="btn btn-primary"
                                                                                onclick="submitFeedback('${o.order_id}', '${__pid}')">Gửi đánh giá</button>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">—</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>

                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </c:otherwise>
</c:choose>
