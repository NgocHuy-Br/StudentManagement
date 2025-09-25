package com.StudentManagement.controller;

import com.StudentManagement.entity.Student;
import com.StudentManagement.entity.User;
import com.StudentManagement.repository.StudentRepository;
import com.StudentManagement.repository.UserRepository;
import org.springframework.data.domain.*;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/admin")
public class AdminController {

    private final UserRepository userRepository;
    private final StudentRepository studentRepository;
    private final PasswordEncoder passwordEncoder;

    public AdminController(UserRepository userRepository,
            StudentRepository studentRepository,
            PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.studentRepository = studentRepository;
        this.passwordEncoder = passwordEncoder;
    }

    private void addUserInfo(Authentication auth, Model model) {
        String firstName = "User";
        String roleDisplay = "Người dùng";
        if (auth != null) {
            var u = userRepository.findByUsername(auth.getName()).orElse(null);
            if (u != null) {
                firstName = (u.getFname() != null && !u.getFname().isBlank()) ? u.getFname() : u.getUsername();
                roleDisplay = switch (u.getRole()) {
                    case ADMIN -> "Quản trị viên";
                    case TEACHER -> "Giáo viên";
                    case STUDENT -> "Sinh viên";
                };
            }
        }
        model.addAttribute("firstName", firstName);
        model.addAttribute("roleDisplay", roleDisplay);
    }

    @GetMapping
    public String index(Authentication auth, Model model) {
        addUserInfo(auth, model);
        model.addAttribute("activeTab", "notice");
        return "admin/admin-dashboard";
    }

    // Danh sách sinh viên: dùng Page<Student> để có đủ field (lớp, khoa) và field
    // user
    @GetMapping("/students")
    public String students(Authentication auth,
            Model model,
            @RequestParam(defaultValue = "") String q,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(defaultValue = "user.username") String sort,
            @RequestParam(defaultValue = "asc") String dir) {
        addUserInfo(auth, model);
        model.addAttribute("activeTab", "students");

        Sort.Direction direction = "desc".equalsIgnoreCase(dir) ? Sort.Direction.DESC : Sort.Direction.ASC;
        // Cho phép sắp xếp theo cả trường của user và của student
        Pageable pageable = PageRequest.of(Math.max(page, 0), Math.max(size, 1), Sort.by(direction, sort));

        Page<Student> students = (q == null || q.isBlank())
                ? studentRepository.findAllWithUser(pageable)
                : studentRepository.search(q.trim(), pageable);

        model.addAttribute("page", students);
        model.addAttribute("q", q);
        model.addAttribute("sort", sort);
        model.addAttribute("dir", dir);
        return "admin/students";
    }

    // Thêm sinh viên: lưu User (mã hóa mật khẩu) + Student trong cùng transaction
    @PostMapping("/students")
    @Transactional
    public String createStudent(@RequestParam String username,
            @RequestParam String password,
            @RequestParam String fname,
            @RequestParam(required = false) String lname,
            @RequestParam String email,
            @RequestParam(required = false) String phone,
            @RequestParam(required = false) String className,
            @RequestParam(required = false) String faculty,
            RedirectAttributes ra) {

        String u = username.trim();
        String e = email.trim();

        if (u.isEmpty() || password == null || password.isBlank() || fname == null || fname.isBlank() || e.isEmpty()) {
            ra.addFlashAttribute("error", "Vui lòng nhập đầy đủ: Mã SV, Mật khẩu, Họ, Email.");
            return "redirect:/admin/students";
        }
        if (userRepository.existsByUsername(u)) {
            ra.addFlashAttribute("error", "Mã SV/Username đã tồn tại: " + u);
            return "redirect:/admin/students";
        }
        if (userRepository.existsByEmail(e)) {
            ra.addFlashAttribute("error", "Email đã tồn tại: " + e);
            return "redirect:/admin/students";
        }

        // 1) User
        User svUser = new User();
        svUser.setUsername(u);
        svUser.setPassword(passwordEncoder.encode(password)); // mã hóa
        svUser.setFname(fname);
        svUser.setLname(lname);
        svUser.setEmail(e);
        svUser.setPhone(phone);
        svUser.setRole(User.Role.STUDENT);
        svUser = userRepository.save(svUser);

        // 2) Student
        Student st = new Student();
        st.setUser(svUser); // @MapsId -> id của student = id user
        st.setClassName(className);
        st.setFaculty(faculty);
        studentRepository.save(st);

        ra.addFlashAttribute("success", "Đã tạo sinh viên: " + u);
        return "redirect:/admin/students";
    }

    @GetMapping("/teachers")
    public String teachers(Authentication auth, Model model) {
        addUserInfo(auth, model);
        model.addAttribute("activeTab", "teachers");
        return "admin/teachers";
    }

    @GetMapping("/subjects")
    public String subjects(Authentication auth, Model model) {
        addUserInfo(auth, model);
        model.addAttribute("activeTab", "subjects");
        return "admin/subjects";
    }
}