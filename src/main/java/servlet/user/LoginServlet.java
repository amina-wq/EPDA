package servlet.user;

import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import ejb.UserBean;
import model.User;


@WebServlet("/login")
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
            session.setAttribute("userId", authenticatedUser.getId());
            session.setAttribute("userRole", authenticatedUser.getRole());
            session.setAttribute("username", authenticatedUser.getUsername());

            res.sendRedirect(req.getContextPath() + "/");
        } else {
        	req.setAttribute("error", "Invalid username or password");
        	req.getRequestDispatcher("/user/login.jsp").forward(req, res);
        }
    }
}