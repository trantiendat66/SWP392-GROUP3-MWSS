<%-- 
    Document   : home
    Created on : Oct 10, 2025, 10:54:09 AM
    Author     : Tran Tien Dat - CE190362
--%>

<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ include file="/WEB-INF/include/header.jsp" %>

<!-- Intro Section -->
<section class="intro-section position-relative text-center text-white">
    <video class="intro-video" autoplay muted loop playsinline>
        <source src="${pageContext.request.contextPath}/assert/css/video/intro.mp4" type="video/mp4">
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
        height: 50vh;
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
<!-- *** KẾT QUẢ TÌM KIẾM HOẶC FEATURED PRODUCTS - HIỂN THỊ NGAY DƯỚI NÚT SHOP NOW *** -->
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
                                <p class="text-center fw-bold text-danger mb-3">${p.price} VNĐ</p>
                                <div class="mt-auto text-center">
                                    <a href="${pageContext.request.contextPath}/product-view?pid=${p.productId}" class="btn btn-primary btn-sm me-2">Details</a>
                                    <button class="btn btn-success btn-sm" onclick="addToCartFromHome(${p.productId})">
                                        <i class="bi bi-cart-plus"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <!-- Khi không tìm thấy: hiển thị giao diện "Product Not Found" ngay dưới nút Shop Now -->
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

<!-- Featured Products cuối trang: luôn hiển thị toàn bộ sản phẩm (id khác để không trùng) -->
<section id="featured-products-default" class="container mb-5">
    <h2 class="section-title text-center mb-4">Featured Products</h2>
    <div class="row g-4">
        <c:forEach var="p" items="${listP}">
            <div class="col-lg-3 col-md-4 col-sm-6">
                <div class="card product-card h-100">
                    <c:choose>
                        <c:when test="${not empty p.image}">
                            <img src="${pageContext.request.contextPath}/assert/image/${p.image}"
                                 class="card-img-top product-media"
                                 alt="${p.productName}" />
                        </c:when>
                        <c:otherwise>
                            <img src="${pageContext.request.contextPath}/assert/image/no-image.png"
                                 class="card-img-top product-media"
                                 alt="no-image" />
                        </c:otherwise>
                    </c:choose>
                    <div class="card-body d-flex flex-column">
                        <h5 class="card-title text-center">${p.productName}</h5>
                        <p class="text-center text-muted mb-1">${p.brand}</p>
                        <p class="text-center fw-bold text-danger mb-3">${p.price} VNĐ</p>
                        <div class="mt-auto text-center">
                            <a href="${pageContext.request.contextPath}/product-view?pid=${p.productId}" class="btn btn-primary btn-sm me-2">Details</a>
                            <button class="btn btn-success btn-sm" onclick="addToCartFromHome(${p.productId})">
                                <i class="bi bi-cart-plus"></i>
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>
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
            // If there's no bottom section, nothing to do
            if (!bottomSection) return;
            // If no keyword => store the current bottom HTML as "all products"
            if (!hasKeyword) {
                // store innerHTML (including cards)
                localStorage.setItem('ws_all_products_html', bottomSection.innerHTML);
            } else {
                // has keyword => try to restore stored full products list
                const stored = localStorage.getItem('ws_all_products_html');
                if (stored) {
                    bottomSection.innerHTML = stored;
                }
                // else: nothing stored (first request is a search) -> do nothing (falls back to server render)
            }
        } catch (e) {
            // fail quietly, don't break page
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
            showMessage('Có lỗi xảy ra khi thêm sản phẩm vào giỏ hàng', 'error');
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
    function updateCartCount() {
        fetch('${pageContext.request.contextPath}/cart?action=count', {
            method: 'GET'
        })
        .then(response => response.json())
        .then(data => {
            const cartBadge = document.getElementById('cart-count');
            if (cartBadge) {
                cartBadge.textContent = data.count;
                cartBadge.style.display = data.count > 0 ? 'inline' : 'none';
            }
        })
        .catch(error => {
            console.error('Error updating cart count:', error);
        });
    }
</script>
<jsp:include page="/WEB-INF/include/footer.jsp" />
