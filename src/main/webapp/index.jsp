<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>HealthDotNet</title>
    <link rel="icon" type="image/svg+xml" href="./images/favicon.svg">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="./css/index.css">
</head>
<body>
    <div class="container">
        <div class="title-container">
            <img src="./images/favicon.svg" alt="HealthDotNet Logo">
            <h1>HealthDotNet</h1>
        </div>

        <p>Hospital Management System</p>

        <form action="login.jsp" method="get">
            <button type="submit" class="btn">Login</button>
        </form>

        <form action="register.jsp" method="get">
            <button type="submit" class="btn">Register</button>
        </form>

        <div class="footer">
            <p>Managed by <strong>Rajbir Singh</strong> & <strong>Rohit Chand</strong></p>
            <p>&copy; <%= java.time.Year.now() %> HealthDotNet</p>
        </div>
    </div>
</body>
</html>
