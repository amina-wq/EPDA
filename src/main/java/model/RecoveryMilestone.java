package model;

import java.io.Serializable;
import java.util.Date;

public class RecoveryMilestone implements Serializable {
    private static final long serialVersionUID = 1L;

    private Long id;
    private Long recoveryPlanId;
    private String weekRange;
    private String task;
    private Date deadline;
    private String status; // "PENDING", "IN_PROGRESS", "COMPLETED"

    private Float grade; 
    
    private String comments;

    public RecoveryMilestone() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getRecoveryPlanId() { return recoveryPlanId; }
    public void setRecoveryPlanId(Long recoveryPlanId) { this.recoveryPlanId = recoveryPlanId; }

    public String getWeekRange() { return weekRange; }
    public void setWeekRange(String weekRange) { this.weekRange = weekRange; }

    public String getTask() { return task; }
    public void setTask(String task) { this.task = task; }

    public Date getDeadline() { return deadline; }
    public void setDeadline(Date deadline) { this.deadline = deadline; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Float getGrade() { return grade; }
    public void setGrade(Float grade) { this.grade = grade; }

    public String getComments() { return comments; }
    public void setComments(String comments) { this.comments = comments; }
}