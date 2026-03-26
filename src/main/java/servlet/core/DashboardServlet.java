package servlet.core;

import java.io.IOException;

import ejb.DashboardBean;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


@WebServlet("")
public class DashboardServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	@EJB
    private DashboardBean dashboardBean;

    @Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("totalStudents", dashboardBean.getTotalStudents());
        request.setAttribute("ineligibleCount", dashboardBean.getIneligibleCount());
        request.setAttribute("activePlans", dashboardBean.getActivePlansCount());
        request.setAttribute("completedPlans", dashboardBean.getCompletedPlansCount());
        request.setAttribute("pendingNotifications", dashboardBean.getPendingNotificationsCount());

        request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
    }
}