package dataBase;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class DBConnector {

    private static final String DB_HOST = "sql.freedb.tech";
    private static final String DB_NAME = "freedb_franchisecoonet";
    private static final String USER = "freedb_Ranjith";
    private static final String PASS = "SGAVXBmXE2Tx9*y";
    private static final String JDBC_DRIVER = "com.mysql.cj.jdbc.Driver";
    private static final int DB_PORT = 3306;
    private static final String DB_URL = "jdbc:mysql://" + DB_HOST + ":" + DB_PORT + "/" + DB_NAME;

    // Method to establish a database connection and return the Connection object
    public static Connection getConnection() throws SQLException {
        Connection conn = null;
        try {
            // Register JDBC driver
            Class.forName(JDBC_DRIVER);

            // Open a connection
            System.out.println("Connecting to database...");
            conn = DriverManager.getConnection(DB_URL, USER, PASS);
            System.out.println("Connected to database successfully!");

        } catch (ClassNotFoundException | SQLException e) {
            // Handle errors
            e.printStackTrace();
            throw new SQLException("Failed to connect to database.");
        }
        return conn;
    }

    // Method to close the connection
    public static void closeConnection(Connection connection) {
        if (connection != null) {
            try {
                connection.close();
                System.out.println("Connection closed.");
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    // Method to close the ResultSet
    public static void closeResultSet(ResultSet rs) {
        if (rs != null) {
            try {
                rs.close();
                System.out.println("ResultSet closed.");
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    // Method to close the PreparedStatement
    public static void closeStatement(PreparedStatement stmt) {
        if (stmt != null) {
            try {
                stmt.close();
                System.out.println("PreparedStatement closed.");
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
