package com.pharmacy.dao;

import com.pharmacy.model.Customer;
import com.pharmacy.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CustomerDAO {

    public List<Customer> getAllCustomers() {
        List<Customer> customers = new ArrayList<>();
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;

        String sql = "SELECT * FROM customers ORDER BY customer_name";

        try {
            conn = DBConnection.getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);

            while (rs.next()) {
                customers.add(extractCustomerFromResultSet(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, rs);
        }

        return customers;
    }

    public Customer getCustomerById(int customerId) {
        Customer customer = null;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql = "SELECT * FROM customers WHERE customer_id = ?";

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, customerId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                customer = extractCustomerFromResultSet(rs);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, rs);
        }

        return customer;
    }

    public Customer getCustomerByPhone(String phone) {
        Customer customer = null;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql = "SELECT * FROM customers WHERE phone = ?";

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, phone);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                customer = extractCustomerFromResultSet(rs);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, rs);
        }

        return customer;
    }

    public boolean addCustomer(Customer customer) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        String sql = "INSERT INTO customers (customer_name, phone, email, address, city, date_of_birth) " +
                "VALUES (?, ?, ?, ?, ?, ?)";

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, customer.getCustomerName());
            pstmt.setString(2, customer.getPhone());
            pstmt.setString(3, customer.getEmail());
            pstmt.setString(4, customer.getAddress());
            pstmt.setString(5, customer.getCity());
            pstmt.setDate(6, customer.getDateOfBirth());

            int rows = pstmt.executeUpdate();
            return rows > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, null);
        }
        return false;
    }

    public boolean updateCustomer(Customer customer) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        String sql = "UPDATE customers SET customer_name = ?, phone = ?, email = ?, " +
                "address = ?, city = ?, date_of_birth = ? WHERE customer_id = ?";

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, customer.getCustomerName());
            pstmt.setString(2, customer.getPhone());
            pstmt.setString(3, customer.getEmail());
            pstmt.setString(4, customer.getAddress());
            pstmt.setString(5, customer.getCity());
            pstmt.setDate(6, customer.getDateOfBirth());
            pstmt.setInt(7, customer.getCustomerId());

            int rows = pstmt.executeUpdate();
            return rows > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, null);
        }
        return false;
    }

    public boolean deleteCustomer(int customerId) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        String sql = "DELETE FROM customers WHERE customer_id = ?";

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, customerId);

            int rows = pstmt.executeUpdate();
            return rows > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, null);
        }
        return false;
    }

    private Customer extractCustomerFromResultSet(ResultSet rs) throws SQLException {
        Customer customer = new Customer();
        customer.setCustomerId(rs.getInt("customer_id"));
        customer.setCustomerName(rs.getString("customer_name"));
        customer.setPhone(rs.getString("phone"));
        customer.setEmail(rs.getString("email"));
        customer.setAddress(rs.getString("address"));
        customer.setCity(rs.getString("city"));
        customer.setDateOfBirth(rs.getDate("date_of_birth"));
        customer.setCreatedAt(rs.getTimestamp("created_at"));
        customer.setUpdatedAt(rs.getTimestamp("updated_at"));
        return customer;
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