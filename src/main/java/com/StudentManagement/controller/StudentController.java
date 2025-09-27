package com.StudentManagement.controller;

import com.StudentManagement.entity.Score;
import com.StudentManagement.entity.Student;
import com.StudentManagement.entity.Subject;
import com.StudentManagement.entity.User;
import com.StudentManagement.repository.ScoreRepository;
import com.StudentManagement.repository.StudentRepository;
import com.StudentManagement.repository.SubjectRepository;
import com.StudentManagement.repository.UserRepository;
import org.springframework.security.core.Authentication;
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

    public StudentController(UserRepository userRepository,
            StudentRepository studentRepository,
            ScoreRepository scoreRepository,
            SubjectRepository subjectRepository) {
        this.userRepository = userRepository;
        this.studentRepository = studentRepository;
        this.scoreRepository = scoreRepository;
        this.subjectRepository = subjectRepository;
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

            // Lấy điểm gần nhất
            List<Score> recentScores = scoreRepository.findByStudent(student)
                    .stream()
                    .limit(5)
                    .collect(Collectors.toList());
            model.addAttribute("recentScores", recentScores);
        }

        return "student/student-dashboard";
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
            @RequestParam(required = false) Long subjectId,
            @RequestParam(required = false) Integer semester) {
        addUserInfo(auth, model);
        model.addAttribute("activeTab", "scores");

        Student student = getCurrentStudent(auth);
        if (student != null) {
            List<Score> allScores = scoreRepository.findByStudent(student);

            // Lọc theo subject và semester nếu có
            List<Score> filteredScores = allScores.stream()
                    .filter(score -> subjectId == null || score.getSubject().getId().equals(subjectId))
                    .filter(score -> semester == null || score.getSemester().equals(String.valueOf(semester)))
                    .collect(Collectors.toList());

            // Nhóm điểm theo học kỳ
            Map<String, List<Score>> scoresBySemester = filteredScores.stream()
                    .collect(Collectors.groupingBy(Score::getSemester));

            // Sắp xếp điểm trong mỗi học kỳ theo mã môn
            for (String sem : scoresBySemester.keySet()) {
                List<Score> semesterScores = scoresBySemester.get(sem);
                semesterScores.sort(Comparator.comparing(s -> s.getSubject().getSubjectCode()));
            }

            // Tính GPA
            Double gpa = scoreRepository.calculateGPAForStudent(student);

            // Lấy danh sách môn học và học kỳ để filter
            List<Subject> subjects = subjectRepository.findByMajorId(student.getMajor().getId());
            List<String> semesters = allScores.stream()
                    .map(Score::getSemester)
                    .distinct()
                    .sorted(Collections.reverseOrder())
                    .collect(Collectors.toList());

            model.addAttribute("student", student);
            model.addAttribute("scoresBySemester", scoresBySemester);
            model.addAttribute("gpa", gpa != null ? Math.round(gpa * 100.0) / 100.0 : 0.0);
            model.addAttribute("subjects", subjects);
            model.addAttribute("semesters", semesters);
        }

        return "student/scores";
    }

    // Xem bảng điểm theo học kỳ
    @GetMapping("/scores/semester/{semester}")
    public String scoresBySemester(@PathVariable String semester,
            Authentication auth,
            Model model) {
        addUserInfo(auth, model);
        model.addAttribute("activeTab", "scores");

        Student student = getCurrentStudent(auth);
        if (student != null) {
            List<Score> scores = scoreRepository.findByStudentAndSemester(student, semester);

            // Tính GPA học kỳ
            double totalWeightedScore = 0;
            int totalCredits = 0;

            for (Score score : scores) {
                if (score.getAvgScore() != null) {
                    totalWeightedScore += score.getAvgScore() * score.getSubject().getCredit();
                    totalCredits += score.getSubject().getCredit();
                }
            }

            double semesterGPA = totalCredits > 0 ? Math.round((totalWeightedScore / totalCredits) * 100.0) / 100.0
                    : 0.0;

            model.addAttribute("student", student);
            model.addAttribute("scores", scores);
            model.addAttribute("semester", semester);
            model.addAttribute("semesterGPA", semesterGPA);
        }

        return "student/semester-scores";
    }
}