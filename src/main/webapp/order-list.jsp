<%-- 
    Document   : order-list
    Created on : Oct 18, 2025, 12:35:00 PM
    Author     : Oanh Nguyen
--%>

<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ include file="/WEB-INF/include/header.jsp" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<div class="container my-4">
    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>

    <div class="d-flex align-items-center justify-content-between">
        <h3 class="mb-3">Đơn hàng của tôi</h3>
        <a href="${ctx}/home" class="btn btn-outline-secondary">← Tiếp tục mua sắm</a>
    </div>

    <ul class="nav nav-tabs mb-3">
        <li class="nav-item">
            <a class="nav-link ${activeTab == 'placed' ? 'active' : ''}" href="${ctx}/orders?tab=placed">Đã đặt</a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${activeTab == 'shipping' ? 'active' : ''}" href="${ctx}/orders?tab=shipping">Đang giao</a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${activeTab == 'delivered' ? 'active' : ''}" href="${ctx}/orders?tab=delivered">Đã giao</a>
        </li>
    </ul>

    <!-- include partial cho mỗi tab -->
    <div class="tab-content">
        <div class="tab-pane fade ${activeTab == 'placed' ? 'show active' : ''}">
            <jsp:include page="/orders-table.jsp">
                <jsp:param name="title" value="Đơn đã đặt (PENDING/CONFIRMED)"/>
                <jsp:param name="listAttr" value="ordersPlaced"/>
            </jsp:include>
        </div>

        <div class="tab-pane fade ${activeTab == 'shipping' ? 'show active' : ''}">
            <jsp:include page="/orders-table.jsp">
                <jsp:param name="title" value="Đơn đang giao (SHIPPING)"/>
                <jsp:param name="listAttr" value="ordersShipping"/>
            </jsp:include>
        </div>

        <div class="tab-pane fade ${activeTab == 'delivered' ? 'show active' : ''}">
            <jsp:include page="/orders-table.jsp">
                <jsp:param name="title" value="Đơn đã giao (DELIVERED)"/>
                <jsp:param name="listAttr" value="ordersDelivered"/>
            </jsp:include>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/include/footer.jsp" %>

