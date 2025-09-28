package com.StudentManagement.repository;

import com.StudentManagement.entity.Faculty;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

@Repository
public interface FacultyRepository extends JpaRepository<Faculty, Long> {

    Optional<Faculty> findByName(String name);

    boolean existsByName(String name);

    @Query("SELECT f FROM Faculty f ORDER BY f.name ASC")
    List<Faculty> findAllOrderByName();

    @Query("SELECT DISTINCT f FROM Faculty f JOIN f.teachers t WHERE SIZE(f.teachers) > 0 ORDER BY f.name ASC")
    List<Faculty> findFacultiesWithTeachers();
}