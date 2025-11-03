package com.healthdotnet.servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class ForgotPasswordServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Forward to the forgot password page
        request.getRequestDispatcher("/WEB-INF/views/forgot.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String fullname = request.getParameter("fullname");
        String email = request.getParameter("email");
        String contact = request.getParameter("contact");
        String dateOfBirth = request.getParameter("dateOfBirth");

        // TODO: Implement password reset logic here
        // For now, just redirect back to login with a message
        HttpSession session = request.getSession();
        session.setAttribute("successMessage", "If the provided details match our records, a password reset link will be sent to your email.");
        response.sendRedirect("login");
    }
}