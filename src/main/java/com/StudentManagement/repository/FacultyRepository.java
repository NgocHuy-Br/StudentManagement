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
}