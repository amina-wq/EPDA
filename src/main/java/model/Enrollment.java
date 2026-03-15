package model;

import java.io.Serializable;

public class Enrollment implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private Long id;
    private String studentId;
    private String courseId;
    private String semester;
    private float grade;
    private Integer attemptNumber;
    private String status; // "PASSED", "FAILED", "IN_PROGRESS"
    
    public Enrollment() {}
    
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    
    public String getStudentId() { return studentId; }
    public void setStudentId(String studentId) { this.studentId = studentId; }
    
    public String getCourseId() { return courseId; }
    public void setCourseId(String courseId) { this.courseId = courseId; }
    
    public String getSemester() { return semester; }
    public void setSemester(String semester) { this.semester = semester; }
    
    public float getGrade() { return grade; }
    public void setGrade(float grade) { this.grade = grade; }
    
    public Integer getAttemptNumber() { return attemptNumber; }
    public void setAttemptNumber(Integer attemptNumber) { this.attemptNumber = attemptNumber; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}