<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0);

HttpSession sessionObj = request.getSession(false);

if (sessionObj == null || sessionObj.getAttribute("user_id") == null) {
    response.sendRedirect("/login");
    return;
}

String SessionRole = (String) sessionObj.getAttribute("role");

if (SessionRole == null || !SessionRole.equalsIgnoreCase("admin")) {
    response.sendRedirect("/login");
    return;
}
%>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>HealthDotNet</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script src="${pageContext.request.contextPath}/js/main.js"></script>
    <style>
        .container {
            width: 100%;
            max-width: 1200px;
            background: white;
            padding: 30px;
            margin: 20px auto;
            border-radius: 15px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
        }

        /* Tabs */
        .tabs-container {
            margin-top: 20px;
        }

        .tabs-header {
            display: flex;
            border-bottom: 2px solid #00796b;
            gap: 0;
            background: linear-gradient(135deg, #e0f7fa, #e8f5e9);
            border-radius: 15px 15px 0 0;
        }

        .tab-btn {
            flex: 1;
            padding: 14px 20px;
            background: transparent;
            border: none;
            cursor: pointer;
            font-size: 15px;
            font-weight: 600;
            color: #00796b99;
            transition: all 0.3s ease;
            border-bottom: 3px solid transparent;
            margin-bottom: -2px;
            text-align: center;
        }

        .tab-btn:hover {
            background: rgba(0, 121, 107, 0.05);
            color: #00796b;
        }

        .tab-btn.active {
            background: white;
            color: #00796b;
            border-bottom-color: #00796b;
        }

        .tab-content {
            display: none;
            padding: 10px;
            background: white;
            border: 1px solid #00796b2a;
            border-top: none;
            border-radius: 0 0 15px 15px;
            animation: fadeIn 0.3s ease;
        }

        .tab-content.active {
            display: block;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* Messages */
        .alert {
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
            border-left: 4px solid;
        }

        .alert-success {
            background: #c8e6c9;
            border-left-color: #2e7d32;
            color: #1b5e20;
        }

        .alert-error {
            background: #ffccbc;
            border-left-color: #bf360c;
            color: #bf360c;
        }

        .alert-close {
            margin-left: auto;
            cursor: pointer;
            font-size: 18px;
            font-weight: bold;
        }

        /* Forms */
        .form-group {
            margin-bottom: 20px;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }

        .form-row.full {
            grid-template-columns: 1fr;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #00796b;
            font-size: 14px;
        }

        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 10px 12px;
            border: 2px solid #00796b99;
            border-radius: 5px;
            font-size: 14px;
            font-family: inherit;
            transition: border-color 0.3s ease;
            box-sizing: border-box;
            color: #00796b;
        }

        .form-group input::placeholder,
        .form-group select::placeholder,
        .form-group textarea::placeholder {
            color: #00796b65;
        }

        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #00796b;
            box-shadow: 0 0 0 3px rgba(0, 121, 107, 0.1);
        }

        .form-group input[type="checkbox"],
        .form-group input[type="radio"] {
            width: auto;
            margin-right: 8px;
            cursor: pointer;
            accent-color: #00796b;
        }

        .form-group.error input,
        .form-group.error select {
            border-color: #bf360c;
            background: #ffe0b2;
        }

        .error-text {
            color: #bf360c;
            font-size: 13px;
            margin-top: 5px;
            display: block;
        }

        .required::after {
            content: " *";
            color: #bf360c;
        }

        /* Buttons */
        .btn-group {
            display: flex;
            gap: 10px;
            margin-top: 30px;
        }

        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
        }

        .btn-primary {
            background: #00796b;
            color: white;
        }

        .btn-primary:hover {
            background: #004d40;
            transform: translateY(-1px);
            box-shadow: 0 2px 8px rgba(0, 121, 107, 0.3);
        }

        .btn-secondary {
            background: #e0e0e0;
            color: #00796b;
            border: 2px solid #00796b;
        }

        .btn-secondary:hover {
            background: #f5f5f5;
        }

        .btn-danger {
            background: #bf360c;
            color: white;
        }

        .btn-danger:hover {
            background: #8d2200;
            transform: translateY(-1px);
            box-shadow: 0 2px 8px rgba(191, 54, 12, 0.3);
        }

        .btn-small {
            padding: 6px 12px;
            font-size: 13px;
        }

        /* Users Table */
        .table-container {
            overflow-x: auto;
            border: 1px solid #00796b2a;
            border-radius: 8px;
            margin-top: 10px;
            max-height: 450px; /* or any height you want */
            overflow-y: auto;
            -ms-overflow-style: none; /* IE and Edge */
            scrollbar-width: none;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            table-layout: auto;
        }

        thead {
            background: linear-gradient(135deg, #e0f7fa, #e8f5e9);
            font-weight: 600;
            position: sticky;
            top: 0;
            z-index: 5;
            text-align: center;
        }

        th {
            padding: 15px 12px;
            text-align: center;
            color: #004d40;
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            cursor: pointer;
            user-select: none;
            white-space: nowrap;
            position: sticky;
            top: 0;
            z-index: 10;
        }

        .th-content {
            display: flex;
            align-items: center;
            gap: 2px;
            width: 100%;
        }

        .sort-icons span {
            display: block;
            font-size: 10px;
            line-height: 10px;
            opacity: 0.4;
            cursor: pointer;
        }

        .sort-icons .active {
            opacity: 1;
            font-weight: bold;
        }
        /* Arrow wrapper */
        th .sort-icons {
            display: flex;
            flex-direction: column;
            line-height: 8px;
            font-size: 10px;
        }

        th .sort-icons span {
            color: #ccc;
        }
        
        th.sort-asc .sort-icons .up {
            color: #004d40;      
            font-weight: bold;
        }
        
        th.sort-desc .sort-icons .down {
            color: #004d40; 
            font-weight: bold;
        }

        td {
            padding: 15px 12px;
            border-bottom: 1px solid #f0f0f0;
            font-size: 14px;
        }

        tr:hover {
            background: #e0f7fa4d;
        }

        td a {
            color: #00796b;
            text-decoration: none;
            font-weight: 600;
        }

        td a:hover {
            text-decoration: underline;
        }

        .table-button {
            display: flex;
        }

        .table-button .delete {
            background-color: #bf360c;
            color: white;
            padding: 5px 10px;
            border: none;
            border-bottom-right-radius: 5px;
            border-top-right-radius: 5px;
            transition: transform 0.1s ease;
        }
        .table-button .edit {
            background-color: #00796b;
            color: white;
            padding: 5px 10px;
            border: none;
            border-bottom-left-radius: 5px;
            border-top-left-radius: 5px;
            text-decoration: none;
            transition: transform 0.1s ease;
        }
        .table-button .edit:hover {
            background-color: #004d40;
        }
        .table-button .delete:hover {
            background-color: #8d2200;
        }
        .table-button .delete:active,
        .table-button .edit:active{
            transform: scale(0.95);
        }

        .badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
        }

        .badge-admin {
            background: #e0f2f1;
            color: #00695c;
        }

        .badge-doctor {
            background: #b2ebf2;
            color: #006064;
        }

        .badge-patient {
            background: #c8e6c9;
            color: #2e7d32;
        }

        .badge-receptionist {
            background: #fff9c4;
            color: #f57f17;
        }

        .badge-active {
            background: #c8e6c9;
            color: #1b5e20;
        }

        .badge-inactive {
            background: #ffccbc;
            color: #bf360c;
        }

        .btn-small {
            padding: 6px 12px;
            font-size: 12px;
        }

        /* Search */
        .search-box {
            display: flex;
            gap: 2px;
            border: solid 1px #00796b3a;
            border-radius: 7px;
            padding: 2px; 
        }
        .search-box:focus-within {
            box-shadow: 0 0 0 3px rgba(0, 121, 107, 0.1);
            border-color: #00796b;
        }

        .search-input {
            flex: 1;
            border: none;
            padding: 10px 5px;
            font-size: 16px;
            outline: none;
            color: #00796b;
        }

        .search-submit {
            background: #00796b;
            color: white;
            border: none;
            padding: 10px 16px;
            cursor: pointer;
            border-bottom-right-radius: 4px;
            border-top-right-radius: 4px;
            font-size: 14px;
            font-weight: 600;
            transition: background 0.3s ease, transform 0.1s ease;
        }

        .search-box .search-submit:hover {
            background: #004d40;
        }

        .search-reset {
            color: #00796b;
            text-decoration: none;
            font-size: 14px;
            font-weight: 600;
            padding: 10px 16px;
            transition: background 0.3s ease, transform 0.1s ease;
            background: #e0f2f1;
        }

        .search-reset:hover {
            background: #b2dfdb;
        }

        .search-reset:active,
        .search-submit:active {
            transform: scale(0.95);
        }

        /* Actions */
        .actions {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }

        /* Modal */
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            z-index: 1000;
            align-items: center;
            justify-content: center;
        }

        .modal.active {
            display: flex;
        }

        .modal-content {
            background: white;
            padding: 30px;
            border-radius: 8px;
            max-width: 400px;
            width: 90%;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
        }

        .modal-header {
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 15px;
            color: #00796b;
        }

        .modal-body {
            margin-bottom: 20px;
            color: #666;
        }

        .modal-footer {
            display: flex;
            gap: 10px;
            justify-content: flex-end;
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #999;
        }

        .empty-state svg {
            width: 80px;
            height: 80px;
            margin-bottom: 20px;
            opacity: 0.3;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .form-row {
                grid-template-columns: 1fr;
            }

            .tabs-header {
                flex-direction: column;
            }

            .tab-btn {
                text-align: left;
            }

            .actions {
                flex-direction: column;
            }

            .btn {
                width: 100%;
            }

            .users-grid {
                grid-template-columns: 1fr;
            }

            .user-field {
                grid-template-columns: 100px 1fr;
            }

            .user-card-actions {
                flex-direction: column;
            }

            .user-card-actions .btn {
                width: 100%;
            }

            th, td {
                padding: 10px 8px;
                font-size: 13px;
                white-space: nowrap;
            }
        }

        @media (max-width: 1200px) {

            .container {
                width: 100%;
                padding: 2px;
                margin: 2px;
            }

        
        }



        /* Phones (≤ 600px) */
        @media (max-width: 600px) {
        
            /* Make table scroll smooth on mobile */
            .table-container {
                overflow-x: scroll;
                -webkit-overflow-scrolling: touch;
                max-height: 400px;
            }
        
            thead th {
                font-size: 12px;
                padding: 10px 6px;
            }
        
            td {
                font-size: 12px;
                padding: 10px 6px;
            }
        
            .badge {
                padding: 3px 8px;
                font-size: 10px;
            }
        }

        /* Extra small screens (≤ 420px) */
        @media (max-width: 420px) {
        
            th .th-content span {
                font-size: 11px;
            }
        
            .sort-icons span {
                font-size: 8px;
            }
            
            .search-box {
                flex-direction: column;
            }

            .search-input {
                padding: 12px;
                font-size: 13px;
            }
            .search-submit {
                border-radius: 0 0 5px 5px;
            }
        
            td {
                font-size: 11px;
            }
        
            .badge {
                font-size: 9px;
                padding: 3px 6px;
            }
        }

        /* Doctor Fields */
        .doctor-fields {
            display: none;
            background: #e0f7fa1a;
            padding: 15px;
            border-radius: 8px;
            margin: 15px 0;
            border-left: 4px solid #00796b;
        }

        .doctor-fields.show {
            display: block;
        }

        /* Checkbox */
        .checkbox-group {
            display: flex;
            align-items: center;
            gap: 10px;
        }
    </style>
</head>
<body>
	
	<div class="container">
		<%@ include file="header.jsp" %>

        <div class="bar-container">
            <a href="dashboard" class="sub-title-logo" style="left: 0;"><img src="${pageContext.request.contextPath}/images/back.svg" alt="back logo"></a>
            <p><strong>Manage Users</strong></p>
            <a href="logout" class="sub-title-logo" style="right: 0;"><img src="${pageContext.request.contextPath}/images/logout.svg" alt="logout logo"></a>
        </div>

        <!-- Messages -->
        <%
            String successMessage = (String) request.getAttribute("successMessage");
            String errorMessage = (String) request.getAttribute("errorMessage");
            
            if (successMessage != null && !successMessage.isEmpty()) {
        %>
        <div class="alert alert-success">
            <span>✓ <%= successMessage %></span>
            <span class="alert-close" onclick="this.parentElement.style.display='none';">&times;</span>
        </div>
        <%
            }
        %>

        <%
            if (errorMessage != null && !errorMessage.isEmpty()) {
        %>
        <div class="alert alert-error">
            <span>✗ <%= errorMessage %></span>
            <span class="alert-close" onclick="this.parentElement.style.display='none';">&times;</span>
        </div>
        <%
            }
        %>

        <!-- Tabs -->
        <div class="tabs-container">
            <div class="tabs-header">
                <%
                    String showPanel = (String) request.getAttribute("showPanel");
                    if (showPanel == null) showPanel = "view";
                %>
                <button class="tab-btn <%= showPanel.equals("view") || showPanel.equals("") ? "active" : "" %>" onclick="switchTab('view')">
                    Users List
                </button>
                <button class="tab-btn <%= showPanel.equals("add") ? "active" : "" %>" onclick="switchTab('add')">
                    Add User
                </button>
                <button class="tab-btn <%= showPanel.equals("edit") ? "active" : "" %>" onclick="switchTab('edit')" <%= request.getAttribute("editUser") == null ? "disabled" : "" %>>
                    Edit User
                </button>
            </div>

            <!-- VIEW USERS TAB -->
            <div id="view" class="tab-content <%= showPanel.equals("view") || showPanel.equals("") ? "active" : "" %>">

                <form method="GET" action="${pageContext.request.contextPath}/manageUsers" class="search-box">
                    <input type="text" name="q" class="search-input" placeholder="Search by username, name, email, or speciality..." value="<%= request.getAttribute("q") != null ? request.getAttribute("q") : "" %>">
                    <a href="${pageContext.request.contextPath}/manageUsers" class="search-reset">X</a>
                    <button type="submit" class="search-submit">Search</button>
                </form>

                <%
                    List<Map<String, Object>> users = (List<Map<String, Object>>) request.getAttribute("users");
                    if (users != null && !users.isEmpty()) {
                %>
                <div class="table-container">
                    <table id="usersTable">
                        <thead>
                            <tr>
                                <th class="sortable" data-column="user_id">
                                    <div class="th-content">
                                        <span>ID</span>
                                        <div class="sort-icons"><span class="up">▲</span><span class="down">▼</span></div>
                                    </div>
                                </th>
                            
                                <th class="sortable" data-column="full_name">
                                    <div class="th-content">
                                        <span>FullName</span>
                                        <div class="sort-icons"><span class="up">▲</span><span class="down">▼</span></div>
                                    </div>
                                </th>
                            
                                <th class="sortable" data-column="username">
                                    <div class="th-content">
                                        <span>Username</span>
                                        <div class="sort-icons"><span class="up">▲</span><span class="down">▼</span></div>
                                    </div>
                                </th>
                            
                                <th class="sortable" data-column="email">
                                    <div class="th-content">
                                        <span>Email</span>
                                        <div class="sort-icons"><span class="up">▲</span><span class="down">▼</span></div>
                                    </div>
                                </th>
                            
                                <th class="sortable" data-column="phone">
                                    <div class="th-content">
                                        <span>Phone</span>
                                        <div class="sort-icons"><span class="up">▲</span><span class="down">▼</span></div>
                                    </div>
                                </th>
                            
                                <th class="sortable" data-column="role">
                                    <div class="th-content">
                                        <span>Role</span>
                                        <div class="sort-icons"><span class="up">▲</span><span class="down">▼</span></div>
                                    </div>
                                </th>
                            
                                <th class="sortable" data-column="is_active">
                                    <div class="th-content">
                                        <span>Status</span>
                                        <div class="sort-icons"><span class="up">▲</span><span class="down">▼</span></div>
                                    </div>
                                </th>
                            
                                <th class="sortable" data-column="date_of_birth">
                                    <div class="th-content">
                                        <span>DOB</span>
                                        <div class="sort-icons"><span class="up">▲</span><span class="down">▼</span></div>
                                    </div>
                                </th>
                            
                                <th class="sortable" data-column="speciality">
                                    <div class="th-content">
                                        <span>Speciality</span>
                                        <div class="sort-icons"><span class="up">▲</span><span class="down">▼</span></div>
                                    </div>
                                </th>
                            
                                <th class="sortable" data-column="consultation_fee">
                                    <div class="th-content">
                                        <span>Fee</span>
                                        <div class="sort-icons"><span class="up">▲</span><span class="down">▼</span></div>
                                    </div>
                                </th>
                            
                                <th>
                                    Actions
                                </th>
                            </tr>
                        </thead>

                        <tbody>
                            <%
                                for (Map<String, Object> user : users) {
                                    String role = (String) user.get("role");
                                    Boolean isActive = (Boolean) user.get("is_active");
                                    String roleLower = role != null ? role.toLowerCase() : "patient";
                                    String fullName = (String) user.get("full_name");
                                    int userId = (Integer) user.get("user_id");
                            %>
                            <tr>
                                <td><%= user.get("user_id") %></td>
                                <td><%= user.get("full_name") %></td>
                                <td><%= user.get("username") %></td>
                                <td><%= user.get("email") %></td>
                                <td><%= user.get("phone") %></td>
                                <td>
                                    <span class="badge badge-<%= roleLower %>">
                                        <%= role %>
                                    </span>
                                </td>
                                <td>
                                    <%
                                        if (isActive != null && isActive) {
                                    %>
                                    <span class="badge badge-active">Active</span>
                                    <%
                                        } else {
                                    %>
                                    <span class="badge badge-inactive">Inactive</span>
                                    <%
                                        }
                                    %>
                                </td>
                                <td><%= user.get("date_of_birth") != null ? user.get("date_of_birth") : "-" %></td>
                                <td><%= user.get("speciality") != null ? user.get("speciality") : "-" %></td>
                                <td><%= user.get("consultation_fee") != null ? user.get("consultation_fee") : "-" %></td>
                                <td class="table-button">
                                    <a href="?action=edit&id=<%= userId %>" class="edit">Edit</a>
                                    <button type="button" class="delete delete-btn" data-id="<%= userId %>" data-name="<%= fullName %>">X</button>
                                </td>
                            </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                </div>
                <%
                    } else {
                %>
                <div class="empty-state">
                    <p style="font-size: 18px; margin-top: 20px;">No users found</p>
                    <p style="color: #bbb; margin-top: 10px;">Click "Add User" to create a new user</p>
                </div>
                <%
                    }
                %>
            </div>

            <!-- ADD USER TAB -->
            <div id="add" class="tab-content <%= showPanel.equals("add") ? "active" : "" %>">
                <form method="POST" action="${pageContext.request.contextPath}/manageUsers">
                    <input type="hidden" name="action" value="add">

                    <div class="form-row">
                        <div class="form-group <%= request.getAttribute("roleError") != null ? "error" : "" %>">
                            <label for="roleAdd" class="required">Role</label>
                            <select id="roleAdd" name="role" onchange="handleRoleChange('add')">
                                <option value="">-- Select Role --</option>
                                <option value="admin" <%= "admin".equals(request.getAttribute("role")) ? "selected" : "" %>>Admin</option>
                                <option value="doctor" <%= "doctor".equals(request.getAttribute("role")) ? "selected" : "" %>>Doctor</option>
                                <option value="patient" <%= "patient".equals(request.getAttribute("role")) ? "selected" : "" %>>Patient</option>
                                <option value="receptionist" <%= "receptionist".equals(request.getAttribute("role")) ? "selected" : "" %>>Receptionist</option>
                            </select>
                            <% if (request.getAttribute("roleError") != null) { %>
                            <span class="error-text"><%= request.getAttribute("roleError") %></span>
                            <% } %>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group <%= request.getAttribute("fullnameError") != null ? "error" : "" %>">
                            <label for="fullnameAdd" class="required">Full Name</label>
                            <input type="text" id="fullnameAdd" name="fullname" value="<%= request.getAttribute("fullname") != null ? request.getAttribute("fullname") : "" %>" placeholder="John Doe">
                            <% if (request.getAttribute("fullnameError") != null) { %>
                            <span class="error-text"><%= request.getAttribute("fullnameError") %></span>
                            <% } %>
                        </div>

                        <div class="form-group <%= request.getAttribute("usernameError") != null ? "error" : "" %>">
                            <label for="usernameAdd" class="required">Username</label>
                            <input type="text" id="usernameAdd" name="username" value="<%= request.getAttribute("username") != null ? request.getAttribute("username") : "" %>" placeholder="john_doe">
                            <% if (request.getAttribute("usernameError") != null) { %>
                            <span class="error-text"><%= request.getAttribute("usernameError") %></span>
                            <% } %>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group <%= request.getAttribute("emailError") != null ? "error" : "" %>">
                            <label for="emailAdd" class="required">Email</label>
                            <input type="email" id="emailAdd" name="email" value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>" placeholder="john@example.com">
                            <% if (request.getAttribute("emailError") != null) { %>
                            <span class="error-text"><%= request.getAttribute("emailError") %></span>
                            <% } %>
                        </div>

                        <div class="form-group <%= request.getAttribute("phoneError") != null ? "error" : "" %>">
                            <label for="phoneAdd" class="required">Phone</label>
                            <input type="tel" id="phoneAdd" name="phone" value="<%= request.getAttribute("phone") != null ? request.getAttribute("phone") : "" %>" placeholder="1234567890">
                            <% if (request.getAttribute("phoneError") != null) { %>
                            <span class="error-text"><%= request.getAttribute("phoneError") %></span>
                            <% } %>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group <%= request.getAttribute("passwordError") != null ? "error" : "" %>">
                            <label for="passwordAdd" class="required">Password</label>
                            <input type="password" id="passwordAdd" name="password" placeholder="••••••••">
                            <% if (request.getAttribute("passwordError") != null) { %>
                            <span class="error-text"><%= request.getAttribute("passwordError") %></span>
                            <% } %>
                        </div>

                        <div class="form-group <%= request.getAttribute("confirmPasswordError") != null ? "error" : "" %>">
                            <label for="confirmPasswordAdd" class="required">Confirm Password</label>
                            <input type="password" id="confirmPasswordAdd" name="confirmPassword" placeholder="••••••••">
                            <% if (request.getAttribute("confirmPasswordError") != null) { %>
                            <span class="error-text"><%= request.getAttribute("confirmPasswordError") %></span>
                            <% } %>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group <%= request.getAttribute("dobError") != null ? "error" : "" %>">
                            <label for="dobAdd" class="required">Date of Birth</label>
                            <input type="date" id="dobAdd" name="dateOfBirth" value="<%= request.getAttribute("dateOfBirth") != null ? request.getAttribute("dateOfBirth") : "" %>">
                            <% if (request.getAttribute("dobError") != null) { %>
                            <span class="error-text"><%= request.getAttribute("dobError") %></span>
                            <% } %>
                        </div>

                        <div class="form-group">
                            <label class="checkbox-group">
                                <input type="checkbox" name="isActive" value="on" checked>
                                <span>Active</span>
                            </label>
                        </div>
                    </div>

                    <!-- Doctor Fields -->
                    <div id="doctorFieldsAdd" class="doctor-fields">
                        <div class="form-row">
                            <div class="form-group <%= request.getAttribute("specialityError") != null ? "error" : "" %>">
                                <label for="specialityAdd" class="required">Speciality</label>
                                <input type="text" id="specialityAdd" name="speciality" value="<%= request.getAttribute("speciality") != null ? request.getAttribute("speciality") : "" %>" placeholder="e.g., Cardiology">
                                <% if (request.getAttribute("specialityError") != null) { %>
                                <span class="error-text"><%= request.getAttribute("specialityError") %></span>
                                <% } %>
                            </div>

                            <div class="form-group <%= request.getAttribute("consultationFeeError") != null ? "error" : "" %>">
                                <label for="consultationFeeAdd" class="required">Consultation Fee</label>
                                <input type="number" id="consultationFeeAdd" name="consultationFee" value="<%= request.getAttribute("consultationFee") != null ? request.getAttribute("consultationFee") : "" %>" placeholder="100.00" step="0.01">
                                <% if (request.getAttribute("consultationFeeError") != null) { %>
                                <span class="error-text"><%= request.getAttribute("consultationFeeError") %></span>
                                <% } %>
                            </div>
                        </div>
                    </div>

                    <div class="btn-group">
                        <button type="submit" class="btn btn-primary">Add User</button>
                        <button type="reset" class="btn btn-secondary">Clear</button>
                    </div>
                </form>
            </div>

            <!-- EDIT USER TAB -->
            <div id="edit" class="tab-content <%= showPanel.equals("edit") ? "active" : "" %>">
                <%
                    Map<String, Object> editUser = (Map<String, Object>) request.getAttribute("editUser");
                    if (editUser != null) {
                %>

                <form method="POST" action="${pageContext.request.contextPath}/manageUsers">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="user_id" value="<%= editUser.get("user_id") %>">

                    <div class="form-row">
                        <div class="form-group <%= request.getAttribute("roleError") != null ? "error" : "" %>">
                            <label for="roleEdit" class="required">Role</label>
                            <select id="roleEdit" name="role" onchange="handleRoleChange('edit')">
                                <option value="">-- Select Role --</option>
                                <option value="admin" <%= "admin".equals(editUser.get("role")) ? "selected" : "" %>>Admin</option>
                                <option value="doctor" <%= "doctor".equals(editUser.get("role")) ? "selected" : "" %>>Doctor</option>
                                <option value="patient" <%= "patient".equals(editUser.get("role")) ? "selected" : "" %>>Patient</option>
                                <option value="receptionist" <%= "receptionist".equals(editUser.get("role")) ? "selected" : "" %>>Receptionist</option>
                            </select>
                            <% if (request.getAttribute("roleError") != null) { %>
                            <span class="error-text"><%= request.getAttribute("roleError") %></span>
                            <% } %>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group <%= request.getAttribute("fullnameError") != null ? "error" : "" %>">
                            <label for="fullnameEdit" class="required">Full Name</label>
                            <input type="text" id="fullnameEdit" name="fullname" value="<%= editUser.get("full_name") != null ? editUser.get("full_name") : "" %>" placeholder="John Doe">
                            <% if (request.getAttribute("fullnameError") != null) { %>
                            <span class="error-text"><%= request.getAttribute("fullnameError") %></span>
                            <% } %>
                        </div>

                        <div class="form-group <%= request.getAttribute("usernameError") != null ? "error" : "" %>">
                            <label for="usernameEdit" class="required">Username</label>
                            <input type="text" id="usernameEdit" name="username" value="<%= editUser.get("username") != null ? editUser.get("username") : "" %>" placeholder="john_doe">
                            <% if (request.getAttribute("usernameError") != null) { %>
                            <span class="error-text"><%= request.getAttribute("usernameError") %></span>
                            <% } %>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group <%= request.getAttribute("emailError") != null ? "error" : "" %>">
                            <label for="emailEdit" class="required">Email</label>
                            <input type="email" id="emailEdit" name="email" value="<%= editUser.get("email") != null ? editUser.get("email") : "" %>" placeholder="john@example.com">
                            <% if (request.getAttribute("emailError") != null) { %>
                            <span class="error-text"><%= request.getAttribute("emailError") %></span>
                            <% } %>
                        </div>

                        <div class="form-group <%= request.getAttribute("phoneError") != null ? "error" : "" %>">
                            <label for="phoneEdit" class="required">Phone</label>
                            <input type="tel" id="phoneEdit" name="phone" value="<%= editUser.get("phone") != null ? editUser.get("phone") : "" %>" placeholder="1234567890">
                            <% if (request.getAttribute("phoneError") != null) { %>
                            <span class="error-text"><%= request.getAttribute("phoneError") %></span>
                            <% } %>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group <%= request.getAttribute("passwordError") != null ? "error" : "" %>">
                            <label for="passwordEdit">Password <small>(leave empty to keep unchanged)</small></label>
                            <input type="password" id="passwordEdit" name="password" placeholder="••••••••">
                            <% if (request.getAttribute("passwordError") != null) { %>
                            <span class="error-text"><%= request.getAttribute("passwordError") %></span>
                            <% } %>
                        </div>

                        <div class="form-group <%= request.getAttribute("confirmPasswordError") != null ? "error" : "" %>">
                            <label for="confirmPasswordEdit">Confirm Password</label>
                            <input type="password" id="confirmPasswordEdit" name="confirmPassword" placeholder="••••••••">
                            <% if (request.getAttribute("confirmPasswordError") != null) { %>
                            <span class="error-text"><%= request.getAttribute("confirmPasswordError") %></span>
                            <% } %>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group <%= request.getAttribute("dobError") != null ? "error" : "" %>">
                            <label for="dobEdit" class="required">Date of Birth</label>
                            <input type="date" id="dobEdit" name="dateOfBirth" value="<%= editUser.get("date_of_birth") != null ? editUser.get("date_of_birth") : "" %>">
                            <% if (request.getAttribute("dobError") != null) { %>
                            <span class="error-text"><%= request.getAttribute("dobError") %></span>
                            <% } %>
                        </div>

                        <div class="form-group">
                            <label class="checkbox-group">
                                <input type="checkbox" name="isActive" value="on" <%= (editUser.get("is_active") instanceof Boolean && (Boolean) editUser.get("is_active")) ? "checked" : "" %>>
                                <span>Active</span>
                            </label>
                        </div>
                    </div>

                    <!-- Doctor Fields -->
                    <div id="doctorFieldsEdit" class="doctor-fields <%= "doctor".equals(editUser.get("role")) ? "show" : "" %>">
                        <div class="form-row">
                            <div class="form-group <%= request.getAttribute("specialityError") != null ? "error" : "" %>">
                                <label for="specialityEdit" class="required">Speciality</label>
                                <input type="text" id="specialityEdit" name="speciality" value="<%= editUser.get("speciality") != null ? editUser.get("speciality") : "" %>" placeholder="e.g., Cardiology">
                                <% if (request.getAttribute("specialityError") != null) { %>
                                <span class="error-text"><%= request.getAttribute("specialityError") %></span>
                                <% } %>
                            </div>

                            <div class="form-group <%= request.getAttribute("consultationFeeError") != null ? "error" : "" %>">
                                <label for="consultationFeeEdit" class="required">Consultation Fee</label>
                                <input type="number" id="consultationFeeEdit" name="consultationFee" value="<%= editUser.get("consultation_fee") != null ? editUser.get("consultation_fee") : "" %>" placeholder="100.00" step="0.01">
                                <% if (request.getAttribute("consultationFeeError") != null) { %>
                                <span class="error-text"><%= request.getAttribute("consultationFeeError") %></span>
                                <% } %>
                            </div>
                        </div>
                    </div>

                    <div class="btn-group">
                        <button type="submit" class="btn btn-primary">Update User</button>
                        <a href="${pageContext.request.contextPath}/manageUsers" class="btn btn-secondary">Cancel</a>
                    </div>
                </form>
                <%
                    } else {
                %>
                <div class="empty-state">
                    <p style="font-size: 16px; margin-top: 20px;">No user selected for editing</p>
                    <p style="color: #bbb; margin-top: 10px;">Select a user from the list to edit</p>
                </div>
                <%
                    }
                %>
            </div>
        </div>
		<%@ include file="footer.jsp" %>
    </div>

    <!-- Delete Confirmation Modal -->
    <div id="deleteModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">Confirm Delete</div>
            <div class="modal-body">
                Are you sure you want to delete user <strong id="deleteUserName"></strong>? This action cannot be undone.
            </div>
            <div class="modal-footer">
                <button class="btn btn-secondary" onclick="closeDeleteModal()">Cancel</button>
                <button class="btn btn-danger" onclick="performDelete()">Delete</button>
            </div>
        </div>
    </div>


    <script>
        let deleteUserId = null;

        // Handle delete button clicks
        document.addEventListener('DOMContentLoaded', function() {
            document.querySelectorAll('.delete-btn').forEach(btn => {
                btn.addEventListener('click', function() {
                    const userId = this.getAttribute('data-id');
                    const userName = this.getAttribute('data-name');
                    confirmDelete(userId, userName);
                });
            });
        });

        // Tab switching
        function switchTab(tabName) {
            const tabs = document.querySelectorAll('.tab-content');
            const buttons = document.querySelectorAll('.tab-btn');

            tabs.forEach(tab => tab.classList.remove('active'));
            buttons.forEach(btn => btn.classList.remove('active'));

            const tab = document.getElementById(tabName);
            const button = event.target;

            if (tab) {
                tab.classList.add('active');
                button.classList.add('active');
            }
        }

        // Handle role change to show/hide doctor fields
        function handleRoleChange(mode) {
            const roleSelect = document.getElementById('role' + (mode === 'add' ? 'Add' : 'Edit'));
            const doctorFields = document.getElementById('doctorFields' + (mode === 'add' ? 'Add' : 'Edit'));

            if (roleSelect.value === 'doctor') {
                doctorFields.classList.add('show');
            } else {
                doctorFields.classList.remove('show');
            }
        }

        // Delete confirmation
        function confirmDelete(userId, userName) {
            deleteUserId = userId;
            document.getElementById('deleteUserName').textContent = userName;
            document.getElementById('deleteModal').classList.add('active');
        }

        function closeDeleteModal() {
            document.getElementById('deleteModal').classList.remove('active');
            deleteUserId = null;
        }

        function performDelete() {
            if (deleteUserId) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/manageUsers';

                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'delete';

                const idInput = document.createElement('input');
                idInput.type = 'hidden';
                idInput.name = 'id';
                idInput.value = deleteUserId;

                form.appendChild(actionInput);
                form.appendChild(idInput);
                document.body.appendChild(form);
                form.submit();
            }
        }

        // Close modal on Escape key
        document.addEventListener('keydown', function(event) {
            if (event.key === 'Escape') {
                closeDeleteModal();
            }
        });

        // Initialize doctor fields visibility on page load
        window.addEventListener('load', function() {
            handleRoleChange('add');
            handleRoleChange('edit');

            // Initialize tab state from URL or query parameter
            const urlParams = new URLSearchParams(window.location.search);
            const action = '${showPanel}';
            if (action && action !== 'null' && action !== '') {
                const tab = document.getElementById(action);
                if (tab) {
                    const allTabs = document.querySelectorAll('.tab-content');
                    const allButtons = document.querySelectorAll('.tab-btn');
                    allTabs.forEach(t => t.classList.remove('active'));
                    allButtons.forEach(b => b.classList.remove('active'));

                    tab.classList.add('active');
                    allButtons[action === 'edit' ? 2 : (action === 'add' ? 1 : 0)].classList.add('active');
                }
            }
        });

        // Helper function to show inline error
        function showFieldError(field, message) {
            if (!field) return;
            const group = field.closest('.form-group');
            if (!group) return;
            
            group.classList.add('error');
            
            // Remove existing validation error message
            const existingError = group.querySelector('.error-text[data-validation]');
            if (existingError) existingError.remove();
            
            // Add new error message
            const errorMsg = document.createElement('span');
            errorMsg.className = 'error-text';
            errorMsg.setAttribute('data-validation', 'true');
            errorMsg.textContent = message;
            group.appendChild(errorMsg);
        }

        function clearValidationErrors() {
            document.querySelectorAll('.form-group.error').forEach(group => {
                group.classList.remove('error');
                const errorMsg = group.querySelector('.error-text[data-validation]');
                if (errorMsg) errorMsg.remove();
            });
        }

        // Form validation with enhanced checks
        document.querySelectorAll('form').forEach(form => {
            form.addEventListener('submit', function(e) {
                const actionInput = this.querySelector('input[name="action"]');
                if (!actionInput) return;

                const action = actionInput.value;

                // Validate add/update forms
                if (action === 'add' || action === 'update') {
                    clearValidationErrors();

                    const fullname = this.querySelector('input[name="fullname"]');
                    const username = this.querySelector('input[name="username"]');
                    const email = this.querySelector('input[name="email"]');
                    const phone = this.querySelector('input[name="phone"]');
                    const password = this.querySelector('input[name="password"]');
                    const confirmPassword = this.querySelector('input[name="confirmPassword"]');
                    const role = this.querySelector('select[name="role"]');
                    const dateOfBirth = this.querySelector('input[name="dateOfBirth"]');
                    const speciality = this.querySelector('input[name="speciality"]');
                    const consultationFee = this.querySelector('input[name="consultationFee"]');

                    let hasError = false;

                    // Validate role
                    if (!role || !role.value.trim()) {
                        showFieldError(role, 'Role is required');
                        hasError = true;
                    } else if (!['admin', 'doctor', 'patient', 'receptionist'].includes(role.value)) {
                        showFieldError(role, 'Invalid role selected');
                        hasError = true;
                    }

                    // Validate full name
                    if (!fullname || !fullname.value.trim()) {
                        showFieldError(fullname, 'Full name is required');
                        hasError = true;
                    } else if (fullname.value.trim().length > 100) {
                        showFieldError(fullname, 'Full name must not exceed 100 characters');
                        hasError = true;
                    }

                    // Validate username
                    if (!username || !username.value.trim()) {
                        showFieldError(username, 'Username is required');
                        hasError = true;
                    } else if (username.value.includes(' ')) {
                        showFieldError(username, 'Username must not contain spaces');
                        hasError = true;
                    } else if (!/^[a-zA-Z0-9._-]{4,20}$/.test(username.value)) {
                        showFieldError(username, 'Username must be 4-20 characters (letters, numbers, _, ., - only)');
                        hasError = true;
                    }

                    // Validate email
                    if (!email || !email.value.trim()) {
                        showFieldError(email, 'Email is required');
                        hasError = true;
                    } else if (!/^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/.test(email.value)) {
                        showFieldError(email, 'Invalid email format');
                        hasError = true;
                    }

                    // Validate phone
                    if (!phone || !phone.value.trim()) {
                        showFieldError(phone, 'Phone is required');
                        hasError = true;
                    } else if (!/^[+]?[0-9]{10,15}$/.test(phone.value)) {
                        showFieldError(phone, 'Phone must be 10-15 digits, optionally starting with +');
                        hasError = true;
                    }

                    // Validate password
                    if (action === 'add') {
                        // ADD: Password is required
                        if (!password || !password.value.trim()) {
                            showFieldError(password, 'Password is required');
                            hasError = true;
                        } else if (password.value.length < 6) {
                            showFieldError(password, 'Password must be at least 6 characters');
                            hasError = true;
                        }

                        if (!confirmPassword || !confirmPassword.value.trim()) {
                            showFieldError(confirmPassword, 'Confirm password is required');
                            hasError = true;
                        } else if (password.value !== confirmPassword.value) {
                            showFieldError(confirmPassword, 'Passwords do not match');
                            hasError = true;
                        }
                    } else if (action === 'update') {
                        // EDIT: Password is optional, but if provided must match
                        if ((password && password.value.trim()) || (confirmPassword && confirmPassword.value.trim())) {
                            if (!password || !password.value.trim()) {
                                showFieldError(password, 'Password is required when changing password');
                                hasError = true;
                            } else if (password.value.length < 6) {
                                showFieldError(password, 'Password must be at least 6 characters');
                                hasError = true;
                            }

                            if (!confirmPassword || !confirmPassword.value.trim()) {
                                showFieldError(confirmPassword, 'Confirm password is required when changing password');
                                hasError = true;
                            } else if (password.value !== confirmPassword.value) {
                                showFieldError(confirmPassword, 'Passwords do not match');
                                hasError = true;
                            }
                        }
                    }

                    // Validate date of birth - REQUIRED
                    if (!dateOfBirth || !dateOfBirth.value.trim()) {
                        showFieldError(dateOfBirth, 'Date of birth is required');
                        hasError = true;
                    } else if (!/^\d{4}-\d{2}-\d{2}$/.test(dateOfBirth.value)) {
                        showFieldError(dateOfBirth, 'Date must be in YYYY-MM-DD format');
                        hasError = true;
                    } else {
                        const dob = new Date(dateOfBirth.value);
                        const today = new Date();
                        if (dob > today) {
                            showFieldError(dateOfBirth, 'Date of birth cannot be in the future');
                            hasError = true;
                        } else if (today.getFullYear() - dob.getFullYear() > 120) {
                            showFieldError(dateOfBirth, 'Date of birth seems invalid (too old)');
                            hasError = true;
                        }
                    }

                    // Validate doctor-specific fields
                    if (role && role.value === 'doctor') {
                        if (!speciality || !speciality.value.trim()) {
                            showFieldError(speciality, 'Speciality is required for doctors');
                            hasError = true;
                        } else if (speciality.value.trim().length > 100) {
                            showFieldError(speciality, 'Speciality must not exceed 100 characters');
                            hasError = true;
                        }

                        if (!consultationFee || !consultationFee.value.trim()) {
                            showFieldError(consultationFee, 'Consultation fee is required for doctors');
                            hasError = true;
                        } else if (!/^\d+(\.\d{1,2})?$/.test(consultationFee.value)) {
                            showFieldError(consultationFee, 'Consultation fee must be a valid number with up to 2 decimal places');
                            hasError = true;
                        } else if (parseFloat(consultationFee.value) <= 0) {
                            showFieldError(consultationFee, 'Consultation fee must be greater than 0');
                            hasError = true;
                        } else if (parseFloat(consultationFee.value) > 99999.99) {
                            showFieldError(consultationFee, 'Consultation fee is too large');
                            hasError = true;
                        }
                    }

                    if (hasError) {
                        e.preventDefault();
                        return false;
                    }
                }
            });
        });

        // Table Sorting Functionality
        const table = document.getElementById('usersTable');
        if (table) {
            const headers = table.querySelectorAll('th.sortable');
            let currentSort = { column: null, direction: 'asc' };

            headers.forEach(header => {
                header.addEventListener('click', function() {
                    const column = this.getAttribute('data-column');
                    const rows = Array.from(table.querySelectorAll('tbody tr'));

                    // Determine sort direction
                    if (currentSort.column === column) {
                        currentSort.direction = currentSort.direction === 'asc' ? 'desc' : 'asc';
                    } else {
                        currentSort.direction = 'asc';
                    }

                    // Remove sort indicators from all headers
                    headers.forEach(h => {
                        h.classList.remove('sort-asc', 'sort-desc');
                    });

                    // Add sort indicator to current header
                    this.classList.add(currentSort.direction === 'asc' ? 'sort-asc' : 'sort-desc');

                    // Sort rows
                    rows.sort((a, b) => {
                        let aValue = a.children[headers[0].parentElement.children.length - 1].textContent;
                        let bValue = b.children[headers[0].parentElement.children.length - 1].textContent;

                        // Get index of sorted column
                        let columnIndex = Array.from(headers).findIndex(h => h === header);
                        if (columnIndex >= 0) {
                            aValue = a.children[columnIndex]?.textContent?.trim() || '';
                            bValue = b.children[columnIndex]?.textContent?.trim() || '';

                            // Try to parse as number for numeric columns
                            if (column === 'user_id' || column === 'consultation_fee') {
                                const aNum = parseFloat(aValue);
                                const bNum = parseFloat(bValue);
                                if (!isNaN(aNum) && !isNaN(bNum)) {
                                    return currentSort.direction === 'asc' ? aNum - bNum : bNum - aNum;
                                }
                            }

                            // String comparison
                            if (currentSort.direction === 'asc') {
                                return aValue.localeCompare(bValue);
                            } else {
                                return bValue.localeCompare(aValue);
                            }
                        }
                        return 0;
                    });

                    // Update current sort state
                    currentSort.column = column;

                    // Re-append sorted rows
                    const tbody = table.querySelector('tbody');
                    rows.forEach(row => tbody.appendChild(row));
                });
            });
        }
    </script>
</body>
</html>