package servlet.user;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import ejb.UserBean;
import ejb.NotificationBean;
import model.Notification;

@WebServlet("/sendNotification")
public class SendNotificationServlet extends HttpServlet {
    @EJB private NotificationBean notificationBean;
    @EJB private UserBean userBean;

    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String recipient = req.getParameter("recipientId");
        
        if (userBean.isStudentValid(recipient)) {
            Notification n = new Notification();
            n.setRecipientId(recipient);
            n.setType(req.getParameter("type"));
            n.setSubject(req.getParameter("subject"));
            n.setContent(req.getParameter("content"));

            notificationBean.sendEmailNotification(n);
            res.sendRedirect("dashboard.jsp?status=sent");
        } else {
            res.sendRedirect("sendNotification.jsp?error=invalid_student");
        }
    }
}