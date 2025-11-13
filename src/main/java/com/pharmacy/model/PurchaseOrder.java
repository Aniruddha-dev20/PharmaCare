package com.pharmacy.model;

import java.sql.Date;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 * PurchaseOrder Model Class
 * Represents purchase_orders table in database
 */
public class PurchaseOrder {
    private int poId;
    private String poNumber;
    private int supplierId;
    private String supplierName; // For display
    private int userId;
    private String userName; // For display
    private Date orderDate;
    private Date expectedDelivery;
    private double totalAmount;
    private String status; // pending, received, cancelled
    private String notes;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private List<PurchaseItem> purchaseItems;

    // Default Constructor
    public PurchaseOrder() {
        this.purchaseItems = new ArrayList<>();
    }

    // Constructor with essential fields
    public PurchaseOrder(String poNumber, int supplierId, int userId, Date orderDate, String status) {
        this.poNumber = poNumber;
        this.supplierId = supplierId;
        this.userId = userId;
        this.orderDate = orderDate;
        this.status = status;
        this.purchaseItems = new ArrayList<>();
    }

    // Getters and Setters
    public int getPoId() {
        return poId;
    }

    public void setPoId(int poId) {
        this.poId = poId;
    }

    public String getPoNumber() {
        return poNumber;
    }

    public void setPoNumber(String poNumber) {
        this.poNumber = poNumber;
    }

    public int getSupplierId() {
        return supplierId;
    }

    public void setSupplierId(int supplierId) {
        this.supplierId = supplierId;
    }

    public String getSupplierName() {
        return supplierName;
    }

    public void setSupplierName(String supplierName) {
        this.supplierName = supplierName;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public Date getOrderDate() {
        return orderDate;
    }

    public void setOrderDate(Date orderDate) {
        this.orderDate = orderDate;
    }

    public Date getExpectedDelivery() {
        return expectedDelivery;
    }

    public void setExpectedDelivery(Date expectedDelivery) {
        this.expectedDelivery = expectedDelivery;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    public List<PurchaseItem> getPurchaseItems() {
        return purchaseItems;
    }

    public void setPurchaseItems(List<PurchaseItem> purchaseItems) {
        this.purchaseItems = purchaseItems;
    }

    // Helper methods
    public void addPurchaseItem(PurchaseItem item) {
        this.purchaseItems.add(item);
    }

    public void calculateTotal() {
        this.totalAmount = 0;
        for (PurchaseItem item : purchaseItems) {
            this.totalAmount += item.getSubtotal();
        }
    }

    public boolean isPending() {
        return "pending".equalsIgnoreCase(this.status);
    }

    public boolean isReceived() {
        return "received".equalsIgnoreCase(this.status);
    }

    public boolean isCancelled() {
        return "cancelled".equalsIgnoreCase(this.status);
    }

    @Override
    public String toString() {
        return "PurchaseOrder{" +
                "poId=" + poId +
                ", poNumber='" + poNumber + '\'' +
                ", supplierName='" + supplierName + '\'' +
                ", totalAmount=" + totalAmount +
                ", status='" + status + '\'' +
                '}';
    }
}