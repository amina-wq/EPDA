package ejb;

import jakarta.annotation.Resource;
import jakarta.ejb.Stateless;
import javax.sql.DataSource;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Notification;

@Stateless
public class NotificationBean {

    @Resource(name = "mysql")
    private DataSource ds;

    public boolean sendEmailNotification(Notification n) {
        String sql = "INSERT INTO notification (recipient_id, type, subject, content, status, created_at) VALUES (?, ?, ?, ?, 'SENT', NOW())";
        
        try (Connection conn = ds.getConnection()) {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, n.getRecipientId());
            ps.setString(2, n.getType());
            ps.setString(3, n.getSubject());
            ps.setString(4, n.getContent());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Notification> getAllNotifications() {
        List<Notification> logs = new ArrayList<>();
        String sql = "SELECT * FROM notification ORDER BY id DESC"; 
        
        try (Connection conn = ds.getConnection()) {
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(sql);
            
            while (rs.next()) {
                logs.add(mapNotification(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return logs;
    }

    private Notification mapNotification(ResultSet rs) throws SQLException {
        Notification n = new Notification();
        n.setId(rs.getLong("id"));
        n.setRecipientId(rs.getString("recipient_id"));
        n.setType(rs.getString("type"));
        n.setSubject(rs.getString("subject"));
        n.setContent(rs.getString("content"));
        n.setSentAt(rs.getDate("sent_at"));
        n.setStatus(rs.getString("status"));
        return n;
    }
}