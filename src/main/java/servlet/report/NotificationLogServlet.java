package servlet.report;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import ejb.NotificationBean;
import model.Notification;

@WebServlet("/NotificationLogServlet")
public class NotificationLogServlet extends HttpServlet {
    @EJB private NotificationBean notificationBean;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        // 1. Fetch data from the Bean we just updated
        List<Notification> logs = notificationBean.getAllNotifications();
        
        // 2. Put the data in the request "envelope"
        req.setAttribute("notificationLogs", logs);
        
        // 3. Send the user to the JSP (adjust path if it's in a subfolder)
        req.getRequestDispatcher("reports/notificationLogs.jsp").forward(req, res);
    }
}