package com.healthdotnet.servlet;

import com.healthdotnet.util.AppLogger;
import com.healthdotnet.util.DBConnection;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/scheduleAppointment")
public class ScheduleAppointmentServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("role") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        if (!"receptionist".equals(session.getAttribute("role").toString())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {

            // FETCH WAITING APPOINTMENTS
            PreparedStatement ps = conn.prepareStatement(
                "SELECT a.appointment_id, a.speciality_required, a.appointment_date " +
                "FROM appointments a " +
                "JOIN users u ON a.patient_id = u.user_id " +
                "WHERE a.status = 'waiting' ORDER BY a.appointment_id DESC"
            );

            ResultSet rs = ps.executeQuery();
            List<Map<String,String>> appointments = new ArrayList<>();

            while (rs.next()) {
                Map<String,String> map = new HashMap<>();
                map.put("appointment_id", rs.getString("appointment_id"));
                map.put("speciality_required", rs.getString("speciality_required"));
                map.put("appointment_date", rs.getString("appointment_date"));
                appointments.add(map);
            }

            request.setAttribute("appointments", appointments);

            // FETCH ALL DOCTORS
            PreparedStatement ps2 = conn.prepareStatement(
                "SELECT d.doctor_id, u.full_name, d.speciality " +
                "FROM doctors d " +
                "JOIN users u ON d.doctor_id = u.user_id"
            );

            ResultSet rs2 = ps2.executeQuery();
            List<Map<String,String>> doctors = new ArrayList<>();

            while (rs2.next()) {
                Map<String,String> map = new HashMap<>();
                map.put("doctor_id", rs2.getString("doctor_id"));
                map.put("full_name", rs2.getString("full_name"));
                map.put("speciality", rs2.getString("speciality"));
                doctors.add(map);
            }

            request.setAttribute("doctors", doctors);

        } catch (Exception e) {
            e.printStackTrace();
        }

        request.getRequestDispatcher("/WEB-INF/views/scheduleAppointment.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("role") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        if (!"receptionist".equals(session.getAttribute("role").toString())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int userId = Integer.parseInt(session.getAttribute("user_id").toString());

        String appointmentId = request.getParameter("appointment_id");
        String doctorId = request.getParameter("doctor_id");
        String scheduledTime = request.getParameter("scheduled_time");

        if (appointmentId == null || doctorId == null || scheduledTime == null ||
            appointmentId.isEmpty() || doctorId.isEmpty() || scheduledTime.isEmpty()) {

            request.setAttribute("errorMessage", "All fields are required.");
            doGet(request, response);
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {

            PreparedStatement ps = conn.prepareStatement(
                "UPDATE appointments SET doctor_id = ?, appointment_date = ?, status = 'scheduled' " +
                "WHERE appointment_id = ?"
            );

            ps.setString(1, doctorId);
            ps.setString(2, scheduledTime);  // override preferred date with scheduled date/time
            ps.setString(3, appointmentId);

            int updated = ps.executeUpdate();

            if (updated > 0) {
                request.setAttribute("successMessage", "Appointment scheduled successfully!");
                AppLogger.log(conn, userId, "Appointment Scheduled ID: " + appointmentId);
            } else {
                request.setAttribute("errorMessage", "Failed to schedule appointment.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Server error occurred.");
        }

        doGet(request, response);
    }
}
