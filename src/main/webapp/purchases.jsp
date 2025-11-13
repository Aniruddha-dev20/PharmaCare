<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pharmacy.model.PurchaseOrder" %>
<%@ page import="com.pharmacy.model.Medicine" %>
<%@ page import="com.pharmacy.model.Supplier" %>
<%@ page import="com.pharmacy.dao.MedicineDAO" %>
<%@ page import="com.pharmacy.dao.SupplierDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    List<PurchaseOrder> purchases = (List<PurchaseOrder>) request.getAttribute("purchases");
    SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy");

    MedicineDAO medicineDAO = new MedicineDAO();
    List<Medicine> availableMedicines = medicineDAO.getAllMedicines();

    SupplierDAO supplierDAO = new SupplierDAO();
    List<Supplier> suppliers = supplierDAO.getAllSuppliers();
%>

<jsp:include page="includes/header.jsp">
    <jsp:param name="title" value="Purchase Orders" />
</jsp:include>

<jsp:include page="includes/sidebar.jsp">
    <jsp:param name="active" value="purchases" />
</jsp:include>

<div class="content-area">
    <div class="page-header d-flex justify-content-between align-items-center">
        <div>
            <h1 class="page-title">Purchase Orders</h1>
            <p class="page-subtitle">Manage medicine purchase orders from suppliers</p>
        </div>
        <button type="button" class="btn btn-primary" onclick="openNewPurchaseModal()">
            <i class="fas fa-plus me-2"></i>New Purchase Order
        </button>
    </div>

    <% if (request.getParameter("success") != null) { %>
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        <i class="fas fa-check-circle me-2"></i>
        Purchase order created successfully!
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

    <div class="card">
        <div class="card-body">
            <% if (purchases != null && !purchases.isEmpty()) { %>
            <div class="table-responsive">
                <table class="table table-hover align-middle">
                    <thead class="table-light">
                    <tr>
                        <th>PO Number</th>
                        <th>Date</th>
                        <th>Supplier</th>
                        <th>Total Amount</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% for (PurchaseOrder po : purchases) { %>
                    <tr>
                        <td><strong><%= po.getPoNumber() %></strong></td>
                        <td><%= sdf.format(po.getOrderDate()) %></td>
                        <td><%= po.getSupplierName() %></td>
                        <td><strong>₹<%= String.format("%.2f", po.getTotalAmount()) %></strong></td>
                        <td>
                            <%
                                String statusClass = "";
                                switch(po.getStatus()) {
                                    case "pending": statusClass = "warning"; break;
                                    case "received": statusClass = "success"; break;
                                    case "cancelled": statusClass = "danger"; break;
                                    default: statusClass = "secondary";
                                }
                            %>
                            <span class="badge bg-<%= statusClass %>">
                <%= po.getStatus().toUpperCase() %>
              </span>
                        </td>
                        <td>
                            <div class="btn-group" role="group">
                                <a href="purchases?action=view&id=<%= po.getPoId() %>" class="btn btn-sm btn-outline-primary" title="View Details">
                                    <i class="fas fa-eye"></i>
                                </a>
                                <% if ("pending".equals(po.getStatus())) { %>
                                <a href="purchases?action=receive&id=<%= po.getPoId() %>" class="btn btn-sm btn-outline-success" title="Mark as Received" onclick="return confirm('Mark this purchase order as received?')">
                                    <i class="fas fa-check"></i>
                                </a>
                                <% } %>
                            </div>
                        </td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
            <% } else { %>
            <div class="text-center py-5">
                <i class="fas fa-shopping-basket fa-3x text-muted mb-3"></i>
                <p class="text-muted">No purchase orders found</p>
                <button type="button" class="btn btn-primary" onclick="openNewPurchaseModal()">
                    <i class="fas fa-plus me-2"></i>Create First Purchase Order
                </button>
            </div>
            <% } %>
        </div>
    </div>
</div>

<!-- New Purchase Order Modal -->
<div class="modal fade" id="newPurchaseModal" tabindex="-1">
    <div class="modal-dialog modal-xl">
        <div class="modal-content">
            <div class="modal-header">
                <div>
                    <h5 class="modal-title">New Purchase Order</h5>
                    <p class="text-muted mb-0 small">Create a new purchase order for medicines</p>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form id="newPurchaseForm" action="purchases" method="post">
                <input type="hidden" name="action" value="create">
                <div class="modal-body">
                    <div class="row g-3 mb-4">
                        <div class="col-md-6">
                            <label for="supplierId" class="form-label">Supplier <span class="text-danger">*</span></label>
                            <select class="form-select" id="supplierId" name="supplierId" required>
                                <option value="">Select supplier</option>
                                <% if (suppliers != null) {
                                    for (Supplier supplier : suppliers) { %>
                                <option value="<%= supplier.getSupplierId() %>"><%= supplier.getSupplierName() %> - <%= supplier.getContactPerson() %></option>
                                <%   }
                                } %>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label for="expectedDelivery" class="form-label">Expected Delivery Date</label>
                            <input type="date" class="form-control" id="expectedDelivery" name="expectedDelivery">
                        </div>
                    </div>
                    <div class="mb-3">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h6 class="mb-0">Items</h6>
                            <button type="button" class="btn btn-primary btn-sm" onclick="addPurchaseItem()">
                                <i class="fas fa-plus me-1"></i> Add Item
                            </button>
                        </div>
                        <div id="purchaseItemsContainer">
                            <div class="text-center py-4 text-muted" id="noPurchaseItemsMessage">
                                No items added. Click "Add Item" to start.
                            </div>
                        </div>
                    </div>
                    <div class="row justify-content-end">
                        <div class="col-md-6">
                            <div class="card bg-light">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-center mb-2">
                                        <span>Subtotal:</span>
                                        <strong id="purchaseSubtotalDisplay">₹0.00</strong>
                                    </div>
                                    <div class="d-flex justify-content-between align-items-center mb-2">
                                        <span>Tax (GST):</span>
                                        <div class="input-group input-group-sm" style="width: 150px;">
                                            <input type="number" class="form-control" id="taxPercent" name="taxPercent" value="0" min="0" max="100" step="0.01" onchange="calculatePurchaseTotal()">
                                            <span class="input-group-text">%</span>
                                        </div>
                                    </div>
                                    <div class="d-flex justify-content-between align-items-center mb-2">
                                        <span>Tax Amount:</span>
                                        <strong id="taxAmountDisplay">₹0.00</strong>
                                    </div>
                                    <hr>
                                    <div class="d-flex justify-content-between align-items-center">
                                        <strong>Total Amount:</strong>
                                        <h4 class="mb-0" id="purchaseTotalDisplay">₹0.00</h4>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row g-3 mt-3">
                        <div class="col-md-12">
                            <label for="purchaseNotes" class="form-label">Notes (Optional)</label>
                            <textarea class="form-control" id="purchaseNotes" name="notes" rows="2"></textarea>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary" id="createPurchaseBtn" disabled>Create Purchase Order</button>
                </div>
            </form>
        </div>
    </div>
</div>

<style>
    .purchase-item-row {
        background: #f8f9fa;
        padding: 15px;
        border-radius: 10px;
        margin-bottom: 10px;
        border: 1px solid #dee2e6;
    }
</style>

<script>
    let purchaseItemCounter = 0;
    let purchaseModal;

    // Store medicine options - Generated from JSP
    const medicineOptionsList = [
        <% if (availableMedicines != null) {
            for (int i = 0; i < availableMedicines.size(); i++) {
                Medicine med = availableMedicines.get(i); %>
        {id: <%= med.getMedicineId() %>, name: '<%= med.getMedicineName().replace("'", "\\'") %>', currentStock: <%= med.getStockQuantity() %>}<%= i < availableMedicines.size() - 1 ? "," : "" %>
        <%      }
        } %>
    ];

    document.addEventListener('DOMContentLoaded', function() {
        purchaseModal = new bootstrap.Modal(document.getElementById('newPurchaseModal'));
    });

    function openNewPurchaseModal() {
        if (purchaseModal) {
            purchaseModal.show();
        } else {
            purchaseModal = new bootstrap.Modal(document.getElementById('newPurchaseModal'));
            purchaseModal.show();
        }
    }

    function getMedicineOptionsHTML() {
        let options = '';
        medicineOptionsList.forEach(med => {
            options += '<option value="' + med.id + '">' +
                med.name + ' (Current Stock: ' + med.currentStock + ')</option>';
        });
        return options;
    }

    function addPurchaseItem() {
        purchaseItemCounter++;
        const noItemsMsg = document.getElementById('noPurchaseItemsMessage');
        if (noItemsMsg) noItemsMsg.style.display = 'none';

        const itemsContainer = document.getElementById('purchaseItemsContainer');
        const itemRow = document.createElement('div');
        itemRow.className = 'purchase-item-row';
        itemRow.id = 'purchaseItem-' + purchaseItemCounter;

        // Build HTML without template literals to avoid JSP conflicts
        let html = '<div class="row g-3 align-items-end">';
        html += '<div class="col-md-4">';
        html += '<label class="form-label small">Medicine</label>';
        html += '<select class="form-select" name="medicineId[]" required>';
        html += '<option value="">Select medicine</option>';
        html += getMedicineOptionsHTML();
        html += '</select>';
        html += '</div>';
        html += '<div class="col-md-2">';
        html += '<label class="form-label small">Quantity</label>';
        html += '<input type="number" class="form-control" name="quantity[]" value="1" min="1" onchange="calculatePurchaseItemTotal(' + purchaseItemCounter + ')" required>';
        html += '</div>';
        html += '<div class="col-md-2">';
        html += '<label class="form-label small">Unit Cost (₹)</label>';
        html += '<input type="number" class="form-control" name="unitCost[]" id="unitCost-' + purchaseItemCounter + '" value="0" min="0" step="0.01" onchange="calculatePurchaseItemTotal(' + purchaseItemCounter + ')" required>';
        html += '</div>';
        html += '<div class="col-md-2">';
        html += '<label class="form-label small">Total</label>';
        html += '<input type="text" class="form-control" id="purchaseItemTotal-' + purchaseItemCounter + '" readonly value="₹0.00">';
        html += '</div>';
        html += '<div class="col-md-2 text-end">';
        html += '<label class="form-label small d-block">&nbsp;</label>';
        html += '<button type="button" class="btn btn-sm btn-outline-danger" onclick="removePurchaseItem(' + purchaseItemCounter + ')"><i class="fas fa-trash"></i> Remove</button>';
        html += '</div>';
        html += '</div>';

        itemRow.innerHTML = html;
        itemsContainer.appendChild(itemRow);
        updateCreatePurchaseButton();
    }

    function calculatePurchaseItemTotal(itemId) {
        const quantity = parseFloat(document.querySelector('#purchaseItem-' + itemId + ' input[name="quantity[]"]').value) || 0;
        const unitCost = parseFloat(document.getElementById('unitCost-' + itemId).value) || 0;

        const total = quantity * unitCost;
        document.getElementById('purchaseItemTotal-' + itemId).value = '₹' + total.toFixed(2);
        calculatePurchaseTotal();
    }

    function removePurchaseItem(itemId) {
        document.getElementById('purchaseItem-' + itemId).remove();
        calculatePurchaseTotal();
        updateCreatePurchaseButton();

        const itemsContainer = document.getElementById('purchaseItemsContainer');
        if (itemsContainer.children.length === 0) {
            itemsContainer.innerHTML = '<div class="text-center py-4 text-muted" id="noPurchaseItemsMessage">No items added. Click "Add Item" to start.</div>';
        }
    }

    function calculatePurchaseTotal() {
        let subtotal = 0;
        document.querySelectorAll('[id^="purchaseItemTotal-"]').forEach(input => {
            const value = input.value.replace('₹', '').replace(',', '');
            subtotal += parseFloat(value) || 0;
        });

        const taxPercent = parseFloat(document.getElementById('taxPercent').value) || 0;
        const taxAmount = (subtotal * taxPercent) / 100;
        const total = subtotal + taxAmount;

        document.getElementById('purchaseSubtotalDisplay').textContent = '₹' + subtotal.toFixed(2);
        document.getElementById('taxAmountDisplay').textContent = '₹' + taxAmount.toFixed(2);
        document.getElementById('purchaseTotalDisplay').textContent = '₹' + total.toFixed(2);
    }

    function updateCreatePurchaseButton() {
        const itemsCount = document.querySelectorAll('.purchase-item-row').length;
        document.getElementById('createPurchaseBtn').disabled = itemsCount === 0;
    }

    document.getElementById('newPurchaseForm').addEventListener('submit', function(e) {
        const itemsCount = document.querySelectorAll('.purchase-item-row').length;
        if (itemsCount === 0) {
            e.preventDefault();
            alert('Please add at least one item to the purchase order');
            return false;
        }

        const supplierId = document.getElementById('supplierId').value;
        if (!supplierId) {
            e.preventDefault();
            alert('Please select a supplier');
            return false;
        }
    });
</script>

<jsp:include page="includes/footer.jsp" />