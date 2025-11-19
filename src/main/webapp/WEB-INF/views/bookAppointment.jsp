<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0);

HttpSession sessionObj = request.getSession(false);
if (sessionObj == null || sessionObj.getAttribute("user_id") == null || sessionObj.getAttribute("role") == null) {
    response.sendRedirect(request.getContextPath() + "/login");
    return;
}
String SessionRole = (String) sessionObj.getAttribute("role");
if (!"patient".equalsIgnoreCase(SessionRole)) {
    response.sendRedirect(request.getContextPath() + "/login");
    return;
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>HealthDotNet</title>
    <link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/images/favicon.svg">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .container {
            width: 100%;
            max-width: 600px;
        }

        /* Search */
        .search-box {
            display: flex;
            gap: 2px;
            border: 1px solid #00796b3a;
            padding: 2px;
            border-radius: 8px;
            margin-bottom: 10px;
        }

        .search-box:focus-within {
            box-shadow: 0 0 0 3px rgba(0, 121, 107, 0.1);
            border-color: #00796b;
        }

        .search-input {
            flex: 1;
            border: none;
            padding: 10px 12px;
            font-size: 15px;
            outline: none;
            color: #00796b;
        }
        .search-reset {
            padding: 10px 16px;
            border: none;
            cursor: pointer;
            font-weight: 600;
            border-radius: 0 5px 5px 0;
            transition: background 0.3s ease, transform 0.1s ease;
        }
        .search-reset {
            background: #e0f2f1;
            color: #00796b;
            text-decoration: none;
        }
        
        .search-reset:hover { background: #b2dfdb; }

        .search-reset:active {
            transform: scale(0.95);
        }

        /* Table container */
        .table-container {
            overflow-x: auto;
            border: 1px solid #00796b2a;
            border-radius: 10px;
            max-height: 450px;
            overflow-y: auto;
            scrollbar-width: none;
            -ms-overflow-style: none;
        }

        .table-container::-webkit-scrollbar {
            display: none;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background: white;
        }

        thead {
            background: linear-gradient(135deg, #e0f7fa, #e8f5e9);
            position: sticky;
            top: 0;
            z-index: 5;
        }

        th {
            padding: 14px;
            color: #004d40;
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            user-select: none;
            white-space: nowrap;
            cursor: pointer;
        }

        .th-content {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 3px;
        }

        .sort-icons {
            display: flex;
            flex-direction: column;
            font-size: 10px;
            line-height: 8px;
        }

        .sort-icons span {
            opacity: 0.2;
        }

        th.sort-asc .sort-icons .up { opacity: 1; color: #004d40; font-weight: bold; }
        th.sort-desc .sort-icons .down { opacity: 1; color: #004d40; font-weight: bold; }

        td {
            padding: 14px;
            border-bottom: 1px solid #f0f0f0;
            text-align: center;
            font-size: 14px;
        }

        tr:hover { background: #e0f7fa42; }

        .table-button {
            display: flex;
        }

        .delete {
            background-color: #bf360c;
            color: white;
            padding: 5px 10px;
            border: none;
            border-radius: 5px;
            transition: transform 0.1s ease;
        }

        .delete:hover {
            background-color: #8d2200;
        }
        .delete:active {
            transform: scale(0.95);
        }

        /* ----------------------- RESPONSIVE DESIGN ----------------------- */
        /* Tablets & Medium Screens */
        @media (max-width: 768px) {
        
            th, td {
                padding: 10px 8px;
                font-size: 13px;
                white-space: nowrap;
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
                padding: 8px;
                font-size: 13px;
            }
            .search-reset {
                border-radius: 0 0 5px 5px;
            }
        
            td {
                font-size: 11px;
            }
        }

        /* tab css */

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
            color: #004d40;
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
        
         /* Actions */
        .actions {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #999;
        }
    </style>

    <script>

        function switchTab(tabName, event) {
            if (event && event.preventDefault) event.preventDefault();

            const tabs = document.querySelectorAll(".tab-content");
            const buttons = document.querySelectorAll(".tab-btn");

            tabs.forEach(t => t.classList.remove("active"));
            buttons.forEach(b => b.classList.remove("active"));

            const target = document.getElementById(tabName);
            if (target) target.classList.add("active");

            // find the clicked button and add class
            if (event && event.currentTarget) {
                event.currentTarget.classList.add("active");
            } else {
                // fallback: activate by matching index
                const mapping = { view:0, add:1 };
                const idx = mapping[tabName] || 0;
                const btn = document.querySelectorAll(".tab-btn")[idx];
                if (btn) btn.classList.add("active");
            }
            // scroll to top of container for better UX on mobile
            window.scrollTo({ top: 0, behavior: 'smooth' });
        }

        // FORM VALIDATION
        function initAppointmentFormValidation() {
            document.querySelectorAll("form").forEach(form => {
                form.addEventListener("submit", function(e) {
                    validateAppointmentForm(e, form);
                });
            });
        }

        function validateAppointmentForm(e, form) {
            // validate only the appointment booking form
            if (!form.querySelector('input[name="speciality"]')) return;

            // Clear previous errors
            clearErrors(form);

            const speciality = form.querySelector('input[name="speciality"]');
            const appointmentDate = form.querySelector('input[name="appointment_date"]');

            let errors = false;

            // SPECIALITY (required, 3–100 characters)
            if (!speciality || !speciality.value.trim()) {
                showError(speciality, "Speciality is required");
                errors = true;
            } else if (speciality.value.trim().length < 3) {
                showError(speciality, "Speciality must be at least 3 characters");
                errors = true;
            } else if (speciality.value.trim().length > 100) {
                showError(speciality, "Maximum 100 characters allowed");
                errors = true;
            }

            // PREFERRED APPOINTMENT DATE (required)
            if (!appointmentDate || !appointmentDate.value.trim()) {
                showError(appointmentDate, "Preferred date is required");
                errors = true;
            } else {
                const selected = new Date(appointmentDate.value);
                const now = new Date();

                if (isNaN(selected.getTime())) {
                    showError(appointmentDate, "Invalid date format");
                    errors = true;
                } else if (selected < now) {
                    showError(appointmentDate, "Date must be in the future");
                    errors = true;
                }
            }

            if (errors) e.preventDefault();
        }

        function showError(field, message) {
            if (!field) return;

            const group = field.closest(".form-group") || field.parentElement;
            if (group) group.classList.add("error");

            const err = document.createElement("span");
            err.className = "error-text";
            err.textContent = message;

            // Remove existing error first
            const existing = group.querySelector(".error-text");
            if (existing) existing.remove();

            group.appendChild(err);

            try { field.focus(); } catch (e) {}
        }

        function clearErrors(form) {
            (form || document).querySelectorAll(".form-group.error").forEach(group => {
                group.classList.remove("error");
                const list = group.querySelectorAll(".error-text");
                list.forEach(el => el.remove());
            });
        }

        function searchTable() {
            let input = document.getElementById("searchInput").value.toLowerCase();
            let table = document.getElementById("appointmentTable");
            let rows = table.getElementsByTagName("tr");
            let visibleCount = 0;

            for (let i = 1; i < rows.length; i++) {
                let row = rows[i];
                let text = row.innerText.toLowerCase();
            
                if (text.includes(input)) {
                    row.style.display = "";
                    visibleCount++;
                } else {
                    row.style.display = "none";
                }
            }
        
            toggleEmptyState(visibleCount);
        }

        function resetSearch() {
            document.getElementById("searchInput").value = "";
            searchTable();
        }

        function toggleEmptyState(visibleCount) {
            const emptyState = document.getElementById("emptyState");
            const tableContainer = document.querySelector(".table-container");
        
            if (visibleCount === 0) {
                emptyState.style.display = "block";
                tableContainer.style.display = "none";
            } else {
                emptyState.style.display = "none";
                tableContainer.style.display = "block";
            }
        }

        function initAppointmentSorting() {
            const table = document.getElementById("appointmentTable");
            if (!table) return;
        
            const headers = table.querySelectorAll("th.sortable");
            const tbody = table.querySelector("tbody");
        
            if (!tbody || headers.length === 0) return;
        
            let currentSort = { column: null, direction: "asc" };
        
            headers.forEach((header, index) => {
                header.addEventListener("click", () => {
                
                    // Determine sort direction
                    const col = index;
                    currentSort.direction =
                        (currentSort.column === col && currentSort.direction === "asc")
                            ? "desc"
                            : "asc";
                
                    currentSort.column = col;
                
                    // Update sort icon classes
                    headers.forEach(h => h.classList.remove("sort-asc", "sort-desc"));
                    header.classList.add(
                        currentSort.direction === "asc" ? "sort-asc" : "sort-desc"
                    );
                
                    // Convert rows to array for sorting
                    const rows = Array.from(tbody.querySelectorAll("tr"));
                
                    rows.sort((a, b) => {
                        const aCell = a.children[col].textContent.trim();
                        const bCell = b.children[col].textContent.trim();
                    
                        // Detect and compare dates
                        const aDate = Date.parse(aCell);
                        const bDate = Date.parse(bCell);
                    
                        if (!isNaN(aDate) && !isNaN(bDate)) {
                            return currentSort.direction === "asc"
                                ? aDate - bDate
                                : bDate - aDate;
                        }
                    
                        // Detect numeric values
                        const aNum = parseFloat(aCell);
                        const bNum = parseFloat(bCell);
                    
                        if (!isNaN(aNum) && !isNaN(bNum)) {
                            return currentSort.direction === "asc"
                                ? aNum - bNum
                                : bNum - aNum;
                        }
                    
                        // Default string compare
                        return currentSort.direction === "asc"
                            ? aCell.localeCompare(bCell)
                            : bCell.localeCompare(aCell);
                    });
                
                    // Re-append sorted rows
                    rows.forEach(r => tbody.appendChild(r));
                });
            });
        }

        window.onload = function() {
            initAppointmentFormValidation();
            initAppointmentSorting();
        };
    </script>

</head>

<body>
    <div class="container">
        <%@ include file="header.jsp" %>

        <div class="bar-container">
            <a href="dashboard" class="sub-title-logo" style="left: 0;"><img src="${pageContext.request.contextPath}/images/back.svg" alt="back-logo"></a>
            <p>Appointments</p>
            <a href="logout" class="sub-title-logo" style="right: 0;"><img src="${pageContext.request.contextPath}/images/logout.svg" alt="logout-logo"></a>
        </div>

        <!-- Server messages (success / error) -->
        <%
            String successMessage = request.getParameter("successMessage") != null ? request.getParameter("successMessage") : (String) request.getAttribute("successMessage");
            String errorMessage = request.getParameter("errorMessage") != null ? request.getParameter("errorMessage") : (String) request.getAttribute("errorMessage");
            if (successMessage != null && !successMessage.isEmpty()) {
        %>
            <div class="alert alert-success" role="alert">
                <span><%= successMessage %></span>
                <span class="alert-close" onclick="this.parentElement.style.display='none'">&times;</span>
            </div>
        <% } %>

        <% if (errorMessage != null && !errorMessage.isEmpty()) { %>
            <div class="alert alert-error" role="alert">
                <span><%= errorMessage %></span>
                <span class="alert-close" onclick="this.parentElement.style.display='none'">&times;</span>
            </div>
        <% } %>

        <!-- Tabs header -->
        <div class="tabs-header" role="tablist">
            <button class="tab-btn active" onclick="switchTab('view', event)">View Appointments</button>
            <button class="tab-btn" onclick="switchTab('add', event)">Book Appointment</button>
        </div>

        <!-- VIEW TAB -->
        <div id="view" class="tab-content active">
        
            <form class="search-box">
                <input type="text" name="q" id="searchInput" class="search-input"
                       placeholder="Search appointments..." onkeyup="searchTable()"/>
                <button type="reset" class="search-reset" onclick="resetSearch()">X</button>
            </form>
        
            <%
                List<Map<String,String>> list = (List<Map<String,String>>) request.getAttribute("appointments");
                boolean hasData = (list != null && !list.isEmpty());
            %>
        
            <div class="table-container" <%= hasData ? "" : "style='display:none;'" %>>
                <table id="appointmentTable">
                    <thead>
                        <tr>
                            <th class="sortable" data-column="0">
                                <div class="th-content">
                                    <span>ID</span>
                                    <div class="sort-icons"><span class="up">▲</span><span class="down">▼</span></div>
                                </div>
                            </th>
                        
                            <th class="sortable" data-column="1">
                                <div class="th-content">
                                    <span>Speciality</span>
                                    <div class="sort-icons"><span class="up">▲</span><span class="down">▼</span></div>
                                </div>
                            </th>
                        
                            <th class="sortable" data-column="2">
                                <div class="th-content">
                                    <span>Date</span>
                                    <div class="sort-icons"><span class="up">▲</span><span class="down">▼</span></div>
                                </div>
                            </th>
                        
                            <th class="sortable" data-column="3">
                                <div class="th-content">
                                    <span>Status</span>
                                    <div class="sort-icons"><span class="up">▲</span><span class="down">▼</span></div>
                                </div>
                            </th>
                        
                            <th>Action</th>
                        </tr>
                    </thead>
                
                    <tbody>
                        <% if (hasData) {
                            for (Map<String,String> row : list) { %>
                            
                                <tr>
                                    <td><%= row.get("id") %></td>
                                    <td><%= row.get("speciality") %></td>
                                    <td><%= row.get("date") %></td>
                                    <td><%= row.get("status") %></td>
                                
                                    <td>
                                        <% if (!"completed".equals(row.get("status")) &&
                                               !"cancelled".equals(row.get("status"))) { %>
                                            
                                            <form action="bookAppointment" method="post" style="display:inline;">
                                                <input type="hidden" name="action" value="cancel">
                                                <input type="hidden" name="appointment_id" value="<%= row.get("id") %>">
                                                <button class="delete delete-btn">Cancel</button>
                                            </form>
                                        
                                        <% } %>
                                    </td>
                                </tr>
                            
                        <%   }
                           } %>
                    </tbody>
                </table>
            </div>
        
            <!-- Empty State -->
            <div id="emptyState"
                 class="empty-state"
                 <%= hasData ? "" : "style='display:none;'" %>
                <p style="font-size:18px; margin:0 0 8px 0;">No Appointments found</p>
            </div>
        
        </div>

        <!-- ADD TAB -->
        <div id="add" class="tab-content">
            <form method="POST" action="${pageContext.request.contextPath}/bookAppointment">
                <div class="form-row">
                    <div class="form-group">
                        <label for="speciality" class="required">Speciality</label>
                        <input type="text" id="speciality" name="speciality" placeholder="e.g. General checkup, Eye, Dental"  />
                        <% if (request.getAttribute("speciality") != null) { %>
                            <span class="error-text"><%= request.getAttribute("speciality") %></span>
                        <% } %>
                    </div>

                    <div class="form-group">
                        <label for="appointment_date" class="required">Preferred Appointment Date</label>
                        <input type="datetime-local" id="appointment_date" name="appointment_date" title="This is only your preferred date. Final date will be scheduled by receptionist." />
                        <% if (request.getAttribute("appointmentDateError") != null) { %>
                            <span class="error-text"><%= request.getAttribute("appointmentDateError") %></span>
                        <% } %>
                    </div>

                </div>

                <div style="display:flex; gap:10px;">
                    <button type="submit" class="btn btn-primary">Request</button>
                    <button type="reset" class="btn btn-secondary">Clear</button>
                </div>
            </form>
        </div>

        <%@ include file="footer.jsp" %>

    </div>

</body>
</html>
