<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pharmacy.model.User" %>
<%
    String activeMenu = request.getParameter("active");
    User currentUser = (User) session.getAttribute("user");
    String userRole = currentUser != null ? currentUser.getRole().toLowerCase() : "";
%>

<div class="sidebar">
    <div class="sidebar-header">
        <i class="fas fa-capsules sidebar-logo"></i>
        <h4 class="mb-0">PharmaCare</h4>
    </div>

    <div class="user-profile">
        <div class="avatar">
            <%= currentUser != null ? currentUser.getFullName().substring(0, 1).toUpperCase() : "U" %>
        </div>
        <div class="user-info">
            <div class="user-name"><%= currentUser != null ? currentUser.getFullName() : "User" %></div>
            <div class="user-role">
        <span class="badge <%=
          userRole.equals("admin") ? "bg-danger" :
          userRole.equals("pharmacist") ? "bg-primary" :
          "bg-success" %>">
          <%= currentUser != null ? currentUser.getRole().toUpperCase() : "GUEST" %>
        </span>
            </div>
        </div>
    </div>

    <nav class="sidebar-nav">
        <ul class="nav-list">
            <!-- Dashboard - All Roles -->
            <li class="nav-item <%= "dashboard".equals(activeMenu) ? "active" : "" %>">
                <a href="dashboard" class="nav-link">
                    <i class="fas fa-home"></i>
                    <span>Dashboard</span>
                </a>
            </li>

            <!-- Sales - Admin & Cashier Only -->
            <% if (userRole.equals("admin") || userRole.equals("cashier")) { %>
            <li class="nav-item <%= "sales".equals(activeMenu) ? "active" : "" %>">
                <a href="sales" class="nav-link">
                    <i class="fas fa-shopping-cart"></i>
                    <span>Sales</span>
                </a>
            </li>
            <% } %>

            <!-- Purchases - Admin & Pharmacist Only -->
            <% if (userRole.equals("admin") || userRole.equals("pharmacist")) { %>
            <li class="nav-item <%= "purchases".equals(activeMenu) ? "active" : "" %>">
                <a href="purchases" class="nav-link">
                    <i class="fas fa-shopping-basket"></i>
                    <span>Purchases</span>
                </a>
            </li>
            <% } %>

            <!-- Medicines - Admin & Pharmacist Only -->
            <% if (userRole.equals("admin") || userRole.equals("pharmacist")) { %>
            <li class="nav-item <%= "medicines".equals(activeMenu) ? "active" : "" %>">
                <a href="medicines" class="nav-link">
                    <i class="fas fa-pills"></i>
                    <span>Medicines</span>
                </a>
            </li>
            <% } %>
            <!-- Stock List - All Roles -->
            <li class="nav-item <%= "stock-list".equals(activeMenu) ? "active" : "" %>">
                <a href="stock-list" class="nav-link">
                    <i class="fas fa-warehouse"></i>
                    <span>Stock List</span>
                    <% if (userRole.equals("cashier")) { %>
                    <span class="badge bg-secondary ms-auto" style="font-size: 9px;">View Only</span>
                    <% } %>
                </a>
            </li>

            <!-- Suppliers - Admin Only -->
            <% if (userRole.equals("admin")) { %>
            <li class="nav-item <%= "suppliers".equals(activeMenu) ? "active" : "" %>">
                <a href="suppliers" class="nav-link">
                    <i class="fas fa-truck"></i>
                    <span>Suppliers</span>
                </a>
            </li>
            <% } %>

            <!-- Users - Admin Only -->
            <% if (userRole.equals("admin")) { %>
            <li class="nav-item <%= "users".equals(activeMenu) ? "active" : "" %>">
                <a href="user" class="nav-link">
                    <i class="fas fa-users"></i>
                    <span>Users</span>
                </a>
            </li>
            <% } %>

            <!-- Reports - Admin & Pharmacist -->
            <% if (userRole.equals("admin") || userRole.equals("pharmacist")) { %>
            <li class="nav-item <%= "reports".equals(activeMenu) ? "active" : "" %>">
                <a href="reports" class="nav-link">
                    <i class="fas fa-chart-bar"></i>
                    <span>Reports</span>
                </a>
            </li>
            <% } %>
            <!-- Logout - All Roles -->
            <li class="nav-item">
                <a href="logout" class="nav-link text-danger">
                    <i class="fas fa-sign-out-alt"></i>
                    <span>Logout</span>
                </a>
            </li>
        </ul>
    </nav>

    <div class="sidebar-footer">
        <small class="text-muted">© 2024 PharmaCare</small>
    </div>
</div>

<style>
    .sidebar {
        width: 260px;
        height: 100vh;
        background: linear-gradient(180deg, #1e293b 0%, #0f172a 100%);
        position: fixed;
        left: 0;
        top: 0;
        overflow-y: auto;
        box-shadow: 2px 0 10px rgba(0,0,0,0.1);
        z-index: 1000;
    }

    .sidebar-header {
        padding: 25px 20px;
        text-align: center;
        background: rgba(255,255,255,0.05);
        border-bottom: 1px solid rgba(255,255,255,0.1);
    }

    .sidebar-logo {
        font-size: 40px;
        color: #3b82f6;
        margin-bottom: 10px;
    }

    .sidebar-header h4 {
        color: white;
        font-weight: 600;
    }

    .user-profile {
        padding: 20px;
        display: flex;
        align-items: center;
        gap: 15px;
        background: rgba(255,255,255,0.03);
        border-bottom: 1px solid rgba(255,255,255,0.1);
    }

    .avatar {
        width: 50px;
        height: 50px;
        border-radius: 50%;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-weight: 700;
        font-size: 20px;
    }

    .user-info {
        flex: 1;
    }

    .user-name {
        color: white;
        font-weight: 600;
        margin-bottom: 5px;
    }

    .user-role .badge {
        font-size: 10px;
        font-weight: 600;
        padding: 3px 8px;
    }

    .sidebar-nav {
        padding: 15px 0;
    }

    .nav-list {
        list-style: none;
        padding: 0;
        margin: 0;
    }

    .nav-item {
        margin: 5px 10px;
    }

    .nav-link {
        display: flex;
        align-items: center;
        padding: 12px 15px;
        color: rgba(255,255,255,0.7);
        text-decoration: none;
        border-radius: 10px;
        transition: all 0.3s ease;
        font-weight: 500;
    }

    .nav-link i {
        width: 24px;
        margin-right: 12px;
        font-size: 18px;
    }

    .nav-link:hover {
        background: rgba(255,255,255,0.1);
        color: white;
        transform: translateX(5px);
    }

    .nav-item.active .nav-link {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
    }

    .sidebar-footer {
        padding: 20px;
        text-align: center;
        border-top: 1px solid rgba(255,255,255,0.1);
        position: absolute;
        bottom: 0;
        width: 100%;
        background: rgba(0,0,0,0.2);
    }

    .sidebar-footer small {
        color: rgba(255,255,255,0.4);
    }

    /* Scrollbar Styling */
    .sidebar::-webkit-scrollbar {
        width: 6px;
    }

    .sidebar::-webkit-scrollbar-track {
        background: rgba(255,255,255,0.05);
    }

    .sidebar::-webkit-scrollbar-thumb {
        background: rgba(255,255,255,0.2);
        border-radius: 3px;
    }

    .sidebar::-webkit-scrollbar-thumb:hover {
        background: rgba(255,255,255,0.3);
    }
</style>