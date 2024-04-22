package servlets;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import dataBase.DBConnector;

@WebServlet("/transactionType")
public class TransactionTypeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Retrieve userId from session
        HttpSession session = request.getSession();
        int userId = 0;
        if (session.getAttribute("userId") != null) {
            userId = (int) session.getAttribute("userId");
        } else {
            sendErrorResponse(response, "User session not found");
            return;
        }

        // Retrieve businessId from request parameters
        String businessIdString = request.getParameter("businessId");
        String category = request.getParameter("category");
        int businessId = 0;
        try {
            businessId = Integer.parseInt(businessIdString);
        } catch (NumberFormatException e) {
            sendErrorResponse(response, "Invalid business ID");
            return;
        }

        // Retrieve transaction type and cost from request parameters
        String type = request.getParameter("type");
        int cost = 0;
        try {
            cost = Integer.parseInt(request.getParameter("cost"));
        } catch (NumberFormatException e) {
            sendErrorResponse(response, "Invalid transaction cost");
            return;
        }

        // Store transaction type in the database
        Connection conn = null;
        PreparedStatement pstmt = null;
        PrintWriter out = response.getWriter();
        JsonObject jsonResponse = new JsonObject();

        try {
            conn = DBConnector.getConnection();
            String sql = "INSERT INTO transaction_types (user_id, business_id, type, cost, category) VALUES (?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            pstmt.setInt(2, businessId);
            pstmt.setString(3, type);
            pstmt.setInt(4, cost);
            pstmt.setString(5, category);

            int rowsAffected = pstmt.executeUpdate();

            if (rowsAffected > 0) {
                jsonResponse.addProperty("success", true);
                jsonResponse.addProperty("message", "Transaction type added successfully.");
            } else {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Failed to add transaction type.");
            }
        } catch (SQLException e) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Database error occurred.");
            e.printStackTrace();
        } finally {
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

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        out.print(jsonResponse.toString());
        out.flush();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Retrieve userId from session
        HttpSession session = request.getSession();
        int userId = 0;
        if (session.getAttribute("userId") != null) {
            userId = (int) session.getAttribute("userId");
        } else {
            sendErrorResponse(response, "User session not found");
            return;
        }

        // Retrieve businessId from request parameters
        String businessIdString = request.getParameter("businessId");
        int businessId = 0;
        try {
            businessId = Integer.parseInt(businessIdString);
        } catch (NumberFormatException e) {
            sendErrorResponse(response, "Invalid business ID");
            return;
        }

        // Retrieve transaction types from the database
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        PrintWriter out = response.getWriter();

        try {
            conn = DBConnector.getConnection();
            String sql = "SELECT transaction_types_id, type, cost, category FROM transaction_types WHERE user_id = ? AND business_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            pstmt.setInt(2, businessId);
            rs = pstmt.executeQuery();

            // Create JSON response
            JsonObject jsonResponse = new JsonObject();
            JsonArray transactionTypes = new JsonArray();

            while (rs.next()) {
                JsonObject transactionType = new JsonObject();
                transactionType.addProperty("id", rs.getInt("transaction_types_id"));
                transactionType.addProperty("type", rs.getString("type"));
                transactionType.addProperty("category", rs.getString("category"));
                transactionType.addProperty("cost", rs.getInt("cost"));
                transactionTypes.add(transactionType);
            }

            jsonResponse.add("transactionTypes", transactionTypes);
            jsonResponse.addProperty("success", true);

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            out.print(jsonResponse.toString());
            out.flush();
        } catch (SQLException e) {
            sendErrorResponse(response, "Database error occurred");
            e.printStackTrace();
        } finally {
            // Close resources
            if (rs != null) {
                try {
                    rs.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
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

    protected void doPut(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Retrieve transaction ID and updated data from request parameters
        int transactionId = Integer.parseInt(request.getParameter("id"));
        String type = request.getParameter("type");
        int cost = Integer.parseInt(request.getParameter("cost"));


        // Update transaction in the database
        Connection conn = null;
        PreparedStatement pstmt = null;
        PrintWriter out = response.getWriter();
        JsonObject jsonResponse = new JsonObject();

        try {
            conn = DBConnector.getConnection();
            String sql = "UPDATE transaction_types SET type = ?, cost = ? WHERE transaction_types_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, type);
            pstmt.setInt(2, cost);
            pstmt.setInt(3, transactionId);

            int rowsAffected = pstmt.executeUpdate();

            if (rowsAffected > 0) {
                jsonResponse.addProperty("success", true);
                jsonResponse.addProperty("message", "Transaction type updated successfully.");
            } else {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Failed to update transaction type.");
            }
        } catch (SQLException e) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Database error occurred.");
            e.printStackTrace();
        } finally {
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

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        out.print(jsonResponse.toString());
        out.flush();
    }

    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Retrievet transaction ID from request parameters
        int transactionId = Integer.parseInt(request.getParameter("transactionId"));

        // Delete transaction from the database
        Connection conn = null;
        PreparedStatement pstmt = null;
        PrintWriter out = response.getWriter();
        JsonObject jsonResponse = new JsonObject();

        try {
            conn = DBConnector.getConnection();
            String sql = "DELETE FROM transaction_types WHERE transaction_types_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, transactionId);

            int rowsAffected = pstmt.executeUpdate();

            if (rowsAffected > 0) {
                jsonResponse.addProperty("success", true);
                jsonResponse.addProperty("message", "Transaction type deleted successfully.");
            } else {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Failed to delete transaction type.");
            }
        } catch (SQLException e) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Database error occurred.");
            e.printStackTrace();
        } finally {
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

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        out.print(jsonResponse.toString());
        out.flush();
    }

    // Method to send error response in JSON format
    private void sendErrorResponse(HttpServletResponse response, String errorMessage) throws IOException {
        PrintWriter out = response.getWriter();
        JsonObject errorResponse = new JsonObject();
        errorResponse.addProperty("success", false);
        errorResponse.addProperty("message", errorMessage);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        out.print(errorResponse.toString());
        out.flush();
    }
}
