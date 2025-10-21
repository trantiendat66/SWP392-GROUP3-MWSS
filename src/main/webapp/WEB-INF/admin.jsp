<%--
    Document   : Admin Dashboard JSP
    Created on : Jan 20, 2025
    Author     : Dang Vi Danh - CE19687
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="model.Product" %>
<%@ page import="model.Staff" %>
<%@ page import="model.TopProduct" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    // Kiểm tra session - Admin phải đăng nhập
    Staff staff = (Staff) session.getAttribute("staff");
    if (staff == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Admin Dashboard - WatchShop</title>
    <style>
        /*
         * Admin Dashboard CSS
         * Created on : Jan 20, 2025
         * Author     : Dang Vi Danh - CE19687
         */

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8f9fa;
            color: #333;
        }

        /* Header */
        .header {
            background-color: #343a40;
            color: white;
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .logo-section {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .logo {
            width: 40px;
            height: 40px;
            background-color: #007bff;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
            font-size: 18px;
        }

        .brand-text {
            display: flex;
            flex-direction: column;
        }

        .brand-name {
            font-size: 24px;
            font-weight: bold;
        }

        .brand-name .watch {
            color: #000;
        }

        .brand-name .shop {
            color: #007bff;
        }

        .search-section {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .search-input {
            padding: 8px 15px;
            border: none;
            border-radius: 20px;
            width: 300px;
            font-size: 14px;
        }

        .search-btn {
            background-color: #007bff;
            color: white;
            border: none;
            padding: 8px 20px;
            border-radius: 20px;
            cursor: pointer;
            font-size: 14px;
        }

        .user-section {
            display: flex;
            align-items: center;
            gap: 10px;
            cursor: pointer;
        }

        .user-icon {
            width: 30px;
            height: 30px;
            background-color: #6c757d;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
        }

        /* Main Layout */
        .main-container {
            display: flex;
            min-height: calc(100vh - 70px);
        }

        /* Sidebar */
        .sidebar {
            width: 280px;
            background-color: white;
            padding: 20px;
            box-shadow: 2px 0 4px rgba(0,0,0,0.1);
        }

        .profile-card {
            text-align: center;
            margin-bottom: 30px;
        }

        .profile-avatar {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            object-fit: cover;
            margin-bottom: 15px;
            border: 3px solid #e9ecef;
        }


        .profile-name {
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 5px;
        }

        .nav-menu {
            list-style: none;
        }

        .nav-item {
            margin-bottom: 10px;
        }

        .nav-link {
            display: block;
            padding: 12px 20px;
            text-decoration: none;
            color: #333;
            border-radius: 8px;
            transition: all 0.3s ease;
            font-weight: 500;
        }

        .nav-link:hover {
            background-color: #f8f9fa;
        }

        .nav-link.active {
            background-color: #dc3545;
            color: white;
        }


        .logout-btn {
            background-color: #dc3545;
            color: white;
            border: none;
            padding: 12px 20px;
            border-radius: 8px;
            width: 100%;
            cursor: pointer;
            font-weight: 500;
            margin-top: 20px;
        }

        /* Main Content */
        .main-content {
            flex: 1;
            padding: 30px;
            background-color: white;
            margin: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        /* Dashboard Stats */
        .dashboard-stats {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .stat-title {
            font-size: 24px;
            font-weight: bold;
            margin-bottom: 15px;
        }

        .revenue-amount {
            font-size: 32px;
            font-weight: bold;
            color: #28a745;
            margin-bottom: 15px;
        }

        .chart-placeholder {
            height: 60px;
            background: linear-gradient(90deg, #007bff 0%, #28a745 50%, #ffc107 100%);
            border-radius: 5px;
            position: relative;
        }

        .chart-line {
            position: absolute;
            top: 50%;
            left: 0;
            right: 0;
            height: 2px;
            background: #007bff;
            transform: translateY(-50%);
        }

        .top-products-list {
            list-style: none;
        }

        .top-product-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 0;
            border-bottom: 1px solid #e9ecef;
        }

        .top-product-item:last-child {
            border-bottom: none;
        }

        .product-name {
            font-weight: 500;
        }

        .product-sold {
            color: #6c757d;
            font-size: 14px;
        }

        .add-product-btn {
            background-color: #28a745;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            font-weight: 500;
            margin-top: 15px;
        }

        /* Product Table */
        .table-container {
            margin-top: 30px;
        }

        .table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .table th {
            background-color: #f8f9fa;
            padding: 15px;
            text-align: left;
            font-weight: 600;
            border-bottom: 2px solid #dee2e6;
        }

        .table td {
            padding: 15px;
            border-bottom: 1px solid #dee2e6;
            vertical-align: middle;
        }

        .table tr:hover {
            background-color: #f8f9fa;
        }

        .product-image {
            width: 60px;
            height: 60px;
            object-fit: cover;
            border-radius: 8px;
            border: 1px solid #dee2e6;
        }

        .product-id {
            font-weight: 600;
            color: #007bff;
        }

        .product-name {
            font-weight: 500;
        }

        .product-brand {
            color: #6c757d;
        }

        .product-category {
            background-color: #e9ecef;
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 500;
        }

        .product-price {
            font-weight: 600;
            color: #28a745;
        }

        .product-stock {
            font-weight: 500;
        }

        .action-buttons {
            display: flex;
            gap: 8px;
        }

        .action-btn {
            width: 32px;
            height: 32px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 14px;
        }

        .edit-btn {
            background-color: #007bff;
            color: white;
        }

        .delete-btn {
            background-color: #dc3545;
            color: white;
        }

        .action-btn:hover {
            opacity: 0.8;
        }

        /* Responsive Design */
        @media (max-width: 1200px) {
            .dashboard-stats {
                grid-template-columns: 1fr;
            }
            
            .search-input {
                width: 200px;
            }
        }

        @media (max-width: 768px) {
            .main-container {
                flex-direction: column;
            }
            
            .sidebar {
                width: 100%;
                order: 2;
            }
            
            .main-content {
                margin: 10px;
                padding: 20px;
            }
            
            .header {
                flex-direction: column;
                gap: 15px;
                padding: 15px;
            }
            
            .search-section {
                width: 100%;
                justify-content: center;
            }
            
            .search-input {
                width: 100%;
                max-width: 300px;
            }
        }
    </style>
</head>
<body>
    <!-- Header -->
    <header class="header">
        <div class="logo-section">
            <div class="logo">C</div>
            <div class="brand-text">
                <div class="brand-name">
                    <span class="watch">CHRONOX</span>
                </div>
                <div class="brand-name">
                    <span class="watch">Watch</span><span class="shop">Shop</span>
                </div>
            </div>
        </div>

        <div class="search-section">
            <input type="text" class="search-input" placeholder="Search by name..." value="${keyword != null ? keyword : ''}">
            <button class="search-btn">Search</button>
        </div>

        <div class="user-section">
            <div class="user-icon">👤</div>
            <span>▼</span>
        </div>
    </header>

    <!-- Main Container -->
    <div class="main-container">
        <!-- Sidebar -->
        <aside class="sidebar">
            <div class="profile-card">
                <img src="./assert/image/trikhue.jpg" alt="Avatar" class="profile-avatar" />
                <div class="profile-name"><%= admin.getUserName() %></div>
            </div>
            
            <ul class="nav-menu">
                <li class="nav-item">
                    <a href="#" class="nav-link active">Product Management</a>
                </li>
                <li class="nav-item">
                    <a href="#" class="nav-link">Order Management</a>
                </li>
                <li class="nav-item">
                    <a href="#" class="nav-link">Manage Rating And Feedback</a>
                </li>
                <li class="nav-item">
                    <a href="#" class="nav-link">Customer Management</a>
                </li>
                <li class="nav-item">
                    <a href="#" class="nav-link">Staff Management</a>
                </li>
            </ul>
            
            <button class="logout-btn">Logout</button>
        </aside>

        <!-- Main Content -->
        <main class="main-content">
            <!-- Dashboard Stats -->
            <div class="dashboard-stats">
                <!-- Revenue Section -->
                <div class="stat-card">
                    <div class="stat-title">Total Revenue</div>
                    <div class="revenue-amount">
                        <%
                            Long totalRevenue = (Long) request.getAttribute("totalRevenue");
                            if (totalRevenue != null) {
                                out.print(String.format("%,d", totalRevenue) + " ₫");
                            } else {
                                out.print("0 ₫");
                            }
                        %>
                    </div>
                    <div class="chart-placeholder">
                        <div class="chart-line"></div>
                    </div>
                </div>
                
                <!-- Top Products Section -->
                <div class="stat-card">
                    <div class="stat-title">Top Products</div>
                    <ul class="top-products-list">
                        <%
                            List<TopProduct> topProducts = (List<TopProduct>) request.getAttribute("topProducts");
                            if (topProducts != null && !topProducts.isEmpty()) {
                                for (TopProduct tp : topProducts) {
                        %>
                        <li class="top-product-item">
                            <span class="product-name"><%= tp.getProductName() %></span>
                            <span class="product-sold"><%= tp.getTotalSold() %> sold</span>
                        </li>
                        <%
                                }
                            } else {
                        %>
                        <li class="top-product-item">
                            <span class="product-name">No sales data available</span>
                            <span class="product-sold">0 sold</span>
                        </li>
                        <%
                            }
                        %>
                    </ul>
                    <button class="add-product-btn">Add New Product</button>
                        </div>
            </div>

            <!-- Additional Stats -->
            <div class="dashboard-stats">
                <!-- Monthly Revenue -->
                <div class="stat-card">
                    <div class="stat-title">This Month Revenue</div>
                    <div class="revenue-amount" style="color: #007bff;">
                        <%
                            Long currentMonthRevenue = (Long) request.getAttribute("currentMonthRevenue");
                            if (currentMonthRevenue != null) {
                                out.print(String.format("%,d", currentMonthRevenue) + " ₫");
                            } else {
                                out.print("0 ₫");
                            }
                        %>
                        </div>
                    </div>

                <!-- Total Orders -->
                <div class="stat-card">
                    <div class="stat-title">Completed Orders</div>
                    <div class="revenue-amount" style="color: #28a745;">
                        <%
                            Integer totalCompletedOrders = (Integer) request.getAttribute("totalCompletedOrders");
                            if (totalCompletedOrders != null) {
                                out.print(String.format("%,d", totalCompletedOrders));
                            } else {
                                out.print("0");
                            }
                        %>
                    </div>
                </div>
            </div>

            <!-- Product Table -->
            <div class="table-container">
                <table class="table">
                            <thead>
                                <tr>
                            <th></th>
                                    <th>Product ID</th>
                                    <th>Product Name</th>
                                    <th>Brand</th>
                            <th>Category</th>
                            <th>Price</th>
                            <th>Stock</th>
                            <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% List<Product> products = (List<Product>) request.getAttribute("products"); %>
                                <% if (products != null && !products.isEmpty()) {
                                    for (Product p : products) { %>
                                        <tr>
                                    <td>
                                        <img src="./assert/image/<%= p.getProductId() %>.jpg" 
                                             alt="<%= p.getProductName() %>" 
                                             class="product-image"
                                             onerror="this.src='./assert/image/watch1.jpg'">
                                    </td>
                                            <td class="product-id"><%= p.getProductId() %></td>
                                    <td class="product-name"><%= p.getProductName() %></td>
                                    <td class="product-brand"><%= p.getBrand() %></td>
                                    <td>
                                        <span class="product-category">
                                            <%= p.isGender() ? "Men" : "Women" %>
                                        </span>
                                    </td>
                                    <td class="product-price"><%= String.format("%,d", p.getPrice()) %> ₫</td>
                                    <td class="product-stock"><%= p.getQuantityProduct() %></td>
                                    <td>
                                        <div class="action-buttons">
                                            <button class="action-btn edit-btn" title="Edit">✏️</button>
                                            <button class="action-btn delete-btn" title="Delete">🗑️</button>
                                                </div>
                                            </td>
                                        </tr>
                                <%  }
                                } else { %>
                                    <tr>
                                <td colspan="8" style="text-align: center;">No products found in the database.</td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
        </main>
    </div>
    
    <script>
        // Sidebar navigation handling
        document.querySelectorAll('.nav-link').forEach(item => {
            item.addEventListener('click', (e) => {
                e.preventDefault();
                document.querySelectorAll('.nav-link').forEach(i => i.classList.remove('active'));
                item.classList.add('active');
            });
        });

        // Action button handlers
        document.querySelectorAll('.edit-btn').forEach(btn => {
            btn.addEventListener('click', (e) => {
                const tr = e.target.closest('tr');
                if (!tr) return;
                const id = tr.querySelector('.product-id')?.textContent || 'Unknown';
                alert('Edit product: ' + id);
            });
        });

        document.querySelectorAll('.delete-btn').forEach(btn => {
            btn.addEventListener('click', (e) => {
                const tr = e.target.closest('tr');
                if (!tr) return;
                const id = tr.querySelector('.product-id')?.textContent || 'Unknown';
                if (confirm('Are you sure you want to delete product: ' + id + '?')) {
                    alert('Delete product: ' + id);
                }
            });
        });

        // Add product button
        document.querySelector('.add-product-btn').addEventListener('click', () => {
            alert('Add new product');
        });

        // Logout button
        document.querySelector('.logout-btn').addEventListener('click', () => {
            if (confirm('Are you sure you want to logout?')) {
                window.location.href = '<%= ctx %>/logout';
            }
        });

        // Search functionality
        document.querySelector('.search-btn').addEventListener('click', () => {
            const keyword = document.querySelector('.search-input').value;
            if (keyword.trim()) {
                window.location.href = '<%= ctx %>/admin?keyword=' + encodeURIComponent(keyword);
            }
        });

        // Enter key search
        document.querySelector('.search-input').addEventListener('keypress', (e) => {
            if (e.key === 'Enter') {
                document.querySelector('.search-btn').click();
            }
        });

    </script>
</body>
</html>
