package servlet.user;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import ejb.UserBean;
import ejb.NotificationBean;
import model.Notification;
import model.User;

@WebServlet("/reset_password")
public class ResetPasswordServlet extends HttpServlet {
    @EJB private UserBean userBean;
    @EJB private NotificationBean notificationBean;

    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String email = req.getParameter("email");
        String currentPass = req.getParameter("currentPassword");
        String newPass = req.getParameter("newPassword");
        String confirm = req.getParameter("confirmPassword");

        // FIXED: Use the new email-based authentication method
        User user = userBean.authenticateByEmail(email, currentPass);

        if (user != null) {
            if (newPass != null && newPass.equals(confirm)) {
                if (userBean.resetPasswordByEmail(email, newPass)) {
                    // Task 5 Alert
                    Notification n = new Notification();
                    n.setRecipientId(email);
                    n.setType("SECURITY_ALERT");
                    n.setSubject("Password Changed");
                    n.setContent("Your password has been updated.");
                    notificationBean.sendEmailNotification(n);

                    res.sendRedirect("login.jsp?message=reset_success");
                } else {
                    res.sendRedirect("resetPassword.jsp?error=db_error");
                }
            } else {
                res.sendRedirect("resetPassword.jsp?error=mismatch");
            }
        } else {
            res.sendRedirect("resetPassword.jsp?error=invalid_current");
        }
    }
}