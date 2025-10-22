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
    <title>Chi Tiết Sản Phẩm</title>
    <style>
        body { background-color: #f4f6f9; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
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
        <%-- ✅ Nếu tìm thấy sản phẩm --%>
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
                    <p>Mã sản phẩm: ${p.productId}</p>
                    <p class="text-muted">Thương hiệu: ${p.brand} | Xuất xứ: ${p.origin}</p>
                    <div class="price-tag">
                        <fmt:formatNumber value="${p.price}" pattern="#,###"/> VND
                    </div>
                </div>
            </div>

            <%-- Thông số kỹ thuật --%>
            <div class="detail-section">
                <div class="detail-title">Thông Số Kỹ Thuật</div>
                <div class="row">
                    <div class="col-md-4 detail-item">
                        <span class="label">Bộ máy</span>
                        <div class="value">${p.machine}</div>
                    </div>
                    <div class="col-md-4 detail-item">
                        <span class="label">Mặt kính</span>
                        <div class="value">${p.glass}</div>
                    </div>
                    <div class="col-md-4 detail-item">
                        <span class="label">Đường kính mặt</span>
                        <div class="value">${p.dialDiameter}</div>
                    </div>
                    <div class="col-md-4 detail-item">
                        <span class="label">Vành bezel</span>
                        <div class="value">${p.bezel}</div>
                    </div>
                    <div class="col-md-4 detail-item">
                        <span class="label">Dây đeo</span>
                        <div class="value">${p.strap}</div>
                    </div>
                    <div class="col-md-4 detail-item">
                        <span class="label">Màu mặt số</span>
                        <div class="value">${p.dialColor}</div>
                    </div>
                </div>
            </div>

            <%-- Thông tin bán hàng & tình trạng --%>
            <div class="detail-section">
                <div class="detail-title">Thông tin Bán hàng & Tình trạng</div>
                <div class="row">
                    <div class="col-md-4 detail-item">
                        <span class="label">Giới tính</span>
                        <div class="value">
                            <c:choose>
                                <c:when test="${p.gender == true}">Nam</c:when>
                                <c:when test="${p.gender == false}">Nữ</c:when>
                                <c:otherwise>Unisex</c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div class="col-md-4 detail-item">
                        <span class="label">Bảo hành</span>
                        <div class="value">${p.warranty}</div>
                    </div>
                    <div class="col-md-4 detail-item">
                        <span class="label">Số lượng tồn kho</span>
                        <div class="value">
                            <c:choose>
                                <c:when test="${p.quantityProduct > 0}">
                                    <span class="badge bg-success">${p.quantityProduct}</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-danger">Hết hàng</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>

            <%-- Mô tả sản phẩm --%>
            <div class="detail-section">
                <div class="detail-title">Mô Tả Sản Phẩm</div>
                <p style="padding: 0 10px;">${p.description}</p>
            </div>

            <%-- Nút quay lại phù hợp với nguồn truy cập --%>
            <div class="d-flex justify-content-start mt-4">
                <c:choose>
                    <c:when test="${param.fromAdmin eq 'true'}">
                        <a href="${ctx}/admin/dashboard" class="btn btn-secondary">⬅️ Quay lại Trang Quản Lý Sản Phẩm</a>
                    </c:when>
                    <c:otherwise>
                        <a href="${ctx}/staffcontrol" class="btn btn-secondary">⬅️ Quay lại Trang Quản Lý Nhân Viên</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </c:when>

        <%-- ❌ Nếu không tìm thấy sản phẩm --%>
        <c:otherwise>
            <div class="not-found">
                <h3>Không tìm thấy thông tin sản phẩm này trong cơ sở dữ liệu.</h3>
                <c:choose>
                    <c:when test="${param.fromAdmin eq 'true'}">
                        <p>Vui lòng kiểm tra lại ID sản phẩm hoặc 
                           <a href="${ctx}/admin/dashboard">quay lại trang quản lý sản phẩm</a>.
                        </p>
                    </c:when>
                    <c:otherwise>
                        <p>Vui lòng kiểm tra lại ID sản phẩm hoặc 
                           <a href="${ctx}/staffcontrol">quay lại trang quản lý nhân viên</a>.
                        </p>
                    </c:otherwise>
                </c:choose>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<%@ include file="/WEB-INF/include/footer.jsp" %>
</body>
</html>
