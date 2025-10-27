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
                        <button class="accordion-button collapsed js-acc-btn" type="button"
                                data-target="#c-${listAttr}-${o.order_id}">
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
                         >
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
                                                        <!-- Nút mở modal -->
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

                                                                            <!-- Đánh giá -->
                                                                            <div class="mb-3 text-start">
                                                                                <label class="form-label mb-2">Đánh giá</label>

                                                                                <%-- star picker: 1 hàng ngôi sao, click để chọn số sao --%>
                                                                                <div class="momo-stars" dir="rtl">
                                                                                    <c:set var="__suf" value="${o.order_id}-${__pid}" />
                                                                                    <input type="radio" name="rating" id="s5-${__suf}" value="5" checked>
                                                                                    <label for="s5-${__suf}" title="5 sao">★</label>

                                                                                    <input type="radio" name="rating" id="s4-${__suf}" value="4">
                                                                                    <label for="s4-${__suf}" title="4 sao">★</label>

                                                                                    <input type="radio" name="rating" id="s3-${__suf}" value="3">
                                                                                    <label for="s3-${__suf}" title="3 sao">★</label>

                                                                                    <input type="radio" name="rating" id="s2-${__suf}" value="2">
                                                                                    <label for="s2-${__suf}" title="2 sao">★</label>

                                                                                    <input type="radio" name="rating" id="s1-${__suf}" value="1">
                                                                                    <label for="s1-${__suf}" title="1 sao">★</label>
                                                                                </div>
                                                                            </div>

                                                                            <div class="mb-2 text-start">
                                                                                <label class="form-label fw-semibold d-block text-start mb-2">Nhận xét</label>
                                                                                <textarea name="comment" class="form-control fb-comment" rows="4"
                                                                                          placeholder="Nhập nội dung đánh giá (không bắt buộc – vui lòng gõ tiếng Việt có dấu)…"></textarea>
                                                                                <div class="form-text text-danger d-none comment-help"></div>
                                                                            </div>



                                                                            <button type="submit" class="btn btn-primary">Gửi đánh giá</button>
                                                                        </form>
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

        <style>
            /* star row */
            .momo-stars {
                display:inline-flex;
                gap:6px;
                font-size: 28px;
                line-height:1;
                user-select:none;
            }
            .momo-stars input {
                display:none;
            }
            .momo-stars label {
                color:#d6d9dd;        /* xám nhạt (sao rỗng) */
                cursor:pointer;
                transition: transform .05s ease-in;
            }
            /* tô màu tất cả sao bên trái sao được chọn (dùng dir=rtl + ~ selector) */
            .momo-stars input:checked ~ label,
            .momo-stars label:hover,
            .momo-stars label:hover ~ label {
                color:#f59f00;        /* vàng cam */
            }
            .momo-stars label:active {
                transform: scale(.95);
            }
        </style>

    </c:otherwise>
</c:choose>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        document.querySelectorAll('.feedback-form').forEach(function (form) {
            form.addEventListener('submit', function (e) {
                const rating = parseInt(form.querySelector('input[name="rating"]:checked')?.value || '5', 10);
                const cmt = form.querySelector('.fb-comment');
                const help = form.querySelector('.fb-help');

                if (rating < 5 && (!cmt.value || cmt.value.trim().length === 0)) {
                    e.preventDefault();
                    help.classList.remove('d-none');
                    cmt.focus();
                } else {
                    help?.classList.add('d-none');
                }
            });
        });
    });
</script>
