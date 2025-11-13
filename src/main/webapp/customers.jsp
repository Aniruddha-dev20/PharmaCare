<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pharmacy.model.Customer" %>
<%@ page import="java.util.List" %>

<%
    List<Customer> customers = (List<Customer>) request.getAttribute("customers");
%>

<jsp:include page="includes/header.jsp">
    <jsp:param name="title" value="Customers" />
</jsp:include>

<jsp:include page="includes/sidebar.jsp">
    <jsp:param name="active" value="customers" />
</jsp:include>

<div class="content-area">
    <!-- Page Header -->
    <div class="page-header d-flex justify-content-between align-items-center">
        <div>
            <h1 class="page-title">Customers</h1>
            <p class="page-subtitle">Manage customer information</p>
        </div>
        <a href="customers?action=add" class="btn btn-primary">
            <i class="fas fa-plus me-2"></i>Add Customer
        </a>
    </div>

    <!-- Success/Error Messages -->
    <% if (request.getParameter("success") != null) { %>
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        <i class="fas fa-check-circle me-2"></i>
        <% if ("added".equals(request.getParameter("success"))) { %>
        Customer added successfully!
        <% } else if ("updated".equals(request.getParameter("success"))) { %>
        Customer updated successfully!
        <% } else if ("deleted".equals(request.getParameter("success"))) { %>
        Customer deleted successfully!
        <% } %>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <% } %>

    <!-- Customers Table -->
    <div class="card">
        <div class="card-header">
            <h5 class="mb-0">
                <i class="fas fa-list me-2"></i>Customer List
                <span class="badge bg-primary ms-2"><%= customers != null ? customers.size() : 0 %></span>
            </h5>
        </div>
        <div class="card-body">
            <% if (customers != null && !customers.isEmpty()) { %>
            <div class="table-responsive">
                <table class="table table-hover align-middle">
                    <thead class="table-light">
                    <tr>
                        <th>ID</th>
                        <th>Customer Name</th>
                        <th>Phone</th>
                        <th>Email</th>
                        <th>City</th>
                        <th>Date of Birth</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% for (Customer customer : customers) { %>
                    <tr>
                        <td><strong><%= customer.getCustomerId() %></strong></td>
                        <td><strong><%= customer.getCustomerName() %></strong></td>
                        <td><%= customer.getPhone() %></td>
                        <td><%= customer.getEmail() != null ? customer.getEmail() : "-" %></td>
                        <td><%= customer.getCity() != null ? customer.getCity() : "-" %></td>
                        <td><%= customer.getDateOfBirth() != null ? customer.getDateOfBirth() : "-" %></td>
                        <td>
                            <div class="btn-group" role="group">
                                <a href="customers?action=edit&id=<%= customer.getCustomerId() %>"
                                   class="btn btn-sm btn-outline-primary"
                                   title="Edit">
                                    <i class="fas fa-edit"></i>
                                </a>
                                <a href="customers?action=delete&id=<%= customer.getCustomerId() %>"
                                   class="btn btn-sm btn-outline-danger"
                                   onclick="return confirmDelete('Are you sure you want to delete this customer?')"
                                   title="Delete">
                                    <i class="fas fa-trash"></i>
                                </a>
                            </div>
                        </td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
            <% } else { %>
            <div class="text-center py-5">
                <i class="fas fa-users fa-3x text-muted mb-3"></i>
                <p class="text-muted">No customers found.</p>
                <a href="customers?action=add" class="btn btn-primary">
                    <i class="fas fa-plus me-2"></i>Add First Customer
                </a>
            </div>
            <% } %>
        </div>
    </div>
</div>

<style>
    .card {
        border: none;
        border-radius: 15px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.05);
    }

    .card-header {
        background: white;
        border-bottom: 1px solid #dee2e6;
        padding: 20px;
        border-radius: 15px 15px 0 0;
    }
</style>

<jsp:include page="includes/footer.jsp" />