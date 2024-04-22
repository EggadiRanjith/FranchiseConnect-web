package dataBase;

import java.sql.Connection;
import java.sql.SQLException;

public class Getconnection {

    public static void main(String[] args) {
        Connection conn = null;
        try {
            // Attempt to establish a database connection
            conn = DBConnector.getConnection();
            
            // If connection is successful, print a success message
            if (conn != null) {
                System.out.println("Database connection established successfully!");
                
                // Do additional operations here if needed
            } else {
                // Print a message if connection is null
                System.out.println("Failed to establish database connection.");
            }
        } catch (SQLException e) {
            // Handle SQL exceptions
            e.printStackTrace();
        } finally {
            // Close the connection in the finally block to ensure it's always closed
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}
