<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0);

HttpSession sessionObj = request.getSession(false);
if (sessionObj == null || sessionObj.getAttribute("user_id") == null) {
    response.sendRedirect(request.getContextPath() + "/login");
    return;
}

String role = (String) sessionObj.getAttribute("role");
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
        <p><strong>Dashboard</strong></p>
        <a href="logout" class="sub-title-logo" style="right: 0;"><img src="${pageContext.request.contextPath}/images/logout.svg" alt="logout logo"></a>
    </div>

    <nav class="dashboard-nav">
        <a href="profile" class="completed">Profile</a>
        
        <% if ("admin".equalsIgnoreCase(role)) { %>
            <a href="manageUsers" class="completed">Manage Users</a>
            <a href="reports">Manage Reports</a>
            <a href="appointments">Manage Appointments</a>
            <a href="prescription">Manage Prescription</a>
            <a href="manageMedicines" class="completed">Manage Medicine</a>
            <a href="payments">Manage Payments</a>
            <a href="logs" class="completed">Logs</a>
        <% } %>
        
        <% if ("doctor".equalsIgnoreCase(role)) { %>
            <a href="appointments">My Appointments</a>
            <a href="patients">My Patients</a>
        <% } %>
        
        <% if ("receptionist".equalsIgnoreCase(role)) { %>
            <a href="appointments">Manage Appointments</a>
            <a href="patients">Patient Records</a>
            <a href="billing">Billing & Payments</a>
        <% } %>
        
        <% if ("patient".equalsIgnoreCase(role)) { %>
            <a href="appointments">My Appointments</a>
            <a href="doctors">Find Doctors</a>
            <a href="reports">My Reports</a>
            <a href="prescription">My Prescription</a>
            <a href="payments">Payments</a>
        <% } %>
    </nav>

    <%@ include file="footer.jsp" %>
</div>
</body>
</html>
