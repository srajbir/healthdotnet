<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>HealthDotNet</title>
    <link rel="icon" type="image/svg+xml" href="images/favicon.svg">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="container">
        <%@ include file="WEB-INF/views/header.jsp" %>

        <form action="login" method="get">
            <button type="submit" class="btn">Login</button>
        </form>

        <form action="register" method="get">
            <button type="submit" class="btn">Register</button>
        </form>

        <%@ include file="WEB-INF/views/footer.jsp" %>
    </div>
</body>
</html>
