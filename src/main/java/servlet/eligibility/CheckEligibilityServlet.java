package servlet.eligibility;

import java.io.IOException;
import java.util.Map;

import ejb.EligibilityCheckBean;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/check_eligibility")
public class CheckEligibilityServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	@EJB
    private EligibilityCheckBean eligibilityBean;
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Map<String, Object> dashboardStats = eligibilityBean.getEligibilityDashboardStats();
        
        request.setAttribute("ineligibleStudents", dashboardStats.get("ineligibleStudents"));
        request.setAttribute("dashboardStats", dashboardStats);
        
        request.getRequestDispatcher("/eligibility/checkEligibility.jsp").forward(request, response);
    }
}
