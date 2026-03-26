package servlet.user;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import ejb.UserBean;
import model.User;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    @EJB private UserBean userBean;

    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String u = req.getParameter("username");
        String p = req.getParameter("password");
        
        User authenticatedUser = userBean.authenticateUser(u, p);
        
        if (authenticatedUser != null) {
            HttpSession session = req.getSession();
            session.setAttribute("user", authenticatedUser);
            res.sendRedirect(req.getContextPath() + "/dashboard.jsp");
        } else {
            res.sendRedirect(req.getContextPath() + "/login.jsp?error=invalid");
        }
    }
}