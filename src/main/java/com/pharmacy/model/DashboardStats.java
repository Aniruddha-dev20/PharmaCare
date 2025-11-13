package com.pharmacy.model;

public class DashboardStats {
    private int totalStock;
    private int totalMedicines;
    private int totalSuppliers;
    private int totalCustomers;
    private int totalPurchases;
    private double purchaseAmount;
    private int totalSales;
    private double salesAmount;
    private int lowStockCount;
    private int expiringCount;

    public DashboardStats() {}

    // Getters and Setters
    public int getTotalStock() { return totalStock; }
    public void setTotalStock(int totalStock) { this.totalStock = totalStock; }

    public int getTotalMedicines() { return totalMedicines; }
    public void setTotalMedicines(int totalMedicines) { this.totalMedicines = totalMedicines; }

    public int getTotalSuppliers() { return totalSuppliers; }
    public void setTotalSuppliers(int totalSuppliers) { this.totalSuppliers = totalSuppliers; }

    public int getTotalCustomers() { return totalCustomers; }
    public void setTotalCustomers(int totalCustomers) { this.totalCustomers = totalCustomers; }

    public int getTotalPurchases() { return totalPurchases; }
    public void setTotalPurchases(int totalPurchases) { this.totalPurchases = totalPurchases; }

    public double getPurchaseAmount() { return purchaseAmount; }
    public void setPurchaseAmount(double purchaseAmount) { this.purchaseAmount = purchaseAmount; }

    public int getTotalSales() { return totalSales; }
    public void setTotalSales(int totalSales) { this.totalSales = totalSales; }

    public double getSalesAmount() { return salesAmount; }
    public void setSalesAmount(double salesAmount) { this.salesAmount = salesAmount; }

    public int getLowStockCount() { return lowStockCount; }
    public void setLowStockCount(int lowStockCount) { this.lowStockCount = lowStockCount; }

    public int getExpiringCount() { return expiringCount; }
    public void setExpiringCount(int expiringCount) { this.expiringCount = expiringCount; }

    @Override
    public String toString() {
        return "DashboardStats{totalMedicines=" + totalMedicines +
                ", totalSales=" + totalSales + ", salesAmount=" + salesAmount + '}';
    }
}