<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pharmacy.model.Sale" %>
<%@ page import="com.pharmacy.model.Medicine" %>
<%@ page import="com.pharmacy.dao.MedicineDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>


<%
    List<Sale> sales = (List<Sale>) request.getAttribute("sales");
    SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy HH:mm");

    MedicineDAO medicineDAO = new MedicineDAO();
    List<Medicine> availableMedicines = medicineDAO.getAllMedicines();
%>

<jsp:include page="includes/header.jsp">
    <jsp:param name="title" value="Sales" />
</jsp:include>

<jsp:include page="includes/sidebar.jsp">
    <jsp:param name="active" value="sales" />
</jsp:include>

<div class="content-area">
    <div class="page-header d-flex justify-content-between align-items-center">
        <div>
            <h1 class="page-title">Sales</h1>
            <p class="page-subtitle">Create and manage sales invoices</p>
        </div>
        <button type="button" class="btn btn-primary" onclick="openNewSaleModal()">
            <i class="fas fa-plus me-2"></i>New Sale
        </button>
    </div>

    <% if (request.getParameter("success") != null) { %>
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        <i class="fas fa-check-circle me-2"></i>
        Sale completed successfully!
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
            <% if (sales != null && !sales.isEmpty()) { %>
            <div class="table-responsive">
                <table class="table table-hover align-middle">
                    <thead class="table-light">
                    <tr>
                        <th>Invoice ID</th>
                        <th>Date</th>
                        <th>Customer Name</th>
                        <th>Phone</th>
                        <th>Total Amount</th>
                        <th>Payment</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% for (Sale sale : sales) { %>
                    <tr>
                        <td><strong><%= sale.getInvoiceNumber() %></strong></td>
                        <td><%= sdf.format(sale.getSaleDate()) %></td>
                        <td><%= sale.getCustomerName() %></td>
                        <td><%= sale.getCustomerPhone() %></td>
                        <td><strong>₹<%= String.format("%.2f", sale.getFinalAmount()) %></strong></td>
                        <td>
              <span class="badge bg-<%= sale.getPaymentMethod().equals("cash") ? "success" : sale.getPaymentMethod().equals("card") ? "primary" : "info" %>">
                <%= sale.getPaymentMethod().toUpperCase() %>
              </span>
                        </td>
                        <td>
                            <div class="btn-group" role="group">
                                <a href="sales?action=view&id=<%= sale.getSaleId() %>" class="btn btn-sm btn-outline-primary" title="View Details">
                                    <i class="fas fa-eye"></i>
                                </a>
                                <a href="sales?action=print&id=<%= sale.getSaleId() %>" class="btn btn-sm btn-outline-secondary" title="Print Invoice" target="_blank">
                                    <i class="fas fa-print"></i>
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
                <i class="fas fa-shopping-cart fa-3x text-muted mb-3"></i>
                <p class="text-muted">No sales records found</p>
                <button type="button" class="btn btn-primary" onclick="openNewSaleModal()">
                    <i class="fas fa-plus me-2"></i>Create First Sale
                </button>
            </div>
            <% } %>
        </div>
    </div>
</div>

<!-- New Sale Modal -->
<div class="modal fade" id="newSaleModal" tabindex="-1">
    <div class="modal-dialog modal-xl">
        <div class="modal-content">
            <div class="modal-header">
                <div>
                    <h5 class="modal-title">New Sale</h5>
                    <p class="text-muted mb-0 small">Create a new invoice for a customer</p>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form id="newSaleForm" action="sales" method="post">
                <input type="hidden" name="action" value="create">
                <div class="modal-body">
                    <div class="row g-3 mb-4">
                        <div class="col-md-6">
                            <label for="customerName" class="form-label">Customer Name <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="customerName" name="customerName" required>
                        </div>
                        <div class="col-md-6">
                            <label for="customerPhone" class="form-label">Phone Number</label>
                            <input type="tel" class="form-control" id="customerPhone" name="customerPhone" pattern="[0-9]{10}">
                        </div>
                    </div>
                    <div class="mb-3">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h6 class="mb-0">Items</h6>
                            <button type="button" class="btn btn-primary btn-sm" onclick="addItem()">
                                <i class="fas fa-plus me-1"></i> Add Item
                            </button>
                        </div>
                        <div id="itemsContainer">
                            <div class="text-center py-4 text-muted" id="noItemsMessage">
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
                                        <strong id="subtotalDisplay">₹0.00</strong>
                                    </div>
                                    <div class="d-flex justify-content-between align-items-center mb-2">
                                        <span>Discount:</span>
                                        <div class="input-group input-group-sm" style="width: 150px;">
                                            <span class="input-group-text">₹</span>
                                            <input type="number" class="form-control" id="discount" name="discount" value="0" min="0" step="0.01" onchange="calculateTotal()">
                                        </div>
                                    </div>
                                    <hr>
                                    <div class="d-flex justify-content-between align-items-center">
                                        <strong>Total Amount:</strong>
                                        <h4 class="mb-0" id="totalDisplay">₹0.00</h4>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row g-3 mt-3">
                        <div class="col-md-6">
                            <label for="paymentMethod" class="form-label">Payment Method</label>
                            <select class="form-select" id="paymentMethod" name="paymentMethod" required>
                                <option value="cash" selected>Cash</option>
                                <option value="card">Card</option>
                                <option value="upi">UPI</option>
                                <option value="other">Other</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label for="notes" class="form-label">Notes (Optional)</label>
                            <input type="text" class="form-control" id="notes" name="notes">
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary" id="completeSaleBtn" disabled>Complete Sale</button>
                </div>
            </form>
        </div>
    </div>
</div>

<style>
    .item-row { background: #f8f9fa; padding: 15px; border-radius: 10px; margin-bottom: 10px; border: 1px solid #dee2e6; }
</style>

<script>
    let itemCounter = 0;
    let saleModal;

    // Store medicine options
    const medicineOptions = [
        <% if (availableMedicines != null) {
            for (int i = 0; i < availableMedicines.size(); i++) {
                Medicine med = availableMedicines.get(i);
                if ("available".equals(med.getStatus()) && med.getStockQuantity() > 0) { %>
        {id: <%= med.getMedicineId() %>, name: '<%= med.getMedicineName().replace("'", "\\'") %>', price: <%= med.getSellingPrice() %>, stock: <%= med.getStockQuantity() %>}<%= i < availableMedicines.size() - 1 ? "," : "" %>
        <%      }
            }
        } %>
    ];

    document.addEventListener('DOMContentLoaded', function() {
        saleModal = new bootstrap.Modal(document.getElementById('newSaleModal'));
    });

    function openNewSaleModal() {
        if (saleModal) {
            saleModal.show();
        } else {
            saleModal = new bootstrap.Modal(document.getElementById('newSaleModal'));
            saleModal.show();
        }
    }

    function getMedicineOptions() {
        let options = '';
        medicineOptions.forEach(med => {
            options += '<option value="' + med.id + '" data-price="' + med.price + '" data-stock="' + med.stock + '">' +
                med.name + ' - ₹' + med.price.toFixed(2) + ' (Stock: ' + med.stock + ')</option>';
        });
        return options;
    }

    function addItem() {
        itemCounter++;
        const noItemsMsg = document.getElementById('noItemsMessage');
        if (noItemsMsg) noItemsMsg.style.display = 'none';

        const itemsContainer = document.getElementById('itemsContainer');
        const itemRow = document.createElement('div');
        itemRow.className = 'item-row';
        itemRow.id = 'item-' + itemCounter;

        itemRow.innerHTML =
            '<div class="row g-3 align-items-end">' +
            '<div class="col-md-5">' +
            '<label class="form-label small">Medicine</label>' +
            '<select class="form-select" name="medicineId[]" onchange="updatePrice(' + itemCounter + ')" required>' +
            '<option value="">Select medicine</option>' +
            getMedicineOptions() +
            '</select>' +
            '</div>' +
            '<div class="col-md-2">' +
            '<label class="form-label small">Quantity</label>' +
            '<input type="number" class="form-control" name="quantity[]" value="1" min="1" onchange="calculateItemTotal(' + itemCounter + ')" required>' +
            '</div>' +
            '<div class="col-md-2">' +
            '<label class="form-label small">Price</label>' +
            '<input type="text" class="form-control" id="price-' + itemCounter + '" readonly value="₹0.00">' +
            '<input type="hidden" id="unitPrice-' + itemCounter + '" name="unitPrice[]" value="0">' +
            '</div>' +
            '<div class="col-md-2">' +
            '<label class="form-label small">Total</label>' +
            '<input type="text" class="form-control" id="itemTotal-' + itemCounter + '" readonly value="₹0.00">' +
            '</div>' +
            '<div class="col-md-1 text-end">' +
            '<button type="button" class="btn btn-sm btn-outline-danger" onclick="removeItem(' + itemCounter + ')"><i class="fas fa-trash"></i></button>' +
            '</div>' +
            '</div>';

        itemsContainer.appendChild(itemRow);
        updateCompleteSaleButton();
    }

    function updatePrice(itemId) {
        const select = document.querySelector('#item-' + itemId + ' select[name="medicineId[]"]');
        const selectedOption = select.options[select.selectedIndex];
        const price = selectedOption.getAttribute('data-price') || 0;
        const stock = selectedOption.getAttribute('data-stock') || 0;

        document.getElementById('unitPrice-' + itemId).value = price;
        document.getElementById('price-' + itemId).value = '₹' + parseFloat(price).toFixed(2);

        const qtyInput = document.querySelector('#item-' + itemId + ' input[name="quantity[]"]');
        qtyInput.setAttribute('max', stock);
        calculateItemTotal(itemId);
    }

    function calculateItemTotal(itemId) {
        const quantity = parseFloat(document.querySelector('#item-' + itemId + ' input[name="quantity[]"]').value) || 0;
        const unitPrice = parseFloat(document.getElementById('unitPrice-' + itemId).value) || 0;
        const maxStock = parseFloat(document.querySelector('#item-' + itemId + ' input[name="quantity[]"]').getAttribute('max')) || 999;

        if (quantity > maxStock) {
            alert('Only ' + maxStock + ' units available!');
            document.querySelector('#item-' + itemId + ' input[name="quantity[]"]').value = maxStock;
            return;
        }

        const total = quantity * unitPrice;
        document.getElementById('itemTotal-' + itemId).value = '₹' + total.toFixed(2);
        calculateTotal();
    }

    function removeItem(itemId) {
        document.getElementById('item-' + itemId).remove();
        calculateTotal();
        updateCompleteSaleButton();

        const itemsContainer = document.getElementById('itemsContainer');
        if (itemsContainer.children.length === 0) {
            itemsContainer.innerHTML = '<div class="text-center py-4 text-muted" id="noItemsMessage">No items added. Click "Add Item" to start.</div>';
        }
    }

    function calculateTotal() {
        let subtotal = 0;
        document.querySelectorAll('[id^="itemTotal-"]').forEach(input => {
            const value = input.value.replace('₹', '').replace(',', '');
            subtotal += parseFloat(value) || 0;
        });

        const discount = parseFloat(document.getElementById('discount').value) || 0;
        const total = subtotal - discount;

        document.getElementById('subtotalDisplay').textContent = '₹' + subtotal.toFixed(2);
        document.getElementById('totalDisplay').textContent = '₹' + total.toFixed(2);
    }

    function updateCompleteSaleButton() {
        const itemsCount = document.querySelectorAll('.item-row').length;
        document.getElementById('completeSaleBtn').disabled = itemsCount === 0;
    }

    document.getElementById('newSaleForm').addEventListener('submit', function(e) {
        const itemsCount = document.querySelectorAll('.item-row').length;
        if (itemsCount === 0) {
            e.preventDefault();
            alert('Please add at least one item to the sale');
            return false;
        }
    });
</script>

<jsp:include page="includes/footer.jsp" />