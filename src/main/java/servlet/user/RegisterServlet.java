package servlet.user;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import ejb.UserBean;
import ejb.NotificationBean;
import model.Notification;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    @EJB private UserBean userBean;
    @EJB private NotificationBean notificationBean;

    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String username = req.getParameter("username");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String role = req.getParameter("role");

        // Attempt to save to database
        if (userBean.registerUser(username, email, password, role)) {
            
            // Task 5: Log the creation of a new staff account
            Notification n = new Notification();
            n.setRecipientId(email);
            n.setType("ACCOUNT_CREATED");
            n.setSubject("Staff Account Created");
            n.setContent("A new " + role + " account has been created for " + username);
            notificationBean.sendEmailNotification(n);

            res.sendRedirect("users?status=registered");
        } else {
            res.sendRedirect("register.jsp?error=failed");
        }
    }
}