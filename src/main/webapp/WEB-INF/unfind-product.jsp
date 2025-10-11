<%-- 
    Document   : home
    Created on : Oct 10, 2025, 10:54:09 AM
    Author     : Tran Tien Dat - CE190362
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Product Not Found</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
        <style>

            html, body {
                height: 100%;
                margin: 0;
                font-family: "Inter", Arial, sans-serif;
                background: #f3f4f6;
            }


            body {
                display: grid;
                place-items: center;
                padding: 24px;
            }


            .not-found-container {
                width: min(680px, 92vw);
                background: #ffffff;
                border-radius: 28px;
                padding: clamp(28px, 5vw, 56px);
                text-align: center;
                box-shadow: 0 14px 40px rgba(17, 24, 39, 0.12);
                animation: fadeIn 0.6s ease-out;
            }


            .not-found-img {
                margin-bottom: 24px;
            }
            .not-found-img img {
                width: min(360px, 70%);
                height: auto;
                aspect-ratio: 4 / 3;
                object-fit: contain;
                display: block;
                margin-inline: auto;
                filter: drop-shadow(0 8px 18px rgba(0, 0, 0, 0.08));
                image-rendering: -webkit-optimize-contrast;
            }


            .not-found-title {
                font-size: clamp(26px, 2.6vw + 10px, 36px);
                font-weight: 800;
                letter-spacing: 0.2px;
                color: #ef4444;
                margin: 6px 0 10px;
            }


            .not-found-desc {
                font-size: clamp(15px, 1.2vw + 10px, 18px);
                color: #4b5563;
                line-height: 1.6;
                margin-bottom: 28px;
            }

            .back-btn {
                background: linear-gradient(90deg, #e9d5ff 0%, #c7d2fe 100%);
                color: #6d28d9;
                border: none;
                border-radius: 14px;
                padding: 14px 34px;
                font-size: 16px;
                font-weight: 700;
                cursor: pointer;
                transition: transform .18s ease, box-shadow .18s ease, background .18s ease, color .18s ease;
                box-shadow: 0 8px 20px rgba(109, 40, 217, 0.18);
            }
            .back-btn:hover {
                background: linear-gradient(90deg, #8b5cf6 0%, #7c3aed 100%);
                color: #fff;
                transform: translateY(-2px);
                box-shadow: 0 10px 22px rgba(124, 58, 237, 0.28);
            }


            @keyframes fadeIn {
                from {
                    opacity: 0;
                    transform: translateY(22px);
                }
                to   {
                    opacity: 1;
                    transform: translateY(0);
                }
            }


            @media (max-width: 480px) {
                .not-found-img img {
                    width: 78%;
                }
                .not-found-desc {
                    margin-bottom: 22px;
                }
            }
        </style>
    </head>
    <body>
        <div class="not-found-container">
            <div class="not-found-img">
                <img src="${pageContext.request.contextPath}/assert/image/not_found_product.png" alt="Not found">
            </div>
            <div class="not-found-title">Product Not Found</div>
            <div class="not-found-desc">
                Sorry, we couldn't find any products matching your search.<br>
                Please try again or go back to the previous page.
            </div>
            <button class="back-btn" onclick="window.history.back()">
                <i class="fa-solid fa-arrow-left"></i> Go Back
            </button>
        </div>
    </body>
</html>
