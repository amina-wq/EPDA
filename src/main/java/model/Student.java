package model;

import java.io.Serializable;


public class Student implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private String id;
    private String name;
    private String program;
    private String email;
    private boolean isEligible;
    
    public String getStudentId() { return id; }
    public void setStudentId(String studentId) { this.id = studentId; }
    
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    
    public String getProgram() { return program; }
    public void setProgram(String program) { this.program = program; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public boolean getIsEligible() { return isEligible; }
    public void setIsEligible(boolean isEligible) { this.isEligible = isEligible; }
}