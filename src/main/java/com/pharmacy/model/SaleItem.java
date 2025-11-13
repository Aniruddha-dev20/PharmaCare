package com.pharmacy.model;

public class SaleItem {
    private int saleItemId;
    private int saleId;
    private int medicineId;
    private String medicineName;
    private int quantity;
    private double unitPrice;
    private double subtotal;

    public SaleItem() {}

    public SaleItem(int medicineId, String medicineName, int quantity, double unitPrice) {
        this.medicineId = medicineId;
        this.medicineName = medicineName;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.subtotal = quantity * unitPrice;
    }

    public SaleItem(int saleId, int medicineId, String medicineName,
                    int quantity, double unitPrice, double subtotal) {
        this.saleId = saleId;
        this.medicineId = medicineId;
        this.medicineName = medicineName;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.subtotal = subtotal;
    }

    // Getters and Setters
    public int getSaleItemId() { return saleItemId; }
    public void setSaleItemId(int saleItemId) { this.saleItemId = saleItemId; }

    public int getSaleId() { return saleId; }
    public void setSaleId(int saleId) { this.saleId = saleId; }

    public int getMedicineId() { return medicineId; }
    public void setMedicineId(int medicineId) { this.medicineId = medicineId; }

    public String getMedicineName() { return medicineName; }
    public void setMedicineName(String medicineName) { this.medicineName = medicineName; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) {
        this.quantity = quantity;
        this.calculateSubtotal();
    }

    public double getUnitPrice() { return unitPrice; }
    public void setUnitPrice(double unitPrice) {
        this.unitPrice = unitPrice;
        this.calculateSubtotal();
    }

    public double getSubtotal() { return subtotal; }
    public void setSubtotal(double subtotal) { this.subtotal = subtotal; }

    // Helper method
    public void calculateSubtotal() {
        this.subtotal = this.quantity * this.unitPrice;
    }

    @Override
    public String toString() {
        return "SaleItem{medicineId=" + medicineId + ", medicineName='" + medicineName +
                "', quantity=" + quantity + ", subtotal=" + subtotal + '}';
    }
}