<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pharmacy.model.Supplier" %>
<%@ page import="java.util.List" %>

<%
    List<Supplier> suppliers = (List<Supplier>) request.getAttribute("suppliers");
%>

<jsp:include page="includes/header.jsp">
    <jsp:param name="title" value="Suppliers" />
</jsp:include>

<jsp:include page="includes/sidebar.jsp">
    <jsp:param name="active" value="suppliers" />
</jsp:include>

<div class="content-area">
    <!-- Page Header -->
    <div class="page-header d-flex justify-content-between align-items-center">
        <div>
            <h1 class="page-title">Suppliers</h1>
            <p class="page-subtitle">Manage your supplier information</p>
        </div>
        <a href="suppliers?action=add" class="btn btn-primary">
            <i class="fas fa-plus me-2"></i>Add Supplier
        </a>
    </div>

    <!-- Success/Error Messages -->
    <% if (request.getParameter("success") != null) { %>
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        <i class="fas fa-check-circle me-2"></i>
        <% if ("added".equals(request.getParameter("success"))) { %>
        Supplier added successfully!
        <% } else if ("updated".equals(request.getParameter("success"))) { %>
        Supplier updated successfully!
        <% } else if ("deleted".equals(request.getParameter("success"))) { %>
        Supplier deleted successfully!
        <% } %>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <% } %>

    <!-- Suppliers Table -->
    <div class="card">
        <div class="card-header">
            <h5 class="mb-0">
                <i class="fas fa-list me-2"></i>Supplier List
                <span class="badge bg-primary ms-2"><%= suppliers != null ? suppliers.size() : 0 %></span>
            </h5>
        </div>
        <div class="card-body">
            <% if (suppliers != null && !suppliers.isEmpty()) { %>
            <div class="table-responsive">
                <table class="table table-hover align-middle">
                    <thead class="table-light">
                    <tr>
                        <th>ID</th>
                        <th>Supplier Name</th>
                        <th>Contact Person</th>
                        <th>Phone</th>
                        <th>Email</th>
                        <th>City</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% for (Supplier supplier : suppliers) { %>
                    <tr>
                        <td><strong><%= supplier.getSupplierId() %></strong></td>
                        <td><strong><%= supplier.getSupplierName() %></strong></td>
                        <td><%= supplier.getContactPerson() != null ? supplier.getContactPerson() : "-" %></td>
                        <td><%= supplier.getPhone() %></td>
                        <td><%= supplier.getEmail() != null ? supplier.getEmail() : "-" %></td>
                        <td><%= supplier.getCity() != null ? supplier.getCity() : "-" %></td>
                        <td>
                            <% if ("active".equals(supplier.getStatus())) { %>
                            <span class="badge bg-success">Active</span>
                            <% } else { %>
                            <span class="badge bg-secondary">Inactive</span>
                            <% } %>
                        </td>
                        <td>
                            <div class="btn-group" role="group">
                                <a href="suppliers?action=edit&id=<%= supplier.getSupplierId() %>"
                                   class="btn btn-sm btn-outline-primary"
                                   title="Edit">
                                    <i class="fas fa-edit"></i>
                                </a>
                                <a href="suppliers?action=delete&id=<%= supplier.getSupplierId() %>"
                                   class="btn btn-sm btn-outline-danger"
                                   onclick="return confirmDelete('Are you sure you want to delete this supplier?')"
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
                <i class="fas fa-truck fa-3x text-muted mb-3"></i>
                <p class="text-muted">No suppliers found.</p>
                <a href="suppliers?action=add" class="btn btn-primary">
                    <i class="fas fa-plus me-2"></i>Add First Supplier
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