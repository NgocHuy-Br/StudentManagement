package com.StudentManagement.repository;

import com.StudentManagement.entity.Score;
import com.StudentManagement.entity.Student;
import com.StudentManagement.entity.Subject;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface ScoreRepository extends JpaRepository<Score, Long> {

  // Tìm điểm theo sinh viên và môn học
  Optional<Score> findByStudentAndSubject(Student student, Subject subject);

  // Lấy tất cả điểm của 1 sinh viên
  @EntityGraph(attributePaths = { "subject", "subject.majors" })
  List<Score> findByStudent(Student student);

  // Lấy danh sách điểm của 1 môn học (cho giáo viên xem)
  @EntityGraph(attributePaths = { "student", "student.user", "subject" })
  Page<Score> findBySubject(Subject subject, Pageable pageable);

  // Tính điểm trung bình tích lũy của sinh viên
  @Query("""
      select avg(s.avgScore * sub.credit) / avg(sub.credit)
      from Score s join s.subject sub
      where s.student = :student and s.avgScore is not null
      """)
  Double calculateGPAForStudent(@Param("student") Student student);

  // Tìm kiếm điểm theo nhiều tiêu chí
  @EntityGraph(attributePaths = { "student", "student.user", "subject", "subject.majors" })
  @Query("""
      select sc from Score sc
      join sc.student st
      join st.user u
      join sc.subject sub
      where
        lower(u.username) like lower(concat('%', :q, '%'))
        or lower(u.fname) like lower(concat('%', :q, '%'))
        or lower(u.lname) like lower(concat('%', :q, '%'))
        or lower(sub.subjectCode) like lower(concat('%', :q, '%'))
        or lower(sub.subjectName) like lower(concat('%', :q, '%'))
      """)
  Page<Score> search(@Param("q") String q, Pageable pageable);

  // Đếm số điểm theo môn học
  @Query("select count(sc) from Score sc where sc.subject.id = :subjectId")
  long countBySubjectId(@Param("subjectId") Long subjectId);

  // Lấy điểm theo lớp học
  @EntityGraph(attributePaths = { "student", "student.user", "subject" })
  @Query("select sc from Score sc join sc.student st where st.classroom.id = :classroomId")
  Page<Score> findByClassroomId(@Param("classroomId") Long classroomId, Pageable pageable);

  // Lấy điểm theo lớp và môn học
  @EntityGraph(attributePaths = { "student", "student.user", "subject" })
  @Query("select sc from Score sc join sc.student st where st.classroom.id = :classroomId and sc.subject.id = :subjectId")
  List<Score> findByStudentClassroomIdAndSubjectId(@Param("classroomId") Long classroomId,
      @Param("subjectId") Long subjectId);

  // Tìm điểm theo ID sinh viên và ID môn học
  @EntityGraph(attributePaths = { "student", "student.user", "subject" })
  @Query("select sc from Score sc where sc.student.id = :studentId and sc.subject.id = :subjectId")
  Optional<Score> findByStudentIdAndSubjectId(@Param("studentId") Long studentId,
      @Param("subjectId") Long subjectId);
}