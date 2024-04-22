package servlets;

import dataBase.DBConnector;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/transaction")
public class Investservlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve accepted transaction details from request parameters
        String purpose = request.getParameter("purpose");
        String amountParameter = request.getParameter("amount");
        int businessId = Integer.parseInt(request.getParameter("businessId"));
        
        if (amountParameter == null) {
            // Handle the case when amount parameter is null
            // You can return an error response or handle it based on your requirements
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Amount parameter is missing");
            return;
        }
        
        int amount;
        try {
            amount = Integer.parseInt(amountParameter);
        } catch (NumberFormatException e) {
            // Handle the case when amount parameter cannot be parsed into an integer
            // You can return an error response or handle it based on your requirements
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid amount parameter");
            return;
        }
        System.out.println("Servlet called. Purpose: " + purpose + ", Amount: " + amount);
        // Retrieve user ID from session
        HttpSession session = request.getSession();
        int userId = (int) session.getAttribute("userId");

        // Perform database operation to insert the transaction details into the MySQL database
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            // Establish database connection
            conn = DBConnector.getConnection();

            // Prepare SQL statement for insertion
            String sql = "INSERT INTO financials (investor_id, business_id, description, investment_amount) VALUES (?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            pstmt.setInt(2, businessId);
            pstmt.setString(3, purpose);
            pstmt.setInt(4, amount);

            // Execute the SQL statement
            int rowsAffected = pstmt.executeUpdate();

            // Check if insertion was successful
            if (rowsAffected > 0) {
                // Respond to the client-side AJAX request (optional)
                response.setContentType("text/plain");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write("Transaction accepted successfully.");
            } else {
                // Handle insertion failure (optional)
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to insert transaction into database.");
            }
        } catch (SQLException e) {
            // Handle database error (optional)
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error occurred.");
        } finally {
            // Close resources
            if (pstmt != null) {
                try {
                    pstmt.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
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
