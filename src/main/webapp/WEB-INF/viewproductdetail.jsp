<%-- 
    Document   : viewproductdetail
    Created on : Oct 17, 2025, 11:06:30 PM
    Author     : Cola
--%>

<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="/WEB-INF/include/header.jsp" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Product Details</title>
        <style>
            body {
                background-color: #f4f6f9;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }
            .product-card {
                max-width: 1000px;
                margin: 30px auto;
                padding: 25px;
                background: #fff;
                border-radius: 8px;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            }
            .header-section {
                display: flex;
                align-items: center;
                margin-bottom: 30px;
                padding-bottom: 20px;
                border-bottom: 1px solid #e0e0e0;
            }
            .profile-img-container {
                width: 150px;
                height: 150px;
                border-radius: 50%;
                overflow: hidden;
                flex-shrink: 0;
                margin-right: 20px;
                border: 3px solid #007bff;
            }
            .profile-img {
                width: 100%;
                height: 100%;
                object-fit: cover;
                background: #f0f0f0;
            }
            .info-header h2 {
                margin: 0;
                font-size: 1.8em;
                color: #333;
            }
            .info-header p {
                margin: 0;
                color: #6c757d;
                font-size: 0.9em;
            }
            .price-tag {
                font-size: 1.5em;
                font-weight: 700;
                color: #dc3545;
                margin-top: 5px;
            }
            .detail-section {
                margin-bottom: 30px;
            }
            .detail-title {
                font-size: 1.1em;
                font-weight: 600;
                color: #495057;
                border-bottom: 1px solid #e9ecef;
                padding-bottom: 8px;
                margin-bottom: 15px;
            }
            .detail-item {
                padding: 0 10px;
            }
            .detail-item .label {
                font-weight: 500;
                color: #007bff;
                display: block;
                font-size: 0.85em;
                margin-bottom: 3px;
            }
            .detail-item .value {
                color: #343a40;
                font-size: 1em;
                margin-bottom: 15px;
            }
            .not-found {
                padding: 30px;
                background-color: #f8d7da;
                color: #721c24;
                border: 1px solid #f5c6cb;
                border-radius: 8px;
                text-align: center;
            }
        </style>
    </head>
    <body>

        <div class="product-card">
            <c:choose>
                <c:when test="${not empty requestScope.viewproductdetail}">
                    <c:set var="p" value="${requestScope.viewproductdetail}"/>

                    <div class="header-section">
                        <div class="profile-img-container">
                            <img src="${ctx}/assert/image/${p.image}" 
                                 alt="${p.productName}" 
                                 class="profile-img" 
                                 onerror="this.onerror=null;this.src='${ctx}/assert/image/default.png';" />
                        </div>

                        <div class="info-header">
                            <h2>${p.productName}</h2>
                            <p>Product ID: ${p.productId}</p>
                            <p class="text-muted">Brand: ${p.brand} | Origin: ${p.origin}</p>
                            <div class="price-tag">
                                <fmt:formatNumber value="${p.price}" pattern="#,###"/> VND
                            </div>
                        </div>
                    </div>

                    <%-- Technical Specifications --%>
                    <div class="detail-section">
                        <div class="detail-title">Technical Specifications</div>
                        <div class="row">
                            <div class="col-md-4 detail-item">
                                <span class="label">Machine</span>
                                <div class="value">${p.machine}</div>
                            </div>
                            <div class="col-md-4 detail-item">
                                <span class="label">Glass</span>
                                <div class="value">${p.glass}</div>
                            </div>
                            <div class="col-md-4 detail-item">
                                <span class="label">Dial Diameter</span>
                                <div class="value">${p.dialDiameter}</div>
                            </div>
                            <div class="col-md-4 detail-item">
                                <span class="label">Bezel</span>
                                <div class="value">${p.bezel}</div>
                            </div>
                            <div class="col-md-4 detail-item">
                                <span class="label">Strap</span>
                                <div class="value">${p.strap}</div>
                            </div>
                            <div class="col-md-4 detail-item">
                                <span class="label">Dial Color</span>
                                <div class="value">${p.dialColor}</div>
                            </div>
                        </div>
                    </div>

                    <%-- Sales Information & Condition --%>
                    <div class="detail-section">
                        <div class="detail-title">Sales Information & Condition</div>
                        <div class="row">
                            <div class="col-md-4 detail-item">
                                <span class="label">Gender</span>
                                <div class="value">
                                    <c:choose>
                                        <c:when test="${p.gender == true}">Male</c:when>
                                        <c:when test="${p.gender == false}">Female</c:when>
                                        <c:otherwise>Unisex</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="col-md-4 detail-item">
                                <span class="label">Warranty</span>
                                <div class="value">${p.warranty}</div>
                            </div>
                            <div class="col-md-4 detail-item">
                                <span class="label">Stock Quantity</span>
                                <div class="value">
                                    <c:choose>
                                        <c:when test="${p.quantityProduct > 0}">
                                            <span class="badge bg-success">${p.quantityProduct}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-danger">Out of Stock</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>

                    <%-- Product Description --%>
                    <div class="detail-section">
                        <div class="detail-title">Product Description</div>
                        <p style="padding: 0 10px;">${p.description}</p>
                    </div>

                    <%-- Back button depending on access source --%>
                    <div class="d-flex justify-content-end mt-4">
                        <c:choose>
                            <c:when test="${param.fromAdmin eq 'true'}">
                                <a href="${ctx}/admin/dashboard" class="btn btn-danger">⬅️ Back to Admin Page</a>
                            </c:when>
                        </c:choose>
                    </div>

                </c:when>

                <c:otherwise>
                    <div class="not-found">
                        <h3>Product information not found in the database.</h3>
                        <c:choose>
                            <c:when test="${param.fromAdmin eq 'true'}">
                                <p>Please check the product ID again or 
                                    <a href="${ctx}/admin/dashboard">go back to the admin page</a>.
                                </p>
                            </c:when>
                        </c:choose>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <%@ include file="/WEB-INF/include/footer.jsp" %>
    </body>
</html>
