package servlet.report;

import java.io.IOException;
import java.util.Map;
import ejb.ReportBean;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Controller for generating individual academic transcripts.
 */
@WebServlet("/student_report")
public class StudentReportServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @EJB
    private ReportBean reportBean;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Get the ID from the button click
        String studentId = request.getParameter("studentId");
        
        // 2. Validation: If no ID, go back to the dashboard
        if (studentId == null || studentId.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/reports");
            return;
        }

        try {
            // 3. Fetch the grouped data (Passed vs Failed) from your Bean
            Map<String, Object> report = reportBean.getFullAcademicReport(studentId);
            
            // 4. Attach data to the request
            request.setAttribute("report", report);
            
            // 5. Forward to your newly created studentReport.jsp
            request.getRequestDispatcher("/reports/studentReport.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            // Handle error 
            throw new ServletException("Error retrieving report for student: " + studentId, e);
        }
    }
}