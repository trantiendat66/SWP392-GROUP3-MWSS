<%-- 
    Document   : header
    Created on : Oct 10, 2025, 10:46:27 AM
    Author     : Tran Tien Dat - CE190362
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!doctype html>
<html lang="vi">
    <head>
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
                <a class="navbar-brand d-flex align-items-center me-3" href="${pageContext.request.contextPath}/home">
                    <img src="${pageContext.request.contextPath}/assert/image/logo.jpg" alt="WatchStore" class="logo-icon me-2">
                    <span class="d-none d-lg-inline logo-text"><strong>Watch<span class="logo-accent">Shop</span></strong></span>
                </a>

                <!-- Toggler cho mobile -->
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#mainNav"
                        aria-controls="mainNav" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon"></span>
                </button>


                <div class="collapse navbar-collapse" id="mainNav">          


                    <form class="d-flex mx-lg-3 flex-grow-0" role="search" action="${pageContext.request.contextPath}/search" method="get">
                        <input class="form-control form-control-sm search-input me-2" type="search" name="keyword" placeholder="Search by name..." aria-label="Search" value="${param.keyword}">
                        <button class="btn btn-outline-light btn-sm" type="submit">Search</button>
                    </form>

                    <ul class="navbar-nav ms-auto mb-2 mb-lg-0 align-items-lg-center">
                        <c:choose>
                            <c:when test="${not empty sessionScope.customer or not empty sessionScope.staff}">
                                <li class="nav-item dropdown me-2">
                                    <a class="nav-link dropdown-toggle" href="#" id="userMenu" role="button"
                                       data-bs-toggle="dropdown" aria-expanded="false">
                                        <i class="bi bi-person-circle"></i>
                                    </a>
                                    <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userMenu">
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile">Profile</a></li>
                                        <li><hr class="dropdown-divider"></li>
                                        <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout">Logout</a></li>
                                    </ul>
                                </li>

                                <!-- 🛒 Chỉ hiển thị cart nếu là customer -->
                                <c:if test="${not empty sessionScope.customer}">
                                    <li class="nav-item">
                                        <a class="btn btn-outline-light btn-sm position-relative" href="${pageContext.request.contextPath}/cart">
                                            <i class="bi bi-cart"></i> Cart
                                            <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger cart-badge" id="cart-count">
                                                0
                                            </span>
                                        </a>
                                    </li>
                                </c:if>
                            </c:when>

                            <c:otherwise>
                                <li class="nav-item me-2">
                                    <a class="btn btn-outline-light btn-sm" href="${pageContext.request.contextPath}/login.jsp">Login</a>
                                </li>
                                <li class="nav-item">
                                    <a class="btn btn-outline-light btn-sm position-relative" href="${pageContext.request.contextPath}/cart">
                                        <i class="bi bi-cart"></i> Cart
                                        <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger cart-badge" id="cart-count">
                                            0
                                        </span>
                                    </a>
                                </li>
                            </c:otherwise>
                        </c:choose>
                    </ul>

                </div>
            </div>
        </nav>

        <script>
            // Cập nhật số lượng giỏ hàng khi tải trang
            document.addEventListener('DOMContentLoaded', function () {
                updateCartCount();
            });

            function updateCartCount() {
                fetch('${pageContext.request.contextPath}/cart?action=count', {
                    method: 'GET'
                })
                        .then(response => response.json())
                        .then(data => {
                            const cartBadge = document.getElementById('cart-count');
                            if (cartBadge) {
                                cartBadge.textContent = data.count;
                                if (data.count > 0) {
                                    cartBadge.style.display = 'inline';
                                } else {
                                    cartBadge.style.display = 'none';
                                }
                            }
                        })
                        .catch(error => {
                            console.error('Error updating cart count:', error);
                        });
            }
        </script>
        <div class="container mt-4">
    </body>
