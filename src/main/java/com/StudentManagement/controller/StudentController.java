package com.StudentManagement.controller;

import com.StudentManagement.entity.Score;
import com.StudentManagement.entity.Student;
import com.StudentManagement.entity.Subject;
import com.StudentManagement.entity.User;
import com.StudentManagement.repository.ScoreRepository;
import com.StudentManagement.repository.StudentRepository;
import com.StudentManagement.repository.SubjectRepository;
import com.StudentManagement.repository.UserRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.*;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/student")
public class StudentController {

    private final UserRepository userRepository;
    private final StudentRepository studentRepository;
    private final ScoreRepository scoreRepository;
    private final SubjectRepository subjectRepository;
    private final PasswordEncoder passwordEncoder;

    public StudentController(UserRepository userRepository,
            StudentRepository studentRepository,
            ScoreRepository scoreRepository,
            SubjectRepository subjectRepository,
            PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.studentRepository = studentRepository;
        this.scoreRepository = scoreRepository;
        this.subjectRepository = subjectRepository;
        this.passwordEncoder = passwordEncoder;
    }

    private void addUserInfo(Authentication auth, Model model) {
        String firstName = "Sinh viên";
        if (auth != null) {
            var u = userRepository.findByUsername(auth.getName()).orElse(null);
            if (u != null) {
                firstName = (u.getFname() != null && !u.getFname().isBlank()) ? u.getFname() : u.getUsername();
            }
        }
        model.addAttribute("firstName", firstName);
        model.addAttribute("roleDisplay", "Sinh viên");
    }

    private Student getCurrentStudent(Authentication auth) {
        if (auth == null)
            return null;
        User user = userRepository.findByUsername(auth.getName()).orElse(null);
        if (user == null)
            return null;
        return studentRepository.findByUser(user).orElse(null);
    }

    @GetMapping
    public String index(Authentication auth, Model model) {
        addUserInfo(auth, model);
        model.addAttribute("activeTab", "dashboard");

        Student student = getCurrentStudent(auth);
        if (student != null) {
            // Tính GPA
            Double gpa = scoreRepository.calculateGPAForStudent(student);
            model.addAttribute("student", student);
            model.addAttribute("gpa", gpa != null ? Math.round(gpa * 100.0) / 100.0 : 0.0);

            // Tính tổng tín chỉ tích lũy (chỉ tính môn đạt)
            Integer totalCredits = scoreRepository.calculateTotalCreditsForStudent(student);
            model.addAttribute("totalCredits", totalCredits != null ? totalCredits : 0);
        }

        return "student/dashboard";
    }

    // Xem danh sách môn học của ngành
    @GetMapping("/subjects")
    public String mySubjects(Authentication auth, Model model) {
        addUserInfo(auth, model);
        model.addAttribute("activeTab", "subjects");

        Student student = getCurrentStudent(auth);
        if (student != null && student.getMajor() != null) {
            List<Subject> subjects = subjectRepository.findByMajorId(student.getMajor().getId());
            List<Score> scores = scoreRepository.findByStudent(student);
            model.addAttribute("subjects", subjects);
            model.addAttribute("scores", scores);
            model.addAttribute("student", student);
        }

        return "student/subjects";
    }

    // Xem điểm chi tiết
    @GetMapping("/scores")
    public String myScores(Authentication auth, Model model,
            @RequestParam(required = false) Long subjectId) {
        addUserInfo(auth, model);
        model.addAttribute("activeTab", "scores");

        Student student = getCurrentStudent(auth);
        if (student != null) {
            List<Score> allScores = scoreRepository.findByStudent(student);

            // Lọc theo subject nếu có
            List<Score> filteredScores = allScores.stream()
                    .filter(score -> subjectId == null || score.getSubject().getId().equals(subjectId))
                    .collect(Collectors.toList());

            // Sắp xếp điểm theo mã môn
            filteredScores.sort(Comparator.comparing(s -> s.getSubject().getSubjectCode()));

            // Tính GPA
            Double gpa = scoreRepository.calculateGPAForStudent(student);

            // Tính tín chỉ tích lũy và chưa đạt
            Integer totalCredits = scoreRepository.calculateTotalCreditsForStudent(student);
            Integer failedCredits = scoreRepository.calculateFailedCreditsForStudent(student);

            // Lấy danh sách môn học để filter
            List<Subject> subjects = subjectRepository.findByMajorId(student.getMajor().getId());

            model.addAttribute("student", student);
            model.addAttribute("scores", filteredScores);
            model.addAttribute("gpa", gpa != null ? Math.round(gpa * 100.0) / 100.0 : 0.0);
            model.addAttribute("totalCredits", totalCredits != null ? totalCredits : 0);
            model.addAttribute("failedCredits", failedCredits != null ? failedCredits : 0);
            model.addAttribute("subjects", subjects);
        }

        return "student/scores_new";
    }

    @PostMapping("/change-password")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> changePassword(
            @RequestParam String currentPassword,
            @RequestParam String newPassword,
            Authentication authentication) {
        Map<String, Object> response = new HashMap<>();

        try {
            // Lấy thông tin user hiện tại
            String username = authentication.getName();
            Optional<User> userOpt = userRepository.findByUsername(username);

            if (!userOpt.isPresent()) {
                response.put("success", false);
                response.put("message", "Không tìm thấy người dùng");
                return ResponseEntity.badRequest().body(response);
            }

            User user = userOpt.get();

            // Kiểm tra mật khẩu hiện tại
            if (!passwordEncoder.matches(currentPassword, user.getPassword())) {
                response.put("success", false);
                response.put("message", "Mật khẩu hiện tại không đúng");
                return ResponseEntity.badRequest().body(response);
            }

            // Kiểm tra mật khẩu mới
            if (newPassword.length() < 6) {
                response.put("success", false);
                response.put("message", "Mật khẩu mới phải có ít nhất 6 ký tự");
                return ResponseEntity.badRequest().body(response);
            }

            // Cập nhật mật khẩu mới
            user.setPassword(passwordEncoder.encode(newPassword));
            userRepository.save(user);

            response.put("success", true);
            response.put("message", "Đổi mật khẩu thành công");
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Có lỗi xảy ra: " + e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }
}