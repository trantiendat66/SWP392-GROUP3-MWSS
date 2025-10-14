<%-- 
    Document   : login
    Created on : Oct 11, 2025, 2:39:10 PM
    Author     : Nguyen Phi Thuong 
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Login - WatchStore</title>
        <style>
            /* ===== Background ===== */
            body {
                margin: 0;
                padding: 0;
                height: 100vh;
                background: url("${pageContext.request.contextPath}/assert/image/login-bg.jpg") no-repeat center center fixed;
                background-size: cover;
                display: flex;
                justify-content: center; /* căn giữa ngang */
                align-items: center; /* căn giữa dọc */
                font-family: "Poppins", Arial, sans-serif;
            }

            /* ===== Container tổng ===== */
            .login-container {
                text-align: center;
                color: white;
            }
            

            h2 {
                color: white;
                font-size: 26px;
                font-weight: 700;
                margin-bottom: 20px;
            }

            /* ===== Khung nhập (xám) ===== */
            .input-box {
                background: rgba(20, 20, 20, 0.9);
                padding: 30px 40px;
                border-radius: 12px;
                width: 360px;
                text-align: center;
                box-shadow: 0 0 25px rgba(0, 0, 0, 0.6);
            }

            input {
                width: 100%;
                padding: 12px;
                margin: 10px 0;
                border: none;
                border-radius: 6px;
                background: rgba(255, 255, 255, 0.15);
                color: #fff;
                font-size: 14px;
                outline: none;
            }

            input::placeholder {
                color: rgba(255, 255, 255, 0.6);
            }

            button {
                width: 100%;
                padding: 12px;
                border: none;
                border-radius: 6px;
                background: #e50914;
                color: white;
                font-size: 15px;
                font-weight: bold;
                margin-top: 20px;
                cursor: pointer;
                transition: background 0.3s;
            }

            button:hover {
                background: #b00610;
            }

            .links {
                display: flex;
                justify-content: space-between;
                margin-top: 15px;
                font-size: 13px;
                width: 360px;
                margin-left: auto;
                margin-right: auto;
            }

            .links a {
                color: #ccc;
                text-decoration: none;
                transition: color 0.3s;
            }

            .links a:hover {
                color: #fff;
            }

            .error {
                color: #ff6666;
                margin-top: 10px;
                font-size: 14px;
            }
        </style>
    </head>
    <body>

        <form action="${pageContext.request.contextPath}/login" method="post">
            <div class="login-container">
                <h2>Login</h2>

                <div class="input-box">
                    <input type="email" name="email" placeholder="Email" required>
                    <input type="password" name="password" placeholder="Password" required>
                </div>

                <button type="submit">LOGIN</button>

                <div class="links">
                    <a href="${pageContext.request.contextPath}/forgot">Forgot Password ?</a>
                    <a href="${pageContext.request.contextPath}/register">Register An Account</a>
                </div>

                <div class="error">
                    <c:if test="${not empty error}">
                        ${error}
                    </c:if>
                </div>
            </div>
        </form>

    </body>
</html>
