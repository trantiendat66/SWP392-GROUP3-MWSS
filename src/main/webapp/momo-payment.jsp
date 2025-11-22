<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MoMo Payment</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/qrcodejs/1.0.0/qrcode.min.js"></script>
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .payment-container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            max-width: 900px;
            width: 90%;
            overflow: hidden;
        }
        .payment-header {
            background: linear-gradient(135deg, #a02d6c 0%, #d5006d 100%);
            color: white;
            padding: 30px;
            text-align: center;
        }
        .payment-header h2 {
            margin: 0;
            font-size: 28px;
            font-weight: 600;
        }
        .countdown-timer {
            background: rgba(255,255,255,0.2);
            display: inline-block;
            padding: 10px 25px;
            border-radius: 50px;
            margin-top: 15px;
            font-size: 24px;
            font-weight: bold;
        }
        .countdown-timer.expired {
            background: rgba(255,0,0,0.3);
        }
        .payment-body {
            padding: 40px;
        }
        #openMomoBtn {
            padding: 20px 60px;
            font-size: 20px;
            box-shadow: 0 8px 25px rgba(160, 45, 108, 0.3);
            animation: pulse 2s infinite;
            border: none;
        }
        #openMomoBtn:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 35px rgba(160, 45, 108, 0.4);
        }
        @keyframes pulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.05); }
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: scale(0.9); }
            to { opacity: 1; transform: scale(1); }
        }
        .qr-fallback {
            padding: 40px;
        }
        .alert-info {
            background: #e7f3ff;
            border: 2px solid #2196F3;
            color: #1976D2;
            border-radius: 10px;
        }
        .btn-outline-primary {
            border: 2px solid #a02d6c;
            color: #a02d6c;
            padding: 10px 30px;
            border-radius: 25px;
            transition: all 0.3s;
        }
        .btn-outline-primary:hover {
            background: #a02d6c;
            color: white;
        }
        .expired-message {
            display: none;
            text-align: center;
            padding: 40px;
        }
        .expired-message.show {
            display: block;
        }
        .expired-message h3 {
            color: #d5006d;
            margin-bottom: 20px;
            font-size: 26px;
        }
        .expired-message p {
            color: #666;
            font-size: 16px;
            margin-bottom: 30px;
        }
        .action-buttons {
            display: flex;
            gap: 15px;
            justify-content: center;
            flex-wrap: wrap;
        }
        .btn-retry {
            background: linear-gradient(135deg, #a02d6c 0%, #d5006d 100%);
            color: white;
            border: none;
            padding: 15px 40px;
            border-radius: 50px;
            font-size: 16px;
            font-weight: 600;
            transition: all 0.3s;
        }
        .btn-retry:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 20px rgba(160, 45, 108, 0.4);
            color: white;
        }
        .btn-cod {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            padding: 15px 40px;
            border-radius: 50px;
            font-size: 16px;
            font-weight: 600;
            transition: all 0.3s;
        }
        .btn-cod:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 20px rgba(118, 75, 162, 0.4);
            color: white;
        }
        .order-info {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 20px;
        }
        .order-info-item {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
        }
        .order-info-item:last-child {
            margin-bottom: 0;
            padding-top: 10px;
            border-top: 2px solid #dee2e6;
            font-weight: bold;
            font-size: 18px;
        }
    </style>
</head>
<body>
    <div class="payment-container">
        <div class="payment-header">
            <h2><i class="fas fa-qrcode"></i> MoMo Payment</h2>
            <div class="countdown-timer" id="countdown">
                <i class="fas fa-clock"></i> <span id="timer">01:00</span>
            </div>
        </div>
        
        <div class="payment-body">
            <!-- Order Info -->
            <div class="order-info">
                <div class="order-info-item">
                    <span><i class="fas fa-shopping-cart"></i> Order ID:</span>
                    <strong>${sessionScope.hold_order_id}</strong>
                </div>
                <div class="order-info-item">
                    <span><i class="fas fa-tag"></i> MoMo Transaction ID:</span>
                    <strong>${sessionScope.momo_order_id}</strong>
                </div>
                <div class="order-info-item">
                    <span><i class="fas fa-money-bill-wave"></i> Total Amount:</span>
                    <strong style="color: #d5006d;">
                        <fmt:formatNumber value="${sessionScope.total_amount}" type="number" pattern="#,###" /> VND
                    </strong>
                </div>
            </div>

            <!-- MoMo Payment Button -->
            <div class="text-center mb-4" id="momoFrame">
                <div class="alert alert-info">
                    <i class="fas fa-mobile-alt"></i> 
                    Click the button below to open MoMo payment page. You have <strong>1 minute</strong> to scan QR code and complete payment.
                </div>
                
                <c:if test="${not empty sessionScope.momo_pay_url}">
                    <button onclick="openMoMoPayment()" class="btn btn-lg btn-retry" id="openMomoBtn">
                        <i class="fas fa-qrcode"></i> Open MoMo Payment Gateway
                    </button>
                    
                    <p class="text-muted mt-3">
                        <small>
                            <i class="fas fa-info-circle"></i> 
                            After completing payment, please close the payment window and return here.
                            <br>The system will automatically update your order status.
                        </small>
                    </p>
                </c:if>
            </div>

            <!-- Success message (hidden until payment completes) -->
            <div class="expired-message" id="successMessage" style="display:none;">
                <h3 style="color:#28a745;"><i class="fas fa-check-circle"></i> Payment Successful</h3>
                <p>Your order has been confirmed. You can view order details or continue shopping.</p>
                <div class="action-buttons">
                    <a href="${ctx}/orders" class="btn btn-retry" style="background:linear-gradient(135deg,#28a745 0%,#3fcf5d 100%);"><i class="fas fa-list"></i> View Orders</a>
                    <a href="${ctx}/index.jsp" class="btn btn-cod" style="background:linear-gradient(135deg,#667eea 0%, #764ba2 100%);"><i class="fas fa-home"></i> Home</a>
                </div>
            </div>

            <!-- Expired message -->
            <div class="expired-message" id="expiredMessage">
                <h3><i class="fas fa-exclamation-circle"></i> QR Code Expired</h3>
                <p>Payment time has ended. You can retry or switch to Cash on Delivery.</p>
                
                <div class="action-buttons">
                    <form action="${ctx}/momo/retry" method="post" style="display: inline;">
                        <input type="hidden" name="orderId" value="${sessionScope.hold_order_id}"/>
                        <button type="submit" class="btn btn-retry">
                            <i class="fas fa-redo"></i> Retry MoMo Payment
                        </button>
                    </form>
                    
                    <form action="${ctx}/order/switch-to-cod" method="post" style="display: inline;"
                          onsubmit="return confirm('Switch to Cash on Delivery for order #${sessionScope.hold_order_id}?');">
                        <input type="hidden" name="orderId" value="${sessionScope.hold_order_id}"/>
                        <button type="submit" class="btn btn-cod">
                            <i class="fas fa-money-bill"></i> Switch to COD
                        </button>
                    </form>
                </div>

                <div class="mt-4">
                    <a href="${ctx}/orders" class="btn btn-outline-secondary">
                        <i class="fas fa-list"></i> View My Orders
                    </a>
                </div>
            </div>
        </div>
    </div>

    <script>
        let momoWindow = null;
        const ORDER_ID = '${sessionScope.hold_order_id}';
        const successMessage = document.getElementById('successMessage');
        const expiredMessage = document.getElementById('expiredMessage');
        const momoFrame = document.getElementById('momoFrame');
        const countdownBox = document.getElementById('countdown');
        const timerDisplay = document.getElementById('timer');
        let timeLeft = 180; // seconds (UI countdown only)
        let paymentCompleted = false;

        function openMoMoPayment() {
            const payUrl = '${sessionScope.momo_pay_url}';
            if (payUrl) {
                momoWindow = window.open(payUrl, 'MoMoPayment', 'width=800,height=900,left=100,top=50,resizable=yes,scrollbars=yes');
                if (momoWindow) momoWindow.focus();
            }
        }

        function showSuccess(status) {
            if (paymentCompleted) return; // avoid double execution
            paymentCompleted = true;
            clearInterval(timerInterval);
            clearInterval(statusPollInterval);
            timerDisplay.textContent = 'PAID';
            countdownBox.classList.add('expired');
            if (momoWindow && !momoWindow.closed) momoWindow.close();
            const openBtn = document.getElementById('openMomoBtn');
            if (openBtn) { openBtn.disabled = true; openBtn.style.opacity = '0.5'; }
            momoFrame.style.display = 'none';
            expiredMessage.style.display = 'none';
            successMessage.style.display = 'block';
            // Clear server-side session tracking
            fetch('${ctx}/api/momo-clear', { method: 'POST' })
                .then(r => r.ok ? r.json() : Promise.reject('Clear session HTTP '+r.status))
                .then(data => console.log('Session cleared:', data))
                .catch(err => console.log('Clear session error:', err));
        }

        function updateTimer() {
            if (paymentCompleted) return; // stop updating on success
            const minutes = Math.floor(timeLeft / 60);
            const seconds = timeLeft % 60;
            timerDisplay.textContent = String(minutes).padStart(2,'0') + ':' + String(seconds).padStart(2,'0');
            if (timeLeft <= 0) {
                clearInterval(timerInterval);
                countdownBox.classList.add('expired');
                timerDisplay.textContent = '00:00';
                if (momoWindow && !momoWindow.closed) momoWindow.close();
                const openBtn = document.getElementById('openMomoBtn');
                if (openBtn) { openBtn.disabled = true; openBtn.style.opacity = '0.5'; openBtn.style.cursor='not-allowed'; }
                momoFrame.style.display = 'none';
                expiredMessage.classList.add('show');
            } else {
                timeLeft--;
            }
        }

        // Start countdown
        updateTimer();
        const timerInterval = setInterval(updateTimer, 1000);

        // Poll server for order status every 3 seconds
        const statusPollInterval = setInterval(function() {
            if (!ORDER_ID) return;
            fetch('${ctx}/api/order-status?orderId=' + ORDER_ID, { cache:'no-store' })
                .then(r => r.ok ? r.json() : Promise.reject('HTTP '+r.status))
                .then(data => {
                    // success flag means order_status changed out of PENDING_HOLD
                    if (data.success) {
                        showSuccess(data.orderStatus);
                    }
                })
                .catch(err => console.log('Status poll error:', err));
        }, 3000);
    </script>
</body>
</html>
