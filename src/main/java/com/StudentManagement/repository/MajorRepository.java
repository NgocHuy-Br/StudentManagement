package com.StudentManagement.repository;

import com.StudentManagement.entity.Major;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface MajorRepository extends JpaRepository<Major, Long> {

  boolean existsByMajorCode(String majorCode);

  boolean existsByMajorCodeAndIdNot(String majorCode, Long id);

  List<Major> findByMajorCode(String majorCode);

  // Lấy danh sách mã ngành duy nhất
  @Query("SELECT DISTINCT m.majorCode FROM Major m ORDER BY m.majorCode")
  List<String> findDistinctMajorCodes();

  // Tìm kiếm theo faculty
  Page<Major> findByFacultyId(Long facultyId, Pageable pageable);

  List<Major> findByFacultyIdOrderByMajorCodeAsc(Long facultyId);

  @Query("""
      select m from Major m
      where
        (lower(m.majorCode) like lower(concat('%', :q, '%'))
        or lower(m.majorName) like lower(concat('%', :q, '%'))
        or lower(m.description) like lower(concat('%', :q, '%'))
        or lower(m.faculty.name) like lower(concat('%', :q, '%'))
        or lower(m.faculty.facultyCode) like lower(concat('%', :q, '%')))
      """)
  Page<Major> search(@Param("q") String q, Pageable pageable);

  @Query("""
      SELECT m FROM Major m
      LEFT JOIN FETCH m.faculty
      WHERE lower(m.majorCode) LIKE lower(concat('%', :search, '%'))
         OR lower(m.majorName) LIKE lower(concat('%', :search, '%'))
      ORDER BY m.majorCode ASC
      """)
  List<Major> searchByCodeOrName(@Param("search") String search);

  @Query("""
      SELECT DISTINCT m FROM Major m
      LEFT JOIN FETCH m.faculty
      LEFT JOIN FETCH m.subjects
      ORDER BY m.majorCode ASC
      """)
  List<Major> findAllWithSubjectCount();

  // Đếm số ngành theo faculty
  Long countByFaculty(com.StudentManagement.entity.Faculty faculty);

  // Đếm số ngành theo faculty ID
  Long countByFacultyId(Long facultyId);

  // Tìm kiếm theo mã/tên và khoa
  @Query("""
      SELECT m FROM Major m
      LEFT JOIN FETCH m.faculty
      WHERE m.faculty.id = :facultyId
        AND (lower(m.majorCode) LIKE lower(concat('%', :search, '%'))
         OR lower(m.majorName) LIKE lower(concat('%', :search, '%')))
      ORDER BY m.majorCode ASC
      """)
  List<Major> searchByCodeOrNameAndFaculty(@Param("search") String search, @Param("facultyId") Long facultyId);

  // Lấy tất cả ngành theo khoa với thông tin môn học
  @Query("""
      SELECT DISTINCT m FROM Major m
      LEFT JOIN FETCH m.faculty
      LEFT JOIN FETCH m.subjects
      WHERE m.faculty.id = :facultyId
      ORDER BY m.majorCode ASC
      """)
  List<Major> findByFacultyIdWithSubjectCount(@Param("facultyId") Long facultyId);
}