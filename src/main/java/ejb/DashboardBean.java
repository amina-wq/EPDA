package ejb;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
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
public class DashboardBean {

	@Resource(name = "mysql")
	private DataSource dataSource;

    @EJB
    private StudentsBean studentsBean;

	public int getTotalStudents() {
        String sql = "SELECT COUNT(*) FROM student";

        try (Connection conn = dataSource.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

	public int getIneligibleCount() {
        List<Student> allStudents = studentsBean.getAllStudents();
        int ineligibleCount = 0;

        for (Student student : allStudents) {
            if (student.getIsEligible()) {
                continue;
            }

            Map<String, Object> stats = studentsBean.getStudentStats(student.getStudentId());
            boolean isEligibleByCriteria = (boolean) stats.get("isEligible");

            if (!isEligibleByCriteria) {
                ineligibleCount++;
            }
        }

        return ineligibleCount;
    }

	public int getActivePlansCount() {
        String sql = "SELECT COUNT(*) FROM recovery_plan WHERE status = 'ACTIVE'";

        try (Connection conn = dataSource.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

	public int getCompletedPlansCount() {
        String sql = "SELECT COUNT(*) FROM recovery_plan WHERE status = 'COMPLETED'";

        try (Connection conn = dataSource.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getPendingNotificationsCount() {
        String sql = "SELECT COUNT(*) FROM notification WHERE status = 'PENDING'";

        try (Connection conn = dataSource.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}
