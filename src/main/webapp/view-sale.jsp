<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pharmacy.model.Sale" %>
<%@ page import="com.pharmacy.model.SaleItem" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    Sale sale = (Sale) request.getAttribute("sale");
    SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy HH:mm");
%>

<jsp:include page="includes/header.jsp">
    <jsp:param name="title" value="Sale Details" />
</jsp:include>

<jsp:include page="includes/sidebar.jsp">
    <jsp:param name="active" value="sales" />
</jsp:include>

<div class="content-area">
    <div class="page-header d-flex justify-content-between align-items-center">
        <div>
            <h1 class="page-title">Sale Details</h1>
            <p class="page-subtitle"><%= sale != null ? sale.getInvoiceNumber() : "" %></p>
        </div>
        <a href="sales" class="btn btn-secondary">
            <i class="fas fa-arrow-left me-2"></i>Back to List
        </a>
    </div>

    <% if (sale != null) { %>
    <div class="row g-4">
        <!-- Sale Information Card -->
        <div class="col-md-4">
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0">Sale Information</h5>
                </div>
                <div class="card-body">
                    <table class="table table-borderless mb-0">
                        <tr>
                            <td class="text-muted">Invoice Number:</td>
                            <td><strong><%= sale.getInvoiceNumber() %></strong></td>
                        </tr>
                        <tr>
                            <td class="text-muted">Date:</td>
                            <td><%= sdf.format(sale.getSaleDate()) %></td>
                        </tr>
                        <tr>
                            <td class="text-muted">Sold By:</td>
                            <td><%= sale.getUserName() != null ? sale.getUserName() : "-" %></td>
                        </tr>
                        <tr>
                            <td class="text-muted">Payment Method:</td>
                            <td>
                                <span class="badge bg-<%= sale.getPaymentMethod().equals("cash") ? "success" : sale.getPaymentMethod().equals("card") ? "primary" : "info" %>">
                                    <%= sale.getPaymentMethod().toUpperCase() %>
                                </span>
                            </td>
                        </tr>
                        <tr>
                            <td class="text-muted">Payment Status:</td>
                            <td>
                                <span class="badge bg-success"><%= sale.getPaymentStatus().toUpperCase() %></span>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>

            <!-- Customer Information -->
            <div class="card mt-4">
                <div class="card-header">
                    <h5 class="mb-0">Customer Information</h5>
                </div>
                <div class="card-body">
                    <h6><%= sale.getCustomerName() %></h6>
                    <p class="text-muted small mb-0">
                        <i class="fas fa-phone me-1"></i>
                        <%= sale.getCustomerPhone() != null ? sale.getCustomerPhone() : "N/A" %>
                    </p>
                </div>
            </div>

            <!-- Notes -->
            <% if (sale.getNotes() != null && !sale.getNotes().isEmpty()) { %>
            <div class="card mt-4">
                <div class="card-header">
                    <h5 class="mb-0">Notes</h5>
                </div>
                <div class="card-body">
                    <p class="mb-0"><%= sale.getNotes() %></p>
                </div>
            </div>
            <% } %>

            <!-- Print Button -->
            <div class="card mt-4">
                <div class="card-body text-center">
                    <a href="sales?action=print&id=<%= sale.getSaleId() %>"
                       target="_blank"
                       class="btn btn-outline-primary w-100">
                        <i class="fas fa-print me-2"></i>Print Invoice
                    </a>
                </div>
            </div>
        </div>

        <!-- Sale Items Card -->
        <div class="col-md-8">
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0">Sale Items</h5>
                </div>
                <div class="card-body">
                    <% if (sale.getSaleItems() != null && !sale.getSaleItems().isEmpty()) { %>
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
                                for (SaleItem item : sale.getSaleItems()) {
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
                                <td colspan="4" class="text-end"><strong>Subtotal:</strong></td>
                                <td class="text-end"><strong>₹<%= String.format("%.2f", sale.getTotalAmount()) %></strong></td>
                            </tr>
                            <% if (sale.getDiscount() > 0) { %>
                            <tr>
                                <td colspan="4" class="text-end"><strong>Discount:</strong></td>
                                <td class="text-end text-danger"><strong>- ₹<%= String.format("%.2f", sale.getDiscount()) %></strong></td>
                            </tr>
                            <% } %>
                            <tr class="table-light">
                                <td colspan="4" class="text-end"><strong>Grand Total:</strong></td>
                                <td class="text-end">
                                    <h5 class="mb-0 text-primary">₹<%= String.format("%.2f", sale.getFinalAmount()) %></h5>
                                </td>
                            </tr>
                            </tfoot>
                        </table>
                    </div>
                    <% } else { %>
                    <p class="text-muted text-center py-4">No items in this sale</p>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
    <% } else { %>
    <div class="alert alert-warning">
        <i class="fas fa-exclamation-triangle me-2"></i>
        Sale not found.
    </div>
    <% } %>
</div>

<jsp:include page="includes/footer.jsp" />