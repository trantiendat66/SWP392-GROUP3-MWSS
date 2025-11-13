<%-- 
    Document   : order-list
    Created on : Oct 18, 2025, 12:35:00 PM
    Author     : Oanh Nguyen
--%>

<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt" %>
<%@ include file="/WEB-INF/include/header.jsp" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<div class="container my-4">
    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>

    <div class="d-flex align-items-center justify-content-between">
        <h3 class="mb-3">My Orders</h3>
        <a href="${ctx}/home" class="btn btn-outline-secondary">← Continue Shopping</a>
    </div>

    <ul class="nav nav-tabs mb-3">
        <li class="nav-item">
            <a class="nav-link ${activeTab == 'placed' ? 'active' : ''}" href="${ctx}/orders?tab=placed">Placed</a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${activeTab == 'shipping' ? 'active' : ''}" href="${ctx}/orders?tab=shipping">Shipping</a>
        </li>
        <li class="nav-item">
            <a class="nav-link ${activeTab == 'delivered' ? 'active' : ''}" href="${ctx}/orders?tab=delivered">Delivered</a>
        </li>
    </ul>

    <!-- include partial for each tab -->
    <div class="tab-content">
        <div class="tab-pane fade ${activeTab == 'placed' ? 'show active' : ''}">
            <jsp:include page="/orders-table.jsp">
                <jsp:param name="title" value="Placed Orders (PENDING/CONFIRMED)"/>
                <jsp:param name="listAttr" value="ordersPlaced"/>
            </jsp:include>
        </div>

        <div class="tab-pane fade ${activeTab == 'shipping' ? 'show active' : ''}">
            <jsp:include page="/orders-table.jsp">
                <jsp:param name="title" value="Orders in Transit (SHIPPING)"/>
                <jsp:param name="listAttr" value="ordersShipping"/>
            </jsp:include>
        </div>

        <div class="tab-pane fade ${activeTab == 'delivered' ? 'show active' : ''}">
            <jsp:include page="/orders-table.jsp">
                <jsp:param name="title" value="Delivered Orders (DELIVERED)"/>
                <jsp:param name="listAttr" value="ordersDelivered"/>
            </jsp:include>
        </div>
    </div>
</div>

<!-- ============ Toggle accordion: click again to close the currently open item ============ -->
<script>
    (function () {
        // Toggle: click to open/close its own item, without affecting others (allow multiple open items)
        document.addEventListener('click', function (e) {
            const btn = e.target.closest('.js-acc-btn, .accordion .accordion-button');
            if (!btn)
                return;

            const sel = btn.getAttribute('data-target') || btn.getAttribute('data-bs-target');
            if (!sel)
                return;
            const pane = document.querySelector(sel);
            if (!pane)
                return;

            // Prevent Bootstrap Data-API default handling so we can fully control it
            e.preventDefault();
            if (typeof e.stopImmediatePropagation === 'function')
                e.stopImmediatePropagation();
            e.stopPropagation();

            const isOpen = pane.classList.contains('show');

            if (window.bootstrap?.Collapse) {
                const inst = window.bootstrap.Collapse.getOrCreateInstance(pane);
                if (isOpen) {
                    inst.hide();
                    btn.classList.add('collapsed');
                    btn.setAttribute('aria-expanded', 'false');
                } else {
                    inst.show();
                    btn.classList.remove('collapsed');
                    btn.setAttribute('aria-expanded', 'true');
                }
            } else {
                // Fallback if bootstrap.bundle is missing
                pane.classList.toggle('show', !isOpen);
                btn.classList.toggle('collapsed', isOpen);
                btn.setAttribute('aria-expanded', String(!isOpen));
            }
        }, true); // capture to run before other handlers
    })();
</script>


<!-- ======================================================================= -->

<!-- Validate feedback form (keep existing logic) -->
<script>
    // Capture submit of all feedback forms (including inside partial includes)
    document.addEventListener('submit', function (e) {
        const form = e.target.closest('.feedback-form');
        if (!form)
            return;

        const ratingEl = form.querySelector('input[name="rating"]:checked');
        const rating = ratingEl ? parseInt(ratingEl.value, 10) : 5;
        const comment = (form.querySelector('textarea[name="comment"]')?.value || '').trim();

        // If < 5★ then comment is required
        if (rating < 5 && comment.length === 0) {
            e.preventDefault();
            const help = form.querySelector('.comment-help');
            if (help) {
                help.textContent = 'Please enter a reason when rating below 5★.';
                help.classList.remove('d-none');
            }
            form.querySelector('textarea[name="comment"]').focus();
        }
    });

    // When changing star rating -> show/hide “required if < 5★” note
    document.addEventListener('change', function (e) {
        if (!e.target.matches('.feedback-form input[name="rating"]'))
            return;
        const form = e.target.closest('.feedback-form');
        const need = parseInt(e.target.value, 10) < 5;
        form.querySelector('.comment-req')?.classList.toggle('d-none', !need);
        // reset warning when star is changed
        form.querySelector('.comment-help')?.classList.add('d-none');
    });
</script>

<%@ include file="/WEB-INF/include/footer.jsp" %>
