package servlet.recovery;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import ejb.RecoveryPlanBean;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.RecoveryPlan;

@WebServlet("/recovery_plans")
public class RecoveryPlanServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @EJB
    private RecoveryPlanBean recoveryPlanBean;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. Capture the search and program filters from the request
        String search = request.getParameter("search");
        String program = request.getParameter("program");

        try {
            // 2. Use getFilteredPlans (this handles the table rows)
            List<RecoveryPlan> plans = recoveryPlanBean.getFilteredPlans(program, search);
            
            // 3. Reverting to the simple status counts (no parameters)
            Map<String, Integer> counts = recoveryPlanBean.getStatusCounts();
            List<String> programs = recoveryPlanBean.getUniquePrograms();

            // 4. Set attributes for the JSP
            request.setAttribute("plans", plans);
            request.setAttribute("counts", counts);
            request.setAttribute("programs", programs);
            
            // 5. Pass the filter values back
            request.setAttribute("searchVal", search);
            request.setAttribute("selectedProgram", program);
            
            // Double check this path! 
            request.getRequestDispatcher("/recovery/studentRecovery.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace(); // Log the error to the Eclipse console
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}