package model;

import java.io.Serializable;


public class Course implements Serializable {
    private static final long serialVersionUID = 1L;

    private String id;
    private String title;
    private Integer credits;
    private String description;

    public Course() {}

    public String getCourseId() { return id; }
    public void setCourseId(String id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public Integer getCredits() { return credits; }
    public void setCredits(Integer credits) { this.credits = credits; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
}