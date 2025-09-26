package com.StudentManagement.repository;

import com.StudentManagement.entity.Teacher;
import com.StudentManagement.entity.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.Optional;

public interface TeacherRepository extends JpaRepository<Teacher, Long> {

    boolean existsByUser(User user);

    Optional<Teacher> findByUser(User user);

    // Lấy danh sách giáo viên kèm user để phân trang/sắp xếp
    @EntityGraph(attributePaths = { "user" })
    @Query("select t from Teacher t join t.user u")
    Page<Teacher> findAllWithUser(Pageable pageable);

    // Tìm kiếm theo mã GV, họ, tên, email, SĐT, bộ môn
    @EntityGraph(attributePaths = { "user" })
    @Query("""
            select t from Teacher t join t.user u
            where
              lower(u.username) like lower(concat('%', :q, '%'))
              or lower(u.fname) like lower(concat('%', :q, '%'))
              or lower(u.lname) like lower(concat('%', :q, '%'))
              or lower(u.email) like lower(concat('%', :q, '%'))
              or lower(u.phone) like lower(concat('%', :q, '%'))
              or lower(t.department) like lower(concat('%', :q, '%'))
            """)
    Page<Teacher> search(@Param("q") String q, Pageable pageable);
}