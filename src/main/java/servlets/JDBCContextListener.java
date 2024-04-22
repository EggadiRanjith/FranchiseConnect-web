package servlets;

import java.sql.SQLException;
import java.util.Enumeration;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

@WebListener
public class JDBCContextListener implements ServletContextListener {

    // Default constructor
    public JDBCContextListener() {
        // Initialization code here, if needed
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        deregisterDrivers();
        // Stop any threads associated with database connections
        // (If applicable)
    }

    private void deregisterDrivers() {
        Enumeration<java.sql.Driver> drivers = java.sql.DriverManager.getDrivers();
        while (drivers.hasMoreElements()) {
            try {
                java.sql.Driver driver = drivers.nextElement();
                java.sql.DriverManager.deregisterDriver(driver);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        // Do nothing on initialization
    }
}
