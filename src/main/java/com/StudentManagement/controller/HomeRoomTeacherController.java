package com.StudentManagement.controller;

import com.StudentManagement.entity.*;
import com.StudentManagement.repository.*;
import org.springframework.data.domain.*;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.ArrayList;

@Controller
@RequestMapping("/teacher")
public class HomeRoomTeacherController {

    private final UserRepository userRepository;
    private final TeacherRepository teacherRepository;
    private final ClassroomRepository classroomRepository;
    private final StudentRepository studentRepository;
    private final ScoreRepository scoreRepository;
    private final SubjectRepository subjectRepository;

    public HomeRoomTeacherController(
            UserRepository userRepository,
            TeacherRepository teacherRepository,
            ClassroomRepository classroomRepository,
            StudentRepository studentRepository,
            ScoreRepository scoreRepository,
            SubjectRepository subjectRepository) {
        this.userRepository = userRepository;
        this.teacherRepository = teacherRepository;
        this.classroomRepository = classroomRepository;
        this.studentRepository = studentRepository;
        this.scoreRepository = scoreRepository;
        this.subjectRepository = subjectRepository;
    }

    /**
     * Lấy thông tin giáo viên hiện tại từ Authentication
     */
    private Teacher getCurrentTeacher(Authentication auth) {
        if (auth == null)
            return null;

        User user = userRepository.findByUsername(auth.getName()).orElse(null);
        if (user == null || user.getRole() != User.Role.TEACHER)
            return null;

        return teacherRepository.findByUser(user).orElse(null);
    }

    /**
     * Dashboard cho giáo viên chủ nhiệm
     */
    @GetMapping
    public String dashboard(Authentication auth, Model model) {
        Teacher teacher = getCurrentTeacher(auth);
        if (teacher == null) {
            return "redirect:/auth/login";
        }

        // Lấy các lớp mà giáo viên đang chủ nhiệm (dùng direct reference)
        List<Classroom> currentClassrooms = classroomRepository.findByHomeRoomTeacher(teacher);

        model.addAttribute("teacher", teacher);
        model.addAttribute("classrooms", currentClassrooms);
        model.addAttribute("activeTab", "dashboard");
        model.addAttribute("firstName", teacher.getUser().getFname());
        model.addAttribute("roleDisplay", "Giáo viên");

        return "teacher/dashboard_clean";
    }

    /**
     * Hiển thị tất cả lớp sinh viên mà giáo viên làm chủ nhiệm
     */
    @GetMapping("/classes")
    public String viewAllClasses(Authentication auth, Model model) {
        Teacher teacher = getCurrentTeacher(auth);
        if (teacher == null) {
            return "redirect:/auth/login";
        }

        System.out.println("=== DEBUG INFO ===");
        System.out.println("Teacher ID: " + teacher.getId());
        System.out.println("Teacher Code: " + teacher.getTeacherCode());
        System.out.println("Username: " + auth.getName());

        // Lấy các lớp mà giáo viên đang chủ nhiệm (dùng direct reference thay vì
        // ClassroomTeacher table)
        List<Classroom> currentClassrooms = classroomRepository.findByHomeRoomTeacher(teacher);

        System.out.println("Current classrooms count: " + currentClassrooms.size());
        for (Classroom classroom : currentClassrooms) {
            System.out.println("Classroom: " + classroom.getClassCode() +
                    " - Teacher ID: "
                    + (classroom.getHomeRoomTeacher() != null ? classroom.getHomeRoomTeacher().getId() : "null"));
        }

        // Lấy tất cả sinh viên của các lớp này
        List<Student> allStudents = new ArrayList<>();
        for (Classroom classroom : currentClassrooms) {
            List<Student> studentsInClass = studentRepository.findByClassroomId(classroom.getId());
            allStudents.addAll(studentsInClass);
            System.out.println("Class " + classroom.getClassCode() + " has " + studentsInClass.size() + " students");
        }

        model.addAttribute("teacher", teacher);
        model.addAttribute("classrooms", currentClassrooms);
        model.addAttribute("allStudents", allStudents);
        model.addAttribute("activeTab", "classes");
        model.addAttribute("firstName", teacher.getUser().getFname());
        model.addAttribute("roleDisplay", "Giáo viên");

        return "teacher/classes";
    }

    /**
     * Xem danh sách học sinh trong lớp
     */
    @GetMapping("/classroom/{classroomId}/students")
    public String viewStudents(
            @PathVariable Long classroomId,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size,
            @RequestParam(required = false) String sort,
            @RequestParam(required = false) String dir,
            Authentication auth,
            Model model) {

        Teacher teacher = getCurrentTeacher(auth);
        if (teacher == null) {
            return "redirect:/auth/login";
        }

        Classroom classroom = classroomRepository.findById(classroomId).orElse(null);
        if (classroom == null) {
            return "redirect:/homeroom";
        }

        // Kiểm tra xem giáo viên có phải chủ nhiệm lớp này không
        boolean isHomeRoomTeacher = classroomRepository.findByHomeRoomTeacher(teacher)
                .stream().anyMatch(c -> c.getId().equals(classroomId));
        if (!isHomeRoomTeacher) {
            return "redirect:/homeroom";
        }

        // Tạo Pageable với sắp xếp
        Pageable pageable;
        if (sort != null && !sort.isEmpty()) {
            Sort.Direction direction = "desc".equalsIgnoreCase(dir) ? Sort.Direction.DESC : Sort.Direction.ASC;
            pageable = PageRequest.of(Math.max(page, 0), Math.max(size, 1), Sort.by(direction, sort));
        } else {
            pageable = PageRequest.of(Math.max(page, 0), Math.max(size, 1));
        }

        Page<Student> students = studentRepository.findByClassroomId(classroomId, pageable);

        model.addAttribute("classroom", classroom);
        model.addAttribute("students", students);
        model.addAttribute("teacher", teacher);

        return "teacher/students";
    }

    /**
     * Xem và quản lý điểm của học sinh
     */
    @GetMapping("/classroom/{classroomId}/scores")
    public String viewScores(
            @PathVariable Long classroomId,
            @RequestParam(required = false) String semester,
            @RequestParam(required = false) Long subjectId,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size,
            Authentication auth,
            Model model) {

        Teacher teacher = getCurrentTeacher(auth);
        if (teacher == null) {
            return "redirect:/auth/login";
        }

        Classroom classroom = classroomRepository.findById(classroomId).orElse(null);
        if (classroom == null) {
            return "redirect:/homeroom";
        }

        // Kiểm tra xem giáo viên có phải chủ nhiệm lớp này không
        boolean isHomeRoomTeacher = classroomRepository.findByHomeRoomTeacher(teacher)
                .stream().anyMatch(c -> c.getId().equals(classroomId));
        if (!isHomeRoomTeacher) {
            return "redirect:/homeroom";
        }

        // Lấy danh sách môn học
        List<Subject> subjects = subjectRepository.findAll();

        Pageable pageable = PageRequest.of(Math.max(page, 0), Math.max(size, 1));
        Page<Score> scores;

        if (subjectId != null && !semester.isEmpty()) {
            Subject subject = subjectRepository.findById(subjectId).orElse(null);
            if (subject != null) {
                scores = scoreRepository.findBySubjectAndSemester(subject, semester, pageable);
            } else {
                scores = scoreRepository.findByClassroomId(classroomId, pageable);
            }
        } else if (subjectId != null) {
            Subject subject = subjectRepository.findById(subjectId).orElse(null);
            if (subject != null) {
                scores = scoreRepository.findBySubject(subject, pageable);
            } else {
                scores = scoreRepository.findByClassroomId(classroomId, pageable);
            }
        } else if (!semester.isEmpty()) {
            scores = scoreRepository.findByClassroomIdAndSemester(classroomId, semester, pageable);
        } else {
            scores = scoreRepository.findByClassroomId(classroomId, pageable);
        }

        model.addAttribute("classroom", classroom);
        model.addAttribute("scores", scores);
        model.addAttribute("subjects", subjects);
        model.addAttribute("selectedSubjectId", subjectId);
        model.addAttribute("selectedSemester", semester);
        model.addAttribute("teacher", teacher);

        return "teacher/scores";
    }

    /**
     * Cập nhật điểm số
     */
    @PostMapping("/scores/{scoreId}")
    public String updateScore(
            @PathVariable Long scoreId,
            @RequestParam Float avgScore,
            @RequestParam(required = false) String notes,
            Authentication auth,
            RedirectAttributes ra) {

        Teacher teacher = getCurrentTeacher(auth);
        if (teacher == null) {
            ra.addFlashAttribute("error", "Không tìm thấy thông tin giáo viên.");
            return "redirect:/homeroom";
        }

        Score score = scoreRepository.findById(scoreId).orElse(null);
        if (score == null) {
            ra.addFlashAttribute("error", "Không tìm thấy điểm.");
            return "redirect:/homeroom";
        }

        // Kiểm tra quyền chỉnh sửa - giáo viên phải là chủ nhiệm của lớp có học sinh
        // này
        Student student = score.getStudent();
        boolean isHomeRoomTeacher = classroomRepository.findByHomeRoomTeacher(teacher)
                .stream().anyMatch(c -> c.getId().equals(student.getClassroom().getId()));
        if (!isHomeRoomTeacher) {
            ra.addFlashAttribute("error", "Bạn không có quyền sửa điểm của học sinh này.");
            return "redirect:/homeroom";
        }

        if (avgScore < 0 || avgScore > 10) {
            ra.addFlashAttribute("error", "Điểm phải nằm trong khoảng từ 0 đến 10.");
            return "redirect:/homeroom/classroom/" + student.getClassroom().getId() + "/scores";
        }

        score.setAvgScore(avgScore);
        score.setNotes(notes);
        scoreRepository.save(score);

        ra.addFlashAttribute("success", "Cập nhật điểm thành công.");
        return "redirect:/homeroom/classroom/" + student.getClassroom().getId() + "/scores";
    }

    /**
     * Xem chi tiết sinh viên (MVC approach)
     */
    @GetMapping("/student/{studentId}/detail")
    public String viewStudentDetail(@PathVariable Long studentId, Authentication auth, Model model) {
        Teacher teacher = getCurrentTeacher(auth);
        if (teacher == null) {
            return "redirect:/login";
        }

        Student student = studentRepository.findById(studentId).orElse(null);
        if (student == null) {
            return "redirect:/teacher/classes";
        }

        // Kiểm tra quyền truy cập
        boolean isHomeRoomTeacher = classroomRepository.findByHomeRoomTeacher(teacher)
                .stream().anyMatch(c -> c.getId().equals(student.getClassroom().getId()));

        if (!isHomeRoomTeacher) {
            return "redirect:/teacher/classes";
        }

        model.addAttribute("student", student);
        model.addAttribute("teacher", teacher);
        model.addAttribute("activeTab", "classes");
        addUserInfo(auth, model);

        return "teacher/student-detail";
    }
}