<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pharmacy.model.Sale" %>
<%@ page import="com.pharmacy.model.SaleItem" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
  Sale sale = (Sale) request.getAttribute("sale");
  SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy HH:mm");
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Invoice - <%= sale != null ? sale.getInvoiceNumber() : "" %></title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    @media print {
      .no-print { display: none; }
      body { margin: 0; padding: 20px; }
    }

    body {
      font-family: 'Courier New', monospace;
      background: white;
    }

    .invoice-container {
      max-width: 800px;
      margin: 20px auto;
      padding: 30px;
      border: 2px solid #333;
      background: white;
    }

    .invoice-header {
      text-align: center;
      border-bottom: 2px solid #333;
      padding-bottom: 20px;
      margin-bottom: 20px;
    }

    .invoice-header h1 {
      margin: 0;
      font-size: 32px;
      font-weight: bold;
    }

    .invoice-details {
      margin-bottom: 20px;
    }

    .invoice-table {
      width: 100%;
      border-collapse: collapse;
      margin-bottom: 20px;
    }

    .invoice-table th, .invoice-table td {
      border: 1px solid #333;
      padding: 8px;
      text-align: left;
    }

    .invoice-table th {
      background: #f0f0f0;
      font-weight: bold;
    }

    .text-right {
      text-align: right;
    }

    .total-section {
      float: right;
      width: 300px;
      margin-top: 20px;
    }

    .total-row {
      display: flex;
      justify-content: space-between;
      padding: 5px 0;
    }

    .grand-total {
      border-top: 2px solid #333;
      margin-top: 10px;
      padding-top: 10px;
      font-size: 18px;
      font-weight: bold;
    }

    .invoice-footer {
      clear: both;
      margin-top: 40px;
      padding-top: 20px;
      border-top: 2px solid #333;
      text-align: center;
    }
  </style>
</head>
<body>

<% if (sale != null) { %>
<div class="invoice-container">
  <!-- Header -->
  <div class="invoice-header">
    <h1>🏥 PHARMACARE</h1>
    <p style="margin: 5px 0;">Pharmacy Management System</p>
    <p style="margin: 5px 0;">Phone: +91-9876543210 | Email: info@pharmacare.com</p>
    <p style="margin: 5px 0;">Address: 123 Medical Lane, Mumbai, Maharashtra - 400001</p>
  </div>

  <!-- Invoice Details -->
  <div class="invoice-details row">
    <div class="col-6">
      <strong>BILL TO:</strong><br>
      <%= sale.getCustomerName() %><br>
      <% if (sale.getCustomerPhone() != null && !sale.getCustomerPhone().isEmpty()) { %>
      Phone: <%= sale.getCustomerPhone() %><br>
      <% } %>
    </div>
    <div class="col-6 text-end">
      <strong>INVOICE NO:</strong> <%= sale.getInvoiceNumber() %><br>
      <strong>DATE:</strong> <%= sdf.format(sale.getSaleDate()) %><br>
      <strong>CASHIER:</strong> <%= sale.getUserName() != null ? sale.getUserName() : "N/A" %><br>
    </div>
  </div>

  <!-- Items Table -->
  <table class="invoice-table">
    <thead>
    <tr>
      <th style="width: 50px;">#</th>
      <th>Medicine Name</th>
      <th style="width: 100px; text-align: center;">Qty</th>
      <th style="width: 120px; text-align: right;">Unit Price</th>
      <th style="width: 120px; text-align: right;">Amount</th>
    </tr>
    </thead>
    <tbody>
    <%
      int itemNo = 1;
      for (SaleItem item : sale.getSaleItems()) {
    %>
    <tr>
      <td><%= itemNo++ %></td>
      <td><%= item.getMedicineName() %></td>
      <td style="text-align: center;"><%= item.getQuantity() %></td>
      <td class="text-right">₹<%= String.format("%.2f", item.getUnitPrice()) %></td>
      <td class="text-right">₹<%= String.format("%.2f", item.getSubtotal()) %></td>
    </tr>
    <% } %>
    </tbody>
  </table>

  <!-- Totals -->
  <div class="total-section">
    <div class="total-row">
      <span>Subtotal:</span>
      <span>₹<%= String.format("%.2f", sale.getTotalAmount()) %></span>
    </div>
    <% if (sale.getDiscount() > 0) { %>
    <div class="total-row">
      <span>Discount:</span>
      <span>- ₹<%= String.format("%.2f", sale.getDiscount()) %></span>
    </div>
    <% } %>
    <div class="total-row grand-total">
      <span>GRAND TOTAL:</span>
      <span>₹<%= String.format("%.2f", sale.getFinalAmount()) %></span>
    </div>
    <div class="total-row" style="margin-top: 10px;">
      <span>Payment Method:</span>
      <span><%= sale.getPaymentMethod().toUpperCase() %></span>
    </div>
  </div>

  <!-- Footer -->
  <div class="invoice-footer">
    <p><strong>Thank you for your business!</strong></p>
    <p>** This is a computer-generated invoice **</p>
    <% if (sale.getNotes() != null && !sale.getNotes().isEmpty()) { %>
    <p style="margin-top: 10px;"><em>Note: <%= sale.getNotes() %></em></p>
    <% } %>
  </div>
</div>

<!-- Print Button -->
<div class="text-center no-print" style="margin: 20px;">
  <button onclick="window.print()" class="btn btn-primary btn-lg">
    <i class="fas fa-print"></i> Print Invoice
  </button>
  <button onclick="window.close()" class="btn btn-secondary btn-lg">
    Close
  </button>
</div>

<% } else { %>
<div class="alert alert-warning m-5">
  Invoice not found.
</div>
<% } %>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>