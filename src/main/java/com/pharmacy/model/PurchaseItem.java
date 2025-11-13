package com.pharmacy.model;

/**
 * PurchaseItem Model Class
 * Represents purchase_items table in database
 */
public class PurchaseItem {
    private int purchaseItemId;
    private int poId;
    private int medicineId;
    private String medicineName; // For display
    private int quantity;
    private double unitPrice;
    private double subtotal;

    // Default Constructor
    public PurchaseItem() {
    }

    // Constructor with essential fields
    public PurchaseItem(int medicineId, String medicineName, int quantity, double unitPrice) {
        this.medicineId = medicineId;
        this.medicineName = medicineName;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.subtotal = quantity * unitPrice;
    }

    // Full Constructor
    public PurchaseItem(int poId, int medicineId, String medicineName, int quantity, double unitPrice, double subtotal) {
        this.poId = poId;
        this.medicineId = medicineId;
        this.medicineName = medicineName;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.subtotal = subtotal;
    }

    // Getters and Setters
    public int getPurchaseItemId() {
        return purchaseItemId;
    }

    public void setPurchaseItemId(int purchaseItemId) {
        this.purchaseItemId = purchaseItemId;
    }

    public int getPoId() {
        return poId;
    }

    public void setPoId(int poId) {
        this.poId = poId;
    }

    public int getMedicineId() {
        return medicineId;
    }

    public void setMedicineId(int medicineId) {
        this.medicineId = medicineId;
    }

    public String getMedicineName() {
        return medicineName;
    }

    public void setMedicineName(String medicineName) {
        this.medicineName = medicineName;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
        this.calculateSubtotal();
    }

    public double getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(double unitPrice) {
        this.unitPrice = unitPrice;
        this.calculateSubtotal();
    }

    public double getSubtotal() {
        return subtotal;
    }

    public void setSubtotal(double subtotal) {
        this.subtotal = subtotal;
    }

    // Helper method
    public void calculateSubtotal() {
        this.subtotal = this.quantity * this.unitPrice;
    }

    @Override
    public String toString() {
        return "PurchaseItem{" +
                "medicineId=" + medicineId +
                ", medicineName='" + medicineName + '\'' +
                ", quantity=" + quantity +
                ", subtotal=" + subtotal +
                '}';
    }
}