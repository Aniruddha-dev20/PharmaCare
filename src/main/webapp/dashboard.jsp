<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pharmacy.model.DashboardStats" %>
<%@ page import="com.pharmacy.model.Medicine" %>
<%@ page import="java.util.List" %>

<%
    // Check if user is logged in
    if (session.getAttribute("user") == null) {
        response.sendRedirect("login");
        return;
    }

    DashboardStats stats = (DashboardStats) request.getAttribute("stats");
    List<Medicine> lowStockMedicines = (List<Medicine>) request.getAttribute("lowStockMedicines");
    List<Medicine> expiringMedicines = (List<Medicine>) request.getAttribute("expiringMedicines");

    String role = (String) session.getAttribute("role");
    String fullName = (String) session.getAttribute("fullName");
    boolean isAdmin = "admin".equalsIgnoreCase(role);
    boolean isPharmacist = "pharmacist".equalsIgnoreCase(role);
    boolean isCashier = "cashier".equalsIgnoreCase(role);

    // Get access error from session if any
    String accessError = (String) session.getAttribute("accessError");
    if (accessError != null) {
        session.removeAttribute("accessError"); // Remove after displaying
    }
%>

<jsp:include page="includes/header.jsp">
    <jsp:param name="title" value="Dashboard" />
</jsp:include>

<jsp:include page="includes/sidebar.jsp">
    <jsp:param name="active" value="dashboard" />
</jsp:include>

<div class="content-area">
    <!-- Page Header -->
    <div class="page-header">
        <h1 class="page-title">
            <i class="fas fa-tachometer-alt me-2"></i>Dashboard
            <span class="badge bg-primary ms-3"><%= role.toUpperCase() %></span>
        </h1>
        <p class="page-subtitle">Welcome back, <strong><%= fullName %></strong>! Overview of pharmacy operations and key metrics</p>
    </div>

    <!-- Access Error Alert -->
    <% if (accessError != null && !accessError.isEmpty()) { %>
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        <i class="fas fa-exclamation-triangle me-2"></i>
        <strong>Access Denied!</strong> <%= accessError %>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <% } %>

    <!-- Role-Based Access Information -->
    <% if (isAdmin) { %>
    <div class="alert alert-info border-0 shadow-sm mb-4">
        <div class="d-flex align-items-center">
            <i class="fas fa-crown fa-2x text-warning me-3"></i>
            <div>
                <h5 class="alert-heading mb-1">👑 Administrator Access - Full System Control</h5>
                <p class="mb-0 small">You have complete access to all modules: User Management, Medicine Inventory, Stock, Suppliers, Purchases, Sales, Customers, and Reports.</p>
            </div>
        </div>
    </div>
    <% } else if (isPharmacist) { %>
    <div class="alert alert-success border-0 shadow-sm mb-4">
        <div class="d-flex align-items-center">
            <i class="fas fa-prescription-bottle fa-2x text-success me-3"></i>
            <div>
                <h5 class="alert-heading mb-1">💊 Pharmacist Access - Inventory & Purchase Management</h5>
                <p class="mb-0 small">You can manage: Medicine Inventory, Stock Levels, and Purchase Orders.</p>
            </div>
        </div>
    </div>
    <% } else if (isCashier) { %>
    <div class="alert alert-warning border-0 shadow-sm mb-4">
        <div class="d-flex align-items-center">
            <i class="fas fa-cash-register fa-2x text-warning me-3"></i>
            <div>
                <h5 class="alert-heading mb-1">🛒 Cashier Access - Sales & Customer Service</h5>
                <p class="mb-0 small">You can: Process Sales, Manage Customers, and View Stock List (read-only).</p>
            </div>
        </div>
    </div>
    <% } %>

    <!-- Statistics Cards -->
    <% if (stats != null) { %>
    <div class="row g-4 mb-4">
        <!-- Admin sees all statistics -->
        <% if (isAdmin) { %>
        <div class="col-md-3">
            <div class="stat-card">
                <div class="stat-icon" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
                    <i class="fas fa-box"></i>
                </div>
                <div class="stat-content">
                    <div class="stat-label">Total Stock</div>
                    <div class="stat-value"><%= stats.getTotalStock() %></div>
                </div>
            </div>
        </div>

        <div class="col-md-3">
            <div class="stat-card">
                <div class="stat-icon" style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);">
                    <i class="fas fa-pills"></i>
                </div>
                <div class="stat-content">
                    <div class="stat-label">Total Medicines</div>
                    <div class="stat-value"><%= stats.getTotalMedicines() %></div>
                </div>
            </div>
        </div>

        <div class="col-md-3">
            <div class="stat-card">
                <div class="stat-icon" style="background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);">
                    <i class="fas fa-truck"></i>
                </div>
                <div class="stat-content">
                    <div class="stat-label">Total Suppliers</div>
                    <div class="stat-value"><%= stats.getTotalSuppliers() %></div>
                </div>
            </div>
        </div>

        <div class="col-md-3">
            <div class="stat-card">
                <div class="stat-icon" style="background: linear-gradient(135deg, #a8edea 0%, #fed6e3 100%);">
                    <i class="fas fa-users"></i>
                </div>
                <div class="stat-content">
                    <div class="stat-label">Total Customers</div>
                    <div class="stat-value"><%= stats.getTotalCustomers() %></div>
                </div>
            </div>
        </div>

        <div class="col-md-3">
            <div class="stat-card">
                <div class="stat-icon" style="background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);">
                    <i class="fas fa-shopping-bag"></i>
                </div>
                <div class="stat-content">
                    <div class="stat-label">No. of Purchases</div>
                    <div class="stat-value"><%= stats.getTotalPurchases() %></div>
                </div>
            </div>
        </div>

        <div class="col-md-3">
            <div class="stat-card">
                <div class="stat-icon" style="background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);">
                    <i class="fas fa-rupee-sign"></i>
                </div>
                <div class="stat-content">
                    <div class="stat-label">Purchase Amount</div>
                    <div class="stat-value">₹<%= String.format("%.0f", stats.getPurchaseAmount()) %></div>
                </div>
            </div>
        </div>

        <div class="col-md-3">
            <div class="stat-card">
                <div class="stat-icon" style="background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);">
                    <i class="fas fa-shopping-cart"></i>
                </div>
                <div class="stat-content">
                    <div class="stat-label">No. of Sales</div>
                    <div class="stat-value"><%= stats.getTotalSales() %></div>
                </div>
            </div>
        </div>

        <div class="col-md-3">
            <div class="stat-card">
                <div class="stat-icon" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
                    <i class="fas fa-rupee-sign"></i>
                </div>
                <div class="stat-content">
                    <div class="stat-label">Sales Amount</div>
                    <div class="stat-value">₹<%= String.format("%.0f", stats.getSalesAmount()) %></div>
                </div>
            </div>
        </div>

        <% } else if (isPharmacist) { %>
        <!-- Pharmacist sees: Stock, Medicines,Purchases -->
        <div class="col-md-3">
            <div class="stat-card">
                <div class="stat-icon" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
                    <i class="fas fa-box"></i>
                </div>
                <div class="stat-content">
                    <div class="stat-label">Total Stock</div>
                    <div class="stat-value"><%= stats.getTotalStock() %></div>
                </div>
            </div>
        </div>

        <div class="col-md-3">
            <div class="stat-card">
                <div class="stat-icon" style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);">
                    <i class="fas fa-pills"></i>
                </div>
                <div class="stat-content">
                    <div class="stat-label">Total Medicines</div>
                    <div class="stat-value"><%= stats.getTotalMedicines() %></div>
                </div>
            </div>
        </div>

        <div class="col-md-3">
            <div class="stat-card">
                <div class="stat-icon" style="background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);">
                    <i class="fas fa-shopping-bag"></i>
                </div>
                <div class="stat-content">
                    <div class="stat-label">No. of Purchases</div>
                    <div class="stat-value"><%= stats.getTotalPurchases() %></div>
                </div>
            </div>
        </div>

        <% } else if (isCashier) { %>
        <!-- Cashier sees: Customers, Sales, Stock -->
        <div class="col-md-4">
            <div class="stat-card">
                <div class="stat-icon" style="background: linear-gradient(135deg, #a8edea 0%, #fed6e3 100%);">
                    <i class="fas fa-users"></i>
                </div>
                <div class="stat-content">
                    <div class="stat-label">Total Customers</div>
                    <div class="stat-value"><%= stats.getTotalCustomers() %></div>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="stat-card">
                <div class="stat-icon" style="background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);">
                    <i class="fas fa-shopping-cart"></i>
                </div>
                <div class="stat-content">
                    <div class="stat-label">No. of Sales</div>
                    <div class="stat-value"><%= stats.getTotalSales() %></div>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="stat-card">
                <div class="stat-icon" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
                    <i class="fas fa-rupee-sign"></i>
                </div>
                <div class="stat-content">
                    <div class="stat-label">Sales Amount</div>
                    <div class="stat-value">₹<%= String.format("%.0f", stats.getSalesAmount()) %></div>
                </div>
            </div>
        </div>
        <% } %>
    </div>
    <% } %>

    <!-- Alerts Row (Only for Admin and Pharmacist) -->
    <% if ((isAdmin || isPharmacist) && (lowStockMedicines != null || expiringMedicines != null)) { %>
    <div class="row g-4">
        <!-- Low Stock Alerts -->
        <div class="col-md-6">
            <div class="alert-card">
                <div class="alert-header">
                    <h5><i class="fas fa-exclamation-triangle text-danger"></i> Low Stock Alerts</h5>
                    <span class="badge bg-danger"><%= stats != null ? stats.getLowStockCount() : 0 %></span>
                </div>
                <div class="alert-body">
                    <% if (lowStockMedicines != null && !lowStockMedicines.isEmpty()) { %>
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                            <tr>
                                <th>Medicine Name</th>
                                <th>Stock</th>
                                <th>Reorder Level</th>
                            </tr>
                            </thead>
                            <tbody>
                            <% for (Medicine medicine : lowStockMedicines) { %>
                            <tr>
                                <td><%= medicine.getMedicineName() %></td>
                                <td><span class="badge bg-danger"><%= medicine.getStockQuantity() %></span></td>
                                <td><%= medicine.getReorderLevel() %></td>
                            </tr>
                            <% } %>
                            </tbody>
                        </table>
                    </div>
                    <% } else { %>
                    <p class="text-muted text-center py-3">✓ No low stock items</p>
                    <% } %>
                </div>
            </div>
        </div>

        <!-- Expiry Alerts -->
        <div class="col-md-6">
            <div class="alert-card">
                <div class="alert-header">
                    <h5><i class="fas fa-clock text-warning"></i> Expiry Alerts</h5>
                    <span class="badge bg-warning"><%= stats != null ? stats.getExpiringCount() : 0 %></span>
                </div>
                <div class="alert-body">
                    <% if (expiringMedicines != null && !expiringMedicines.isEmpty()) { %>
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                            <tr>
                                <th>Medicine Name</th>
                                <th>Batch</th>
                                <th>Expiry Date</th>
                            </tr>
                            </thead>
                            <tbody>
                            <% for (Medicine medicine : expiringMedicines) { %>
                            <tr>
                                <td><%= medicine.getMedicineName() %></td>
                                <td><%= medicine.getBatchNumber() %></td>
                                <td><span class="badge bg-warning"><%= medicine.getExpiryDate() %></span></td>
                            </tr>
                            <% } %>
                            </tbody>
                        </table>
                    </div>
                    <% } else { %>
                    <p class="text-muted text-center py-3">✓ No expiring items</p>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
    <% } %>
</div>

<style>
    .quick-action-card i {
        font-size: 32px;
        display: block;
        margin-bottom: 10px;
    }

    .quick-action-card span {
        font-weight: 600;
        font-size: 14px;
    }

    .stat-card {
        background: white;
        border-radius: 15px;
        padding: 25px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        display: flex;
        align-items: center;
        gap: 20px;
        transition: transform 0.3s, box-shadow 0.3s;
    }

    .stat-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 5px 20px rgba(0,0,0,0.1);
    }

    .stat-icon {
        width: 70px;
        height: 70px;
        border-radius: 15px;
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-size: 30px;
    }

    .stat-content {
        flex: 1;
    }

    .stat-label {
        font-size: 14px;
        color: #666;
        margin-bottom: 5px;
    }

    .stat-value {
        font-size: 28px;
        font-weight: 700;
        color: #333;
    }

    .alert-card {
        background: white;
        border-radius: 15px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        overflow: hidden;
    }

    .alert-header {
        padding: 20px;
        background: #f8f9fa;
        display: flex;
        justify-content: space-between;
        align-items: center;
        border-bottom: 1px solid #dee2e6;
    }

    .alert-header h5 {
        margin: 0;
        font-size: 18px;
        font-weight: 600;
    }

    .alert-body {
        padding: 20px;
        max-height: 400px;
        overflow-y: auto;
    }

    .table {
        margin: 0;
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
</style>

<jsp:include page="includes/footer.jsp" />