<%--
    Document   : Admin Dashboard JSP
    Created on : Jan 20, 2025
    Author     : Dang Vi Danh - CE19687
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Product" %>
<%
    // Kiểm tra session - Admin phải đăng nhập
    Object staffObj = session.getAttribute("staff");
    if (staffObj == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assert/css/home.css">
    <style>
        
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 8px 10px; border-bottom: 1px solid #ddd; }
        .actions { display: flex; gap: 8px; }
        
        
        .btn { padding: 5px 10px; margin: 2px; text-decoration: none; border: 1px solid #ccc; background: #f5f5f5; color: #333; }
        .btn:hover { background: #e0e0e0; }
        .btn-add { background: #4CAF50; color: white; }     
        .btn-edit { background: #2196F3; color: white; }     
        .btn-delete { background: #f44336; color: white; }   
        .btn-view { background: #FF9800; color: white; }     
    </style>
    
    
    
</head>
<body>
<h2>Admin Dashboard</h2>


<div style="margin-bottom: 20px;">
    <a href="#" class="btn btn-add">Add Product</a>
</div>

<!-- Lấy danh sách sản phẩm từ AdminDashboardServlet -->
<% List<Product> products = (List<Product>) request.getAttribute("products"); %>
<table>
    <thead>
    <tr>
        <th>ID</th>
        <th>Image</th>
        <th>Name</th>
        <th>Brand</th>
        <th>Price</th>
        <th>Qty</th>
        <th>Actions</th>
    </tr>
    </thead>
    <tbody>
    <% if (products != null) {
        for (Product p : products) { %>
            <tr>
                <td><%= p.getProductId() %></td>
                <td><img src="<%=request.getContextPath()%>/assert/image/<%= p.getImage() %>" alt="img" width="60"></td>
                <td><%= p.getProductName() %></td>
                <td><%= p.getBrand() %></td>
                <td><%= p.getPrice() %></td>
                <td><%= p.getQuantityProduct() %></td>
                <td class="actions">
                    
                    <a href="<%=request.getContextPath()%>/viewproductdetail?id=<%=p.getProductId()%>" class="btn btn-view">View Detail</a>
                    
                    <a href="#" class="btn btn-edit">Edit</a>
                    
                    <a href="#" class="btn btn-delete">Delete</a>
                </td>
            </tr>
    <%  }
    } %>
    </tbody>
    
</table>

</body>
</html>


