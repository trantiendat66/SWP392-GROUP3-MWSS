<%-- 
    Document   : Staff
    Created on : Oct 15, 2025, 10:29:09 AM
    Author     : Nguyen Thien Dat - CE190879 - 06/05/2005
--%>

<%@page import="model.Staff"%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/include/header.jsp" %>
<%
    Staff t = (Staff) request.getAttribute("staff");
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <style>
            body {
                font-family: Arial, sans-serif;
                background:#f4f6f8;
                padding:30px;
            }
            .card {
                width:240px;
                margin:0 auto;
                background:#fff;
                border-radius:8px;
                box-shadow:0 2px 6px rgba(0,0,0,0.1);
                display:flex;
                padding-bottom: 10px;
                overflow:hidden;
            }
            .avatar {
                width:160px;
                height:160px;
                border-radius:50%;
                object-fit:cover;
                border:6px solid #fff;
                box-shadow:0 2px 6px rgba(0,0,0,0.1);
                background:#ddd;
                align-self: center;
            }
            .name {
                font-size:20px;
                margin-top:12px;
                font-weight:700;
                text-align: center;
            }
            .status {
                color:white;
                margin-top:6px;
                font-size:14px;
                background-color: black;
                text-align: center;
                padding:4px 8px;
                border-radius:6px;
                font-size:12px;
                margin-top:6px;
                width: 40%;
                margin: 0 auto;
                display:inline-block;
            }
            .nav-link{
                box-shadow:0 2px 6px rgba(0,0,0,0.1);
                color: black;
                width: 80%;
                margin: 5px auto;
                background: #fff;
            }

            /* Table styles */
            table{
                width:100%;
                border-collapse:collapse;
                font-size:16px;
                min-width:980px;
                box-shadow:0 2px 6px rgba(0,0,0,0.1);
            }
            thead th{
                text-align:left;
                padding:10px;
                background:#fff;
                border-bottom:2px solid #222;
                font-weight:700;
                font-size:13px;
            }
            tbody td{
                padding:12px 10px;
                border-bottom:1px solid rgba(0,0,0,0.08);
                vertical-align:middle;
            }
            tbody tr:hover td{
                background: rgba(139,92,246,0.04)
            }
            .order-id{
                font-weight:700;
                color:#333
            }
            .date-pill{
                display:inline-block;
                padding:6px 8px;
                border-radius:20px;
                background:#f0f0f0;
                font-size:13px;
                color:#333;
            }
            .status-order{
                padding:6px 10px;
                border-radius:16px;
                font-weight:600;
                font-size:13px;
                display:inline-block;
                min-width:84px;
                text-align:center;
                border-radius:20px;
                background:#f0f0f0;
            }
            .status-order.pending{
                color:black;
                font-weight:700;
            }
            .status-order.completed{
                color:#00cc33;
                font-weight:700;
            }
            .status-order.cancelled{
                color:red;
                font-weight:700;
            }

            .right-actions{
                display:flex;
                gap:10px;
                justify-content:center
            }
            .icon {
                width:34px;
                height:34px;
                border-radius:50%;
                display:inline-flex;
                align-items:center;
                justify-content:center;
                background:#111;
                color:#fff;
                font-size:14px;
                cursor:pointer;
                border:1px solid rgba(0,0,0,0.08);
            }
            .icon.view{
                background:#fff;
                color:#111;
                border:1px solid #111
            }
            .icon.edit{
                background:#fff;
                color:#111;
                border:1px solid #111
            }

            @media (max-width:980px){
                table{
                    min-width:680px
                }
            }
            @media (max-width:760px){
                table{
                    min-width:0;
                    font-size:13px
                }
            }
        </style>
    </head>
    <body>
        <div class="d-flex align-items-start">
            <div class="nav flex-column nav-pills me-3" id="v-pills-tab" role="tablist" aria-orientation="vertical">
                <div class="card">
                    <img src="./assert/image/trikhue.jpg" alt="Avatar" class="avatar" />
                    <div class="name"><%= (t != null ? t.getUserName() : "Hỏng Cóa Tên")%></div>
                    <div class="status small"><%= (t != null ? t.getRole() : "None")%></div>
                </div>
                <button class="nav-link active" id="pill-product" data-bs-toggle="pill" data-bs-target="#v-pills-product" type="button" role="tab" aria-controls="v-pills-products" aria-selected="true">Product Management</button>
                <button class="nav-link" id="pill-order" data-bs-toggle="pill" data-bs-target="#v-pills-order" type="button" role="tab" aria-controls="v-pills-profile" aria-selected="false">Order Management</button>
                <button class="nav-link" id="pill-rate-feedback" data-bs-toggle="pill" data-bs-target="#v-pills-rate-feedback" type="button" role="tab" aria-controls="v-pills-messages" aria-selected="false">Rate And Feedback Management</button>
                <button class="nav-link" id="pill-profile" data-bs-toggle="pill" data-bs-target="#v-pills-profile" type="button" role="tab" aria-controls="v-pills-settings" aria-selected="false">Profile Management</button>
            </div>

            <div class="tab-content" id="v-pills-tabContent">
                <div class="tab-pane fade show active" id="v-pills-home" role="tabpanel" aria-labelledby="v-pills-home-tab" tabindex="0">
                </div>
                <div class="tab-pane fade" id="v-pills-order" role="tabpanel" aria-labelledby="v-pills-order" tabindex="0"
                     <!-- Main content -->
                     <section class="main" aria-label="Order management">
                        <div class="listOrders" role="region" aria-labelledby="orders-title">
                            <table aria-describedby="orders-desc">
                                <thead>
                                    <tr>
                                        <th>Order ID</th>
                                        <th>Customer Name</th>
                                        <th>Order Date</th>
                                        <th>Status</th>
                                        <th>Total (VND)</th>
                                        <th style="text-align:center">Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <!-- Example rows -->
                                    <tr>
                                        <td class="order-id">ORD001</td>
                                        <td>Nguyễn Văn An</td>
                                        <td><span class="date-pill">15/9/2025</span></td>
                                        <td><span class="status-order pending">Pending</span></td>
                                        <td>4,500,000</td>
                                        <td><div class="right-actions" role="group" aria-label="Actions">
                                                <button class="icon view" title="View" aria-label="Xem">
                                                    <!-- eye icon -->
                                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none"><path d="M2 12s4-7 10-7 10 7 10 7-4 7-10 7S2 12 2 12z" stroke="#111" stroke-width="1.4" stroke-linecap="round" stroke-linejoin="round"/><circle cx="12" cy="12" r="3" stroke="#111" stroke-width="1.6"/></svg>
                                                </button>
                                                <button class="icon edit" title="Edit" aria-label="Sửa">
                                                    <!-- edit icon -->
                                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none"><path d="M3 21h3l11-11-3-3L3 18v3z" stroke="#111" stroke-width="1.4" stroke-linecap="round" stroke-linejoin="round"/><path d="M14 7l3 3" stroke="#111" stroke-width="1.4" stroke-linecap="round" stroke-linejoin="round"/></svg>
                                                </button>
                                            </div></td>
                                    </tr>

                                    <tr>
                                        <td class="order-id">ORD002</td>
                                        <td>Trần Thị Hồng</td>
                                        <td><span class="date-pill">16/9/2025</span></td>
                                        <td><span class="status-order completed">Completed</span></td>
                                        <td>7,800,000</td>
                                        <td><div class="right-actions">
                                                <button class="icon view" title="View" aria-label="Xem">👁</button>
                                                <button class="icon edit" title="Edit" aria-label="Sửa">✏️</button>
                                            </div></td>
                                    </tr>

                                    <tr>
                                        <td class="order-id">ORD003</td>
                                        <td>Lê Văn Huy</td>
                                        <td><span class="date-pill">17/9/2025</span></td>
                                        <td><span class="status-order cancelled">Cancelled</span></td>
                                        <td>2,500,000</td>
                                        <td><div class="right-actions">
                                                <button class="icon view" title="View" aria-label="Xem">👁</button>
                                                <button class="icon edit" title="Edit" aria-label="Sửa">✏️</button>
                                            </div></td>
                                    </tr>

                                    <!-- more rows (for demo, repeated) -->
                                    <tr>
                                        <td class="order-id">ORD004</td>
                                        <td>Phạm Thị Thu</td>
                                        <td><span class="date-pill">18/9/2025</span></td>
                                        <td><span class="status-order completed">Completed</span></td>
                                        <td>9,500,000</td>
                                        <td><div class="right-actions">
                                                <button class="icon view" title="View" aria-label="Xem">👁</button>
                                                <button class="icon edit" title="Edit" aria-label="Sửa">✏️</button>
                                            </div></td>
                                    </tr>

                                    <tr>
                                        <td class="order-id">ORD005</td>
                                        <td>Hoàng Minh Quân</td>
                                        <td><span class="date-pill">19/9/2025</span></td>
                                        <td><span class="status-order pending">Pending</span></td>
                                        <td>3,200,000</td>
                                        <td><div class="right-actions">
                                                <button class="icon view" title="View" aria-label="Xem">👁</button>
                                                <button class="icon edit" title="Edit" aria-label="Sửa">✏️</button>
                                            </div></td>
                                    </tr>

                                    <tr>
                                        <td class="order-id">ORD006</td>
                                        <td>Võ Thị Lan</td>
                                        <td><span class="date-pill">20/9/2025</span></td>
                                        <td><span class="status-order completed">Completed</span></td>
                                        <td>35,000,000</td>
                                        <td><div class="right-actions">
                                                <button class="icon view" title="View" aria-label="Xem">👁</button>
                                                <button class="icon edit" title="Edit" aria-label="Sửa">✏️</button>
                                            </div></td>
                                    </tr>

                                </tbody>
                            </table>
                        </div>
                    </section>

                </div>
                <div class="tab-pane fade" id="v-pills-messages" role="tabpanel" aria-labelledby="v-pills-messages-tab" tabindex="0">...</div>
                <div class="tab-pane fade" id="v-pills-settings" role="tabpanel" aria-labelledby="v-pills-settings-tab" tabindex="0">...</div>
            </div>
        </div>
        <script>
            // Sidebar active handling
            document.querySelectorAll('.nav-item').forEach(item => {
                item.addEventListener('click', () => {
                    document.querySelectorAll('.nav-item').forEach(i => i.classList.remove('active'));
                    item.classList.add('active');
                    // In a real app you'd route or update content here
                });
            });

            // Example: action button handlers (just demo)
            document.querySelectorAll('.icon.view').forEach(btn => {
                btn.addEventListener('click', (e) => {
                    const tr = e.target.closest('tr');
                    if (!tr)
                        return;
                    const id = tr.querySelector('.order-id')?.textContent || 'Unknown';
                    alert('Xem chi tiết ' + id);
                });
            });
            document.querySelectorAll('.icon.edit').forEach(btn => {
                btn.addEventListener('click', (e) => {
                    const tr = e.target.closest('tr');
                    if (!tr)
                        return;
                    const id = tr.querySelector('.order-id')?.textContent || 'Unknown';
                    alert('Chỉnh sửa ' + id);
                });
            });
        </script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js" integrity="sha384-j1CDi7MgGQ12Z7Qab0qlWQ/Qqz24Gc6BM0thvEMVjHnfYGF0rmFCozFSxQBxwHKO" crossorigin="anonymous"></script>
    </body>
</html>
<jsp:include page="/WEB-INF/include/footer.jsp" />