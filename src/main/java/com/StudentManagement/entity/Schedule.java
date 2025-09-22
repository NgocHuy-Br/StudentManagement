package com.StudentManagement.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "schedules")
public class Schedule {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private int dayOfWeek; // 2-8 (Thứ 2 -> CN)
    private int period; // Tiết học

    @ManyToOne
    @JoinColumn(name = "course_id")
    private Course course;

    private String room;
    private String linkOnline;

    // Getter & Setter
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public int getDayOfWeek() {
        return dayOfWeek;
    }

    public void setDayOfWeek(int dayOfWeek) {
        this.dayOfWeek = dayOfWeek;
    }

    public int getPeriod() {
        return period;
    }

    public void setPeriod(int period) {
        this.period = period;
    }

    public Course getCourse() {
        return course;
    }

    public void setCourse(Course course) {
        this.course = course;
    }

    public String getRoom() {
        return room;
    }

    public void setRoom(String room) {
        this.room = room;
    }

    public String getLinkOnline() {
        return linkOnline;
    }

    public void setLinkOnline(String linkOnline) {
        this.linkOnline = linkOnline;
    }
}
