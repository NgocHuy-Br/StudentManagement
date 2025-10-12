package com.StudentManagement.dto;

public class FacultyStatDTO {
    private String facultyCode;
    private String facultyName;
    private Long majorCount;
    private Long teacherCount;
    private Long studentCount;

    // Constructors
    public FacultyStatDTO() {
    }

    public FacultyStatDTO(String facultyCode, String facultyName, Long majorCount, Long teacherCount,
            Long studentCount) {
        this.facultyCode = facultyCode;
        this.facultyName = facultyName;
        this.majorCount = majorCount;
        this.teacherCount = teacherCount;
        this.studentCount = studentCount;
    }

    // Getters and Setters
    public String getFacultyCode() {
        return facultyCode;
    }

    public void setFacultyCode(String facultyCode) {
        this.facultyCode = facultyCode;
    }

    public String getFacultyName() {
        return facultyName;
    }

    public void setFacultyName(String facultyName) {
        this.facultyName = facultyName;
    }

    public Long getMajorCount() {
        return majorCount;
    }

    public void setMajorCount(Long majorCount) {
        this.majorCount = majorCount;
    }

    public Long getTeacherCount() {
        return teacherCount;
    }

    public void setTeacherCount(Long teacherCount) {
        this.teacherCount = teacherCount;
    }

    public Long getStudentCount() {
        return studentCount;
    }

    public void setStudentCount(Long studentCount) {
        this.studentCount = studentCount;
    }
}