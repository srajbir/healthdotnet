package com.healthdotnet.util;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class AppLogger {

    public static void log(Connection conn, int userId, String action) {
        String sql = "INSERT INTO logs (user_id, action) VALUES (?, ?)";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, action);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
