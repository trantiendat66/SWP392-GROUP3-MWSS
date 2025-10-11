<%-- 
    Document   : home
    Created on : Oct 10, 2025, 10:54:09 AM
    Author     : Tran Tien Dat - CE190362
--%>

<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

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

<section id="featured-products" class="container mb-5">
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
                            <a href="${pageContext.request.contextPath}/product-detail?pid=${p.productId}" class="btn btn-primary btn-sm">Details</a>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</section>

<jsp:include page="/WEB-INF/include/footer.jsp" />
