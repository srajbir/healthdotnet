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
if (!"receptionist".equalsIgnoreCase(SessionRole)) {
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
            max-width: 900px;
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

        .con {
            background-color: #00796b;
            color: white;
            padding: 5px 10px;
            border: none;
            border-radius: 5px;
            transition: transform 0.1s ease;
        }

        .con:hover {
            background-color: #004d40;
        }
        .con:active {
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

        input,
        select {
            width: 90%;
            padding: 5px 6px;
            border: 2px solid #00796b99;
            border-radius: 5px;
            font-size: 14px;
            font-family: inherit;
            transition: border-color 0.3s ease;
            box-sizing: border-box;
            color: #00796b;
        }

        input::placeholder,
        select::placeholder {
            color: #00796b65;
        }

        input:focus,
        select:focus {
            outline: none;
            border-color: #00796b;
            box-shadow: 0 0 0 3px rgba(0, 121, 107, 0.1);
        }

        .required::after {
            content: " *";
            color: #bf360c;
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #999;
        }
    </style>

    <script>
        function initAppointmentSorting() {
            const table = document.getElementById("appointmentTable");
            if (!table) return;

            const headers = table.querySelectorAll("th.sortable");
            const tbody = table.querySelector("tbody");

            if (!tbody || headers.length === 0) return;

            let currentSort = { column: null, direction: "asc" };

            headers.forEach((header, index) => {
                // Only allow sorting for columns 0,1,2
                if (index > 2) return;
            
                header.addEventListener("click", () => {
                    const col = index;
                
                    // Toggle sort direction
                    currentSort.direction =
                        currentSort.column === col && currentSort.direction === "asc"
                            ? "desc"
                            : "asc";
                
                    currentSort.column = col;
                
                    // Update icons
                    headers.forEach(h => h.classList.remove("sort-asc", "sort-desc"));
                    header.classList.add(
                        currentSort.direction === "asc" ? "sort-asc" : "sort-desc"
                    );
                
                    let rows = Array.from(tbody.querySelectorAll("tr"));
                
                    rows.sort((a, b) => {
                        const aCell = a.children[col].innerText.trim();
                        const bCell = b.children[col].innerText.trim();
                    
                        // Date sorting
                        const aDate = Date.parse(aCell);
                        const bDate = Date.parse(bCell);
                        if (!isNaN(aDate) && !isNaN(bDate)) {
                            return currentSort.direction === "asc"
                                ? aDate - bDate
                                : bDate - aDate;
                        }
                    
                        // Numeric sorting
                        const aNum = parseFloat(aCell);
                        const bNum = parseFloat(bCell);
                        if (!isNaN(aNum) && !isNaN(bNum)) {
                            return currentSort.direction === "asc"
                                ? aNum - bNum
                                : bNum - aNum;
                        }
                    
                        // Case-insensitive text sorting
                        return currentSort.direction === "asc"
                            ? aCell.toLowerCase().localeCompare(bCell.toLowerCase())
                            : bCell.toLowerCase().localeCompare(aCell.toLowerCase());
                    });
                
                    // Re-append sorted rows
                    rows.forEach(r => tbody.appendChild(r));
                });
            });
        }

        function searchTable() {
            const input = document.getElementById("searchInput").value.toLowerCase().trim();
            const table = document.getElementById("appointmentTable");
            const tbody = table.querySelector("tbody");
            const rows = tbody.querySelectorAll("tr");
        
            let visibleCount = 0;
        
            rows.forEach(row => {
                // Read only first 3 columns
                const col1 = row.children[0].innerText.toLowerCase(); // ID
                const col2 = row.children[1].innerText.toLowerCase(); // Speciality
                const col3 = row.children[2].innerText.toLowerCase(); // Preferred Date
            
                // Match condition (partial match)
                const match =
                    col1.includes(input) ||
                    col2.includes(input) ||
                    col3.includes(input);
            
                if (match) {
                    row.style.display = "";
                    visibleCount++;
                } else {
                    row.style.display = "none";
                }
            });
        
            // Update empty-state visibility
            toggleEmptyState(visibleCount);
        }

        function resetSearch() {
            document.getElementById("searchInput").value = "";
            searchTable();
        }

        function toggleEmptyState(visibleCount) {
            const emptyMsg = document.querySelector(".empty-state");
            const tableContainer = document.querySelector(".table-container");

            if (visibleCount === 0) {
                emptyMsg.style.display = "block";
                tableContainer.style.display = "none";
            } else {
                emptyMsg.style.display = "none";
                tableContainer.style.display = "block";
            }
        }

        function disablePastDateTime() {
            const now = new Date();

            // Add 15 mins
            now.setMinutes(now.getMinutes() + 15);

            now.setMinutes(now.getMinutes() - now.getTimezoneOffset());

            const minValue = now.toISOString().slice(0, 16);

            document.querySelectorAll('input[type="datetime-local"]').forEach(dt => {
                dt.min = minValue;
            });
        }

        window.onload = function() {
            initAppointmentSorting();
            disablePastDateTime();
        };
    </script>
</head>

<body>
    <div class="container">

        <%@ include file="header.jsp" %>

        <div class="bar-container">
            <a href="dashboard" class="sub-title-logo" style="left: 0;"><img src="${pageContext.request.contextPath}/images/back.svg" alt="back-logo"></a>
            <p>Schedule Appointments</p>
            <a href="logout" class="sub-title-logo" style="right: 0;"><img src="${pageContext.request.contextPath}/images/logout.svg" alt="logout-logo"></a>
        </div>

        <!-- ALERTS -->
        <%
            String successMessage = (String) request.getAttribute("successMessage");
            String errorMessage = (String) request.getAttribute("errorMessage");
            if(successMessage != null){
        %>
            <div class="alert alert-success">
                <span><%= successMessage %></span>
                <span class="alert-close" onclick="this.parentElement.style.display='none'">&times;</span>
            </div>
        <% } %>

        <% if(errorMessage != null){ %>
            <div class="alert alert-error">
                <span><%= errorMessage %></span>
                <span class="alert-close" onclick="this.parentElement.style.display='none'">&times;</span>
            </div>
        <% } %>

        <!-- Search Box -->
        <form class="search-box">
            <input type="text" name="q" id="searchInput" class="search-input"
                    placeholder="Search appointments..." onkeyup="searchTable()"/>
            <button type="reset" class="search-reset" onclick="resetSearch()">X</button>
        </form>

        <!-- Appointment list -->
        <%
            List<Map<String,String>> appointments = 
                (List<Map<String,String>>) request.getAttribute("appointments");

            List<Map<String,String>> doctors = 
                (List<Map<String,String>>) request.getAttribute("doctors");

            boolean hasData = appointments != null && !appointments.isEmpty();
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
                                <span>Prefered Date</span>
                                <div class="sort-icons"><span class="up">▲</span><span class="down">▼</span></div>
                            </div>
                        </th>
                    
                        <th><div class="th-content"><span>Select Doctor</span></div></th>
                        <th><div class="th-content"><span>Select Time</span></div></th>
                        <th>Confirm</th>
                    </tr>
                </thead>

                <tbody>
                <% if (hasData) {
                    for (Map<String,String> row : appointments) { %>
                        <tr>

                            <!-- Plain sortable cells -->
                            <td><%= row.get("appointment_id") %></td>
                            <td><%= row.get("speciality_required") %></td>
                            <td><%= row.get("appointment_date") %></td>

                            <!-- These cells contain form controls -->
                            <td>
                                <form action="scheduleAppointment" method="post">
                                    <input type="hidden" name="appointment_id"
                                           value="<%= row.get("appointment_id") %>">

                                    <select name="doctor_id" required>
                                        <option value="" class="form-select">Select doctor</option>
                                        <% for (Map<String,String> d : doctors) { %>
                                            <option value="<%= d.get("doctor_id") %>">
                                                <%= d.get("full_name") %> — <%= d.get("speciality") %>
                                            </option>
                                        <% } %>
                                    </select>
                            </td>

                            <td>
                                    <input type="datetime-local" name="scheduled_time" class="form-row" required>
                            </td>

                            <td>
                                    <button class="con">Confirm</button>
                                </form>
                            </td>

                        </tr>

                <%  } } %>
                </tbody>
            </table>
        </div>

        <!-- EMPTY -->
        <div class="empty-state" <%= hasData ? "style='display:none;'" : "" %>>
            <p style="font-size:18px;">No waiting appointments</p>
        </div>

        <%@ include file="footer.jsp" %>
    </div>
</body>
</html>