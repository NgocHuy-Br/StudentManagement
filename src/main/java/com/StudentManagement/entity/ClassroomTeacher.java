package com.StudentManagement.entity;

import jakarta.persistence.*;
import java.time.LocalDate;

/**
 * Entity quản lý lịch sử giáo viên chủ nhiệm lớp
 * Một lớp có thể có nhiều giáo viên chủ nhiệm trong các thời điểm khác nhau
 * Một giáo viên có thể chủ nhiệm nhiều lớp trong các thời điểm khác nhau
 */
@Entity
@Table(name = "classroom_teachers")
public class ClassroomTeacher {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // Quan hệ với Classroom (1 lớp có nhiều lịch sử giáo viên chủ nhiệm)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "classroom_id", nullable = false)
    private Classroom classroom;

    // Quan hệ với Teacher (1 giáo viên có thể chủ nhiệm nhiều lớp)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "teacher_id", nullable = false)
    private Teacher teacher;

    // Thời gian bắt đầu chủ nhiệm
    @Column(nullable = false)
    private LocalDate startDate;

    // Thời gian kết thúc chủ nhiệm (null = hiện tại đang chủ nhiệm)
    @Column
    private LocalDate endDate;

    // Ghi chú lý do thay đổi
    @Column(length = 500)
    private String notes;

    // Constructors
    public ClassroomTeacher() {
    }

    public ClassroomTeacher(Classroom classroom, Teacher teacher, LocalDate startDate) {
        this.classroom = classroom;
        this.teacher = teacher;
        this.startDate = startDate;
    }

    public ClassroomTeacher(Classroom classroom, Teacher teacher, LocalDate startDate, String notes) {
        this.classroom = classroom;
        this.teacher = teacher;
        this.startDate = startDate;
        this.notes = notes;
    }

    // Getters & Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Classroom getClassroom() {
        return classroom;
    }

    public void setClassroom(Classroom classroom) {
        this.classroom = classroom;
    }

    public Teacher getTeacher() {
        return teacher;
    }

    public void setTeacher(Teacher teacher) {
        this.teacher = teacher;
    }

    public LocalDate getStartDate() {
        return startDate;
    }

    public void setStartDate(LocalDate startDate) {
        this.startDate = startDate;
    }

    public LocalDate getEndDate() {
        return endDate;
    }

    public void setEndDate(LocalDate endDate) {
        this.endDate = endDate;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    // Utility methods
    public boolean isCurrentHomeRoomTeacher() {
        return endDate == null;
    }

    public boolean wasHomeRoomTeacherAt(LocalDate date) {
        return (startDate.isEqual(date) || startDate.isBefore(date)) &&
                (endDate == null || endDate.isAfter(date));
    }
}