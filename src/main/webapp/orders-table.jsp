<%-- 
    Document   : orders-table
    Created on : Oct 18, 2025, 12:35:39 PM
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
                                        ${o.order_date}
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
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="it" items="${itemsMap[o.order_id]}">
                                        <tr>
                                            <td>
                                                <img src="${ctx}/assert/image/${it.image}"
                                                     class="img-thumbnail"
                                                     style="width:60px;height:60px;object-fit:cover"
                                                     alt="${it.product_name}">
                                            </td>
                                            <td>${it.product_name}</td>
                                            <td class="text-center">${it.quantity}</td>
                                            <td class="text-end"><fmt:formatNumber value="${it.unit_price}" type="number"/> VNĐ</td>
                                            <td class="text-end"><fmt:formatNumber value="${it.total_price}" type="number"/> VNĐ</td>
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

