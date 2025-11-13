package com.pharmacy.model;

import java.sql.Date;
import java.sql.Timestamp;

/**
 * Medicine Model Class
 * Represents medicines table in database
 * Used for inventory management
 */
public class Medicine {
    private int medicineId;
    private String medicineName;
    private String genericName;
    private String category;
    private int supplierId;
    private String supplierName; // For display purposes
    private double unitPrice;
    private double sellingPrice;
    private int stockQuantity;
    private int reorderLevel;
    private Date expiryDate;
    private Date manufactureDate;
    private String batchNumber;
    private String description;
    private String rackNumber;
    private String status; // available, out_of_stock, discontinued
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Default Constructor
    public Medicine() {
    }

    // Constructor for adding new medicine
    public Medicine(String medicineName, String genericName, String category,
                    int supplierId, double unitPrice, double sellingPrice,
                    int stockQuantity, int reorderLevel, Date expiryDate) {
        this.medicineName = medicineName;
        this.genericName = genericName;
        this.category = category;
        this.supplierId = supplierId;
        this.unitPrice = unitPrice;
        this.sellingPrice = sellingPrice;
        this.stockQuantity = stockQuantity;
        this.reorderLevel = reorderLevel;
        this.expiryDate = expiryDate;
    }

    // Full Constructor
    public Medicine(int medicineId, String medicineName, String genericName,
                    String category, int supplierId, double unitPrice,
                    double sellingPrice, int stockQuantity, int reorderLevel,
                    Date expiryDate, Date manufactureDate, String batchNumber,
                    String description, String rackNumber, String status) {
        this.medicineId = medicineId;
        this.medicineName = medicineName;
        this.genericName = genericName;
        this.category = category;
        this.supplierId = supplierId;
        this.unitPrice = unitPrice;
        this.sellingPrice = sellingPrice;
        this.stockQuantity = stockQuantity;
        this.reorderLevel = reorderLevel;
        this.expiryDate = expiryDate;
        this.manufactureDate = manufactureDate;
        this.batchNumber = batchNumber;
        this.description = description;
        this.rackNumber = rackNumber;
        this.status = status;
    }

    // Getters and Setters
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

    public String getGenericName() {
        return genericName;
    }

    public void setGenericName(String genericName) {
        this.genericName = genericName;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
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

    public double getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(double unitPrice) {
        this.unitPrice = unitPrice;
    }

    public double getSellingPrice() {
        return sellingPrice;
    }

    public void setSellingPrice(double sellingPrice) {
        this.sellingPrice = sellingPrice;
    }

    public int getStockQuantity() {
        return stockQuantity;
    }

    public void setStockQuantity(int stockQuantity) {
        this.stockQuantity = stockQuantity;
    }

    public int getReorderLevel() {
        return reorderLevel;
    }

    public void setReorderLevel(int reorderLevel) {
        this.reorderLevel = reorderLevel;
    }

    public Date getExpiryDate() {
        return expiryDate;
    }

    public void setExpiryDate(Date expiryDate) {
        this.expiryDate = expiryDate;
    }

    public Date getManufactureDate() {
        return manufactureDate;
    }

    public void setManufactureDate(Date manufactureDate) {
        this.manufactureDate = manufactureDate;
    }

    public String getBatchNumber() {
        return batchNumber;
    }

    public void setBatchNumber(String batchNumber) {
        this.batchNumber = batchNumber;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getRackNumber() {
        return rackNumber;
    }

    public void setRackNumber(String rackNumber) {
        this.rackNumber = rackNumber;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
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

    // Helper methods
    public boolean isLowStock() {
        return this.stockQuantity <= this.reorderLevel;
    }

    public boolean isOutOfStock() {
        return this.stockQuantity == 0;
    }

    public boolean isAvailable() {
        return "available".equalsIgnoreCase(this.status);
    }

    public double getProfit() {
        return this.sellingPrice - this.unitPrice;
    }

    public double getProfitMargin() {
        if (this.unitPrice == 0) return 0;
        return ((this.sellingPrice - this.unitPrice) / this.unitPrice) * 100;
    }

    public double getStockValue() {
        return this.stockQuantity * this.sellingPrice;
    }

    @Override
    public String toString() {
        return "Medicine{" +
                "medicineId=" + medicineId +
                ", medicineName='" + medicineName + '\'' +
                ", category='" + category + '\'' +
                ", stockQuantity=" + stockQuantity +
                ", sellingPrice=" + sellingPrice +
                ", status='" + status + '\'' +
                '}';
    }
}