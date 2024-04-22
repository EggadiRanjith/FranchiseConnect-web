package servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import dataBase.DBConnector;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/businesslist")
public class BusinessServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        int userId = (int) session.getAttribute("userId");
        String userType = (String) session.getAttribute("userType");

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        List<Business> businessList = new ArrayList<>();

        try {
            conn = DBConnector.getConnection();
            if (conn != null) {
                System.out.println("Connected to database successfully.");
                
                String sql;
                if (userType.equals("business")) {
                    // If the user is a business, fetch business IDs
                    sql = "SELECT business_id FROM businesses WHERE user_id = ?";
                    stmt = conn.prepareStatement(sql);
                    stmt.setInt(1, userId);
                    rs = stmt.executeQuery();
                    
                    // Retrieve business IDs
                    List<Integer> businessIds = new ArrayList<>();
                    while (rs.next()) {
                    	System.out.println(businessIds);
                        int businessId = rs.getInt("business_id");
                        businessIds.add(businessId);
                    }
                    // Print out the retrieved business IDs
                    System.out.println("Business IDs: " + businessIds);
                    // Now, fetch application details for each business
                    sql = "SELECT "
                            + "applications.*, "
                            + "investor.username AS investor_username, "
                            + "investor.email AS investor_email, "
                            + "investor.contact_info AS investor_contact_info, "
                            + "investor.user_id AS investor_id, "
                            + "business.business_id AS business_id, "
                            + "business_user.username AS business_username, "
                            + "business_user.email AS business_email, "
                            + "business_user.contact_info AS business_contact_info "
                            + "FROM "
                            + "applications "
                            + "JOIN "
                            + "users AS investor ON applications.investor_id = investor.user_id "
                            + "JOIN "
                            + "businesses AS business ON applications.business_id = business.business_id "
                            + "JOIN "
                            + "users AS business_user ON business.user_id = business_user.user_id "
                            + "WHERE "
                            + "applications.business_id = ? "
                            + "AND applications.application_status = 'agreed' "
                            + "AND applications.investor_verification_status = 'agreed'";
                    
                 // For each business ID, fetch application details and add to businessList
                    for (int businessId : businessIds) {
                        System.out.println("Processing business ID: " + businessId);

                        stmt = conn.prepareStatement(sql);
                        stmt.setInt(1, businessId);
                        rs = stmt.executeQuery();

                        while (rs.next()) {
                            int investorId = rs.getInt("investor_id");
                            String investorUsername = rs.getString("investor_username");
                            Business business = new Business(investorId, investorUsername);
                            businessList.add(business);

                            // Print out details for each retrieved row
                            System.out.println("Investor ID: " + investorId + ", Investor Username: " + investorUsername);
                        }
                    }
                }

else {
                    // If the user is not a business, fetch application details directly
                    sql = "SELECT "
                            + "applications.*, "
                            + "investor.username AS investor_username, "
                            + "investor.email AS investor_email, "
                            + "investor.contact_info AS investor_contact_info, "
                            + "investor.user_id AS investor_id, "
                            + "business.business_id AS business_id, "
                            + "business.business_name AS business_name, "
                            + "business_user.username AS business_username, "
                            + "business_user.email AS business_email, "
                            + "business_user.contact_info AS business_contact_info, "
                            + "business_user.user_id AS business_user_id "
                            + "FROM "
                            + "applications "
                            + "JOIN "
                            + "users AS investor ON applications.investor_id = investor.user_id "
                            + "JOIN "
                            + "businesses AS business ON applications.business_id = business.business_id "
                            + "JOIN "
                            + "users AS business_user ON business.user_id = business_user.user_id "
                            + "WHERE "
                            + "applications.investor_id = ? "
                            + "AND applications.application_status = 'agreed' "
                            + "AND applications.investor_verification_status = 'agreed'";
                    
                    stmt = conn.prepareStatement(sql);
                    stmt.setInt(1, userId);
                    rs = stmt.executeQuery();
                    
                    // Retrieve application details
                    while (rs.next()) {
                        int businessId = rs.getInt("business_id");
                        String businessName = rs.getString("business_name");
                        Business business = new Business(businessId, businessName);
                        businessList.add(business);
                        System.out.println("Business ID: " + businessId + ", Business Name: " + businessName);
                    }
                }

            } else {
                System.out.println("Failed to connect to database.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnector.closeResultSet(rs);
            DBConnector.closeStatement(stmt);
            DBConnector.closeConnection(conn);
        }

        request.setAttribute("businessList", businessList);
        request.getRequestDispatcher("/businesslist.jsp").forward(request, response);
    }
}
