<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@ include file="/WEB-INF/include/header.jsp" %>
<head>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<c:choose>
    <c:when test="${empty product}">
        <div class="container"><div class="alert alert-warning">Product not found.</div></div>
    </c:when>
    <c:otherwise>
        <div class="container product-details py-4">
            <div class="row">
                <div class="col-md-6">
                    <img src="${pageContext.request.contextPath}/assert/image/${product.image}" 
                         class="img-fluid rounded mb-3" alt="${product.productName}">
                </div>

                <div class="col-md-6">
                    <h2>${product.productName}</h2>
                    <p class="text-muted">Brand: ${product.brand} — Origin: ${product.origin}</p>
                    <h3 class="text-danger">${product.price} VND</h3>

                    <div class="d-flex align-items-center mb-3">
                        <input type="number" id="quantity-input" value="1" min="1" max="${product.quantityProduct}"
                               class="form-control me-2" style="width:100px;">
                        <button type="button" class="btn btn-danger btn-lg me-2" 
                                onclick="addToCart(${product.productId})">
                            <i class="fas fa-cart-plus"></i> Add to cart
                        </button>

                        <button type="button" class="btn btn-primary btn-lg" 
                                onclick="buyNow(${product.productId})">
                            <i class="fas fa-shopping-cart"></i> Buy now
                        </button>
                    </div>

                    <!-- HIDDEN FORM: Buy Now -> /order/buy-now (does not add to cart) -->
                    <form id="buyNowForm" action="${pageContext.request.contextPath}/order/buy-now" method="post" style="display:none;">
                        <input type="hidden" name="product_id" value="${product.productId}">
                        <input type="hidden" name="quantity" id="buyNowQty" value="1">
                    </form>

                    <hr>

                    <h5>Description</h5>
                    <p><c:out value="${product.description}" /></p>

                    <h5>Specifications</h5>
                    <ul>
                        <li><strong>Warranty:</strong> ${product.warranty}</li>
                        <li><strong>Movement:</strong> ${product.machine}</li>
                        <li><strong>Glass:</strong> ${product.glass}</li>
                        <li><strong>Dial diameter:</strong> ${product.dialDiameter}</li>
                        <li><strong>Bezel:</strong> ${product.bezel}</li>
                        <li><strong>Strap:</strong> ${product.strap}</li>
                        <li><strong>Dial color:</strong> ${product.dialColor}</li>
                        <li><strong>Functions:</strong> ${product.function}</li>
                        <li><strong>In stock:</strong> ${product.quantityProduct}</li>
                        <li><strong>Gender:</strong> <c:out value="${product.gender ? 'Male' : 'Female'}" /></li>
                    </ul>
                </div>
            </div>

        </div>

        <!-- Product Reviews -->
        <div class="container my-5">
            <h3>Product Reviews</h3>
            <c:if test="${empty productReviews}">
                <p>No reviews for this product yet.</p>
            </c:if>
            <c:forEach var="review" items="${productReviews}">
                <div class="card mb-3">
                    <div class="card-body">
                        <h5 class="card-title">${review.username}</h5>
                        <h6 class="card-subtitle mb-2 text-muted">${review.date}</h6>
                        <p class="card-text">${review.comment}</p>
                        <p class="card-text"><strong>Rating:</strong> ${review.rating}/5</p>
                    </div>
                </div>
            </c:forEach>
        </div>
    </c:otherwise>
</c:choose>

<script>
    // Keep the same logic for addToCart / showMessage / updateCartCount
    function addToCart(productId) {
        const quantity = document.getElementById('quantity-input').value;
        const maxQuantity = ${product.quantityProduct};
        
        if (quantity < 1) {
            alert('Quantity must be greater than 0');
            return;
        }
        
        if (quantity > maxQuantity) {
            alert('Quantity cannot exceed ' + maxQuantity + ' items remaining in stock');
            return;
        }
        
        fetch('${pageContext.request.contextPath}/cart?action=add&productId=' + productId + '&quantity=' + quantity, {
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
                    showMessage('An error occurred while adding the product to the cart', 'error');
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
            if (alert)
                alert.remove();
        }, 3000);
    }
</script>

<script>
  function buyNow(productId) {
    var qtyEl = document.getElementById('quantity-input');
    var qty = qtyEl ? parseInt(qtyEl.value, 10) : 1;
    if (!qty || qty < 1) qty = 1;

    document.getElementById('buyNowQty').value = qty;
    document.getElementById('buyNowForm').submit();
  }
</script>

<jsp:include page="/WEB-INF/include/footer.jsp" />
