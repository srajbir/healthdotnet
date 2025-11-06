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

        <h1 class="sub-title">404 - Page Not Found</h1>
        <p class="message">We couldn't find what you were looking for.</p>
        <a href="${pageContext.request.contextPath}/" class="link">Go Back Home</a>

        <%@ include file="footer.jsp" %>
    </div>
</body>
</html>
