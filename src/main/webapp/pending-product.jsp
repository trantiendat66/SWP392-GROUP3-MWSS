<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/include/header.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Temporary Product Handling</title>
    <style>
        .pending-product-container {
            max-width: 600px;
            margin: 50px auto;
            padding: 20px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .product-info {
            display: flex;
            align-items: center;
            margin-bottom: 20px;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 8px;
        }
        .product-image {
            width: 80px;
            height: 80px;
            object-fit: cover;
            border-radius: 8px;
            margin-right: 15px;
        }
        .product-details h5 {
            margin: 0 0 5px 0;
            color: #333;
        }
        .product-details p {
            margin: 0;
            color: #666;
        }
        .action-buttons {
            display: flex;
            gap: 10px;
            justify-content: center;
        }
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }
        .btn-primary {
            background: #007bff;
            color: white;
        }
        .btn-secondary {
            background: #6c757d;
            color: white;
        }
        .btn-success {
            background: #28a745;
            color: white;
        }
        .btn:hover {
            opacity: 0.9;
        }
    </style>
</head>
<body>
    <div class="pending-product-container">
        <h3 class="text-center mb-4">
            <i class="bi bi-cart-plus"></i> Pending Product
        </h3>
        
        <div id="product-info" class="product-info" style="display: none;">
            <img id="product-image" src="" alt="Product" class="product-image">
            <div class="product-details">
                <h5 id="product-name"></h5>
                <p id="product-price"></p>
                <p>Quantity: <span id="product-quantity"></span></p>
            </div>
        </div>
        
        <div id="no-product" class="text-center" style="display: none;">
            <i class="bi bi-info-circle" style="font-size: 3rem; color: #6c757d;"></i>
            <h5 class="mt-3">No pending product</h5>
            <p class="text-muted">You can continue shopping</p>
        </div>
        
        <div class="action-buttons">
            <button id="add-to-cart-btn" class="btn btn-success" style="display: none;">
                <i class="bi bi-cart-plus"></i> Add to cart
            </button>
            <button id="buy-now-btn" class="btn btn-primary" style="display: none;">
                <i class="bi bi-bag"></i> Buy now
            </button>
            <a href="${pageContext.request.contextPath}/home" class="btn btn-secondary">
                <i class="bi bi-house"></i> Back to home
            </a>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            checkPendingProduct();
        });

        function checkPendingProduct() {
            const pendingProduct = localStorage.getItem('pendingProduct');
            
            if (pendingProduct) {
                try {
                    const product = JSON.parse(pendingProduct);
                    displayProduct(product);
                } catch (e) {
                    console.error('Error parsing pending product:', e);
                    showNoProduct();
                }
            } else {
                showNoProduct();
            }
        }

        function displayProduct(product) {
            document.getElementById('product-image').src = '${pageContext.request.contextPath}/assert/image/' + product.image;
            document.getElementById('product-name').textContent = product.productName;
            document.getElementById('product-price').textContent = formatPrice(product.price) + ' VND';
            document.getElementById('product-quantity').textContent = product.quantity;
            
            document.getElementById('product-info').style.display = 'flex';
            document.getElementById('add-to-cart-btn').style.display = 'inline-block';
            document.getElementById('buy-now-btn').style.display = 'inline-block';
            document.getElementById('no-product').style.display = 'none';
        }

        function showNoProduct() {
            document.getElementById('product-info').style.display = 'none';
            document.getElementById('add-to-cart-btn').style.display = 'none';
            document.getElementById('buy-now-btn').style.display = 'none';
            document.getElementById('no-product').style.display = 'block';
        }

        function formatPrice(price) {
            return new Intl.NumberFormat('vi-VN').format(price);
        }

        // Handle add to cart
        document.getElementById('add-to-cart-btn').addEventListener('click', function() {
            const pendingProduct = JSON.parse(localStorage.getItem('pendingProduct'));
            
            fetch('${pageContext.request.contextPath}/pending-product?action=add&productId=' + pendingProduct.productId + '&quantity=' + pendingProduct.quantity, {
                method: 'GET'
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showMessage('Product successfully added to cart!', 'success');
                    localStorage.removeItem('pendingProduct');
                    setTimeout(() => {
                        window.location.href = '${pageContext.request.contextPath}/cart';
                    }, 1500);
                } else {
                    showMessage(data.message, 'error');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showMessage('An error occurred while adding the product to the cart', 'error');
            });
        });

        // Handle buy now
        document.getElementById('buy-now-btn').addEventListener('click', function() {
            const pendingProduct = JSON.parse(localStorage.getItem('pendingProduct'));
            
            // Create a hidden form to submit
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = '${pageContext.request.contextPath}/order/buy-now';
            
            const productIdInput = document.createElement('input');
            productIdInput.type = 'hidden';
            productIdInput.name = 'product_id';
            productIdInput.value = pendingProduct.productId;
            
            const quantityInput = document.createElement('input');
            quantityInput.type = 'hidden';
            quantityInput.name = 'quantity';
            quantityInput.value = pendingProduct.quantity;
            
            form.appendChild(productIdInput);
            form.appendChild(quantityInput);
            document.body.appendChild(form);
            
            localStorage.removeItem('pendingProduct');
            form.submit();
        });

        function showMessage(message, type) {
            if (window.showToast) {
                window.showToast(message, type);
                return;
            }
            const box = document.createElement('div');
            box.style.cssText = 'position:fixed;top:20px;right:20px;z-index:2147483647;background:'+
                (type==='success'?'#198754':'#dc3545')+';color:#fff;padding:10px 14px;border-radius:8px;box-shadow:0 6px 18px rgba(0,0,0,.2);font-weight:600;max-width:340px;';
            box.textContent = (message||'').toString();
            document.body.appendChild(box);
            setTimeout(()=>box.remove(),3000);
        }
    </script>

    <jsp:include page="/WEB-INF/include/footer.jsp" />
</body>
</html>
