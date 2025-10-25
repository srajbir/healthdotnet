package com.healthdotnet.servlet;

import java.io.IOException;
import java.sql.*;
import com.healthdotnet.model.Users;
import com.healthdotnet.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Basic field validation
        if (username == null || username.isEmpty() || password == null || password.isEmpty()) {
            request.setAttribute("errorMessage", "Please enter both username and password");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        String sql = "SELECT * FROM users WHERE username = ? AND password = ? AND is_active = TRUE";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username);
            ps.setString(2, password);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    // Create user object
                    Users user = new Users();
                    user.setUserId(rs.getInt("user_id"));
                    user.setFullName(rs.getString("full_name"));
                    user.setUsername(rs.getString("username"));
                    user.setPassword(rs.getString("password"));
                    user.setEmail(rs.getString("email"));
                    user.setContactNumber(rs.getString("phone"));
                    user.setIsActive(rs.getBoolean("is_active"));

                    Date dob = rs.getDate("date_of_birth");
                    if (dob != null) user.setDob(dob.toLocalDate());

                    Timestamp created = rs.getTimestamp("created_at");
                    if (created != null) user.setCreatedAt(created.toLocalDateTime().toLocalDate());

                    String roleStr = rs.getString("role");
                    if (roleStr != null) {
                        user.setRole(Users.Role.valueOf(roleStr.toUpperCase()));
                    }

                    // Store user in session
                    HttpSession session = request.getSession();
                    session.setAttribute("loggedInUser", user);
                    session.setMaxInactiveInterval(30 * 60); // 30 mins

                    // Role-based redirection
                    switch (roleStr.toLowerCase()) {
                        case "admin":
                            response.sendRedirect("admin-dashboard.jsp");
                            break;
                        case "doctor":
                            response.sendRedirect("doctor-dashboard.jsp");
                            break;
                        case "receptionist":
                            response.sendRedirect("receptionist-dashboard.jsp");
                            break;
                        case "patient":
                            response.sendRedirect("patient-dashboard.jsp");
                            break;
                        default:
                            response.sendRedirect("index.jsp");
                            break;
                    }

                } else {
                    request.setAttribute("errorMessage", "Invalid username or password");
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database error, please try again later.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}
