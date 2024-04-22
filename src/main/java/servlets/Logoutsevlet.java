package servlets;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/logoutServlet")
public class Logoutsevlet extends HttpServlet {
	   private static final long serialVersionUID = 2L;
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false); // Retrieve existing session, if any

        if (session != null) {
            session.invalidate(); // Invalidate the session
            response.setStatus(HttpServletResponse.SC_OK);
        } else {
            // No session found
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Session not found");
        }
    }
}
