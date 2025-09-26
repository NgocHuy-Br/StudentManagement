package com.StudentManagement.controller;

import com.StudentManagement.entity.Score;
import com.StudentManagement.entity.Subject;
import com.StudentManagement.entity.Teacher;
import com.StudentManagement.entity.TeacherSubject;
import com.StudentManagement.entity.User;
import com.StudentManagement.repository.ScoreRepository;
import com.StudentManagement.repository.SubjectRepository;
import com.StudentManagement.repository.TeacherRepository;
import com.StudentManagement.repository.TeacherSubjectRepository;
import com.StudentManagement.repository.UserRepository;
import org.springframework.data.domain.*;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequestMapping("/teacher")
public class TeacherController {

    private final UserRepository userRepository;
    private final TeacherRepository teacherRepository;
    private final TeacherSubjectRepository teacherSubjectRepository;
    private final ScoreRepository scoreRepository;
    private final SubjectRepository subjectRepository;

    public TeacherController(UserRepository userRepository,
            TeacherRepository teacherRepository,
            TeacherSubjectRepository teacherSubjectRepository,
            ScoreRepository scoreRepository,
            SubjectRepository subjectRepository) {
        this.userRepository = userRepository;
        this.teacherRepository = teacherRepository;
        this.teacherSubjectRepository = teacherSubjectRepository;
        this.scoreRepository = scoreRepository;
        this.subjectRepository = subjectRepository;
    }

    private void addUserInfo(Authentication auth, Model model) {
        String firstName = "Giáo viên";
        if (auth != null) {
            var u = userRepository.findByUsername(auth.getName()).orElse(null);
            if (u != null) {
                firstName = (u.getFname() != null && !u.getFname().isBlank()) ? u.getFname() : u.getUsername();
            }
        }
        model.addAttribute("firstName", firstName);
        model.addAttribute("roleDisplay", "Giáo viên");
    }

    private Teacher getCurrentTeacher(Authentication auth) {
        if (auth == null)
            return null;
        User user = userRepository.findByUsername(auth.getName()).orElse(null);
        if (user == null)
            return null;
        return teacherRepository.findByUser(user).orElse(null);
    }

    @GetMapping
    public String index(Authentication auth, Model model) {
        addUserInfo(auth, model);
        model.addAttribute("activeTab", "dashboard");

        Teacher teacher = getCurrentTeacher(auth);
        if (teacher != null) {
            // Lấy danh sách môn học mà giáo viên phụ trách
            List<TeacherSubject> teacherSubjects = teacherSubjectRepository.findByTeacher(teacher);
            model.addAttribute("teacherSubjects", teacherSubjects);
        }

        return "teacher/teacher-dashboard";
    }

    // Xem danh sách môn học phụ trách
    @GetMapping("/subjects")
    public String mySubjects(Authentication auth, Model model) {
        addUserInfo(auth, model);
        model.addAttribute("activeTab", "subjects");

        Teacher teacher = getCurrentTeacher(auth);
        if (teacher != null) {
            List<TeacherSubject> teacherSubjects = teacherSubjectRepository.findByTeacher(teacher);
            model.addAttribute("teacherSubjects", teacherSubjects);
        }

        return "teacher/subjects";
    }

    // Xem danh sách sinh viên của môn học
    @GetMapping("/subjects/{subjectId}/students")
    public String subjectStudents(@PathVariable Long subjectId,
            Authentication auth,
            Model model,
            @RequestParam(defaultValue = "") String semester,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        addUserInfo(auth, model);
        model.addAttribute("activeTab", "subjects");

        Teacher teacher = getCurrentTeacher(auth);
        Subject subject = subjectRepository.findById(subjectId).orElse(null);

        if (teacher == null || subject == null) {
            return "redirect:/teacher/subjects";
        }

        // Kiểm tra xem giáo viên có dạy môn này không
        boolean isTeaching = teacherSubjectRepository.existsByTeacherAndSubjectAndSemester(teacher, subject, semester);
        if (!isTeaching) {
            return "redirect:/teacher/subjects";
        }

        Pageable pageable = PageRequest.of(Math.max(page, 0), Math.max(size, 1));
        Page<Score> scores = semester.isEmpty()
                ? scoreRepository.findBySubject(subject, pageable)
                : scoreRepository.findBySubjectAndSemester(subject, semester, pageable);

        model.addAttribute("subject", subject);
        model.addAttribute("scores", scores);
        model.addAttribute("semester", semester);
        return "teacher/subject-students";
    }

    // Cập nhật điểm sinh viên
    @PostMapping("/scores/{scoreId}")
    public String updateScore(@PathVariable Long scoreId,
            @RequestParam Float avgScore,
            @RequestParam(required = false) String notes,
            Authentication auth,
            RedirectAttributes ra) {

        Teacher teacher = getCurrentTeacher(auth);
        if (teacher == null) {
            ra.addFlashAttribute("error", "Không tìm thấy thông tin giáo viên.");
            return "redirect:/teacher";
        }

        Score score = scoreRepository.findById(scoreId).orElse(null);
        if (score == null) {
            ra.addFlashAttribute("error", "Không tìm thấy điểm.");
            return "redirect:/teacher/subjects";
        }

        // Kiểm tra xem giáo viên có quyền sửa điểm môn này không
        boolean canEdit = teacherSubjectRepository.existsByTeacherAndSubjectAndSemester(
                teacher, score.getSubject(), score.getSemester());

        if (!canEdit) {
            ra.addFlashAttribute("error", "Bạn không có quyền sửa điểm môn học này.");
            return "redirect:/teacher/subjects";
        }

        if (avgScore < 0 || avgScore > 10) {
            ra.addFlashAttribute("error", "Điểm phải nằm trong khoảng từ 0 đến 10.");
            return "redirect:/teacher/subjects/" + score.getSubject().getId() + "/students?semester="
                    + score.getSemester();
        }

        score.setAvgScore(avgScore);
        score.setNotes(notes);
        scoreRepository.save(score);

        ra.addFlashAttribute("success", "Đã cập nhật điểm cho sinh viên " + score.getStudent().getUser().getUsername());
        return "redirect:/teacher/subjects/" + score.getSubject().getId() + "/students?semester=" + score.getSemester();
    }
}