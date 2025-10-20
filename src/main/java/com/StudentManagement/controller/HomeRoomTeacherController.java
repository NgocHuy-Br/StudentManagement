package com.StudentManagement.controller;

import com.StudentManagement.entity.*;
import com.StudentManagement.repository.*;
import com.StudentManagement.service.PdfService;
import org.springframework.data.domain.*;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.ArrayList;
import java.util.Optional;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/teacher")
public class HomeRoomTeacherController {

    private final UserRepository userRepository;
    private final TeacherRepository teacherRepository;
    private final ClassroomRepository classroomRepository;
    private final StudentRepository studentRepository;
    private final ScoreRepository scoreRepository;
    private final SubjectRepository subjectRepository;
    private final PdfService pdfService;
    private final PasswordEncoder passwordEncoder;

    public HomeRoomTeacherController(
            UserRepository userRepository,
            TeacherRepository teacherRepository,
            ClassroomRepository classroomRepository,
            StudentRepository studentRepository,
            ScoreRepository scoreRepository,
            SubjectRepository subjectRepository,
            PdfService pdfService,
            PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.teacherRepository = teacherRepository;
        this.classroomRepository = classroomRepository;
        this.studentRepository = studentRepository;
        this.scoreRepository = scoreRepository;
        this.subjectRepository = subjectRepository;
        this.pdfService = pdfService;
        this.passwordEncoder = passwordEncoder;
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

        // Lấy các lớp mà giáo viên được phân công
        List<Classroom> assignedClasses = classroomRepository.findByHomeRoomTeacher(teacher);

        // Lấy danh sách môn học
        List<Subject> subjects = subjectRepository.findAll();

        model.addAttribute("teacher", teacher);
        model.addAttribute("assignedClasses", assignedClasses);
        model.addAttribute("subjects", subjects);
        model.addAttribute("activeTab", "dashboard");
        model.addAttribute("firstName", teacher.getUser().getFname());
        model.addAttribute("roleDisplay", "Giáo viên");

        return "teacher/dashboard_redesigned";
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
        model.addAttribute("assignedClasses", currentClassrooms); // Đổi từ "classrooms" thành "assignedClasses"
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

        // Lấy danh sách sinh viên trong lớp
        List<Student> students = studentRepository.findByClassroomId(classroomId);

        Pageable pageable = PageRequest.of(Math.max(page, 0), Math.max(size, 1));
        Page<Score> scores;

        if (subjectId != null) {
            Subject subject = subjectRepository.findById(subjectId).orElse(null);
            if (subject != null) {
                scores = scoreRepository.findBySubject(subject, pageable);
            } else {
                scores = scoreRepository.findByClassroomId(classroomId, pageable);
            }
        } else {
            scores = scoreRepository.findByClassroomId(classroomId, pageable);
        }

        model.addAttribute("classroom", classroom);
        model.addAttribute("students", students);
        model.addAttribute("scores", scores);
        model.addAttribute("subjects", subjects);
        model.addAttribute("selectedSubjectId", subjectId);
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
        model.addAttribute("firstName", teacher.getUser().getFname());
        model.addAttribute("roleDisplay", "Giáo viên");

        return "teacher/student-detail";
    }

    /**
     * Tab Điểm sinh viên - Quản lý điểm
     */
    @GetMapping("/scores")
    public String manageScores(Authentication auth, Model model,
            @RequestParam(required = false) Long classroomId,
            @RequestParam(required = false) Long subjectId,
            @RequestParam(required = false) String search) {

        Teacher teacher = getCurrentTeacher(auth);
        if (teacher == null) {
            return "redirect:/auth/login";
        }

        // Lấy các lớp mà giáo viên chủ nhiệm
        List<Classroom> assignedClasses = classroomRepository.findByHomeRoomTeacher(teacher);

        // Khởi tạo các list
        List<Subject> subjects = new ArrayList<>();
        List<Student> students = new ArrayList<>();
        List<Score> scores = new ArrayList<>();

        // Chỉ xử lý khi đã chọn lớp
        if (classroomId != null) {
            // Kiểm tra quyền truy cập lớp
            boolean hasAccess = assignedClasses.stream()
                    .anyMatch(c -> c.getId().equals(classroomId));

            if (hasAccess) {
                // Lấy môn học của lớp đã chọn
                Classroom selectedClassroom = classroomRepository.findById(classroomId).orElse(null);
                if (selectedClassroom != null && selectedClassroom.getMajor() != null) {
                    subjects = selectedClassroom.getMajor().getSubjects();
                }

                // Lấy sinh viên của lớp
                students = studentRepository.findByClassroomId(classroomId);

                if (subjectId != null) {
                    // Lọc điểm theo môn học cụ thể
                    scores = scoreRepository.findByStudentClassroomIdAndSubjectId(classroomId, subjectId);
                } else {
                    // Lấy tất cả điểm của lớp (tất cả môn học)
                    scores = scoreRepository.findAllByClassroomId(classroomId);
                }

                // Lọc sinh viên theo tìm kiếm nếu có
                if (search != null && !search.trim().isEmpty()) {
                    String searchTerm = search.trim().toLowerCase();
                    students = students.stream()
                            .filter(student -> student.getUser().getUsername().toLowerCase().contains(searchTerm) ||
                                    (student.getUser().getFname() + " " + student.getUser().getLname()).toLowerCase()
                                            .contains(searchTerm))
                            .collect(Collectors.toList());

                    // Lọc điểm tương ứng với sinh viên đã lọc
                    List<Long> filteredStudentIds = students.stream()
                            .map(Student::getId)
                            .collect(Collectors.toList());

                    scores = scores.stream()
                            .filter(score -> filteredStudentIds.contains(score.getStudent().getId()))
                            .collect(Collectors.toList());
                }
            }
        }

        model.addAttribute("teacher", teacher);
        model.addAttribute("assignedClasses", assignedClasses);
        model.addAttribute("subjects", subjects);
        model.addAttribute("students", students);
        model.addAttribute("scores", scores);
        model.addAttribute("selectedClassroomId", classroomId);
        model.addAttribute("selectedSubjectId", subjectId);
        model.addAttribute("search", search);
        model.addAttribute("activeTab", "scores");
        model.addAttribute("firstName", teacher.getUser().getFname());
        model.addAttribute("roleDisplay", "Giáo viên");

        return "teacher/scores";
    }

    /**
     * Cập nhật điểm sinh viên
     */
    @PostMapping("/scores/update")
    public String updateScore(@RequestParam Long studentId,
            @RequestParam Long subjectId,
            @RequestParam(required = false) Double attendanceScore,
            @RequestParam(required = false) Double midtermScore,
            @RequestParam(required = false) Double finalScore,
            @RequestParam(required = false) String notes,
            Authentication auth,
            RedirectAttributes ra) {

        Teacher teacher = getCurrentTeacher(auth);
        if (teacher == null) {
            return "redirect:/auth/login";
        }

        Student student = studentRepository.findById(studentId).orElse(null);
        Subject subject = subjectRepository.findById(subjectId).orElse(null);

        if (student == null || subject == null) {
            ra.addFlashAttribute("error", "Không tìm thấy sinh viên hoặc môn học.");
            return "redirect:/teacher/scores";
        }

        // Kiểm tra quyền truy cập
        boolean hasAccess = classroomRepository.findByHomeRoomTeacher(teacher)
                .stream().anyMatch(c -> c.getId().equals(student.getClassroom().getId()));

        if (!hasAccess) {
            ra.addFlashAttribute("error", "Bạn không có quyền cập nhật điểm cho sinh viên này.");
            return "redirect:/teacher/scores";
        }

        // Tìm hoặc tạo điểm
        Score score = scoreRepository.findByStudentAndSubject(student, subject)
                .orElse(new Score());

        if (score.getId() == null) {
            score.setStudent(student);
            score.setSubject(subject);
        }

        // Cập nhật điểm
        if (attendanceScore != null) {
            score.setAttendanceScore(attendanceScore.floatValue());
        }
        if (midtermScore != null) {
            score.setMidtermScore(midtermScore.floatValue());
        }
        if (finalScore != null) {
            score.setFinalScore(finalScore.floatValue());
        }
        score.setNotes(notes);

        // Tính điểm trung bình (10% chuyên cần + 30% giữa kỳ + 60% cuối kỳ)
        Float attendance = score.getAttendanceScore();
        Float midterm = score.getMidtermScore();
        Float finalS = score.getFinalScore();

        if (attendance != null && midterm != null && finalS != null) {
            double avgScore = attendance * 0.1 + midterm * 0.3 + finalS * 0.6;
            score.setAvgScore((float) avgScore);
        } else if (midterm != null && finalS != null) {
            // Nếu chưa có điểm chuyên cần, tính theo công thức cũ
            double avgScore = midterm * 0.4 + finalS * 0.6;
            score.setAvgScore((float) avgScore);
        }

        scoreRepository.save(score);

        ra.addFlashAttribute("success", "Cập nhật điểm thành công.");
        return "redirect:/teacher/scores?classroomId=" + student.getClassroom().getId()
                + "&subjectId=" + subjectId;
    }

    /**
     * Xóa điểm sinh viên
     */
    @PostMapping("/scores/delete")
    public String deleteScore(@RequestParam Long scoreId,
            Authentication auth,
            RedirectAttributes ra) {

        Teacher teacher = getCurrentTeacher(auth);
        if (teacher == null) {
            return "redirect:/auth/login";
        }

        Score score = scoreRepository.findById(scoreId).orElse(null);
        if (score == null) {
            ra.addFlashAttribute("error", "Không tìm thấy điểm để xóa.");
            return "redirect:/teacher/scores";
        }

        // Kiểm tra quyền truy cập
        boolean hasAccess = classroomRepository.findByHomeRoomTeacher(teacher)
                .stream().anyMatch(c -> c.getId().equals(score.getStudent().getClassroom().getId()));

        if (!hasAccess) {
            ra.addFlashAttribute("error", "Bạn không có quyền xóa điểm này.");
            return "redirect:/teacher/scores";
        }

        scoreRepository.delete(score);
        ra.addFlashAttribute("success", "Xóa điểm thành công.");

        return "redirect:/teacher/scores";
    }

    /**
     * Đổi mật khẩu cho giáo viên
     */
    @PostMapping("/change-password")
    @Transactional
    public String changePassword(@RequestParam String currentPassword,
            @RequestParam String newPassword,
            @RequestParam String confirmPassword,
            Authentication auth,
            RedirectAttributes ra) {

        Teacher teacher = getCurrentTeacher(auth);
        if (teacher == null) {
            return "redirect:/auth/login";
        }

        // Validate input
        if (newPassword == null || newPassword.trim().isEmpty()) {
            ra.addFlashAttribute("error", "Mật khẩu mới không được để trống.");
            return "redirect:/teacher";
        }

        if (newPassword.length() < 6) {
            ra.addFlashAttribute("error", "Mật khẩu mới phải có ít nhất 6 ký tự.");
            return "redirect:/teacher";
        }

        if (!newPassword.equals(confirmPassword)) {
            ra.addFlashAttribute("error", "Xác nhận mật khẩu không khớp.");
            return "redirect:/teacher";
        }

        // Verify current password
        User user = teacher.getUser();
        if (!passwordEncoder.matches(currentPassword, user.getPassword())) {
            ra.addFlashAttribute("error", "Mật khẩu hiện tại không đúng.");
            return "redirect:/teacher";
        }

        // Update password
        user.setPassword(passwordEncoder.encode(newPassword));
        userRepository.save(user);

        ra.addFlashAttribute("success", "Đổi mật khẩu thành công.");
        return "redirect:/teacher";
    }

    /**
     * Export điểm lớp ra PDF (Giáo viên chủ nhiệm)
     */
    @GetMapping("/classroom/{classroomId}/scores/export-pdf")
    public ResponseEntity<byte[]> exportClassScoresPdf(
            @PathVariable Long classroomId,
            @RequestParam(required = false) Long subjectId,
            Authentication auth) {

        try {
            // Kiểm tra quyền truy cập
            Teacher teacher = getCurrentTeacher(auth);
            if (teacher == null) {
                return ResponseEntity.badRequest().build();
            }

            // Kiểm tra lớp có thuộc quyền quản lý của giáo viên không
            Optional<Classroom> classroomOpt = classroomRepository.findById(classroomId);
            if (classroomOpt.isEmpty()) {
                return ResponseEntity.notFound().build();
            }

            Classroom classroom = classroomOpt.get();
            // Kiểm tra giáo viên có phải chủ nhiệm của lớp này không
            ClassroomTeacher currentTeacherRecord = classroom.getCurrentHomeRoomTeacherRecord();
            if (currentTeacherRecord == null || !currentTeacherRecord.getTeacher().getId().equals(teacher.getId())) {
                return ResponseEntity.badRequest().build();
            }

            // Lấy điểm của lớp - tạo tất cả combination sinh viên x môn học
            List<Score> scores = new ArrayList<>();
            List<Student> students = studentRepository.findByClassroomId(classroomId);
            List<Subject> subjects = new ArrayList<>();

            if (classroom.getMajor() != null) {
                subjects = classroom.getMajor().getSubjects();
            }

            // Tạo tất cả các combination sinh viên x môn học
            for (Student student : students) {
                if (subjectId != null) {
                    // Chỉ một môn học được chọn
                    Optional<Subject> subjectOpt = subjectRepository.findById(subjectId);
                    if (subjectOpt.isPresent()) {
                        Subject subject = subjectOpt.get();
                        // Tìm score thực tế hoặc tạo score ảo
                        Optional<Score> existingScoreOpt = scoreRepository
                                .findByStudentIdAndSubjectId(student.getId(), subjectId);

                        if (existingScoreOpt.isPresent()) {
                            scores.add(existingScoreOpt.get());
                        } else {
                            // Tạo Score ảo với tất cả điểm null
                            Score virtualScore = new Score();
                            virtualScore.setStudent(student);
                            virtualScore.setSubject(subject);
                            virtualScore.setAttendanceScore(null);
                            virtualScore.setMidtermScore(null);
                            virtualScore.setFinalScore(null);
                            virtualScore.setAvgScore(null);
                            scores.add(virtualScore);
                        }
                    }
                } else {
                    // Tất cả môn học của chuyên ngành
                    for (Subject subject : subjects) {
                        Optional<Score> existingScoreOpt = scoreRepository
                                .findByStudentIdAndSubjectId(student.getId(), subject.getId());

                        if (existingScoreOpt.isPresent()) {
                            scores.add(existingScoreOpt.get());
                        } else {
                            // Tạo Score ảo với tất cả điểm null
                            Score virtualScore = new Score();
                            virtualScore.setStudent(student);
                            virtualScore.setSubject(subject);
                            virtualScore.setAttendanceScore(null);
                            virtualScore.setMidtermScore(null);
                            virtualScore.setFinalScore(null);
                            virtualScore.setAvgScore(null);
                            scores.add(virtualScore);
                        }
                    }
                }
            }

            // Lấy thông tin lớp và môn học
            String classroomName = classroom.getClassCode();
            String subjectName = null;
            if (subjectId != null) {
                Optional<Subject> subject = subjectRepository.findById(subjectId);
                if (subject.isPresent()) {
                    subjectName = subject.get().getSubjectName();
                }
            }

            // Thông tin người xuất
            String exportedBy = (teacher.getUser().getFname() + " " + teacher.getUser().getLname()).trim();
            if (exportedBy.isEmpty()) {
                exportedBy = teacher.getUser().getUsername();
            }

            // Tạo PDF
            byte[] pdfData = pdfService.generateScoresPdf(scores, classroomId, subjectId, classroomName, subjectName,
                    exportedBy, null);

            // Tạo tên file
            String fileName = "BangDiem_" + classroomName.replaceAll("[^\\w\\s-]", "").replaceAll("\\s+", "_");
            if (subjectName != null) {
                fileName += "_" + subjectName.replaceAll("[^\\w\\s-]", "").replaceAll("\\s+", "_");
            }
            fileName += "_" + java.time.LocalDate.now().toString() + ".pdf";

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_PDF);
            headers.setContentDispositionFormData("attachment", fileName);
            headers.setContentLength(pdfData.length);

            return ResponseEntity.ok()
                    .headers(headers)
                    .body(pdfData);

        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().build();
        }
    }
}