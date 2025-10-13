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

                    <!-- Search + Filter -->
                    <form class="d-flex mx-lg-3 flex-grow-0" role="search" action="${pageContext.request.contextPath}/search" method="get">
                        <input class="form-control form-control-sm search-input me-2" type="search" name="keyword" placeholder="Search by name..." aria-label="Search" value="${param.keyword}">
                        <button class="btn btn-outline-light btn-sm" type="submit">Search</button>
                        <div class="dt-mega-fillter_btn active ms-2 px-2 py-1 d-flex align-items-center"
                             id="filterButton"
                             style="border: 1px solid white; border-radius: 5px; cursor: pointer;">
                            <img width="25" height="25"
                                 style="filter: brightness(0) invert(1);"
                                 src="${pageContext.request.contextPath}/assert/image/filtericon.png"
                                 alt="filter">
                            <span style="color: white; margin-left: 5px;">Filter</span>
                        </div>
                    </form>

                    <!-- Popup filter -->
                    <div class="modal fade" id="filterModal" tabindex="-1" aria-labelledby="filterLabel" aria-hidden="true">
                        <div class="modal-dialog modal-dialog-centered">
                            <div class="modal-content bg-dark text-white">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="filterLabel">Filter Products</h5>
                                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                                </div>

                                <div class="modal-body">
                                    <div class="mb-3">
                                        <label for="priceRange" class="form-label">Price Range</label>
                                        <select class="form-select" id="priceRange" name="priceRange">
                                            <option value="">-- Select range --</option>
                                            <option value="0-2000000">0 - 2 triệu</option>
                                            <option value="2000000-4000000">2 - 4 triệu</option>
                                            <option value="4000000-6000000">4 - 6 triệu</option>
                                            <option value="6000000-8000000">6 - 8 triệu</option>
                                            <option value="8000000-10000000">8 - 10 triệu</option>
                                            <option value="10000000-20000000">10 - 20 triệu</option>
                                            <option value="20000000-40000000">20 - 40 triệu</option>
                                            <option value="40000000-100000000">40 - 100 triệu</option>
                                            <option value="40000000-100000000">Trên 100 triệu</option>
                                        </select>
                                    </div>
                                    <div class="mb-3">
                                        <label for="brand" class="form-label">Brand</label>
                                        <select class="form-select" id="brand" name="brand">
                                            <option value="">-- All brands --</option>
                                            <option value="Casio">Casio</option>
                                            <option value="Seiko">Rolex</option>
                                            <option value="Citizen">Citizen</option>
                                            <option value="Omega">Koi</option>
                                        </select>
                                    </div>
                                    <div class="mb-3">
                                        <label for="gender" class="form-label">Gender</label>
                                        <select class="form-select" id="gender" name="gender">
                                            <option value="">-- All Gender --</option>
                                            <option value="1">Male</option>
                                            <option value="0">Female</option>
                                        </select>
                                    </div>
                                </div>

                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">Close</button>
                                    <button type="button" id="applyFilter" class="btn btn-primary btn-sm">Apply Filter</button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Right Side -->
                    <ul class="navbar-nav ms-auto mb-2 mb-lg-0 align-items-lg-center">

                        <c:choose>
                            <!-- Nếu đã login -->
                            <c:when test="${not empty sessionScope.customer}">
                                <li class="nav-item dropdown me-2">
                                    <a class="nav-link dropdown-toggle" href="#" id="userMenu" role="button"
                                       data-bs-toggle="dropdown" aria-expanded="false">
                                        <i class="bi bi-person-circle"></i> 
                                        ${sessionScope.customer.customer_name}
                                    </a>
                                    <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userMenu">
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/user/profile.jsp">Profile</a></li>
                                        <li><hr class="dropdown-divider"></li>
                                        <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout">Logout</a></li>
                                    </ul>
                                </li>

                                <!-- Cart -->
                                <li class="nav-item me-2">
                                    <a class="btn btn-outline-light btn-sm position-relative" href="${pageContext.request.contextPath}/cart">
                                        <i class="bi bi-cart"></i> Cart
                                        <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger cart-badge" id="cart-count">
                                            0
                                        </span>
                                    </a>
                                </li>
                            </c:when>

                            <!-- Nếu chưa login -->
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

            document.getElementById("filterButton").addEventListener("click", function () {
                const modal = new bootstrap.Modal(document.getElementById('filterModal'));
                modal.show();
            });

            document.getElementById("applyFilter").addEventListener("click", function () {
                const priceRange = document.getElementById("priceRange").value;
                const brand = document.getElementById("brand").value;
                const gender = document.getElementById("gender").value;
                const baseUrl = "${pageContext.request.contextPath}/filterServlet";
                const params = new URLSearchParams({
                    brand,
                    gender,
                    priceRange
                });
                window.location.href = baseUrl + "?" + params.toString();
            });
        </script>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"
                integrity="sha384-j1CDi7MgGQ12Z7Qab0qlWQ/Qqz24Gc6BM0thvEMVjHnfYGF0rmFCozFSxQBxwHKO"
        crossorigin="anonymous"></script>

        <div class="container mt-4">



            <script>
            document.getElementById("filterButton").addEventListener("click", function () {
                const modal = new bootstrap.Modal(document.getElementById('filterModal'));
                modal.show();
            });
            document.getElementById("applyFilter").addEventListener("click", function () {
                const priceRange = document.getElementById("priceRange").value;
                const brand = document.getElementById("brand").value;
                const gender = document.getElementById("gender").value;
                const baseUrl = "${pageContext.request.contextPath}/filterServlet";
                const params = new URLSearchParams({
                    brand,
                    gender,
                    priceRange
                });
                window.location.href = baseUrl + "?" + params.toString();
            });
            </script>
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js" integrity="sha384-j1CDi7MgGQ12Z7Qab0qlWQ/Qqz24Gc6BM0thvEMVjHnfYGF0rmFCozFSxQBxwHKO" crossorigin="anonymous"></script>
    </body>
