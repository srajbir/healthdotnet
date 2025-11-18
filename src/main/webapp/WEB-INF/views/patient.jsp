<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<% 
    String userRole = (String) session.getAttribute("role");
    String userId = (String) session.getAttribute("user_id");

    if (userRole == null || !"patient".equalsIgnoreCase(userRole)) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Patient Dashboard</title>
    <link rel="stylesheet" href="styles.css">   
</head>
<body>
        <h1>Welcome, Patient <%= userId %></h1>
      <div class="dashboard">
        <div class="option">
            <h3>Book Appointment</h3>
            <p>Schedule a new appointment with a doctor.</p>
            <a href="bookAppointment.jsp">Book Now</a>
        </div>
        <div class="option">
            <h3>View Reports and Prescriptions</h3>
            <p>Check your medical reports and Prescriptions.</p>
            <a href="viewReports.jsp">View Now</a>
        </div>
        <div class="option">
            <h3>Make Payment</h3>
            <p>Pay for services or bills.</p>
            <a href="payment.jsp">Pay Now</a>
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