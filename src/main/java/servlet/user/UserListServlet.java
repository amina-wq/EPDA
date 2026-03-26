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


@WebServlet("/users")
public class UserListServlet extends HttpServlet {
    @EJB private UserBean userBean;
    @EJB private NotificationBean notificationBean;

    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        req.setAttribute("userList", userBean.getAllUsers());
        req.getRequestDispatcher("user/userList.jsp").forward(req, res);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
    	User admin = (User) req.getSession().getAttribute("user");
    	
    	String idStr = req.getParameter("userId");
        String action = req.getParameter("action");
        String status = "error";

        if (idStr != null && action != null) {
            Long id = Long.parseLong(idStr);
            boolean success = false;
            String logMsg = "";

            if ("deactivate".equals(action)) {
                success = userBean.updateUserStatus(id, false);
                logMsg = "Deactivated by " + admin.getUsername();
                if(success) status = "deactivated";
            } else if ("reactivate".equals(action)) {
                success = userBean.updateUserStatus(id, true);
                logMsg = "Reactivated by " + admin.getUsername();
                if(success) status = "reactivated";
            } else if ("reset".equals(action)) {
                success = userBean.resetPassword(id, "Temp123!");
                logMsg = "Password reset to Temp123! by " + admin.getUsername();
                if(success) status = "reset_success";
            }

            if (success) {
                User target = userBean.getUserById(id);
                Notification n = new Notification();
                n.setRecipientId(target.getEmail());
                n.setType("SECURITY_ALERT");
                n.setSubject("Staff Account Security Update");
                n.setContent(logMsg);
                notificationBean.sendEmailNotification(n);
            }
        }
        res.sendRedirect(req.getContextPath() + "/users?status=" + status);
    }
}