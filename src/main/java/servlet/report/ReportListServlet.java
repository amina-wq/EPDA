package servlet.report;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import ejb.ReportBean;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/reports")
public class ReportListServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @EJB
    private ReportBean reportBean;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String search = request.getParameter("search");
        String program = request.getParameter("program");

        try {
            // 1. Fetch filtered list of students
            List<Map<String, Object>> studentList = reportBean.getStudentSummaries(program, search);
            
            // 2. Fetch all programs for the dropdown filter
            List<String> programs = reportBean.getUniquePrograms();

            // 3. Set attributes for reportDashboard.jsp
            request.setAttribute("studentList", studentList);
            request.setAttribute("programs", programs);
            
            // 4. Send back the current filter values 
            request.setAttribute("searchVal", search);
            request.setAttribute("selectedProgram", program);

            request.getRequestDispatcher("/reports/report.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Error generating student report list", e);
        }
    }
}