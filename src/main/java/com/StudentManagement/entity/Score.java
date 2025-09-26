
package com.StudentManagement.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "scores", uniqueConstraints = @UniqueConstraint(columnNames = { "student_id", "subject_id", "semester" }))
public class Score {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "student_id", nullable = false)
    private Student student;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "subject_id", nullable = false)
    private Subject subject;

    @Column(name = "avg_score")
    private Float avgScore; // Điểm trung bình môn (chỉ 1 cột)

    @Column(length = 20, nullable = false)
    private String semester; // Học kỳ: 2024-1, 2024-2, etc.

    @Column(length = 500)
    private String notes; // Ghi chú (nếu cần)

    // Constructors
    public Score() {
    }

    public Score(Student student, Subject subject, Float avgScore, String semester) {
        this.student = student;
        this.subject = subject;
        this.avgScore = avgScore;
        this.semester = semester;
    }

    // Getters & Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Student getStudent() {
        return student;
    }

    public void setStudent(Student student) {
        this.student = student;
    }

    public Subject getSubject() {
        return subject;
    }

    public void setSubject(Subject subject) {
        this.subject = subject;
    }

    public Float getAvgScore() {
        return avgScore;
    }

    public void setAvgScore(Float avgScore) {
        this.avgScore = avgScore;
    }

    public String getSemester() {
        return semester;
    }

    public void setSemester(String semester) {
        this.semester = semester;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }
}