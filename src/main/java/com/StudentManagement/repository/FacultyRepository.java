package com.StudentManagement.repository;

import com.StudentManagement.entity.Faculty;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

@Repository
public interface FacultyRepository extends JpaRepository<Faculty, Long> {

    Optional<Faculty> findByName(String name);

    Optional<Faculty> findByFacultyCode(String facultyCode);

    boolean existsByName(String name);

    boolean existsByFacultyCode(String facultyCode);

    boolean existsByNameAndIdNot(String name, Long id);

    boolean existsByFacultyCodeAndIdNot(String facultyCode, Long id);

    @Query("SELECT f FROM Faculty f ORDER BY f.name ASC")
    List<Faculty> findAllOrderByName();

    @Query("SELECT DISTINCT f FROM Faculty f JOIN f.teachers t WHERE SIZE(f.teachers) > 0 ORDER BY f.name ASC")
    List<Faculty> findFacultiesWithTeachers();

    @Query("""
            SELECT f FROM Faculty f
            WHERE lower(f.facultyCode) LIKE lower(concat('%', :q, '%'))
               OR lower(f.name) LIKE lower(concat('%', :q, '%'))
               OR lower(f.description) LIKE lower(concat('%', :q, '%'))
            ORDER BY f.facultyCode ASC, f.name ASC
            """)
    Page<Faculty> search(@Param("q") String q, Pageable pageable);

    // Query sắp xếp theo số lượng giáo viên
    @Query("""
            SELECT f FROM Faculty f
            LEFT JOIN f.teachers t
            GROUP BY f.id, f.facultyCode, f.name, f.description
            ORDER BY COUNT(t) ASC, f.name ASC
            """)
    Page<Faculty> findAllOrderByTeacherCountAsc(Pageable pageable);

    @Query("""
            SELECT f FROM Faculty f
            LEFT JOIN f.teachers t
            GROUP BY f.id, f.facultyCode, f.name, f.description
            ORDER BY COUNT(t) DESC, f.name ASC
            """)
    Page<Faculty> findAllOrderByTeacherCountDesc(Pageable pageable);

    // Query tìm kiếm và sắp xếp theo số lượng giáo viên
    @Query("""
            SELECT f FROM Faculty f
            LEFT JOIN f.teachers t
            WHERE lower(f.facultyCode) LIKE lower(concat('%', :q, '%'))
               OR lower(f.name) LIKE lower(concat('%', :q, '%'))
               OR lower(f.description) LIKE lower(concat('%', :q, '%'))
            GROUP BY f.id, f.facultyCode, f.name, f.description
            ORDER BY COUNT(t) ASC, f.name ASC
            """)
    Page<Faculty> searchOrderByTeacherCountAsc(@Param("q") String q, Pageable pageable);

    @Query("""
            SELECT f FROM Faculty f
            LEFT JOIN f.teachers t
            WHERE lower(f.facultyCode) LIKE lower(concat('%', :q, '%'))
               OR lower(f.name) LIKE lower(concat('%', :q, '%'))
               OR lower(f.description) LIKE lower(concat('%', :q, '%'))
            GROUP BY f.id, f.facultyCode, f.name, f.description
            ORDER BY COUNT(t) DESC, f.name ASC
            """)
    Page<Faculty> searchOrderByTeacherCountDesc(@Param("q") String q, Pageable pageable);

    // Query sắp xếp theo số lượng ngành (majorCount)
    @Query("""
            SELECT f FROM Faculty f
            LEFT JOIN Major m ON m.faculty.id = f.id
            GROUP BY f.id, f.facultyCode, f.name, f.description
            ORDER BY COUNT(DISTINCT m.id) ASC, f.name ASC
            """)
    Page<Faculty> findAllOrderByMajorCountAsc(Pageable pageable);

    @Query("""
            SELECT f FROM Faculty f
            LEFT JOIN Major m ON m.faculty.id = f.id
            GROUP BY f.id, f.facultyCode, f.name, f.description
            ORDER BY COUNT(DISTINCT m.id) DESC, f.name ASC
            """)
    Page<Faculty> findAllOrderByMajorCountDesc(Pageable pageable);

    @Query("""
            SELECT f FROM Faculty f
            LEFT JOIN Major m ON m.faculty.id = f.id
            WHERE lower(f.facultyCode) LIKE lower(concat('%', :q, '%'))
               OR lower(f.name) LIKE lower(concat('%', :q, '%'))
               OR lower(f.description) LIKE lower(concat('%', :q, '%'))
            GROUP BY f.id, f.facultyCode, f.name, f.description
            ORDER BY COUNT(DISTINCT m.id) ASC, f.name ASC
            """)
    Page<Faculty> searchOrderByMajorCountAsc(@Param("q") String q, Pageable pageable);

    @Query("""
            SELECT f FROM Faculty f
            LEFT JOIN Major m ON m.faculty.id = f.id
            WHERE lower(f.facultyCode) LIKE lower(concat('%', :q, '%'))
               OR lower(f.name) LIKE lower(concat('%', :q, '%'))
               OR lower(f.description) LIKE lower(concat('%', :q, '%'))
            GROUP BY f.id, f.facultyCode, f.name, f.description
            ORDER BY COUNT(DISTINCT m.id) DESC, f.name ASC
            """)
    Page<Faculty> searchOrderByMajorCountDesc(@Param("q") String q, Pageable pageable);

    // Query sắp xếp theo số lượng sinh viên (studentCount)
    @Query("""
            SELECT f FROM Faculty f
            LEFT JOIN Major m ON m.faculty.id = f.id
            LEFT JOIN Student s ON s.major.id = m.id
            GROUP BY f.id, f.facultyCode, f.name, f.description
            ORDER BY COUNT(DISTINCT s.id) ASC, f.name ASC
            """)
    Page<Faculty> findAllOrderByStudentCountAsc(Pageable pageable);

    @Query("""
            SELECT f FROM Faculty f
            LEFT JOIN Major m ON m.faculty.id = f.id
            LEFT JOIN Student s ON s.major.id = m.id
            GROUP BY f.id, f.facultyCode, f.name, f.description
            ORDER BY COUNT(DISTINCT s.id) DESC, f.name ASC
            """)
    Page<Faculty> findAllOrderByStudentCountDesc(Pageable pageable);

    @Query("""
            SELECT f FROM Faculty f
            LEFT JOIN Major m ON m.faculty.id = f.id
            LEFT JOIN Student s ON s.major.id = m.id
            WHERE lower(f.facultyCode) LIKE lower(concat('%', :q, '%'))
               OR lower(f.name) LIKE lower(concat('%', :q, '%'))
               OR lower(f.description) LIKE lower(concat('%', :q, '%'))
            GROUP BY f.id, f.facultyCode, f.name, f.description
            ORDER BY COUNT(DISTINCT s.id) ASC, f.name ASC
            """)
    Page<Faculty> searchOrderByStudentCountAsc(@Param("q") String q, Pageable pageable);

    @Query("""
            SELECT f FROM Faculty f
            LEFT JOIN Major m ON m.faculty.id = f.id
            LEFT JOIN Student s ON s.major.id = m.id
            WHERE lower(f.facultyCode) LIKE lower(concat('%', :q, '%'))
               OR lower(f.name) LIKE lower(concat('%', :q, '%'))
               OR lower(f.description) LIKE lower(concat('%', :q, '%'))
            GROUP BY f.id, f.facultyCode, f.name, f.description
            ORDER BY COUNT(DISTINCT s.id) DESC, f.name ASC
            """)
    Page<Faculty> searchOrderByStudentCountDesc(@Param("q") String q, Pageable pageable);
}