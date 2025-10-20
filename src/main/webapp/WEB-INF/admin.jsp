<%--
    Document   : Admin Dashboard JSP
    Created on : Jan 20, 2025
    Author     : Dang Vi Danh - CE19687
--%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
    // session check (nếu servlet đã redirect rồi thì không cần, nhưng giữ an toàn)
    if (session.getAttribute("staff") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="utf-8"/>
        <title>Admin Dashboard</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assert/css/home.css" />
        <style>
            /* (giữ style ngắn gọn) */
            body{
                font-family:Arial, sans-serif;
                background:#f4f6f8;
                margin:0;
                padding:20px
            }
            .add-btn{
                background:#4CAF50;
                color:#fff;
                padding:8px 12px;
                border-radius:6px;
                text-decoration:none
            }
            table{
                width:100%;
                border-collapse:collapse;
                margin-top:12px
            }
            th,td{
                padding:10px;
                border-bottom:1px solid #eee;
                text-align:left
            }
            .btn{
                padding:6px 8px;
                border-radius:4px;
                color:#fff;
                text-decoration:none
            }
            .btn-edit{
                background:#2196F3
            }
            .btn-delete{
                background:#f44336
            }
            .btn-view{
                background:#FF9800
            }
        </style>
    </head>
    <body>
        <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:16px;">
            <h2>Admin Dashboard</h2>
            <a href="${pageContext.request.contextPath}/addproduct" class="add-btn">Add New Product</a>
        </div>

        <!-- messages -->
        <c:if test="${not empty sessionScope.successMessage}">
            <div style="background:#e6ffed;padding:8px;border-radius:6px;margin-bottom:8px;">
                <c:out value="${sessionScope.successMessage}"/>
            </div>
            <c:remove var="successMessage" scope="session"/>
        </c:if>
        <c:if test="${not empty sessionScope.errorMessage}">
            <div style="background:#ffe6e6;padding:8px;border-radius:6px;margin-bottom:8px;">
                <c:out value="${sessionScope.errorMessage}"/>
            </div>
            <c:remove var="errorMessage" scope="session"/>
        </c:if>

        <!-- product table -->
        <table>
            <thead>
                <tr>
                    <th>ID</th><th>Image</th><th>Name</th><th>Brand</th><th>Price</th><th>Qty</th><th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty products}">
                        <c:forEach var="p" items="${products}">
                            <tr>
                                <td><c:out value="${p.productId}"/></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty p.image}">
                                            <img src="${pageContext.request.contextPath}/assert/image/${p.image}" alt="img" width="60"/>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color:#999">No image</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td><c:out value="${p.productName}"/></td>
                                <td><c:out value="${p.brand}"/></td>
                                <td><fmt:formatNumber value="${p.price}" type="number" maxFractionDigits="0"/> ₫</td>
                                <td><c:out value="${p.quantityProduct}"/></td>
                                <td>
                                    <a class="btn btn-view" href="${pageContext.request.contextPath}/viewproductdetail?id=${p.productId}">View</a>
                                    <a class="btn btn-edit" href="${pageContext.request.contextPath}/editproduct?id=${p.productId}">Edit</a>
                                    <form method="post" action="${pageContext.request.contextPath}/deleteproduct" style="display:inline" onsubmit="return confirm('Bạn có chắc muốn xóa sản phẩm này?');">
                                        <input type="hidden" name="id" value="${p.productId}" />
                                        <button type="submit" class="btn btn-delete">Delete</button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr><td colspan="7" style="text-align:center;padding:18px 0;">No products found.</td></tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </body>
</html>
