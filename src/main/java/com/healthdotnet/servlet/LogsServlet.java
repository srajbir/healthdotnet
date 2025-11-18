package com.healthdotnet.servlet;

import com.healthdotnet.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/logs")
public class LogsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ----------- ADMIN ACCESS CHECK ----------
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("role") == null ||
                !session.getAttribute("role").toString().equalsIgnoreCase("admin")) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // ----------- GET SEARCH PARAMETER ----------
        String search = request.getParameter("search");
        List<Map<String, Object>> logs = new ArrayList<>();

        // ----------- BASE SQL -----------
        StringBuilder sql = new StringBuilder(
            "SELECT l.log_id, l.user_id, u.role, u.username, " +
            "l.action, l.log_time " +
            "FROM logs l " +
            "JOIN users u ON l.user_id = u.user_id " +
            "WHERE 1=1"
        );

        // ----------- SEARCH ----------
        if (search != null && !search.trim().isEmpty()) {

            sql.append(" AND (");
            sql.append(" l.log_id LIKE ? ");
            sql.append(" OR l.user_id LIKE ? ");
            sql.append(" OR u.role LIKE ? ");
            sql.append(" OR u.username LIKE ? ");
            sql.append(" OR l.action LIKE ? ");
            sql.append(" OR DATE_FORMAT(l.log_time, '%Y-%m-%d %H:%i:%s') LIKE ? ");
            sql.append(")");
        }

        sql.append(" ORDER BY l.log_id DESC");

        // ----------- EXECUTE QUERY ----------
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            if (search != null && !search.trim().isEmpty()) {

                String value = "%" + search + "%";

                ps.setString(1, value);
                ps.setString(2, value);
                ps.setString(3, value);
                ps.setString(4, value);
                ps.setString(5, value);
                ps.setString(6, value);
            }

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("log_id", rs.getInt("log_id"));
                row.put("user_id", rs.getInt("user_id"));
                row.put("role", rs.getString("role"));
                row.put("username", rs.getString("username"));
                row.put("action", rs.getString("action"));
                row.put("log_time", rs.getString("log_time"));
                logs.add(row);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        // ----------- SEND TO JSP ----------
        request.setAttribute("logs", logs);
        request.getRequestDispatcher("/WEB-INF/views/logs.jsp").forward(request, response);
    }
}
