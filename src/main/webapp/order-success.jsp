<%-- 
    Document   : order-success
    Created on : Oct 15, 2025, 5:31:51 PM
    Author     : Oanh Nguyen
--%>

<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Đặt hàng thành công</title>
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <style>
            /* ---- Chỉ scope trong trang này để tránh đụng CSS ở header/footer ---- */
            .order-success{
                background:#f5f6fa;
                padding:32px 16px;
            }
            .order-success .center{
                max-width:520px;
                margin:24px auto;
            }

            .order-success .card{
                background:#fff;
                border-radius:18px;
                padding:36px 28px;
                text-align:center;
                box-shadow:0 12px 30px rgba(0,0,0,.08);
                animation:os-fade .6s ease;
            }
            @keyframes os-fade{
                from{
                    opacity:0;
                    transform:translateY(16px)
                }
                to{
                    opacity:1;
                    transform:translateY(0)
                }
            }

            .order-success .tick{
                width:85px;
                height:85px;
                margin:2px auto 20px;
                border-radius:50%;
                background:#eaf7f1;
                display:flex;
                align-items:center;
                justify-content:center;
            }
            .order-success .tick svg{
                width:40px;
                height:40px;
                stroke:#22a05d;
                stroke-width:4;
                fill:none;
                stroke-linecap:round;
                stroke-linejoin:round;
                stroke-dasharray:48;
                stroke-dashoffset:48;
                animation:os-draw .6s ease forwards;
            }
            @keyframes os-draw{
                to{
                    stroke-dashoffset:0
                }
            }

            .order-success h1{
                font-size:1.6rem;
                margin:10px 0 8px;
                color:#222
            }
            .order-success .desc{
                color:#5a5a5a;
                line-height:1.6;
                margin:0 0 14px
            }
            .order-success .label{
                color:#5a5a5a;
                margin-top:10px
            }
            .order-success .code{
                font-weight:700;
                font-size:1.15rem;
                color:#d9534f;
                margin:4px 0 2px
            }

            .order-success .actions{
                display:flex;
                gap:14px;
                justify-content:center;
                margin-top:22px;
                flex-wrap:wrap
            }
            .order-success .btn{
                display:inline-flex;
                align-items:center;
                gap:8px;
                text-decoration:none;
                padding:12px 24px;
                border-radius:28px;
                font-weight:600;
                transition:all .25s ease;
                border:none;
                cursor:pointer;
            }
            .order-success .btn svg{
                width:18px;
                height:18px;
                stroke-width:2.3
            }
            .order-success .btn-primary{
                background:#22a05d;
                color:#fff;
                box-shadow:0 4px 10px rgba(34,160,93,.3)
            }
            .order-success .btn-primary:hover{
                transform:translateY(-2px);
                box-shadow:0 6px 15px rgba(34,160,93,.4)
            }
            .order-success .btn-secondary{
                background:#eef2ff;
                color:#1f2a44;
                box-shadow:0 3px 8px rgba(0,0,0,.05)
            }
            .order-success .btn-secondary:hover{
                transform:translateY(-2px);
                box-shadow:0 5px 12px rgba(0,0,0,.1)
            }

            .order-success .note{
                font-size:.9rem;
                color:#8a8a8a;
                margin-top:14px
            }
        </style>
    </head>
    <body>

        <!-- Header -->
        <jsp:include page="/WEB-INF/include/header.jsp" />

        <!-- Content -->
        <main class="order-success">
            <div class="center">
                <div class="card" role="status" aria-live="polite">
                    <div class="tick" aria-hidden="true">
                        <svg viewBox="0 0 52 52"><path d="M14 27 L23 36 L38 17"></path></svg>
                    </div>

                    <h1>Đặt hàng thành công 🎉</h1>
                    <p class="desc">
                        Cảm ơn bạn đã mua hàng. Đơn hàng của bạn đã được ghi nhận và đang xử lý.<br>
                        Chúng tôi sẽ liên hệ sớm để xác nhận giao hàng.
                    </p>

                    <div class="label">Mã đơn hàng</div>
                    <div class="code">#${param.orderId}</div>

                    <div class="actions">
                        <a class="btn btn-primary" href="${pageContext.request.contextPath}/orders?tab=placed">
                            <!-- icon list -->
                            <svg xmlns="http://www.w3.org/2000/svg" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path d="M3 7h18M3 12h18M3 17h18"></path>
                            </svg>
                            Xem đơn hàng
                        </a>
                        <a class="btn btn-secondary" href="${pageContext.request.contextPath}/index.jsp">
                            <!-- icon cart -->
                            <svg xmlns="http://www.w3.org/2000/svg" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path d="M6 6h15l-1.5 9h-12zM9 22a1 1 0 100-2 1 1 0 000 2zm8 0a1 1 0 100-2 1 1 0 000 2z"></path>
                            </svg>
                            Tiếp tục mua sắm
                        </a>
                    </div>

                    <div class="note">Bạn có thể xem chi tiết đơn trong mục “Đơn hàng của tôi”.</div>
                </div>
            </div>
        </main>

        <!-- Footer -->
        <jsp:include page="/WEB-INF/include/footer.jsp" />

    </body>
</html>
