<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Registration</title>
    <link rel="stylesheet" href="./css/registration.css">
</head>
<body>
    <div class="Registration-container">
       <h2>User Registration</h2> 
        <form method="post" action="${pageContext.request.contextPath}/register" class="Registration-form">
           <label for="fullname">Full Name</label>
           <input type="text" id="fullname" name="fullname" required><br>

           <label for="username">User Name</label>
           <input type="text" id="username" name="username" required><br>

           <label for="password">Password</label>
           <input type="password" id="password" name="password" required><br>

           <label for="email">Email</label>
           <input type="email" id="email" name="email" required><br>

           <label for="contact">Contact</label>
           <input type="tel" id="contact" name="contact"><br>

           <label for="dateOfBirth">Date of Birth</label>
           <input type="date" id="dateOfBirth" name="dateOfBirth"><br>

           <button type="submit" class="btn-submit">Register</button>
        </form>
    </div>
</body>


</html>



