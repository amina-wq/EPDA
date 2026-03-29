package servlet.recovery;

import java.io.IOException;
import java.util.List;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import ejb.RecoveryPlanBean;
import model.RecoveryPlan;

/**
 * Servlet to handle the selection of students who need a new recovery plan.
 * Accesses planMilestone.jsp
 */
@WebServlet("/plan_milestone")
public class PlanMilestoneServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @EJB
    private RecoveryPlanBean recoveryPlanBean;

    /**
     * Handles GET requests to display the list of candidates for recovery.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            // 1. Fetch the unique programs from the student table for the JSP filter dropdown
            List<String> programs = recoveryPlanBean.getUniquePrograms();
            
            // 2. Fetch students who have a 'FAILED' enrollment status 
            // but do NOT have an entry in the recovery_plan table for that course.
            List<RecoveryPlan> candidates = recoveryPlanBean.getStudentsNeedingPlans();

            // 3. Set the data as request attributes so the JSP can access them
            request.setAttribute("programs", programs);
            request.setAttribute("candidates", candidates);

            // 4. Forward the request to the JSP file
            // Note: Ensure the filename 'planMilestone.jsp' matches your file's case exactly.
            request.getRequestDispatcher("/recovery/planMilestone.jsp").forward(request, response);
            
        } catch (Exception e) {
            // Log the error and show a generic error message to the user
            e.printStackTrace();
            throw new ServletException("Error loading the Recovery Plan Milestone page", e);
        }
    }

    /**
     * Redirects POST requests to the doGet method.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}