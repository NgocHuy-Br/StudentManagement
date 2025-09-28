package com.StudentManagement.repository;

import com.StudentManagement.entity.ClassroomTeacher;
import com.StudentManagement.entity.Classroom;
import com.StudentManagement.entity.Teacher;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

public interface ClassroomTeacherRepository extends JpaRepository<ClassroomTeacher, Long> {

    // Tìm giáo viên chủ nhiệm hiện tại của lớp
    Optional<ClassroomTeacher> findByClassroomAndEndDateIsNull(Classroom classroom);

    // Tìm giáo viên chủ nhiệm hiện tại theo ID lớp
    @Query("SELECT ct FROM ClassroomTeacher ct WHERE ct.classroom.id = :classroomId AND ct.endDate IS NULL")
    Optional<ClassroomTeacher> findCurrentByClassroomId(@Param("classroomId") Long classroomId);

    // Lịch sử giáo viên chủ nhiệm của lớp
    List<ClassroomTeacher> findByClassroomOrderByStartDateDesc(Classroom classroom);

    // Lịch sử giáo viên chủ nhiệm theo ID lớp
    @Query("SELECT ct FROM ClassroomTeacher ct WHERE ct.classroom.id = :classroomId ORDER BY ct.startDate DESC")
    List<ClassroomTeacher> findByClassroomIdOrderByStartDateDesc(@Param("classroomId") Long classroomId);

    // Các lớp mà giáo viên đang chủ nhiệm
    List<ClassroomTeacher> findByTeacherAndEndDateIsNull(Teacher teacher);

    // Các lớp mà giáo viên đang chủ nhiệm theo ID giáo viên
    @Query("SELECT ct FROM ClassroomTeacher ct WHERE ct.teacher.id = :teacherId AND ct.endDate IS NULL")
    List<ClassroomTeacher> findCurrentByTeacherId(@Param("teacherId") Long teacherId);

    // Lịch sử chủ nhiệm của giáo viên
    List<ClassroomTeacher> findByTeacherOrderByStartDateDesc(Teacher teacher);

    // Tìm giáo viên chủ nhiệm tại thời điểm cụ thể
    @Query("SELECT ct FROM ClassroomTeacher ct WHERE ct.classroom = :classroom " +
            "AND ct.startDate <= :date AND (ct.endDate IS NULL OR ct.endDate > :date)")
    Optional<ClassroomTeacher> findByClassroomAndDate(@Param("classroom") Classroom classroom,
            @Param("date") LocalDate date);

    // Kiểm tra xem giáo viên có đang chủ nhiệm lớp nào không
    boolean existsByTeacherAndEndDateIsNull(Teacher teacher);

    // Kiểm tra xem lớp có giáo viên chủ nhiệm hiện tại không
    boolean existsByClassroomAndEndDateIsNull(Classroom classroom);

    // Tìm các lớp không có giáo viên chủ nhiệm
    @Query("SELECT c FROM Classroom c WHERE c.id NOT IN " +
            "(SELECT ct.classroom.id FROM ClassroomTeacher ct WHERE ct.endDate IS NULL)")
    Page<Classroom> findClassroomsWithoutCurrentTeacher(Pageable pageable);

    // Thống kê: Đếm số lớp mà giáo viên đang chủ nhiệm
    @Query("SELECT COUNT(ct) FROM ClassroomTeacher ct WHERE ct.teacher = :teacher AND ct.endDate IS NULL")
    long countCurrentClassroomsByTeacher(@Param("teacher") Teacher teacher);

    // Tìm các thay đổi giáo viên chủ nhiệm gần đây
    @Query("SELECT ct FROM ClassroomTeacher ct WHERE ct.startDate >= :fromDate ORDER BY ct.startDate DESC")
    Page<ClassroomTeacher> findRecentChanges(@Param("fromDate") LocalDate fromDate, Pageable pageable);
}