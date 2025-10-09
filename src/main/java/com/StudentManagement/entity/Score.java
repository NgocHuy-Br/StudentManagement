
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

    @Column(name = "attendance_score")
    private Float attendanceScore; // Điểm chuyên cần (TP1)

    @Column(name = "midterm_score")
    private Float midtermScore; // Điểm giữa kỳ (TP2)

    @Column(name = "final_score")
    private Float finalScore; // Điểm cuối kỳ (TP3)

    @Column(name = "avg_score")
    private Float avgScore; // Điểm trung bình môn (tự động tính hoặc lưu sẵn)

    @Column(length = 20, nullable = false)
    private String semester; // Học kỳ: 2024-1, 2024-2, etc.

    @Column(length = 500)
    private String notes; // Ghi chú (nếu cần)

    // Constructors
    public Score() {
    }

    public Score(Student student, Subject subject, Float attendanceScore, Float midtermScore, Float finalScore,
            String semester) {
        this.student = student;
        this.subject = subject;
        this.attendanceScore = attendanceScore;
        this.midtermScore = midtermScore;
        this.finalScore = finalScore;
        this.semester = semester;
        this.avgScore = calculateAvgScore(); // Tự động tính điểm TB
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

    public Float getAttendanceScore() {
        return attendanceScore;
    }

    public void setAttendanceScore(Float attendanceScore) {
        this.attendanceScore = attendanceScore;
        this.avgScore = calculateAvgScore(); // Tự động tính lại điểm TB
    }

    public Float getMidtermScore() {
        return midtermScore;
    }

    public void setMidtermScore(Float midtermScore) {
        this.midtermScore = midtermScore;
        this.avgScore = calculateAvgScore(); // Tự động tính lại điểm TB
    }

    public Float getFinalScore() {
        return finalScore;
    }

    public void setFinalScore(Float finalScore) {
        this.finalScore = finalScore;
        this.avgScore = calculateAvgScore(); // Tự động tính lại điểm TB
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

    // Phương thức tính điểm trung bình tự động
    // Công thức: (Chuyên cần * 0.1) + (Giữa kỳ * 0.3) + (Cuối kỳ * 0.6)
    public Float calculateAvgScore() {
        if (attendanceScore == null || midtermScore == null || finalScore == null) {
            return null; // Chưa đủ điểm để tính TB
        }
        return Math.round((attendanceScore * 0.1f + midtermScore * 0.3f + finalScore * 0.6f) * 100f) / 100f;
    }

    // Phương thức để cập nhật lại điểm TB khi có thay đổi
    public void updateAvgScore() {
        this.avgScore = calculateAvgScore();
    }

    // Phương thức kiểm tra xem có đủ điểm để tính TB không
    public boolean hasAllScores() {
        return attendanceScore != null && midtermScore != null && finalScore != null;
    }

    // Phương thức lấy xếp loại
    public String getGradeClassification() {
        if (avgScore == null)
            return "Chưa có điểm";
        if (avgScore >= 8.5)
            return "Xuất sắc";
        if (avgScore >= 7.0)
            return "Giỏi";
        if (avgScore >= 5.5)
            return "Khá";
        if (avgScore >= 4.0)
            return "Trung bình";
        return "Yếu";
    }
}