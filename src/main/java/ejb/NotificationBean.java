package ejb;

import jakarta.annotation.Resource;
import jakarta.ejb.Stateless;
import jakarta.mail.*;
import jakarta.mail.internet.*;
import javax.sql.DataSource;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;
import model.Notification;

@Stateless
public class NotificationBean {

    @Resource(name = "mysql")
    private DataSource ds;

    public boolean sendEmailNotification(Notification n) {
        String sql = "INSERT INTO notification (recipient_id, type, subject, content, status, sent_at, created_at) VALUES (?, ?, ?, ?, 'SENT', NOW(), NOW())";
        boolean dbSuccess = false;
        
        try (Connection conn = ds.getConnection()) {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, n.getRecipientId());
            ps.setString(2, n.getType());
            ps.setString(3, n.getSubject());
            ps.setString(4, n.getContent());
            
            dbSuccess = ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }

        if (dbSuccess) {
            sendRealEmailViaSMTP(n.getRecipientId(), n.getSubject(), n.getContent());
        }

        return dbSuccess;
    }

    private void sendRealEmailViaSMTP(String toAddress, String subject, String messageContent) {
        final String fromEmail = "epdaproject@gmail.com"; 
        final String appPassword = "qbtmjkgjyugyqhzy"; 

        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "465");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.ssl.enable", "true");
        
        props.put("mail.smtp.socketFactory.port", "465");
        props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
        props.put("mail.smtp.socketFactory.fallback", "false");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, appPassword);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(fromEmail));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toAddress));
            message.setSubject(subject);
            message.setText(messageContent + "\n\n--\nAutomated System Notification");
            
            Transport.send(message);
            System.out.println("SUCCESS: Real email sent to " + toAddress);
            
        } catch (MessagingException e) {
            System.err.println("FAILED: Could not send real email to " + toAddress);
            e.printStackTrace();
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