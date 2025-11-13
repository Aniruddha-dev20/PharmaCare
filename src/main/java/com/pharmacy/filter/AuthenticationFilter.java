package com.pharmacy.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * AuthenticationFilter - Protects pages that require login
 * Checks if user is logged in before allowing access
 */
@WebFilter(filterName = "AuthenticationFilter", urlPatterns = {
        "/dashboard", "/dashboard/*",
        "/medicines", "/medicines/*",
        "/suppliers", "/suppliers/*",
        "/customers", "/customers/*",
        "/sales", "/sales/*",
        "/purchases", "/purchases/*",
        "/stock-list", "/stock-list/*",
        "/reports", "/reports/*"
})
public class AuthenticationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        System.out.println("âœ“ AuthenticationFilter initialized");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        String loginURI = httpRequest.getContextPath() + "/login";

        boolean loggedIn = (session != null && session.getAttribute("user") != null);
        boolean loginRequest = httpRequest.getRequestURI().equals(loginURI);

        if (loggedIn || loginRequest) {
            // User is logged in or requesting login page, allow access
            chain.doFilter(request, response);
        } else {
            // User is not logged in, redirect to login page
            System.out.println("âœ— Unauthorized access attempt to: " + httpRequest.getRequestURI());
            httpResponse.sendRedirect(loginURI);
        }
    }

    @Override
    public void destroy() {
        System.out.println("âœ“ AuthenticationFilter destroyed");
    }
}