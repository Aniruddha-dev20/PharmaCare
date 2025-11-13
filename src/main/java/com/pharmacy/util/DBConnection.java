package com.pharmacy.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Database Connection Utility Class
 * Provides methods to establish and close database connections
 * Uses MySQL JDBC Driver
 */
public class DBConnection {

    // Database configuration
    private static final String DB_URL = "jdbc:mysql://localhost:3306/pharmacy_db";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "root"; // Change this to your MySQL password
    private static final String DB_DRIVER = "com.mysql.cj.jdbc.Driver";

    // Connection pool settings (optional but recommended)
    private static final int MAX_POOL_SIZE = 10;
    private static int currentConnections = 0;

    // Static block to load the JDBC driver
    static {
        try {
            Class.forName(DB_DRIVER);
            System.out.println("✓ MySQL JDBC Driver loaded successfully");
        } catch (ClassNotFoundException e) {
            System.err.println("✗ MySQL JDBC Driver not found!");
            e.printStackTrace();
        }
    }

    /**
     * Get database connection
     * @return Connection object
     * @throws SQLException if connection fails
     */
    public static Connection getConnection() throws SQLException {
        try {
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            currentConnections++;
            System.out.println("✓ Database connected successfully (Active: " + currentConnections + ")");
            return conn;
        } catch (SQLException e) {
            System.err.println("✗ Database connection failed!");
            System.err.println("Error: " + e.getMessage());
            throw e;
        }
    }

    /**
     * Close database connection
     * @param conn Connection to close
     */
    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
                currentConnections--;
                System.out.println("✓ Database connection closed (Active: " + currentConnections + ")");
            } catch (SQLException e) {
                System.err.println("✗ Error closing connection: " + e.getMessage());
            }
        }
    }

    /**
     * Test database connection
     * @return true if connection successful, false otherwise
     */
    public static boolean testConnection() {
        Connection conn = null;
        try {
            conn = getConnection();
            System.out.println("✓ Database connection test PASSED");
            return true;
        } catch (SQLException e) {
            System.err.println("✗ Database connection test FAILED");
            e.printStackTrace();
            return false;
        } finally {
            closeConnection(conn);
        }
    }

    /**
     * Get current active connections count
     * @return number of active connections
     */
    public static int getActiveConnections() {
        return currentConnections;
    }

    /**
     * Get database configuration info
     * @return configuration string
     */
    public static String getConnectionInfo() {
        return "Database: " + DB_URL + " | User: " + DB_USER + " | Active Connections: " + currentConnections;
    }

    // Main method for testing
    public static void main(String[] args) {
        System.out.println("=== Testing Database Connection ===");
        System.out.println(getConnectionInfo());

        if (testConnection()) {
            System.out.println("\n✓ Database is ready to use!");
        } else {
            System.out.println("\n✗ Please check your MySQL configuration:");
            System.out.println("  1. MySQL service is running");
            System.out.println("  2. Database 'pharmacy_db' exists");
            System.out.println("  3. Username and password are correct");
            System.out.println("  4. mysql-connector-java.jar is in classpath");
        }
    }
}