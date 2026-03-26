package ejb;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import jakarta.annotation.Resource;
import jakarta.ejb.EJB;
import jakarta.ejb.LocalBean;
import jakarta.ejb.Stateless;
import model.Student;

@Stateless
@LocalBean
public class EligibilityCheckBean {

	@Resource(name = "mysql")
	private DataSource dataSource;

    @EJB
    private StudentsBean studentsBean;

	public Map<String, Object> getEligibilityDashboardStats() {
        Map<String, Object> stats = new HashMap<>();

        String query = "SELECT " +
                     "COUNT(*) as total_students, " +
                     "SUM(CASE WHEN is_eligible THEN 1 ELSE 0 END) as confirmed_count " +
                     "FROM student";

        try (Connection conn = dataSource.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {

            if (rs.next()) {
                stats.put("totalStudents", rs.getInt("total_students"));
                stats.put("confirmedCount", rs.getInt("confirmed_count"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        List<Map<String, Object>> ineligible = getIneligibleStudents();
        stats.put("ineligibleCount", ineligible.size());
        stats.put("ineligibleStudents", ineligible);

        return stats;
    }

	private List<Map<String, Object>> getIneligibleStudents() {
        List<Map<String, Object>> ineligibleList = new ArrayList<>();
        List<Student> allStudents = studentsBean.getAllStudents();

        for (Student student : allStudents) {
            Map<String, Object> stats = studentsBean.getStudentStats(student.getStudentId());

            student.setCgpa((double) stats.get("cgpa"));

            boolean isEligible = (boolean) stats.get("isEligible") || student.getIsEligible();

            if (!isEligible) {
                Map<String, Object> studentInfo = new HashMap<>();
                studentInfo.put("student", student);
                studentInfo.put("failedCount", stats.get("failedCount"));
                studentInfo.put("reason", stats.get("reason"));
                ineligibleList.add(studentInfo);
            }
        }

        return ineligibleList;
    }

	public void confirmEligibility(String studentId) {
        String query = "UPDATE student SET is_eligible = TRUE WHERE id = ?";

        try (Connection conn = dataSource.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setString(1, studentId);
            pstmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Error confirming eligibility for student: " + studentId, e);
        }
    }
}