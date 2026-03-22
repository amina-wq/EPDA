package servlet.filter;

import java.io.IOException;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;


@WebFilter("/*")
public class AuthFilter implements Filter {
    private static final Set<String> PUBLIC_PAGES = new HashSet<>(Arrays.asList(
        "/login",
        "/reset_password",
        "/css/",
        "/js/",
        "/images/"
    ));

    private static final Set<String> ADMIN_ONLY_PAGES = new HashSet<>(Arrays.asList(
        "/users",
        "/create_user",
        "/edit_user",
        "/delete_user"
    )); // for example

    private static final Set<String> STAFF_PAGES = new HashSet<>(Arrays.asList(
        "/students",
        "/check_eligibility",
        "/confirm_registration",
        "/recovery_plans",
        "/reports",
        "/performance_dashboard",
        "/notifications"
    )); // for example

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        String uri = req.getRequestURI();
        String contextPath = req.getContextPath();
        String path = uri.substring(contextPath.length());

        if (isPublicPage(path)) {
            chain.doFilter(request, response);
            return;
        }

        User user = null;
        if (session != null) {
            user = (User) session.getAttribute("user");
        }

        if (user == null) {
            res.sendRedirect(contextPath + "/login");
            return;
        }

        String userRole = user.getRole();

        if (isAdminOnlyPage(path) && !"ADMIN".equals(userRole)) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied. Admin rights required.");
            return;
        }

        if (isStaffPage(path) && !("ADMIN".equals(userRole) || "OFFICER".equals(userRole))) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied. Staff rights required.");
            return;
        }

        chain.doFilter(request, response);
    }

    private boolean isPublicPage(String path) {
        for (String publicPath : PUBLIC_PAGES) {
            if (path.equals(publicPath) || path.startsWith(publicPath)) {
                return true;
            }
        }
        return false;
    }

    private boolean isAdminOnlyPage(String path) {
        for (String adminPath : ADMIN_ONLY_PAGES) {
            if (path.equals(adminPath) || path.startsWith(adminPath)) {
                return true;
            }
        }
        return false;
    }

    private boolean isStaffPage(String path) {
        for (String staffPath : STAFF_PAGES) {
            if (path.equals(staffPath) || path.startsWith(staffPath)) {
                return true;
            }
        }
        return false;
    }
}