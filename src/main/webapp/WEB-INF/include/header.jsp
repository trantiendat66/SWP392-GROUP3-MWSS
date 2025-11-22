<%-- 
    Document   : header
    Created on : Oct 10, 2025, 10:46:27 AM
    Author     : Tran Tien Dat - CE190362
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!doctype html>

<html lang="en">
    <head>
        <style>
            .nav-link1{
                box-shadow:0 2px 6px rgba(0,0,0,0.1);
                color: #ffffff;
                width: 90%;
                margin: 5px auto;
                text-decoration:none !important;
            }
            .cart-notification {
                position: fixed;
                top: 70px;
                left: 50%;
                transform: translateX(-50%);
                z-index: 2147483647;
                color: #fff;
                padding: 12px 20px;
                border-radius: 8px;
                box-shadow: 0 6px 18px rgba(0,0,0,.2);
                font-weight: 600;
                font-size: 14px;
                line-height: 1.4;
                text-align: center;
                min-width: 300px;
                max-width: 600px;
                transition: opacity 0.3s ease;
            }
        </style>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title><c:out value="${pageTitle != null ? pageTitle : 'WatchShop'}"/></title>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>        
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

        <!-- Bootstrap Icons -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">

        <!-- Custom CSS -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assert/css/home.css">

    </head>
    <body>
        <nav class="navbar navbar-expand-lg navbar-dark bg-dark py-2">
            <div class="container">

                <!-- Left: logo -->
                <c:choose>

                    <c:when test="${not empty sessionScope.staff}">
                        <div class="navbar-brand d-flex align-items-center me-3">
                            <img src="${pageContext.request.contextPath}/assert/image/logo.jpg" alt="WatchStore" class="logo-icon me-2">
                            <span class="d-none d-lg-inline logo-text">
                                <strong>Watch<span class="logo-accent">Shop</span></strong>
                            </span>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <a class="navbar-brand d-flex align-items-center me-3"
                           href="${pageContext.request.contextPath}/home">
                            <img src="${pageContext.request.contextPath}/assert/image/logo.jpg" alt="WatchStore" class="logo-icon me-2">
                            <span class="d-none d-lg-inline logo-text">
                                <strong>Watch<span class="logo-accent">Shop</span></strong>
                            </span>
                        </a>
                    </c:otherwise>
                </c:choose>

                <!-- Toggler cho mobile -->
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#mainNav"
                        aria-controls="mainNav" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon"></span>
                </button>


                <div class="collapse navbar-collapse" id="mainNav">          
                    <c:if test="${empty sessionScope.staff or isHome}">
                        <form class="d-flex mx-lg-3 flex-grow-0" role="search" action="${pageContext.request.contextPath}/search" method="get">
                            <input class="form-control form-control-sm search-input me-2" type="search" name="keyword" placeholder="Search product by name..." aria-label="Search" value="${param.keyword}">
                            <button class="btn btn-outline-light btn-sm" type="submit">Search</button>
                        </form>
                        <c:choose>
                            <c:when test="${not empty requestScope.listC}">
                                <li class="nav-item dropdown">
                                    <a class="nav-link dropdown-toggle fw-semibold text-white" href="#" id="productDropdown" role="button"
                                       data-bs-toggle="dropdown" aria-expanded="false">
                                        Menu
                                    </a>
                                    <ul class="dropdown-menu" aria-labelledby="productDropdown">
                                        <c:forEach var="cat" items="${requestScope.listC}">
                                            <li>
                                                <a class="dropdown-item" href="${pageContext.request.contextPath}/home?active=${cat.id}">
                                                    ${cat.name}
                                                </a>
                                            </li>
                                            <li><hr class="dropdown-divider"></li>
                                            </c:forEach>
                                    </ul>
                                </li>
                            </c:when>
                        </c:choose>
                    </c:if>
                    <ul class="navbar-nav ms-auto mb-2 mb-lg-0 align-items-lg-center">
                        <c:choose>
                            <c:when test="${not empty sessionScope.customer or not empty sessionScope.staff}">

                                <c:set var="isAdmin" value="${not empty sessionScope.staff and sessionScope.staff.role eq 'Admin'}" />

                                <c:choose>
                                    <c:when test="${isAdmin}">
                                        <li class="nav-item me-2"></li>
                                        </c:when>

                                    <c:otherwise>
                                        <li class="nav-item dropdown me-2">
                                            <a class="nav-link1 dropdown-toggle" href="#" id="userMenu" role="button"
                                               data-bs-toggle="dropdown" aria-expanded="false">
                                                <i class="bi bi-person-circle"></i>
                                            </a>
                                            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userMenu">

                                                <c:if test="${not empty sessionScope.customer}">
                                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile">Profile</a></li>
                                                    <li><hr class="dropdown-divider"></li>
                                                    </c:if>

                                                <c:if test="${not empty sessionScope.staff}">
                                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/staff_profile">Profile</a></li>
                                                    <li><hr class="dropdown-divider"></li>
                                                    </c:if>

                                                <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout">Logout</a></li>
                                            </ul>
                                        </li>

                                        <c:if test="${not empty sessionScope.customer}">
                                            <li class="nav-item">
                                                <a class="btn btn-outline-light btn-sm position-relative" href="${pageContext.request.contextPath}/cart">
                                                    <i class="bi bi-cart"></i> Cart
                                                    <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger cart-badge" id="cart-count" style="display: none;">
                                                        0
                                                    </span>
                                                </a>
                                            </li>
                                        </c:if>
                                    </c:otherwise>
                                </c:choose>
                            </c:when>

                            <c:otherwise>
                                <li class="nav-item me-2">
                                    <a class="btn btn-outline-light btn-sm" href="${pageContext.request.contextPath}/login.jsp">Login</a>
                                </li>
                                <li class="nav-item">
                                    <a class="btn btn-outline-light btn-sm position-relative" href="${pageContext.request.contextPath}/login.jsp">
                                        <i class="bi bi-cart"></i> Cart
                                    </a>
                                </li>
                            </c:otherwise>
                        </c:choose>
                    </ul>

                </div>
            </div>
        </nav>

        <!-- Fixed notification area for cart messages -->
        <div id="cart-notification" class="cart-notification" style="display: none;"></div>

        <script>
            // Cập nhật số lượng giỏ hàng khi tải trang
            document.addEventListener('DOMContentLoaded', function () {
                updateCartCount();
            });

            function updateCartCount() {
                const cartBadge = document.getElementById('cart-count');
                // Chỉ cập nhật nếu có badge (tức là user đã đăng nhập)
                if (!cartBadge) {
                    return; // User chưa đăng nhập, không có badge
                }

                fetch('${pageContext.request.contextPath}/cart?action=count', {
                    method: 'GET'
                })
                        .then(response => {
                            if (!response.ok) {
                                throw new Error('Network response was not ok');
                            }
                            return response.json();
                        })
                        .then(data => {
                            const count = data.count || 0;
                            cartBadge.textContent = count;

                            // Hiển thị badge khi có sản phẩm, ẩn khi không có
                            if (count > 0) {
                                cartBadge.style.display = 'block';
                                cartBadge.className = 'position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger cart-badge';
                            } else {
                                cartBadge.style.display = 'none';
                            }
                        })
                        .catch(error => {
                            console.error('Error updating cart count:', error);
                            // Ẩn badge nếu có lỗi
                            if (cartBadge) {
                                cartBadge.style.display = 'none';
                            }
                        });
            }

            // Hàm để cập nhật số lượng giỏ hàng từ các trang khác
            window.updateCartCount = updateCartCount;

            // Fixed notification for cart messages (no popup)
            window.showToast = function(message, type) {
                try {
                    const notification = document.getElementById('cart-notification');
                    if (!notification) return;
                    
                    const palette = {
                        success: '#198754',
                        error:   '#dc3545',
                        info:    '#0d6efd',
                        warning: '#f59f00'
                    };
                    const bg = palette[type] || palette.info;
                    
                    // Set notification content and style
                    notification.textContent = (message || '').toString();
                    notification.style.background = bg;
                    notification.style.display = 'block';
                    
                    // Auto hide after 3 seconds
                    clearTimeout(window.cartNotificationTimeout);
                    window.cartNotificationTimeout = setTimeout(() => {
                        notification.style.display = 'none';
                    }, 3000);
                } catch (_) { /* noop */ }
            };
        </script>
        <div class="container mt-4">
