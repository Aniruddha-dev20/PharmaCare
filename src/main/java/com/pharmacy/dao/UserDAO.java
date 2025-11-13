package com.pharmacy.dao;

import com.pharmacy.model.User;
import com.pharmacy.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * UserDAO - Data Access Object for User operations
 * Handles all database operations related to users
 */
public class UserDAO {

    /**
     * Validate user login credentials
     * @param username Username
     * @param password Password
     * @return User object if valid, null otherwise
     */
    public User validateUser(String username, String password) {
        User user = null;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql = "SELECT * FROM users WHERE username = ? AND password = ? AND status = 'active'";

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, username);
            pstmt.setString(2, password);

            rs = pstmt.executeQuery();

            if (rs.next()) {
                user = extractUserFromResultSet(rs);
                System.out.println("✓ User validated: " + username);
            } else {
                System.out.println("✗ Invalid credentials for: " + username);
            }

        } catch (SQLException e) {
            System.err.println("Error validating user: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, rs);
        }

        return user;
    }

    /**
     * Get user by ID
     * @param userId User ID
     * @return User object
     */
    public User getUserById(int userId) {
        User user = null;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql = "SELECT * FROM users WHERE user_id = ?";

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);

            rs = pstmt.executeQuery();

            if (rs.next()) {
                user = extractUserFromResultSet(rs);
            }

        } catch (SQLException e) {
            System.err.println("Error getting user by ID: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, rs);
        }

        return user;
    }

    /**
     * Get all users
     * @return List of all users
     */
    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;

        String sql = "SELECT * FROM users ORDER BY created_at DESC";

        try {
            conn = DBConnection.getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);

            while (rs.next()) {
                users.add(extractUserFromResultSet(rs));
            }

            System.out.println("✓ Retrieved " + users.size() + " users");

        } catch (SQLException e) {
            System.err.println("Error getting all users: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, rs);
        }

        return users;
    }

    /**
     * Add new user
     * @param user User object
     * @return true if successful, false otherwise
     */
    public boolean addUser(User user) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        String sql = "INSERT INTO users (username, password, full_name, email, phone, role, status) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, user.getUsername());
            pstmt.setString(2, user.getPassword());
            pstmt.setString(3, user.getFullName());
            pstmt.setString(4, user.getEmail());
            pstmt.setString(5, user.getPhone());
            pstmt.setString(6, user.getRole());
            pstmt.setString(7, "active");

            int rows = pstmt.executeUpdate();

            if (rows > 0) {
                System.out.println("✓ User added successfully: " + user.getUsername());
                return true;
            }

        } catch (SQLException e) {
            System.err.println("Error adding user: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, null);
        }

        return false;
    }

    /**
     * Update user
     * @param user User object with updated information
     * @return true if successful, false otherwise
     */
    public boolean updateUser(User user) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        String sql = "UPDATE users SET full_name = ?, email = ?, phone = ?, role = ?, status = ? " +
                "WHERE user_id = ?";

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, user.getFullName());
            pstmt.setString(2, user.getEmail());
            pstmt.setString(3, user.getPhone());
            pstmt.setString(4, user.getRole());
            pstmt.setString(5, user.getStatus());
            pstmt.setInt(6, user.getUserId());

            int rows = pstmt.executeUpdate();

            if (rows > 0) {
                System.out.println("✓ User updated successfully: " + user.getUsername());
                return true;
            }

        } catch (SQLException e) {
            System.err.println("Error updating user: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, null);
        }

        return false;
    }

    /**
     * Delete user (soft delete - set status to inactive)
     * @param userId User ID
     * @return true if successful, false otherwise
     */
    public boolean deleteUser(int userId) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        String sql = "UPDATE users SET status = 'inactive' WHERE user_id = ?";

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);

            int rows = pstmt.executeUpdate();

            if (rows > 0) {
                System.out.println("✓ User deactivated successfully");
                return true;
            }

        } catch (SQLException e) {
            System.err.println("Error deleting user: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, null);
        }

        return false;
    }

    /**
     * Check if username exists
     * @param username Username to check
     * @return true if exists, false otherwise
     */
    public boolean usernameExists(String username) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql = "SELECT COUNT(*) FROM users WHERE username = ?";

        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, username);

            rs = pstmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }

        } catch (SQLException e) {
            System.err.println("Error checking username: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, rs);
        }

        return false;
    }

    /**
     * Extract User object from ResultSet
     * @param rs ResultSet
     * @return User object
     * @throws SQLException
     */
    private User extractUserFromResultSet(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("user_id"));
        user.setUsername(rs.getString("username"));
        user.setPassword(rs.getString("password"));
        user.setFullName(rs.getString("full_name"));
        user.setEmail(rs.getString("email"));
        user.setPhone(rs.getString("phone"));
        user.setRole(rs.getString("role"));
        user.setStatus(rs.getString("status"));
        user.setCreatedAt(rs.getTimestamp("created_at"));
        user.setUpdatedAt(rs.getTimestamp("updated_at"));
        return user;
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