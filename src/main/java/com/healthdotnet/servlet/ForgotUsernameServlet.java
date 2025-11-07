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

@WebServlet("/forgot-username")
public class ForgotUsernameServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws IOException, ServletException {
        request.getRequestDispatcher("/WEB-INF/views/forgotUsername.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        String fullname = request.getParameter("fullname");
        String email = request.getParameter("email");
        String phoneNumber = request.getParameter("contact");
        String dob = request.getParameter("dateOfBirth");

        if (fullname == null || fullname.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            phoneNumber == null || phoneNumber.trim().isEmpty() ||
            dob == null || dob.trim().isEmpty()) {
                
            request.setAttribute("errorMessage", "All fields are required.");
            request.getRequestDispatcher("/WEB-INF/views/forgotUsername.jsp").forward(request, response);
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {

            try (PreparedStatement ps = conn.prepareStatement("SELECT username FROM users WHERE full_name=? AND email=? AND phone=? AND date_of_birth=?")) {
                ps.setString(1, fullname);
                ps.setString(2, email);
                ps.setString(3, phoneNumber);
                ps.setString(4, dob);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        String username = rs.getString("username");

                        HttpSession session = request.getSession();
                        session.setAttribute("successMessage", "Username fetched successfully!");
                        session.setAttribute("username", username);

                        response.sendRedirect(request.getContextPath() + "/login");
                    } else {
                        request.setAttribute("errorMessage", "No such user exists.");
                        request.getRequestDispatcher("/WEB-INF/views/forgotUsername.jsp").forward(request, response);
                    }
                }
            }

        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Database error occurred. Please try again later.");
            request.getRequestDispatcher("/WEB-INF/views/forgotUsername.jsp").forward(request, response);
            return;
        }
    }
}
