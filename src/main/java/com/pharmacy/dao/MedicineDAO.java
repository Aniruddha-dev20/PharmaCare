package com.pharmacy.dao;

import com.pharmacy.model.Medicine;
import com.pharmacy.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * MedicineDAO - Data Access Object for Medicine operations
 * Handles all database operations related to medicines
 */
public class MedicineDAO {

    /**
     * Get all medicines
     * @return List of all medicines
     */
    public List<Medicine> getAllMedicines() {
        List<Medicine> medicines = new ArrayList<>();
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;

        String sql = "SELECT m.*, s.supplier_name " +
                "FROM medicines m " +
                "LEFT JOIN suppliers s ON m.supplier_id = s.supplier_id " +
                "ORDER BY m.medicine_name";

        try {
            conn = DBConnection.getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);

            while (rs.next()) {
                medicines.add(extractMedicineFromResultSet(rs));
            }

            System.out.println("✓ Retrieved " + medicines.size() + " medicines");

        } catch (SQLException e) {
            System.err.println("Error getting medicines: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, rs);
        }

        return medicines;
    }

    /**
     * Get medicine by ID
     * @param medicineId Medicine ID
     * @return Medicine object
     */
    public Medicine getMedicineById(int medicineId) {
        Medicine medicine = null;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql = "SELECT m.*, s.supplier_name " +
                "FROM medicines m " +
                "LEFT JOIN suppliers s ON m.supplier_id = s.supplier_id " +
                "WHERE m.medicine_id = ?";

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, medicineId);

            rs = pstmt.executeQuery();

            if (rs.next()) {
                medicine = extractMedicineFromResultSet(rs);
            }

        } catch (SQLException e) {
            System.err.println("Error getting medicine by ID: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, rs);
        }

        return medicine;
    }

    /**
     * Search medicines by name
     * @param searchTerm Search term
     * @return List of matching medicines
     */
    public List<Medicine> searchMedicines(String searchTerm) {
        List<Medicine> medicines = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql = "SELECT m.*, s.supplier_name " +
                "FROM medicines m " +
                "LEFT JOIN suppliers s ON m.supplier_id = s.supplier_id " +
                "WHERE m.medicine_name LIKE ? OR m.generic_name LIKE ? " +
                "ORDER BY m.medicine_name";

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            String search = "%" + searchTerm + "%";
            pstmt.setString(1, search);
            pstmt.setString(2, search);

            rs = pstmt.executeQuery();

            while (rs.next()) {
                medicines.add(extractMedicineFromResultSet(rs));
            }

            System.out.println("✓ Found " + medicines.size() + " medicines for: " + searchTerm);

        } catch (SQLException e) {
            System.err.println("Error searching medicines: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, rs);
        }

        return medicines;
    }

    /**
     * Add new medicine
     * @param medicine Medicine object
     * @return true if successful, false otherwise
     */
    public boolean addMedicine(Medicine medicine) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        String sql = "INSERT INTO medicines (medicine_name, generic_name, category, supplier_id, " +
                "unit_price, selling_price, stock_quantity, reorder_level, expiry_date, " +
                "manufacture_date, batch_number, description, rack_number, status) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, medicine.getMedicineName());
            pstmt.setString(2, medicine.getGenericName());
            pstmt.setString(3, medicine.getCategory());
            pstmt.setInt(4, medicine.getSupplierId());
            pstmt.setDouble(5, medicine.getUnitPrice());
            pstmt.setDouble(6, medicine.getSellingPrice());
            pstmt.setInt(7, medicine.getStockQuantity());
            pstmt.setInt(8, medicine.getReorderLevel());
            pstmt.setDate(9, medicine.getExpiryDate());
            pstmt.setDate(10, medicine.getManufactureDate());
            pstmt.setString(11, medicine.getBatchNumber());
            pstmt.setString(12, medicine.getDescription());
            pstmt.setString(13, medicine.getRackNumber());
            pstmt.setString(14, "available");

            int rows = pstmt.executeUpdate();

            if (rows > 0) {
                System.out.println("✓ Medicine added: " + medicine.getMedicineName());
                return true;
            }

        } catch (SQLException e) {
            System.err.println("Error adding medicine: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, null);
        }

        return false;
    }

    /**
     * Update medicine
     * @param medicine Medicine object with updated information
     * @return true if successful, false otherwise
     */
    public boolean updateMedicine(Medicine medicine) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        String sql = "UPDATE medicines SET medicine_name = ?, generic_name = ?, category = ?, " +
                "supplier_id = ?, unit_price = ?, selling_price = ?, stock_quantity = ?, " +
                "reorder_level = ?, expiry_date = ?, manufacture_date = ?, batch_number = ?, " +
                "description = ?, rack_number = ?, status = ? WHERE medicine_id = ?";

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, medicine.getMedicineName());
            pstmt.setString(2, medicine.getGenericName());
            pstmt.setString(3, medicine.getCategory());
            pstmt.setInt(4, medicine.getSupplierId());
            pstmt.setDouble(5, medicine.getUnitPrice());
            pstmt.setDouble(6, medicine.getSellingPrice());
            pstmt.setInt(7, medicine.getStockQuantity());
            pstmt.setInt(8, medicine.getReorderLevel());
            pstmt.setDate(9, medicine.getExpiryDate());
            pstmt.setDate(10, medicine.getManufactureDate());
            pstmt.setString(11, medicine.getBatchNumber());
            pstmt.setString(12, medicine.getDescription());
            pstmt.setString(13, medicine.getRackNumber());
            pstmt.setString(14, medicine.getStatus());
            pstmt.setInt(15, medicine.getMedicineId());

            int rows = pstmt.executeUpdate();

            if (rows > 0) {
                System.out.println("✓ Medicine updated: " + medicine.getMedicineName());
                return true;
            }

        } catch (SQLException e) {
            System.err.println("Error updating medicine: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, null);
        }

        return false;
    }

    /**
     * Delete medicine
     * @param medicineId Medicine ID
     * @return true if successful, false otherwise
     */
    public boolean deleteMedicine(int medicineId) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        String sql = "DELETE FROM medicines WHERE medicine_id = ?";

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, medicineId);

            int rows = pstmt.executeUpdate();

            if (rows > 0) {
                System.out.println("✓ Medicine deleted successfully");
                return true;
            }

        } catch (SQLException e) {
            System.err.println("Error deleting medicine: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, null);
        }

        return false;
    }

    /**
     * Update medicine stock
     * @param medicineId Medicine ID
     * @param quantity Quantity to add (positive) or subtract (negative)
     * @return true if successful, false otherwise
     */
    public boolean updateStock(int medicineId, int quantity) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        String sql = "UPDATE medicines SET stock_quantity = stock_quantity + ? WHERE medicine_id = ?";

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, quantity);
            pstmt.setInt(2, medicineId);

            int rows = pstmt.executeUpdate();

            if (rows > 0) {
                System.out.println("✓ Stock updated for medicine ID: " + medicineId);
                return true;
            }

        } catch (SQLException e) {
            System.err.println("Error updating stock: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, null);
        }

        return false;
    }

    /**
     * Get low stock medicines
     * @return List of medicines with stock below reorder level
     */
    public List<Medicine> getLowStockMedicines() {
        List<Medicine> medicines = new ArrayList<>();
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;

        String sql = "SELECT m.*, s.supplier_name " +
                "FROM medicines m " +
                "LEFT JOIN suppliers s ON m.supplier_id = s.supplier_id " +
                "WHERE m.stock_quantity <= m.reorder_level AND m.status = 'available' " +
                "ORDER BY m.stock_quantity";

        try {
            conn = DBConnection.getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);

            while (rs.next()) {
                medicines.add(extractMedicineFromResultSet(rs));
            }

        } catch (SQLException e) {
            System.err.println("Error getting low stock medicines: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, rs);
        }

        return medicines;
    }

    /**
     * Get expiring medicines (within 30 days)
     * @return List of expiring medicines
     */
    public List<Medicine> getExpiringMedicines() {
        List<Medicine> medicines = new ArrayList<>();
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;

        String sql = "SELECT m.*, s.supplier_name " +
                "FROM medicines m " +
                "LEFT JOIN suppliers s ON m.supplier_id = s.supplier_id " +
                "WHERE m.expiry_date <= DATE_ADD(CURDATE(), INTERVAL 30 DAY) " +
                "AND m.expiry_date >= CURDATE() AND m.status = 'available' " +
                "ORDER BY m.expiry_date";

        try {
            conn = DBConnection.getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);

            while (rs.next()) {
                medicines.add(extractMedicineFromResultSet(rs));
            }

        } catch (SQLException e) {
            System.err.println("Error getting expiring medicines: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, rs);
        }

        return medicines;
    }

    /**
     * Get medicines by category
     * @param category Category name
     * @return List of medicines in that category
     */
    public List<Medicine> getMedicinesByCategory(String category) {
        List<Medicine> medicines = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql = "SELECT m.*, s.supplier_name " +
                "FROM medicines m " +
                "LEFT JOIN suppliers s ON m.supplier_id = s.supplier_id " +
                "WHERE m.category = ? ORDER BY m.medicine_name";

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, category);

            rs = pstmt.executeQuery();

            while (rs.next()) {
                medicines.add(extractMedicineFromResultSet(rs));
            }

        } catch (SQLException e) {
            System.err.println("Error getting medicines by category: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, rs);
        }

        return medicines;
    }

    /**
     * Extract Medicine object from ResultSet
     * @param rs ResultSet
     * @return Medicine object
     * @throws SQLException
     */
    private Medicine extractMedicineFromResultSet(ResultSet rs) throws SQLException {
        Medicine medicine = new Medicine();
        medicine.setMedicineId(rs.getInt("medicine_id"));
        medicine.setMedicineName(rs.getString("medicine_name"));
        medicine.setGenericName(rs.getString("generic_name"));
        medicine.setCategory(rs.getString("category"));
        medicine.setSupplierId(rs.getInt("supplier_id"));
        medicine.setSupplierName(rs.getString("supplier_name"));
        medicine.setUnitPrice(rs.getDouble("unit_price"));
        medicine.setSellingPrice(rs.getDouble("selling_price"));
        medicine.setStockQuantity(rs.getInt("stock_quantity"));
        medicine.setReorderLevel(rs.getInt("reorder_level"));
        medicine.setExpiryDate(rs.getDate("expiry_date"));
        medicine.setManufactureDate(rs.getDate("manufacture_date"));
        medicine.setBatchNumber(rs.getString("batch_number"));
        medicine.setDescription(rs.getString("description"));
        medicine.setRackNumber(rs.getString("rack_number"));
        medicine.setStatus(rs.getString("status"));
        medicine.setCreatedAt(rs.getTimestamp("created_at"));
        medicine.setUpdatedAt(rs.getTimestamp("updated_at"));
        return medicine;
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