<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pharmacy.model.Medicine" %>
<%@ page import="java.util.List" %>

<%
    List<Medicine> medicines = (List<Medicine>) request.getAttribute("medicines");
    String searchTerm = (String) request.getAttribute("searchTerm");
%>

<jsp:include page="includes/header.jsp">
    <jsp:param name="title" value="Medicines" />
</jsp:include>

<jsp:include page="includes/sidebar.jsp">
    <jsp:param name="active" value="medicines" />
</jsp:include>

<div class="content-area">
    <!-- Page Header -->
    <div class="page-header d-flex justify-content-between align-items-center">
        <div>
            <h1 class="page-title">Medicines</h1>
            <p class="page-subtitle">Manage your medicine inventory</p>
        </div>
        <a href="medicines?action=add" class="btn btn-primary">
            <i class="fas fa-plus me-2"></i>Add Medicine
        </a>
    </div>

    <!-- Success/Error Messages -->
    <% if (request.getParameter("success") != null) { %>
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        <i class="fas fa-check-circle me-2"></i>
        <% if ("added".equals(request.getParameter("success"))) { %>
        Medicine added successfully!
        <% } else if ("updated".equals(request.getParameter("success"))) { %>
        Medicine updated successfully!
        <% } else if ("deleted".equals(request.getParameter("success"))) { %>
        Medicine deleted successfully!
        <% } %>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <% } %>

    <% if (request.getParameter("error") != null) { %>
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        <i class="fas fa-exclamation-circle me-2"></i>
        <%= request.getParameter("error") %>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <% } %>

    <!-- Search and Filter -->
    <div class="card mb-4">
        <div class="card-body">
            <form action="medicines" method="get" class="row g-3">
                <input type="hidden" name="action" value="search">
                <div class="col-md-8">
                    <div class="input-group">
                        <span class="input-group-text"><i class="fas fa-search"></i></span>
                        <input type="text"
                               class="form-control"
                               name="search"
                               placeholder="Search by medicine name or generic name..."
                               value="<%= searchTerm != null ? searchTerm : "" %>">
                    </div>
                </div>
                <div class="col-md-2">
                    <button type="submit" class="btn btn-primary w-100">
                        <i class="fas fa-search me-2"></i>Search
                    </button>
                </div>
                <div class="col-md-2">
                    <a href="medicines" class="btn btn-secondary w-100">
                        <i class="fas fa-redo me-2"></i>Reset
                    </a>
                </div>
            </form>
        </div>
    </div>

    <!-- Medicines Table -->
    <div class="card">
        <div class="card-header">
            <h5 class="mb-0">
                <i class="fas fa-list me-2"></i>Medicine List
                <span class="badge bg-primary ms-2"><%= medicines != null ? medicines.size() : 0 %></span>
            </h5>
        </div>
        <div class="card-body">
            <% if (medicines != null && !medicines.isEmpty()) { %>
            <div class="table-responsive">
                <table class="table table-hover align-middle">
                    <thead class="table-light">
                    <tr>
                        <th>ID</th>
                        <th>Medicine Name</th>
                        <th>Generic Name</th>
                        <th>Category</th>
                        <th>Supplier</th>
                        <th>Price</th>
                        <th>Stock</th>
                        <th>Expiry</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% for (Medicine medicine : medicines) { %>
                    <tr>
                        <td><strong><%= medicine.getMedicineId() %></strong></td>
                        <td>
                            <strong><%= medicine.getMedicineName() %></strong>
                            <% if (medicine.getBatchNumber() != null) { %>
                            <br><small class="text-muted">Batch: <%= medicine.getBatchNumber() %></small>
                            <% } %>
                        </td>
                        <td><%= medicine.getGenericName() != null ? medicine.getGenericName() : "-" %></td>
                        <td><span class="badge bg-info"><%= medicine.getCategory() %></span></td>
                        <td><%= medicine.getSupplierName() != null ? medicine.getSupplierName() : "-" %></td>
                        <td>
                            <strong>₹‚<%= String.format("%.2f", medicine.getSellingPrice()) %></strong>
                            <br><small class="text-muted">Cost: ₹‚<%= String.format("%.2f", medicine.getUnitPrice()) %></small>
                        </td>
                        <td>
                            <% if (medicine.getStockQuantity() <= medicine.getReorderLevel()) { %>
                            <span class="badge bg-danger"><%= medicine.getStockQuantity() %></span>
                            <br><small class="text-danger">Low Stock!</small>
                            <% } else { %>
                            <span class="badge bg-success"><%= medicine.getStockQuantity() %></span>
                            <% } %>
                        </td>
                        <td>
                            <small><%= medicine.getExpiryDate() %></small>
                        </td>
                        <td>
                            <% if ("available".equals(medicine.getStatus())) { %>
                            <span class="badge bg-success">Available</span>
                            <% } else if ("out_of_stock".equals(medicine.getStatus())) { %>
                            <span class="badge bg-danger">Out of Stock</span>
                            <% } else { %>
                            <span class="badge bg-secondary"><%= medicine.getStatus() %></span>
                            <% } %>
                        </td>
                        <td>
                            <div class="btn-group" role="group">
                                <a href="medicines?action=edit&id=<%= medicine.getMedicineId() %>"
                                   class="btn btn-sm btn-outline-primary"
                                   title="Edit">
                                    <i class="fas fa-edit"></i>
                                </a>
                                <a href="medicines?action=delete&id=<%= medicine.getMedicineId() %>"
                                   class="btn btn-sm btn-outline-danger"
                                   onclick="return confirmDelete('Are you sure you want to delete this medicine?')"
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
                <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                <p class="text-muted">No medicines found.</p>
                <a href="medicines?action=add" class="btn btn-primary">
                    <i class="fas fa-plus me-2"></i>Add First Medicine
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

    .card-body {
        padding: 20px;
    }

    .table th {
        font-weight: 600;
        font-size: 13px;
        text-transform: uppercase;
        color: #666;
        white-space: nowrap;
    }

    .table td {
        vertical-align: middle;
        font-size: 14px;
    }

    .btn-group .btn {
        padding: 5px 10px;
    }

    .badge {
        font-weight: 500;
        padding: 5px 10px;
    }

    .input-group-text {
        background: white;
        border-right: none;
    }

    .input-group .form-control {
        border-left: none;
    }

    .input-group .form-control:focus {
        border-color: #ced4da;
        box-shadow: none;
    }
</style>

<jsp:include page="includes/footer.jsp" />