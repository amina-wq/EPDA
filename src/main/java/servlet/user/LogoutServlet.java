package servlet.user;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * We handle both GET and POST to ensure that whether the user clicks 
     * a link or a form button, they are successfully signed out.
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processLogout(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processLogout(request, response);
    }

    private void processLogout(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. ACCESS THE SESSION: Find the current user's digital 'badge'
        HttpSession session = request.getSession(false);

        if (session != null) {
            // 2. INVALIDATE: This effectively 'shreds' the session data.
            // All attributes (like the "user" object) are deleted instantly.
            session.invalidate();
        }

        // 3. REDIRECT: Send the user back to the public 'front door'
        // We add a message so the login page can show a 'Logged out' notification.
        response.sendRedirect(request.getContextPath() + "/login.jsp?message=logged_out");
    }
}