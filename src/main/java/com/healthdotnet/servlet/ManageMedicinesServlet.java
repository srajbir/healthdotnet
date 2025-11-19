package com.healthdotnet.servlet;

import com.healthdotnet.util.AppLogger;
import com.healthdotnet.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/manageMedicines")
public class ManageMedicinesServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Admin authentication
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("role") == null ||
                !session.getAttribute("role").toString().equalsIgnoreCase("admin")) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        String search = request.getParameter("q");
        String idStr = request.getParameter("id");

        request.setAttribute("q", (search != null ? search : ""));

        try (Connection conn = DBConnection.getConnection()) {

            if ("edit".equalsIgnoreCase(action) && idStr != null) {

                Map<String, Object> medicineData = getMedicineById(conn, Integer.parseInt(idStr));

                if (medicineData != null) {
                    request.setAttribute("editMedicine", medicineData);
                    request.setAttribute("showPanel", "edit");
                } else {
                    request.setAttribute("errorMessage", "Medicine not found.");
                }

            } else {
                List<Map<String, Object>> list = getMedicines(conn, search);
                request.setAttribute("medicines", list);
                request.setAttribute("showPanel", "view");
            }

        } catch (Exception ex) {
            request.setAttribute("errorMessage", "Error: " + ex.getMessage());
        }

        request.getRequestDispatcher("/WEB-INF/views/manageMedicines.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Admin authentication
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("role") == null ||
                !session.getAttribute("role").toString().equalsIgnoreCase("admin")) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int curId = Integer.parseInt(session.getAttribute("user_id").toString());

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        try (Connection conn = DBConnection.getConnection()) {

            switch (action) {

                case "add":
                    addMedicine(request, response, conn, curId);
                    return;

                case "update":
                    updateMedicine(request, response, conn, curId);
                    return;

                case "delete":
                    deleteMedicine(request, response, conn, curId);
                    return;

                default:
                    response.sendRedirect(request.getContextPath() + "/manageMedicines");
            }

        } catch (Exception ex) {
            request.setAttribute("errorMessage", "Unexpected error: " + ex.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/manageMedicines.jsp").forward(request, response);
        }
    }

    private List<Map<String, Object>> getMedicines(Connection conn, String search) throws SQLException {

        List<Map<String, Object>> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder("SELECT * FROM medicines WHERE 1=1");

        boolean applySearch = (search != null && !search.trim().isEmpty());

        if (applySearch) {
            sql.append(" AND (name LIKE ? OR description LIKE ? OR price LIKE ?)");
        }

        sql.append(" ORDER BY medicine_id DESC");

        try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            if (applySearch) {
                String like = "%" + search.trim() + "%";
                ps.setString(1, like);
                ps.setString(2, like);
                ps.setString(3, like);
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {

                Map<String, Object> m = new HashMap<>();
                m.put("medicine_id", rs.getInt("medicine_id"));
                m.put("name", rs.getString("name"));
                m.put("description", rs.getString("description"));
                m.put("price", rs.getBigDecimal("price"));

                list.add(m);
            }
        }
        return list;
    }

    private Map<String, Object> getMedicineById(Connection conn, int id) throws SQLException {

        String sql = "SELECT * FROM medicines WHERE medicine_id = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                Map<String, Object> m = new HashMap<>();
                m.put("medicine_id", rs.getInt("medicine_id"));
                m.put("name", rs.getString("name"));
                m.put("description", rs.getString("description"));
                m.put("price", rs.getBigDecimal("price"));
                return m;
            }
        }
        return null;
    }

    private void addMedicine(HttpServletRequest req, HttpServletResponse res, Connection conn , int cur_user_id)
            throws Exception {

        String name = req.getParameter("name");
        String description = req.getParameter("description");
        String priceStr = req.getParameter("price");

        boolean hasError = validateInputs(req, name, description, priceStr);

        if (hasError) {
            req.setAttribute("showPanel", "add");
            req.getRequestDispatcher("/WEB-INF/views/manageMedicines.jsp").forward(req, res);
            return;
        }

        String sql = "INSERT INTO medicines (name, description, price) VALUES (?, ?, ?)";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name.trim());
            ps.setString(2, description.trim());
            ps.setBigDecimal(3, new java.math.BigDecimal(priceStr));
            ps.executeUpdate();
        }

        AppLogger.log(conn, cur_user_id, name + " medicine added");

        res.sendRedirect(req.getContextPath() + "/manageMedicines?successMessage=Medicine+added+successfully");
    }

    private void updateMedicine(HttpServletRequest req, HttpServletResponse res, Connection conn, int cur_user_id)
            throws Exception {

        int id = Integer.parseInt(req.getParameter("medicine_id"));
        String name = req.getParameter("name");
        String description = req.getParameter("description");
        String priceStr = req.getParameter("price");

        boolean hasError = validateInputs(req, name, description, priceStr);

        if (hasError) {
            req.setAttribute("editMedicine", getMedicineById(conn, id));
            req.setAttribute("showPanel", "edit");
            req.getRequestDispatcher("/WEB-INF/views/manageMedicines.jsp").forward(req, res);
            return;
        }

        String sql = "UPDATE medicines SET name=?, description=?, price=? WHERE medicine_id=?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, name.trim());
            ps.setString(2, description.trim());
            ps.setBigDecimal(3, new java.math.BigDecimal(priceStr));
            ps.setInt(4, id);
            ps.executeUpdate();
        }
        AppLogger.log(conn, cur_user_id, name + " medicine updated (ID: " + id + ")");

        res.sendRedirect(req.getContextPath() + "/manageMedicines?successMessage=Medicine+updated+successfully");
    }

    private void deleteMedicine(HttpServletRequest req, HttpServletResponse res, Connection conn, int cur_user_id)
            throws Exception {

        String idStr = req.getParameter("medicine_id");

        // Validate ID
        if (idStr == null || idStr.trim().isEmpty()) {
            res.sendRedirect(req.getContextPath() + "/manageMedicines?errorMessage=Invalid+medicine+ID");
            return;
        }

        int id;
        try {
            id = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            res.sendRedirect(req.getContextPath() + "/manageMedicines?errorMessage=Invalid+ID+format");
            return;
        }

        int rowsAffected = 0;

        try (PreparedStatement ps =
                     conn.prepareStatement("DELETE FROM medicines WHERE medicine_id=?")) {

            ps.setInt(1, id);
            rowsAffected = ps.executeUpdate();

        } catch (SQLException e) {
            res.sendRedirect(req.getContextPath() + "/manageMedicines?errorMessage=Delete+failed");
            return;
        }

        // If no record deleted → show error
        if (rowsAffected == 0) {
            res.sendRedirect(req.getContextPath() + "/manageMedicines?errorMessage=Medicine+not+found");
            return;
        }

        // Success
        AppLogger.log(conn, cur_user_id,  "Medicine deleted: ID '" + id + "'");
        res.sendRedirect(req.getContextPath() + "/manageMedicines?successMessage=Medicine+deleted+successfully");
    }

    private boolean validateInputs(HttpServletRequest req, String name, String description, String priceStr) {

        boolean error = false;
        if (name == null || name.trim().isEmpty()) {
            req.setAttribute("nameError", "Medicine name is required.");
            error = true;
        } else {
            String trimmed = name.trim();

            if (trimmed.length() < 3) {
                req.setAttribute("nameError", "Name must be at least 3 characters.");
                error = true;
            } else if (trimmed.length() > 100) {
                req.setAttribute("nameError", "Name cannot exceed 100 characters.");
                error = true;
            }

            // Optional: restrict only to alphabets, numbers & spaces
            if (!trimmed.matches("^[A-Za-z0-9\\s\\-_,.]+$")) {
                req.setAttribute("nameError", "Invalid characters in name.");
                error = true;
            }
        }

        if (description == null || description.trim().isEmpty()) {
            req.setAttribute("descriptionError", "Description is required.");
            error = true;
        } else {
            String trimmed = description.trim();

            if (trimmed.length() < 10) {
                req.setAttribute("descriptionError", "Description must be at least 10 characters.");
                error = true;
            } else if (trimmed.length() > 1000) {
                req.setAttribute("descriptionError", "Description cannot exceed 1000 characters.");
                error = true;
            }

            // Avoid only symbols or only numbers
            if (trimmed.matches("^[0-9]+$")) {
                req.setAttribute("descriptionError", "Description cannot contain only numbers.");
                error = true;
            }

            if (trimmed.matches("^[^A-Za-z0-9]+$")) {
                req.setAttribute("descriptionError", "Description cannot contain only special characters.");
                error = true;
            }
        }

        if (priceStr == null || priceStr.trim().isEmpty()) {
            req.setAttribute("priceError", "Price is required.");
            error = true;
        } else {
            try {
                java.math.BigDecimal price = new java.math.BigDecimal(priceStr);

                // Must be positive
                if (price.compareTo(java.math.BigDecimal.ZERO) <= 0) {
                    req.setAttribute("priceError", "Price must be greater than 0.");
                    error = true;
                }

                // Prevent too large values
                if (price.compareTo(new java.math.BigDecimal("999999.99")) > 0) {
                    req.setAttribute("priceError", "Price exceeds maximum allowed amount.");
                    error = true;
                }

                // Decimal precision validation (max 2 decimal places)
                if (price.scale() > 2) {
                    req.setAttribute("priceError", "Price cannot have more than 2 decimal places.");
                    error = true;
                }

            } catch (Exception e) {
                req.setAttribute("priceError", "Invalid price format.");
                error = true;
            }
        }

        req.setAttribute("name", name);
        req.setAttribute("description", description);
        req.setAttribute("price", priceStr);

        return error;
    }
}

