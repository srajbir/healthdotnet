<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>HealthDotNet</title>
    <link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/images/favicon.svg">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script src="${pageContext.request.contextPath}/js/main.js"></script>
</head>
<body>
    <div class="container">
        <%@ include file="header.jsp" %>

        <p class="sub-title"><strong>Register to HealthDotNet</strong></p>

        <form method="post" action="register">
            <!-- Full Name -->
            <label for="fullname" class="lbl">Full Name</label>
            <input class="input-text" type="text" id="fullname" name="fullname"
                   value='<%= request.getAttribute("fullname") != null ? request.getAttribute("fullname") : "" %>'
                   placeholder="Enter your full name">
            <%
                String fullnameError = (String) request.getAttribute("fullnameError");
                if (fullnameError != null && !fullnameError.isEmpty()) {
            %>
                <div class="error"><%= fullnameError %></div>
            <% } %>

            <!-- Username -->
            <label for="username" class="lbl">Username</label>
            <input class="input-text" type="text" id="username" name="username"
                   value='<%= request.getAttribute("username") != null ? request.getAttribute("username") : "" %>'
                   placeholder="Enter your username">
            <%
                String usernameError = (String) request.getAttribute("usernameError");
                if (usernameError != null && !usernameError.isEmpty()) {
            %>
                <div class="error"><%= usernameError %></div>
            <% } %>

            <!-- Password -->
            <label for="password" class="lbl">Password</label>
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

            <!-- Email -->
            <label for="email" class="lbl">Email</label>
            <input class="input-text" type="email" id="email" name="email"
                   value='<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>'
                   placeholder="Enter your email">
            <%
                String emailError = (String) request.getAttribute("emailError");
                if (emailError != null && !emailError.isEmpty()) {
            %>
                <div class="error"><%= emailError %></div>
            <% } %>

            <!-- Contact -->
            <label for="contact" class="lbl">Contact</label>
            <input class="input-text" type="tel" id="contact" name="contact"
                   value='<%= request.getAttribute("contact") != null ? request.getAttribute("contact") : "" %>'
                   placeholder="Enter your contact number">
            <%
                String contactError = (String) request.getAttribute("contactError");
                if (contactError != null && !contactError.isEmpty()) {
            %>
                <div class="error"><%= contactError %></div>
            <% } %>

            <!-- Date of Birth -->
            <label for="dateOfBirth" class="lbl">Date of Birth</label>
            <input class="input-text" type="date" id="dateOfBirth" name="dateOfBirth"
                   value='<%= request.getAttribute("dateOfBirth") != null ? request.getAttribute("dateOfBirth") : "" %>'>
            <%
                String dobError = (String) request.getAttribute("dobError");
                if (dobError != null && !dobError.isEmpty()) {
            %>
                <div class="error"><%= dobError %></div>
            <% } %>

            <button type="submit" class="btn">Register</button>

            <%
                String dbError = (String) request.getAttribute("dbError");
                if (dbError != null && !dbError.isEmpty()) {
            %>
                <div class="error"><%= dbError %></div>
            <% } %>
        </form>

        <p class="message">
            Already have an account? <a href="login" class="link">Login</a>
        </p>

        <%@ include file="footer.jsp" %>
    </div>
</body>
</html>