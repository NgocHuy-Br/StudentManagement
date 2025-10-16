// filepath: d:\3. PTIT\05. HK 4\05. TT Co so\1. Do an\StudentManagement\src\main\java\com\StudentManagement\repository\UserRepository.java
package com.StudentManagement.repository;

import com.StudentManagement.entity.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.*;
import org.springframework.data.repository.query.Param;

import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Long> {

  Optional<User> findByUsername(String username);

  Optional<User> findByEmail(String email);

  boolean existsByUsername(String username);

  boolean existsByEmail(String email);

  Optional<User> findByNationalId(String nationalId);

  boolean existsByNationalId(String nationalId);

  boolean existsByRole(User.Role role);

  Page<User> findByRole(User.Role role, Pageable pageable);

  @Query("""
      select u from User u
      where u.role = :role
        and (
           lower(u.username) like lower(concat('%', :q, '%')) or
           lower(u.fname)    like lower(concat('%', :q, '%')) or
           lower(u.lname)    like lower(concat('%', :q, '%')) or
           lower(u.email)    like lower(concat('%', :q, '%')) or
           lower(u.phone)    like lower(concat('%', :q, '%')) or
           u.nationalId       like concat('%', :q, '%')
        )
      """)
  Page<User> searchByRoleAndQuery(@Param("role") User.Role role,
      @Param("q") String q,
      Pageable pageable);
}