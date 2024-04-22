package servlets;

import com.google.gson.Gson;
import dataBase.DBConnector;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/fetchAllTransactions")
public class FetchAllTransactionsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        int userId = (int) session.getAttribute("userId");
        String userType = (String) session.getAttribute("userType");
        int businessId = Integer.parseInt(request.getParameter("businessId"));

        if (userId == 0 || businessId == 0) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnector.getConnection();
            if (userType.equals("business")) {
                String sql = "SELECT financial_id, description, investment_amount, income_amount, investment_date FROM financials WHERE investor_id = ? AND business_id = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, businessId);
                pstmt.setInt(2, userId);
            
            } else {
            String sql = "SELECT financial_id, description, investment_amount, income_amount, investment_date FROM financials WHERE investor_id = ? AND business_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            pstmt.setInt(2, businessId);
            }
            rs = pstmt.executeQuery();

            List<Transaction> transactions = new ArrayList<>();

            while (rs.next()) {
                int id = rs.getInt("financial_id");
                String description = rs.getString("description");
                int investAmount = rs.getInt("investment_amount");
                String date = rs.getString("investment_date");
                Integer incomeAmount = rs.getInt("income_amount");

                Transaction transaction = new Transaction(id, description, investAmount, date, incomeAmount);
                transactions.add(transaction);
            }

            // Convert transactions list to JSON
            String json = new Gson().toJson(transactions);

            // Set response type and write JSON response
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();
            out.print(json);
            out.flush();
        } catch (SQLException e) {
            e.printStackTrace();
            // Handle database error
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
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
}
