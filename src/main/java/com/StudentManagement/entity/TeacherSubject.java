package com.StudentManagement.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "teacher_subjects", uniqueConstraints = @UniqueConstraint(columnNames = { "teacher_id", "subject_id" }))
public class TeacherSubject {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "teacher_id", nullable = false)
    private Teacher teacher;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "subject_id", nullable = false)
    private Subject subject;

    @Column(length = 20)
    private String semester; // Học kỳ phụ trách: 2024-1, 2024-2, etc.

    @Column(length = 100)
    private String className; // Lớp học phần: N1, N2, etc.

    // Constructors
    public TeacherSubject() {
    }

    public TeacherSubject(Teacher teacher, Subject subject, String semester, String className) {
        this.teacher = teacher;
        this.subject = subject;
        this.semester = semester;
        this.className = className;
    }

    // Getters & Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Teacher getTeacher() {
        return teacher;
    }

    public void setTeacher(Teacher teacher) {
        this.teacher = teacher;
    }

    public Subject getSubject() {
        return subject;
    }

    public void setSubject(Subject subject) {
        this.subject = subject;
    }

    public String getSemester() {
        return semester;
    }

    public void setSemester(String semester) {
        this.semester = semester;
    }

    public String getClassName() {
        return className;
    }

    public void setClassName(String className) {
        this.className = className;
    }
}