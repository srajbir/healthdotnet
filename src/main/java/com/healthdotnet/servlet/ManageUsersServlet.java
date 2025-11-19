package com.healthdotnet.servlet;

import com.healthdotnet.util.AppLogger;
import com.healthdotnet.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.*;
import java.sql.Date;
import java.time.LocalDate;
import java.util.*;

@WebServlet("/manageUsers")
public class ManageUsersServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // Admin authentication
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("role") == null ||
                !session.getAttribute("role").toString().equalsIgnoreCase("admin")) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        String idStr = request.getParameter("id");

        // ---------- EDIT MODE ----------
        if (action != null && "edit".equalsIgnoreCase(action) && idStr != null) {
            try (Connection conn = DBConnection.getConnection()) {

                String sql = "SELECT u.*, d.speciality, d.consultation_fee " +
                        "FROM users u LEFT JOIN doctors d ON u.user_id = d.doctor_id " +
                        "WHERE u.user_id = ?";

                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    try {
                        ps.setInt(1, Integer.parseInt(idStr));
                    } catch (NumberFormatException e) {
                        request.setAttribute("errorMessage", "Invalid user ID format.");
                        request.getRequestDispatcher("/WEB-INF/views/manageUsers.jsp").forward(request, response);
                        return;
                    }
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {

                            Map<String, Object> user = new HashMap<>();
                            user.put("user_id", rs.getInt("user_id"));
                            user.put("role", rs.getString("role"));
                            user.put("full_name", rs.getString("full_name"));
                            user.put("username", rs.getString("username"));
                            user.put("email", rs.getString("email"));
                            user.put("phone", rs.getString("phone"));

                            Date dob = rs.getDate("date_of_birth");
                            user.put("date_of_birth", dob != null ? dob.toString() : null);

                            user.put("is_active", rs.getBoolean("is_active"));
                            user.put("speciality", rs.getString("speciality"));
                            user.put("consultation_fee", rs.getBigDecimal("consultation_fee"));
                            
                            Timestamp createdAt = rs.getTimestamp("created_at");
                            user.put("created_at", createdAt != null ? createdAt.toString() : null);

                            request.setAttribute("editUser", user);
                            request.setAttribute("showPanel", "edit");
                        }
                    }
                }

            } catch (SQLException e) {
                e.printStackTrace();
                request.setAttribute("errorMessage", "Database error while loading user data.");
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("errorMessage", "An unexpected error occurred.");
            }

            request.getRequestDispatcher("/WEB-INF/views/manageUsers.jsp").forward(request, response);
            return;
        }

        // ---------- DEFAULT: VIEW USERS ----------
        List<Map<String, Object>> users = new ArrayList<>();
        String q = request.getParameter("q");
        if (q != null) q = q.trim();
        request.setAttribute("q", q);

        if (q != null && !q.isEmpty()) {
            request.setAttribute("showPanel", "view");
        }

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT u.*, d.speciality, d.consultation_fee " +
                    "FROM users u LEFT JOIN doctors d ON u.user_id = d.doctor_id";

            if (q != null && !q.isEmpty()) {
                sql += " WHERE u.username LIKE ? OR u.full_name LIKE ? OR u.email LIKE ? OR u.phone LIKE ? " +
                       "OR d.speciality LIKE ? OR u.role LIKE ? OR CAST(u.user_id AS CHAR) LIKE ? " +
                       "OR DATE_FORMAT(u.date_of_birth, '%Y-%m-%d') LIKE ? OR DATE_FORMAT(u.date_of_birth, '%Y-%m') LIKE ? " +
                       "OR DATE_FORMAT(u.date_of_birth, '%Y') LIKE ?";
            }

            sql += " ORDER BY u.user_id DESC";

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                if (q != null && !q.isEmpty()) {
                    String like = "%" + q + "%";
                    ps.setString(1, like);    // username
                    ps.setString(2, like);    // full_name
                    ps.setString(3, like);    // email
                    ps.setString(4, like);    // phone
                    ps.setString(5, like);    // speciality
                    ps.setString(6, like);    // role
                    ps.setString(7, like);    // user_id
                    ps.setString(8, like);    // date_of_birth (full date)
                    ps.setString(9, like);    // date_of_birth (year-month)
                    ps.setString(10, like);   // date_of_birth (year only)
                }

                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {

                        Map<String, Object> u = new HashMap<>();
                        u.put("user_id", rs.getInt("user_id"));
                        u.put("role", rs.getString("role"));
                        u.put("full_name", rs.getString("full_name"));
                        u.put("username", rs.getString("username"));
                        u.put("email", rs.getString("email"));
                        u.put("phone", rs.getString("phone"));

                        Date dob = rs.getDate("date_of_birth");
                        u.put("date_of_birth", dob != null ? dob.toString() : null);

                        u.put("is_active", rs.getBoolean("is_active"));
                        u.put("speciality", rs.getString("speciality"));
                        u.put("consultation_fee", rs.getBigDecimal("consultation_fee"));
                        
                        Timestamp createdAt = rs.getTimestamp("created_at");
                        u.put("created_at", createdAt != null ? createdAt.toString() : null);

                        users.add(u);
                    }
                }
            }

        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Unable to load users.");
        }

        request.setAttribute("users", users);
        request.getRequestDispatcher("/WEB-INF/views/manageUsers.jsp").forward(request, response);
    }

    // POST HANDLER
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("role") == null ||
                !session.getAttribute("role").toString().equalsIgnoreCase("admin")) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int curId = Integer.parseInt(session.getAttribute("user_id").toString());

        String action = request.getParameter("action");

        if (action == null || action.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/manageUsers");
            return;
        }

        if ("delete".equalsIgnoreCase(action)) {
            handleDelete(request, response, curId);
            return;
        }

        if ("add".equalsIgnoreCase(action) || "update".equalsIgnoreCase(action)) {
            handleAddOrUpdate(request, response, "update".equalsIgnoreCase(action), curId);
            return;
        }

        response.sendRedirect(request.getContextPath() + "/manageUsers");
    }

        // DELETE HANDLER
        private void handleDelete(HttpServletRequest request, HttpServletResponse response, int cur_user_id) throws IOException {
        
            String idStr = request.getParameter("id");
            if (idStr == null || idStr.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/manageUsers?errorMessage=Invalid+user+ID");
                return;
            }
        
            int id;
            try {
                id = Integer.parseInt(idStr);
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/manageUsers?errorMessage=Invalid+ID+format");
                return;
            }
        
            Connection conn = null;
            try {
                conn = DBConnection.getConnection();
                conn.setAutoCommit(false);
            
                // Delete from doctors
                try (PreparedStatement ps1 = conn.prepareStatement("DELETE FROM doctors WHERE doctor_id = ?")) {
                    ps1.setInt(1, id);
                    ps1.executeUpdate();
                }
            
                // Delete from users
                int userDeleted;
                try (PreparedStatement ps2 = conn.prepareStatement("DELETE FROM users WHERE user_id = ?")) {
                    ps2.setInt(1, id);
                    userDeleted = ps2.executeUpdate();
                }
            
                if (userDeleted == 0) {
                    conn.rollback();
                    response.sendRedirect(request.getContextPath() + "/manageUsers?errorMessage=User+not+found");
                    return;
                }
            
                conn.commit();
            
                // Log deletion
                AppLogger.log(conn, cur_user_id, "User deleted '" + id + "'");
            
                response.sendRedirect(request.getContextPath() + "/manageUsers?successMessage=User+deleted+successfully");
            
            } catch (SQLException e) {
                e.printStackTrace();
                if (conn != null) {
                    try { conn.rollback(); } catch (SQLException rollbackEx) { rollbackEx.printStackTrace(); }
                }
                response.sendRedirect(request.getContextPath() + "/manageUsers?errorMessage=Database+error");
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/manageUsers?errorMessage=Unexpected+error");
            } finally {
                if (conn != null) {
                    try { conn.close(); } catch (SQLException closeEx) { closeEx.printStackTrace(); }
                }
            }
        }

    // ADD / UPDATE 
    private void handleAddOrUpdate(HttpServletRequest request, HttpServletResponse response, boolean isUpdate, int cur_user_id)
            throws IOException, ServletException {

        // Collect parameters and trim whitespace
        String idStr = request.getParameter("user_id");
        Integer id = null;
        if (idStr != null && !idStr.isEmpty()) {
            try {
                id = Integer.valueOf(idStr);
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid user ID format.");
                request.getRequestDispatcher("/WEB-INF/views/manageUsers.jsp?errorMessage=Invalid+user+ID").forward(request, response);
                return;
            }
        }

        String role = request.getParameter("role") != null ? request.getParameter("role").trim() : "";
        String fullName = request.getParameter("fullname") != null ? request.getParameter("fullname").trim() : "";
        String username = request.getParameter("username") != null ? request.getParameter("username").trim() : "";
        String password = request.getParameter("password") != null ? request.getParameter("password").trim() : "";
        String confirmPassword = request.getParameter("confirmPassword") != null ? request.getParameter("confirmPassword").trim() : "";
        String email = request.getParameter("email") != null ? request.getParameter("email").trim() : "";
        String phone = request.getParameter("phone") != null ? request.getParameter("phone").trim() : "";
        String dobStr = request.getParameter("dateOfBirth") != null ? request.getParameter("dateOfBirth").trim() : "";
        String isActiveStr = request.getParameter("isActive");
        String speciality = request.getParameter("speciality") != null ? request.getParameter("speciality").trim() : "";
        String feeStr = request.getParameter("consultationFee") != null ? request.getParameter("consultationFee").trim() : "";

        boolean hasError = false;
        Map<String, String> errors = new HashMap<>();

        // VALIDATION ------------------------------------
        // Validate role
        if (role.isEmpty()) {
            errors.put("roleError", "Role is required.");
            hasError = true;
        } else if (!role.matches("^(admin|doctor|patient|receptionist)$")) {
            errors.put("roleError", "Invalid role selected.");
            hasError = true;
        }

        // Validate full name
        if (fullName.isEmpty()) {
            errors.put("fullnameError", "Full name is required.");
            hasError = true;
        } else if (fullName.length() > 100) {
            errors.put("fullnameError", "Full name must not exceed 100 characters.");
            hasError = true;
        }

        // Validate username
        if (username.isEmpty()) {
            errors.put("usernameError", "Username is required.");
            hasError = true;
        } else if (username.contains(" ")) {
            errors.put("usernameError", "Username must not contain spaces.");
            hasError = true;
        } else if (!username.matches("^[a-zA-Z0-9._-]{4,20}$")) {
            errors.put("usernameError", "Username must be 4-20 characters, letters/numbers/_/./- only.");
            hasError = true;
        }

        // Validate password - different logic for add vs update
        if (!isUpdate) {
            // ADD: Both password fields required
            if (password.isEmpty()) {
                errors.put("passwordError", "Password is required.");
                hasError = true;
            } else if (password.length() < 6) {
                errors.put("passwordError", "Password must be at least 6 characters.");
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

            if (confirmPassword.isEmpty()) {
                errors.put("confirmPasswordError", "Confirm password is required.");
                hasError = true;
            } else if (!password.equals(confirmPassword)) {
                errors.put("confirmPasswordError", "Passwords do not match.");
                hasError = true;
            }
        } else {
            // EDIT: Password is optional, but if provided, both fields must match
            if (!password.isEmpty() || !confirmPassword.isEmpty()) {
                if (password.isEmpty()) {
                    errors.put("passwordError", "Password is required when changing password.");
                    hasError = true;
                } else if (password.length() < 6) {
                    errors.put("passwordError", "Password must be at least 6 characters.");
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

                if (confirmPassword.isEmpty()) {
                    errors.put("confirmPasswordError", "Confirm password is required when changing password.");
                    hasError = true;
                } else if (!password.equals(confirmPassword)) {
                    errors.put("confirmPasswordError", "Passwords do not match.");
                    hasError = true;
                }
            }
        }

        // Validate email - improved regex
        if (email.isEmpty()) {
            errors.put("emailError", "Email is required.");
            hasError = true;
        } else if (!email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")) {
            errors.put("emailError", "Invalid email format.");
            hasError = true;
        }

        // Validate phone
        if (phone.isEmpty()) {
            errors.put("phoneError", "Phone is required.");
            hasError = true;
        } else if (!phone.matches("^[+]?[0-9]{10,15}$")) {
            errors.put("phoneError", "Phone must be 10-15 digits, optionally starting with +.");
            hasError = true;
        }

        // Validate Date of Birth
        LocalDate dob = null;

        if (dobStr.isEmpty()) {
            errors.put("dobError", "Date of birth is required.");
            hasError = true;
        } else if (!dobStr.matches("^\\d{4}-\\d{2}-\\d{2}$")) {
            errors.put("dobError", "Date must be YYYY-MM-DD format.");
            hasError = true;
        } else {
            try {
                String[] parts = dobStr.split("-");
                int year = Integer.parseInt(parts[0]);
                int month = Integer.parseInt(parts[1]);
                int day = Integer.parseInt(parts[2]);
                
                // Validate date ranges
                if (month < 1 || month > 12) {
                    errors.put("dobError", "Invalid month (01-12).");
                    hasError = true;
                } else if (day < 1 || day > 31) {
                    errors.put("dobError", "Invalid day (01-31).");
                    hasError = true;
                } else {
                    try {
                        dob = LocalDate.of(year, month, day);
                        
                        // Check not in future
                        if (dob.isAfter(LocalDate.now())) {
                            errors.put("dobError", "Date of birth cannot be in the future.");
                            hasError = true;
                        }
                        // Check not too old (>120 years)
                        else if (dob.isBefore(LocalDate.now().minusYears(120))) {
                            errors.put("dobError", "Date of birth seems invalid (too old).");
                            hasError = true;
                        }
                    } catch (java.time.DateTimeException e) {
                        errors.put("dobError", "Invalid date (check day for month).");
                        hasError = true;
                    }
                }
            } catch (NumberFormatException e) {
                errors.put("dobError", "Invalid date format.");
                hasError = true;
            } catch (Exception e) {
                errors.put("dobError", "Invalid date.");
                hasError = true;
            }
        }

        // Validate doctor-specific fields
        if ("doctor".equalsIgnoreCase(role)) {
            if (speciality.isEmpty()) {
                errors.put("specialityError", "Speciality is required for doctors.");
                hasError = true;
            } else if (speciality.length() > 100) {
                errors.put("specialityError", "Speciality must not exceed 100 characters.");
                hasError = true;
            }

            if (feeStr.isEmpty()) {
                errors.put("consultationFeeError", "Consultation fee is required for doctors.");
                hasError = true;
            } else {
                try {
                    java.math.BigDecimal fee = new java.math.BigDecimal(feeStr);
                    if (fee.compareTo(java.math.BigDecimal.ZERO) <= 0) {
                        errors.put("consultationFeeError", "Consultation fee must be greater than 0.");
                        hasError = true;
                    } else if (fee.scale() > 2) {
                        errors.put("consultationFeeError", "Consultation fee must have at most 2 decimal places.");
                        hasError = true;
                    } else if (fee.compareTo(new java.math.BigDecimal("99999.99")) > 0) {
                        errors.put("consultationFeeError", "Consultation fee is too large.");
                        hasError = true;
                    }
                } catch (NumberFormatException e) {
                    errors.put("consultationFeeError", "Consultation fee must be a valid number.");
                    hasError = true;
                }
            }
        }

        // IF ERRORS → return to form
        if (hasError) {

            for (var e : errors.entrySet()) {
                request.setAttribute(e.getKey(), e.getValue());
            }

            request.setAttribute("fullname", fullName);
            request.setAttribute("username", username);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            request.setAttribute("dateOfBirth", dobStr);
            request.setAttribute("role", role);
            request.setAttribute("speciality", speciality);
            request.setAttribute("consultationFee", feeStr);
            request.setAttribute("showPanel", isUpdate ? "edit" : "add");

            if (isUpdate && id != null) {

                Map<String, Object> e = new HashMap<>();
                e.put("user_id", id);
                e.put("role", role);
                e.put("full_name", fullName);
                e.put("username", username);
                e.put("email", email);
                e.put("phone", phone);
                e.put("date_of_birth", dobStr);
                e.put("is_active", "on".equalsIgnoreCase(isActiveStr));
                e.put("speciality", speciality);
                e.put("consultation_fee",
                        feeStr != null && !feeStr.isEmpty() ? new java.math.BigDecimal(feeStr) : null);

                request.setAttribute("editUser", e);
            }

            request.getRequestDispatcher("/WEB-INF/views/manageUsers.jsp").forward(request, response);
            return;
        }

        // --------------------- DATABASE OPERATIONS -----------------------
        try (Connection conn = DBConnection.getConnection()) {

            conn.setAutoCommit(false);

            boolean active = "on".equalsIgnoreCase(isActiveStr);

            // UNIQUE CHECKS
            if (exists(conn, "username", username, isUpdate, id)) {
                request.setAttribute("usernameError", "Username already exists.");  
                sendBack(request, response, isUpdate, id, fullName, username, email, phone, dobStr, role, speciality, feeStr);
                return;
            }

            if (exists(conn, "email", email, isUpdate, id)) {
                request.setAttribute("emailError", "Email already registered.");
                sendBack(request, response, isUpdate, id, fullName, username, email, phone, dobStr, role, speciality, feeStr);
                return;
            }

            if (exists(conn, "phone", phone, isUpdate, id)) {
                request.setAttribute("phoneError", "Phone already registered.");
                sendBack(request, response, isUpdate, id, fullName, username, email, phone, dobStr, role, speciality, feeStr);
                return;
            }

            // UPDATE ------------------------------------
            if (isUpdate && id != null) {

                StringBuilder sql = new StringBuilder(
                        "UPDATE users SET role=?, full_name=?, username=?, email=?, phone=?, date_of_birth=?, is_active=?");

                if (!password.isEmpty()) {
                    sql.append(", password=?");
                }

                sql.append(" WHERE user_id=?");

                try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {

                    int idx = 1;
                    ps.setString(idx++, role);
                    ps.setString(idx++, fullName);
                    ps.setString(idx++, username);
                    ps.setString(idx++, email);
                    ps.setString(idx++, phone);

                    if (dob != null) ps.setDate(idx++, Date.valueOf(dob));
                    else ps.setNull(idx++, Types.DATE);

                    ps.setBoolean(idx++, active);

                    if (!password.isEmpty()) {
                        ps.setString(idx++, password);
                    }

                    ps.setInt(idx, id);
                    ps.executeUpdate();
                }

                AppLogger.log(conn, cur_user_id, "Profile updated '" + id + "'");

                // UPDATE DOCTOR TABLE
                if ("doctor".equalsIgnoreCase(role)) {

                    if (existsDoctor(conn, id)) {

                        try (PreparedStatement ps = conn.prepareStatement(
                                "UPDATE doctors SET speciality=?, consultation_fee=? WHERE doctor_id=?")) {

                            ps.setString(1, speciality);
                            ps.setBigDecimal(2, new java.math.BigDecimal(feeStr));
                            ps.setInt(3, id);
                            ps.executeUpdate();
                        }

                    } else {

                        try (PreparedStatement ps = conn.prepareStatement(
                                "INSERT INTO doctors (doctor_id, speciality, consultation_fee) VALUES (?, ?, ?)")) {

                            ps.setInt(1, id);
                            ps.setString(2, speciality);
                            ps.setBigDecimal(3, new java.math.BigDecimal(feeStr));
                            ps.executeUpdate();
                        }
                    }

                } else {
                    try (PreparedStatement ps = conn.prepareStatement("DELETE FROM doctors WHERE doctor_id=?")) {
                        ps.setInt(1, id);
                        ps.executeUpdate();
                    }
                }

                conn.commit();
                request.getSession().setAttribute("successMessage", "User updated successfully.");
                response.sendRedirect(request.getContextPath() + "/manageUsers?successMessage=User+updated+successfully");
                return;
            }

            // INSERT NEW USER ------------------------------------
            String sql = "INSERT INTO users (role, full_name, username, password, email, phone, date_of_birth, is_active, created_at) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

            int newId;

            try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

                ps.setString(1, role);
                ps.setString(2, fullName);
                ps.setString(3, username);
                ps.setString(4, password);
                ps.setString(5, email);
                ps.setString(6, phone);

                if (dob != null) ps.setDate(7, Date.valueOf(dob));
                else ps.setNull(7, Types.DATE);

                ps.setBoolean(8, active);
                ps.setDate(9, Date.valueOf(LocalDate.now()));

                ps.executeUpdate();

                try (ResultSet keys = ps.getGeneratedKeys()) {
                    keys.next();
                    newId = keys.getInt(1);
                }
            }

            AppLogger.log(conn, cur_user_id, "User added '" + newId+ "'");

            // INSERT DOCTOR
            if ("doctor".equalsIgnoreCase(role)) {

                try (PreparedStatement ps = conn.prepareStatement(
                        "INSERT INTO doctors (doctor_id, speciality, consultation_fee) VALUES (?, ?, ?)")) {

                    ps.setInt(1, newId);
                    ps.setString(2, speciality);
                    ps.setBigDecimal(3, new java.math.BigDecimal(feeStr));
                    ps.executeUpdate();
                }
            }

            conn.commit();
            request.getSession().setAttribute("successMessage", "User added successfully.");
            response.sendRedirect(request.getContextPath() + "/manageUsers?successMessage=User+added+successfully");

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database error while saving user: " + e.getMessage());
            request.setAttribute("showPanel", isUpdate ? "edit" : "add");
            response.sendRedirect(request.getContextPath() + "/WEB-INF/views/manageUsers.jsp?errorMessage=Database+error");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An unexpected error occurred while saving user.");
            request.setAttribute("showPanel", isUpdate ? "edit" : "add");
            try {
                response.sendRedirect(request.getContextPath() + "manageUsers.jsp?errorMessage=Unexpected+error");
            } catch (IOException ioEx) {
                ioEx.printStackTrace();
            }
        }
    }

    // ---------- REUSABLE HELPERS ----------

    private boolean exists(Connection conn, String field, String value, boolean isUpdate, Integer id) throws SQLException {

        String sql = "SELECT COUNT(*) FROM users WHERE " + field + "=?";

        if (isUpdate && id != null) {
            sql += " AND user_id <> ?";
        }

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, value);

            if (isUpdate && id != null) {
                ps.setInt(2, id);
            }

            try (ResultSet rs = ps.executeQuery()) {
                rs.next();
                return rs.getInt(1) > 0;
            }
        }
    }

    private boolean existsDoctor(Connection conn, int id) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM doctors WHERE doctor_id=?")) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                rs.next();
                return rs.getInt(1) > 0;
            }
        }
    }

    private void sendBack(HttpServletRequest request, HttpServletResponse response,
                          boolean isUpdate, Integer id, String fullName, String username, String email,
                          String phone, String dobStr, String role, String speciality, String feeStr)
            throws ServletException, IOException {

        request.setAttribute("fullname", fullName);
        request.setAttribute("username", username);
        request.setAttribute("email", email);
        request.setAttribute("phone", phone);
        request.setAttribute("dateOfBirth", dobStr);
        request.setAttribute("role", role);
        request.setAttribute("speciality", speciality);
        request.setAttribute("consultationFee", feeStr);
        request.setAttribute("showPanel", isUpdate ? "edit" : "add");

        if (isUpdate && id != null) {
            Map<String, Object> e = new HashMap<>();
            e.put("user_id", id);
            e.put("role", role);
            e.put("full_name", fullName);
            e.put("username", username);
            e.put("email", email);
            e.put("phone", phone);
            e.put("date_of_birth", dobStr);
            e.put("speciality", speciality);
            e.put("consultation_fee", feeStr);
            request.setAttribute("editUser", e);
        }

        request.getRequestDispatcher("/WEB-INF/views/manageUsers.jsp").forward(request, response);
    }
}
