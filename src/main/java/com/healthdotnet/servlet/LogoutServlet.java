package com.healthdotnet.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.healthdotnet.util.DBConnection;
import com.healthdotnet.util.AppLogger;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session != null) {
            Object userIdObj = session.getAttribute("user_id");
            int userId = (userIdObj != null) ? Integer.parseInt(userIdObj.toString()) : 0;

            // Log logout action
            try (Connection conn = DBConnection.getConnection()) {
                AppLogger.log(conn, userId, "Logout successful");
            } catch (SQLException e) {
                e.printStackTrace();
            }

            session.invalidate();
        }
        response.sendRedirect(request.getContextPath() + "/login");
    }
}
