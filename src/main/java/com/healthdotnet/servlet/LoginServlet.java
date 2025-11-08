package com.healthdotnet.servlet;

import java.io.IOException;
import java.sql.*;
import com.healthdotnet.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Basic field validation
            if (username == null || username.isEmpty() || password == null || password.isEmpty()) {
                request.setAttribute("errorMessage", "Please enter both username and password");
                request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
                return;
            }

        String sql = "SELECT user_id, role FROM users WHERE username = ? AND password = ? AND is_active = TRUE";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username);
            ps.setString(2, password);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    // User data
                    String userId = rs.getString("user_id");
                    String role = rs.getString("role");

                    // Invalidate old session if any
                    HttpSession oldSession = request.getSession(false);
                    if (oldSession != null) {
                        oldSession.invalidate();
                    }

                    // Create a new session
                    HttpSession newSession = request.getSession(true);
                    newSession.setAttribute("user_id", userId);
                    newSession.setAttribute("role", role);
                    newSession.setMaxInactiveInterval(60 * 60); // 60 mins

                    // Role-based redirection
                    switch (role.toLowerCase()) {
                        case "admin":
                            response.sendRedirect(request.getContextPath() + "/admin-dashboard");
                            break;
                        case "doctor":
                            response.sendRedirect(request.getContextPath() + "/doctor-dashboard");
                            break;
                        case "receptionist":
                            response.sendRedirect(request.getContextPath() + "/receptionist-dashboard");
                            break;
                        case "patient":
                            response.sendRedirect(request.getContextPath() + "/patient-dashboard");
                            break;
                        default:
                            response.sendRedirect(request.getContextPath() + "/login");
                            // response.sendRedirect(request.getContextPath() + "/profile"); // for testing profile page, disable all cases except default
                            break;
                    }

                } else {
                    request.setAttribute("errorMessage", "Invalid username or password");
                    request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database error, please try again later.");
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
        }
    }
}
