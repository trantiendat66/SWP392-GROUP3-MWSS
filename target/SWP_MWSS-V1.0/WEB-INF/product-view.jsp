<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/WEB-INF/include/header.jsp" %>

<c:choose>
    <c:when test="${empty product}">
        <div class="container"><div class="alert alert-warning">Sản phẩm không tồn tại.</div></div>
    </c:when>
    <c:otherwise>
        <div class="container product-details py-4">
            <div class="row">
                <div class="col-md-6">
                    <c:choose>
                        <c:when test="${not empty product.video}">
                            <video controls class="w-100 mb-3" poster="${pageContext.request.contextPath}/assert/image/${product.image}">
                                <source src="${pageContext.request.contextPath}/assert/video/${product.video}" type="video/mp4">
                                Your browser does not support the video tag.
                            </video>
                        </c:when>
                        <c:otherwise>
                            <img src="${pageContext.request.contextPath}/assert/image/${product.image}" class="img-fluid rounded mb-3" alt="${product.productName}">
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="col-md-6">
                    <h2>${product.productName}</h2>
                    <p class="text-muted">Thương hiệu: ${product.brand} — Xuất xứ: ${product.origin}</p>
                    <h3 class="text-danger">${product.price} VNĐ</h3>

                    <div class="d-flex align-items-center mb-3">
                        <input type="number" id="quantity-input" value="1" min="1" class="form-control me-2" style="width:100px;">
                        <button type="button" class="btn btn-success" onclick="addToCart(${product.productId})">
                            <i class="bi bi-cart-plus"></i> Thêm vào giỏ
                        </button>
                    </div>

                    <hr>
                    <h5>Mô tả</h5>
                    <p><c:out value="${product.description}" /></p>

                    <h5>Thông số</h5>
                    <ul>
                        <li><strong>Bảo hành:</strong> ${product.warranty}</li>
                        <li><strong>Máy:</strong> ${product.machine}</li>
                        <li><strong>Kính:</strong> ${product.glass}</li>
                        <li><strong>Đường kính:</strong> ${product.dialDiameter}</li>
                        <li><strong>Dây:</strong> ${product.strap}</li>
                        <li><strong>Màu mặt:</strong> ${product.dialColor}</li>
                    </ul>
                </div>
            </div>
        </div>
    </c:otherwise>
</c:choose>

<script>
    function addToCart(productId) {
        const quantity = document.getElementById('quantity-input').value;
        
        if (quantity < 1) {
            alert('Số lượng phải lớn hơn 0');
            return;
        }
        
        fetch('${pageContext.request.contextPath}/cart?action=add&productId=' + productId + '&quantity=' + quantity, {
            method: 'GET'
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                // Hiển thị thông báo thành công
                showMessage(data.message, 'success');
                
                // Cập nhật số lượng giỏ hàng trong header
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
        
        // Tự động ẩn sau 3 giây
        setTimeout(() => {
            const alert = document.querySelector('.alert');
            if (alert) {
                alert.remove();
            }
        }, 3000);
    }
    
    function updateCartCount() {
        fetch('${pageContext.request.contextPath}/cart?action=count', {
            method: 'GET'
        })
        .then(response => response.json())
        .then(data => {
            // Cập nhật số lượng trong header nếu có
            const cartBadge = document.querySelector('.cart-badge');
            if (cartBadge) {
                cartBadge.textContent = data.count;
            }
        })
        .catch(error => {
            console.error('Error updating cart count:', error);
        });
    }
</script>

<jsp:include page="/WEB-INF/include/footer.jsp" />
