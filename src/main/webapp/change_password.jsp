<%-- 
    Document   : change_password
    Created on : Oct 15, 2025, 9:54:07 AM
    Author     : hau
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/include/header.jsp" %>
        <style>
            .change-password-page {
                font-family: Arial, sans-serif;
                background: #f4f4f9;
                display: flex;
                justify-content: center;
                align-items: flex-start;
                min-height: 60vh;
                padding: 24px 0;
            }
            .password-box {
                background: white;
                padding: 30px;
                border-radius: 10px;
                box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
                width: 400px;
                text-align: center;
            }
            .change-password-page h2 {
                margin-bottom: 20px;
            }
            .change-password-page label {
                display: block;
                text-align: left;
                margin: 10px 0 5px;
                font-weight: bold;
            }
            .change-password-page input[type="password"] {
                width: 100%;
                padding: 10px;
                margin-bottom: 15px;
                border: 1px solid #ccc;
                border-radius: 5px;
            }
            .change-password-page button {
                width: 100%;
                padding: 10px;
                background: #007bff;
                color: white;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                font-size: 16px;
            }
            .change-password-page button:hover {
                background: #0056b3;
            }
            .change-password-page .link {
                display: block;
                margin-top: 10px;
                text-decoration: none;
                color: #333;
            }
            .change-password-page .error {
                color: red;
                margin-top: 10px;
            }
        </style>
        <div class="change-password-page">
        <%
            String ctx = request.getContextPath();
            String cancelLink = ctx + "/profile"; // mặc định là customer
            if (session.getAttribute("staff") != null) {
                cancelLink = ctx + "/staff_profile"; // nếu là staff thì đổi
            }
        %>
        <div class="password-box">
            <h2>Change Password</h2>
            <form action="change_password" method="post">
                <label>Old Password</label>
                <input type="password" name="oldPassword" >

                <label>New Password</label>
                <input id="cp-new" type="password" name="newPassword" >
                <div class="pw-hints" style="text-align:left; font-size:12px; margin-top:6px;">
                    <strong>Password must contain:</strong>
                    <ul style="list-style:none; padding-left:0; margin:6px 0 0;">
                        <li data-crit="len" style="margin:4px 0; display:flex; align-items:center; gap:6px;"><span class="icon"></span>At least 6 characters</li>
                        <li data-crit="upper" style="margin:4px 0; display:flex; align-items:center; gap:6px;"><span class="icon"></span>One uppercase letter (A-Z)</li>
                        <li data-crit="lower" style="margin:4px 0; display:flex; align-items:center; gap:6px;"><span class="icon"></span>One lowercase letter (a-z)</li>
                        <li data-crit="digit" style="margin:4px 0; display:flex; align-items:center; gap:6px;"><span class="icon"></span>One number (0-9)</li>
                        <li data-crit="special" style="margin:4px 0; display:flex; align-items:center; gap:6px;"><span class="icon"></span>One special character (!@#$%^&*)</li>
                    </ul>
                </div>

                <label>Confirm New Password</label>
                <input id="cp-confirm" type="password" name="confirmPassword" >

                <button type="submit">Update Password</button>
                <a class="link" href="<%= cancelLink %>">Cancel</a>
            </form>

            <% if (request.getAttribute("error") != null) {%>
            <p class="error"><%= request.getAttribute("error")%></p>
            <% }%>
            <script>
                (function(){
                    const pw = document.getElementById('cp-new');
                    const items = document.querySelectorAll('.pw-hints [data-crit]');
                    function update(v){
                        const tests={len:v.length>=6,upper:/[A-Z]/.test(v),lower:/[a-z]/.test(v),digit:/\d/.test(v),special:/[^A-Za-z0-9]/.test(v)};
                        items.forEach(li=>{
                            const k=li.getAttribute('data-crit');
                            const icon=li.querySelector('.icon');
                            if(tests[k]){ li.style.color='#7dd87d'; icon.style.display='inline-flex'; icon.textContent='✓'; icon.style.background='#2e7d32'; icon.style.color='#fff'; icon.style.fontSize='12px'; icon.style.fontWeight='700'; icon.style.borderRadius='4px'; icon.style.width='16px'; icon.style.height='16px'; icon.style.justifyContent='center'; icon.style.alignItems='center'; }
                            else { li.style.color='#ff9999'; icon.textContent=''; icon.style.display='none'; }
                        });
                    }
                    pw.addEventListener('input',e=>update(e.target.value));
                    update(pw.value);
                })();
            </script>
        </div>
        </div>
    <jsp:include page="/WEB-INF/include/footer.jsp" />