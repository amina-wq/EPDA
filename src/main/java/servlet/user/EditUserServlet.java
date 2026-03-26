package servlet.user;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import ejb.UserBean;
import ejb.NotificationBean;
import model.User;
import model.Notification;

@WebServlet("/editUser")
public class EditUserServlet extends HttpServlet {
    @EJB private UserBean userBean;
    @EJB private NotificationBean notificationBean;

    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String idParam = req.getParameter("id");
        if (idParam != null) {
            Long id = Long.parseLong(idParam);
            User u = userBean.getUserById(id);
            req.setAttribute("targetUser", u);
            req.getRequestDispatcher("editUser.jsp").forward(req, res);
        } else {
            res.sendRedirect("users");
        }
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        Long id = Long.parseLong(req.getParameter("userId"));
        String username = req.getParameter("username");
        String email = req.getParameter("email");
        String role = req.getParameter("role");

        if (userBean.updateUser(id, username, email, role)) {
            // Task 5 Integration: Log the edit as a notification
            Notification n = new Notification();
            n.setRecipientId(email);
            n.setType("SECURITY_ALERT");
            n.setSubject("Account Details Updated");
            n.setContent("Admin has updated your account details (Role: " + role + ").");
            notificationBean.sendEmailNotification(n);

            res.sendRedirect("users?status=updated");
        } else {
            res.sendRedirect("editUser?id=" + id + "&error=failed");
        }
    }
}