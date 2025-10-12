package com.StudentManagement.dto;

public class TotalStatDTO {
    private Long totalFaculties;
    private Long totalMajors;
    private Long totalTeachers;
    private Long totalStudents;

    // Constructors
    public TotalStatDTO() {
    }

    public TotalStatDTO(Long totalFaculties, Long totalMajors, Long totalTeachers, Long totalStudents) {
        this.totalFaculties = totalFaculties;
        this.totalMajors = totalMajors;
        this.totalTeachers = totalTeachers;
        this.totalStudents = totalStudents;
    }

    // Getters and Setters
    public Long getTotalFaculties() {
        return totalFaculties;
    }

    public void setTotalFaculties(Long totalFaculties) {
        this.totalFaculties = totalFaculties;
    }

    public Long getTotalMajors() {
        return totalMajors;
    }

    public void setTotalMajors(Long totalMajors) {
        this.totalMajors = totalMajors;
    }

    public Long getTotalTeachers() {
        return totalTeachers;
    }

    public void setTotalTeachers(Long totalTeachers) {
        this.totalTeachers = totalTeachers;
    }

    public Long getTotalStudents() {
        return totalStudents;
    }

    public void setTotalStudents(Long totalStudents) {
        this.totalStudents = totalStudents;
    }
}