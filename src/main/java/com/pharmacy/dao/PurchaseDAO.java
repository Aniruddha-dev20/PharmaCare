package com.pharmacy.dao;

import com.pharmacy.model.PurchaseOrder;
import com.pharmacy.model.PurchaseItem;
import com.pharmacy.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * PurchaseDAO - Data Access Object for Purchase Operations
 */
public class PurchaseDAO {

    /**
     * Add new purchase order with items
     */
    public boolean addPurchaseOrder(PurchaseOrder po) {
        Connection conn = null;
        PreparedStatement pstmtPO = null;
        PreparedStatement pstmtItem = null;
        ResultSet rs = null;

        String sqlPO = "INSERT INTO purchase_orders (po_number, supplier_id, user_id, order_date, " +
                "expected_delivery, total_amount, status, notes) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        String sqlItem = "INSERT INTO purchase_items (po_id, medicine_id, quantity, unit_price, subtotal) " +
                "VALUES (?, ?, ?, ?, ?)";

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Start transaction

            // Insert purchase order
            pstmtPO = conn.prepareStatement(sqlPO, Statement.RETURN_GENERATED_KEYS);
            pstmtPO.setString(1, po.getPoNumber());
            pstmtPO.setInt(2, po.getSupplierId());
            pstmtPO.setInt(3, po.getUserId());
            pstmtPO.setDate(4, po.getOrderDate());
            pstmtPO.setDate(5, po.getExpectedDelivery());
            pstmtPO.setDouble(6, po.getTotalAmount());
            pstmtPO.setString(7, po.getStatus());
            pstmtPO.setString(8, po.getNotes());

            int rows = pstmtPO.executeUpdate();

            if (rows > 0) {
                rs = pstmtPO.getGeneratedKeys();
                if (rs.next()) {
                    int poId = rs.getInt(1);

                    // Insert purchase items
                    pstmtItem = conn.prepareStatement(sqlItem);
                    for (PurchaseItem item : po.getPurchaseItems()) {
                        pstmtItem.setInt(1, poId);
                        pstmtItem.setInt(2, item.getMedicineId());
                        pstmtItem.setInt(3, item.getQuantity());
                        pstmtItem.setDouble(4, item.getUnitPrice());
                        pstmtItem.setDouble(5, item.getSubtotal());
                        pstmtItem.addBatch();
                    }
                    pstmtItem.executeBatch();
                }
            }

            conn.commit(); // Commit transaction
            System.out.println("✓ Purchase order created: " + po.getPoNumber());
            return true;

        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback(); // Rollback on error
                    System.out.println("✗ Transaction rolled back");
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            System.err.println("Error adding purchase order: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (conn != null) conn.setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
            closeResources(conn, pstmtPO, rs);
            if (pstmtItem != null) {
                try { pstmtItem.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        }
        return false;
    }

    /**
     * Get all purchase orders
     */
    public List<PurchaseOrder> getAllPurchaseOrders() {
        List<PurchaseOrder> orders = new ArrayList<>();
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;

        String sql = "SELECT po.*, s.supplier_name, u.full_name as user_name " +
                "FROM purchase_orders po " +
                "LEFT JOIN suppliers s ON po.supplier_id = s.supplier_id " +
                "LEFT JOIN users u ON po.user_id = u.user_id " +
                "ORDER BY po.order_date DESC";

        try {
            conn = DBConnection.getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);

            while (rs.next()) {
                orders.add(extractPurchaseOrderFromResultSet(rs));
            }

            System.out.println("✓ Retrieved " + orders.size() + " purchase orders");

        } catch (SQLException e) {
            System.err.println("Error getting purchase orders: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, rs);
        }

        return orders;
    }

    /**
     * Get purchase order by ID with items
     */
    public PurchaseOrder getPurchaseOrderById(int poId) {
        PurchaseOrder po = null;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql = "SELECT po.*, s.supplier_name, u.full_name as user_name " +
                "FROM purchase_orders po " +
                "LEFT JOIN suppliers s ON po.supplier_id = s.supplier_id " +
                "LEFT JOIN users u ON po.user_id = u.user_id " +
                "WHERE po.po_id = ?";

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, poId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                po = extractPurchaseOrderFromResultSet(rs);
                po.setPurchaseItems(getPurchaseItems(poId));
            }

        } catch (SQLException e) {
            System.err.println("Error getting purchase order by ID: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, rs);
        }

        return po;
    }

    /**
     * Get purchase items for a purchase order
     */
    public List<PurchaseItem> getPurchaseItems(int poId) {
        List<PurchaseItem> items = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql = "SELECT pi.*, m.medicine_name " +
                "FROM purchase_items pi " +
                "LEFT JOIN medicines m ON pi.medicine_id = m.medicine_id " +
                "WHERE pi.po_id = ?";

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, poId);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                PurchaseItem item = new PurchaseItem();
                item.setPurchaseItemId(rs.getInt("purchase_item_id"));
                item.setPoId(rs.getInt("po_id"));
                item.setMedicineId(rs.getInt("medicine_id"));
                item.setMedicineName(rs.getString("medicine_name"));
                item.setQuantity(rs.getInt("quantity"));
                item.setUnitPrice(rs.getDouble("unit_price"));
                item.setSubtotal(rs.getDouble("subtotal"));
                items.add(item);
            }

        } catch (SQLException e) {
            System.err.println("Error getting purchase items: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, rs);
        }

        return items;
    }

    /**
     * Update purchase order status
     */
    public boolean updatePurchaseStatus(int poId, String status) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        String sql = "UPDATE purchase_orders SET status = ? WHERE po_id = ?";

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, status);
            pstmt.setInt(2, poId);

            int rows = pstmt.executeUpdate();

            if (rows > 0) {
                System.out.println("✓ Purchase order status updated to: " + status);

                // If status is 'received', update medicine stock
                if ("received".equalsIgnoreCase(status)) {
                    updateMedicineStock(poId);
                }

                return true;
            }

        } catch (SQLException e) {
            System.err.println("Error updating purchase status: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, null);
        }

        return false;
    }

    /**
     * Update medicine stock when purchase is received
     */
    private void updateMedicineStock(int poId) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        String sql = "UPDATE medicines m " +
                "JOIN purchase_items pi ON m.medicine_id = pi.medicine_id " +
                "SET m.stock_quantity = m.stock_quantity + pi.quantity " +
                "WHERE pi.po_id = ?";

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, poId);

            int rows = pstmt.executeUpdate();
            System.out.println("✓ Updated stock for " + rows + " medicines");

        } catch (SQLException e) {
            System.err.println("Error updating medicine stock: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, null);
        }
    }

    /**
     * Generate unique PO number
     */
    public String generatePONumber() {
        return "PO-" + System.currentTimeMillis();
    }

    /**
     * Get purchase orders by status
     */
    public List<PurchaseOrder> getPurchaseOrdersByStatus(String status) {
        List<PurchaseOrder> orders = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql = "SELECT po.*, s.supplier_name, u.full_name as user_name " +
                "FROM purchase_orders po " +
                "LEFT JOIN suppliers s ON po.supplier_id = s.supplier_id " +
                "LEFT JOIN users u ON po.user_id = u.user_id " +
                "WHERE po.status = ? " +
                "ORDER BY po.order_date DESC";

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, status);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                orders.add(extractPurchaseOrderFromResultSet(rs));
            }

        } catch (SQLException e) {
            System.err.println("Error getting purchase orders by status: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, rs);
        }

        return orders;
    }

    /**
     * Extract PurchaseOrder from ResultSet
     */
    private PurchaseOrder extractPurchaseOrderFromResultSet(ResultSet rs) throws SQLException {
        PurchaseOrder po = new PurchaseOrder();
        po.setPoId(rs.getInt("po_id"));
        po.setPoNumber(rs.getString("po_number"));
        po.setSupplierId(rs.getInt("supplier_id"));
        po.setSupplierName(rs.getString("supplier_name"));
        po.setUserId(rs.getInt("user_id"));
        po.setUserName(rs.getString("user_name"));
        po.setOrderDate(rs.getDate("order_date"));
        po.setExpectedDelivery(rs.getDate("expected_delivery"));
        po.setTotalAmount(rs.getDouble("total_amount"));
        po.setStatus(rs.getString("status"));
        po.setNotes(rs.getString("notes"));
        po.setCreatedAt(rs.getTimestamp("created_at"));
        po.setUpdatedAt(rs.getTimestamp("updated_at"));
        return po;
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