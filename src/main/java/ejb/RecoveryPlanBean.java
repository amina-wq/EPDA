package ejb;

import java.sql.*;
import java.util.*;
import javax.sql.DataSource;
import jakarta.annotation.Resource;
import jakarta.ejb.LocalBean;
import jakarta.ejb.Stateless;
import model.RecoveryPlan;
import model.Student;
import model.Course;
import model.RecoveryMilestone;

@Stateless
@LocalBean
public class RecoveryPlanBean {

    @Resource(name = "mysql")
    private DataSource dataSource;

    public List<RecoveryPlan> getAllPlans() throws SQLException {
        return getFilteredPlans(null, null);
    }

    /**
     * Reverted to standard JOIN for baseline testing
     */
    public List<RecoveryPlan> getFilteredPlans(String program, String search) throws SQLException {
        List<RecoveryPlan> plans = new ArrayList<>();
        
        StringBuilder sql = new StringBuilder(
            "SELECT rp.*, s.name, s.program, c.title " +
            "FROM recovery_plan rp " +
            "JOIN student s ON rp.student_id = s.id " +
            "JOIN course c ON rp.course_id = c.id WHERE 1=1 "
        );

        if (program != null && !program.isEmpty() && !program.equals("All Programs")) {
            sql.append(" AND s.program = ? ");
        }
        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (s.id LIKE ? OR s.name LIKE ?) ");
        }
        
        sql.append(" ORDER BY rp.start_date DESC");

        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            int paramIdx = 1;
            if (program != null && !program.isEmpty() && !program.equals("All Programs")) {
                ps.setString(paramIdx++, program);
            }
            if (search != null && !search.trim().isEmpty()) {
                String pattern = "%" + search.trim() + "%";
                ps.setString(paramIdx++, pattern);
                ps.setString(paramIdx++, pattern);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    RecoveryPlan p = new RecoveryPlan();
                    p.setId(rs.getLong("id"));
                    p.setStudentId(rs.getString("student_id"));
                    p.setCourseId(rs.getString("course_id"));
                    p.setStartDate(rs.getDate("start_date"));
                    p.setEndDate(rs.getDate("end_date"));
                    p.setStatus(rs.getString("status"));

                    Student s = new Student();
                    s.setName(rs.getString("name"));
                    s.setProgram(rs.getString("program"));
                    p.setStudent(s);

                    Course c = new Course();
                    c.setTitle(rs.getString("title"));
                    p.setCourse(c);

                    plans.add(p);
                }
            }
        }
        return plans;
    }

    
    public Map<String, Integer> getStatusCounts() throws SQLException {
        Map<String, Integer> counts = new HashMap<>();
        counts.put("ACTIVE", 0);
        counts.put("COMPLETED", 0);
        counts.put("CANCELLED", 0);

        String sql = "SELECT status, COUNT(*) as cnt FROM recovery_plan GROUP BY status";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                String status = rs.getString("status");
                if (status != null) {
                    counts.put(status.toUpperCase(), rs.getInt("cnt"));
                }
            }
        }
        return counts;
    }

    public List<String> getUniquePrograms() throws SQLException {
        List<String> programs = new ArrayList<>();
        String sql = "SELECT DISTINCT program FROM student ORDER BY program ASC";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                String prog = rs.getString("program");
                if (prog != null && !prog.isEmpty()) {
                    programs.add(prog);
                }
            }
        }
        return programs;
    }

    public List<RecoveryPlan> getStudentsNeedingPlans() throws SQLException {
        List<RecoveryPlan> candidates = new ArrayList<>();
        String sql = "SELECT s.id, s.name, s.program, c.id AS course_id, c.title " +
                     "FROM student s " +
                     "JOIN enrollment e ON s.id = e.student_id " +
                     "JOIN course c ON e.course_id = c.id " +
                     "LEFT JOIN recovery_plan rp ON s.id = rp.student_id AND e.course_id = rp.course_id " +
                     "WHERE e.status = 'FAILED' AND rp.id IS NULL";

        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                RecoveryPlan p = new RecoveryPlan();
                Student s = new Student();
                s.setStudentId(rs.getString("id")); 
                s.setName(rs.getString("name"));
                s.setProgram(rs.getString("program"));
                p.setStudent(s);
                
                Course c = new Course();
                c.setCourseId(rs.getString("course_id")); 
                c.setTitle(rs.getString("title"));
                p.setCourse(c);
                candidates.add(p);
            }
        }
        return candidates;
    }

    public Map<String, Object> getFailureDetails(String studentId, String courseId) throws SQLException {
        Map<String, Object> details = new HashMap<>();
        String sql = "SELECT s.name, s.program, e.id as enroll_id, e.semester, e.attempt_number, e.grade, c.title, " +
                     "fc.component_type, fc.component_name, fc.score, fc.passing_score " +
                     "FROM student s " +
                     "JOIN enrollment e ON s.id = e.student_id " +
                     "JOIN course c ON e.course_id = c.id " +
                     "LEFT JOIN failed_component fc ON e.id = fc.enrollment_id " +
                     "WHERE s.id = ? AND c.id = ? AND e.status = 'FAILED'";

        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, studentId);
            ps.setString(2, courseId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    details.put("name", rs.getString("name"));
                    details.put("program", rs.getString("program"));
                    details.put("enrollId", rs.getLong("enroll_id"));
                    details.put("semester", rs.getString("semester"));
                    details.put("attempt", rs.getInt("attempt_number"));
                    details.put("grade", rs.getFloat("grade"));
                    details.put("courseTitle", rs.getString("title"));
                    details.put("compType", rs.getString("component_type"));
                    details.put("compName", rs.getString("component_name"));
                    details.put("compScore", rs.getFloat("score"));
                    details.put("passScore", rs.getFloat("passing_score"));
                }
            }
        }
        return details;
    }

    public RecoveryPlan getPlanWithMilestones(long planId) throws SQLException {
        RecoveryPlan plan = null;
        String sql = "SELECT rp.*, s.name, s.program, c.title, " +
                     "e.id as enroll_id, e.semester, e.attempt_number, e.grade as fail_grade, " +
                     "fc.component_type, fc.component_name, fc.score, fc.passing_score " +
                     "FROM recovery_plan rp " +
                     "JOIN student s ON rp.student_id = s.id " +
                     "JOIN course c ON rp.course_id = c.id " +
                     "JOIN enrollment e ON s.id = e.student_id AND c.id = e.course_id " +
                     "LEFT JOIN failed_component fc ON e.id = fc.enrollment_id " +
                     "WHERE rp.id = ? AND e.status = 'FAILED'";

        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, planId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    plan = new RecoveryPlan();
                    plan.setId(rs.getLong("id"));
                    plan.setStatus(rs.getString("status"));
                    plan.setStartDate(rs.getDate("start_date"));
                    plan.setEndDate(rs.getDate("end_date"));
                    plan.setSemester(rs.getString("semester"));
                    plan.setAttemptNumber(rs.getInt("attempt_number"));
                    plan.setFailedGrade(rs.getFloat("fail_grade"));

                    plan.setEnrollmentId(rs.getLong("enroll_id"));
                    plan.setComponentType(rs.getString("component_type"));
                    plan.setComponentName(rs.getString("component_name"));
                    plan.setScore(rs.getFloat("score"));
                    plan.setPassingScore(rs.getFloat("passing_score"));

                    Student s = new Student();
                    s.setStudentId(rs.getString("student_id"));
                    s.setName(rs.getString("name"));
                    s.setProgram(rs.getString("program"));
                    plan.setStudent(s);

                    Course c = new Course();
                    c.setCourseId(rs.getString("course_id"));
                    c.setTitle(rs.getString("title"));
                    plan.setCourse(c);

                    plan.setMilestones(getMilestonesByPlanId(planId, conn));
                }
            }
        }
        return plan;
    }

    private List<RecoveryMilestone> getMilestonesByPlanId(long planId, Connection conn) throws SQLException {
        List<RecoveryMilestone> list = new ArrayList<>();
        String sql = "SELECT * FROM recovery_milestone WHERE recovery_plan_id = ? ORDER BY deadline ASC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, planId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    RecoveryMilestone m = new RecoveryMilestone();
                    m.setId(rs.getLong("id"));
                    m.setWeekRange(rs.getString("week_range"));
                    m.setTask(rs.getString("task"));
                    m.setDeadline(rs.getDate("deadline"));
                    m.setStatus(rs.getString("status"));
                    m.setGrade(rs.getFloat("grade"));
                    m.setComments(rs.getString("comments"));
                    list.add(m);
                }
            }
        }
        return list;
    }
    
    public void saveOrUpdatePlan(String planIdStr, String studentId, String courseId, String start, String end, String planStatus,
            String[] weeks, String[] tasks, String[] deadlines, String[] mStatuses, String[] mGrades, String[] mComments) throws SQLException {

        try (Connection conn = dataSource.getConnection()) {
            long actualPlanId;

            if (planIdStr == null || planIdStr.trim().isEmpty() || planIdStr.equals("null")) {
                String sql = "INSERT INTO recovery_plan (student_id, course_id, start_date, end_date, status) VALUES (?, ?, ?, ?, 'ACTIVE')";
                try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                    ps.setString(1, studentId);
                    ps.setString(2, courseId);
                    ps.setDate(3, java.sql.Date.valueOf(start));
                    ps.setDate(4, java.sql.Date.valueOf(end));
                    ps.executeUpdate();
                    
                    try (ResultSet rs = ps.getGeneratedKeys()) {
                        if (rs.next()) {
                            actualPlanId = rs.getLong(1);
                        } else {
                            throw new SQLException("Failed to retrieve generated plan ID.");
                        }
                    }
                }
            } else {
                actualPlanId = Long.parseLong(planIdStr);
                String sql = "UPDATE recovery_plan SET start_date = ?, end_date = ?, status = ? WHERE id = ?";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setDate(1, java.sql.Date.valueOf(start));
                    ps.setDate(2, java.sql.Date.valueOf(end));
                    ps.setString(3, planStatus);
                    ps.setLong(4, actualPlanId);
                    ps.executeUpdate();
                }
                
                try (PreparedStatement psD = conn.prepareStatement("DELETE FROM recovery_milestone WHERE recovery_plan_id = ?")) {
                    psD.setLong(1, actualPlanId);
                    psD.executeUpdate();
                }
            }

            if (weeks != null && weeks.length > 0) {
                String sqlM = "INSERT INTO recovery_milestone (recovery_plan_id, week_range, task, deadline, status, grade, comments) VALUES (?, ?, ?, ?, ?, ?, ?)";
                try (PreparedStatement psM = conn.prepareStatement(sqlM)) {
                    for (int i = 0; i < weeks.length; i++) {
                        if (weeks[i] == null || weeks[i].trim().isEmpty()) continue;
                        
                        psM.setLong(1, actualPlanId);
                        psM.setString(2, weeks[i]);
                        psM.setString(3, tasks[i]);
                        psM.setDate(4, java.sql.Date.valueOf(deadlines[i]));
                        psM.setString(5, mStatuses[i]);
                        
                        if (mGrades[i] == null || mGrades[i].trim().isEmpty()) {
                            psM.setNull(6, java.sql.Types.FLOAT);
                        } else {
                            try {
                                float g = Float.parseFloat(mGrades[i]);
                                psM.setFloat(6, g);
                            } catch (NumberFormatException e) {
                                psM.setNull(6, java.sql.Types.FLOAT);
                            }
                        }
                        
                        psM.setString(7, mComments[i]);
                        psM.addBatch();
                    }
                    psM.executeBatch();
                }
            }
        } 
    }
}