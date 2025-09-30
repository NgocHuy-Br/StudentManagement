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

  // Lấy danh sách môn học kèm ngành để phân trang/sắp xếp
  @EntityGraph(attributePaths = { "majors" })
  Page<Subject> findAll(Pageable pageable);

  // Tìm kiếm theo mã môn, tên môn
  @EntityGraph(attributePaths = { "majors" })
  @Query("""
      select distinct s from Subject s left join s.majors m
      where
        lower(s.subjectCode) like lower(concat('%', :q, '%'))
        or lower(s.subjectName) like lower(concat('%', :q, '%'))
      """)
  Page<Subject> search(@Param("q") String q, Pageable pageable);

  // Lấy môn học theo ngành (Many-to-Many) - Pageable version
  @EntityGraph(attributePaths = { "majors" })
  @Query("select distinct s from Subject s join s.majors m where m.id = :majorId")
  Page<Subject> findByMajorId(Long majorId, Pageable pageable);

  // Lấy môn học theo ngành (Many-to-Many) - List version
  @EntityGraph(attributePaths = { "majors" })
  @Query("select distinct s from Subject s join s.majors m where m.id = :majorId")
  List<Subject> findByMajorId(Long majorId);

  // Tìm kiếm môn học trong một ngành cụ thể
  @EntityGraph(attributePaths = { "majors" })
  @Query("""
      select distinct s from Subject s join s.majors m
      where m.id = :majorId
        and (lower(s.subjectCode) like lower(concat('%', :q, '%'))
             or lower(s.subjectName) like lower(concat('%', :q, '%')))
      """)
  Page<Subject> searchByMajorId(@Param("majorId") Long majorId, @Param("q") String q, Pageable pageable);

  // Đếm số môn học theo ngành (Many-to-Many)
  @Query("select count(distinct s) from Subject s join s.majors m where m.id = :majorId")
  long countByMajorId(@Param("majorId") Long majorId);

  // Lấy môn học theo ngành với sắp xếp
  @EntityGraph(attributePaths = { "majors" })
  @Query("select distinct s from Subject s join s.majors m where m.id = :majorId")
  List<Subject> findByMajorIdWithSort(@Param("majorId") Long majorId, org.springframework.data.domain.Sort sort);

  // Tìm kiếm môn học trong ngành với sắp xếp
  @EntityGraph(attributePaths = { "majors" })
  @Query("""
      select distinct s from Subject s join s.majors m
      where m.id = :majorId
        and (lower(s.subjectCode) like lower(concat('%', :q, '%'))
             or lower(s.subjectName) like lower(concat('%', :q, '%')))
      """)
  List<Subject> findByMajorIdAndSearchWithSort(@Param("majorId") Long majorId, @Param("q") String q,
      org.springframework.data.domain.Sort sort);

  // Lấy danh sách môn học chưa thuộc ngành
  @Query("""
      SELECT s FROM Subject s
      WHERE s.id NOT IN (
          SELECT DISTINCT sub.id FROM Subject sub
          JOIN sub.majors m
          WHERE m.id = :majorId
      )
      ORDER BY s.subjectCode ASC
      """)
  List<Subject> findSubjectsNotInMajor(@Param("majorId") Long majorId);
}