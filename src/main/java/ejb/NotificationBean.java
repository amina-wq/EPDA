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

    // F3: Send Notification Logic (Saves to the 'notification' table)
    public boolean sendEmailNotification(Notification n) {
        // Updated table name and columns based on your MySQL screenshot
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

    // F3: Retrieve All Notifications for the Admin Log
    public List<Notification> getAllNotifications() {
        List<Notification> logs = new ArrayList<>();
        // Updated table name to 'notification'
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
        n.setRecipientId(rs.getString("recipient_id"));
        n.setType(rs.getString("type"));
        n.setSubject(rs.getString("subject"));
        n.setContent(rs.getString("content"));
        // You can add n.setStatus(rs.getString("status")) if your model has it
        return n;
    }
}