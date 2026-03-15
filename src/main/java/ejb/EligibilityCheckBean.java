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
import jakarta.ejb.LocalBean;
import jakarta.ejb.Stateless;
import model.Student;

@Stateless
@LocalBean
public class EligibilityCheckBean {

	@Resource(name = "mysql")
	private DataSource dataSource;

	public List<Student> getAllStudents() {
		List<Student> students = new ArrayList<>();
		String query = "SELECT * FROM student";

		try (Connection conn = dataSource.getConnection();
				Statement stmt = conn.createStatement();
				ResultSet rs = stmt.executeQuery(query)) {

			while (rs.next()) {
				Student s = new Student();
				s.setStudentId(rs.getString("id"));
				s.setName(rs.getString("name"));
				s.setProgram(rs.getString("program"));
				s.setEmail(rs.getString("email"));
				s.setIsEligible(rs.getBoolean("is_eligible"));
				students.add(s);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return students;
	}
	
	public double calculateCGPA(String studentId) {
        String query = "SELECT e.grade, c.credits FROM enrollment e " +
                     "JOIN course c ON e.course_id = c.id " +
                     "WHERE e.student_id = ? AND e.status = 'PASSED'";
        
        double totalGradePoints = 0;
        int totalCredits = 0;
        
        try (Connection conn = dataSource.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setString(1, studentId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                float grade = rs.getFloat("grade");
                int credits = rs.getInt("credits");
                
                totalGradePoints += grade * credits;
                totalCredits += credits;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        if (totalCredits == 0) return 0.0;
        return totalGradePoints / totalCredits;
    }
	
	public int countFailedCourses(String studentId) {
        String query = "SELECT COUNT(*) as failed_count FROM enrollment " +
                     "WHERE student_id = ? AND status = 'FAILED'";
        
        try (Connection conn = dataSource.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setString(1, studentId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("failed_count");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
	
	public Map<String, Object> getStudentStats(String studentId) {
        Map<String, Object> stats = new HashMap<>();
        
        double cgpa = calculateCGPA(studentId);
        int failedCount = countFailedCourses(studentId);
        
        stats.put("studentId", studentId);
        stats.put("cgpa", cgpa);
        stats.put("failedCount", failedCount);
        stats.put("isEligible", cgpa >= 2.0 && failedCount <= 3);
        
        if (cgpa < 2.0 && failedCount > 3) {
            stats.put("reason", "CGPA below 2.0 and more than 3 failed courses");
        } else if (cgpa < 2.0) {
            stats.put("reason", "CGPA below 2.0");
        } else if (failedCount > 3) {
            stats.put("reason", "More than 3 failed courses");
        }
        
        return stats;
    }
	
	public List<Map<String, Object>> getIneligibleStudents() {
        List<Map<String, Object>> ineligibleList = new ArrayList<>();
        List<Student> allStudents = getAllStudents();
        
        for (Student student : allStudents) {
            Map<String, Object> stats = getStudentStats(student.getStudentId());
            boolean isEligible = (boolean) stats.get("isEligible") || student.getIsEligible();
            
            if (!isEligible) {
                Map<String, Object> studentInfo = new HashMap<>();
                studentInfo.put("student", student);
                studentInfo.put("cgpa", stats.get("cgpa"));
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
}