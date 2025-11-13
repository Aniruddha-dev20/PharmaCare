package com.pharmacy.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.*;

/**
 * RoleBasedAccessFilter - Comprehensive Role-Based Access Control
 *
 * ADMIN: Full access to everything
 * PHARMACIST: Medicine, Stock List, Purchase
 * CASHIER: Sales, Stock List (view only), Customers
 */
@WebFilter(filterName = "RoleBasedAccessFilter", urlPatterns = {"/*"})
public class RoleBasedAccessFilter implements Filter {

    private static final Map<String, List<String>> ROLE_PERMISSIONS = new HashMap<>();

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // ADMIN - Full system access
        ROLE_PERMISSIONS.put("admin", Arrays.asList(
                "/user", "/users.jsp", "/user-form.jsp",
                "/medicines", "/medicines.jsp", "/add-medicine.jsp", "/edit-medicine.jsp",
                "/stock-list", "/stock-list.jsp",
                "/suppliers", "/suppliers.jsp", "/add-supplier.jsp", "/edit-supplier.jsp",
                "/purchases", "/purchases.jsp", "/view-purchase.jsp",
                "/sales", "/sales.jsp", "/view-sale.jsp", "/print-invoice.jsp",
                "/customers", "/customers.jsp", "/add-customer.jsp", "/edit-customer.jsp",
                "/reports", "/reports.jsp",
                "/dashboard", "/dashboard.jsp"
        ));

        // PHARMACIST - Medicine, Stock, Supplier, Purchase
        ROLE_PERMISSIONS.put("pharmacist", Arrays.asList(
                "/medicines", "/medicines.jsp", "/add-medicine.jsp", "/edit-medicine.jsp",
                "/stock-list", "/stock-list.jsp",
                "/purchases", "/purchases.jsp", "/view-purchase.jsp",
                "/dashboard", "/dashboard.jsp"
        ));

        // CASHIER - Sales, Stock List (view only), Customers
        ROLE_PERMISSIONS.put("cashier", Arrays.asList(
                "/sales", "/sales.jsp", "/view-sale.jsp", "/print-invoice.jsp",
                "/stock-list", "/stock-list.jsp",
                "/customers", "/customers.jsp", "/add-customer.jsp", "/edit-customer.jsp",
                "/dashboard", "/dashboard.jsp"
        ));

        System.out.println("✓ Role-Based Access Filter initialized");
        System.out.println("  - Admin: Full access to all modules");
        System.out.println("  - Pharmacist: Medicine, Stock, Purchase");
        System.out.println("  - Cashier: Sales, Stock (view only), Customers");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        String path = requestURI.substring(contextPath.length());

        // Allow public resources
        if (isPublicResource(path, httpRequest)) {
            chain.doFilter(request, response);
            return;
        }

        // Check if user is logged in
        if (session == null || session.getAttribute("user") == null) {
            System.out.println("❌ Unauthorized access to: " + path);
            httpResponse.sendRedirect(contextPath + "/login.jsp");
            return;
        }

        String userRole = (String) session.getAttribute("role");
        String action = httpRequest.getParameter("action");

        // Check role-based access
        if (!hasAccess(userRole, path)) {
            System.out.println("❌ Access DENIED for role '" + userRole + "' to: " + path);
            session.setAttribute("accessError", "Access Denied! You don't have permission to access this page.");
            httpResponse.sendRedirect(contextPath + "/dashboard");
            return;
        }

        // SPECIAL RULE: Cashier - Stock List VIEW ONLY
        if ("cashier".equalsIgnoreCase(userRole) && isStockRelated(path)) {
            if (isModifyAction(action)) {
                System.out.println("❌ Cashier blocked from modifying stock");
                session.setAttribute("accessError", "Cashiers can only VIEW stock information. Contact a pharmacist to make changes.");
                httpResponse.sendRedirect(contextPath + "/dashboard");
                return;
            }
        }

        // SPECIAL RULE: Block pharmacist from sales
        if ("pharmacist".equalsIgnoreCase(userRole) && isSalesRelated(path)) {
            System.out.println("❌ Pharmacist blocked from sales");
            session.setAttribute("accessError", "Pharmacists cannot access sales module. Contact a cashier.");
            httpResponse.sendRedirect(contextPath + "/dashboard");
            return;
        }

        // SPECIAL RULE: Block cashier from medicine/supplier/purchase
        if ("cashier".equalsIgnoreCase(userRole)) {
            if (isMedicineRelated(path) || isSupplierRelated(path) || isPurchaseRelated(path)) {
                System.out.println("❌ Cashier blocked from: " + path);
                session.setAttribute("accessError", "Cashiers cannot access this module. Contact a pharmacist.");
                httpResponse.sendRedirect(contextPath + "/dashboard");
                return;
            }
        }

        // SPECIAL RULE: Only admin can access user management
        if (!("admin".equalsIgnoreCase(userRole)) && (path.contains("/user") && !path.equals("/user"))) {
            System.out.println("❌ Non-admin blocked from user management");
            session.setAttribute("accessError", "Only administrators can manage users.");
            httpResponse.sendRedirect(contextPath + "/dashboard");
            return;
        }

        System.out.println("✓ Access GRANTED for role '" + userRole + "' to: " + path);
        chain.doFilter(request, response);
    }

    private boolean isPublicResource(String path, HttpServletRequest request) {
        // Login/logout pages
        if (path.equals("/") || path.equals("/login") || path.equals("/login.jsp") ||
                path.equals("/index.jsp") || path.equals("/logout")) {
            return true;
        }

        // Static resources
        if (path.startsWith("/css/") || path.startsWith("/js/") ||
                path.startsWith("/images/") || path.startsWith("/resources/") ||
                path.startsWith("/assets/") || path.startsWith("/fonts/") ||
                path.endsWith(".css") || path.endsWith(".js") ||
                path.endsWith(".png") || path.endsWith(".jpg") ||
                path.endsWith(".jpeg") || path.endsWith(".gif") ||
                path.endsWith(".svg") || path.endsWith(".ico") ||
                path.endsWith(".woff") || path.endsWith(".woff2") || path.endsWith(".ttf")) {
            return true;
        }

        // Include files (header, footer, sidebar)
        if (path.startsWith("/includes/") || path.contains("header.jsp") ||
                path.contains("footer.jsp") || path.contains("sidebar.jsp")) {
            return true;
        }

        return false;
    }

    private boolean hasAccess(String role, String path) {
        if (role == null) return false;

        List<String> permissions = ROLE_PERMISSIONS.get(role.toLowerCase());
        if (permissions == null) return false;

        for (String permission : permissions) {
            if (path.contains(permission) || path.equals(permission)) {
                return true;
            }
        }

        return false;
    }

    private boolean isStockRelated(String path) {
        return path.contains("stock") || path.contains("Stock");
    }

    private boolean isSalesRelated(String path) {
        return path.contains("sale") || path.contains("Sale");
    }

    private boolean isMedicineRelated(String path) {
        return path.contains("medicine") || path.contains("Medicine");
    }

    private boolean isSupplierRelated(String path) {
        return path.contains("supplier") || path.contains("Supplier");
    }

    private boolean isPurchaseRelated(String path) {
        return path.contains("purchase") || path.contains("Purchase");
    }

    private boolean isModifyAction(String action) {
        if (action == null) return false;

        String actionLower = action.toLowerCase();
        return actionLower.equals("add") ||
                actionLower.equals("edit") ||
                actionLower.equals("update") ||
                actionLower.equals("delete") ||
                actionLower.equals("save") ||
                actionLower.equals("remove");
    }

    @Override
    public void destroy() {
        System.out.println("Role-Based Access Filter destroyed");
    }
}