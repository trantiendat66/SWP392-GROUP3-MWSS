<%-- 
    Document   : import_detail.jsp
    Created on : Nov 13, 2025, 9:52:57 PM
    Author     : Cola
--%>


<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/include/header.jsp" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Import Inventory Detail</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
        <style>
            html, body { margin: 0; padding: 0; background: #f5f7fb; overflow-x: hidden; height: 100%; }
            .page-wrap { padding: 0; background: #f5f7fb; min-height: calc(100vh - 60px); }
            .main-container { display: flex; gap: 0; align-items: stretch; width: 100%; min-height: calc(100vh - 60px); overflow: hidden; }
            .sidebar { width: 280px; min-width: 280px; background: #fff; padding: 22px; box-shadow: 2px 0 8px rgba(0,0,0,0.03); border-radius: 0; flex-shrink: 0; position: relative; display: flex; flex-direction: column; }
            .profile-card { text-align: center; margin-bottom: 18px; }
            .profile-avatar { width: 72px; height: 72px; border-radius: 50%; object-fit: cover; display: inline-block; border: 2px solid #e9ecef; background: #f0f0f0; }
            .profile-role { display: block; background-color: #000; color: #fff; font-size: 18px; font-weight: 700; padding: 8px 16px; border-radius: 6px; margin-top: 10px; width: fit-content; margin-left: auto; margin-right: auto; }
            .nav-menu { list-style: none; padding: 0; margin: 12px 0 0 0; }
            .nav-menu li { margin-bottom: 10px; }
            .nav-link { display: block; padding: 10px 14px; border-radius: 8px; color: #333; text-decoration: none; font-weight: 600; }
            .nav-link.active, .nav-link:hover { background: #dc3545; color: white; }
            .main-content { background: white; margin: 10px; border-radius: 8px; flex: 1 1 auto; padding: 24px; box-shadow: 0 2px 14px rgba(0,0,0,0.04); min-width: 0; overflow-x: auto; }
        </style>
    </head>
    <body>
        <div class="page-wrap">
            <div class="main-container">
                <aside class="sidebar">
                    <div class="profile-card">
                        <img class="profile-avatar" src="${pageContext.request.contextPath}/assert/image/account.jpg" alt="avatar"/>
                        <c:choose>
                            <c:when test="${not empty sessionScope.staff}">
                                <div class="profile-role">${sessionScope.staff.role}</div>
                            </c:when>
                            <c:otherwise>
                                <div class="profile-role">Guest</div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <ul class="nav-menu">
                        <li><a class="nav-link" href="${pageContext.request.contextPath}/product">Product Management</a></li>
                        <li><a class="nav-link" href="${pageContext.request.contextPath}/staffcontrol?active=admino">Order Management</a></li>
                        <li><a class="nav-link" href="${pageContext.request.contextPath}/staffcontrol?active=admin">Ratings & Feedback</a></li>
                        <li><a class="nav-link" href="${pageContext.request.contextPath}/admin/customerlist">Customer Management</a></li>
                        <li><a class="nav-link" href="${pageContext.request.contextPath}/admin/staff">Staff Management</a></li>
                        <li><a class="nav-link active" href="${pageContext.request.contextPath}/listimportinventory">Import Management</a></li>
                    </ul>
                </aside>
                <main class="main-content">
                    <h2 class="mb-4">Import Inventory Detail</h2>

        <c:set var="inv" value="${inventory}" />

        <div class="mb-3">
            <p><strong>Import ID:</strong> ${inv.importInvetoryId}</p>
            <p><strong>Supplier:</strong> ${inv.supplier}</p>
            <p><strong>Import Date:</strong> ${inv.importDate}</p>
            <p><strong>Created At:</strong> ${inv.importAt}</p>
            <p><strong>Total Quantity:</strong> ${inv.totalImportQuantity}</p>
            <p><strong>Total Import Price:</strong> ${inv.totalImportPrice}</p>
            <div class="d-flex align-items-center gap-3 mb-4">

                <label class="form-label mb-0"><strong>Status:</strong></label>

                <c:choose>
                    <c:when test="${!inv.importStatus}">
                        <form action="updateimportstatus" method="post" class="d-flex align-items-center gap-2">
                            <input type="hidden" name="id" value="${inv.importInvetoryId}">

                            <select name="status" class="form-select" style="width: fit-content; min-width: max-content;">
                                <option value="0" selected>Not import</option>
                                <option value="1">Imported successfully</option>
                            </select>

                            <button type="submit" class="btn btn-success">Save</button>
                        </form>
                    </c:when>
                    <c:otherwise>
                        <select class="form-select" style="width: fit-content; min-width: max-content;" disabled>
                            <option value="1" selected>Imported successfully</option>
                        </select>
                    </c:otherwise>

                </c:choose>

            </div>

        </div>

        <h4>Imported Products</h4>
        <table class="table table-striped">
            <thead>
                <tr>
                    <th>#</th>
                    <th>Product</th>
                    <th>Import Price</th>
                    <th>Quantity</th>
                    <th>Subtotal</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="p" items="${products}" varStatus="st">
                    <tr>
                        <td>${st.index + 1}</td>
                        <td>${p.productName}</td>
                        <td>${p.importProductPrice}</td>
                        <td>${p.importQuantity}</td>
                        <td>${p.importProductPrice * p.importQuantity}</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

                    <a href="listimportinventory" class="btn btn-secondary mt-3">Back to list</a>
                </main>
            </div>
        </div>
        <jsp:include page="/WEB-INF/include/footer.jsp" />
    </body>
</html>
