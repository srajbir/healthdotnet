package com.healthdotnet.servlet;

import java.io.IOException;
import java.sql.*;
import java.time.LocalDate;
import java.time.DateTimeException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.healthdotnet.util.AppLogger;
import com.healthdotnet.util.DBConnection;
import com.healthdotnet.model.Users;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Directly show the register page
        request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Creating User object to hold form data
        Users newUser = new Users();
        
        // Retrieve submitted values and set them in the Users object
        newUser.setFullName(request.getParameter("fullname"));
        newUser.setUsername(request.getParameter("username"));
        newUser.setPassword(request.getParameter("password"));
        String confirmPassword = request.getParameter("confirmPassword");
        newUser.setEmail(request.getParameter("email"));
        newUser.setContactNumber(request.getParameter("contact"));
        String dobStr = request.getParameter("dateOfBirth");

        // Keep user-entered values in case of validation error
        request.setAttribute("fullname", newUser.getFullName());
        request.setAttribute("username", newUser.getUsername());
        request.setAttribute("email", newUser.getEmail());
        request.setAttribute("contact", newUser.getContactNumber());
        request.setAttribute("dateOfBirth", dobStr);

        boolean hasError = false;

        // === FIELD VALIDATION ===
        String fullName = newUser.getFullName();
        if (fullName == null || fullName.trim().isEmpty()) {
            request.setAttribute("fullnameError", "Full name is required.");
            hasError = true;
        }

        String username = newUser.getUsername();
        if (username == null || username.trim().isEmpty()) {
            request.setAttribute("usernameError", "Username is required.");
            hasError = true;
        } else if (username.contains(" ")) {
            request.setAttribute("usernameError", "Username must not contain spaces.");
            hasError = true;
        } else if (!username.matches("^[a-zA-Z0-9._-]{4,20}$")) {
            request.setAttribute("usernameError", "Username must be 4–20 characters and use only letters, digits, dots, underscores, or hyphens.");
            hasError = true;
        } else if (username.startsWith(".") || username.endsWith(".") ||
                   username.startsWith("_") || username.endsWith("_") ||
                   username.startsWith("-") || username.endsWith("-")) {
            request.setAttribute("usernameError", "Username cannot start or end with a special character.");
            hasError = true;
        }

        String password = newUser.getPassword();
        if (password == null || password.trim().isEmpty()) {
            request.setAttribute("passwordError", "Password is required.");
            hasError = true;
        } else if (password.length() < 6) {
            request.setAttribute("passwordError", "Password must be at least 6 characters.");
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

        if (confirmPassword == null || confirmPassword.trim().isEmpty()) {
            request.setAttribute("confirmPasswordError", "Confirm password is required.");
            hasError = true;
        } else if (!password.equals(confirmPassword)) {
            request.setAttribute("confirmPasswordError", "Passwords do not match.");
            hasError = true;
        }

        String email = newUser.getEmail();
        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("emailError", "Email is required.");
            hasError = true;
        } else if (!email.matches("^[\\w.%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")) {
            request.setAttribute("emailError", "Invalid email format.");
            hasError = true;
        }

        String contact = newUser.getContactNumber();
        if (contact == null || contact.trim().isEmpty()) {
            request.setAttribute("contactError", "Contact number is required.");
            hasError = true;
        } else if (!contact.matches("^\\d{10}$")) {
            request.setAttribute("contactError", "Please enter a valid contact number.");
            hasError = true;
        }

        // Validate and parse date of birth
        if (dobStr == null || dobStr.trim().isEmpty()) {
            request.setAttribute("dobError", "Date of birth is required.");
            hasError = true;
        } else {
            try {
                // Validate date format and range
                if (!dobStr.matches("^\\d{4}-\\d{2}-\\d{2}$")) {
                    request.setAttribute("dobError", "Date must be in DD-MM-YYYY format");
                    hasError = true;
                } else {
                    String[] parts = dobStr.split("-");
                    int year = Integer.parseInt(parts[0]);
                    int month = Integer.parseInt(parts[1]);
                    int day = Integer.parseInt(parts[2]);
                    
                    // Check year is reasonable (between 1900 and current year)
                    if (year < 1925 || year > LocalDate.now().getYear()) {
                        request.setAttribute("dobError", "Please enter a valid year between 1900 and " + LocalDate.now().getYear());
                        hasError = true;
                    } else {
                        try {
                            LocalDate dob = LocalDate.of(year, month, day);
                            newUser.setDob(dob);
                        } catch (DateTimeException e) {
                            request.setAttribute("dobError", "Please enter a valid date");
                            hasError = true;
                        }
                    }
                }
            } catch (NumberFormatException e) {
                request.setAttribute("dobError", "Please enter a valid date");
                hasError = true;
            }
        }

        if (hasError) {
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }

        // === DATABASE VALIDATIONS ===
        try (Connection conn = DBConnection.getConnection()) {

            // Username uniqueness
            try (PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM users WHERE username=?")) {
                ps.setString(1, username);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next() && rs.getInt(1) > 0) {
                        request.setAttribute("usernameError", "Username already exists.");
                        request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
                        return;
                    }
                }
            }

            // Email uniqueness
            try (PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM users WHERE email=?")) {
                ps.setString(1, newUser.getEmail());
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next() && rs.getInt(1) > 0) {
                        request.setAttribute("emailError", "Email already registered.");
                        request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
                        return;
                    }
                }
            }

            // Contact uniqueness
            try (PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM users WHERE phone=?")) {
                ps.setString(1, newUser.getContactNumber());
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next() && rs.getInt(1) > 0) {
                        request.setAttribute("contactError", "Contact number already registered.");
                        request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
                        return;
                    }
                }
            }

            // Date validation
            LocalDate dateOfBirth = newUser.getDob();
            if (dateOfBirth != null && dateOfBirth.isAfter(LocalDate.now())) {
                request.setAttribute("dobError", "Date of birth cannot be in the future.");
                request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
                return;
            }

            // Set additional user properties
            newUser.setRole(Users.Role.PATIENT);
            newUser.setIsActive(true);
            newUser.setCreatedAt(LocalDate.now());

            // === INSERT INTO DATABASE ===
            String sql = "INSERT INTO users (role, full_name, username, password, email, phone, date_of_birth, is_active, created_at) "
                       + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, newUser.getRole().name());
                ps.setString(2, newUser.getFullName());
                ps.setString(3, newUser.getUsername());
                ps.setString(4, newUser.getPassword());
                ps.setString(5, newUser.getEmail());
                ps.setString(6, newUser.getContactNumber());
                ps.setDate(7, Date.valueOf(newUser.getDob()));
                ps.setBoolean(8, newUser.getIsActive());
                ps.setDate(9, Date.valueOf(newUser.getCreatedAt()));
                ps.executeUpdate();
            }

            AppLogger.log(conn, 0, "Registration successful for username: '" + newUser.getUsername() + "'");

            // Set success message in session
            HttpSession session = request.getSession();
            session.setAttribute("successMessage", "Registration successful!");
            // Redirect to /login page after successful registration
            response.sendRedirect(request.getContextPath() + "/login");
            return;

        } catch (SQLException e) {
            request.setAttribute("dbError", "An error occurred while processing your registration. Please try again later.");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }
    }
}
