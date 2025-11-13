package com.pharmacy.dao;

import com.pharmacy.model.Sale;
import com.pharmacy.model.SaleItem;
import com.pharmacy.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SaleDAO {

    public boolean addSale(Sale sale) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        PreparedStatement pstmtItem = null;
        ResultSet rs = null;

        String sqlSale = "INSERT INTO sales (invoice_number, user_id, customer_id, customer_name, " +
                "customer_phone, total_amount, discount, final_amount, payment_method, " +
                "payment_status, notes) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        String sqlItem = "INSERT INTO sale_items (sale_id, medicine_id, medicine_name, quantity, " +
                "unit_price, subtotal) VALUES (?, ?, ?, ?, ?, ?)";

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Start transaction

            // Insert sale
            pstmt = conn.prepareStatement(sqlSale, Statement.RETURN_GENERATED_KEYS);
            pstmt.setString(1, sale.getInvoiceNumber());
            pstmt.setInt(2, sale.getUserId());
            if (sale.getCustomerId() > 0) {
                pstmt.setInt(3, sale.getCustomerId());
            } else {
                pstmt.setNull(3, Types.INTEGER);
            }
            pstmt.setString(4, sale.getCustomerName());
            pstmt.setString(5, sale.getCustomerPhone());
            pstmt.setDouble(6, sale.getTotalAmount());
            pstmt.setDouble(7, sale.getDiscount());
            pstmt.setDouble(8, sale.getFinalAmount());
            pstmt.setString(9, sale.getPaymentMethod());
            pstmt.setString(10, "paid");
            pstmt.setString(11, sale.getNotes());

            int rows = pstmt.executeUpdate();

            if (rows > 0) {
                rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    int saleId = rs.getInt(1);

                    // Insert sale items
                    pstmtItem = conn.prepareStatement(sqlItem);
                    for (SaleItem item : sale.getSaleItems()) {
                        pstmtItem.setInt(1, saleId);
                        pstmtItem.setInt(2, item.getMedicineId());
                        pstmtItem.setString(3, item.getMedicineName());
                        pstmtItem.setInt(4, item.getQuantity());
                        pstmtItem.setDouble(5, item.getUnitPrice());
                        pstmtItem.setDouble(6, item.getSubtotal());
                        pstmtItem.addBatch();

                        // Update medicine stock
                        updateMedicineStock(conn, item.getMedicineId(), -item.getQuantity());
                    }
                    pstmtItem.executeBatch();
                }
            }

            conn.commit(); // Commit transaction
            System.out.println("✓ Sale completed: " + sale.getInvoiceNumber());
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
            e.printStackTrace();
        } finally {
            try {
                if (conn != null) conn.setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
            closeResources(conn, pstmt, rs);
            if (pstmtItem != null) {
                try { pstmtItem.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        }
        return false;
    }

    private void updateMedicineStock(Connection conn, int medicineId, int quantity) throws SQLException {
        String sql = "UPDATE medicines SET stock_quantity = stock_quantity + ? WHERE medicine_id = ?";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, quantity);
        pstmt.setInt(2, medicineId);
        pstmt.executeUpdate();
        pstmt.close();
    }

    public List<Sale> getAllSales() {
        List<Sale> sales = new ArrayList<>();
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;

        String sql = "SELECT s.*, u.full_name as user_name FROM sales s " +
                "LEFT JOIN users u ON s.user_id = u.user_id " +
                "ORDER BY s.sale_date DESC";

        try {
            conn = DBConnection.getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);

            while (rs.next()) {
                sales.add(extractSaleFromResultSet(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, rs);
        }

        return sales;
    }

    public Sale getSaleById(int saleId) {
        Sale sale = null;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql = "SELECT s.*, u.full_name as user_name FROM sales s " +
                "LEFT JOIN users u ON s.user_id = u.user_id WHERE s.sale_id = ?";

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, saleId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                sale = extractSaleFromResultSet(rs);
                sale.setSaleItems(getSaleItems(saleId));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, rs);
        }

        return sale;
    }

    public List<SaleItem> getSaleItems(int saleId) {
        List<SaleItem> items = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql = "SELECT * FROM sale_items WHERE sale_id = ?";

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, saleId);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                SaleItem item = new SaleItem();
                item.setSaleItemId(rs.getInt("sale_item_id"));
                item.setSaleId(rs.getInt("sale_id"));
                item.setMedicineId(rs.getInt("medicine_id"));
                item.setMedicineName(rs.getString("medicine_name"));
                item.setQuantity(rs.getInt("quantity"));
                item.setUnitPrice(rs.getDouble("unit_price"));
                item.setSubtotal(rs.getDouble("subtotal"));
                items.add(item);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, rs);
        }

        return items;
    }

    public String generateInvoiceNumber() {
        String invoiceNumber = "INV-" + System.currentTimeMillis();
        return invoiceNumber;
    }

    private Sale extractSaleFromResultSet(ResultSet rs) throws SQLException {
        Sale sale = new Sale();
        sale.setSaleId(rs.getInt("sale_id"));
        sale.setInvoiceNumber(rs.getString("invoice_number"));
        sale.setUserId(rs.getInt("user_id"));
        sale.setUserName(rs.getString("user_name"));
        sale.setCustomerId(rs.getInt("customer_id"));
        sale.setCustomerName(rs.getString("customer_name"));
        sale.setCustomerPhone(rs.getString("customer_phone"));
        sale.setTotalAmount(rs.getDouble("total_amount"));
        sale.setDiscount(rs.getDouble("discount"));
        sale.setFinalAmount(rs.getDouble("final_amount"));
        sale.setPaymentMethod(rs.getString("payment_method"));
        sale.setPaymentStatus(rs.getString("payment_status"));
        sale.setSaleDate(rs.getTimestamp("sale_date"));
        sale.setNotes(rs.getString("notes"));
        return sale;
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