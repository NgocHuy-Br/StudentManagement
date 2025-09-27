package com.StudentManagement.repository;

import com.StudentManagement.entity.Subject;
import com.StudentManagement.entity.Major;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface SubjectRepository extends JpaRepository<Subject, Long> {

  boolean existsBySubjectCode(String subjectCode);

  Optional<Subject> findBySubjectCode(String subjectCode);

  List<Subject> findByMajor(Major major);

  // Lấy danh sách môn học kèm ngành để phân trang/sắp xếp
  @EntityGraph(attributePaths = { "major" })
  @Query("select s from Subject s join s.major m")
  Page<Subject> findAllWithMajor(Pageable pageable);

  // Tìm kiếm theo mã môn, tên môn, ngành
  @EntityGraph(attributePaths = { "major" })
  @Query("""
      select s from Subject s join s.major m
      where
        lower(s.subjectCode) like lower(concat('%', :q, '%'))
        or lower(s.subjectName) like lower(concat('%', :q, '%'))
        or lower(m.majorCode) like lower(concat('%', :q, '%'))
        or lower(m.majorName) like lower(concat('%', :q, '%'))
      """)
  Page<Subject> search(@Param("q") String q, Pageable pageable);

  // Lấy môn học theo ngành
  @EntityGraph(attributePaths = { "major" })
  Page<Subject> findByMajorId(Long majorId, Pageable pageable);

  // Tìm kiếm môn học trong một ngành cụ thể
  @EntityGraph(attributePaths = { "major" })
  @Query("""
      select s from Subject s
      where s.major.id = :majorId
        and (lower(s.subjectCode) like lower(concat('%', :q, '%'))
             or lower(s.subjectName) like lower(concat('%', :q, '%')))
      """)
  Page<Subject> searchByMajorId(@Param("majorId") Long majorId, @Param("q") String q, Pageable pageable);

  // Đếm số môn học theo ngành
  @Query("select count(s) from Subject s where s.major.id = :majorId")
  long countByMajorId(@Param("majorId") Long majorId);
}