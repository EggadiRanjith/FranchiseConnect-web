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
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve form parameters
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Check credentials
        boolean isAuthenticated = authenticate(email, password);

        // Set message based on authentication result
        String message;
        if (isAuthenticated) {
            // Get user ID and type from the database
            UserData userData = getUserDataByEmail(email);

            // Save user ID and type in session
            HttpSession session = request.getSession();
            session.setAttribute("userId", userData.getUserId());
            session.setAttribute("userType", userData.getUserType());

            // Print session attributes in console
            System.out.println("User ID stored in session: " + userData.getUserId());
            System.out.println("User type stored in session: " + userData.getUserType());

            // Forward to a new page upon successful login
            System.out.println("Forwarding to main.jsp with userType: " + userData.getUserType());
            response.sendRedirect("main.jsp");
            return;
        } else {
            message = "Error: Invalid email or password.";
        }

        // Forward message to the login page
        request.setAttribute("message", message);
        request.getRequestDispatcher("/Login.jsp").forward(request, response);
    }

    private boolean authenticate(String email, String password) {
        // Database authentication logic
        boolean isAuthenticated = false;
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            // Attempt to establish a database connection
            conn = DBConnector.getConnection();
            if (conn != null) {
                // Query to retrieve the password for the given email
                String sql = "SELECT password FROM users WHERE email = ?";
                stmt = conn.prepareStatement(sql);
                stmt.setString(1, email);
                rs = stmt.executeQuery();
                if (rs.next()) {
                    String storedPassword = rs.getString("password");
                    // Compare the passwords
                    isAuthenticated = password.equals(storedPassword);
                }
            } else {
                System.out.println("Failed to connect to database.");
            }
        } catch (SQLException e) {
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
            if (stmt != null) {
                try {
                    stmt.close();
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

        return isAuthenticated;
    }

    private UserData getUserDataByEmail(String email) {
        UserData userData = null;
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            // Attempt to establish a database connection
            conn = DBConnector.getConnection();
            if (conn != null) {
                // Query to retrieve the user ID and type for the given email
                String sql = "SELECT user_id, user_type FROM users WHERE email = ?";
                stmt = conn.prepareStatement(sql);
                stmt.setString(1, email);
                rs = stmt.executeQuery();
                if (rs.next()) {
                    // Retrieve user ID and type from the result set
                    int userId = rs.getInt("user_id");
                    String userType = rs.getString("user_type");
                    // Create UserData object
                    userData = new UserData(userId, userType);
                }
            } else {
                System.out.println("Failed to connect to database.");
            }
        } catch (SQLException e) {
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
            if (stmt != null) {
                try {
                    stmt.close();
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

        return userData;
    }
}

class UserData {
    private int userId;
    private String userType;

    public UserData(int userId, String userType) {
        this.userId = userId;
        this.userType = userType;
    }

    public int getUserId() {
        return userId;
    }

    public String getUserType() {
        return userType;
    }
}
