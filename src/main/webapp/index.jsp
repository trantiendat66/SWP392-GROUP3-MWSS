<%-- 
    Document   : index
    Created on : Oct 10, 2025, 10:52:12 AM
    Author     : Tran Tien Dat - CE190362
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    response.sendRedirect(request.getContextPath() + "/home");
//request.getRequestDispatcher("/WEB-INF/home.jsp").forward(request, response);
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Hello World!</h1>
    </body>
</html>

