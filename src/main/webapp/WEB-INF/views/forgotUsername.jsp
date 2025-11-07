<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1
response.setHeader("Pragma", "no-cache"); // HTTP 1.0
response.setDateHeader("Expires", 0); // Proxies
%>

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
       <p class="sub-title"><strong>Forgot Username</strong></p>
        <form method="post" action="${pageContext.request.contextPath}/forgot-username">
           <label for="fullname" class="lbl">Full Name</label>
           <input type="text" id="fullname" name="fullname" class="input-text" placeholder="Enter your full name">

           <label for="email" class="lbl">Email</label>
           <input type="email" id="email" name="email" class="input-text" placeholder="Enter your email">

           <label for="contact" class="lbl">Contact</label>
           <input type="tel" id="contact" name="contact" class="input-text" placeholder="Enter your contact number">

           <label for="dateOfBirth" class="lbl">Date of Birth</label>
           <input type="date" id="dateOfBirth" name="dateOfBirth" class="input-text">

           <button type="submit" class="btn">Get Details</button>
            <%
                String errorMessage = (String) request.getAttribute("errorMessage");
                if (errorMessage != null && !errorMessage.isEmpty()) {
            %>
                <div class="error"><%= errorMessage %></div>
            <% } %>
        </form>
        <p class="message">
            Know your username / password? <a href="login" class="link">Login</a>
        </p>
        <%@ include file="footer.jsp" %>
    </div>
</body>
</html>
