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
    @EntityGraph(attributePaths = { "major" })
    Page<Subject> findAll(Pageable pageable);

    // Tìm kiếm theo mã môn, tên môn
    @EntityGraph(attributePaths = { "major" })
    @Query("""
            select s from Subject s
            where lower(s.subjectCode) like lower(concat('%', :q, '%'))
              or lower(s.subjectName) like lower(concat('%', :q, '%'))
            """)
    Page<Subject> search(@Param("q") String q, Pageable pageable);

    // Lấy môn học theo ngành (One-to-Many) - Pageable version
    @EntityGraph(attributePaths = { "major" })
    Page<Subject> findByMajorId(Long majorId, Pageable pageable);

    // Lấy môn học theo ngành (One-to-Many) - List version
    @EntityGraph(attributePaths = { "major" })
    List<Subject> findByMajorId(Long majorId);

    // Tìm kiếm môn học trong một ngành cụ thể
    @EntityGraph(attributePaths = { "major" })
    @Query("""
            select s from Subject s
            where s.major.id = :majorId
              and (lower(s.subjectCode) like lower(concat('%', :q, '%'))
                   or lower(s.subjectName) like lower(concat('%', :q, '%')))
            """)
    Page<Subject> searchByMajorId(@Param("majorId") Long majorId, @Param("q") String q, Pageable pageable);

    // Đếm số môn học theo ngành (One-to-Many)
    long countByMajorId(Long majorId);

    // Lấy môn học theo ngành với sắp xếp
    @EntityGraph(attributePaths = { "major" })
    List<Subject> findByMajorId(Long majorId, org.springframework.data.domain.Sort sort);

    // Tìm kiếm môn học trong ngành với sắp xếp
    @EntityGraph(attributePaths = { "major" })
    @Query("""
            select s from Subject s
            where s.major.id = :majorId
              and (lower(s.subjectCode) like lower(concat('%', :q, '%'))
                   or lower(s.subjectName) like lower(concat('%', :q, '%')))
            """)
    List<Subject> findByMajorIdAndSearchWithSort(@Param("majorId") Long majorId, @Param("q") String q,
            org.springframework.data.domain.Sort sort);

    // Lấy danh sách môn học chưa thuộc ngành nào (để thêm vào ngành)
    @Query("SELECT s FROM Subject s WHERE s.major IS NULL ORDER BY s.subjectCode ASC")
    List<Subject> findSubjectsWithoutMajor();

    // Tìm kiếm tất cả môn học (không phụ thuộc ngành)
    @EntityGraph(attributePaths = { "major" })
    @Query("""
            select s from Subject s
            where lower(s.subjectCode) like lower(concat('%', :q, '%'))
               or lower(s.subjectName) like lower(concat('%', :q, '%'))
            """)
    List<Subject> findAllBySearchWithSort(@Param("q") String q, org.springframework.data.domain.Sort sort);

    // Helper method for data migration - get major IDs from old many-to-many table
    @Query(value = "SELECT major_id FROM major_subjects WHERE subject_id = :subjectId", nativeQuery = true)
    List<Long> findMajorIdsBySubjectId(@Param("subjectId") Long subjectId);
}