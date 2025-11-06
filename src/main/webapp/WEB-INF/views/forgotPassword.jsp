<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>HealthDotNet</title>
    <link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/images/favicon.svg">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script src="${pageContext.request.contextPath}/js/main.js"></script>
</head>
<body>
    <div class="container">
        <%@ include file="header.jsp" %>
       <p class="sub-title"><strong>Reset Password</strong></p>
        <form method="post" action="${pageContext.request.contextPath}/forgot">
            <!-- Input Fields -->
            <label for="username" class="lbl">Username</label>
            <input type="text" id="username" name="username" class="input-text" placeholder="Enter your username"
                value='<%= request.getAttribute("username") != null ? request.getAttribute("username") : "" %>'>

            <label for="fullname" class="lbl">Full Name</label>
            <input type="text" id="fullname" name="fullname" class="input-text" placeholder="Enter your full name"
                value='<%= request.getAttribute("fullname") != null ? request.getAttribute("fullname") : "" %>'>

            <label for="email" class="lbl">Email</label>
            <input type="email" id="email" name="email" class="input-text" placeholder="Enter your email"
                value='<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>'>

            <label for="contact" class="lbl">Contact</label>
            <input type="tel" id="contact" name="contact" class="input-text" placeholder="Enter your contact number"
                value='<%= request.getAttribute("contact") != null ? request.getAttribute("contact") : "" %>'>

            <label for="dateOfBirth" class="lbl">Date of Birth</label>
            <input type="date" id="dateOfBirth" name="dateOfBirth" class="input-text"
                value='<%= request.getAttribute("dateOfBirth") != null ? request.getAttribute("dateOfBirth") : "" %>'>

            <%
                String errorMessage = (String) request.getAttribute("errorMessage");
                if (errorMessage != null && !errorMessage.isEmpty()) {
            %>
                <div class="error"><%= errorMessage %></div>
            <% } %>
           
            <!-- Password -->
            <label for="password" class="lbl">New Password</label>
            <input class="input-text" type="password" id="password" name="password" placeholder="Enter your password">
            <%
                String passwordError = (String) request.getAttribute("passwordError");
                if (passwordError != null && !passwordError.isEmpty()) {
            %>
                <div class="error"><%= passwordError %></div>
            <% } %>

            <!-- Confirm Password -->
            <label for="confirmPassword" class="lbl">Confirm Password</label>
            <input class="input-text" type="password" id="confirmPassword" name="confirmPassword"
                   placeholder="Re-enter your password">
            <%
                String confirmPasswordError = (String) request.getAttribute("confirmPasswordError");
                if (confirmPasswordError != null && !confirmPasswordError.isEmpty()) {
            %>
                <div class="error"><%= confirmPasswordError %></div>
            <% } %>

           <button type="submit" class="btn">Reset Password</button>

            <%
                String dbError = (String) request.getAttribute("dbError");
                if (dbError != null && !dbError.isEmpty()) {
            %>
                <div class="error"><%= dbError %></div>
            <% } %>
        </form>
        <p class="message">
            Know your username / password? <a href="login" class="link">Login</a>
        </p>
        <%@ include file="footer.jsp" %>
    </div>
</body>
</html>
