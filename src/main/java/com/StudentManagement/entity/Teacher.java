package com.StudentManagement.entity;

import jakarta.persistence.*;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Entity
@Table(name = "teachers")
public class Teacher {
    @Id
    private Long id; // same as User.id

    @OneToOne
    @MapsId
    @JoinColumn(name = "id")
    private User user;

    @Column(unique = true, length = 20)
    private String teacherCode; // Mã giáo viên: GV001, GV002, etc.

    @Column(length = 200)
    private String department; // Bộ môn

    // Liên kết với Faculty (Khoa)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "faculty_id")
    private Faculty faculty;

    // Quan hệ với ClassroomTeacher (1 giáo viên có thể chủ nhiệm nhiều lớp trong
    // lịch sử)
    @OneToMany(mappedBy = "teacher", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<ClassroomTeacher> classroomTeachers;

    // Getters & Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public String getTeacherCode() {
        return teacherCode;
    }

    public void setTeacherCode(String teacherCode) {
        this.teacherCode = teacherCode;
    }

    public String getDepartment() {
        return department;
    }

    public void setDepartment(String department) {
        this.department = department;
    }

    public Faculty getFaculty() {
        return faculty;
    }

    public void setFaculty(Faculty faculty) {
        this.faculty = faculty;
    }

    public List<ClassroomTeacher> getClassroomTeachers() {
        return classroomTeachers;
    }

    public void setClassroomTeachers(List<ClassroomTeacher> classroomTeachers) {
        this.classroomTeachers = classroomTeachers;
    }

    // Helper method to get current homeroom classes
    public List<ClassroomTeacher> getCurrentHomeRoomClasses() {
        if (classroomTeachers == null)
            return new ArrayList<>();
        return classroomTeachers.stream()
                .filter(ct -> ct.getEndDate() == null)
                .collect(Collectors.toList());
    }
}
