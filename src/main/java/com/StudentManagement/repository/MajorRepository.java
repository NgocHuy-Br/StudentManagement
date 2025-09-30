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

    Optional<Major> findByMajorCode(String majorCode);

    @Query("""
            select m from Major m
            where
              lower(m.majorCode) like lower(concat('%', :q, '%'))
              or lower(m.majorName) like lower(concat('%', :q, '%'))
              or lower(m.description) like lower(concat('%', :q, '%'))
            """)
    Page<Major> search(@Param("q") String q, Pageable pageable);

    @Query("""
            SELECT m FROM Major m
            WHERE lower(m.majorCode) LIKE lower(concat('%', :search, '%'))
               OR lower(m.majorName) LIKE lower(concat('%', :search, '%'))
            ORDER BY m.majorCode ASC
            """)
    List<Major> searchByCodeOrName(@Param("search") String search);

    @Query("""
            SELECT m FROM Major m
            LEFT JOIN m.subjects s
            ORDER BY m.majorCode ASC
            """)
    List<Major> findAllWithSubjectCount();
}