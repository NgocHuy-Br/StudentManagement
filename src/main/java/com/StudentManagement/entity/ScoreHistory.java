package com.StudentManagement.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

/**
 * Entity lưu lịch sử các lần nhập/chỉnh sửa điểm
 * Mỗi lần có thay đổi điểm sẽ tạo 1 record trong bảng này
 */
@Entity
@Table(name = "score_history")
public class ScoreHistory {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // Quan hệ với Score - một điểm có nhiều lịch sử thay đổi
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "score_id", nullable = false)
    private Score score;

    // User thực hiện thay đổi (có thể là Admin hoặc Teacher)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "changed_by_user_id", nullable = false)
    private User changedByUser;

    // Điểm chuyên cần tại thời điểm này
    @Column(name = "attendance_score")
    private Float attendanceScore;

    // Điểm giữa kỳ tại thời điểm này
    @Column(name = "midterm_score")
    private Float midtermScore;

    // Điểm cuối kỳ tại thời điểm này
    @Column(name = "final_score")
    private Float finalScore;

    // Điểm trung bình tại thời điểm này
    @Column(name = "avg_score")
    private Float avgScore;

    // Loại thao tác: CREATE, UPDATE
    @Enumerated(EnumType.STRING)
    @Column(name = "action_type", nullable = false)
    private ActionType actionType;

    // Thời gian thực hiện thay đổi
    @Column(name = "changed_at", nullable = false)
    private LocalDateTime changedAt;

    // Ghi chú tại thời điểm này
    @Column(length = 500)
    private String notes;

    // Mô tả thay đổi (tự động generate)
    @Column(name = "change_description", length = 1000)
    private String changeDescription;

    // Enum cho loại thao tác
    public enum ActionType {
        CREATE("Tạo mới"),
        UPDATE("Cập nhật");

        private final String description;

        ActionType(String description) {
            this.description = description;
        }

        public String getDescription() {
            return description;
        }
    }

    // Constructors
    public ScoreHistory() {
    }

    public ScoreHistory(Score score, User changedByUser, ActionType actionType, String changeDescription) {
        this.score = score;
        this.changedByUser = changedByUser;
        this.actionType = actionType;
        this.changeDescription = changeDescription;
        this.changedAt = LocalDateTime.now();

        // Copy điểm hiện tại từ Score
        this.attendanceScore = score.getAttendanceScore();
        this.midtermScore = score.getMidtermScore();
        this.finalScore = score.getFinalScore();
        this.avgScore = score.getAvgScore();
        this.notes = score.getNotes();
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Score getScore() {
        return score;
    }

    public void setScore(Score score) {
        this.score = score;
    }

    public User getChangedByUser() {
        return changedByUser;
    }

    public void setChangedByUser(User changedByUser) {
        this.changedByUser = changedByUser;
    }

    public Float getAttendanceScore() {
        return attendanceScore;
    }

    public void setAttendanceScore(Float attendanceScore) {
        this.attendanceScore = attendanceScore;
    }

    public Float getMidtermScore() {
        return midtermScore;
    }

    public void setMidtermScore(Float midtermScore) {
        this.midtermScore = midtermScore;
    }

    public Float getFinalScore() {
        return finalScore;
    }

    public void setFinalScore(Float finalScore) {
        this.finalScore = finalScore;
    }

    public Float getAvgScore() {
        return avgScore;
    }

    public void setAvgScore(Float avgScore) {
        this.avgScore = avgScore;
    }

    public ActionType getActionType() {
        return actionType;
    }

    public void setActionType(ActionType actionType) {
        this.actionType = actionType;
    }

    public LocalDateTime getChangedAt() {
        return changedAt;
    }

    public void setChangedAt(LocalDateTime changedAt) {
        this.changedAt = changedAt;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public String getChangeDescription() {
        return changeDescription;
    }

    public void setChangeDescription(String changeDescription) {
        this.changeDescription = changeDescription;
    }
}