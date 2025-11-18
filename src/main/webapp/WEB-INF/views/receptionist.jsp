<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<% 
     String userRole = (String) session.getAttribute("role");
     String userId = (String) session.getAttribute("user_id");

     if (userRole == null || !"receptionist".equalsIgnoreCase(userRole)) {
         response.sendRedirect(request.getContextPath() + "/login");
         return;
     }
%>
<!DOCTYPE html>
<html>      
    <head>
        <meta charset="UTF-8">
        <title>Receptionist Dashboard</title>
        <link rel="stylesheet" href="styles.css">
    </head>
    <body>
        <h1>Welcome, Receptionist <%= userId %></h1>
        <div class="dashboard">
            <div class="option">
                <h3>Manage Appointments</h3>
                <p>View, schedule, and manage patient appointments.</p>
                <a href="manageAppointments.jsp">Manage Now</a>
            </div>
            <!-- <div class="option">
                <h3>Patient Check-In</h3>
                <p>Check in patients for their appointments.</p>
                <a href="patientCheckIn.jsp">Check-In Now</a>
            </div> -->
            <div class="option">
                <h3>Billing and Payments</h3>
                <p>Handle billing and process payments.</p>
                <a href="billingPayments.jsp">Process Now</a>
            </div>
            <div class="option">
                <a href="logout.jsp">Logout</a>
            </div>
        </div>  
        <footer>
            <p>&copy; 2024 HealthCare System</p>
        </footer>     
    </body>
</html>