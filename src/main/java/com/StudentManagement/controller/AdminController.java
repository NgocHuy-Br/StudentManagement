package com.StudentManagement.controller;

import com.StudentManagement.entity.Major;
import com.StudentManagement.entity.Student;
import com.StudentManagement.entity.Subject;
import com.StudentManagement.entity.Teacher;
import com.StudentManagement.entity.User;
import com.StudentManagement.repository.MajorRepository;
import com.StudentManagement.repository.ScoreRepository;
import com.StudentManagement.repository.StudentRepository;
import com.StudentManagement.repository.SubjectRepository;
import com.StudentManagement.repository.TeacherRepository;
import com.StudentManagement.repository.TeacherSubjectRepository;
import com.StudentManagement.repository.UserRepository;
import org.springframework.data.domain.*;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequestMapping("/admin")
public class AdminController {

    private final UserRepository userRepository;
    private final StudentRepository studentRepository;
    private final TeacherRepository teacherRepository;
    private final MajorRepository majorRepository;
    private final SubjectRepository subjectRepository;
    private final ScoreRepository scoreRepository;
    private final TeacherSubjectRepository teacherSubjectRepository;
    private final PasswordEncoder passwordEncoder;

    public AdminController(UserRepository userRepository,
            StudentRepository studentRepository,
            TeacherRepository teacherRepository,
            MajorRepository majorRepository,
            SubjectRepository subjectRepository,
            ScoreRepository scoreRepository,
            TeacherSubjectRepository teacherSubjectRepository,
            PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.studentRepository = studentRepository;
        this.teacherRepository = teacherRepository;
        this.majorRepository = majorRepository;
        this.subjectRepository = subjectRepository;
        this.scoreRepository = scoreRepository;
        this.teacherSubjectRepository = teacherSubjectRepository;
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

    // Danh sách sinh viên: dùng Page<Student> để có đủ field (lớp, ngành) và field
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

        // Lấy danh sách ngành học để hiển thị trong form thêm sinh viên
        List<Major> majors = majorRepository.findAll();

        model.addAttribute("page", students);
        model.addAttribute("majors", majors);
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
            @RequestParam Long majorId,
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

        // Kiểm tra ngành học tồn tại
        Major major = majorRepository.findById(majorId).orElse(null);
        if (major == null) {
            ra.addFlashAttribute("error", "Ngành học không tồn tại.");
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
        st.setMajor(major); // Gán ngành học thay vì faculty
        studentRepository.save(st);

        ra.addFlashAttribute("success", "Đã tạo sinh viên: " + u);
        return "redirect:/admin/students";
    }

    @GetMapping("/teachers")
    public String teachers(Authentication auth, Model model,
            @RequestParam(defaultValue = "") String q,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(defaultValue = "user.username") String sort,
            @RequestParam(defaultValue = "asc") String dir) {
        addUserInfo(auth, model);
        model.addAttribute("activeTab", "teachers");

        Sort.Direction direction = "desc".equalsIgnoreCase(dir) ? Sort.Direction.DESC : Sort.Direction.ASC;
        Pageable pageable = PageRequest.of(Math.max(page, 0), Math.max(size, 1), Sort.by(direction, sort));

        Page<Teacher> teachers = (q == null || q.isBlank())
                ? teacherRepository.findAllWithUser(pageable)
                : teacherRepository.search(q.trim(), pageable);

        model.addAttribute("page", teachers);
        model.addAttribute("q", q);
        model.addAttribute("sort", sort);
        model.addAttribute("dir", dir);
        return "admin/teachers";
    }

    // Thêm giáo viên
    @PostMapping("/teachers")
    @Transactional
    public String createTeacher(@RequestParam String username,
            @RequestParam String password,
            @RequestParam String fname,
            @RequestParam(required = false) String lname,
            @RequestParam String email,
            @RequestParam(required = false) String phone,
            @RequestParam(required = false) String department,
            RedirectAttributes ra) {

        String u = username.trim();
        String e = email.trim();

        if (u.isEmpty() || password == null || password.isBlank() || fname == null || fname.isBlank() || e.isEmpty()) {
            ra.addFlashAttribute("error", "Vui lòng nhập đầy đủ: Mã GV, Mật khẩu, Họ, Email.");
            return "redirect:/admin/teachers";
        }
        if (userRepository.existsByUsername(u)) {
            ra.addFlashAttribute("error", "Mã GV/Username đã tồn tại: " + u);
            return "redirect:/admin/teachers";
        }
        if (userRepository.existsByEmail(e)) {
            ra.addFlashAttribute("error", "Email đã tồn tại: " + e);
            return "redirect:/admin/teachers";
        }

        // 1) User
        User teacherUser = new User();
        teacherUser.setUsername(u);
        teacherUser.setPassword(passwordEncoder.encode(password));
        teacherUser.setFname(fname);
        teacherUser.setLname(lname);
        teacherUser.setEmail(e);
        teacherUser.setPhone(phone);
        teacherUser.setRole(User.Role.TEACHER);
        teacherUser = userRepository.save(teacherUser);

        // 2) Teacher
        Teacher teacher = new Teacher();
        teacher.setUser(teacherUser);
        teacher.setDepartment(department);
        teacherRepository.save(teacher);

        ra.addFlashAttribute("success", "Đã tạo giáo viên: " + u);
        return "redirect:/admin/teachers";
    }

    @GetMapping("/subjects")
    public String subjects(Authentication auth, Model model,
            @RequestParam(defaultValue = "") String q,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(defaultValue = "subjectCode") String sort,
            @RequestParam(defaultValue = "asc") String dir) {
        addUserInfo(auth, model);
        model.addAttribute("activeTab", "subjects");

        Sort.Direction direction = "desc".equalsIgnoreCase(dir) ? Sort.Direction.DESC : Sort.Direction.ASC;
        Pageable pageable = PageRequest.of(Math.max(page, 0), Math.max(size, 1), Sort.by(direction, sort));

        Page<Subject> subjects = (q == null || q.isBlank())
                ? subjectRepository.findAllWithMajor(pageable)
                : subjectRepository.search(q.trim(), pageable);

        // Lấy danh sách ngành học để hiển thị trong form thêm môn học
        List<Major> majors = majorRepository.findAll();

        model.addAttribute("page", subjects);
        model.addAttribute("majors", majors);
        model.addAttribute("q", q);
        model.addAttribute("sort", sort);
        model.addAttribute("dir", dir);
        return "admin/subjects";
    }

    // Thêm môn học
    @PostMapping("/subjects")
    public String createSubject(@RequestParam String subjectCode,
            @RequestParam String subjectName,
            @RequestParam int credit,
            @RequestParam Long majorId,
            RedirectAttributes ra) {

        String code = subjectCode.trim();
        String name = subjectName.trim();

        if (code.isEmpty() || name.isEmpty() || credit <= 0) {
            ra.addFlashAttribute("error", "Vui lòng nhập đầy đủ thông tin môn học.");
            return "redirect:/admin/subjects";
        }
        if (subjectRepository.existsBySubjectCode(code)) {
            ra.addFlashAttribute("error", "Mã môn học đã tồn tại: " + code);
            return "redirect:/admin/subjects";
        }

        Major major = majorRepository.findById(majorId).orElse(null);
        if (major == null) {
            ra.addFlashAttribute("error", "Ngành học không tồn tại.");
            return "redirect:/admin/subjects";
        }

        Subject subject = new Subject();
        subject.setSubjectCode(code);
        subject.setSubjectName(name);
        subject.setCredit(credit);
        subject.setMajor(major);
        subjectRepository.save(subject);

        ra.addFlashAttribute("success", "Đã tạo môn học: " + code + " - " + name);
        return "redirect:/admin/subjects";
    }

    // Quản lý ngành học
    @GetMapping("/majors")
    public String majors(Authentication auth, Model model,
            @RequestParam(defaultValue = "") String q,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(defaultValue = "majorCode") String sort,
            @RequestParam(defaultValue = "asc") String dir) {
        addUserInfo(auth, model);
        model.addAttribute("activeTab", "majors");

        Sort.Direction direction = "desc".equalsIgnoreCase(dir) ? Sort.Direction.DESC : Sort.Direction.ASC;
        Pageable pageable = PageRequest.of(Math.max(page, 0), Math.max(size, 1), Sort.by(direction, sort));

        Page<Major> majors = (q == null || q.isBlank())
                ? majorRepository.findAll(pageable)
                : majorRepository.search(q.trim(), pageable);

        model.addAttribute("page", majors);
        model.addAttribute("q", q);
        model.addAttribute("sort", sort);
        model.addAttribute("dir", dir);
        return "admin/majors";
    }

    // Thêm ngành học
    @PostMapping("/majors")
    public String createMajor(@RequestParam String majorCode,
            @RequestParam String majorName,
            @RequestParam(required = false) String description,
            RedirectAttributes ra) {

        String code = majorCode.trim().toUpperCase();
        String name = majorName.trim();

        if (code.isEmpty() || name.isEmpty()) {
            ra.addFlashAttribute("error", "Vui lòng nhập đầy đủ mã ngành và tên ngành.");
            return "redirect:/admin/majors";
        }
        if (majorRepository.existsByMajorCode(code)) {
            ra.addFlashAttribute("error", "Mã ngành đã tồn tại: " + code);
            return "redirect:/admin/majors";
        }

        Major major = new Major(code, name, description);
        majorRepository.save(major);

        ra.addFlashAttribute("success", "Đã tạo ngành học: " + code + " - " + name);
        return "redirect:/admin/majors";
    }

    // Cập nhật ngành học
    @PostMapping("/majors/edit")
    @Transactional
    public String editMajor(@RequestParam Long id,
            @RequestParam String majorCode,
            @RequestParam String majorName,
            @RequestParam(required = false) String description,
            RedirectAttributes ra) {

        String code = majorCode.trim().toUpperCase();
        String name = majorName.trim();

        if (code.isEmpty() || name.isEmpty()) {
            ra.addFlashAttribute("error", "Vui lòng nhập đầy đủ mã ngành và tên ngành.");
            return "redirect:/admin/majors";
        }

        Major existingMajor = majorRepository.findById(id).orElse(null);
        if (existingMajor == null) {
            ra.addFlashAttribute("error", "Không tìm thấy ngành học.");
            return "redirect:/admin/majors";
        }

        // Kiểm tra mã ngành trùng (trừ chính nó)
        if (!existingMajor.getMajorCode().equals(code) && majorRepository.existsByMajorCode(code)) {
            ra.addFlashAttribute("error", "Mã ngành đã tồn tại: " + code);
            return "redirect:/admin/majors";
        }

        existingMajor.setMajorCode(code);
        existingMajor.setMajorName(name);
        existingMajor.setDescription(description);
        majorRepository.save(existingMajor);

        ra.addFlashAttribute("success", "Đã cập nhật ngành học: " + code);
        return "redirect:/admin/majors";
    }

    // Xóa ngành học
    @PostMapping("/majors/delete")
    @Transactional
    public String deleteMajor(@RequestParam Long id, RedirectAttributes ra) {
        Major major = majorRepository.findById(id).orElse(null);
        if (major == null) {
            ra.addFlashAttribute("error", "Không tìm thấy ngành học.");
            return "redirect:/admin/majors";
        }

        // Kiểm tra xem có sinh viên nào thuộc ngành này không
        long studentCount = studentRepository.countByMajorId(id);
        if (studentCount > 0) {
            ra.addFlashAttribute("error",
                    "Không thể xóa ngành học vì còn " + studentCount + " sinh viên thuộc ngành này.");
            return "redirect:/admin/majors";
        }

        // Kiểm tra xem có môn học nào thuộc ngành này không
        long subjectCount = subjectRepository.countByMajorId(id);
        if (subjectCount > 0) {
            ra.addFlashAttribute("error",
                    "Không thể xóa ngành học vì còn " + subjectCount + " môn học thuộc ngành này.");
            return "redirect:/admin/majors";
        }

        majorRepository.delete(major);
        ra.addFlashAttribute("success", "Đã xóa ngành học: " + major.getMajorCode());
        return "redirect:/admin/majors";
    }

    // Xem chi tiết ngành học và các môn học
    @GetMapping("/majors/{id}/subjects")
    public String majorSubjects(@PathVariable Long id, Authentication auth, Model model,
            @RequestParam(defaultValue = "") String q,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(defaultValue = "subjectCode") String sort,
            @RequestParam(defaultValue = "asc") String dir) {
        addUserInfo(auth, model);

        Major major = majorRepository.findById(id).orElse(null);
        if (major == null) {
            return "redirect:/admin/majors";
        }

        Sort.Direction direction = "desc".equalsIgnoreCase(dir) ? Sort.Direction.DESC : Sort.Direction.ASC;
        Pageable pageable = PageRequest.of(Math.max(page, 0), Math.max(size, 1), Sort.by(direction, sort));

        Page<Subject> subjects = (q == null || q.isBlank())
                ? subjectRepository.findByMajorId(id, pageable)
                : subjectRepository.searchByMajorId(id, q.trim(), pageable);

        model.addAttribute("major", major);
        model.addAttribute("page", subjects);
        model.addAttribute("q", q);
        model.addAttribute("sort", sort);
        model.addAttribute("dir", dir);
        return "admin/major-subjects";
    }

    // Thêm môn học cho ngành
    @PostMapping("/majors/{majorId}/subjects")
    @Transactional
    public String createSubjectForMajor(@PathVariable Long majorId,
            @RequestParam String subjectCode,
            @RequestParam String subjectName,
            @RequestParam int credit,
            RedirectAttributes ra) {

        String code = subjectCode.trim().toUpperCase();
        String name = subjectName.trim();

        if (code.isEmpty() || name.isEmpty() || credit <= 0) {
            ra.addFlashAttribute("error", "Vui lòng nhập đầy đủ thông tin môn học.");
            return "redirect:/admin/majors/" + majorId + "/subjects";
        }

        if (subjectRepository.existsBySubjectCode(code)) {
            ra.addFlashAttribute("error", "Mã môn học đã tồn tại: " + code);
            return "redirect:/admin/majors/" + majorId + "/subjects";
        }

        Major major = majorRepository.findById(majorId).orElse(null);
        if (major == null) {
            ra.addFlashAttribute("error", "Ngành học không tồn tại.");
            return "redirect:/admin/majors";
        }

        Subject subject = new Subject();
        subject.setSubjectCode(code);
        subject.setSubjectName(name);
        subject.setCredit(credit);
        subject.setMajor(major);
        subjectRepository.save(subject);

        ra.addFlashAttribute("success", "Đã thêm môn học: " + code);
        return "redirect:/admin/majors/" + majorId + "/subjects";
    }

    // Xóa môn học khỏi ngành
    @PostMapping("/majors/{majorId}/subjects/delete")
    @Transactional
    public String deleteSubjectFromMajor(@PathVariable Long majorId,
            @RequestParam Long subjectId,
            RedirectAttributes ra) {

        Subject subject = subjectRepository.findById(subjectId).orElse(null);
        if (subject == null) {
            ra.addFlashAttribute("error", "Không tìm thấy môn học.");
            return "redirect:/admin/majors/" + majorId + "/subjects";
        }

        // Kiểm tra xem có điểm nào cho môn này không
        long scoreCount = scoreRepository.countBySubjectId(subjectId);
        if (scoreCount > 0) {
            ra.addFlashAttribute("error", "Không thể xóa môn học vì đã có " + scoreCount + " điểm số được ghi nhận.");
            return "redirect:/admin/majors/" + majorId + "/subjects";
        }

        // Xóa phân công giảng dạy cho môn này
        teacherSubjectRepository.deleteBySubjectId(subjectId);

        subjectRepository.delete(subject);
        ra.addFlashAttribute("success", "Đã xóa môn học: " + subject.getSubjectCode());
        return "redirect:/admin/majors/" + majorId + "/subjects";
    }
}