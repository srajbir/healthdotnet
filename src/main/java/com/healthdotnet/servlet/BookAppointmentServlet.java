package com.healthdotnet.servlet;

import com.healthdotnet.util.DBConnection;
import com.healthdotnet.util.AppLogger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/bookAppointment")
public class BookAppointmentServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("role") == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        if (!"patient".equals(session.getAttribute("role").toString())) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        int userId = Integer.parseInt(session.getAttribute("user_id").toString());

        Connection con = null;
        List<Map<String, String>> appointments = new ArrayList<>();

        try {
            con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(
                "SELECT appointment_id, speciality_required, appointment_date, status " +
                "FROM appointments WHERE patient_id = ? ORDER BY appointment_date DESC"
            );
            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, String> row = new HashMap<>();
                row.put("id", rs.getString("appointment_id"));
                row.put("speciality", rs.getString("speciality_required"));
                row.put("date", rs.getString("appointment_date"));
                row.put("status", rs.getString("status"));
                appointments.add(row);
            }

            req.setAttribute("appointments", appointments);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", "Failed to load appointments.");
        } finally {
            DBConnection.close(con);
        }

        req.getRequestDispatcher("/WEB-INF/views/bookAppointment.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("role") == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        if (!"patient".equals(session.getAttribute("role").toString())) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action = req.getParameter("action");

        if ("cancel".equals(action)) {
            cancelAppointment(req, res);
        } else {
            requestAppointment(req, res);
        }
    }

    private void requestAppointment(HttpServletRequest req, HttpServletResponse res) throws IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        int userId = Integer.parseInt(session.getAttribute("user_id").toString());
        String speciality = req.getParameter("speciality");
        String date = req.getParameter("appointment_date");

        if (speciality == null || speciality.isBlank() || date == null || date.isBlank()) {
            res.sendRedirect(req.getContextPath() + "/bookAppointment?errorMessage=All+fields+are+required");
            return;
        }

        Connection con = null;

        try {
            con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO appointments (patient_id, speciality_required, appointment_date, status) " +
                "VALUES (?, ?, ?, 'waiting')"
            );
            ps.setInt(1, userId);
            ps.setString(2, speciality);
            ps.setString(3, date);
            ps.executeUpdate();

            AppLogger.log(con, userId, "Created new appointment");

            res.sendRedirect(req.getContextPath() + "/bookAppointment?successMessage=Appointment+requested+successfully");

        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect(req.getContextPath() + "/bookAppointment?errorMessage=Failed+to+request+appointment");
        } finally {
            DBConnection.close(con);
        }
    }

    private void cancelAppointment(HttpServletRequest req, HttpServletResponse res) throws IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            res.sendRedirect("login.jsp");
            return;
        }

        int userId = Integer.parseInt(session.getAttribute("user_id").toString());
        String appointmentId = req.getParameter("appointment_id");

        if (appointmentId == null) {
            res.sendRedirect(req.getContextPath() + "/bookAppointment?errorMessage=Invalid+appointment+ID");
            return;
        }

        Connection con = null;

        try {
            con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(
                "UPDATE appointments SET status='cancelled' WHERE appointment_id = ? AND patient_id = ?"
            );
            ps.setInt(1, Integer.parseInt(appointmentId));
            ps.setInt(2, userId);

            int updated = ps.executeUpdate();

            if (updated > 0) {
                AppLogger.log(con, userId, "Cancelled appointment ID: " + appointmentId);
            }

            res.sendRedirect(req.getContextPath() + "/bookAppointment?successMessage=Appointment+cancelled");

        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect(req.getContextPath() + "/bookAppointment?errorMessage=Failed+to+cancel");
        } finally {
            DBConnection.close(con);
        }
    }
}
