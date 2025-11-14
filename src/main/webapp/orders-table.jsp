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
        <div class="alert alert-info">No orders.</div>
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
                                        <%-- DISPLAY DATE: if DELIVERED and has delivered_at then use delivered_at, otherwise use order_date (String) --%>
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
                                        <fmt:formatNumber value="${o.total_amount}" type="number"/> VND
                                    </span>
                                </div>
                                <small class="text-muted">
                                    ${o.shipping_address} | ${o.phone} |
                                    Payment: <c:out value="${o.payment_method == 1 ? 'Paid' : 'COD'}"/>
                                </small>
                            </div>
                        </button>
                    </h2>

                    <div id="c-${listAttr}-${o.order_id}" class="accordion-collapse collapse">
                        <div class="accordion-body p-0">
                            <table class="table mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th style="width:70px;">Image</th>
                                        <th>Product</th>
                                        <th class="text-center" style="width:100px;">Qty</th>
                                        <th class="text-end">Unit Price</th>
                                        <th class="text-end">Total</th>
                                        <%-- FEEDBACK: add "Review" column --%>
                                        <th class="text-end" style="width:140px;">Review</th>
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
                                            <td>
                                                <a href="${ctx}/productdetail?id=${it.productId}" 
                                                   class="text-decoration-none text-primary"
                                                   title="View product details">
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
                                                    <%-- Check if already has feedback --%>
                                                    <c:when test="${not empty feedbackMap && feedbackMap.containsKey(__key)}">
                                                        <c:set var="fb" value="${feedbackMap[__key]}" />
                                                        <c:choose>
                                                            <c:when test="${fb.can_edit}">
                                                                <%-- Show Edit and Delete buttons --%>
                                                                <div class="btn-group-vertical btn-group-sm" role="group">
                                                                    <a href="${ctx}/feedback/edit?id=${fb.feedback_id}" 
                                                                       class="btn btn-sm btn-outline-warning" 
                                                                       title="Edit your review">
                                                                        <i class="bi bi-pencil-square"></i> Edit
                                                                    </a>
                                                                    <form action="${ctx}/feedback/delete" method="post" 
                                                                          style="display:inline;"
                                                                          onsubmit="return confirm('Are you sure you want to delete this review?');">
                                                                        <input type="hidden" name="feedback_id" value="${fb.feedback_id}">
                                                                        <button type="submit" class="btn btn-sm btn-outline-danger w-100">
                                                                            <i class="bi bi-trash"></i> Delete
                                                                        </button>
                                                                    </form>
                                                                </div>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <%-- Already reviewed but can't edit anymore --%>
                                                                <span class="badge bg-success">
                                                                    <i class="bi bi-check-circle"></i> Reviewed
                                                                </span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:when>
                                                    
                                                    <%-- Not reviewed yet, show Review button if eligible --%>
                                                    <c:when test="${not empty eligibleKeys && eligibleKeys.contains(__key)}">
                                                        <!-- Button to open modal -->
                                                        <button type="button"
                                                                class="btn btn-sm btn-outline-primary"
                                                                data-bs-toggle="modal"
                                                                data-bs-target="#fbModal-${o.order_id}-${__pid}">
                                                            Review
                                                        </button>

                                                        <!-- Modal -->
                                                        <div class="modal fade" id="fbModal-${o.order_id}-${__pid}" tabindex="-1" aria-hidden="true">
                                                            <div class="modal-dialog">
                                                                <div class="modal-content">
                                                                    <div class="modal-header">
                                                                        <h5 class="modal-title">Product Review</h5>
                                                                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                                    </div>

                                                                    <div class="modal-body">
                                                                        <form action="${ctx}/feedback/create" method="post" class="feedback-form">
                                                                            <input type="hidden" name="order_id" value="${o.order_id}">
                                                                            <input type="hidden" name="product_id" value="${__pid}">

                                                                            <!-- Rating -->
                                                                            <div class="mb-3 text-start">
                                                                                <label class="form-label mb-2">Rating</label>

                                                                                <%-- star picker: 1 row of stars, click to select rating --%>
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
                                                                                <textarea name="comment" class="form-control fb-comment" rows="4"
                                                                                          placeholder="Enter your review (optional – please type in Vietnamese with diacritics)…"></textarea>
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
                color:#d6d9dd;        /* light gray (empty star) */
                cursor:pointer;
                transition: transform .05s ease-in;
            }
            /* color all stars to the left of the selected star (use dir=rtl + ~ selector) */
            .momo-stars input:checked ~ label,
            .momo-stars label:hover,
            .momo-stars label:hover ~ label {
                color:#f59f00;        /* orange-yellow */
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
<div class="mt-3 mb-3 text-end">
    <a href="profile" class="btn btn-secondary">Back</a>
</div>