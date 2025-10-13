<%-- 
    Document   : footer
    Created on : Oct 10, 2025, 10:46:51 AM
    Author     : Tran Tien Dat - CE190362
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<footer class="site-footer footer-full">
    <div class="container text-center">
        <div class="row">
            <div class="col-md-4">
                <h5 class="mb-3">Quick Links</h5>
                <p class="mb-1"><a href="${pageContext.request.contextPath}/" class="text-white">Home</a></p>
                <p class="mb-1"><a href="${pageContext.request.contextPath}/products" class="text-white">Products</a></p>
                <p class="mb-1"><a href="${pageContext.request.contextPath}/orders" class="text-white">Order History</a></p>
                <p class="mb-0"><a href="${pageContext.request.contextPath}/about" class="text-white">About</a></p>
            </div>
            <div class="col-md-4">
                <h5 class="mb-3">Contact Us</h5>
                <p class="mb-1">123 Music Street, District 1, Ho Chi Minh City</p>
                <p class="mb-1">Email: support@watchshop.vn</p>
                <p class="mb-0">Phone: +84 234 567 890</p>
            </div>
            <div class="col-md-4">
                <h5 class="mb-3">Follow Us</h5>
                <p class="mb-1">Facebook</p>
                <p class="mb-1">Instagram</p>
                <p class="mb-0">Twitter</p>
            </div>
        </div>

        <hr style="border-color: rgba(255,255,255,0.06); margin: 24px 0;" />

        <p class="mb-0">© 2025 WatchShop. All rights reserved.</p>
    </div>
</footer>

<style>
   
    .footer-full {
        position: relative;
        left: 50%;
        right: 50%;
        margin-left: -50vw;
        margin-right: -50vw;
        width: 100vw;
        box-sizing: border-box;
        background: #23272a;
        color: #fff;
        padding: 48px 0;
        z-index: 10;
    }
 
    .footer-full a {
        color: #fff;
        text-decoration: none;
        opacity: .95;
    }
    .footer-full a:hover {
        opacity: 1;
        text-decoration: underline;
    }

    html, body {
        overflow-x: hidden;
    }
</style>
