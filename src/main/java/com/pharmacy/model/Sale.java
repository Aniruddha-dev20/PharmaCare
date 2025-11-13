package com.pharmacy.model;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class Sale {
    private int saleId;
    private String invoiceNumber;
    private int userId;
    private String userName; // For display
    private int customerId;
    private String customerName;
    private String customerPhone;
    private double totalAmount;
    private double discount;
    private double finalAmount;
    private String paymentMethod;
    private String paymentStatus;
    private Timestamp saleDate;
    private String notes;
    private List<SaleItem> saleItems; // List of items in this sale

    public Sale() {
        this.saleItems = new ArrayList<>();
    }

    public Sale(String invoiceNumber, int userId, String customerName,
                String customerPhone, double totalAmount, double discount,
                double finalAmount, String paymentMethod) {
        this.invoiceNumber = invoiceNumber;
        this.userId = userId;
        this.customerName = customerName;
        this.customerPhone = customerPhone;
        this.totalAmount = totalAmount;
        this.discount = discount;
        this.finalAmount = finalAmount;
        this.paymentMethod = paymentMethod;
        this.saleItems = new ArrayList<>();
    }

    // Getters and Setters
    public int getSaleId() { return saleId; }
    public void setSaleId(int saleId) { this.saleId = saleId; }

    public String getInvoiceNumber() { return invoiceNumber; }
    public void setInvoiceNumber(String invoiceNumber) { this.invoiceNumber = invoiceNumber; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }

    public int getCustomerId() { return customerId; }
    public void setCustomerId(int customerId) { this.customerId = customerId; }

    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }

    public String getCustomerPhone() { return customerPhone; }
    public void setCustomerPhone(String customerPhone) { this.customerPhone = customerPhone; }

    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }

    public double getDiscount() { return discount; }
    public void setDiscount(double discount) { this.discount = discount; }

    public double getFinalAmount() { return finalAmount; }
    public void setFinalAmount(double finalAmount) { this.finalAmount = finalAmount; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public String getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }

    public Timestamp getSaleDate() { return saleDate; }
    public void setSaleDate(Timestamp saleDate) { this.saleDate = saleDate; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public List<SaleItem> getSaleItems() { return saleItems; }
    public void setSaleItems(List<SaleItem> saleItems) { this.saleItems = saleItems; }

    // Helper methods
    public void addSaleItem(SaleItem item) {
        this.saleItems.add(item);
    }

    public void calculateTotals() {
        this.totalAmount = 0;
        for (SaleItem item : saleItems) {
            this.totalAmount += item.getSubtotal();
        }
        this.finalAmount = this.totalAmount - this.discount;
    }

    public boolean isPaid() {
        return "paid".equalsIgnoreCase(this.paymentStatus);
    }

    @Override
    public String toString() {
        return "Sale{saleId=" + saleId + ", invoiceNumber='" + invoiceNumber +
                "', finalAmount=" + finalAmount + '}';
    }
}