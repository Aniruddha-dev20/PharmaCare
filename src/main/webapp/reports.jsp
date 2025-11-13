<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<jsp:include page="includes/header.jsp">
    <jsp:param name="title" value="Reports" />
</jsp:include>

<jsp:include page="includes/sidebar.jsp">
    <jsp:param name="active" value="reports" />
</jsp:include>

<div class="content-area">
    <!-- Page Header -->
    <div class="page-header">
        <h1 class="page-title">Reports & Analytics</h1>
        <p class="page-subtitle">Generate comprehensive business reports</p>
    </div>

    <!-- Report Cards -->
    <div class="row g-4">
        <!-- Sales Report -->
        <div class="col-md-6 col-lg-4">
            <div class="report-card">
                <div class="report-icon bg-primary">
                    <i class="fas fa-chart-line"></i>
                </div>
                <div class="report-content">
                    <h5>Sales Report</h5>
                    <p class="text-muted mb-3">View sales transactions, revenue analysis, and customer purchase history</p>
                    <a href="reports?type=sales" class="btn btn-primary btn-sm">
                        <i class="fas fa-file-alt me-1"></i>Generate Report
                    </a>
                </div>
            </div>
        </div>

        <!-- Stock Report -->
        <div class="col-md-6 col-lg-4">
            <div class="report-card">
                <div class="report-icon bg-success">
                    <i class="fas fa-boxes"></i>
                </div>
                <div class="report-content">
                    <h5>Stock Report</h5>
                    <p class="text-muted mb-3">Current inventory status, stock levels, and valuation details</p>
                    <a href="reports?type=stock" class="btn btn-success btn-sm">
                        <i class="fas fa-file-alt me-1"></i>Generate Report
                    </a>
                </div>
            </div>
        </div>

        <!-- Expiry Report -->
        <div class="col-md-6 col-lg-4">
            <div class="report-card">
                <div class="report-icon bg-warning">
                    <i class="fas fa-calendar-times"></i>
                </div>
                <div class="report-content">
                    <h5>Expiry Alert Report</h5>
                    <p class="text-muted mb-3">Medicines expiring soon or already expired requiring attention</p>
                    <a href="reports?type=expiry" class="btn btn-warning btn-sm">
                        <i class="fas fa-file-alt me-1"></i>Generate Report
                    </a>
                </div>
            </div>
        </div>

        <!-- Purchase Report -->
        <div class="col-md-6 col-lg-4">
            <div class="report-card">
                <div class="report-icon bg-info">
                    <i class="fas fa-shopping-bag"></i>
                </div>
                <div class="report-content">
                    <h5>Purchase Report</h5>
                    <p class="text-muted mb-3">Purchase orders, supplier transactions, and procurement analysis</p>
                    <a href="reports?type=purchase" class="btn btn-info btn-sm">
                        <i class="fas fa-file-alt me-1"></i>Generate Report
                    </a>
                </div>
            </div>
        </div>

        <!-- Low Stock Report -->
        <div class="col-md-6 col-lg-4">
            <div class="report-card">
                <div class="report-icon bg-danger">
                    <i class="fas fa-exclamation-triangle"></i>
                </div>
                <div class="report-content">
                    <h5>Low Stock Report</h5>
                    <p class="text-muted mb-3">Medicines below reorder level needing immediate restocking</p>
                    <a href="reports?type=lowstock" class="btn btn-danger btn-sm">
                        <i class="fas fa-file-alt me-1"></i>Generate Report
                    </a>
                </div>
            </div>
        </div>

        <!-- Financial Report -->
        <div class="col-md-6 col-lg-4">
            <div class="report-card">
                <div class="report-icon bg-secondary">
                    <i class="fas fa-rupee-sign"></i>
                </div>
                <div class="report-content">
                    <h5>Financial Report</h5>
                    <p class="text-muted mb-3">Revenue, expenses, profit margins, and financial summaries</p>
                    <a href="reports?type=financial" class="btn btn-secondary btn-sm">
                        <i class="fas fa-file-alt me-1"></i>Generate Report
                    </a>
                </div>
            </div>
        </div>
    </div>

    <!-- Custom Report Generator -->
    <div class="card mt-4">
        <div class="card-header">
            <h5 class="mb-0">
                <i class="fas fa-filter me-2"></i>Custom Report Generator
            </h5>
        </div>
        <div class="card-body">
            <form id="customReportForm" class="row g-3">
                <div class="col-md-3">
                    <label for="reportType" class="form-label">Report Type</label>
                    <select class="form-select" id="reportType" name="reportType">
                        <option value="sales">Sales</option>
                        <option value="stock">Stock</option>
                        <option value="purchase">Purchase</option>
                        <option value="financial">Financial</option>
                    </select>
                </div>

                <div class="col-md-3">
                    <label for="startDate" class="form-label">Start Date</label>
                    <input type="date" class="form-control" id="startDate" name="startDate">
                </div>

                <div class="col-md-3">
                    <label for="endDate" class="form-label">End Date</label>
                    <input type="date" class="form-control" id="endDate" name="endDate">
                </div>

                <div class="col-md-3">
                    <label for="format" class="form-label">Export Format</label>
                    <select class="form-select" id="format" name="format">
                        <option value="pdf">PDF</option>
                        <option value="excel">Excel</option>
                        <option value="csv">CSV</option>
                    </select>
                </div>

                <div class="col-12">
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-download me-2"></i>Generate & Download
                    </button>
                    <button type="button" class="btn btn-secondary" onclick="printReport()">
                        <i class="fas fa-print me-2"></i>Print Report
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- Quick Statistics -->
    <div class="row g-4 mt-4">
        <div class="col-md-3">
            <div class="quick-stat">
                <div class="stat-value text-primary">₹0.00</div>
                <div class="stat-label">Today's Sales</div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="quick-stat">
                <div class="stat-value text-success">₹0.00</div>
                <div class="stat-label">This Month</div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="quick-stat">
                <div class="stat-value text-info">0</div>
                <div class="stat-label">Total Transactions</div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="quick-stat">
                <div class="stat-value text-warning">0</div>
                <div class="stat-label">Pending Orders</div>
            </div>
        </div>
    </div>
</div>

<style>
    .report-card {
        background: white;
        border-radius: 15px;
        padding: 25px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        height: 100%;
        transition: transform 0.3s, box-shadow 0.3s;
    }

    .report-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 5px 20px rgba(0,0,0,0.1);
    }

    .report-icon {
        width: 70px;
        height: 70px;
        border-radius: 15px;
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-size: 32px;
        margin-bottom: 20px;
    }

    .report-content h5 {
        font-weight: 600;
        margin-bottom: 10px;
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

    .quick-stat {
        background: white;
        border-radius: 15px;
        padding: 25px;
        text-align: center;
        box-shadow: 0 2px 10px rgba(0,0,0,0.05);
    }

    .stat-value {
        font-size: 32px;
        font-weight: 700;
        margin-bottom: 10px;
    }

    .stat-label {
        font-size: 14px;
        color: #666;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }
</style>

<script>
    // Set default dates
    const today = new Date();
    const firstDay = new Date(today.getFullYear(), today.getMonth(), 1);

    document.getElementById('startDate').valueAsDate = firstDay;
    document.getElementById('endDate').valueAsDate = today;

    // Form submission
    document.getElementById('customReportForm').addEventListener('submit', function(e) {
        e.preventDefault();
        alert('Report generation feature will be implemented. This will generate and download the selected report.');
    });

    function printReport() {
        alert('Print report feature will be implemented. This will open a print-friendly version of the report.');
    }
</script>

<jsp:include page="includes/footer.jsp" />