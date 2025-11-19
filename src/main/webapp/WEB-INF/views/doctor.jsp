<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0);

HttpSession sessionObj = request.getSession(false);
if (sessionObj == null || sessionObj.getAttribute("user_id") == null) {
    response.sendRedirect(request.getContextPath() + "/login");
    return;
}

String role = (String) sessionObj.getAttribute("role");
if (role == null || !"doctor".equalsIgnoreCase(role)) {
    response.sendError(403, "Access denied");
    return;
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>HealthDotNet - Doctor</title>
  <link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/images/favicon.svg">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/doc.css" />
</head>
<body>
  <div class="container">
    <%@ include file="header.jsp" %>
    <div class="dashboard-container">
    <main>
      <section class="welcome-section">
        <h1>Welcome, Dr. Amelia Scott</h1>
      </section>

      <section class="stats-overview">
        <div class="stat-item">
          <h2>320</h2>
          <p>Active Patients</p>
        </div>
        <div class="stat-item new-appointments">
          <h2>150</h2>
          <p>New Appointments</p>
          <div class="progress-bar-wrapper" aria-label="New Appointments progress">
            <div class="progress-bar new-app-progress" style="width: 100%;"></div>
          </div>
        </div>
        <div class="stat-item bed-occupancy">
          <p>Bed Occupancy</p>
          <div class="progress-bar-wrapper" aria-label="Bed Occupancy progress 75%">
            <div class="progress-bar bed-occupancy-progress" style="width: 75%;"></div>
          </div>
        </div>
        <div class="stat-item discharges">
          <h3>10</h3>
          <p>Discharges</p>
        </div>
        <div class="stat-item large-numbers">
          <div><strong>1,245</strong><span>Patients</span></div>
          <div><strong>78</strong><span>Doctors</span></div>
          <div><strong>203</strong><span>Treatments</span></div>
        </div>
      </section>

      <section class="main-content-grid">

        <article class="profile-card">
          <img src="https://randomuser.me/api/portraits/women/44.jpg" alt="Dr. Amelia Scott" />
          <div class="profile-info">
            <h2>Dr. Amelia Scott</h2>
            <p>Cardiologist</p>
          </div>
          <div class="medical-records">
            <div class="record-item">
              <div class="icon">🩺</div>
              <div>
                <h4>Patient Medical Summary</h4>
                <p>Total Records: 1,250 patients</p>
              </div>
            </div>
            <div class="record-item">
              <div class="icon">🩹</div>
              <div>
                <h4>Active Treatments</h4>
                <p>Patients Under Treatment: 120 patients</p>
              </div>
            </div>
            <div class="record-item">
              <div class="icon">🧪</div>
              <div>
                <h4>Recent Test Results</h4>
                <p>Updated Today</p>
              </div>
            </div>
          </div>
        </article>

        <article class="work-progress">
          <h3>Work Progress</h3>
          <p class="patient-count">12 <span>Patients Treated This Week</span></p>
          <div class="bar-graph">
            <div class="bar" style="height: 40px;"></div>
            <div class="bar" style="height: 35px;"></div>
            <div class="bar" style="height: 37px;"></div>
            <div class="bar" style="height: 37px;"></div>
            <div class="bar highlight" style="height: 50px;"></div>
            <div class="bar" style="height: 29px;"></div>
          </div>
          <div class="time-pill">3 PM - 6 PM</div>
        </article>

        <article class="work-tracker" aria-label="Work tracker timer">
          <button class="expand-btn" aria-label="Expand">&#x2197;</button>
          <svg width="140" height="140" viewBox="0 0 100 100" aria-hidden="true">
            <circle class="circle-bg" cx="50" cy="50" r="45" fill="none" />
            <circle class="circle-progress" cx="50" cy="50" r="45" fill="none" stroke-dasharray="283" stroke-dashoffset="80" />
          </svg>
          <span class="time">01:45</span>
          <span class="session-label">Active Session</span>
          <div class="controls">
            <button class="control-btn play" title="Play">&#9658;</button>
            <button class="control-btn pause" title="Pause">&#10073;&#10073;</button>
            <button class="control-btn reset" title="Reset">&#128337;</button>
          </div>
        </article>

        <article class="appointments-panel">
          <header class="appointments-header">
            <h3>Appointments</h3>
            <span>18%</span>
          </header>
          <nav class="appointment-filters" role="group" aria-label="Filter appointments">
            <button class="filter-btn upcoming active">Upcoming</button>
            <button class="filter-btn completed">Completed</button>
            <button class="filter-btn canceled">Canceled</button>
          </nav>

          <div class="appointment-task-list" aria-label="Appointment Task List 4 of 10">
            <h4>Appointment Task List 4/10</h4>
            <ul>
              <li>
                <span class="icon">💬</span> Check-Up
                <span class="patient">John Doe (9:00 AM)</span>
                <span class="checkbox"></span>
              </li>
              <li>
                <span class="icon">💬</span> Follow-up
                <span class="patient">Sarah Lee (10:30 AM)</span>
                <span class="checkbox"></span>
              </li>
              <li class="completed">
                <span class="icon">❤️‍🩹</span> ECG Test
                <span class="patient">Robert Smith (1:00 PM)</span>
                <span class="checkbox checked"></span>
              </li>
              <li>
                <span class="icon">💬</span> Surgery Consultation
                <span class="patient">Emily Brown (3:00 PM)</span>
                <span class="checkbox"></span>
              </li>
              <li>
                <span class="icon">💬</span> Check-Up
                <span class="patient">Ritha Doe (8:00 AM)</span>
                <span class="checkbox"></span>
              </li>
            </ul>
          </div>
        </article>

        <article class="calendar-schedule">
          <header class="calendar-header">
            <span class="primitive">September</span>
            <span class="month-year">October 2025</span>
            <span class="primitive">November</span>
          </header>
          <div class="calendar-weekdays">
            <span>Mon</span><span>Tue</span><span><strong>Wed</strong></span><span>Thu</span><span>Fri</span><span>Sat</span><span>Sun</span>
          </div>
          <div class="calendar-dates">
            <span>14</span>
            <span>15</span>
            <span class="active">16</span>
            <span>17</span>
            <span>18</span>
            <span>19</span>
            <span>20</span>
          </div>

          <div class="schedule-item surgery">
            <span class="icon">🔪</span>Surgery Schedule - Tomorrow 8:00 AM
          </div>
          <div class="schedule-item meeting">
            <svg class="icon-check" viewBox="0 0 24 24" aria-hidden="true"><path d="M9 12l2 2 4-4"/></svg>
            Doctor's Meeting - Monday 10:00 AM
          </div>
        </article>

      </section>
      </section>
    </main>

    <!-- Doctor actions: Prescribe, Reports, Assigned Patients -->
    <aside class="doctor-actions">
      <h3>Actions</h3>
      <button id="btn-prescribe" class="action-btn">Prescribe Medicine</button>
      <button id="btn-report" class="action-btn">Write Report</button>
      <button id="btn-patients" class="action-btn">View Assigned Patients</button>

      <div id="assigned-patients" class="panel hidden">
        <h4>Assigned Patients</h4>
        <table class="patients-table">
          <thead><tr><th>Patient</th><th>Age</th><th>Appointment</th><th>Action</th></tr></thead>
          <tbody>
            <tr><td>John Doe</td><td>45</td><td>2025-11-15 09:00</td><td><a href="#">Open</a></td></tr>
            <tr><td>Sarah Lee</td><td>36</td><td>2025-11-15 10:30</td><td><a href="#">Open</a></td></tr>
          </tbody>
        </table>
      </div>

      <!-- lightweight modals for prescribe/report (non-functional placeholder) -->
      <div id="modal-prescribe" class="modal hidden" role="dialog" aria-hidden="true">
        <form class="modal-form" method="post" action="${pageContext.request.contextPath}/doctor/prescribe">
          <h4>Prescribe Medicine</h4>
          <label>Patient Username<input name="patient" required></label>
          <label>Medicine<input name="medicine" required></label>
          <label>Dosage<input name="dosage"></label>
          <button type="submit" class="btn">Send</button>
          <button type="button" class="btn" onclick="document.getElementById('modal-prescribe').classList.add('hidden')">Close</button>
        </form>
      </div>

      <div id="modal-report" class="modal hidden" role="dialog" aria-hidden="true">
        <form class="modal-form" method="post" action="${pageContext.request.contextPath}/doctor/report">
          <h4>Write Report</h4>
          <label>Patient Username<input name="patient" required></label>
          <label>Report<textarea name="report" required></textarea></label>
          <button type="submit" class="btn">Save</button>
          <button type="button" class="btn" onclick="document.getElementById('modal-report').classList.add('hidden')">Close</button>
        </form>
      </div>

    </aside>

    <%@ include file="footer.jsp" %>
  </div>

  <script>
    document.getElementById('btn-prescribe').addEventListener('click', function(){
      document.getElementById('modal-prescribe').classList.remove('hidden');
    });
    document.getElementById('btn-report').addEventListener('click', function(){
      document.getElementById('modal-report').classList.remove('hidden');
    });
    document.getElementById('btn-patients').addEventListener('click', function(){
      document.getElementById('assigned-patients').classList.toggle('hidden');
    });
  </script>
</body>
</html>
