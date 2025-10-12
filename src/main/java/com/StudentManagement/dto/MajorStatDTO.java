package com.StudentManagement.dto;

public class MajorStatDTO {
    private String majorCode;
    private String majorName;
    private String facultyName;
    private String courseYear;
    private Long studentCount;

    // Constructors
    public MajorStatDTO() {
    }

    public MajorStatDTO(String majorCode, String majorName, String facultyName, String courseYear, Long studentCount) {
        this.majorCode = majorCode;
        this.majorName = majorName;
        this.facultyName = facultyName;
        this.courseYear = courseYear;
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

    public String getCourseYear() {
        return courseYear;
    }

    public void setCourseYear(String courseYear) {
        this.courseYear = courseYear;
    }

    public Long getStudentCount() {
        return studentCount;
    }

    public void setStudentCount(Long studentCount) {
        this.studentCount = studentCount;
    }
}