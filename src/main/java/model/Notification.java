package model;

import java.io.Serializable;
import java.util.Date;


public class Notification implements Serializable {
    private static final long serialVersionUID = 1L;

    private Long id;
    private String recipientId;
    private String type; // "ACCOUNT_CREATED", "PASSWORD_RESET", "RECOVERY_PLAN_CREATED", "REPORT_READY", etc
    private String subject;
    private String content;
    private Date sentAt;
    private String status; // "PENDING", "SENT", "FAILED"

    public Notification() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getRecipientId() { return recipientId; }
    public void setRecipientId(String recipientId) { this.recipientId = recipientId; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public String getSubject() { return subject; }
    public void setSubject(String subject) { this.subject = subject; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public Date getSentAt() { return sentAt; }
    public void setSentAt(Date sentAt) { this.sentAt = sentAt; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}