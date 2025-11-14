<%-- 
    Document   : staff_add
    Created on : Nov 7, 2025, 5:01:14 PM
    Author     : Tran Tien Dat - CE190362
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Staff" %>
<%@ include file="/WEB-INF/include/header.jsp" %>
<%!
    public String esc(String s) {
        if (s == null) {
            return "";
        }
        return s.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#x27;");
    }
%>
<%
    Staff formStaff = (Staff) request.getAttribute("staff");
    String userName = request.getParameter("userName") != null ? request.getParameter("userName")
            : (formStaff != null ? formStaff.getUserName() : "");
    String email = request.getParameter("email") != null ? request.getParameter("email")
            : (formStaff != null ? formStaff.getEmail() : "");
    String phone = request.getParameter("phone") != null ? request.getParameter("phone")
            : (formStaff != null ? formStaff.getPhone() : "");
    String position = request.getParameter("position") != null ? request.getParameter("position")
            : (formStaff != null ? formStaff.getPosition() : "");
    String address = request.getParameter("address") != null ? request.getParameter("address")
            : (formStaff != null ? formStaff.getAddress() : "");
    String role = request.getParameter("role") != null ? request.getParameter("role")
            : (formStaff != null ? formStaff.getRole() : "Staff");
    String status = request.getParameter("status") != null ? request.getParameter("status")
            : (formStaff != null ? formStaff.getStatus() : "Active");
    String successMessage = (String) request.getAttribute("successMessage");
    String errorMessage = (String) request.getAttribute("errorMessage");
    if (successMessage == null) {
        successMessage = (String) session.getAttribute("successMessage");
    }
    if (errorMessage == null) {
        errorMessage = (String) session.getAttribute("errorMessage");
    }
    if (session.getAttribute("successMessage") != null) {
        session.removeAttribute("successMessage");
    }
    if (session.getAttribute("errorMessage") != null) {
        session.removeAttribute("errorMessage");
    }
    // field-level errors (set by servlet)
    String usernameError = (String) request.getAttribute("usernameError");
    String passwordError = (String) request.getAttribute("passwordError");
    String emailError = (String) request.getAttribute("emailError");
    String phoneError = (String) request.getAttribute("phoneError");
    String positionError = (String) request.getAttribute("positionError");
    String addressError = (String) request.getAttribute("addressError");
%>
<style>
    html, body {
        margin: 0;
        padding: 0;
        background: #f5f7fb;
        overflow-x: hidden;
        height: 100%;
    }
    .page-wrap {
        padding: 0;
        background: #f5f7fb;
        min-height: calc(100vh - 60px);
    }
    .main-container {
        display: flex;
        gap: 0;
        align-items: stretch;
        width: 100%;
        min-height: calc(100vh - 60px);
        overflow: hidden;
    }
    .sidebar {
        width: 280px;
        min-width: 280px;
        background: #fff;
        padding: 22px;
        box-shadow: 2px 0 8px rgba(0,0,0,0.03);
        border-radius: 0;
        flex-shrink: 0;
        position: relative;
        display: flex;
        flex-direction: column;
    }
    .profile-card {
        text-align: center;
        margin-bottom: 18px;
    }
    .profile-avatar {
        width: 72px;
        height: 72px;
        border-radius: 50%;
        object-fit: cover;
        display: inline-block;
        border: 2px solid #e9ecef;
        background: #f0f0f0;
    }
    .profile-role {
        display: block;
        background-color: #000;
        color: #fff;
        font-size: 18px;
        font-weight: 700;
        padding: 8px 16px;
        border-radius: 6px;
        margin-top: 10px;
        width: fit-content;
        margin-left: auto;
        margin-right: auto;
    }
    .nav-menu {
        list-style: none;
        padding: 0;
        margin: 12px 0 0 0;
    }
    .nav-menu li {
        margin-bottom: 10px;
    }
    .nav-link {
        display: block;
        padding: 10px 14px;
        border-radius: 8px;
        color: #333;
        text-decoration: none;
        font-weight: 600;
    }
    .nav-link.active, .nav-link:hover {
        background: #dc3545;
        color: white;
    }
    .main-content {
        background: white;
        margin: 10px;
        border-radius: 8px;
        flex: 1 1 auto;
        padding: 24px;
        box-shadow: 0 2px 14px rgba(0,0,0,0.04);
        min-width: 0;
        overflow-x: auto;
    }
    .staff-page {
        padding: 0;
        max-width: 100%;
        margin: 0;
    }
    .page-header {
        display:flex;
        justify-content:space-between;
        align-items:center;
        gap:12px;
        margin-bottom:18px;
    }
    .page-header h2 {
        font-size:28px;
        color:#dc3545;
        margin:0;
        font-weight:700;
    }
    .form-card {
        background:#fff;
        border-radius:10px;
        padding:18px;
        box-shadow:0 8px 24px rgba(20,20,20,0.04);
    }
    .form-row {
        display:grid;
        grid-template-columns: 1fr 1fr;
        gap:12px;
        margin-bottom:12px;
    }
    .form-group {
        display:flex;
        flex-direction:column;
    }
    label {
        font-weight:600;
        margin-bottom:6px;
        color:#333;
        font-size:14px;
    }
    input[type="text"], input[type="email"], input[type="password"], textarea, select {
        padding:10px 12px;
        border:1px solid #e6e9ee;
        border-radius:8px;
        font-size:14px;
    }
    textarea {
        min-height:80px;
        resize:vertical;
    }
    .btn-primary {
        background:#28a745;
        color:#fff;
        padding:10px 16px;
        border-radius:8px;
        font-weight:700;
        text-decoration:none;
        border:none;
        cursor:pointer;
    }
    .btn-ghost {
        background:#6c757d;
        color:#fff;
        padding:10px 16px;
        border-radius:8px;
        font-weight:700;
        border:none;
        cursor:pointer;
        text-decoration:none;
        display:inline-block;
        line-height:normal;
    }
    .btn-actions {
        display:flex;
        gap:8px;
        justify-content:flex-end;
        align-items:center;
    }
    .flash {
        padding:10px 12px;
        border-radius:8px;
        margin-bottom:12px;
        font-weight:600;
    }
    .flash-success {
        background:#e6ffed;
        color:#155724;
        border:1px solid #c3e6cb;
    }
    .flash-error {
        background:#fff1f0;
        color:#721c24;
        border:1px solid #f5c6cb;
    }
    .field-error {
        color: #dc3545;
        background: #fff1f0;
        padding: 6px 10px;
        border-radius: 6px;
        margin-top:6px;
        font-size:13px;
        border: 1px solid #f5c6cb;
        display:inline-block;
    }
    input.error, textarea.error {
        border-color: #dc3545;
        box-shadow: 0 0 0 3px rgba(220,53,69,0.06);
    }
    @media (max-width:880px) {
        .form-row {
            grid-template-columns: 1fr;
        }
        .btn-actions {
            justify-content:stretch;
            gap:10px;
        }
        .btn-actions .btn-primary, .btn-actions .btn-ghost {
            width:100%;
            text-align:center;
        }
    }
</style>
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
                <li><a class="nav-link active" href="${pageContext.request.contextPath}/admin/staff">Staff Management</a></li>
                <li><a class="nav-link" href="${pageContext.request.contextPath}/listimportinventory">Import Management</a></li>
            </ul>
        </aside>
        <main class="main-content">
            <div class="staff-page">
                <div class="page-header">
                    <h2>Add New Staff</h2>
                </div>
                <% if (successMessage != null) {%>
                <div class="flash flash-success"><%= esc(successMessage)%></div>
                <% } else if (errorMessage != null) {%>
                <div class="flash flash-error"><%= esc(errorMessage)%></div>
                <% }%>
                <div class="form-card" role="form" aria-label="Add staff form">
                    <form method="post" action="${pageContext.request.contextPath}/admin/staff/add" onsubmit="return validateForm(this);">
                        <div class="form-row">
                            <div class="form-group">
                                <label for="userName">Username <span style="color:#dc3545">*</span></label>
                                <input id="userName" name="userName" type="text" value="<%= esc(userName)%>" required autocomplete="off"
                                       <%= (usernameError != null) ? "class=\"error\"" : ""%> />
                                <% if (usernameError != null) {%>
                                <div class="field-error"><%= esc(usernameError)%></div>
                                <% }%>
                            </div>
                            <div class="form-group">
                                <label for="password">Password <span style="color:#dc3545">*</span></label>
                                <input id="password" name="password" type="password" placeholder="Enter password" required autocomplete="new-password"
                                       <%= (passwordError != null) ? "class=\"error\"" : ""%> />
                                <% if (passwordError != null) {%>
                                <div class="field-error"><%= esc(passwordError)%></div>
                                <% }%>
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-group">
                                <label for="email">Email</label>
                                <input id="email" name="email" type="email" value="<%= esc(email)%>"
                                       <%= (emailError != null) ? "class=\"error\"" : ""%> />
                                <% if (emailError != null) {%>
                                <div class="field-error"><%= esc(emailError)%></div>
                                <% }%>
                            </div>
                            <div class="form-group">
                                <label for="phone">Phone</label>
                                <input id="phone" name="phone" type="text" value="<%= esc(phone)%>"
                                       <%= (phoneError != null) ? "class=\"error\"" : ""%> />
                                <% if (phoneError != null) {%>
                                <div class="field-error"><%= esc(phoneError)%></div>
                                <% }%>
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-group">
                                <label for="role">Role</label>
                                <input type="text" id="role" name="role" value="Staff" readonly class="form-control">
                            </div>
                            <div class="form-group">
                                <label for="position">Position</label>
                                <input id="position" name="position" type="text" value="<%= esc(position)%>"
                                       <%= (positionError != null) ? "class=\"error\"" : ""%> />
                                <% if (positionError != null) {%>
                                <div class="field-error"><%= esc(positionError)%></div>
                                <% }%>
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-group" style="grid-column:1 / -1;">
                                <label for="address">Address</label>
                                <textarea id="address" name="address" <%= (addressError != null) ? "class=\"error\"" : ""%>><%= esc(address)%></textarea>
                                <% if (addressError != null) {%>
                                <div class="field-error"><%= esc(addressError)%></div>
                                <% }%>
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-group">
                                <label>Status</label>
                                <input type="hidden" id="status" name="status" value="Active">
                                <span style="font-weight:600; color:#28a745;">Active</span>
                            </div>
                            <div class="form-group" style="align-self:end; text-align:left;">
                                <div class="btn-actions" style="display:flex; gap:10px; justify-content:flex-end;">
                                    <button type="submit" class="btn-primary">Add staff</button>
                                    <a class="btn-ghost" href="${pageContext.request.contextPath}/admin/staff">Cancel</a>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
            <script>
                function validateForm(form) {
                    const username = form.userName.value.trim();
                    const password = form.password.value;
                    const email = form.email.value.trim();
                    const phone = form.phone.value.trim();
                    const role = form.role.value.trim();
                    const position = form.position.value.trim();
                    const address = form.address.value.trim();
                    const status = form.status.value.trim();


                    if (username.length < 2) {
                        alert("Username must have at least 2 characters.");
                        form.userName.focus();
                        return false;
                    }

                    if (password.length < 6) {
                        alert("Password must have at least 6 characters.");
                        form.password.focus();
                        return false;
                    }

                    if (email === "" || !/^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$/.test(email)) {
                        alert("Please enter a valid email.");
                        form.email.focus();
                        return false;
                    }
                    if (phone === "" || !/^\d{10,11}$/.test(phone)) {
                        alert("Please enter a valid phone number (10-11 digits).");
                        form.phone.focus();
                        return false;
                    }

                    if (position === "") {
                        alert("Position cannot be empty.");
                        form.position.focus();
                        return false;
                    }

                    if (!/^[\p{L}\d\s]+$/u.test(position) || /^\d+$/.test(position)) {
                        alert("Position must contain at least one letter and can only contain letters, numbers and spaces (no numbers, no special characters).");
                        form.position.focus();
                        return false;
                    }

                    if (address === "") {
                        alert("Address cannot be empty.");
                        form.address.focus();
                        return false;
                    }
                    if (!/^[\p{L}\d\s]+$/u.test(address) || /^\d+$/.test(address)) {
                        alert("Address must contain at least one letter and can only contain letters, numbers and spaces (no numbers, no special characters).");
                        form.address.focus();
                        return false;
                    }

                    return true;
                }
            </script>
        </main>
    </div>
</div>
<%@ include file="/WEB-INF/include/footer.jsp" %>