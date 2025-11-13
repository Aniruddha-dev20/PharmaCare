<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pharmacy.model.Supplier" %>
<%@ page import="java.util.List" %>

<%
    List<Supplier> suppliers = (List<Supplier>) request.getAttribute("suppliers");
%>

<jsp:include page="includes/header.jsp">
    <jsp:param name="title" value="Add Medicine" />
</jsp:include>

<jsp:include page="includes/sidebar.jsp">
    <jsp:param name="active" value="medicines" />
</jsp:include>

<div class="content-area">
    <!-- Page Header -->
    <div class="page-header">
        <h1 class="page-title">Add New Medicine</h1>
        <p class="page-subtitle">Enter medicine details to add to inventory</p>
    </div>

    <!-- Error Message -->
    <% if (request.getAttribute("error") != null) { %>
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        <i class="fas fa-exclamation-circle me-2"></i>
        <%= request.getAttribute("error") %>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <% } %>

    <!-- Form Card -->
    <div class="card">
        <div class="card-body">
            <form action="medicines" method="post" id="addMedicineForm">
                <input type="hidden" name="action" value="add">

                <div class="row g-4">
                    <!-- Basic Information -->
                    <div class="col-12">
                        <h5 class="section-title">
                            <i class="fas fa-info-circle me-2"></i>Basic Information
                        </h5>
                        <hr>
                    </div>

                    <div class="col-md-6">
                        <label for="medicineName" class="form-label required">Medicine Name</label>
                        <input type="text"
                               class="form-control"
                               id="medicineName"
                               name="medicineName"
                               required>
                    </div>

                    <div class="col-md-6">
                        <label for="genericName" class="form-label">Generic Name</label>
                        <input type="text"
                               class="form-control"
                               id="genericName"
                               name="genericName">
                    </div>

                    <div class="col-md-6">
                        <label for="category" class="form-label required">Category</label>
                        <select class="form-select" id="category" name="category" required>
                            <option value="">Select Category</option>
                            <option value="Antibiotic">Antibiotic</option>
                            <option value="Painkiller">Painkiller</option>
                            <option value="Diabetes">Diabetes</option>
                            <option value="Blood Pressure">Blood Pressure</option>
                            <option value="Vitamin">Vitamin</option>
                            <option value="Antihistamine">Antihistamine</option>
                            <option value="Cold & Cough">Cold & Cough</option>
                            <option value="Blood Thinner">Blood Thinner</option>
                            <option value="Other">Other</option>
                        </select>
                    </div>

                    <div class="col-md-6">
                        <label for="supplierId" class="form-label required">Supplier</label>
                        <select class="form-select" id="supplierId" name="supplierId" required>
                            <option value="">Select Supplier</option>
                            <% if (suppliers != null) {
                                for (Supplier supplier : suppliers) { %>
                            <option value="<%= supplier.getSupplierId() %>">
                                <%= supplier.getSupplierName() %>
                            </option>
                            <%  }
                            } %>
                        </select>
                    </div>

                    <!-- Pricing Information -->
                    <div class="col-12 mt-4">
                        <h5 class="section-title">
                            <i class="fas fa-rupee-sign me-2"></i>Pricing Information
                        </h5>
                        <hr>
                    </div>

                    <div class="col-md-6">
                        <label for="unitPrice" class="form-label required">Unit Price (Cost)</label>
                        <div class="input-group">
                            <span class="input-group-text">₹</span>
                            <input type="number"
                                   class="form-control"
                                   id="unitPrice"
                                   name="unitPrice"
                                   step="0.01"
                                   min="0"
                                   required>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <label for="sellingPrice" class="form-label required">Selling Price (MRP)</label>
                        <div class="input-group">
                            <span class="input-group-text">₹</span>
                            <input type="number"
                                   class="form-control"
                                   id="sellingPrice"
                                   name="sellingPrice"
                                   step="0.01"
                                   min="0"
                                   required>
                        </div>
                        <small class="text-muted">Profit: <span id="profitDisplay">₹0.00</span></small>
                    </div>

                    <!-- Stock Information -->
                    <div class="col-12 mt-4">
                        <h5 class="section-title">
                            <i class="fas fa-boxes me-2"></i>Stock Information
                        </h5>
                        <hr>
                    </div>

                    <div class="col-md-6">
                        <label for="stockQuantity" class="form-label required">Stock Quantity</label>
                        <input type="number"
                               class="form-control"
                               id="stockQuantity"
                               name="stockQuantity"
                               min="0"
                               required>
                    </div>

                    <div class="col-md-6">
                        <label for="reorderLevel" class="form-label required">Reorder Level</label>
                        <input type="number"
                               class="form-control"
                               id="reorderLevel"
                               name="reorderLevel"
                               value="10"
                               min="0"
                               required>
                        <small class="text-muted">Alert when stock goes below this level</small>
                    </div>

                    <!-- Additional Details -->
                    <div class="col-12 mt-4">
                        <h5 class="section-title">
                            <i class="fas fa-calendar me-2"></i>Additional Details
                        </h5>
                        <hr>
                    </div>

                    <div class="col-md-4">
                        <label for="expiryDate" class="form-label required">Expiry Date</label>
                        <input type="date"
                               class="form-control"
                               id="expiryDate"
                               name="expiryDate"
                               required>
                    </div>

                    <div class="col-md-4">
                        <label for="manufactureDate" class="form-label">Manufacture Date</label>
                        <input type="date"
                               class="form-control"
                               id="manufactureDate"
                               name="manufactureDate">
                    </div>

                    <div class="col-md-4">
                        <label for="batchNumber" class="form-label">Batch Number</label>
                        <input type="text"
                               class="form-control"
                               id="batchNumber"
                               name="batchNumber">
                    </div>

                    <div class="col-md-6">
                        <label for="rackNumber" class="form-label">Rack Number</label>
                        <input type="text"
                               class="form-control"
                               id="rackNumber"
                               name="rackNumber"
                               placeholder="e.g., A1, B2, C3">
                    </div>

                    <div class="col-md-6">
                        <label for="description" class="form-label">Description</label>
                        <textarea class="form-control"
                                  id="description"
                                  name="description"
                                  rows="3"></textarea>
                    </div>

                    <!-- Form Actions -->
                    <div class="col-12 mt-4">
                        <hr>
                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save me-2"></i>Save Medicine
                            </button>
                            <button type="reset" class="btn btn-secondary">
                                <i class="fas fa-redo me-2"></i>Reset
                            </button>
                            <a href="medicines" class="btn btn-outline-secondary">
                                <i class="fas fa-times me-2"></i>Cancel
                            </a>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>

<style>
    .section-title {
        color: #667eea;
        font-size: 18px;
        font-weight: 600;
    }

    .required::after {
        content: " *";
        color: red;
    }

    .form-label {
        font-weight: 500;
        color: #495057;
        margin-bottom: 0.5rem;
    }

    .form-control, .form-select {
        border-radius: 8px;
        border: 1px solid #ced4da;
        padding: 10px 15px;
    }

    .form-control:focus, .form-select:focus {
        border-color: #667eea;
        box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
    }

    .input-group-text {
        background: #f8f9fa;
        border-color: #ced4da;
    }

    .btn {
        padding: 10px 25px;
        border-radius: 8px;
        font-weight: 500;
    }
</style>

<script>
    // Calculate profit
    document.getElementById('unitPrice').addEventListener('input', calculateProfit);
    document.getElementById('sellingPrice').addEventListener('input', calculateProfit);

    function calculateProfit() {
        const unitPrice = parseFloat(document.getElementById('unitPrice').value) || 0;
        const sellingPrice = parseFloat(document.getElementById('sellingPrice').value) || 0;
        const profit = sellingPrice - unitPrice;
        document.getElementById('profitDisplay').textContent = '₹' + profit.toFixed(2);
    }

    // Set minimum expiry date to today
    const today = new Date().toISOString().split('T')[0];
    document.getElementById('expiryDate').setAttribute('min', today);

    // Form validation
    document.getElementById('addMedicineForm').addEventListener('submit', function(e) {
        const sellingPrice = parseFloat(document.getElementById('sellingPrice').value);
        const unitPrice = parseFloat(document.getElementById('unitPrice').value);

        if (sellingPrice < unitPrice) {
            e.preventDefault();
            alert('Selling price cannot be less than unit price!');
            return false;
        }

        const expiryDate = new Date(document.getElementById('expiryDate').value);
        const today = new Date();

        if (expiryDate < today) {
            e.preventDefault();
            alert('Expiry date cannot be in the past!');
            return false;
        }
    });
</script>

<jsp:include page="includes/footer.jsp" />