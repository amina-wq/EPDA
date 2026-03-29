package model;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

public class RecoveryPlan implements Serializable {
    private static final long serialVersionUID = 1L;

    private Long id;
    private String studentId;
    private String courseId;
    private Date startDate;
    private Date endDate;
    private String status; // "ACTIVE", "COMPLETED", "CANCELLED"
    
    private String semester;
    private Integer attemptNumber;
    private Float failedGrade; // Updated to Float for consistency/null support

    // NEW FIELDS FOR STUDENT PERFORMANCE CONTEXT
    private Long enrollmentId;
    private String componentType;
    private String componentName;
    private Float score;
    private Float passingScore;

    // Computed Fields
    private List<RecoveryMilestone> milestones;
    private Student student;
    private Course course;

    public RecoveryPlan() {}

    // NEW GETTERS AND SETTERS
    public Long getEnrollmentId() { return enrollmentId; }
    public void setEnrollmentId(Long enrollmentId) { this.enrollmentId = enrollmentId; }

    public String getComponentType() { return componentType; }
    public void setComponentType(String componentType) { this.componentType = componentType; }

    public String getComponentName() { return componentName; }
    public void setComponentName(String componentName) { this.componentName = componentName; }

    public Float getScore() { return score; }
    public void setScore(Float score) { this.score = score; }

    public Float getPassingScore() { return passingScore; }
    public void setPassingScore(Float passingScore) { this.passingScore = passingScore; }

    // ORIGINAL GETTERS AND SETTERS
    public String getSemester() { return semester; }
    public void setSemester(String semester) { this.semester = semester; }

    public Integer getAttemptNumber() { return attemptNumber; }
    public void setAttemptNumber(Integer attemptNumber) { this.attemptNumber = attemptNumber; }

    public Float getFailedGrade() { return failedGrade; }
    public void setFailedGrade(Float failedGrade) { this.failedGrade = failedGrade; }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getStudentId() { return studentId; }
    public void setStudentId(String studentId) { this.studentId = studentId; }

    public String getCourseId() { return courseId; }
    public void setCourseId(String courseId) { this.courseId = courseId; }

    public Date getStartDate() { return startDate; }
    public void setStartDate(Date startDate) { this.startDate = startDate; }

    public Date getEndDate() { return endDate; }
    public void setEndDate(Date endDate) { this.endDate = endDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public List<RecoveryMilestone> getMilestones() { return milestones; }
    public void setMilestones(List<RecoveryMilestone> milestones) { this.milestones = milestones; }

    public Student getStudent() { return student; }
    public void setStudent(Student student) { this.student = student; }

    public Course getCourse() { return course; }
    public void setCourse(Course course) { this.course = course; }
}