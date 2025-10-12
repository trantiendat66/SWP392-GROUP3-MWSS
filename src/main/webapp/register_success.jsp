<%-- 
    Document   : registerSuccess
    Created on : Oct 11, 2025, 3:56:10 PM
    Author     : Oanh Nguyen
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head><title>Register success</title></head>
<body style="font-family: Arial; margin:30px">
  <h2>Welcome, ${customerName}!</h2>
  <p>Your account has been created successfully.</p>
  <p><a href="${pageContext.request.contextPath}/login">Go to Login</a></p>
</body>
</html>

