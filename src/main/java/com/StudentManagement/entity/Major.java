package com.StudentManagement.entity;

import jakarta.persistence.*;
import java.util.List;

@Entity
@Table(name = "majors")
public class Major {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true, nullable = false, length = 20)
    private String majorCode; // Mã ngành: CNTT, KHMT, etc.

    @Column(nullable = false, length = 200)
    private String majorName; // Tên ngành: Công nghệ thông tin, etc.

    @Column(length = 500)
    private String description; // Mô tả ngành

    // Quan hệ với Student (1 ngành có nhiều sinh viên)
    @OneToMany(mappedBy = "major", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Student> students;

    // Quan hệ với Subject (1 ngành có nhiều môn học)
    @OneToMany(mappedBy = "major", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Subject> subjects;

    // Constructors
    public Major() {
    }

    public Major(String majorCode, String majorName, String description) {
        this.majorCode = majorCode;
        this.majorName = majorName;
        this.description = description;
    }

    // Getters & Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

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

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public List<Student> getStudents() {
        return students;
    }

    public void setStudents(List<Student> students) {
        this.students = students;
    }

    public List<Subject> getSubjects() {
        return subjects;
    }

    public void setSubjects(List<Subject> subjects) {
        this.subjects = subjects;
    }
}