<%-- 
    Document   : header
    Created on : Oct 10, 2025, 10:46:27 AM
    Author     : Tran Tien Dat - CE190362
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><c:out value="${pageTitle != null ? pageTitle : 'Watch Store'}"/></title>
    
    <!-- ✅ Bootstrap CSS CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assert/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assert/css/home.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assert/css/product.view.css">
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
  <div class="container-fluid">
    <a class="navbar-brand" href="${pageContext.request.contextPath}/index.jsp">WatchStore</a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#mainNav">
      <span class="navbar-toggler-icon"></span>
    </button>

    <div class="collapse navbar-collapse" id="mainNav">
      <form class="d-flex ms-auto" action="${pageContext.request.contextPath}/search" method="get">
        <input class="form-control me-2" type="search" name="keyword" placeholder="Tìm kiếm..." value="${param.keyword}">
        <button class="btn btn-outline-light" type="submit">Tìm</button>
      </form>

      <ul class="navbar-nav ms-3">
        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/cart">Giỏ hàng</a></li>
        <c:choose>
            <c:when test="${not empty sessionScope.account}">
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/user/profile.jsp">${sessionScope.account.username}</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/logout">Đăng xuất</a></li>
            </c:when>
            <c:otherwise>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/login.jsp">Đăng nhập</a></li>
            </c:otherwise>
        </c:choose>
      </ul>
    </div>
  </div>
</nav>

<main class="container mt-4">

