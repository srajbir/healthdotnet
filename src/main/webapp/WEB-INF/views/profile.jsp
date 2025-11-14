<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0);

HttpSession sessionObj = request.getSession(false);
if (sessionObj == null || sessionObj.getAttribute("user_id") == null) {
    response.sendRedirect("login.jsp");
    return;
}
%>

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

    <div class="bar-container">
        <a href="javascript:history.back()" class="sub-title-logo" style="left: 0;"><img src="${pageContext.request.contextPath}/images/back.svg" alt="back logo"></a>
        <p class="sub-title"><strong>Your Profile</strong></p>
        <a href="logout" class="sub-title-logo" style="right: 0;"><img src="${pageContext.request.contextPath}/images/logout.svg" alt="logout logo"></a>
    </div>

    <form method="post" action="profile">
        <!-- USERNAME (READONLY) -->
        <label for="username" class="lbl">Username</label>
        <input class="input-text" type="text" id="username" name="username"
               value='<%= request.getAttribute("username") != null ? request.getAttribute("username") : "" %>' readonly>

        <!-- FULL NAME -->
        <label for="full_name" class="lbl">Full Name</label>
        <input class="input-text" type="text" id="full_name" name="full_name"
               value='<%= request.getAttribute("full_name") != null ? request.getAttribute("full_name") : "" %>'>
        <% if (request.getAttribute("fullNameError") != null) { %>
            <div class="error"><%= request.getAttribute("fullNameError") %></div>
        <% } %>

        <!-- EMAIL -->
        <label for="email" class="lbl">Email</label>
        <input class="input-text" type="email" id="email" name="email"
               value='<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>'>
        <% if (request.getAttribute("emailError") != null) { %>
            <div class="error"><%= request.getAttribute("emailError") %></div>
        <% } %>

        <!-- PHONE -->
        <label for="phone" class="lbl">Phone</label>
        <input class="input-text" type="tel" id="phone" name="phone"
               value='<%= request.getAttribute("phone") != null ? request.getAttribute("phone") : "" %>'>
        <% if (request.getAttribute("phoneError") != null) { %>
            <div class="error"><%= request.getAttribute("phoneError") %></div>
        <% } %>

        <!-- DATE OF BIRTH -->
        <label for="date_of_birth" class="lbl">Date of Birth</label>
        <input class="input-text" type="date" id="date_of_birth" name="date_of_birth"
               value='<%= request.getAttribute("date_of_birth") != null ? request.getAttribute("date_of_birth") : "" %>'>
        <% if (request.getAttribute("dobError") != null) { %>
            <div class="error"><%= request.getAttribute("dobError") %></div>
        <% } %>

        <!-- DOCTOR-ONLY FIELDS -->
        <%
            String role = (String) sessionObj.getAttribute("role");
            if ("doctor".equalsIgnoreCase(role)) {
        %>
            <hr>
            
            <label for="speciality" class="lbl">Speciality</label>
            <input class="input-text" type="text" id="speciality" name="speciality"
                   value='<%= request.getAttribute("speciality") != null ? request.getAttribute("speciality") : "" %>'>
            <% if (request.getAttribute("specialityError") != null) { %>
                <div class="error"><%= request.getAttribute("specialityError") %></div>
            <% } %>

            <label for="consultation_fee" class="lbl">Consultation Fee</label>
            <input class="input-text" type="number" step="0.01" id="consultation_fee" name="consultation_fee"
                   value='<%= request.getAttribute("consultation_fee") != null ? request.getAttribute("consultation_fee") : "" %>'>
            <% if (request.getAttribute("consultationFeeError") != null) { %>
                <div class="error"><%= request.getAttribute("consultationFeeError") %></div>
            <% } %>
        <% } %>
    
        <hr>

        <!-- New Password -->
        <label for="newPassword" class="lbl">New Password</label>
        <input class="input-text" type="password" id="newPassword" name="newPassword" placeholder="Enter your new password">
        <% if (request.getAttribute("newPasswordError") != null) { %>
            <div class="error"><%= request.getAttribute("newPasswordError") %></div>
            <% } %>
            
        <!-- Confirm New Password -->
        <label for="confirmPassword" class="lbl">Confirm New Password</label>
        <input class="input-text" type="password" id="confirmPassword" name="confirmPassword" placeholder="Re-enter your new password">
        <% if (request.getAttribute("confirmNewPasswordError") != null) { %>
            <div class="error"><%= request.getAttribute("confirmNewPasswordError") %></div>
            <% } %>
    
        <hr>

        <!-- PASSWORD CONFIRMATION -->
        <label for="password" class="lbl">Confirm Current Password</label>
        <input class="input-text" type="password" id="password" name="password" placeholder="Enter your current password to update">
        <% if (request.getAttribute("passwordError") != null) { %>
            <div class="error"><%= request.getAttribute("passwordError") %></div>
        <% } %>

        <!-- BUTTONS -->
        <button type="submit" class="btn">Update Profile</button>

        <!-- SUCCESS OR ERROR MESSAGES -->
        <% if (request.getAttribute("successMessage") != null) { %>
            <div class="success"><%= request.getAttribute("successMessage") %></div>
        <% } else if (request.getAttribute("errorMessage") != null) { %>
            <div class="error"><%= request.getAttribute("errorMessage") %></div>
        <% } %>

    </form>

    <%@ include file="footer.jsp" %>
</div>
</body>
</html>
