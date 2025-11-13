<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pharmacy.model.Medicine" %>
<%@ page import="com.pharmacy.model.Supplier" %>
<%@ page import="java.util.List" %>

<%
    Medicine medicine = (Medicine) request.getAttribute("medicine");
    List<Supplier> suppliers = (List<Supplier>) request.getAttribute("suppliers");
%>

<jsp:include page="includes/header.jsp">
    <jsp:param name="title" value="Edit Medicine" />
</jsp:include>

<jsp:include page="includes/sidebar.jsp">
    <jsp:param name="active" value="medicines" />
</jsp:include>

<div class="content-area">
    <!-- Page Header -->
    <div class="page-header">
        <h1 class="page-title">Edit Medicine</h1>
        <p class="page-subtitle">Update medicine details</p>
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
            <form action="medicines" method="post" id="editMedicineForm">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="medicineId" value="<%= medicine.getMedicineId() %>">

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
                               value="<%= medicine.getMedicineName() %>"
                               required>
                    </div>

                    <div class="col-md-6">
                        <label for="genericName" class="form-label">Generic Name</label>
                        <input type="text"
                               class="form-control"
                               id="genericName"
                               name="genericName"
                               value="<%= medicine.getGenericName() != null ? medicine.getGenericName() : "" %>">
                    </div>

                    <div class="col-md-6">
                        <label for="category" class="form-label required">Category</label>
                        <select class="form-select" id="category" name="category" required>
                            <option value="">Select Category</option>
                            <option value="Antibiotic" <%= "Antibiotic".equals(medicine.getCategory()) ? "selected" : "" %>>Antibiotic</option>
                            <option value="Painkiller" <%= "Painkiller".equals(medicine.getCategory()) ? "selected" : "" %>>Painkiller</option>
                            <option value="Diabetes" <%= "Diabetes".equals(medicine.getCategory()) ? "selected" : "" %>>Diabetes</option>
                            <option value="Blood Pressure" <%= "Blood Pressure".equals(medicine.getCategory()) ? "selected" : "" %>>Blood Pressure</option>
                            <option value="Vitamin" <%= "Vitamin".equals(medicine.getCategory()) ? "selected" : "" %>>Vitamin</option>
                            <option value="Antihistamine" <%= "Antihistamine".equals(medicine.getCategory()) ? "selected" : "" %>>Antihistamine</option>
                            <option value="Cold & Cough" <%= "Cold & Cough".equals(medicine.getCategory()) ? "selected" : "" %>>Cold & Cough</option>
                            <option value="Blood Thinner" <%= "Blood Thinner".equals(medicine.getCategory()) ? "selected" : "" %>>Blood Thinner</option>
                            <option value="Other" <%= "Other".equals(medicine.getCategory()) ? "selected" : "" %>>Other</option>
                        </select>
                    </div>

                    <div class="col-md-6">
                        <label for="supplierId" class="form-label required">Supplier</label>
                        <select class="form-select" id="supplierId" name="supplierId" required>
                            <option value="">Select Supplier</option>
                            <% if (suppliers != null) {
                                for (Supplier supplier : suppliers) { %>
                            <option value="<%= supplier.getSupplierId() %>"
                                    <%= supplier.getSupplierId() == medicine.getSupplierId() ? "selected" : "" %>>
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
                                   value="<%= medicine.getUnitPrice() %>"
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
                                   value="<%= medicine.getSellingPrice() %>"
                                   required>
                        </div>
                        <small class="text-muted">Profit: <span id="profitDisplay">₹<%= String.format("%.2f", medicine.getProfit()) %></span></small>
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
                               value="<%= medicine.getStockQuantity() %>"
                               required>
                    </div>

                    <div class="col-md-6">
                        <label for="reorderLevel" class="form-label required">Reorder Level</label>
                        <input type="number"
                               class="form-control"
                               id="reorderLevel"
                               name="reorderLevel"
                               min="0"
                               value="<%= medicine.getReorderLevel() %>"
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
                               value="<%= medicine.getExpiryDate() %>"
                               required>
                    </div>

                    <div class="col-md-4">
                        <label for="manufactureDate" class="form-label">Manufacture Date</label>
                        <input type="date"
                               class="form-control"
                               id="manufactureDate"
                               name="manufactureDate"
                               value="<%= medicine.getManufactureDate() != null ? medicine.getManufactureDate() : "" %>">
                    </div>

                    <div class="col-md-4">
                        <label for="batchNumber" class="form-label">Batch Number</label>
                        <input type="text"
                               class="form-control"
                               id="batchNumber"
                               name="batchNumber"
                               value="<%= medicine.getBatchNumber() != null ? medicine.getBatchNumber() : "" %>">
                    </div>

                    <div class="col-md-4">
                        <label for="rackNumber" class="form-label">Rack Number</label>
                        <input type="text"
                               class="form-control"
                               id="rackNumber"
                               name="rackNumber"
                               value="<%= medicine.getRackNumber() != null ? medicine.getRackNumber() : "" %>"
                               placeholder="e.g., A1, B2, C3">
                    </div>

                    <div class="col-md-4">
                        <label for="status" class="form-label required">Status</label>
                        <select class="form-select" id="status" name="status" required>
                            <option value="available" <%= "available".equals(medicine.getStatus()) ? "selected" : "" %>>Available</option>
                            <option value="out_of_stock" <%= "out_of_stock".equals(medicine.getStatus()) ? "selected" : "" %>>Out of Stock</option>
                            <option value="discontinued" <%= "discontinued".equals(medicine.getStatus()) ? "selected" : "" %>>Discontinued</option>
                        </select>
                    </div>

                    <div class="col-md-4">
                        <label for="description" class="form-label">Description</label>
                        <textarea class="form-control"
                                  id="description"
                                  name="description"
                                  rows="1"><%= medicine.getDescription() != null ? medicine.getDescription() : "" %></textarea>
                    </div>

                    <!-- Form Actions -->
                    <div class="col-12 mt-4">
                        <hr>
                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save me-2"></i>Update Medicine
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
</script>

<jsp:include page="includes/footer.jsp" />