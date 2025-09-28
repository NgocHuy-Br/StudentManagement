package com.StudentManagement.service;

import com.StudentManagement.entity.ClassroomTeacher;
import com.StudentManagement.entity.Classroom;
import com.StudentManagement.entity.Teacher;
import com.StudentManagement.repository.ClassroomTeacherRepository;
import com.StudentManagement.repository.ClassroomRepository;
import com.StudentManagement.repository.TeacherRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class ClassroomTeacherService {

    @Autowired
    private ClassroomTeacherRepository classroomTeacherRepository;

    @Autowired
    private ClassroomRepository classroomRepository;

    @Autowired
    private TeacherRepository teacherRepository;

    /**
     * Gán giáo viên chủ nhiệm cho lớp
     */
    public ClassroomTeacher assignHomeRoomTeacher(Long classroomId, Long teacherId, String notes) {
        Classroom classroom = classroomRepository.findById(classroomId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy lớp học"));

        Teacher teacher = teacherRepository.findById(teacherId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy giáo viên"));

        // Kết thúc nhiệm kỳ của giáo viên chủ nhiệm hiện tại (nếu có)
        Optional<ClassroomTeacher> currentTeacher = classroomTeacherRepository
                .findByClassroomAndEndDateIsNull(classroom);

        if (currentTeacher.isPresent()) {
            ClassroomTeacher current = currentTeacher.get();
            current.setEndDate(LocalDate.now());
            current.setNotes((current.getNotes() != null ? current.getNotes() + ". " : "") +
                    "Kết thúc nhiệm kỳ: " + LocalDate.now());
            classroomTeacherRepository.save(current);
        }

        // Tạo bản ghi mới cho giáo viên chủ nhiệm mới
        ClassroomTeacher newAssignment = new ClassroomTeacher(classroom, teacher, LocalDate.now(), notes);
        ClassroomTeacher saved = classroomTeacherRepository.save(newAssignment);

        // Cập nhật trường homeRoomTeacher trong Classroom để query nhanh
        classroom.setHomeRoomTeacher(teacher);
        classroomRepository.save(classroom);

        return saved;
    }

    /**
     * Kết thúc nhiệm kỳ giáo viên chủ nhiệm
     */
    public void endHomeRoomAssignment(Long classroomId, String notes) {
        Classroom classroom = classroomRepository.findById(classroomId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy lớp học"));

        Optional<ClassroomTeacher> currentTeacher = classroomTeacherRepository
                .findByClassroomAndEndDateIsNull(classroom);

        if (currentTeacher.isPresent()) {
            ClassroomTeacher current = currentTeacher.get();
            current.setEndDate(LocalDate.now());
            current.setNotes((current.getNotes() != null ? current.getNotes() + ". " : "") + notes);
            classroomTeacherRepository.save(current);

            // Xóa homeRoomTeacher trong Classroom
            classroom.setHomeRoomTeacher(null);
            classroomRepository.save(classroom);
        }
    }

    /**
     * Chuyển giao giáo viên chủ nhiệm
     */
    public ClassroomTeacher transferHomeRoomTeacher(Long classroomId, Long newTeacherId, String notes) {
        return assignHomeRoomTeacher(classroomId, newTeacherId, "Chuyển giao: " + notes);
    }

    /**
     * Lấy giáo viên chủ nhiệm hiện tại của lớp
     */
    @Transactional(readOnly = true)
    public Optional<ClassroomTeacher> getCurrentHomeRoomTeacher(Long classroomId) {
        return classroomTeacherRepository.findCurrentByClassroomId(classroomId);
    }

    /**
     * Lấy lịch sử giáo viên chủ nhiệm của lớp
     */
    @Transactional(readOnly = true)
    public List<ClassroomTeacher> getHomeRoomTeacherHistory(Long classroomId) {
        return classroomTeacherRepository.findByClassroomIdOrderByStartDateDesc(classroomId);
    }

    /**
     * Lấy các lớp mà giáo viên đang chủ nhiệm
     */
    @Transactional(readOnly = true)
    public List<ClassroomTeacher> getCurrentClassroomsByTeacher(Long teacherId) {
        return classroomTeacherRepository.findCurrentByTeacherId(teacherId);
    }

    /**
     * Lấy lịch sử chủ nhiệm của giáo viên
     */
    @Transactional(readOnly = true)
    public List<ClassroomTeacher> getTeacherHomeRoomHistory(Long teacherId) {
        Teacher teacher = teacherRepository.findById(teacherId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy giáo viên"));
        return classroomTeacherRepository.findByTeacherOrderByStartDateDesc(teacher);
    }

    /**
     * Lấy các lớp không có giáo viên chủ nhiệm
     */
    @Transactional(readOnly = true)
    public Page<Classroom> getClassroomsWithoutHomeRoomTeacher(Pageable pageable) {
        return classroomTeacherRepository.findClassroomsWithoutCurrentTeacher(pageable);
    }

    /**
     * Thống kê số lớp mà giáo viên đang chủ nhiệm
     */
    @Transactional(readOnly = true)
    public long countCurrentClassroomsByTeacher(Long teacherId) {
        Teacher teacher = teacherRepository.findById(teacherId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy giáo viên"));
        return classroomTeacherRepository.countCurrentClassroomsByTeacher(teacher);
    }

    /**
     * Lấy các thay đổi giáo viên chủ nhiệm gần đây
     */
    @Transactional(readOnly = true)
    public Page<ClassroomTeacher> getRecentChanges(int days, Pageable pageable) {
        LocalDate fromDate = LocalDate.now().minusDays(days);
        return classroomTeacherRepository.findRecentChanges(fromDate, pageable);
    }

    /**
     * Kiểm tra xem giáo viên có đang chủ nhiệm lớp nào không
     */
    @Transactional(readOnly = true)
    public boolean isTeacherCurrentlyAssigned(Long teacherId) {
        Teacher teacher = teacherRepository.findById(teacherId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy giáo viên"));
        return classroomTeacherRepository.existsByTeacherAndEndDateIsNull(teacher);
    }

    /**
     * Kiểm tra xem lớp có giáo viên chủ nhiệm hiện tại không
     */
    @Transactional(readOnly = true)
    public boolean hasCurrentHomeRoomTeacher(Long classroomId) {
        Classroom classroom = classroomRepository.findById(classroomId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy lớp học"));
        return classroomTeacherRepository.existsByClassroomAndEndDateIsNull(classroom);
    }

    /**
     * Kiểm tra xem giáo viên có đang là chủ nhiệm hiện tại không
     */
    @Transactional(readOnly = true)
    public boolean isCurrentHomeRoomTeacher(Long teacherId) {
        Teacher teacher = teacherRepository.findById(teacherId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy giáo viên"));
        return classroomTeacherRepository.existsByTeacherAndEndDateIsNull(teacher);
    }
}