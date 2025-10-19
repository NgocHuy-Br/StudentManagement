package com.StudentManagement.repository;

import com.StudentManagement.entity.Student;
import com.StudentManagement.entity.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.*;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface StudentRepository extends JpaRepository<Student, Long> {

  boolean existsByUser(User user);

  Optional<Student> findByUser(User user);

  // Tìm sinh viên theo username của user
  @EntityGraph(attributePaths = { "user", "major", "classroom" })
  Optional<Student> findByUserUsername(String username);

  // Lấy danh sách sinh viên kèm user để phân trang/sắp xếp theo cả trường của
  // user
  @EntityGraph(attributePaths = { "user" })
  @Query("select s from Student s join s.user u")
  Page<Student> findAllWithUser(Pageable pageable);

  // Tìm kiếm theo MSSV, họ, tên, email, SĐT, lớp, ngành
  @EntityGraph(attributePaths = { "user", "major" })
  @Query("""
      select s from Student s join s.user u
      where
        lower(u.username) like lower(concat('%', :q, '%'))
        or lower(u.fname)  like lower(concat('%', :q, '%'))
        or lower(u.lname)  like lower(concat('%', :q, '%'))
        or lower(u.email)  like lower(concat('%', :q, '%'))
        or lower(u.phone)  like lower(concat('%', :q, '%'))
        or lower(s.className) like lower(concat('%', :q, '%'))
        or lower(s.major.majorName) like lower(concat('%', :q, '%'))
        or lower(s.major.majorCode) like lower(concat('%', :q, '%'))
      """)
  Page<Student> search(@Param("q") String q, Pageable pageable);

  // Đếm số sinh viên theo ngành
  @Query("select count(s) from Student s where s.major.id = :majorId")
  long countByMajorId(@Param("majorId") Long majorId);

  // Lấy sinh viên theo lớp học
  @EntityGraph(attributePaths = { "user", "major", "classroom" })
  Page<Student> findByClassroomId(Long classroomId, Pageable pageable);

  // Lấy tất cả sinh viên theo lớp học (không phân trang)
  @EntityGraph(attributePaths = { "user", "major", "classroom" })
  List<Student> findByClassroomId(Long classroomId);

  // Tìm kiếm sinh viên trong lớp cụ thể
  @EntityGraph(attributePaths = { "user", "major", "classroom" })
  @Query("""
      select s from Student s join s.user u
      where s.classroom.id = :classroomId
        and (lower(u.username) like lower(concat('%', :q, '%'))
             or lower(u.fname) like lower(concat('%', :q, '%'))
             or lower(u.lname) like lower(concat('%', :q, '%'))
             or lower(u.email) like lower(concat('%', :q, '%'))
             or lower(u.phone) like lower(concat('%', :q, '%')))
      """)
  Page<Student> searchByClassroomId(@Param("classroomId") Long classroomId, @Param("q") String q, Pageable pageable);

  // Lấy sinh viên chưa có lớp (để thêm vào lớp)
  @EntityGraph(attributePaths = { "user", "major" })
  @Query("select s from Student s where s.classroom is null and s.major.id = :majorId")
  Page<Student> findUnassignedStudentsByMajorId(@Param("majorId") Long majorId, Pageable pageable);

  // Lấy tất cả sinh viên chưa có lớp
  @EntityGraph(attributePaths = { "user", "major" })
  List<Student> findByClassroomIsNull();

  // Đếm số sinh viên theo khoa
  @Query("SELECT COUNT(s) FROM Student s WHERE s.major.faculty.id = :facultyId")
  Long countByFacultyId(@Param("facultyId") Long facultyId);

  // Đếm số sinh viên theo major
  Long countByMajor(com.StudentManagement.entity.Major major);

  // Đếm số sinh viên theo faculty (thông qua major)
  @Query("SELECT COUNT(s) FROM Student s WHERE s.major.faculty = :faculty")
  Long countByMajorFaculty(@Param("faculty") com.StudentManagement.entity.Faculty faculty);
}