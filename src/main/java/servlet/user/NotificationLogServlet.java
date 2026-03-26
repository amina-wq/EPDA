package servlet.user;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import ejb.NotificationBean;
import model.Notification;


@WebServlet("/notifications")
public class NotificationLogServlet extends HttpServlet {
    @EJB private NotificationBean notificationBean;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        List<Notification> logs = notificationBean.getAllNotifications();

        req.setAttribute("notificationLogs", logs);

        req.getRequestDispatcher("user/notificationLogs.jsp").forward(req, res);
    }
}