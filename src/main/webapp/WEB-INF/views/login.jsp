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

        <p class="sub-title"><strong>Login to HealthDotNet</strong></p>

        <form action="login" method="post">
            <label for="username" class="lbl">Username:</label>
            <input type="text" name="username" placeholder="Enter your username" class="input-text">
            
            <label for="password" class="lbl">Password:</label>
            <input type="password" name="password" placeholder="Enter your password" class="input-text">

            <button type="submit" class="btn">Login</button>
            <%
                String errorMessage = (String) request.getAttribute("errorMessage");
                if (errorMessage != null && !errorMessage.isEmpty()) {
            %>
                <div class="error"><%= errorMessage %></div>
            <%
                }
            %>

        </form>

        <p class="message">
            Forgot your <a href="forgot-username" class="link">Username</a> | <a href="forgot-password" class="link">Password</a>?<br>
            Don't have an account? <a href="register" class="link">Register</a>
        </p>

    <%@ include file="footer.jsp" %>
    </div>

    <%
        String successMessage = (String) session.getAttribute("successMessage");
        if (successMessage != null && !successMessage.isEmpty()) { 
            session.removeAttribute("successMessage");  
    %> 
        <div class="modal" id="modal">
            <div class="container">
                <p class="success"><%= successMessage %></p>

                <% 
                    String username = (String) session.getAttribute("username");
                    if (username != null && !username.isEmpty()) {
                %>
                    <p class="message">Username: <strong><%= username %></strong></p>
                <% } %>

                <p class="message">Please Log into your account.</p>
                <button class="btn" onclick="document.getElementById('modal').style.display='none'">
                    Close
                </button>
            </div>
        </div>
    <% } %>
</body>
</html>
