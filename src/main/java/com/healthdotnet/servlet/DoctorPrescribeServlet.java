package com.healthdotnet.servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/doctor/prescribe")
public class DoctorPrescribeServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        String role = (String) session.getAttribute("role");
        if (role == null || !"doctor".equalsIgnoreCase(role)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String patient = request.getParameter("patient");
        String medicine = request.getParameter("medicine");
        String dosage = request.getParameter("dosage");

        // TODO: save prescription to DB. For now, set a session message.
        session.setAttribute("successMessage", "Prescription sent for " + patient);
        response.sendRedirect(request.getContextPath() + "/doctor");
    }
}
