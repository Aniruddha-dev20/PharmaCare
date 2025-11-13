package com.pharmacy.dao;

import com.pharmacy.model.Supplier;
import com.pharmacy.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SupplierDAO {

    public List<Supplier> getAllSuppliers() {
        List<Supplier> suppliers = new ArrayList<>();
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;

        String sql = "SELECT * FROM suppliers WHERE status = 'active' ORDER BY supplier_name";

        try {
            conn = DBConnection.getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);

            while (rs.next()) {
                suppliers.add(extractSupplierFromResultSet(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, rs);
        }

        return suppliers;
    }

    public Supplier getSupplierById(int supplierId) {
        Supplier supplier = null;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql = "SELECT * FROM suppliers WHERE supplier_id = ?";

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, supplierId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                supplier = extractSupplierFromResultSet(rs);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, rs);
        }

        return supplier;
    }

    public boolean addSupplier(Supplier supplier) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        String sql = "INSERT INTO suppliers (supplier_name, contact_person, phone, email, " +
                "address, city, state, pincode, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'active')";

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, supplier.getSupplierName());
            pstmt.setString(2, supplier.getContactPerson());
            pstmt.setString(3, supplier.getPhone());
            pstmt.setString(4, supplier.getEmail());
            pstmt.setString(5, supplier.getAddress());
            pstmt.setString(6, supplier.getCity());
            pstmt.setString(7, supplier.getState());
            pstmt.setString(8, supplier.getPincode());

            int rows = pstmt.executeUpdate();
            return rows > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, null);
        }
        return false;
    }

    public boolean updateSupplier(Supplier supplier) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        String sql = "UPDATE suppliers SET supplier_name = ?, contact_person = ?, phone = ?, " +
                "email = ?, address = ?, city = ?, state = ?, pincode = ? WHERE supplier_id = ?";

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, supplier.getSupplierName());
            pstmt.setString(2, supplier.getContactPerson());
            pstmt.setString(3, supplier.getPhone());
            pstmt.setString(4, supplier.getEmail());
            pstmt.setString(5, supplier.getAddress());
            pstmt.setString(6, supplier.getCity());
            pstmt.setString(7, supplier.getState());
            pstmt.setString(8, supplier.getPincode());
            pstmt.setInt(9, supplier.getSupplierId());

            int rows = pstmt.executeUpdate();
            return rows > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, null);
        }
        return false;
    }

    public boolean deleteSupplier(int supplierId) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        String sql = "UPDATE suppliers SET status = 'inactive' WHERE supplier_id = ?";

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, supplierId);

            int rows = pstmt.executeUpdate();
            return rows > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, null);
        }
        return false;
    }

    private Supplier extractSupplierFromResultSet(ResultSet rs) throws SQLException {
        Supplier supplier = new Supplier();
        supplier.setSupplierId(rs.getInt("supplier_id"));
        supplier.setSupplierName(rs.getString("supplier_name"));
        supplier.setContactPerson(rs.getString("contact_person"));
        supplier.setPhone(rs.getString("phone"));
        supplier.setEmail(rs.getString("email"));
        supplier.setAddress(rs.getString("address"));
        supplier.setCity(rs.getString("city"));
        supplier.setState(rs.getString("state"));
        supplier.setPincode(rs.getString("pincode"));
        supplier.setStatus(rs.getString("status"));
        supplier.setCreatedAt(rs.getTimestamp("created_at"));
        supplier.setUpdatedAt(rs.getTimestamp("updated_at"));
        return supplier;
    }

    private void closeResources(Connection conn, Statement stmt, ResultSet rs) {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) DBConnection.closeConnection(conn);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}