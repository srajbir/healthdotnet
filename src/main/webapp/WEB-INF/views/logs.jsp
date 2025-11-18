<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, java.util.Map" %>
<%
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0);

HttpSession sessionObj = request.getSession(false);
String SessionRole = (String) sessionObj.getAttribute("role");

if (sessionObj == null || sessionObj.getAttribute("user_id") == null || SessionRole == null || !SessionRole.equalsIgnoreCase("admin")) {
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
            max-width: 800px;
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
        .search-reset,
        .search-submit {
            padding: 10px 16px;
            border: none;
            cursor: pointer;
            font-weight: 600;
            transition: background 0.3s ease, transform 0.1s ease;
        }
        .search-submit {
            background: #00796b;
            color: white;
            border-radius: 0 5px 5px 0;
        }
        .search-reset {
            background: #e0f2f1;
            color: #00796b;
            text-decoration: none;
        }
        
        .search-submit:hover { background: #004d40; }
        .search-reset:hover { background: #b2dfdb; }

        .search-reset:active,
        .search-submit:active {
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

        /* Badges for roles */
        .badge {
            padding: 4px 10px;
            border-radius: 10px;
            font-size: 12px;
            font-weight: bold;
        }
        .badge-admin { background: #e0f2f1; color: #00695c; }
        .badge-doctor { background: #b2ebf2; color: #006064; }
        .badge-patient { background: #c8e6c9; color: #2e7d32; }
        .badge-receptionist { background: #fff9c4; color: #f57f17; }

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
                padding: 8px;
                font-size: 13px;
            }
            .search-submit {
                border-radius: 0 0 5px 5px;
            }

            .search-reset {
                padding: 5px 8px;
            }
        
            td {
                font-size: 11px;
            }
        
            .badge {
                font-size: 9px;
                padding: 3px 6px;
            }
        }

    </style>
</head>

<body>
<div class="container">

    <%@ include file="header.jsp" %>

    <div class="bar-container">
        <a href="dashboard" class="sub-title-logo" style="left: 0;"><img src="${pageContext.request.contextPath}/images/back.svg" alt="back logo"></a>
        <p><strong>System Logs</strong></p>
        <a href="logout" class="sub-title-logo" style="right: 0;"><img src="${pageContext.request.contextPath}/images/logout.svg" alt="logout logo"></a>
    </div>

    <!-- Search Bar -->
    <form method="get" action="logs" class="search-box">
        <input class="search-input" type="text" name="search" placeholder="Search logs..."
               value="<%= request.getParameter("search") == null ? "" : request.getParameter("search") %>">
        <a href="logs" class="search-reset">X</a>
        <button type="submit" class="search-submit">Search</button>
    </form>

    <div class="table-container">
    <table id="logsTable">
        <thead>
        <tr>
            <!-- LOG ID -->
            <th class="sortable" data-column="log_id">
                <div class="th-content">
                    <span>Log ID</span>
                    <div class="sort-icons"><span class="up">▲</span><span class="down">▼</span></div>
                </div>
            </th>

            <!-- USER ID -->
            <th class="sortable" data-column="user_id">
                <div class="th-content">
                    <span>User ID</span>
                    <div class="sort-icons"><span class="up">▲</span><span class="down">▼</span></div>
                </div>
            </th>

            <!-- ROLE -->
            <th class="sortable" data-column="role">
                <div class="th-content">
                    <span>Role</span>
                    <div class="sort-icons"><span class="up">▲</span><span class="down">▼</span></div>
                </div>
            </th>

            <!-- USERNAME -->
            <th class="sortable" data-column="username">
                <div class="th-content">
                    <span>Username</span>
                    <div class="sort-icons"><span class="up">▲</span><span class="down">▼</span></div>
                </div>
            </th>

            <!-- ACTION -->
            <th class="sortable" data-column="action">
                <div class="th-content">
                    <span>Action</span>
                    <div class="sort-icons"><span class="up">▲</span><span class="down">▼</span></div>
                </div>
            </th>

            <!-- TIMESTAMP -->
            <th class="sortable" data-column="log_time">
                <div class="th-content">
                    <span>Timestamp</span>
                    <div class="sort-icons"><span class="up">▲</span><span class="down">▼</span></div>
                </div>
            </th>
        </tr>
        </thead>

        <tbody>
        <%
            List<Map<String,Object>> logs =
                (List<Map<String,Object>>) request.getAttribute("logs");

            if (logs != null) {
                for (Map<String,Object> row : logs) {
        %>
        <tr>
            <td><%= row.get("log_id") %></td>
            <td><%= row.get("user_id") %></td>

            <td>
                <span class="badge badge-<%= row.get("role") %>">
                    <%= row.get("role") %>
                </span>
            </td>

            <td><%= row.get("username") %></td>
            <td><%= row.get("action") %></td>
            <td><%= row.get("log_time") %></td>
        </tr>
        <%
                }
            }
        %>
        </tbody>
    </table>
    </div>

    <%@ include file="footer.jsp" %>
</div>

<!-- Sorting Script -->
<script>
    const table = document.getElementById("logsTable");
    const headers = table.querySelectorAll("th.sortable");
    let sortState = { column: null, direction: 'asc' };

    headers.forEach((header, index) => {
        header.addEventListener("click", () => {
            const columnIndex = index;

            // Flip sort direction
            if (sortState.column === columnIndex) {
                sortState.direction = sortState.direction === 'asc' ? 'desc' : 'asc';
            } else {
                sortState.column = columnIndex;
                sortState.direction = 'asc';
            }

            // Remove all highlights
            headers.forEach(h => h.classList.remove("sort-asc", "sort-desc"));

            // Apply highlight
            header.classList.add(sortState.direction === 'asc' ? "sort-asc" : "sort-desc");

            const rows = Array.from(table.querySelectorAll("tbody tr"));

            rows.sort((a, b) => {
                let x = a.children[columnIndex].innerText.trim();
                let y = b.children[columnIndex].innerText.trim();

                // Numeric sorting
                if (!isNaN(x) && !isNaN(y)) {
                    return sortState.direction === 'asc' ? x - y : y - x;
                }

                // Date sorting
                if (Date.parse(x) && Date.parse(y)) {
                    return sortState.direction === 'asc'
                        ? new Date(x) - new Date(y)
                        : new Date(y) - new Date(x);
                }

                // Text sorting
                return sortState.direction === 'asc'
                    ? x.localeCompare(y)
                    : y.localeCompare(x);
            });

            const tbody = table.querySelector("tbody");
            rows.forEach(r => tbody.appendChild(r));
        });
    });
</script>

</body>
</html>
