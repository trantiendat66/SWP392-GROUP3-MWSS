<%-- 
    Document   : register
    Created on : Oct 11, 2025, 3:54:58 PM
    Author     : Oanh Nguyen
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
  String err     = (String) request.getAttribute("error");
  String name    = request.getParameter("customer_name")==null?"":request.getParameter("customer_name");
  String phone   = request.getParameter("phone")==null?"":request.getParameter("phone");
  String email   = request.getParameter("email")==null?"":request.getParameter("email");
  String address = request.getParameter("address")==null?"":request.getParameter("address");
  String gender  = request.getParameter("gender")==null?"":request.getParameter("gender");
  String dob     = request.getParameter("dob")==null?"":request.getParameter("dob");
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Register - WatchStore</title>
        <style>
            /* ===== Background (giống login) ===== */
            body {
                margin: 0;
                padding: 0;
                height: 100vh;
                background: url("${pageContext.request.contextPath}/assert/image/login-bg.jpg") no-repeat center center fixed;
                background-size: cover;
                display: flex;
                justify-content: center;
                align-items: center;
                font-family: "Poppins", Arial, sans-serif;
            }

            .auth-container{
                display: block;         
                text-align: center;
                color: #fff;
                margin-top: 300px;
                padding: 60px 0;        
                overflow: visible;      
            }

            h2{
                display: block;
                width: 440px;           /* trùng với .input-box */
                margin: 0 auto 18px;    /* căn giữa + khoảng cách dưới */
                font-size: 26px;
                font-weight: 700;
                color: #fff;
                text-shadow: 0 0 8px rgba(0,0,0,.6);
            }

            /* ===== Khung nhập ===== */
            .input-box {
                background: rgba(20, 20, 20, 0.9);
                padding: 40px 45px;
                border-radius: 14px;
                width: 440px;
                text-align: left;
                box-shadow: 0 0 25px rgba(0, 0, 0, 0.6);
                margin: 18px auto 0; /* ⬅️ tạo khoảng cách giữa tiêu đề và khung */
            }

            .field {
                margin-bottom: 16px; /* đều giữa các ô input */
            }

            label {
                display: block;
                margin-bottom: 6px;
                font-size: 13px;
                color: rgba(255, 255, 255, 0.85);
                font-weight: 600;
            }

            input, select {
                width: 100%;
                padding: 12px;
                border: none;
                border-radius: 6px;
                background: rgba(255, 255, 255, 0.15);
                color: #fff;
                font-size: 14px;
                outline: none;
                box-sizing: border-box;
            }
            select option { background:#222; color:#fff; }
            .pw-hints { margin-top:10px; font-size:12px; line-height:1.4; }
            .pw-hints ul { list-style:none; padding-left:0; margin:6px 0 0; }
            .pw-hints li { display:flex; align-items:center; gap:6px; color:#ff9999; }
            .pw-hints li.met { color:#7dd87d; }
            .pw-hints li span.icon { display:none; }
            .pw-hints li.met span.icon { display:inline-flex; justify-content:center; align-items:center; width:16px; height:16px; background:#2e7d32; color:#fff; font-size:12px; font-weight:700; border-radius:4px; }

            input::placeholder {
                color: rgba(255, 255, 255, 0.6);
            }

            input[type="file"] {
                background: rgba(255, 255, 255, 0.08);
            }

            button {
                width: 100%;
                padding: 13px;
                border: none;
                border-radius: 6px;
                background: #e50914;
                color: white;
                font-size: 15px;
                font-weight: bold;
                margin-top: 10px;
                cursor: pointer;
                transition: background 0.3s;
            }

            button:hover {
                background: #b00610;
            }

            .links {
                display: flex;
                justify-content: space-between;
                margin-top: 20px;
                font-size: 13px;
                width: 440px;
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

        <form action="${pageContext.request.contextPath}/register"
              method="post"
              enctype="multipart/form-data"
              accept-charset="UTF-8">
            <div class="auth-container">

                <h2>Register</h2>


                <div class="input-box">
                    <% if (err != null) { %>
                    <div class="error"><%= err %></div>
                    <% } %>

                    <div class="field">
                        <label>Full Name</label>
                        <input type="text" name="customer_name" value="<%=name%>" placeholder="Your full name" required>
                    </div>

                    <div class="field">
                        <label>Phone</label>
                        <input type="text" name="phone" value="<%=phone%>" placeholder="Phone number" required>
                    </div>

                    <div class="field">
                        <label>Email</label>
                        <input type="email" name="email" value="<%=email%>" placeholder="Email" required>
                    </div>

                    <div class="field">
                        <label>Address</label>
                        <input type="text" name="address" value="<%=address%>" placeholder="Address">
                    </div>

                    <div class="field">
                        <label>Date of Birth</label>
                        <input type="date" name="dob" value="<%=dob%>">
                    </div>

                    <div class="field">
                        <label>Gender</label>
                        <select name="gender">
                            <option value="" <%= gender.equals("")?"selected":"" %> >-- Select --</option>
                            <option value="Male"   <%= gender.equals("Male")?"selected":"" %>>Male</option>
                            <option value="Female" <%= gender.equals("Female")?"selected":"" %>>Female</option>
                            <option value="Other"  <%= gender.equals("Other")?"selected":"" %>>Other</option>
                        </select>
                    </div>

                    <div class="field">
                        <label>Password</label>
                        <input id="reg-password" type="password" name="password" placeholder="Password" required>
                        <div class="pw-hints" id="pw-hints">
                            <strong>Password must contain:</strong>
                            <ul>
                                <li data-crit="len"><span class="icon"></span>At least 6 characters</li>
                                <li data-crit="upper"><span class="icon"></span>One uppercase letter (A-Z)</li>
                                <li data-crit="lower"><span class="icon"></span>One lowercase letter (a-z)</li>
                                <li data-crit="digit"><span class="icon"></span>One number (0-9)</li>
                                <li data-crit="special"><span class="icon"></span>One special character (!@#$%^&* etc)</li>
                            </ul>
                        </div>
                    </div>

                    <div class="field">
                        <label>Confirm Password</label>
                        <input id="reg-confirm" type="password" name="confirm_password" placeholder="Confirm password" required>
                    </div>

                    <button type="submit">REGISTER</button>
                </div>

                <div class="links">
                    <a href="${pageContext.request.contextPath}/forgot">Forgot Password ?</a>
                    <a href="${pageContext.request.contextPath}/login">Back to Login</a>
                </div>
            </div>
        </form>

    <script>
        const pw = document.getElementById('reg-password');
        const confirmPw = document.getElementById('reg-confirm');
        const listItems = Array.from(document.querySelectorAll('#pw-hints li'));
        function evalStrength(val){
            const tests = {
                len: val.length >= 6,
                upper: /[A-Z]/.test(val),
                lower: /[a-z]/.test(val),
                digit: /\d/.test(val),
                special: /[^A-Za-z0-9]/.test(val)
            };
            listItems.forEach(li => {
                const key = li.getAttribute('data-crit');
                const icon = li.querySelector('.icon');
                if(tests[key]){ 
                    li.classList.add('met');
                    if(icon) icon.textContent='✓';
                } else { 
                    li.classList.remove('met');
                    if(icon) icon.textContent='';
                }
            });
        }
        pw.addEventListener('input', e => evalStrength(e.target.value));
        // initial
        evalStrength(pw.value);
    </script>
    </body>
</html>

