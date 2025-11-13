package com.pharmacy.dao;

import com.pharmacy.model.DashboardStats;
import com.pharmacy.util.DBConnection;
import java.sql.*;

/**
 * DashboardDAO - Data Access Object for Dashboard Statistics
 * Fetches aggregated data for dashboard display
 */
public class DashboardDAO {

    /**
     * Get all dashboard statistics
     * @return DashboardStats object with all metrics
     */
    public DashboardStats getDashboardStats() {
        DashboardStats stats = new DashboardStats();
        Connection conn = null;
        CallableStatement cstmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();

            // Call stored procedure
            cstmt = conn.prepareCall("{CALL GetDashboardStats()}");
            rs = cstmt.executeQuery();

            if (rs.next()) {
                stats.setTotalStock(rs.getInt("total_stock"));
                stats.setTotalMedicines(rs.getInt("total_medicines"));
                stats.setTotalSuppliers(rs.getInt("total_suppliers"));
                stats.setTotalCustomers(rs.getInt("total_customers"));
                stats.setTotalPurchases(rs.getInt("total_purchases"));
                stats.setPurchaseAmount(rs.getDouble("purchase_amount"));
                stats.setTotalSales(rs.getInt("total_sales"));
                stats.setSalesAmount(rs.getDouble("sales_amount"));
                stats.setLowStockCount(rs.getInt("low_stock_count"));
                stats.setExpiringCount(rs.getInt("expiring_count"));
            }

            System.out.println("✓ Dashboard statistics retrieved");

        } catch (SQLException e) {
            System.err.println("Error getting dashboard stats: " + e.getMessage());
            e.printStackTrace();

            // Fallback: Get stats individually if stored procedure fails
            stats = getDashboardStatsManually(conn);
        } finally {
            closeResources(conn, cstmt, rs);
        }

        return stats;
    }

    /**
     * Manual method to get dashboard stats (fallback)
     * @param conn Database connection
     * @return DashboardStats object
     */
    private DashboardStats getDashboardStatsManually(Connection conn) {
        DashboardStats stats = new DashboardStats();
        Statement stmt = null;
        ResultSet rs = null;

        try {
            if (conn == null || conn.isClosed()) {
                conn = DBConnection.getConnection();
            }

            stmt = conn.createStatement();

            // Total Stock
            rs = stmt.executeQuery("SELECT SUM(stock_quantity) as total FROM medicines WHERE status = 'available'");
            if (rs.next()) stats.setTotalStock(rs.getInt("total"));
            rs.close();

            // Total Medicines
            rs = stmt.executeQuery("SELECT COUNT(*) as total FROM medicines WHERE status = 'available'");
            if (rs.next()) stats.setTotalMedicines(rs.getInt("total"));
            rs.close();

            // Total Suppliers
            rs = stmt.executeQuery("SELECT COUNT(*) as total FROM suppliers WHERE status = 'active'");
            if (rs.next()) stats.setTotalSuppliers(rs.getInt("total"));
            rs.close();

            // Total Customers
            rs = stmt.executeQuery("SELECT COUNT(*) as total FROM customers");
            if (rs.next()) stats.setTotalCustomers(rs.getInt("total"));
            rs.close();

            // Total Purchases
            rs = stmt.executeQuery("SELECT COUNT(*) as count, COALESCE(SUM(total_amount), 0) as amount FROM purchase_orders");
            if (rs.next()) {
                stats.setTotalPurchases(rs.getInt("count"));
                stats.setPurchaseAmount(rs.getDouble("amount"));
            }
            rs.close();

            // Total Sales
            rs = stmt.executeQuery("SELECT COUNT(*) as count, COALESCE(SUM(final_amount), 0) as amount FROM sales");
            if (rs.next()) {
                stats.setTotalSales(rs.getInt("count"));
                stats.setSalesAmount(rs.getDouble("amount"));
            }
            rs.close();

            // Low Stock Count
            rs = stmt.executeQuery("SELECT COUNT(*) as total FROM medicines WHERE stock_quantity <= reorder_level AND status = 'available'");
            if (rs.next()) stats.setLowStockCount(rs.getInt("total"));
            rs.close();

            // Expiring Count
            rs = stmt.executeQuery("SELECT COUNT(*) as total FROM medicines WHERE expiry_date <= DATE_ADD(CURDATE(), INTERVAL 30 DAY) AND expiry_date >= CURDATE() AND status = 'available'");
            if (rs.next()) stats.setExpiringCount(rs.getInt("total"));
            rs.close();

            System.out.println("✓ Dashboard statistics retrieved manually");

        } catch (SQLException e) {
            System.err.println("Error in manual dashboard stats: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return stats;
    }

    /**
     * Close database resources
     */
    private void closeResources(Connection conn, Statement stmt, ResultSet rs) {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) DBConnection.closeConnection(conn);
        } catch (SQLException e) {
            System.err.println("Error closing resources: " + e.getMessage());
        }
    }
}