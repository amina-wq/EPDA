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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        request.getRequestDispatcher("/user/login.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String u = req.getParameter("username");
        String p = req.getParameter("password");

        User authenticatedUser = userBean.authenticateUser(u, p);

        if (authenticatedUser != null) {
            HttpSession session = req.getSession();
            session.setAttribute("user", authenticatedUser);
            session.setAttribute("userId", user.getId());
            session.setAttribute("userRole", user.getRole());
            session.setAttribute("username", user.getUsername());

            res.sendRedirect(req.getContextPath() + "/");
        } else {
            res.sendRedirect(req.getContextPath() + "/user/login.jsp?error=invalid");
        }
    }
}