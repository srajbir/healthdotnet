<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>HealthDotNet</title>
    <link rel="icon" type="image/svg+xml" href="./images/favicon.svg">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="./css/style.css">
</head>
<body>
    <div class="container">
        <div class="title-container">
            <img src="./images/favicon.svg" alt="HealthDotNet Logo">
            <h1>HealthDotNet</h1>
        </div>

        <p class="sub-title">Hospital Management System</p>

        <form action="LoginServlet" method="post">
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
            Forgot your username / password? <a href="reset_data.jsp">Reset Password</a><br>
            Don't have an account? <a href="register.jsp">Register</a>
        </p>

        <div class="footer">
            <p>Managed by <strong>Rajbir Singh</strong> & <strong>Rohit Chand</strong></p>
            <p>&copy; <%= java.time.Year.now() %> HealthDotNet</p>
        </div>
    </div>
</body>
</html>
