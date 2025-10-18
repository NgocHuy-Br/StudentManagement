package com.StudentManagement.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import java.util.List;

@Entity
@Table(name = "subjects")
public class Subject {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true, nullable = false, length = 20)
    private String subjectCode;

    @Column(nullable = false, length = 200)
    private String subjectName;

    private int credit; // Số tín chỉ

    // Hệ số điểm (mặc định: chuyên cần 10%, giữa kỳ 30%, cuối kỳ 60%)
    @Column(name = "attendance_weight")
    private Float attendanceWeight = 0.1f; // Hệ số điểm chuyên cần (TP1)

    @Column(name = "midterm_weight")
    private Float midtermWeight = 0.3f; // Hệ số điểm giữa kỳ (TP2)

    @Column(name = "final_weight")
    private Float finalWeight = 0.6f; // Hệ số điểm cuối kỳ (TP3)

    // Quan hệ Many-to-Many với Major (1 môn có thể thuộc nhiều ngành)
    @JsonIgnore
    @ManyToMany(mappedBy = "subjects", fetch = FetchType.LAZY)
    private List<Major> majors;

    // Quan hệ với Score (1 môn có nhiều điểm)
    @JsonIgnore
    @OneToMany(mappedBy = "subject", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Score> scores;

    // Getters & Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getSubjectCode() {
        return subjectCode;
    }

    public void setSubjectCode(String subjectCode) {
        this.subjectCode = subjectCode;
    }

    public String getSubjectName() {
        return subjectName;
    }

    public void setSubjectName(String subjectName) {
        this.subjectName = subjectName;
    }

    public int getCredit() {
        return credit;
    }

    public void setCredit(int credit) {
        this.credit = credit;
    }

    public List<Major> getMajors() {
        return majors;
    }

    public void setMajors(List<Major> majors) {
        this.majors = majors;
    }

    public List<Score> getScores() {
        return scores;
    }

    public void setScores(List<Score> scores) {
        this.scores = scores;
    }

    public Float getAttendanceWeight() {
        return attendanceWeight;
    }

    public void setAttendanceWeight(Float attendanceWeight) {
        this.attendanceWeight = attendanceWeight;
    }

    public Float getMidtermWeight() {
        return midtermWeight;
    }

    public void setMidtermWeight(Float midtermWeight) {
        this.midtermWeight = midtermWeight;
    }

    public Float getFinalWeight() {
        return finalWeight;
    }

    public void setFinalWeight(Float finalWeight) {
        this.finalWeight = finalWeight;
    }

    // Phương thức kiểm tra tổng hệ số có bằng 1.0 không
    public boolean isValidWeights() {
        if (attendanceWeight == null || midtermWeight == null || finalWeight == null) {
            return false;
        }
        float total = attendanceWeight + midtermWeight + finalWeight;
        return Math.abs(total - 1.0f) < 0.001f; // Cho phép sai số nhỏ
    }

    // Phương thức chuẩn hóa hệ số về tổng = 1.0
    public void normalizeWeights() {
        if (attendanceWeight == null || midtermWeight == null || finalWeight == null) {
            // Gán mặc định nếu null
            attendanceWeight = 0.1f;
            midtermWeight = 0.3f;
            finalWeight = 0.6f;
            return;
        }

        float total = attendanceWeight + midtermWeight + finalWeight;
        if (total > 0) {
            attendanceWeight = attendanceWeight / total;
            midtermWeight = midtermWeight / total;
            finalWeight = finalWeight / total;
        }
    }

    // Phương thức format hiển thị hệ số điểm dạng "10-30-60"
    public String getWeightDisplayFormat() {
        int attendance = attendanceWeight != null ? Math.round(attendanceWeight * 100) : 10;
        int midterm = midtermWeight != null ? Math.round(midtermWeight * 100) : 30;
        int finalExam = finalWeight != null ? Math.round(finalWeight * 100) : 60;
        return attendance + "-" + midterm + "-" + finalExam;
    }
}