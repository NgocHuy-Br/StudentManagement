package com.StudentManagement.entity;

import jakarta.persistence.*;
import java.util.List;

@Entity
@Table(name = "classrooms")
public class Classroom {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true, nullable = false, length = 20)
    private String classCode; // Mã lớp: D20CQCN01-N, etc.

    @Column(nullable = false, length = 10)
    private String courseYear; // Khóa học: 2020, 2021, etc.

    // Quan hệ với Major (1 lớp thuộc 1 ngành)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "major_id", nullable = false)
    private Major major;

    // Quan hệ với Teacher (1 lớp có 1 giáo viên chủ nhiệm)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "teacher_id")
    private Teacher homeRoomTeacher;

    // Quan hệ Many-to-Many với Subject (1 lớp học nhiều môn)
    @ManyToMany(cascade = { CascadeType.PERSIST, CascadeType.MERGE }, fetch = FetchType.LAZY)
    @JoinTable(name = "classroom_subjects", joinColumns = @JoinColumn(name = "classroom_id"), inverseJoinColumns = @JoinColumn(name = "subject_id"))
    private List<Subject> subjects;

    // Quan hệ với Student (1 lớp có nhiều sinh viên)
    @OneToMany(mappedBy = "classroom", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Student> students;

    // Constructors
    public Classroom() {
    }

    public Classroom(String classCode, String courseYear, Major major) {
        this.classCode = classCode;
        this.courseYear = courseYear;
        this.major = major;
    }

    // Getters & Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getClassCode() {
        return classCode;
    }

    public void setClassCode(String classCode) {
        this.classCode = classCode;
    }

    public String getCourseYear() {
        return courseYear;
    }

    public void setCourseYear(String courseYear) {
        this.courseYear = courseYear;
    }

    public Major getMajor() {
        return major;
    }

    public void setMajor(Major major) {
        this.major = major;
    }

    public Teacher getHomeRoomTeacher() {
        return homeRoomTeacher;
    }

    public void setHomeRoomTeacher(Teacher homeRoomTeacher) {
        this.homeRoomTeacher = homeRoomTeacher;
    }

    public List<Subject> getSubjects() {
        return subjects;
    }

    public void setSubjects(List<Subject> subjects) {
        this.subjects = subjects;
    }

    public List<Student> getStudents() {
        return students;
    }

    public void setStudents(List<Student> students) {
        this.students = students;
    }

    // Helper method to get student count
    public int getStudentCount() {
        return students != null ? students.size() : 0;
    }

    @Override
    public String toString() {
        return "Classroom{" +
                "id=" + id +
                ", classCode='" + classCode + '\'' +
                ", courseYear='" + courseYear + '\'' +
                '}';
    }
}