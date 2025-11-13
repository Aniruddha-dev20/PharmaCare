<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pharmacy.model.PurchaseOrder" %>
<%@ page import="com.pharmacy.model.PurchaseItem" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
  PurchaseOrder po = (PurchaseOrder) request.getAttribute("purchaseOrder");
  SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy");
%>

<jsp:include page="includes/header.jsp">
  <jsp:param name="title" value="Purchase Order Details" />
</jsp:include>

<jsp:include page="includes/sidebar.jsp">
  <jsp:param name="active" value="purchases" />
</jsp:include>

<div class="content-area">
  <!-- Page Header -->
  <div class="page-header d-flex justify-content-between align-items-center">
    <div>
      <h1 class="page-title">Purchase Order Details</h1>
      <p class="page-subtitle"><%= po != null ? po.getPoNumber() : "" %></p>
    </div>
    <a href="purchases" class="btn btn-secondary">
      <i class="fas fa-arrow-left me-2"></i>Back to List
    </a>
  </div>

    <% if (po != null) { %>
  <div class="row g-4">
    <!-- Order Information Card -->
    <div class="col-md-4">
      <div class="card">
        <div class="card-header">
          <h5 class="mb-0">Order Information</h5>
        </div>
        <div class="card-body">
          <table class="table table-borderless mb-0">
            <tr>
              <td class="text-muted">PO Number:</td>
              <td><strong><%= po.getPoNumber() %></strong></td>
            </tr>
            <tr>
              <td class="text-muted">Status:</td>
              <td>
                <% if ("pending".equals(po.getStatus())) { %>
                <span class="badge bg-warning">Pending</span>
                <% } else if ("received".equals(po.getStatus())) { %>
                <span class="badge bg-success">Received</span>
                <% } else if ("cancelled".equals(po.getStatus())) { %>
                <span class="badge bg-danger">Cancelled</span>
                <% } %>
              </td>
            </tr>
            <tr>
              <td class="text-muted">Order Date:</td>
              <td><%= sdf.format(po.getOrderDate()) %></td>
            </tr>
            <tr>
              <td class="text-muted">Expected Delivery:</td>
              <td><%= po.getExpectedDelivery() != null ? sdf.format(po.getExpectedDelivery()) : "-" %></td>
            </tr>
            <tr>
              <td class="text-muted">Created By:</td>
              <td><%= po.getUserName() != null ? po.getUserName() : "-" %></td>
            </tr>
          </table>
        </div>
      </div>

      <!-- Supplier Information -->
      <div class="card mt-4">
        <div class="card-header">
          <h5 class="mb-0">Supplier Information</h5>
        </div>
        <div class="card-body">
          <h6><%= po.getSupplierName() %></h6>
          <p class="text-muted small mb-0">Supplier ID: <%= po.getSupplierId() %></p>
        </div>
      </div>

      <!-- Notes -->
      <% if (po.getNotes() != null && !po.getNotes().isEmpty()) { %>
      <div class="card mt-4">
        <div class="card-header">
          <h5 class="mb-0">Notes</h5>
        </div>
        <div class="card-body">
          <p class="mb-0"><%= po.getNotes() %></p>
        </div>
      </div>
      <% } %>

      <!-- Actions -->
      <% if ("pending".equals(po.getStatus())) { %>
      <div class="card mt-4">
        <div class="card-body">
          <h6 class="mb-3">Actions</h6>
          <a href="purchases?action=receive&id=<%= po.getPoId() %>"
             class="btn btn-success w-100 mb-2"
             onclick="return confirm('Mark this order as received and update stock?')">
            <i class="fas fa-check me-2"></i>Mark as Received
          </a>
          <a href="purchases?action=cancel&id=<%= po.getPoId() %>"
             class="btn btn-danger w-100"
             onclick="return confirm('Cancel this purchase order?')">
            <i class="fas fa-times me-2"></i>Cancel Order
          </a>
        </div>
      </div>
      <% } %>
    </div>

    <!-- Order Items Card -->
    <div class="col-md-8">
      <div class="card">
        <div class="card-header">
          <h5 class="mb-0">Order Items</h5>
        </div>
        <div class="card-body">
          <% if (po.getPurchaseItems() != null && !po.getPurchaseItems().isEmpty()) { %>
          <div class="table-responsive">
            <table class="table table-hover">
              <thead class="table-light">
              <tr>
                <th>#</th>
                <th>Medicine Name</th>
                <th>Quantity</th>
                <th>Unit Price</th>
                <th class="text-end">Subtotal</th>
              </tr>
              </thead>
              <tbody>
              <%
                int itemNo = 1;
                for (PurchaseItem item : po.getPurchaseItems()) {
              %>
              <tr>
                <td><%= itemNo++ %></td>
                <td><strong><%= item.getMedicineName() %></strong></td>
                <td><%= item.getQuantity() %></td>
                <td>₹<%= String.format("%.2f", item.getUnitPrice()) %></td>
                <td class="text-end"><strong>₹<%= String.format("%.2f", item.getSubtotal()) %></strong></td>
              </tr>
              <% } %>
              </tbody>
              <tfoot>
              <tr>
                <td colspan="4" class="text-end"><strong>Total Amount:</strong></td>
                <td class="text-end">
                  <h5 class="mb-0 text-primary">₹<%= String.format("%.2f", po.getTotalAmount()) %></h5>
                </td>
              </tr>
              </tfoot>
            </table>
          </div>
          <% } else { %>
          <p class="text-muted text-center py-4">No items in this purchase order</p>
          <% } %>
        </div>
      </div>

      <!-- Print Section -->
      <div class="card mt-4">
        <div class="card-body text-center">
          <button onclick="window.print()" class="btn btn-outline-primary">
            <i class="fas fa-print me-2"></i>Print Purchase Order
          </button>
        </div>
      </div>
    </div>
  </div>
    <% } else { %>
  <div class="alert alert-warning">
    <i class="fas fa-exclamation-triangle me-2"></i>
    <% } %>
  </div>