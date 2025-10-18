package com.StudentManagement.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "users")
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // Mã đăng nhập: với sinh viên dùng MSSV
    @Column(unique = true, nullable = false, length = 100)
    private String username;

    @Column(nullable = false, length = 200)
    private String password;

    @Column(length = 100)
    private String fname;

    @Column(length = 100)
    private String lname;

    @Column(unique = true, nullable = true, length = 200)
    private String email;

    @Column(unique = true, length = 12)
    private String nationalId; // Số căn cước công dân

    @Column(length = 30)
    private String phone;

    @Column(length = 500)
    private String address; // Địa chỉ

    @Column(nullable = true)
    private java.time.LocalDate birthDate; // Ngày sinh

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private Role role;

    public enum Role {
        ADMIN, TEACHER, STUDENT
    }

    // Getters & Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getFname() {
        return fname;
    }

    public void setFname(String fname) {
        this.fname = fname;
    }

    public String getLname() {
        return lname;
    }

    public void setLname(String lname) {
        this.lname = lname;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getNationalId() {
        return nationalId;
    }

    public void setNationalId(String nationalId) {
        this.nationalId = nationalId;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public java.time.LocalDate getBirthDate() {
        return birthDate;
    }

    public void setBirthDate(java.time.LocalDate birthDate) {
        this.birthDate = birthDate;
    }

    public Role getRole() {
        return role;
    }

    public void setRole(Role role) {
        this.role = role;
    }

    // Helper method for full name
    public String getFullName() {
        StringBuilder fullName = new StringBuilder();
        if (fname != null && !fname.trim().isEmpty()) {
            fullName.append(fname.trim());
        }
        if (lname != null && !lname.trim().isEmpty()) {
            if (fullName.length() > 0) {
                fullName.append(" ");
            }
            fullName.append(lname.trim());
        }
        return fullName.length() > 0 ? fullName.toString() : username;
    }
}