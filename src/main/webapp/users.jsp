<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pharmacy.model.User" %>
<%@ page import="java.util.List" %>
<%
    if (session.getAttribute("user") == null || !"admin".equalsIgnoreCase((String)session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<User> users = (List<User>) request.getAttribute("users");
%>

<jsp:include page="includes/header.jsp">
    <jsp:param name="title" value="User Management" />
</jsp:include>

<jsp:include page="includes/sidebar.jsp">
    <jsp:param name="active" value="users" />
</jsp:include>

<div class="content-area">
    <div class="page-header d-flex justify-content-between align-items-center">
        <div>
            <h1 class="page-title"><i class="fas fa-user-shield"></i> User Management</h1>
            <p class="page-subtitle">Manage system users and their roles</p>
        </div>
        <a href="user?action=add" class="btn btn-primary">
            <i class="fas fa-plus me-2"></i>Add New User
        </a>
    </div>

    <div class="card border-0 shadow-sm">
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-hover">
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>Username</th>
                        <th>Full Name</th>
                        <th>Email</th>
                        <th>Phone</th>
                        <th>Role</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% if (users != null && !users.isEmpty()) {
                        for (User user : users) { %>
                    <tr>
                        <td><%= user.getUserId() %></td>
                        <td><%= user.getUsername() %></td>
                        <td><%= user.getFullName() %></td>
                        <td><%= user.getEmail() %></td>
                        <td><%= user.getPhone() %></td>
                        <td>
                                <span class="badge bg-<%= user.isAdmin() ? "primary" : (user.isPharmacist() ? "success" : "warning") %>">
                                    <%= user.getRole().toUpperCase() %>
                                </span>
                        </td>
                        <td>
                                <span class="badge bg-<%= user.isActive() ? "success" : "secondary" %>">
                                    <%= user.getStatus().toUpperCase() %>
                                </span>
                        </td>
                        <td>
                            <a href="user?action=edit&id=<%= user.getUserId() %>" class="btn btn-sm btn-primary">
                                <i class="fas fa-edit"></i>
                            </a>
                            <a href="user?action=delete&id=<%= user.getUserId() %>"
                               class="btn btn-sm btn-danger"
                               onclick="return confirm('Are you sure?')">
                                <i class="fas fa-trash"></i>
                            </a>
                        </td>
                    </tr>
                    <% }
                    } else { %>
                    <tr>
                        <td colspan="8" class="text-center">No users found</td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<jsp:include page="includes/footer.jsp" />
