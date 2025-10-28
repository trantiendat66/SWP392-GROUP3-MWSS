<%-- 
    Document   : home
    Created on : Oct 10, 2025, 10:54:09 AM
    Author     : Tran Tien Dat - CE190362
--%>

<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ include file="/WEB-INF/include/header.jsp" %>
<!--<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">-->

<!-- Intro Section -->
<section class="intro-section position-relative text-center text-white">
    <video class="intro-video" autoplay muted loop playsinline>
        <source src="${pageContext.request.contextPath}/assert/css/video/introwatch.mp4" type="video/mp4">
        Your browser does not support the video tag.
    </video>
    <div class="video-blocker"></div>
</section>

<style>
    html {
        scroll-behavior: smooth;
    }

    .intro-section {
        position: relative;
        width: 100vw;
        left: 50%;
        right: 50%;
        margin-left: -50vw;
        margin-right: -50vw;
        height: 70vh;
        overflow: hidden;
    }
    .intro-video {
        position: absolute;
        inset: 0;
        width: 100%;
        height: 100%;
        object-fit: cover;
        object-position: center;
        z-index: 1;
    }

    .video-blocker {
        position: absolute;
        inset: 0;
        background: rgba(0,0,0,0.25);
        z-index: 2;
    }

    @media (max-width: 480px) {
        .intro-section {
            height: 60vh;
        }
    }
</style>

<!-- Hero Section -->
<section class="py-5 bg-light text-center">
    <div class="container">
        <h1 class="mb-3">Welcome to WatchShop</h1>
        <p class="lead mb-4">Discover Quality Watches.</p>
        <a href="#featured-products" class="btn btn-primary btn-lg">Shop Now</a>
    </div>
</section>

<!-- *** SEARCH RESULTS OR FEATURED PRODUCTS - DISPLAYED RIGHT BELOW SHOP NOW BUTTON *** -->
<c:if test="${not empty param.keyword}">
    <section id="featured-products" class="container mb-5 mt-4">
        <h2 class="section-title text-center mb-4">
            <c:choose>
                <c:when test="${not empty param.keyword}">
                    Search Results for "<span style="color:#007bff;">${fn:escapeXml(param.keyword)}</span>"
                </c:when>
                <c:otherwise>
                    Featured Products
                </c:otherwise>
            </c:choose>
        </h2>
        <div id="search-results" class="row g-4 justify-content-center text-center">

            <c:choose>
                <c:when test="${not empty listP}">
                    <c:forEach var="p" items="${listP}">
                        <div class="col-lg-3 col-md-4 col-sm-6">
                            <div class="card product-card h-100 shadow-sm">
                                <c:choose>
                                    <c:when test="${not empty p.image}">
                                        <img src="${pageContext.request.contextPath}/assert/image/${p.image}"
                                             class="card-img-top product-media"
                                             alt="${fn:escapeXml(p.productName)}" />
                                    </c:when>
                                    <c:otherwise>
                                        <img src="${pageContext.request.contextPath}/assert/image/no-image.png"
                                             class="card-img-top product-media"
                                             alt="no-image" />
                                    </c:otherwise>
                                </c:choose>
                                <div class="card-body d-flex flex-column">
                                    <h5 class="card-title text-center">${fn:escapeXml(p.productName)}</h5>
                                    <p class="text-center text-muted mb-1">${fn:escapeXml(p.brand)}</p>
                                    <p class="text-center fw-bold text-danger mb-3"><fmt:formatNumber value="${p.price}" type="number"/> VND</p>
                                    <div class="mt-auto text-center">
                                        <a href="${pageContext.request.contextPath}/productdetail?id=${p.productId}"
                                           class="btn btn-outline-primary btn-sm me-2">Details</a>

                                        <!-- BUY NOW: add to cart then go to cart page -->
                                        <form action="${pageContext.request.contextPath}/order/buy-now" method="post" class="d-inline">
                                            <input type="hidden" name="product_id" value="${p.productId}">
                                            <input type="hidden" name="quantity" value="1">
                                            <button type="submit" class="btn btn-danger btn-sm me-2">Buy now</button>
                                        </form>

                                        <!-- Add to cart (keep if using AJAX) -->
                                        <button class="btn btn-success btn-sm" onclick="addToCartFromHome(${p.productId})" title="Add to cart">
                                            <i class="bi bi-cart-plus"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>

                    <div class="col-12">
                        <div class="not-found-container" style="background:#fff; padding:28px; border-radius:12px; text-align:center;">
                            <div class="not-found-img" style="margin-bottom:16px;">
                                <img src="${pageContext.request.contextPath}/assert/image/not_found_product.png"
                                     alt="Not found" style="max-width:320px;">
                            </div>
                            <h3 style="color:#ef4444; margin-bottom:8px;">Product Not Found</h3>
                            <p style="color:#4b5563; margin-bottom:16px;">
                                Sorry, we couldn't find any products matching "<strong>${fn:escapeXml(param.keyword)}</strong>".
                                Please try another keyword.
                            </p>
                            <a href="${pageContext.request.contextPath}/" class="btn btn-outline-secondary">Clear search</a>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </section>
</c:if>

<section class="container mb-5">
    <h2 class="section-title text-center mb-4">Explore Categories</h2>
    <div class="row g-4">
        <div class="col-md-4">
            <img src="${pageContext.request.contextPath}/assert/image/watch1.jpg" class="img-fluid rounded category-thumb" alt="Category 1">
        </div>
        <div class="col-md-4">
            <img src="${pageContext.request.contextPath}/assert/image/watch2.jpg" class="img-fluid rounded category-thumb" alt="Category 2">
        </div>
        <div class="col-md-4">
            <img src="${pageContext.request.contextPath}/assert/image/watch3.jpg" class="img-fluid rounded category-thumb" alt="Category 3">
        </div>
    </div>
</section>

<!-- Featured Products at bottom: always show all products (different ID to avoid duplication) -->
<section id="featured-products-default" class="container mb-5">
    <h2 class="section-title text-center mb-4">Featured Products</h2>

    <form class="d-flex mx-lg-0 py-2 flex-grow-0" role="search" action="${pageContext.request.contextPath}/search" method="get">
        <div class="dt-mega-fillter_btn active ms-2 py-1 d-flex align-items-center"
             id="filterButton"
             style="border: 2px solid black; border-radius: 5px; cursor: pointer;">
            <img width="25" height="25"
                 src="${pageContext.request.contextPath}/assert/image/filtericon.png"
                 alt="filter">
            <span style="color: black; margin-left: 5px;">Filter</span>
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
                            <option value="0-2000000">0 - 2 million</option>
                            <option value="2000000-4000000">2 - 4 million</option>
                            <option value="4000000-6000000">4 - 6 million</option>
                            <option value="6000000-8000000">6 - 8 million</option>
                            <option value="8000000-10000000">8 - 10 million</option>
                            <option value="10000000-20000000">10 - 20 million</option>
                            <option value="20000000-40000000">20 - 40 million</option>
                            <option value="40000000-100000000">40 - 100 million</option>
                            <option value="40000000-100000000">Above 100 million</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="brand" class="form-label">Brand</label>
                        <select class="form-select" id="brand" name="brand">
                            <option value="">-- All brands --</option>
                            <option value="Casio">Casio</option>
                            <option value="Seiko">Seiko</option>
                            <option value="Citizen">Citizen</option>
                            <option value="Tissot">Tissot</option>
                            <option value="Doxa">Doxa</option>
                            <option value="KOI">KOI</option>
                            <option value="Saga">Saga</option>
                            <option value="Orient">Orient</option>
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

    <div id="productList">
        <jsp:include page="/partials/product-list.jsp" />
    </div>
</section>

<script>
    // ---------------------------
    // Preserve "all products" HTML in localStorage so bottom always shows full list
    // Works without changing servlet. If user visited home once (no keyword), HTML is stored.
    // On subsequent visits with ?keyword=..., bottom is restored from stored HTML.
    // ---------------------------
    document.addEventListener('DOMContentLoaded', function () {
        try {
            const params = new URLSearchParams(window.location.search);
            const hasKeyword = params.has('keyword') && params.get('keyword').trim() !== '';
            const bottomSection = document.getElementById('featured-products-default');
            if (!bottomSection) return;
            if (!hasKeyword) {
                localStorage.setItem('ws_all_products_html', bottomSection.innerHTML);
            } else {
                const stored = localStorage.getItem('ws_all_products_html');
                if (stored) {
                    bottomSection.innerHTML = stored;
                }
            }
        } catch (e) {
            console.error('Error preserving featured products HTML:', e);
        }
    });

    function addToCartFromHome(productId) {
        fetch('${pageContext.request.contextPath}/cart?action=add&productId=' + productId + '&quantity=1', {
            method: 'GET'
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                showMessage(data.message, 'success');
                updateCartCount();
            } else {
                showMessage(data.message, 'error');
            }
        })
        .catch(error => {
            console.error('Error:', error);
            showMessage('An error occurred while adding the product to cart', 'error');
        });
    }

    function showMessage(message, type) {
        const alertClass = type === 'success' ? 'alert-success' : 'alert-danger';
        const alertHtml = `
            <div class="alert ${alertClass} alert-dismissible fade show position-fixed" 
                 style="top: 20px; right: 20px; z-index: 9999;">
    ${message}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        `;
        document.body.insertAdjacentHTML('beforeend', alertHtml);
        setTimeout(() => {
            const alert = document.querySelector('.alert');
            if (alert) alert.remove();
        }, 3000);
    }
</script>

<script>
    const filterBtn = document.getElementById("filterButton");
    if (filterBtn) {
        filterBtn.addEventListener("click", function () {
            const modal = new bootstrap.Modal(document.getElementById('filterModal'));
            modal.show();
        });
    }

    const applyFilterBtn = document.getElementById("applyFilter");
    if (applyFilterBtn) {
        applyFilterBtn.addEventListener("click", function (e) {
            e.preventDefault();
            const priceRange = document.getElementById("priceRange").value;
            const brand = document.getElementById("brand").value;
            const gender = document.getElementById("gender").value;
            const baseUrl = "${pageContext.request.contextPath}/filterServlet";
            const params = new URLSearchParams({ brand, gender, priceRange });
            fetch(baseUrl + "?" + params.toString())
                .then(response => response.text())
                .then(html => {
                    document.getElementById("productList").innerHTML = html;
                })
                .catch(err => console.error("Error filtering:", err));

            const modal = bootstrap.Modal.getInstance(document.getElementById('filterModal'));
            modal.hide();
        });
    }
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js" integrity="sha384-j1CDi7MgGQ12Z7Qab0qlWQ/Qqz24Gc6BM0thvEMVjHnfYGF0rmFCozFSxQBxwHKO" crossorigin="anonymous"></script>
<jsp:include page="/WEB-INF/include/footer.jsp" />
