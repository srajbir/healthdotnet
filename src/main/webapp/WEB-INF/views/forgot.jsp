<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>HealthDotNet</title>
    <link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/images/favicon.svg">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="container">
        <%@ include file="header.jsp" %>
       <h2>Forgot Password</h2> 
        <form method="post" action="${pageContext.request.contextPath}/forgot" class="Detail-form">
           <label for="fullname">Full Name</label>
           <input type="text" id="fullname" name="fullname" required><br>

           <label for="email">Email</label>
           <input type="email" id="email" name="email" required><br>

           <label for="contact">Contact</label>
           <input type="tel" id="contact" name="contact"><br>

           <label for="dateOfBirth">Date of Birth</label>
           <input type="date" id="dateOfBirth" name="dateOfBirth"><br>

           <button type="submit" class="btn-submit">Send reset link to registered Email</button>
        </form>
        <%@ include file="footer.jsp" %>
    </div>
</body>
</html>
