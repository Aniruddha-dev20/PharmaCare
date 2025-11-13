<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pharmacy.model.Medicine" %>
<%@ page import="java.util.List" %>

<%
    List<Medicine> medicines = (List<Medicine>) request.getAttribute("medicines");
    Long totalItems = (Long) request.getAttribute("totalItems");
    Long inStock = (Long) request.getAttribute("inStock");
    Long lowStock = (Long) request.getAttribute("lowStock");
    Long outOfStock = (Long) request.getAttribute("outOfStock");
    String currentFilter = (String) request.getAttribute("currentFilter");

    // Check if user is cashier (VIEW ONLY mode)
    String role = (String) session.getAttribute("role");
    boolean isCashier = "cashier".equalsIgnoreCase(role);
    Boolean isCashierAttr = (Boolean) request.getAttribute("isCashier");
    if (isCashierAttr != null) {
        isCashier = isCashierAttr;
    }
%>

<jsp:include page="includes/header.jsp">
    <jsp:param name="title" value="Stock List" />
</jsp:include>

<jsp:include page="includes/sidebar.jsp">
    <jsp:param name="active" value="stock-list" />
</jsp:include>

<div class="content-area">
    <div class="page-header">
        <h1 class="page-title">
            <i class="fas fa-boxes me-2"></i>Stock List
            <% if (isCashier) { %>
            <span class="badge bg-warning text-dark ms-2">
                    <i class="fas fa-eye"></i> VIEW ONLY
                </span>
            <% } %>
        </h1>
        <p class="page-subtitle">
            <% if (isCashier) { %>
            View inventory levels and stock status (Read-only access)
            <% } else { %>
            Monitor inventory levels and stock status
            <% } %>
        </p>
    </div>

    <!-- Cashier Notice -->
    <% if (isCashier) { %>
    <div class="alert alert-warning border-0 shadow-sm mb-4">
        <div class="d-flex align-items-center">
            <i class="fas fa-info-circle fa-2x me-3"></i>
            <div>
                <h5 class="alert-heading mb-1">👁️ View-Only Mode</h5>
                <p class="mb-0 small">
                    You are viewing the stock list in <strong>read-only mode</strong>.
                    You cannot add, edit, or delete medicines.
                    Please contact a pharmacist or administrator for stock changes.
                </p>
            </div>
        </div>
    </div>
    <% } %>

    <!-- Statistics Cards -->
    <div class="row g-4 mb-4">
        <div class="col-md-3">
            <div class="stat-card">
                <div class="stat-icon bg-primary">
                    <i class="fas fa-boxes"></i>
                </div>
                <div class="stat-content">
                    <div class="stat-label">Total Items</div>
                    <div class="stat-value"><%= totalItems != null ? totalItems : 0 %></div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card">
                <div class="stat-icon bg-success">
                    <i class="fas fa-check-circle"></i>
                </div>
                <div class="stat-content">
                    <div class="stat-label">In Stock</div>
                    <div class="stat-value"><%= inStock != null ? inStock : 0 %></div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card">
                <div class="stat-icon bg-warning">
                    <i class="fas fa-exclamation-triangle"></i>
                </div>
                <div class="stat-content">
                    <div class="stat-label">Low Stock</div>
                    <div class="stat-value"><%= lowStock != null ? lowStock : 0 %></div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card">
                <div class="stat-icon bg-danger">
                    <i class="fas fa-times-circle"></i>
                </div>
                <div class="stat-content">
                    <div class="stat-label">Out of Stock</div>
                    <div class="stat-value"><%= outOfStock != null ? outOfStock : 0 %></div>
                </div>
            </div>
        </div>
    </div>

    <!-- Stock Table -->
    <div class="card">
        <div class="card-header">
            <div class="d-flex justify-content-between align-items-center flex-wrap gap-3">
                <h5 class="mb-0"><i class="fas fa-list me-2"></i>Inventory Status</h5>
                <div class="btn-group" role="group">
                    <a href="stock-list" class="btn btn-sm btn-outline-primary <%= currentFilter == null ? "active" : "" %>">
                        <i class="fas fa-list"></i> All
                    </a>
                    <a href="stock-list?filter=available" class="btn btn-sm btn-outline-success <%= "available".equals(currentFilter) ? "active" : "" %>">
                        <i class="fas fa-check"></i> Available
                    </a>
                    <a href="stock-list?filter=low" class="btn btn-sm btn-outline-warning <%= "low".equals(currentFilter) ? "active" : "" %>">
                        <i class="fas fa-exclamation-triangle"></i> Low Stock
                    </a>
                    <a href="stock-list?filter=out" class="btn btn-sm btn-outline-danger <%= "out".equals(currentFilter) ? "active" : "" %>">
                        <i class="fas fa-times"></i> Out of Stock
                    </a>
                </div>
            </div>
        </div>
        <div class="card-body">
            <% if (medicines != null && !medicines.isEmpty()) { %>
            <div class="table-responsive">
                <table class="table table-hover align-middle">
                    <thead class="table-light">
                    <tr>
                        <th>ID</th>
                        <th>Medicine Name</th>
                        <th>Category</th>
                        <th>Supplier</th>
                        <th>Stock Quantity</th>
                        <th>Reorder Level</th>
                        <th>Status</th>
                        <% if (!isCashier) { %>
                        <th>Actions</th>
                        <% } %>
                    </tr>
                    </thead>
                    <tbody>
                    <% for (Medicine medicine : medicines) { %>
                    <tr>
                        <td><%= medicine.getMedicineId() %></td>
                        <td>
                            <strong><%= medicine.getMedicineName() %></strong>
                            <% if (medicine.getGenericName() != null && !medicine.getGenericName().isEmpty()) { %>
                            <br><small class="text-muted"><%= medicine.getGenericName() %></small>
                            <% } %>
                        </td>
                        <td><span class="badge bg-info"><%= medicine.getCategory() %></span></td>
                        <td><%= medicine.getSupplierName() != null ? medicine.getSupplierName() : "-" %></td>
                        <td>
                            <% if (medicine.getStockQuantity() == 0) { %>
                            <span class="badge bg-danger fs-6"><%= medicine.getStockQuantity() %></span>
                            <% } else if (medicine.getStockQuantity() <= medicine.getReorderLevel()) { %>
                            <span class="badge bg-warning text-dark fs-6"><%= medicine.getStockQuantity() %></span>
                            <% } else { %>
                            <span class="badge bg-success fs-6"><%= medicine.getStockQuantity() %></span>
                            <% } %>
                        </td>
                        <td><%= medicine.getReorderLevel() %></td>
                        <td>
                            <% if (medicine.getStockQuantity() == 0) { %>
                            <span class="badge bg-danger">
                                <i class="fas fa-times-circle"></i> Out of Stock
                            </span>
                            <% } else if (medicine.getStockQuantity() <= medicine.getReorderLevel()) { %>
                            <span class="badge bg-warning text-dark">
                                <i class="fas fa-exclamation-triangle"></i> Low Stock
                            </span>
                            <% } else { %>
                            <span class="badge bg-success">
                                <i class="fas fa-check-circle"></i> In Stock
                            </span>
                            <% } %>
                        </td>
                        <% if (!isCashier) { %>
                        <td>
                            <a href="medicines?action=edit&id=<%= medicine.getMedicineId() %>"
                               class="btn btn-sm btn-outline-primary"
                               title="Update Stock">
                                <i class="fas fa-edit"></i> Update
                            </a>
                        </td>
                        <% } %>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
            <% } else { %>
            <div class="text-center py-5">
                <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                <p class="text-muted">No medicines found for the selected filter.</p>
                <a href="stock-list" class="btn btn-primary">
                    <i class="fas fa-list"></i> View All Stock
                </a>
            </div>
            <% } %>
        </div>
    </div>
</div>

<style>
    .stat-card {
        background: white;
        border-radius: 15px;
        padding: 20px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        display: flex;
        align-items: center;
        gap: 15px;
        transition: transform 0.3s, box-shadow 0.3s;
    }

    .stat-card:hover {
        transform: translateY(-3px);
        box-shadow: 0 4px 15px rgba(0,0,0,0.1);
    }

    .stat-icon {
        width: 60px;
        height: 60px;
        border-radius: 12px;
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-size: 24px;
    }

    .stat-label {
        font-size: 13px;
        color: #666;
        margin-bottom: 5px;
        font-weight: 600;
        text-transform: uppercase;
    }

    .stat-value {
        font-size: 24px;
        font-weight: 700;
        color: #333;
    }

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

    .card-header h5 {
        font-weight: 600;
        color: #333;
    }

    .table th {
        font-weight: 600;
        font-size: 13px;
        text-transform: uppercase;
        color: #666;
        border-bottom: 2px solid #dee2e6;
    }

    .table td {
        vertical-align: middle;
    }

    .btn-group .btn {
        font-size: 13px;
    }

    .btn-group .btn.active {
        font-weight: 600;
    }
</style>

<jsp:include page="includes/footer.jsp" />