package com.StudentManagement.repository;

import com.StudentManagement.entity.Classroom;
import com.StudentManagement.entity.Major;
import com.StudentManagement.entity.Teacher;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface ClassroomRepository extends JpaRepository<Classroom, Long> {

  boolean existsByClassCode(String classCode);

  Optional<Classroom> findByClassCode(String classCode);

  // Lấy danh sách lớp kèm thông tin major, teacher để phân trang/sắp xếp
  @EntityGraph(attributePaths = { "major", "homeRoomTeacher", "homeRoomTeacher.user", "students" })
  Page<Classroom> findAll(Pageable pageable);

  // Tìm kiếm theo mã lớp, khóa học, ngành, giáo viên
  @EntityGraph(attributePaths = { "major", "homeRoomTeacher", "homeRoomTeacher.user", "students" })
  @Query("""
      select c from Classroom c
      left join c.major m
      left join c.homeRoomTeacher t
      left join t.user tu
      where
        lower(c.classCode) like lower(concat('%', :q, '%'))
        or lower(c.courseYear) like lower(concat('%', :q, '%'))
        or lower(m.majorCode) like lower(concat('%', :q, '%'))
        or lower(m.majorName) like lower(concat('%', :q, '%'))
        or lower(tu.fname) like lower(concat('%', :q, '%'))
        or lower(tu.lname) like lower(concat('%', :q, '%'))
        or lower(concat(tu.fname, ' ', tu.lname)) like lower(concat('%', :q, '%'))
        or lower(concat(tu.lname, ' ', tu.fname)) like lower(concat('%', :q, '%'))
      """)
  Page<Classroom> search(@Param("q") String q, Pageable pageable);

  // Lấy lớp theo ngành
  @EntityGraph(attributePaths = { "major", "homeRoomTeacher", "homeRoomTeacher.user", "students" })
  Page<Classroom> findByMajor(Major major, Pageable pageable);

  // Đếm số sinh viên trong lớp
  @Query("select count(s) from Student s where s.classroom.id = :classroomId")
  long countStudentsByClassroomId(@Param("classroomId") Long classroomId);

  // Lấy danh sách lớp theo ngành (không phân trang)
  List<Classroom> findByMajorId(Long majorId);

  // Lấy danh sách lớp theo ngành (có phân trang)
  @EntityGraph(attributePaths = { "major", "homeRoomTeacher", "homeRoomTeacher.user", "students" })
  Page<Classroom> findByMajorId(Long majorId, Pageable pageable);

  // Tìm kiếm theo tên lớp và lọc theo ngành
  @EntityGraph(attributePaths = { "major", "homeRoomTeacher", "homeRoomTeacher.user", "students" })
  @Query("""
      select c from Classroom c
      left join c.major m
      left join c.homeRoomTeacher t
      left join t.user tu
      where
        m.id = :majorId AND (
          lower(c.classCode) like lower(concat('%', :search, '%'))
          or lower(c.courseYear) like lower(concat('%', :search, '%'))
          or lower(tu.fname) like lower(concat('%', :search, '%'))
          or lower(tu.lname) like lower(concat('%', :search, '%'))
          or lower(concat(tu.fname, ' ', tu.lname)) like lower(concat('%', :search, '%'))
          or lower(concat(tu.lname, ' ', tu.fname)) like lower(concat('%', :search, '%'))
        )
      """)
  Page<Classroom> searchByClassCodeAndMajor(@Param("search") String search, @Param("majorId") Long majorId,
      Pageable pageable);

  // Find classrooms by homeroom teacher
  @EntityGraph(attributePaths = { "major", "homeRoomTeacher", "homeRoomTeacher.user", "students" })
  List<Classroom> findByHomeRoomTeacher(Teacher teacher);
}