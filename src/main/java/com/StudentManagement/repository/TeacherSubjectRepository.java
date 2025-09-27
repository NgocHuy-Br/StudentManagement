package com.StudentManagement.repository;

import com.StudentManagement.entity.TeacherSubject;
import com.StudentManagement.entity.Teacher;
import com.StudentManagement.entity.Subject;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.*;
import org.springframework.data.repository.query.Param;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

public interface TeacherSubjectRepository extends JpaRepository<TeacherSubject, Long> {

  // Tìm phân công dạy theo giáo viên và môn học
  Optional<TeacherSubject> findByTeacherAndSubject(Teacher teacher, Subject subject);

  // Lấy tất cả môn học mà giáo viên phụ trách
  @EntityGraph(attributePaths = { "subject", "subject.major" })
  List<TeacherSubject> findByTeacher(Teacher teacher);

  // Lấy môn học mà giáo viên phụ trách theo học kỳ
  @EntityGraph(attributePaths = { "subject", "subject.major" })
  List<TeacherSubject> findByTeacherAndSemester(Teacher teacher, String semester);

  // Lấy tất cả giáo viên dạy 1 môn học
  @EntityGraph(attributePaths = { "teacher", "teacher.user" })
  List<TeacherSubject> findBySubject(Subject subject);

  // Lấy giáo viên dạy môn học theo học kỳ
  @EntityGraph(attributePaths = { "teacher", "teacher.user" })
  List<TeacherSubject> findBySubjectAndSemester(Subject subject, String semester);

  // Lấy tất cả phân công dạy với thông tin đầy đủ
  @EntityGraph(attributePaths = { "teacher", "teacher.user", "subject", "subject.major" })
  @Query("select ts from TeacherSubject ts")
  Page<TeacherSubject> findAllWithDetails(Pageable pageable);

  // Tìm kiếm phân công dạy
  @EntityGraph(attributePaths = { "teacher", "teacher.user", "subject", "subject.major" })
  @Query("""
      select ts from TeacherSubject ts
      join ts.teacher t
      join t.user u
      join ts.subject s
      where
        lower(u.username) like lower(concat('%', :q, '%'))
        or lower(u.fname) like lower(concat('%', :q, '%'))
        or lower(u.lname) like lower(concat('%', :q, '%'))
        or lower(s.subjectCode) like lower(concat('%', :q, '%'))
        or lower(s.subjectName) like lower(concat('%', :q, '%'))
        or lower(ts.semester) like lower(concat('%', :q, '%'))
        or lower(ts.className) like lower(concat('%', :q, '%'))
      """)
  Page<TeacherSubject> search(@Param("q") String q, Pageable pageable);

  // Kiểm tra xem giáo viên có đang dạy môn học này không
  boolean existsByTeacherAndSubjectAndSemester(Teacher teacher, Subject subject, String semester);

  // Xóa phân công theo môn học
  @Modifying
  @Transactional
  @Query("DELETE FROM TeacherSubject ts WHERE ts.subject.id = :subjectId")
  void deleteBySubjectId(@Param("subjectId") Long subjectId);
}