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

<div class="container-fluid">
    <div class="row mb-3">
        <div class="col-8">
            <h3 class="mb-0">${title}</h3>
        </div>
    </div>

    <c:choose>
        <c:when test="${empty orders}">
            <div class="alert alert-info">No orders.</div>
        </c:when>
        <c:otherwise>

            <div class="list-group">
                <c:forEach var="o" items="${orders}">

                    <div class="list-group-item mb-2 shadow-sm">
                        <!-- header row: left = id/date/status/address, right = total + chevron -->
                        <div class="d-flex align-items-start justify-content-between">
                            <div class="me-3 flex-grow-1">
                                <div class="d-flex align-items-center gap-2 flex-wrap">
                                    <div class="fw-bold">#${o.order_id}</div>

                                    <div class="text-muted">•</div>

                                    <div class="text-muted"> 
                                        <c:choose>
                                            <c:when test="${o.order_status eq 'DELIVERED' and o.delivered_at ne null}">
                                                <fmt:formatDate value="${o.delivered_at}" pattern="yyyy-MM-dd HH:mm:ss"/>
                                            </c:when>
                                            <c:otherwise>
                                                ${o.order_date}
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                    <span class="badge bg-secondary ms-2">${o.order_status}</span>
                                </div>

                                <div class="small text-muted mt-1">
                                    ${o.shipping_address} | ${o.phone} | Payment:
                                    <c:choose>
                                        <c:when test="${o.payment_method == 0}">COD</c:when>
                                        <c:when test="${o.payment_method == 1}">MoMo</c:when>
                                        <c:otherwise>Other</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <div class="text-end ms-3" style="min-width:170px;">

                                <div class="mt-2">
                                    <c:choose>
                                        <c:when test="${o.order_status eq 'PENDING' && o.payment_method == 0}">
                                            <form action="${ctx}/order/cancel" method="post" class="d-inline" onsubmit="return confirm('Bạn chắc chắn muốn hủy đơn #${o.order_id}?');">
                                                <input type="hidden" name="orderId" value="${o.order_id}"/>
                                                <button type="submit" class="btn btn-sm btn-outline-danger">Cancel Order</button>
                                            </form>
                                        </c:when>
                                        <c:when test="${o.order_status eq 'PENDING' && o.payment_method != 0}">
                                            <span class="badge bg-warning text-dark" title="MoMo orders cannot be cancelled">No Cancel (MoMo)</span>
                                        </c:when>
                                        <c:when test="${o.order_status eq 'CANCELLED'}">
                                            <span class="badge bg-danger-subtle text-danger">Cancelled</span>
                                        </c:when>
                                    </c:choose>
                                </div>
                            </div>
                        </div>

                        <!-- collapsible items table -->
                        <div class="mt-3">
                            <div class="table-responsive">
                                <table class="table table-borderless align-middle mb-0">
                                    <thead class="table-light">
                                        <tr>
                                            <th style="width:70px">Image</th>
                                            <th>Product</th>
                                            <th class="text-center" style="width:80px">Qty</th>
                                            <th class="text-end" style="width:140px">Unit Price</th>
                                            <th class="text-end" style="width:140px">Total</th>
                                            <th class="text-end" style="width:160px">Review</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="it" items="${itemsMap[o.order_id]}">
                                            <tr>
                                                <td>
                                                    <img src="${ctx}/assert/image/${it.image}" alt="${it.productName}" class="img-thumbnail" style="width:60px;height:60px;object-fit:cover">
                                                </td>
                                                <td>
                                                    <a href="${ctx}/productdetail?id=${it.productId}" class="text-decoration-none">
                                                        ${it.productName}
                                                    </a>
                                                </td>
                                                <td class="text-center">${it.quantity}</td>
                                                <td class="text-end"><fmt:formatNumber value="${it.unitPrice}" type="number"/> VND</td>
                                                <td class="text-end"><fmt:formatNumber value="${it.totalPrice}" type="number"/> VND</td>
                                                <td class="text-end">
                                                    <c:set var="__pid" value="${it.productId}" />
                                                    <c:set var="__key" value="${o.order_id}:${__pid}" />

                                                    <c:choose>
                                                        <c:when test="${not empty feedbackMap && feedbackMap.containsKey(__key)}">
                                                            <c:set var="fb" value="${feedbackMap[__key]}" />
                                                            <c:choose>
                                                                <c:when test="${fb.can_edit}">
                                                                    <div class="d-flex gap-2 justify-content-end">
                                                                        <button type="button" class="btn btn-sm btn-outline-warning flex-fill" data-bs-toggle="modal" data-bs-target="#fbEditModal-${fb.feedback_id}">
                                                                            <i class="bi bi-pencil-square"></i> Edit
                                                                        </button>

                                                                        <form action="${ctx}/feedback/delete" method="post" class="m-0 flex-fill" onsubmit="return confirm('Are you sure you want to delete this review?');">
                                                                            <input type="hidden" name="feedback_id" value="${fb.feedback_id}">
                                                                            <button type="submit" class="btn btn-sm btn-outline-danger w-100">
                                                                                <i class="bi bi-trash"></i> Delete
                                                                            </button>
                                                                        </form>
                                                                    </div>

                                                                    <!-- Edit modal (kept as-is) -->
                                                                    <div class="modal fade" id="fbEditModal-${fb.feedback_id}" tabindex="-1" aria-hidden="true">
                                                                        <div class="modal-dialog">
                                                                            <div class="modal-content">
                                                                                <div class="modal-header">
                                                                                    <h5 class="modal-title">Edit Your Feedback</h5>
                                                                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                                                </div>
                                                                                <div class="modal-body">
                                                                                    <form action="${ctx}/feedback/edit" method="post" class="feedback-form">
                                                                                        <input type="hidden" name="feedback_id" value="${fb.feedback_id}">
                                                                                        <div class="mb-3 text-start">
                                                                                            <label class="form-label mb-2">Rating</label>
                                                                                            <div class="momo-stars" dir="rtl">
                                                                                                <c:set var="__edit_suf" value="edit-${fb.feedback_id}" />
                                                                                                <input type="radio" name="rating" id="s5-${__edit_suf}" value="5" ${fb.rating == 5 ? 'checked' : ''}>
                                                                                                <label for="s5-${__edit_suf}" title="5 stars">★</label>
                                                                                                <input type="radio" name="rating" id="s4-${__edit_suf}" value="4" ${fb.rating == 4 ? 'checked' : ''}>
                                                                                                <label for="s4-${__edit_suf}" title="4 stars">★</label>
                                                                                                <input type="radio" name="rating" id="s3-${__edit_suf}" value="3" ${fb.rating == 3 ? 'checked' : ''}>
                                                                                                <label for="s3-${__edit_suf}" title="3 stars">★</label>
                                                                                                <input type="radio" name="rating" id="s2-${__edit_suf}" value="2" ${fb.rating == 2 ? 'checked' : ''}>
                                                                                                <label for="s2-${__edit_suf}" title="2 stars">★</label>
                                                                                                <input type="radio" name="rating" id="s1-${__edit_suf}" value="1" ${fb.rating == 1 ? 'checked' : ''}>
                                                                                                <label for="s1-${__edit_suf}" title="1 star">★</label>
                                                                                            </div>
                                                                                        </div>

                                                                                        <div class="mb-2 text-start">
                                                                                            <label class="form-label fw-semibold d-block text-start mb-2">Comment</label>
                                                                                            <textarea name="comment" class="form-control fb-comment" rows="4">${fb.comment}</textarea>
                                                                                            <div class="form-text text-danger d-none comment-help"></div>
                                                                                        </div>

                                                                                        <button type="submit" class="btn btn-primary">Update Feedback</button>
                                                                                    </form>
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                    </div>

                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge bg-success"><i class="bi bi-check-circle"></i> Reviewed</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </c:when>

                                                        <c:when test="${not empty eligibleKeys && eligibleKeys.contains(__key)}">
                                                            <button type="button" class="btn btn-sm btn-outline-primary" data-bs-toggle="modal" data-bs-target="#fbModal-${o.order_id}-${__pid}">Review</button>

                                                            <!-- Create modal (kept as-is) -->
                                                            <div class="modal fade" id="fbModal-${o.order_id}-${__pid}" tabindex="-1" aria-hidden="true">
                                                                <div class="modal-dialog">
                                                                    <div class="modal-content">
                                                                        <div class="modal-header">
                                                                            <h5 class="modal-title">Product Review</h5>
                                                                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                                        </div>
                                                                        <div class="modal-body">
                                                                            <form action="${ctx}/feedback/create" method="post" class="feedback-form">
                                                                                <input type="hidden" name="order_id" value="${o.order_id}">
                                                                                <input type="hidden" name="product_id" value="${__pid}">

                                                                                <div class="mb-3 text-start">
                                                                                    <label class="form-label mb-2">Rating</label>
                                                                                    <div class="momo-stars" dir="rtl">
                                                                                        <c:set var="__suf" value="${o.order_id}-${__pid}" />
                                                                                        <input type="radio" name="rating" id="s5-${__suf}" value="5" checked>
                                                                                        <label for="s5-${__suf}" title="5 stars">★</label>
                                                                                        <input type="radio" name="rating" id="s4-${__suf}" value="4">
                                                                                        <label for="s4-${__suf}" title="4 stars">★</label>
                                                                                        <input type="radio" name="rating" id="s3-${__suf}" value="3">
                                                                                        <label for="s3-${__suf}" title="3 stars">★</label>
                                                                                        <input type="radio" name="rating" id="s2-${__suf}" value="2">
                                                                                        <label for="s2-${__suf}" title="2 stars">★</label>
                                                                                        <input type="radio" name="rating" id="s1-${__suf}" value="1">
                                                                                        <label for="s1-${__suf}" title="1 star">★</label>
                                                                                    </div>
                                                                                </div>

                                                                                <div class="mb-2 text-start">
                                                                                    <label class="form-label fw-semibold d-block text-start mb-2">Comment</label>
                                                                                    <textarea name="comment" class="form-control fb-comment" rows="4"></textarea>
                                                                                    <div class="form-text text-danger d-none comment-help"></div>
                                                                                </div>

                                                                                <button type="submit" class="btn btn-primary">Submit Review</button>
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
                .order-action-btn {
                    min-width: 140px;
                }

                .momo-stars {
                    display:inline-flex;
                    gap:6px;
                    font-size: 22px;
                    line-height:1;
                    user-select:none;
                }
                .momo-stars input {
                    display:none;
                }
                .momo-stars label {
                    color:#d6d9dd;
                    cursor:pointer;
                    transition: transform .05s ease-in;
                }
                .momo-stars input:checked ~ label,
                .momo-stars label:hover,
                .momo-stars label:hover ~ label {
                    color:#f59f00;
                }
                .momo-stars label:active {
                    transform: scale(.95);
                }

                /* Ensure the list-group-item stretches full width and keeps consistent padding */
                .list-group-item {
                    border-radius:6px;
                }
            </style>

        </c:otherwise>
    </c:choose>

    <div class="row mt-4">
        <div class="col text-end">
            <a href="${ctx}/profile" class="btn btn-secondary">Back</a>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        document.querySelectorAll('.feedback-form').forEach(function (form) {
            form.addEventListener('submit', function (e) {
                const rating = parseInt(form.querySelector('input[name="rating"]:checked')?.value || '5', 10);
                const cmt = form.querySelector('.fb-comment');
                const help = form.querySelector('.comment-help');

                if (rating < 5 && (!cmt.value || cmt.value.trim().length === 0)) {
                    e.preventDefault();
                    if (help)
                        help.classList.remove('d-none');
                    cmt.focus();
                } else {
                    if (help)
                        help.classList.add('d-none');
                }
            });
        });
    });
</script>
