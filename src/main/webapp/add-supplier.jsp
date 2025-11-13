<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<jsp:include page="includes/header.jsp">
    <jsp:param name="title" value="Add Supplier" />
</jsp:include>

<jsp:include page="includes/sidebar.jsp">
    <jsp:param name="active" value="suppliers" />
</jsp:include>

<div class="content-area">
    <!-- Page Header -->
    <div class="page-header">
        <h1 class="page-title">Add New Supplier</h1>
        <p class="page-subtitle">Enter supplier details to add to the system</p>
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
            <form action="suppliers" method="post" id="addSupplierForm">
                <input type="hidden" name="action" value="add">

                <div class="row g-4">
                    <!-- Basic Information -->
                    <div class="col-12">
                        <h5 class="section-title">
                            <i class="fas fa-info-circle me-2"></i>Supplier Information
                        </h5>
                        <hr>
                    </div>

                    <div class="col-md-6">
                        <label for="supplierName" class="form-label required">Supplier Name</label>
                        <input type="text"
                               class="form-control"
                               id="supplierName"
                               name="supplierName"
                               placeholder="Enter supplier name"
                               required>
                    </div>

                    <div class="col-md-6">
                        <label for="contactPerson" class="form-label">Contact Person</label>
                        <input type="text"
                               class="form-control"
                               id="contactPerson"
                               name="contactPerson"
                               placeholder="Enter contact person name">
                    </div>

                    <!-- Contact Information -->
                    <div class="col-12 mt-4">
                        <h5 class="section-title">
                            <i class="fas fa-phone me-2"></i>Contact Information
                        </h5>
                        <hr>
                    </div>

                    <div class="col-md-6">
                        <label for="phone" class="form-label required">Phone Number</label>
                        <input type="tel"
                               class="form-control"
                               id="phone"
                               name="phone"
                               placeholder="Enter phone number"
                               pattern="[0-9]{10}"
                               required>
                        <small class="text-muted">10-digit phone number</small>
                    </div>

                    <div class="col-md-6">
                        <label for="email" class="form-label">Email Address</label>
                        <input type="email"
                               class="form-control"
                               id="email"
                               name="email"
                               placeholder="Enter email address">
                    </div>

                    <!-- Address Information -->
                    <div class="col-12 mt-4">
                        <h5 class="section-title">
                            <i class="fas fa-map-marker-alt me-2"></i>Address Information
                        </h5>
                        <hr>
                    </div>

                    <div class="col-md-12">
                        <label for="address" class="form-label">Address</label>
                        <textarea class="form-control"
                                  id="address"
                                  name="address"
                                  rows="3"
                                  placeholder="Enter complete address"></textarea>
                    </div>

                    <div class="col-md-4">
                        <label for="city" class="form-label">City</label>
                        <input type="text"
                               class="form-control"
                               id="city"
                               name="city"
                               placeholder="Enter city">
                    </div>

                    <div class="col-md-4">
                        <label for="state" class="form-label">State</label>
                        <input type="text"
                               class="form-control"
                               id="state"
                               name="state"
                               placeholder="Enter state">
                    </div>

                    <div class="col-md-4">
                        <label for="pincode" class="form-label">Pincode</label>
                        <input type="text"
                               class="form-control"
                               id="pincode"
                               name="pincode"
                               placeholder="Enter pincode"
                               pattern="[0-9]{6}">
                        <small class="text-muted">6-digit pincode</small>
                    </div>

                    <!-- Form Actions -->
                    <div class="col-12 mt-4">
                        <hr>
                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save me-2"></i>Save Supplier
                            </button>
                            <button type="reset" class="btn btn-secondary">
                                <i class="fas fa-redo me-2"></i>Reset
                            </button>
                            <a href="suppliers" class="btn btn-outline-secondary">
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

    .form-control, .form-select {
        border-radius: 8px;
        border: 1px solid #ced4da;
        padding: 10px 15px;
    }

    .form-control:focus, .form-select:focus {
        border-color: #667eea;
        box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
    }
</style>

<jsp:include page="includes/footer.jsp" />