package model;

import java.io.Serializable;


public class FailedComponent implements Serializable {
    private static final long serialVersionUID = 1L;

    private Long id;
    private Long enrollmentId;
    private String componentType; // "ASSIGNMENT", "EXAM", "QUIZ", "PROJECT"
    private String componentName;
    private float score;
    private float passingScore;

    public FailedComponent() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getEnrollmentId() { return enrollmentId; }
    public void setEnrollmentId(Long enrollmentId) { this.enrollmentId = enrollmentId; }

    public String getComponentType() { return componentType; }
    public void setComponentType(String componentType) { this.componentType = componentType; }

    public String getComponentName() { return componentName; }
    public void setComponentName(String componentName) { this.componentName = componentName; }

    public float getScore() { return score; }
    public void setScore(float score) { this.score = score; }

    public float getPassingScore() { return passingScore; }
    public void setPassingScore(float passingScore) { this.passingScore = passingScore; }
}