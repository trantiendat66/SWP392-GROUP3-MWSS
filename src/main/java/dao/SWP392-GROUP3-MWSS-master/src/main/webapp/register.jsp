<%-- 
    Document   : register
    Created on : Oct 11, 2025, 3:54:58 PM
    Author     : Oanh Nguyen
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
  String ctx = request.getContextPath();
  String err = (String) request.getAttribute("error");
  String name   = request.getParameter("customer_name")==null?"":request.getParameter("customer_name");
  String phone  = request.getParameter("phone")==null?"":request.getParameter("phone");
  String email  = request.getParameter("email")==null?"":request.getParameter("email");
  String address= request.getParameter("address")==null?"":request.getParameter("address");
  String gender = request.getParameter("gender")==null?"":request.getParameter("gender");
  String dob    = request.getParameter("dob")==null?"":request.getParameter("dob");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Create Your Account</title>
        <style>
            body{
                font-family:Arial;
                background:#f4f6f8;
                margin:0
            }
            .wrap{
                max-width:980px;
                margin:40px auto;
                background:#fff;
                border-radius:10px;
                box-shadow:0 6px 20px rgba(0,0,0,.08);
                display:flex;
                overflow:hidden
            }
            .left{
                flex:1;
                padding:40px;
                background:linear-gradient(135deg,#0ea5e9,#2563eb);
                color:#fff
            }
            .left h2{
                margin:0 0 10px
            }
            .right{
                flex:1.2;
                padding:40px
            }
            .grid{
                display:grid;
                grid-template-columns:1fr 1fr;
                gap:16px
            }
            .grid .full{
                grid-column:1 / -1
            }
            label{
                font-weight:600;
                font-size:14px
            }
            input,select{
                width:100%;
                padding:10px 12px;
                border:1px solid #e5e7eb;
                border-radius:8px
            }
            .btn{
                width:100%;
                padding:12px 14px;
                border:0;
                border-radius:10px;
                background:#2563eb;
                color:#fff;
                font-weight:700;
                cursor:pointer
            }
            .err{
                background:#fee2e2;
                color:#b91c1c;
                padding:10px 12px;
                border-radius:8px;
                margin-bottom:12px
            }
        </style>
    </head>
    <body>
        <div class="wrap">
            <div class="left">
                <h2>Welcome to Watch Shop</h2>
                <p>Join a thriving community and access premium content.<br/>Your time starts here.</p>
            </div>
            <div class="right">
                <h2>Create Your Account</h2>

                <% if (err != null) { %><div class="err"><%= err %></div><% } %>

                <form action="${pageContext.request.contextPath}/RegisterController"
                      method="post"
                      enctype="multipart/form-data"
                      accept-charset="UTF-8">

                    <div class="grid">
                        <div>
                            <label>Full Name</label>
                            <input type="text" name="customer_name" value="<%=name%>" required>
                        </div>
                        <div>
                            <label>Phone</label>
                            <input type="text" name="phone" value="<%=phone%>" required>
                        </div>
                        <div class="full">
                            <label>Email</label>
                            <input type="email" name="email" value="<%=email%>" required>
                        </div>
                        <div class="full">
                            <label>Address</label>
                            <input type="text" name="address" value="<%=address%>">
                        </div>
                        <div>
                            <label>Date of Birth</label>
                            <input type="date" name="dob" value="<%=dob%>">
                        </div>
                        <div>
                            <label>Gender</label>
                            <select name="gender">
                                <option value="" <%= gender.equals("")?"selected":"" %> >-- Select --</option>
                                <option value="Male"   <%= gender.equals("Male")?"selected":"" %>>Male</option>
                                <option value="Female" <%= gender.equals("Female")?"selected":"" %>>Female</option>
                                <option value="Other"  <%= gender.equals("Other")?"selected":"" %>>Other</option>
                            </select>
                        </div>
                        <div>
                            <label>Password</label>
                            <input type="password" name="password" required>
                        </div>
                        <div>
                            <label>Confirm Password</label>
                            <input type="password" name="confirm_password" required>
                        </div>
                        <div class="full">
                            <label>Avatar (optional)</label>
                            <input type="file" name="image" accept="image/*">
                        </div>
                        <div class="full">
                            <button class="btn" type="submit">Register</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </body>
</html>


