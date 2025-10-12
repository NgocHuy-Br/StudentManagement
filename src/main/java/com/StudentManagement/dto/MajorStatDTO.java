package com.StudentManagement.dto;

public class MajorStatDTO {
    private String majorCode;
    private String majorName;
    private String facultyName;
    private Long studentCount;

    // Constructors
    public MajorStatDTO() {
    }

    public MajorStatDTO(String majorCode, String majorName, String facultyName, Long studentCount) {
        this.majorCode = majorCode;
        this.majorName = majorName;
        this.facultyName = facultyName;
        this.studentCount = studentCount;
    }

    // Getters and Setters
    public String getMajorCode() {
        return majorCode;
    }

    public void setMajorCode(String majorCode) {
        this.majorCode = majorCode;
    }

    public String getMajorName() {
        return majorName;
    }

    public void setMajorName(String majorName) {
        this.majorName = majorName;
    }

    public String getFacultyName() {
        return facultyName;
    }

    public void setFacultyName(String facultyName) {
        this.facultyName = facultyName;
    }

    public Long getStudentCount() {
        return studentCount;
    }

    public void setStudentCount(Long studentCount) {
        this.studentCount = studentCount;
    }
}