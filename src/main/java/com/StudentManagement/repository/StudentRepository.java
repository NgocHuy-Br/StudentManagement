package com.StudentManagement.repository;

import com.StudentManagement.entity.Student;
import com.StudentManagement.entity.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.*;
import org.springframework.data.repository.query.Param;

import java.util.Optional;

public interface StudentRepository extends JpaRepository<Student, Long> {

    boolean existsByUser(User user);

    Optional<Student> findByUser(User user);

    // Lấy danh sách sinh viên kèm user để phân trang/sắp xếp theo cả trường của
    // user
    @EntityGraph(attributePaths = { "user" })
    @Query("select s from Student s join s.user u")
    Page<Student> findAllWithUser(Pageable pageable);

    // Tìm kiếm theo MSSV, họ, tên, email, SĐT, lớp, khoa
    @EntityGraph(attributePaths = { "user" })
    @Query("""
            select s from Student s join s.user u
            where
              lower(u.username) like lower(concat('%', :q, '%'))
              or lower(u.fname)  like lower(concat('%', :q, '%'))
              or lower(u.lname)  like lower(concat('%', :q, '%'))
              or lower(u.email)  like lower(concat('%', :q, '%'))
              or lower(u.phone)  like lower(concat('%', :q, '%'))
              or lower(s.className) like lower(concat('%', :q, '%'))
              or lower(s.faculty)   like lower(concat('%', :q, '%'))
            """)
    Page<Student> search(@Param("q") String q, Pageable pageable);
}