package com.pharmacy.servlet;

import com.pharmacy.dao.UserDAO;
import com.pharmacy.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * LoginServlet - Handles user authentication
 * URL: /login
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        System.out.println("✓ LoginServlet initialized");
    }

    /**
     * GET method - Display login page
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if user is already logged in
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            response.sendRedirect("dashboard");
            return;
        }

        // Forward to login page
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    /**
     * POST method - Process login
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("===== LOGIN SERVLET CALLED =====");
        System.out.println("Method: " + request.getMethod());
        System.out.println("Context Path: " + request.getContextPath());
        System.out.println("Servlet Path: " + request.getServletPath());

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        System.out.println("Username: " + username);
        System.out.println("Password: " + (password != null ? "***" : "null"));


        // Validate credentials
        User user = userDAO.validateUser(username.trim(), password);

        if (user != null) {
            // Login successful
            HttpSession session = request.getSession(true);
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("username", user.getUsername());
            session.setAttribute("fullName", user.getFullName());
            session.setAttribute("role", user.getRole());
            session.setMaxInactiveInterval(30 * 60); // 30 minutes

            System.out.println("✓ User logged in: " + username + " (" + user.getRole() + ")");

            // Redirect to dashboard
            response.sendRedirect("dashboard");

        } else {
            // Login failed
            request.setAttribute("error", "Invalid username or password");
            request.setAttribute("username", username); // Keep username in form
            request.getRequestDispatcher("login.jsp").forward(request, response);

            System.out.println("✗ Failed login attempt: " + username);
        }
    }
}