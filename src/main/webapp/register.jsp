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

        <p><strong class="sub-title">Register to HealthDotNet</strong></p>

        <form method="post" action="register">
           <label for="fullname" class="lbl">Full Name</label>
           <input class="input-text" type="text" id="fullname" name="fullname" placeholder="Enter your full name" required>

           <label for="username" class="lbl">User Name</label>
           <input class="input-text" type="text" id="username" name="username" placeholder="Enter your username" required>

           <label for="password" class="lbl">Password</label>
           <input class="input-text" type="password" id="password" name="password" placeholder="Enter your password" required>

           <label for="email" class="lbl">Email</label>
           <input class="input-text" type="email" id="email" name="email" placeholder="Enter your email" required>

           <label for="contact" class="lbl">Contact</label>
           <input class="input-text" type="tel" id="contact" name="contact" placeholder="Enter your contact number">

           <label for="dateOfBirth" class="lbl">Date of Birth</label>
           <input class="input-text" type="date" id="dateOfBirth" name="dateOfBirth">

            <%
                String errorMessage = (String) request.getAttribute("errorMessage");
                if (errorMessage != null && !errorMessage.isEmpty()) {
            %>
                <div class="error"><%= errorMessage %></div>
            <%
                }
            %>

           <button type="submit" class="btn">Register</button>

        </form>

        <%@ include file="WEB-INF/views/footer.jsp" %>
    </div>
</body>


</html>



