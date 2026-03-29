package servlet.recovery;

import java.io.IOException;
import java.util.Map;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import ejb.RecoveryPlanBean;
import model.RecoveryPlan;

@WebServlet("/setup_plan")
public class StudentRecoveryPlansServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @EJB
    private RecoveryPlanBean recoveryPlanBean;

    /**
     * GET: Handles Loading the Form
     * Modes: CREATE (New), EDIT (Active), VIEW (Completed/Cancelled)
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String studentId = request.getParameter("studentId");
        String courseId = request.getParameter("courseId");
        String planIdParam = request.getParameter("planId");

        try {
            if (planIdParam != null && !planIdParam.isEmpty()) {
                // SCENARIO: View or Edit Existing Plan
                long planId = Long.parseLong(planIdParam);
                RecoveryPlan plan = recoveryPlanBean.getPlanWithMilestones(planId);
                
                request.setAttribute("plan", plan);
                
                // Logic: Only ACTIVE plans can be edited
                boolean isLocked = !"ACTIVE".equals(plan.getStatus());
                request.setAttribute("isLocked", isLocked);
                request.setAttribute("mode", isLocked ? "VIEW" : "EDIT");
            } 
            else if (studentId != null && courseId != null) {
                // SCENARIO: Create Brand New Plan
                Map<String, Object> details = recoveryPlanBean.getFailureDetails(studentId, courseId);
                
                request.setAttribute("details", details);
                request.setAttribute("studentId", studentId);
                request.setAttribute("courseId", courseId);
                request.setAttribute("isLocked", false);
                request.setAttribute("mode", "CREATE");
            }

            request.getRequestDispatcher("/recovery/setupForm.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Error loading recovery plan details", e);
        }
    }

    /**
     * POST: Handles Saving/Updating the Form
     * Triggered by the "Save Recovery Changes" button
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Get Plan Level Data (Including the new planStatus)
        String planIdStr = request.getParameter("planId");
        String studentId = request.getParameter("studentId");
        String courseId = request.getParameter("courseId");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String planStatus = request.getParameter("planStatus"); // NEW

        // 2. Get Milestone Arrays (The 6 columns from the table)
        String[] weeks = request.getParameterValues("mWeek[]");
        String[] tasks = request.getParameterValues("mTask[]");
        String[] deadlines = request.getParameterValues("mDeadline[]");
        String[] mStatuses = request.getParameterValues("mStatus[]");   // NEW
        String[] mGrades = request.getParameterValues("mGrade[]");       // NEW
        String[] mComments = request.getParameterValues("mComments[]"); // NEW

        try {
            // 3. Call the updated Bean method (Passing all 12 parameters)
            recoveryPlanBean.saveOrUpdatePlan(
                planIdStr, studentId, courseId, startDate, endDate, planStatus,
                weeks, tasks, deadlines, mStatuses, mGrades, mComments
            );

            // 4. Redirect back to the dashboard on success
            response.sendRedirect("recovery_plans?status=updated");
            
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Failed to save recovery plan changes", e);
        }
    }
}