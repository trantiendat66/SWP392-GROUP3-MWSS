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

<!-- ... Kết thúc tab-content ... -->

<script>
    // Bắt submit của mọi form đánh giá (kể cả nằm trong partial include)
    document.addEventListener('submit', function (e) {
        const form = e.target.closest('.feedback-form');
        if (!form)
            return;

        const ratingEl = form.querySelector('input[name="rating"]:checked');
        const rating = ratingEl ? parseInt(ratingEl.value, 10) : 5;
        const comment = (form.querySelector('textarea[name="comment"]')?.value || '').trim();

        // Nếu < 5★ thì bắt buộc comment
        if (rating < 5 && comment.length === 0) {
            e.preventDefault();
            const help = form.querySelector('.comment-help');
            if (help) {
                help.textContent = 'Vui lòng nhập lý do khi đánh giá dưới 5★.';
                help.classList.remove('d-none');
            }
            form.querySelector('textarea[name="comment"]').focus();
        }
    });

    // Khi đổi số sao -> hiển thị/ẩn nhắc "bắt buộc nếu < 5★"
    document.addEventListener('change', function (e) {
        if (!e.target.matches('.feedback-form input[name="rating"]'))
            return;
        const form = e.target.closest('.feedback-form');
        const need = parseInt(e.target.value, 10) < 5;
        form.querySelector('.comment-req')?.classList.toggle('d-none', !need);

        // reset cảnh báo khi đổi sao
        form.querySelector('.comment-help')?.classList.add('d-none');
    });
</script>

<%@ include file="/WEB-INF/include/footer.jsp" %>
