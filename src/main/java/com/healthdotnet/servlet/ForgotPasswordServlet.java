package com.healthdotnet.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.healthdotnet.util.DBConnection;
@WebServlet("/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws IOException, ServletException {
        request.getRequestDispatcher("/WEB-INF/views/forgotPassword.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        
        String username = request.getParameter("username");
        String fullname = request.getParameter("fullname");
        String email = request.getParameter("email");
        String phoneNumber = request.getParameter("contact");
        String dob = request.getParameter("dateOfBirth");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        if (username == null || username.trim().isEmpty() ||
            fullname == null || fullname.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            phoneNumber == null || phoneNumber.trim().isEmpty() ||
            dob == null || dob.trim().isEmpty()) {

            request.setAttribute("username", username);
            request.setAttribute("fullname", fullname);
            request.setAttribute("email", email);
            request.setAttribute("contact", phoneNumber);
            request.setAttribute("dateOfBirth", dob);

            request.setAttribute("errorMessage", "All fields are required.");
            request.getRequestDispatcher("/WEB-INF/views/forgotPassword.jsp").forward(request, response);
            return;

        }

        try (Connection conn = DBConnection.getConnection()) {

            try (PreparedStatement ps = conn.prepareStatement("SELECT user_id FROM users WHERE username=? AND full_name=? AND email=? AND phone=? AND date_of_birth=?")) {
                ps.setString(1, username);
                ps.setString(2, fullname);
                ps.setString(3, email);
                ps.setString(4, phoneNumber);
                ps.setString(5, dob);
                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) {
                        request.setAttribute("username", username);
                        request.setAttribute("fullname", fullname);
                        request.setAttribute("email", email);
                        request.setAttribute("contact", phoneNumber);
                        request.setAttribute("dateOfBirth", dob);
                        
                        request.setAttribute("errorMessage", "No such user exists.");
                        request.getRequestDispatcher("/WEB-INF/views/forgotPassword.jsp").forward(request, response);
                        return;
                    }
                }
            }

        Boolean hasError = false;

        if (password == null || password.trim().isEmpty()) {
            request.setAttribute("passwordError", "Password is required.");
            hasError = true;
        } else if (password.length() < 6) {
            request.setAttribute("passwordError", "Password must be at least 6 characters.");
            hasError = true;
        } else if (!password.matches(".*[A-Z].*")) {
            request.setAttribute("passwordError", "Password must contain at least one uppercase letter.");
            hasError = true;
        } else if (!password.matches(".*[a-z].*")) {
            request.setAttribute("passwordError", "Password must contain at least one lowercase letter.");
            hasError = true;
        } else if (!password.matches(".*\\d.*")) {
            request.setAttribute("passwordError", "Password must contain at least one digit.");
            hasError = true;
        } else if (!password.matches(".*[!@#$%^&*()].*")) {
            request.setAttribute("passwordError", "Password must contain at least one special character.");
            hasError = true;
        }

        if (confirmPassword == null || confirmPassword.trim().isEmpty()) {
            request.setAttribute("confirmPasswordError", "Confirm password is required.");
            hasError = true;
        } else if (!password.equals(confirmPassword)) {
            request.setAttribute("confirmPasswordError", "Passwords do not match.");
            hasError = true;
        }

        if (hasError) {
            request.setAttribute("username", username);
            request.setAttribute("fullname", fullname);
            request.setAttribute("email", email);
            request.setAttribute("contact", phoneNumber);
            request.setAttribute("dateOfBirth", dob);
            request.getRequestDispatcher("/WEB-INF/views/forgotPassword.jsp").forward(request, response);
            return;
        }

        try (PreparedStatement ps = conn.prepareStatement("UPDATE users SET password=? WHERE username=? AND email=?")) {
            ps.setString(1, confirmPassword);
            ps.setString(2, username);
            ps.setString(3, email);
            ps.executeUpdate();
        };

        HttpSession session = request.getSession();
        session.setAttribute("successMessage", "Password reset successful.");
        response.sendRedirect(request.getContextPath() + "/login");

        } catch (SQLException e) {
            request.setAttribute("username", username);
            request.setAttribute("fullname", fullname);
            request.setAttribute("email", email);
            request.setAttribute("contact", phoneNumber);
            request.setAttribute("dateOfBirth", dob);

            request.setAttribute("dbError", "Database error occurred. Please try again later.");
            request.getRequestDispatcher("/WEB-INF/views/forgotPassword.jsp").forward(request, response);
            return;
        }
    }
}
