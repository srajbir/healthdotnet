<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>HealthDotNet</title>
    <link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/images/favicon.svg">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="container">
        <%@ include file="header.jsp" %>

        <p><strong class="sub-title">Login to HealthDotNet</strong></p>

        <form action="login" method="post">
            <label for="username" class="lbl">Username:</label>
            <input type="text" name="username" placeholder="Enter your username" class="input-text">
            
            <label for="password" class="lbl">Password:</label>
            <input type="password" name="password" placeholder="Enter your password" class="input-text">

            <%
                String errorMessage = (String) request.getAttribute("errorMessage");
                if (errorMessage != null && !errorMessage.isEmpty()) {
            %>
                <div class="error"><%= errorMessage %></div>
            <%
                }
            %>

            <button type="submit" class="btn">Login</button>
        </form>

        <p class="message">
            Forgot your username / password? <a href="forgot" class="link">Reset Password</a><br>
            Don't have an account? <a href="register" class="link">Register</a>
        </p>

    <%@ include file="footer.jsp" %>
    </div>
</body>
</html>
