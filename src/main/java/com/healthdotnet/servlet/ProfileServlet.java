package com.healthdotnet.servlet;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.*;
import java.time.DateTimeException;
import java.time.LocalDate;

import com.healthdotnet.util.AppLogger;
import com.healthdotnet.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // === DISPLAY PROFILE ===
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int userId = Integer.parseInt(session.getAttribute("user_id").toString());
        String role = (String) session.getAttribute("role");

        String sql = "SELECT u.user_id, u.full_name, u.username, u.email, u.phone, u.date_of_birth, u.role, " +
                     "d.speciality, d.consultation_fee " +
                     "FROM users u LEFT JOIN doctors d ON u.user_id = d.doctor_id WHERE u.user_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    request.setAttribute("full_name", rs.getString("full_name"));
                    request.setAttribute("username", rs.getString("username"));
                    request.setAttribute("email", rs.getString("email"));
                    request.setAttribute("phone", rs.getString("phone"));
                    request.setAttribute("date_of_birth", rs.getDate("date_of_birth"));
                    request.setAttribute("role", rs.getString("role"));

                    if ("doctor".equalsIgnoreCase(role)) {
                        request.setAttribute("speciality", rs.getString("speciality"));
                        request.setAttribute("consultation_fee", rs.getBigDecimal("consultation_fee"));
                    }
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading profile.");
        }

        request.getRequestDispatcher("/WEB-INF/views/profile.jsp").forward(request, response);
    }

    // === UPDATE PROFILE (with password confirmation) ===
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int userId = Integer.parseInt(session.getAttribute("user_id").toString());
        String role = (String) session.getAttribute("role");

        boolean hasError = false;

        // === FIELD RETRIEVAL ===
        String fullName = request.getParameter("full_name");
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String dobStr = request.getParameter("date_of_birth");

        String speciality = request.getParameter("speciality");
        String consultationFeeStr = request.getParameter("consultation_fee");

        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        String password = request.getParameter("password"); // Password confirmation

        LocalDate dob = null;
        BigDecimal consultationFee = null;

        // === PASSWORD VALIDATION ===
        if (password == null || password.trim().isEmpty()) {
            request.setAttribute("passwordError", "Password is required to update profile.");
            hasError = true;
        } else {
            // Verify password in DB
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement("SELECT password FROM users WHERE user_id = ?")) {
                ps.setInt(1, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        String storedPassword = rs.getString("password");
                        if (!storedPassword.equals(password)) {
                            request.setAttribute("passwordError", "Incorrect password.");
                            hasError = true;
                        }
                    } else {
                        request.setAttribute("errorMessage", "User not found.");
                        hasError = true;
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
                request.setAttribute("errorMessage", "Error verifying password.");
                hasError = true;
            }
        }

        // === NEW PASSWORD VALIDATION (optional update) ===
        if ((newPassword != null && !newPassword.trim().isEmpty()) ||
            (confirmPassword != null && !confirmPassword.trim().isEmpty())) {
            
            if (newPassword == null || newPassword.trim().isEmpty()) {
                request.setAttribute("newPasswordError", "New password cannot be empty.");
                hasError = true;
            } else if (newPassword.length() < 6) {
                request.setAttribute("newPasswordError", "Password must be at least 6 characters long.");
                hasError = true;
            } else if (!newPassword.matches(".*[A-Z].*")) {
                request.setAttribute("newPasswordError", "Password must contain at least one uppercase letter.");
                hasError = true;
            } else if (!newPassword.matches(".*[a-z].*")) {
                request.setAttribute("newPasswordError", "Password must contain at least one lowercase letter.");
                hasError = true;
            } else if (!newPassword.matches(".*\\d.*")) {
                request.setAttribute("newPasswordError", "Password must contain at least one digit.");
                hasError = true;
            } else if (!newPassword.matches(".*[!@#$%^&*()].*")) {
                request.setAttribute("newPasswordError", "Password must contain at least one special character (!@#$%^&*()).");
                hasError = true;
            }
        
            if (confirmPassword == null || confirmPassword.trim().isEmpty()) {
                request.setAttribute("confirmNewPasswordError", "Please confirm your new password.");
                hasError = true;
            } else if (!newPassword.equals(confirmPassword)) {
                request.setAttribute("confirmNewPasswordError", "New passwords do not match.");
                hasError = true;
            }
        }

        // === FIELD VALIDATION ===
        if (fullName == null || fullName.trim().isEmpty()) {
            request.setAttribute("fullNameError", "Full name is required.");
            hasError = true;
        } else if (!fullName.matches("^[A-Za-z ]{3,50}$")) {
            request.setAttribute("fullNameError", "Full name should be 3–50 letters only.");
            hasError = true;
        }

        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("emailError", "Email is required.");
            hasError = true;
        } else if (!email.matches("^[\\w.%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")) {
            request.setAttribute("emailError", "Invalid email format.");
            hasError = true;
        }

        if (phone == null || phone.trim().isEmpty()) {
            request.setAttribute("phoneError", "Phone number is required.");
            hasError = true;
        } else if (!phone.matches("^\\d{10}$")) {
            request.setAttribute("phoneError", "Please enter a valid 10-digit phone number.");
            hasError = true;
        }

        if (dobStr == null || dobStr.trim().isEmpty()) {
            request.setAttribute("dobError", "Date of birth is required.");
            hasError = true;
        } else {
            try {
                if (!dobStr.matches("^\\d{4}-\\d{2}-\\d{2}$")) {
                    request.setAttribute("dobError", "Date must be in YYYY-MM-DD format.");
                    hasError = true;
                } else {
                    String[] parts = dobStr.split("-");
                    int year = Integer.parseInt(parts[0]);
                    int month = Integer.parseInt(parts[1]);
                    int day = Integer.parseInt(parts[2]);

                    if (year < 1925 || year > LocalDate.now().getYear()) {
                        request.setAttribute("dobError", "Please enter a valid year between 1925 and " + LocalDate.now().getYear());
                        hasError = true;
                    } else {
                        try {
                            dob = LocalDate.of(year, month, day);
                            if (dob.isAfter(LocalDate.now())) {
                                request.setAttribute("dobError", "Date of birth cannot be in the future.");
                                hasError = true;
                            }
                        } catch (DateTimeException e) {
                            request.setAttribute("dobError", "Please enter a valid date.");
                            hasError = true;
                        }
                    }
                }
            } catch (NumberFormatException e) {
                request.setAttribute("dobError", "Please enter a valid date.");
                hasError = true;
            }
        }

        if ("doctor".equalsIgnoreCase(role)) {
            if (speciality == null || speciality.trim().isEmpty()) {
                request.setAttribute("specialityError", "Speciality is required for doctors.");
                hasError = true;
            }
            if (consultationFeeStr == null || consultationFeeStr.trim().isEmpty()) {
                request.setAttribute("consultationFeeError", "Consultation fee is required.");
                hasError = true;
            } else {
                try {
                    consultationFee = new BigDecimal(consultationFeeStr);
                    if (consultationFee.compareTo(BigDecimal.ZERO) < 0) {
                        request.setAttribute("consultationFeeError", "Consultation fee cannot be negative.");
                        hasError = true;
                    }
                } catch (NumberFormatException e) {
                    request.setAttribute("consultationFeeError", "Invalid fee amount.");
                    hasError = true;
                }
            }
        }

        // === IF VALIDATION FAILS ===
        if (hasError) {
            request.setAttribute("full_name", fullName);
            request.setAttribute("username", username);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            request.setAttribute("date_of_birth", dobStr);
            request.setAttribute("role", role);
            if ("doctor".equalsIgnoreCase(role)) {
                request.setAttribute("speciality", speciality);
                request.setAttribute("consultation_fee", consultationFeeStr);
            }
            request.getRequestDispatcher("/WEB-INF/views/profile.jsp").forward(request, response);
            return;
        }

        // === DATABASE UPDATE ===
        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);

            String updateUserSQL = "UPDATE users SET full_name=?, email=?, phone=?, date_of_birth=? WHERE user_id=?";
            try (PreparedStatement ps = conn.prepareStatement(updateUserSQL)) {
                ps.setString(1, fullName);
                ps.setString(2, email);
                ps.setString(3, phone);
                ps.setDate(4, java.sql.Date.valueOf(dob));
                ps.setInt(5, userId);
                ps.executeUpdate();
            }

            if ("doctor".equalsIgnoreCase(role)) {
                String updateDoctorSQL = "UPDATE doctors SET speciality=?, consultation_fee=? WHERE doctor_id=?";
                try (PreparedStatement ps = conn.prepareStatement(updateDoctorSQL)) {
                    ps.setString(1, speciality);
                    ps.setBigDecimal(2, consultationFee);
                    ps.setInt(3, userId);
                    ps.executeUpdate();
                }
            }

            if (!hasError && newPassword != null && !newPassword.trim().isEmpty()) {
                String updatePasswordSQL = "UPDATE users SET password=? WHERE user_id=?";
                try (PreparedStatement ps = conn.prepareStatement(updatePasswordSQL)) {
                    ps.setString(1, newPassword);
                    ps.setInt(2, userId);
                    ps.executeUpdate();
                }
            }

            AppLogger.log(conn, userId, "Profile updated");

            conn.commit();
            request.setAttribute("successMessage", "Profile updated successfully!");

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database error occurred while updating profile.");
        }

        doGet(request, response);
    }
}
