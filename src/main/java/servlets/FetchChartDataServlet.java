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

@WebServlet("/fetchChartData")
public class FetchChartDataServlet extends HttpServlet {
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

        boolean isMonthly = Boolean.parseBoolean(request.getParameter("monthly"));

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnector.getConnection();
            if (userType.equals("business")) {
                String sql = "SELECT ";
                if (isMonthly) {
                    sql += "MONTH(investment_date) AS period, ";
                } else {
                    sql += "YEAR(investment_date) AS period, ";
                }
                sql += "SUM(investment_amount) AS totalInvestment, SUM(income_amount) AS totalIncome, COUNT(*) AS transactionCount " +
                        "FROM financials WHERE investor_id = ? AND business_id = ? ";
                if (isMonthly) {
                    sql += "GROUP BY MONTH(investment_date)";
                } else {
                    sql += "GROUP BY YEAR(investment_date)";
                }
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, businessId);
                pstmt.setInt(2, userId);
            
            } else {
                String sql = "SELECT ";
                if (isMonthly) {
                    sql += "MONTH(investment_date) AS period, ";
                } else {
                    sql += "YEAR(investment_date) AS period, ";
                }
                sql += "SUM(investment_amount) AS totalInvestment, SUM(income_amount) AS totalIncome, COUNT(*) AS transactionCount " +
                        "FROM financials WHERE investor_id = ? AND business_id = ? ";
                if (isMonthly) {
                    sql += "GROUP BY MONTH(investment_date)";
                } else {
                    sql += "GROUP BY YEAR(investment_date)";
                }
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, userId);
                pstmt.setInt(2, businessId);
            }
            
            
            rs = pstmt.executeQuery();

            List<String> labels = new ArrayList<>();
            List<Integer> investmentData = new ArrayList<>();
            List<Integer> incomeData = new ArrayList<>();
            List<Integer> transactionCounts = new ArrayList<>();

            while (rs.next()) {
                String period = rs.getString("period");
                int totalInvestment = rs.getInt("totalInvestment");
                int totalIncome = rs.getInt("totalIncome");
                int transactionCount = rs.getInt("transactionCount");

                labels.add(period); // Use month or year as label

                investmentData.add(totalInvestment);
                incomeData.add(totalIncome);
                transactionCounts.add(transactionCount);
            }

            // Construct JSON object
            ChartData chartData = new ChartData(labels, investmentData, incomeData, transactionCounts);
            String json = new Gson().toJson(chartData);

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

    // Class to represent chart data
    private static class ChartData {
        List<String> labels;
        List<Integer> investmentData;
        List<Integer> incomeData;
        List<Integer> transactionCounts;

        public ChartData(List<String> labels, List<Integer> investmentData, List<Integer> incomeData, List<Integer> transactionCounts) {
            this.labels = labels;
            this.investmentData = investmentData;
            this.incomeData = incomeData;
            this.transactionCounts = transactionCounts;
        }
    }
}
