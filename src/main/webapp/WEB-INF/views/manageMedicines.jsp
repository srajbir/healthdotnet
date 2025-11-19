<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0);

// SAFE session check (avoid NPE)
HttpSession sessionObj = request.getSession(false);
if (sessionObj == null || sessionObj.getAttribute("user_id") == null || sessionObj.getAttribute("role") == null) {
    response.sendRedirect(request.getContextPath() + "/login");
    return;
}
String SessionRole = (String) sessionObj.getAttribute("role");
if (!"admin".equalsIgnoreCase(SessionRole)) {
    response.sendRedirect(request.getContextPath() + "/login");
    return;
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>HealthDotNet</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script defer src="${pageContext.request.contextPath}/js/main.js"></script>

    <style>
        .container {
            width: 100%;
            max-width: 700px;
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
            .search-submit {
                border-radius: 0 0 5px 5px;
            }

            .search-reset {
                padding: 5px 8px;
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
    </style>
</head>
<body>
    <div class="container">
        <%@ include file="header.jsp" %>

        <div class="bar-container">
            <a href="dashboard" class="sub-title-logo" style="left: 0;"><img src="${pageContext.request.contextPath}/images/back.svg" alt="back-logo"></a>
            <p>Manage Medicines</p>
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
            <%
                String showPanel = (String) request.getAttribute("showPanel");
                if (showPanel == null) showPanel = "view";
            %>
            <button class="tab-btn <%= "view".equals(showPanel) ? "active" : "" %>" onclick="switchTab('view', event)">Medicine List</button>
            <button class="tab-btn <%= "add".equals(showPanel) ? "active" : "" %>" onclick="switchTab('add', event)">Add Medicine</button>
            <button class="tab-btn <%= "edit".equals(showPanel) ? "active" : "" %>" onclick="switchTab('edit', event)" <%= request.getAttribute("editMedicine") == null ? "disabled" : "" %>>Edit Medicine</button>
        </div>

        <!-- VIEW TAB -->
        <div id="view" class="tab-content <%= "view".equals(showPanel) ? "active" : "" %>">
            <form method="GET" action="${pageContext.request.contextPath}/manageMedicines" class="search-box">
                <input type="text" name="q" class="search-input" placeholder="Search by name, description, or price..." value="<%= request.getAttribute("q") != null ? request.getAttribute("q") : "" %>" />
                <a class="search-reset" href="${pageContext.request.contextPath}/manageMedicines">X</a>
                <button type="submit" class="search-submit">Search</button>
            </form>

            <%
                List<Map<String, Object>> medicines = (List<Map<String, Object>>) request.getAttribute("medicines");
                if (medicines != null && !medicines.isEmpty()) {
            %>

            <div class="table-container">
                <table id="medicinesTable" aria-describedby="medicine-list">
                    <thead>
                        <tr>
                            <th class="sortable" data-column="medicine_id"><div class="th-content"><span>ID</span><div class="sort-icons"><span class="up">▲</span><span class="down">▼</span></div></div></th>
                            <th class="sortable" data-column="name"><div class="th-content"><span>Name</span><div class="sort-icons"><span class="up">▲</span><span class="down">▼</span></div></div></th>
                            <th class="sortable" data-column="description"><div class="th-content"><span>Description</span><div class="sort-icons"><span class="up">▲</span><span class="down">▼</span></div></div></th>
                            <th class="sortable" data-column="price"><div class="th-content"><span>Price</span><div class="sort-icons"><span class="up">▲</span><span class="down">▼</span></div></div></th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            for (Map<String, Object> med : medicines) {
                                int medId = med.get("medicine_id") instanceof Integer ? (Integer) med.get("medicine_id") : ((Number) med.get("medicine_id")).intValue();
                                String medName = med.get("name") != null ? med.get("name").toString() : "";
                                Object priceObj = med.get("price");
                                String priceStr = priceObj != null ? priceObj.toString() : "";
                        %>
                        <tr>
                            <td><%= medId %></td>
                            <td><%= medName %></td>
                            <td><%= med.get("description") != null ? med.get("description") : "-" %></td>
                            <td>₹ <%= priceStr %></td>
                            <td class="table-button">
                                <!-- Edit: send action=edit&id=... (servlet expects id param for edit view) -->
                                <a class="edit" href="?action=edit&id=<%= medId %>">Edit</a>

                                <!-- Delete: Option B - JS modal triggered -->
                                <button type="button" class="delete delete-btn" data-id="<%= medId %>" data-name="<%= medName.replace("\"","&quot;") %>">Delete</button>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>

            <% } else { %>
                <div class="empty-state">
                    <p style="font-size:18px; margin:0 0 8px 0;">No medicines found</p>
                    <p style="margin:0; color:#bbb;">Use "Add Medicine" to create one.</p>
                </div>
            <% } %>
        </div>

        <!-- ADD TAB -->
        <div id="add" class="tab-content <%= "add".equals(showPanel) ? "active" : "" %>">
            <form method="POST" action="${pageContext.request.contextPath}/manageMedicines">
                <input type="hidden" name="action" value="add" />
                <div class="form-row">
                    <div class="form-group <%= request.getAttribute("nameError") != null ? "error" : "" %>">
                        <label for="medicineNameAdd" class="required">Medicine Name</label>
                        <input type="text" id="medicineNameAdd" name="name" value="<%= request.getAttribute("name") != null ? request.getAttribute("name") : "" %>" placeholder="Paracetamol 500mg" />
                        <% if (request.getAttribute("nameError") != null) { %>
                            <span class="error-text"><%= request.getAttribute("nameError") %></span>
                        <% } %>
                    </div>

                    <div class="form-group <%= request.getAttribute("priceError") != null ? "error" : "" %>">
                        <label for="medicinePriceAdd"  class="required">Price</label>
                        <input type="text" id="medicinePriceAdd" name="price" value="<%= request.getAttribute("price") != null ? request.getAttribute("price") : "" %>" placeholder="50.00" />
                        <% if (request.getAttribute("priceError") != null) { %>
                            <span class="error-text"><%= request.getAttribute("priceError") %></span>
                        <% } %>
                    </div>

                    <div class="form-group <%= request.getAttribute("descriptionError") != null ? "error" : "" %>">
                        <label for="medicineDescriptionAdd"  class="required">Description</label>
                        <input type="text" id="medicineDescriptionAdd" name="description" placeholder="Details..." value="<%= request.getAttribute("description") != null ? request.getAttribute("description") : "" %>" />
                        <% if (request.getAttribute("descriptionError") != null) { %>
                            <span class="error-text"><%= request.getAttribute("descriptionError") %></span>
                        <% } %>
                    </div>

                </div>

                <div style="display:flex; gap:10px;">
                    <button type="submit" class="btn btn-primary">Add Medicine</button>
                    <button type="reset" class="btn btn-secondary">Clear</button>
                </div>
            </form>
        </div>

        <!-- EDIT TAB -->
        <div id="edit" class="tab-content <%= "edit".equals(showPanel) ? "active" : "" %>">
            <%
                Map<String,Object> editMedicine = (Map<String,Object>) request.getAttribute("editMedicine");
                if (editMedicine != null) {
                    Object mid = editMedicine.get("medicine_id");
            %>
            <form method="POST" action="${pageContext.request.contextPath}/manageMedicines" novalidate>
                <input type="hidden" name="action" value="update" />
                <input type="hidden" name="medicine_id" value="<%= mid != null ? mid.toString() : "" %>" />

                <div class="form-row">
                    <div class="form-group <%= request.getAttribute("nameError") != null ? "error" : "" %>">
                        <label for="medicineNameEdit">Medicine Name <span style="color:var(--danger)">*</span></label>
                        <input type="text" id="medicineNameEdit" name="name" value="<%= editMedicine.get("name") != null ? editMedicine.get("name") : "" %>" placeholder="Paracetamol 500mg" />
                        <% if (request.getAttribute("nameError") != null) { %>
                            <span class="error-text"><%= request.getAttribute("nameError") %></span>
                        <% } %>
                    </div>

                    <div class="form-group <%= request.getAttribute("priceError") != null ? "error" : "" %>">
                        <label for="medicinePriceEdit">Price (₹) <span style="color:var(--danger)">*</span></label>
                        <input type="text" id="medicinePriceEdit" name="price" value="<%= editMedicine.get("price") != null ? editMedicine.get("price") : "" %>" placeholder="50.00" />
                        <% if (request.getAttribute("priceError") != null) { %>
                            <span class="error-text"><%= request.getAttribute("priceError") %></span>
                        <% } %>
                    </div>

                    <div class="form-group <%= request.getAttribute("descriptionError") != null ? "error" : "" %>">
                        <label for="medicineDescriptionEdit">Description <span style="color:var(--danger)">*</span></label>
                        <input type="text" id="medicineDescriptionEdit" name="description" rows="3" placeholder="Details..." value="<%= editMedicine.get("description") != null ? editMedicine.get("description") : "" %>" />
                        <% if (request.getAttribute("descriptionError") != null) { %>
                            <span class="error-text"><%= request.getAttribute("descriptionError") %></span>
                        <% } %>
                    </div>

                </div>

                <div style="display:flex; gap:10px;">
                    <button type="submit" class="btn btn-primary">Update Medicine</button>
                    <a href="${pageContext.request.contextPath}/manageMedicines" class="btn btn-secondary">Cancel</a>
                </div>
            </form>
            <% } else { %>
                <div class="empty-state"><p>No medicine selected for editing.</p></div>
            <% } %>
        </div>

        <%@ include file="footer.jsp" %>
    </div>

    <!-- Delete Modal (Option B) -->
    <div id="deleteModal" class="modal" role="dialog" aria-modal="true" aria-hidden="true">
        <div class="modal-content" role="document">
            <div class="modal-header">Confirm Delete</div>
            <div class="modal-body">
                Are you sure you want to delete medicine: <strong id="deleteMedicineName">-</strong>?
            </div>
            <div class="modal-footer">
                <button class="btn btn-secondary" type="button" onclick="closeDeleteModal()">Cancel</button>
                <button class="btn btn-danger" type="button" id="confirmDeleteBtn" onclick="performDelete()">Delete</button>
            </div>
        </div>
    </div>

    <script>
        // --- Initialization ---
        document.addEventListener("DOMContentLoaded", () => {
            initDeleteButtons();
            initTabsFromServer();
            initMedicineFormValidation();
            initSorting();
            registerEscapeKey();
        });

        // -----------------------------
        // DELETE (Option B) - Modal
        // -----------------------------
        let deleteMedicineId = null;

        function initDeleteButtons() {
            document.querySelectorAll("button.delete").forEach(btn => {
                btn.addEventListener("click", (ev) => {
                    const id = btn.getAttribute("data-id");
                    const name = btn.getAttribute("data-name") || "this medicine";
                    confirmDelete(id, name);
                });
            });
        }

        function confirmDelete(id, name) {
            deleteMedicineId = id;
            document.getElementById("deleteMedicineName").textContent = name;
            const modal = document.getElementById("deleteModal");
            modal.classList.add("active");
            modal.setAttribute("aria-hidden", "false");
        }

        function closeDeleteModal() {
            const modal = document.getElementById("deleteModal");
            modal.classList.remove("active");
            modal.setAttribute("aria-hidden", "true");
            deleteMedicineId = null;
        }

        function performDelete() {
            if (!deleteMedicineId) return;

            // create POST form and submit (server expects action=delete & medicine_id)
            const form = document.createElement("form");
            form.method = "POST";
            form.action = "${pageContext.request.contextPath}/manageMedicines";

            const inputAction = document.createElement("input");
            inputAction.type = "hidden";
            inputAction.name = "action";
            inputAction.value = "delete";

            const inputId = document.createElement("input");
            inputId.type = "hidden";
            inputId.name = "medicine_id";
            inputId.value = deleteMedicineId;

            form.appendChild(inputAction);
            form.appendChild(inputId);

            // optionally add CSRF token input here if you use one

            document.body.appendChild(form);
            form.submit();
        }

        function registerEscapeKey() {
            document.addEventListener("keydown", (e) => {
                if (e.key === "Escape") closeDeleteModal();
            });
        }

        // -----------------------------
        // TABS
        // -----------------------------
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
                const mapping = { view:0, add:1, edit:2 };
                const idx = mapping[tabName] || 0;
                const btn = document.querySelectorAll(".tab-btn")[idx];
                if (btn) btn.classList.add("active");
            }
            // scroll to top of container for better UX on mobile
            window.scrollTo({ top: 0, behavior: 'smooth' });
        }

        function initTabsFromServer() {
            // 'showPanel' server var available in JSP as showPanel
            const showPanel = '<%= showPanel %>';
            if (!showPanel || showPanel === 'null') return;
            const tab = document.getElementById(showPanel);
            if (!tab) return;
            document.querySelectorAll(".tab-content").forEach(t => t.classList.remove("active"));
            document.querySelectorAll(".tab-btn").forEach(b => b.classList.remove("active"));

            tab.classList.add("active");
            const map = { view:0, add:1, edit:2 };
            const btn = document.querySelectorAll(".tab-btn")[ map[showPanel] || 0 ];
            if (btn) btn.classList.add("active");
        }

        // -----------------------------
        // FORM VALIDATION (client-side)
        // Only runs for add/update forms
        // -----------------------------
        function initMedicineFormValidation() {
            document.querySelectorAll("form").forEach(form => {
                form.addEventListener("submit", function(e) { validateMedicineForm(e, form); });
            });
        }

        function validateMedicineForm(e, form) {
            const actionField = form.querySelector('input[name="action"]');
            const action = actionField ? actionField.value : '';
            if (!["add", "update"].includes(action)) return; // do not validate delete or other forms

            // clear previous errors
            clearErrors(form);

            // form fields using names expected by servlet: name, description, price
            const name = form.querySelector('input[name="name"]');
            const description = form.querySelector('input[name="description"]');
            const price = form.querySelector('input[name="price"]');

            let errors = false;

            // NAME
            if (!name || !name.value.trim()) {
                showError(name, "Medicine name is required");
                errors = true;
            } else if (name.value.trim().length < 3) {
                showError(name, "Name must be at least 3 characters");
                errors = true;
            } else if (name.value.trim().length > 100) {
                showError(name, "Maximum 100 characters allowed");
                errors = true;
            }

            // PRICE (allow numbers with up to 2 decimals, optionally with ₹ or commas)
            if (!price || !price.value.trim()) {
                showError(price, "Price is required");
                errors = true;
            } else {
                let raw = price.value.trim().replace(/[₹,\s]/g, '');
                // allow leading +/-
                if (!/^[+-]?\d+(\.\d{1,2})?$/.test(raw)) {
                    showError(price, "Enter valid price (max 2 decimals)");
                    errors = true;
                } else {
                    const num = parseFloat(raw);
                    if (!(num > 0)) {
                        showError(price, "Price must be greater than 0");
                        errors = true;
                    }
                    if (num > 999999.99) {
                        showError(price, "Price exceeds maximum allowed amount");
                        errors = true;
                    }
                }
            }

            // DESCRIPTION (optional but server requires >=10 chars)
            if (!description || description.value.trim().length < 10) {
                showError(description, "Description must be at least 10 characters");
                errors = true;
            } else if (description.value.trim().length > 1000) {
                showError(description, "Description too long");
                errors = true;
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
            // remove existing error-text first
            const existing = group.querySelector(".error-text");
            if (existing) existing.remove();
            group.appendChild(err);
            // focus first error field
            try { field.focus(); } catch(e) {}
        }

        function clearErrors(form) {
            (form || document).querySelectorAll(".form-group.error").forEach(g => {
                g.classList.remove("error");
                const et = g.querySelectorAll(".error-text");
                et.forEach(e => e.remove());
            });
        }

        // -----------------------------
        // TABLE SORTING
        // -----------------------------
        function initSorting() {
            const table = document.getElementById("medicinesTable");
            if (!table) return;
            const headers = table.querySelectorAll("th.sortable");
            const tbody = table.querySelector("tbody");
            if (!tbody) return;

            let currentSort = { column: null, direction: "asc" };

            headers.forEach((header, index) => {
                header.addEventListener("click", () => {
                    const col = header.getAttribute("data-column");
                    const rows = Array.from(tbody.querySelectorAll("tr"));

                    // toggle
                    currentSort.direction = (currentSort.column === col && currentSort.direction === "asc") ? "desc" : "asc";
                    currentSort.column = col;

                    headers.forEach(h => h.classList.remove("sort-asc", "sort-desc"));
                    header.classList.add(currentSort.direction === "asc" ? "sort-asc" : "sort-desc");

                    rows.sort((a,b) => {
                        const aCell = a.children[index].textContent.trim();
                        const bCell = b.children[index].textContent.trim();

                        // attempt numeric compare after stripping currency symbol and commas
                        const aClean = aCell.replace(/[₹,]/g,'').trim();
                        const bClean = bCell.replace(/[₹,]/g,'').trim();

                        if (!isNaN(aClean) && !isNaN(bClean) && aClean !== "" && bClean !== "") {
                            return currentSort.direction === "asc" ? parseFloat(aClean) - parseFloat(bClean) : parseFloat(bClean) - parseFloat(aClean);
                        }

                        return currentSort.direction === "asc" ? aCell.localeCompare(bCell) : bCell.localeCompare(aCell);
                    });

                    // re-append sorted rows
                    rows.forEach(r => tbody.appendChild(r));
                });
            });
        }

    </script>
</body>
</html>
