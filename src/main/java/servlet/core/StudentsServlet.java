package servlet.core;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import ejb.StudentsBean;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Student;


@WebServlet("/students")
public class StudentsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @EJB
    private StudentsBean studentsBean;

    @Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String programFilter = request.getParameter("program");
        String eligibleFilter = request.getParameter("eligible");
        String searchQuery = request.getParameter("search");

        List<Student> allStudents = studentsBean.getAllStudents();

        List<Student> filteredStudents = allStudents;

        for (Student student : filteredStudents) {
            Map<String, Object> stats = studentsBean.getStudentStats(student.getStudentId());
            student.setCgpa((double) stats.get("cgpa"));

            boolean isEligibleByCriteria = (boolean) stats.get("isEligible");
            boolean isConfirmed = student.getIsEligible();
            student.setIsEligible(isEligibleByCriteria || isConfirmed);
        }

        if (programFilter != null && !programFilter.isEmpty() && !"all".equals(programFilter)) {
            filteredStudents = filteredStudents.stream()
                .filter(s -> programFilter.equals(s.getProgram()))
                .collect(java.util.stream.Collectors.toList());
        }

        if (eligibleFilter != null && !eligibleFilter.isEmpty() && !"all".equals(eligibleFilter)) {
            boolean showEligible = "yes".equals(eligibleFilter);
            filteredStudents = filteredStudents.stream()
                .filter(s -> showEligible == s.getIsEligible())
                .collect(java.util.stream.Collectors.toList());
        }

        if (searchQuery != null && !searchQuery.isEmpty()) {
            String searchLower = searchQuery.toLowerCase();
            filteredStudents = filteredStudents.stream()
                .filter(s -> s.getName().toLowerCase().contains(searchLower) ||
                             s.getStudentId().toLowerCase().contains(searchLower))
                .collect(java.util.stream.Collectors.toList());
        }

        List<String> allPrograms = studentsBean.getAllPrograms();
        Map<String, Integer> programStats = studentsBean.getStudentsByProgram();

        long eligibleCount = filteredStudents.stream().filter(Student::getIsEligible).count();
        long ineligibleCount = filteredStudents.size() - eligibleCount;

        request.setAttribute("students", filteredStudents);
        request.setAttribute("allPrograms", allPrograms);
        request.setAttribute("programStats", programStats);
        request.setAttribute("totalCount", filteredStudents.size());
        request.setAttribute("eligibleCount", eligibleCount);
        request.setAttribute("ineligibleCount", ineligibleCount);
        request.setAttribute("selectedProgram", programFilter);
        request.setAttribute("selectedEligible", eligibleFilter);
        request.setAttribute("searchQuery", searchQuery);

        request.getRequestDispatcher("/core/students.jsp").forward(request, response);
    }
}