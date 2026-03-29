package ejb;

import java.sql.*;
import java.util.*;
import javax.sql.DataSource;
import jakarta.annotation.Resource;
import jakarta.ejb.LocalBean;
import jakarta.ejb.Stateless;

@Stateless
@LocalBean
public class ReportBean {

    @Resource(name = "mysql")
    private DataSource dataSource;

    /**
     * Dashboard Logic: Calculates CGPA based ONLY on passed courses.
     */
    public List<Map<String, Object>> getStudentSummaries(String program, String search) throws SQLException {
        List<Map<String, Object>> students = new ArrayList<>();
        
        StringBuilder sql = new StringBuilder(
            "SELECT s.id, s.name, s.program, " +
            "SUM(CASE WHEN e.status = 'PASSED' THEN e.grade * c.credits ELSE 0 END) as total_points, " +
            "SUM(CASE WHEN e.status = 'PASSED' THEN c.credits ELSE 0 END) as passed_credits, " +
            "SUM(CASE WHEN e.status = 'FAILED' THEN 1 ELSE 0 END) as fail_count " +
            "FROM student s " +
            "LEFT JOIN enrollment e ON s.id = e.student_id " +
            "LEFT JOIN course c ON e.course_id = c.id " +
            "WHERE (e.status != 'IN_PROGRESS' OR e.status IS NULL) "
        );

        if (program != null && !program.isEmpty()) sql.append(" AND s.program = ? ");
        if (search != null && !search.trim().isEmpty()) sql.append(" AND (s.name LIKE ? OR s.id LIKE ?) ");

        sql.append(" GROUP BY s.id, s.name, s.program");

        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            int idx = 1;
            if (program != null && !program.isEmpty()) ps.setString(idx++, program);
            if (search != null && !search.trim().isEmpty()) {
                String p = "%" + search.trim() + "%";
                ps.setString(idx++, p);
                ps.setString(idx++, p);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("id", rs.getString("id"));
                    map.put("name", rs.getString("name"));
                    map.put("program", rs.getString("program"));
                    
                    double points = rs.getDouble("total_points");
                    int credits = rs.getInt("passed_credits");
                    int fails = rs.getInt("fail_count");
                    
                    double cgpa = (credits > 0) ? points / credits : 0.0;
                    map.put("cgpa", cgpa);
                    map.put("failCount", fails);
                    map.put("is_eligible", (cgpa >= 2.0 && fails <= 3));
                    
                    students.add(map);
                }
            }
        }
        return students;
    }

    /**
     * Individual Report Logic: Groups by Semester and separates Passed vs Failed.
     */
    public Map<String, Object> getFullAcademicReport(String studentId) throws SQLException {
        Map<String, Object> reportData = new HashMap<>();
        
        String studentSql = "SELECT name, id, program FROM student WHERE id = ?";
        // This query filters out failures that were successfully re-taken
        String historySql = "SELECT e.semester, c.id as code, c.title, c.credits, e.grade, e.status " +
                            "FROM enrollment e " +
                            "JOIN course c ON e.course_id = c.id " +
                            "WHERE e.student_id = ? " +
                            "AND (e.status = 'PASSED' OR (e.status = 'FAILED' AND c.id NOT IN (" +
                            "   SELECT course_id FROM enrollment WHERE student_id = ? AND status = 'PASSED'" +
                            "))) " +
                            "ORDER BY e.semester ASC";

        try (Connection conn = dataSource.getConnection()) {
            // 1. Get Header Info
            try (PreparedStatement ps = conn.prepareStatement(studentSql)) {
                ps.setString(1, studentId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        reportData.put("name", rs.getString("name"));
                        reportData.put("studentId", rs.getString("id"));
                        reportData.put("program", rs.getString("program"));
                    }
                }
            }

            // 2. Get Course History
            try (PreparedStatement ps = conn.prepareStatement(historySql)) {
                ps.setString(1, studentId);
                ps.setString(2, studentId);
                try (ResultSet rs = ps.executeQuery()) {
                    Map<String, Map<String, List<Map<String, Object>>>> semesterGroups = new LinkedHashMap<>();
                    Map<String, Double> semesterGPAs = new HashMap<>();

                    while (rs.next()) {
                        String sem = rs.getString("semester");
                        String status = rs.getString("status");
                        
                        Map<String, Object> course = new HashMap<>();
                        course.put("code", rs.getString("code"));
                        course.put("title", rs.getString("title"));
                        course.put("credits", rs.getInt("credits"));
                        course.put("grade", rs.getDouble("grade"));
                        
                        semesterGroups.putIfAbsent(sem, new HashMap<>());
                        semesterGroups.get(sem).putIfAbsent("passed", new ArrayList<>());
                        semesterGroups.get(sem).putIfAbsent("failed", new ArrayList<>());

                        if ("PASSED".equals(status)) {
                            semesterGroups.get(sem).get("passed").add(course);
                        } else {
                            semesterGroups.get(sem).get("failed").add(course);
                        }
                    }

                    // Calculate individual GPA per table
                    semesterGroups.forEach((sem, groups) -> {
                        double pts = 0;
                        int creds = 0;
                        for (Map<String, Object> c : groups.get("passed")) {
                            pts += (double) c.get("grade") * (int) c.get("credits");
                            creds += (int) c.get("credits");
                        }
                        semesterGPAs.put(sem, creds > 0 ? pts / creds : 0.0);
                    });

                    reportData.put("semesterGroups", semesterGroups);
                    reportData.put("semesterGPAs", semesterGPAs);
                }
            }
        }
        return reportData;
    }

    public List<String> getUniquePrograms() throws SQLException {
        List<String> programs = new ArrayList<>();
        String sql = "SELECT DISTINCT program FROM student ORDER BY program ASC";
        try (Connection conn = dataSource.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                programs.add(rs.getString("program"));
            }
        }
        return programs;
    }
}