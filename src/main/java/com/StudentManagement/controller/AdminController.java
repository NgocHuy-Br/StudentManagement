package com.StudentManagement.controller;

import com.StudentManagement.entity.Classroom;
import com.StudentManagement.entity.ClassroomTeacher;
import com.StudentManagement.entity.Faculty;
import com.StudentManagement.entity.Major;
import com.StudentManagement.entity.Score;
import com.StudentManagement.entity.ScoreHistory;
import com.StudentManagement.entity.Student;
import com.StudentManagement.entity.Subject;
import com.StudentManagement.entity.Teacher;
import com.StudentManagement.entity.User;
import com.StudentManagement.repository.ClassroomRepository;
import com.StudentManagement.repository.FacultyRepository;
import com.StudentManagement.repository.MajorRepository;
import com.StudentManagement.repository.ScoreRepository;
import com.StudentManagement.repository.ScoreHistoryRepository;
import com.StudentManagement.repository.StudentRepository;
import com.StudentManagement.repository.SubjectRepository;
import com.StudentManagement.repository.TeacherRepository;
import com.StudentManagement.repository.UserRepository;
import com.StudentManagement.service.ClassroomTeacherService;
import com.StudentManagement.service.OverviewService;
import com.StudentManagement.service.PdfService;
import com.StudentManagement.util.DateFormatHelper;
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

import java.util.HashMap;
import java.util.Map;
import java.util.List;
import java.util.ArrayList;
import java.util.Optional;
import java.util.regex.Pattern;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Controller
@RequestMapping("/admin")
public class AdminController {

    private static final Logger logger = LoggerFactory.getLogger(AdminController.class);

    private final UserRepository userRepository;
    private final StudentRepository studentRepository;
    private final TeacherRepository teacherRepository;
    private final FacultyRepository facultyRepository;
    private final MajorRepository majorRepository;
    private final SubjectRepository subjectRepository;
    private final ScoreRepository scoreRepository;
    private final ScoreHistoryRepository scoreHistoryRepository;
    private final ClassroomRepository classroomRepository;
    private final ClassroomTeacherService classroomTeacherService;
    private final OverviewService overviewService;
    private final PdfService pdfService;
    private final PasswordEncoder passwordEncoder;

    // Pattern for course year validation
    private static final Pattern COURSE_YEAR_PATTERN = Pattern.compile("^[0-9]{4}-[0-9]{4}$");

    public AdminController(UserRepository userRepository,
            StudentRepository studentRepository,
            TeacherRepository teacherRepository,
            FacultyRepository facultyRepository,
            MajorRepository majorRepository,
            SubjectRepository subjectRepository,
            ScoreRepository scoreRepository,
            ScoreHistoryRepository scoreHistoryRepository,
            ClassroomRepository classroomRepository,
            ClassroomTeacherService classroomTeacherService,
            OverviewService overviewService,
            PdfService pdfService,
            PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.studentRepository = studentRepository;
        this.teacherRepository = teacherRepository;
        this.facultyRepository = facultyRepository;
        this.majorRepository = majorRepository;
        this.subjectRepository = subjectRepository;
        this.scoreRepository = scoreRepository;
        this.scoreHistoryRepository = scoreHistoryRepository;
        this.classroomRepository = classroomRepository;
        this.classroomTeacherService = classroomTeacherService;
        this.overviewService = overviewService;
        this.pdfService = pdfService;
        this.passwordEncoder = passwordEncoder;
    }

    /**
     * Validate course year format and logic
     * Format should be YYYY-YYYY where the second year > first year
     */
    private String validateCourseYear(String courseYear) {
        if (courseYear == null || courseYear.trim().isEmpty()) {
            return "Khóa học không được để trống";
        }

        String trimmed = courseYear.trim();

        if (!COURSE_YEAR_PATTERN.matcher(trimmed).matches()) {
            return "Định dạng khóa học phải là YYYY-YYYY (ví dụ: 2025-2029)";
        }

        try {
            String[] years = trimmed.split("-");
            int startYear = Integer.parseInt(years[0]);
            int endYear = Integer.parseInt(years[1]);

            if (startYear < 1900 || startYear > 2100) {
                return "Năm bắt đầu phải nằm trong khoảng từ 1900 đến 2100";
            }

            if (endYear < 1900 || endYear > 2100) {
                return "Năm kết thúc phải nằm trong khoảng từ 1900 đến 2100";
            }

            if (endYear <= startYear) {
                return "Năm kết thúc phải lớn hơn năm bắt đầu";
            }

            if (endYear - startYear > 10) {
                return "Khoảng cách giữa năm bắt đầu và kết thúc không được quá 10 năm";
            }

        } catch (NumberFormatException e) {
            return "Năm phải là số hợp lệ";
        }

        return null; // No error
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
        // Redirect to overview page
        return "redirect:/admin/overview";
    }

    // Trang tổng quan
    @GetMapping("/overview")
    public String overview(Authentication auth, Model model) {
        // Thêm thông tin header
        String firstName = "User";
        String roleDisplay = "Người dùng";
        if (auth != null) {
            Optional<User> u = userRepository.findByUsername(auth.getName());
            if (u.isPresent()) {
                firstName = (u.get().getFname() != null && !u.get().getFname().isBlank()) ? u.get().getFname()
                        : u.get().getUsername();
                roleDisplay = switch (u.get().getRole()) {
                    case ADMIN -> "Quản trị viên";
                    case TEACHER -> "Giáo viên";
                    case STUDENT -> "Sinh viên";
                };
            }
        }

        model.addAttribute("firstName", firstName);
        model.addAttribute("roleDisplay", roleDisplay);

        // Lấy thông tin user hiện tại
        String username = auth.getName();
        User currentUser = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));
        model.addAttribute("currentUser", currentUser);

        // Lấy thống kê tổng quát
        model.addAttribute("totalStats", overviewService.getTotalStatistics());

        // Lấy thống kê theo khoa
        model.addAttribute("facultyStats", overviewService.getFacultyStatistics());

        // Lấy thống kê theo ngành
        model.addAttribute("majorStats", overviewService.getMajorStatistics());

        return "admin/overview";
    }

    // Danh sách lớp học: giao diện 2 panel - trái: quản lý lớp, phải: sinh viên
    // trong lớp
    @GetMapping("/classrooms")
    public String classrooms(Authentication auth,
            Model model,
            @RequestParam(defaultValue = "") String search,
            @RequestParam(required = false) Long majorId,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(defaultValue = "classCode") String sort,
            @RequestParam(defaultValue = "asc") String dir,
            @RequestParam(required = false) Long selectedClassroomId,
            @RequestParam(defaultValue = "username-asc") String studentSort) {
        addUserInfo(auth, model);
        model.addAttribute("activeTab", "classrooms");

        Sort.Direction direction = "desc".equalsIgnoreCase(dir) ? Sort.Direction.DESC : Sort.Direction.ASC;
        Pageable pageable = PageRequest.of(Math.max(page, 0), Math.max(size, 1), Sort.by(direction, sort));

        Page<Classroom> classrooms;

        // Tìm kiếm và lọc theo điều kiện
        if ((search == null || search.isBlank()) && majorId == null) {
            // Không có điều kiện tìm kiếm
            classrooms = classroomRepository.findAll(pageable);
        } else if (majorId != null && (search == null || search.isBlank())) {
            // Chỉ lọc theo ngành
            classrooms = classroomRepository.findByMajorId(majorId, pageable);
        } else if (majorId == null && search != null && !search.isBlank()) {
            // Chỉ tìm kiếm theo tên
            classrooms = classroomRepository.search(search.trim(), pageable);
        } else {
            // Cả tìm kiếm và lọc theo ngành
            classrooms = classroomRepository.searchByClassCodeAndMajor(search.trim(), majorId, pageable);
        }

        // Lấy danh sách ngành và giáo viên cho form tạo lớp
        List<Major> majors = majorRepository.findAll();
        List<Teacher> teachers = teacherRepository.findAll();

        model.addAttribute("classrooms", classrooms.getContent());
        model.addAttribute("page", classrooms);
        model.addAttribute("majors", majors);
        model.addAttribute("teachers", teachers);
        model.addAttribute("search", search);
        model.addAttribute("majorId", majorId);
        model.addAttribute("sort", sort);
        model.addAttribute("dir", dir);
        model.addAttribute("selectedClassroomId", selectedClassroomId);

        // Nếu có lớp được chọn, lấy thông tin sinh viên trong lớp
        if (selectedClassroomId != null) {
            Classroom selectedClass = classroomRepository.findById(selectedClassroomId).orElse(null);
            if (selectedClass != null) {
                // Xử lý sắp xếp sinh viên
                Sort studentSortBy;
                if ("name-asc".equals(studentSort)) {
                    studentSortBy = Sort.by(Sort.Direction.ASC, "user.fname");
                } else if ("name-desc".equals(studentSort)) {
                    studentSortBy = Sort.by(Sort.Direction.DESC, "user.fname");
                } else if ("username-desc".equals(studentSort)) {
                    studentSortBy = Sort.by(Sort.Direction.DESC, "user.username");
                } else if ("email-asc".equals(studentSort)) {
                    studentSortBy = Sort.by(Sort.Direction.ASC, "user.email");
                } else if ("email-desc".equals(studentSort)) {
                    studentSortBy = Sort.by(Sort.Direction.DESC, "user.email");
                } else { // mặc định username-asc
                    studentSortBy = Sort.by(Sort.Direction.ASC, "user.username");
                }

                Pageable studentPageable = PageRequest.of(0, 50, studentSortBy);
                Page<Student> studentsInClass = studentRepository.findByClassroomId(selectedClassroomId,
                        studentPageable);

                model.addAttribute("selectedClass", selectedClass);
                model.addAttribute("classStudents", studentsInClass.getContent());
                model.addAttribute("studentsInClass", studentsInClass);
                model.addAttribute("studentSort", studentSort);

                // Lấy danh sách sinh viên chưa có lớp cùng ngành để thêm vào lớp
                Page<Student> unassignedStudents = studentRepository.findUnassignedStudentsByMajorId(
                        selectedClass.getMajor().getId(), PageRequest.of(0, 50, Sort.by("user.username")));
                model.addAttribute("availableStudents", unassignedStudents.getContent());
                model.addAttribute("unassignedStudents", unassignedStudents);
            }
        }

        return "admin/classrooms_new";
    }

    // Hiển thị form tạo lớp học mới
    @GetMapping("/classrooms/create")
    public String showCreateClassroomForm(Model model) {
        // Lấy danh sách giáo viên cho dropdown
        model.addAttribute("teachers", teacherRepository.findAll());
        return "admin/classrooms/create";
    }

    // Thêm lớp học mới
    @PostMapping("/classrooms")
    @Transactional
    public String createClassroom(@RequestParam String classCode,
            @RequestParam String courseYear,
            @RequestParam String majorCode,
            @RequestParam(required = false) Long teacherId,
            RedirectAttributes ra) {

        String code = classCode.trim().toUpperCase();
        String year = courseYear.trim();
        String majCode = majorCode.trim();

        if (code.isEmpty()) {
            ra.addFlashAttribute("error", "Vui lòng nhập mã lớp.");
            return "redirect:/admin/classrooms";
        }

        // Validate course year format and logic
        String courseYearError = validateCourseYear(year);
        if (courseYearError != null) {
            ra.addFlashAttribute("error", courseYearError);
            return "redirect:/admin/classrooms";
        }

        if (classroomRepository.existsByClassCode(code)) {
            ra.addFlashAttribute("error", "Mã lớp đã tồn tại: " + code);
            return "redirect:/admin/classrooms";
        }

        // Tìm ngành theo mã ngành
        List<Major> majors = majorRepository.findByMajorCode(majCode);
        if (majors.isEmpty()) {
            ra.addFlashAttribute("error", "Không tìm thấy ngành " + majCode);
            return "redirect:/admin/classrooms";
        }
        Major major = majors.get(0);

        Teacher teacher = null;
        if (teacherId != null) {
            teacher = teacherRepository.findById(teacherId).orElse(null);
        }

        Classroom classroom = new Classroom(code, year, major);
        classroom.setHomeRoomTeacher(teacher);
        classroomRepository.save(classroom);

        ra.addFlashAttribute("success", "Đã tạo lớp học: " + code);
        return "redirect:/admin/classrooms";
    }

    // Xóa lớp học
    @PostMapping("/classrooms/delete")
    @Transactional
    public String deleteClassroom(@RequestParam Long id, RedirectAttributes ra) {
        System.out.println("=== DELETE CLASSROOM ENDPOINT CALLED ===");
        System.out.println("DEBUG: deleteClassroom called with id: " + id);
        System.out.println("DEBUG: Request timestamp: " + System.currentTimeMillis());

        Classroom classroom = classroomRepository.findById(id).orElse(null);
        if (classroom == null) {
            System.out.println("DEBUG: Classroom not found with id: " + id);
            ra.addFlashAttribute("error", "Không tìm thấy lớp học.");
            return "redirect:/admin/classrooms";
        }

        System.out.println("DEBUG: Found classroom: " + classroom.getClassCode());

        // Kiểm tra xem có sinh viên nào trong lớp không
        long studentCount = classroomRepository.countStudentsByClassroomId(id);
        System.out.println("DEBUG: Student count in classroom: " + studentCount);

        if (studentCount > 0) {
            System.out.println("DEBUG: Cannot delete classroom - has students");
            ra.addFlashAttribute("error", "Không thể xóa lớp học vì còn " + studentCount + " sinh viên.");
            return "redirect:/admin/classrooms";
        }

        System.out.println("DEBUG: About to delete classroom: " + classroom.getClassCode());
        try {
            classroomRepository.delete(classroom);
            System.out.println("DEBUG: Classroom deleted successfully from database");
            ra.addFlashAttribute("success", "Đã xóa lớp học: " + classroom.getClassCode());
        } catch (Exception e) {
            System.out.println("DEBUG: Error deleting classroom: " + e.getMessage());
            e.printStackTrace();
            ra.addFlashAttribute("error", "Lỗi khi xóa lớp học: " + e.getMessage());
        }

        System.out.println("DEBUG: Redirecting to /admin/classrooms");
        return "redirect:/admin/classrooms";
    }

    // Cập nhật thông tin lớp học
    @PostMapping("/classrooms/update")
    @Transactional
    public String updateClassroom(@RequestParam Long id,
            @RequestParam(required = false) String classCode,
            @RequestParam(required = false) String courseYear,
            @RequestParam(required = false) Long majorId,
            @RequestParam(required = false) Long teacherId,
            @RequestParam(required = false) String teacherChangeNotes,
            RedirectAttributes ra) {
        System.out.println("DEBUG: updateClassroom called with id: " + id);

        Classroom classroom = classroomRepository.findById(id).orElse(null);
        if (classroom == null) {
            System.out.println("DEBUG: Classroom not found with id: " + id);
            ra.addFlashAttribute("error", "Không tìm thấy lớp học.");
            return "redirect:/admin/classrooms";
        }

        boolean hasStudents = classroom.getStudents() != null && !classroom.getStudents().isEmpty();
        System.out.println("DEBUG: Classroom has students: " + hasStudents);

        String oldCode = classroom.getClassCode();

        try {
            // Lưu thông tin giáo viên chủ nhiệm cũ để so sánh
            Teacher oldTeacher = classroom.getHomeRoomTeacher();

            // Nếu lớp đã có sinh viên, chỉ cho phép sửa giáo viên chủ nhiệm
            if (hasStudents) {
                // Chỉ cập nhật giáo viên chủ nhiệm
                Teacher newTeacher = null;
                if (teacherId != null && teacherId > 0) {
                    newTeacher = teacherRepository.findById(teacherId).orElse(null);
                }

                // Cập nhật lịch sử chủ nhiệm nếu có thay đổi giáo viên
                if (!isTeacherSame(oldTeacher, newTeacher)) {
                    String notes = (teacherChangeNotes != null && !teacherChangeNotes.trim().isEmpty())
                            ? teacherChangeNotes.trim()
                            : "Thay đổi giáo viên chủ nhiệm";
                    updateTeacherHistory(classroom, newTeacher, notes);
                }

                classroom.setHomeRoomTeacher(newTeacher);
                classroomRepository.save(classroom);
                ra.addFlashAttribute("success", "Đã cập nhật giáo viên chủ nhiệm cho lớp " + oldCode);
            } else {
                // Lớp chưa có sinh viên - cho phép sửa tất cả thông tin

                // Cập nhật mã lớp nếu có
                if (classCode != null && !classCode.trim().isEmpty()) {
                    String newCode = classCode.trim().toUpperCase();
                    if (!newCode.equals(oldCode) && classroomRepository.existsByClassCode(newCode)) {
                        ra.addFlashAttribute("error", "Mã lớp đã tồn tại: " + newCode);
                        return "redirect:/admin/classrooms";
                    }
                    classroom.setClassCode(newCode);
                }

                // Cập nhật khóa học nếu có
                if (courseYear != null && !courseYear.trim().isEmpty()) {
                    String courseYearError = validateCourseYear(courseYear.trim());
                    if (courseYearError != null) {
                        ra.addFlashAttribute("error", courseYearError);
                        return "redirect:/admin/classrooms";
                    }
                    classroom.setCourseYear(courseYear.trim());
                }

                // Cập nhật ngành nếu có
                if (majorId != null) {
                    Major newMajor = majorRepository.findById(majorId).orElse(null);
                    if (newMajor != null) {
                        classroom.setMajor(newMajor);
                    }
                }

                // Cập nhật giáo viên chủ nhiệm
                Teacher newTeacher = null;
                if (teacherId != null && teacherId > 0) {
                    newTeacher = teacherRepository.findById(teacherId).orElse(null);
                }

                // Cập nhật lịch sử chủ nhiệm nếu có thay đổi giáo viên
                if (!isTeacherSame(oldTeacher, newTeacher)) {
                    String notes = (teacherChangeNotes != null && !teacherChangeNotes.trim().isEmpty())
                            ? teacherChangeNotes.trim()
                            : "Cập nhật giáo viên chủ nhiệm";
                    updateTeacherHistory(classroom, newTeacher, notes);
                }

                classroom.setHomeRoomTeacher(newTeacher);

                classroomRepository.save(classroom);
                ra.addFlashAttribute("success", "Đã cập nhật thông tin lớp học thành công!");
            }

            System.out.println("DEBUG: Classroom updated successfully");

        } catch (Exception e) {
            System.out.println("DEBUG: Error updating classroom: " + e.getMessage());
            e.printStackTrace();
            ra.addFlashAttribute("error", "Lỗi khi cập nhật lớp học: " + e.getMessage());
        }

        return "redirect:/admin/classrooms";
    }

    // Thêm sinh viên vào lớp
    @PostMapping("/classrooms/{classId}/students/add")
    @Transactional
    public String addStudentToClass(@PathVariable Long classId,
            @RequestParam Long studentId,
            RedirectAttributes ra) {

        Classroom classroom = classroomRepository.findById(classId).orElse(null);
        if (classroom == null) {
            ra.addFlashAttribute("error", "Không tìm thấy lớp học.");
            return "redirect:/admin/classrooms";
        }

        Student student = studentRepository.findById(studentId).orElse(null);
        if (student == null) {
            ra.addFlashAttribute("error", "Không tìm thấy sinh viên.");
            return "redirect:/admin/classrooms?selectedClassId=" + classId;
        }

        // Kiểm tra ngành của sinh viên có khớp với ngành của lớp không
        if (!student.getMajor().getId().equals(classroom.getMajor().getId())) {
            ra.addFlashAttribute("error", "Sinh viên phải cùng ngành với lớp học.");
            return "redirect:/admin/classrooms?selectedClassId=" + classId;
        }

        student.setClassroom(classroom);
        student.setClassName(classroom.getClassCode()); // Cập nhật legacy field
        studentRepository.save(student);

        ra.addFlashAttribute("success", "Đã thêm sinh viên vào lớp: " + student.getUser().getUsername());
        return "redirect:/admin/classrooms?selectedClassId=" + classId;
    }

    // Tạo sinh viên mới cho lớp
    @PostMapping("/classrooms/{classId}/students/create")
    @Transactional
    public String createStudentForClass(@PathVariable Long classId,
            @RequestParam String username,
            @RequestParam(required = false) String password,
            @RequestParam(required = false) String fname,
            @RequestParam(required = false) String lname,
            @RequestParam(required = false) String fullName,
            @RequestParam String email,
            @RequestParam(required = false) String phone,
            @RequestParam(required = false) String phoneNumber,
            @RequestParam(required = false) String address,
            @RequestParam(required = false) String nationalId,
            @RequestParam(required = false) String birthDate,
            RedirectAttributes ra) {

        Classroom classroom = classroomRepository.findById(classId).orElse(null);
        if (classroom == null) {
            ra.addFlashAttribute("error", "Không tìm thấy lớp học.");
            return "redirect:/admin/classrooms";
        }

        String u = username.trim();
        String e = email.trim();

        // Tự động gán password = username nếu không có
        String pwd = (password != null && !password.trim().isEmpty()) ? password.trim() : u;

        // Xử lý fullName nếu có (tách thành fname và lname theo chuẩn Việt Nam)
        String firstName = fname; // Tên (phần cuối)
        String lastName = lname; // Họ và tên đệm (phần đầu)
        if (fullName != null && !fullName.trim().isEmpty() && (firstName == null || firstName.trim().isEmpty())) {
            String[] nameParts = fullName.trim().split("\\s+");
            if (nameParts.length >= 2) {
                // Tên là phần cuối cùng
                firstName = nameParts[nameParts.length - 1];
                // Họ và tên đệm là phần còn lại
                lastName = String.join(" ", java.util.Arrays.copyOfRange(nameParts, 0, nameParts.length - 1));
            } else {
                firstName = fullName.trim();
                lastName = "";
            }
        }

        // Xử lý phoneNumber
        String phoneNum = (phone != null && !phone.trim().isEmpty()) ? phone : phoneNumber;

        if (u.isEmpty() || firstName == null || firstName.trim().isEmpty() || e.isEmpty()) {
            ra.addFlashAttribute("error", "Vui lòng nhập đầy đủ: Mã SV, Họ tên, Email.");
            return "redirect:/admin/classrooms?selectedClassId=" + classId;
        }
        if (userRepository.existsByUsername(u)) {
            ra.addFlashAttribute("error", "Mã SV/Username đã tồn tại: " + u);
            return "redirect:/admin/classrooms?selectedClassId=" + classId;
        }
        if (userRepository.existsByEmail(e)) {
            ra.addFlashAttribute("error", "Email đã tồn tại: " + e);
            return "redirect:/admin/classrooms?selectedClassId=" + classId;
        }

        // Kiểm tra nationalId nếu có
        if (nationalId != null && !nationalId.trim().isEmpty()) {
            String nId = nationalId.trim();
            if (nId.length() != 12 || !nId.matches("\\d+")) {
                ra.addFlashAttribute("error", "CCCD phải có 12 chữ số");
                return "redirect:/admin/classrooms?selectedClassId=" + classId;
            }
            if (userRepository.existsByNationalId(nId)) {
                ra.addFlashAttribute("error", "CCCD đã tồn tại: " + nId);
                return "redirect:/admin/classrooms?selectedClassId=" + classId;
            }
        }

        // Kiểm tra xem sinh viên đã thuộc lớp nào chưa (nếu username đã tồn tại)
        Student existingStudent = studentRepository.findByUserUsername(u).orElse(null);
        if (existingStudent != null && existingStudent.getClassroom() != null) {
            ra.addFlashAttribute("error",
                    "Sinh viên " + u + " đã thuộc lớp: " + existingStudent.getClassroom().getClassCode());
            return "redirect:/admin/classrooms?selectedClassId=" + classId;
        }

        // Tạo User
        User svUser = new User();
        svUser.setUsername(u);
        svUser.setPassword(passwordEncoder.encode(pwd)); // sử dụng pwd đã xử lý
        svUser.setFname(firstName != null ? firstName.trim() : null);
        svUser.setLname(lastName != null ? lastName.trim() : null);
        svUser.setEmail(e);
        svUser.setPhone(phoneNum != null ? phoneNum.trim() : null);
        svUser.setAddress(address != null ? address.trim() : null);
        svUser.setNationalId(nationalId != null && !nationalId.trim().isEmpty() ? nationalId.trim() : null);

        // Xử lý ngày sinh
        if (birthDate != null && !birthDate.trim().isEmpty()) {
            try {
                svUser.setBirthDate(java.time.LocalDate.parse(birthDate.trim()));
            } catch (Exception ex) {
                ra.addFlashAttribute("error",
                        "Định dạng ngày sinh không hợp lệ. Vui lòng sử dụng định dạng: YYYY-MM-DD");
                return "redirect:/admin/classrooms?selectedClassId=" + classId;
            }
        }

        svUser.setRole(User.Role.STUDENT);
        svUser = userRepository.save(svUser);

        // Tạo Student và gán vào lớp
        Student st = new Student();
        st.setUser(svUser);
        st.setClassroom(classroom);
        st.setClassName(classroom.getClassCode());
        st.setMajor(classroom.getMajor()); // Ngành của sinh viên phải giống lớp
        studentRepository.save(st);

        ra.addFlashAttribute("success", "Đã tạo sinh viên cho lớp: " + u);
        return "redirect:/admin/classrooms?selectedClassId=" + classId;
    }

    // Xóa sinh viên khỏi lớp
    @PostMapping("/classrooms/{classId}/students/{studentId}/remove")
    @Transactional
    public String removeStudentFromClass(@PathVariable Long classId,
            @PathVariable Long studentId,
            RedirectAttributes ra) {

        Student student = studentRepository.findById(studentId).orElse(null);
        if (student == null) {
            ra.addFlashAttribute("error", "Không tìm thấy sinh viên.");
            return "redirect:/admin/classrooms?selectedClassId=" + classId;
        }

        student.setClassroom(null);
        student.setClassName(null);
        studentRepository.save(student);

        ra.addFlashAttribute("success", "Đã xóa sinh viên khỏi lớp: " + student.getUser().getUsername());
        return "redirect:/admin/classrooms?selectedClassId=" + classId;
    }

    // Xóa sinh viên khỏi lớp - mapping mới để match với JavaScript
    @PostMapping("/classrooms/removeStudent")
    @Transactional
    public String removeStudentFromClassNew(@RequestParam Long studentId,
            @RequestParam Long classroomId,
            RedirectAttributes ra) {

        Student student = studentRepository.findById(studentId).orElse(null);
        if (student == null) {
            ra.addFlashAttribute("error", "Không tìm thấy sinh viên.");
            return "redirect:/admin/classrooms?selectedClassId=" + classroomId;
        }

        student.setClassroom(null);
        student.setClassName(null);
        studentRepository.save(student);

        ra.addFlashAttribute("success", "Đã xóa sinh viên khỏi lớp: " + student.getUser().getUsername());
        return "redirect:/admin/classrooms?selectedClassId=" + classroomId;
    }

    // Thêm sinh viên: giữ lại method cũ cho backward compatibility
    @PostMapping("/students")
    @Transactional
    public String createStudent(@RequestParam String username,
            @RequestParam(required = false) String password,
            @RequestParam(required = false) String fname,
            @RequestParam(required = false) String lname,
            @RequestParam(required = false) String fullName,
            @RequestParam String email,
            @RequestParam(required = false) String phone,
            @RequestParam(required = false) String phoneNumber,
            @RequestParam(required = false) String address,
            @RequestParam(required = false) String nationalId,
            @RequestParam(required = false) String birthDate,
            @RequestParam(required = false) String className,
            @RequestParam Long majorId,
            RedirectAttributes ra) {

        String u = username.trim();
        String e = email.trim();

        // Tự động gán password = username nếu không có
        String pwd = (password != null && !password.trim().isEmpty()) ? password.trim() : u;

        // Xử lý fullName nếu có (tách thành fname và lname theo chuẩn Việt Nam)
        String firstName = fname; // Tên (phần cuối)
        String lastName = lname; // Họ và tên đệm (phần đầu)
        if (fullName != null && !fullName.trim().isEmpty() && (firstName == null || firstName.trim().isEmpty())) {
            String[] nameParts = fullName.trim().split("\\s+");
            if (nameParts.length >= 2) {
                // Tên là phần cuối cùng
                firstName = nameParts[nameParts.length - 1];
                // Họ và tên đệm là phần còn lại
                lastName = String.join(" ", java.util.Arrays.copyOfRange(nameParts, 0, nameParts.length - 1));
            } else {
                firstName = fullName.trim();
                lastName = "";
            }
        }

        // Xử lý phoneNumber
        String phoneNum = (phone != null && !phone.trim().isEmpty()) ? phone : phoneNumber;

        if (u.isEmpty() || firstName == null || firstName.trim().isEmpty() || e.isEmpty()) {
            ra.addFlashAttribute("error", "Vui lòng nhập đầy đủ: Mã SV, Họ tên, Email.");
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

        // Kiểm tra nationalId nếu có
        if (nationalId != null && !nationalId.trim().isEmpty()) {
            String nId = nationalId.trim();
            if (nId.length() != 12 || !nId.matches("\\d+")) {
                ra.addFlashAttribute("error", "CCCD phải có 12 chữ số");
                return "redirect:/admin/students";
            }
            if (userRepository.existsByNationalId(nId)) {
                ra.addFlashAttribute("error", "CCCD đã tồn tại: " + nId);
                return "redirect:/admin/students";
            }
        }

        // Kiểm tra xem sinh viên đã tồn tại chưa (bằng username)
        Student existingStudent = studentRepository.findByUserUsername(u).orElse(null);
        if (existingStudent != null) {
            String currentClass = existingStudent.getClassroom() != null ? existingStudent.getClassroom().getClassCode()
                    : "chưa có lớp";
            ra.addFlashAttribute("error", "Sinh viên " + u + " đã tồn tại trong hệ thống (lớp: " + currentClass + ")");
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
        svUser.setPassword(passwordEncoder.encode(pwd)); // sử dụng pwd đã xử lý
        svUser.setFname(firstName != null ? firstName.trim() : null);
        svUser.setLname(lastName != null ? lastName.trim() : null);
        svUser.setEmail(e);
        svUser.setPhone(phoneNum != null ? phoneNum.trim() : null);
        svUser.setAddress(address != null ? address.trim() : null);
        svUser.setNationalId(nationalId != null && !nationalId.trim().isEmpty() ? nationalId.trim() : null);

        // Xử lý ngày sinh
        if (birthDate != null && !birthDate.trim().isEmpty()) {
            try {
                svUser.setBirthDate(java.time.LocalDate.parse(birthDate.trim()));
            } catch (Exception ex) {
                ra.addFlashAttribute("error",
                        "Định dạng ngày sinh không hợp lệ. Vui lòng sử dụng định dạng: YYYY-MM-DD");
                return "redirect:/admin/students";
            }
        }

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
            @RequestParam(defaultValue = "") String faculty,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(defaultValue = "user.username") String sort,
            @RequestParam(defaultValue = "asc") String dir) {
        addUserInfo(auth, model);
        model.addAttribute("activeTab", "teachers");

        Sort.Direction direction = "desc".equalsIgnoreCase(dir) ? Sort.Direction.DESC : Sort.Direction.ASC;
        Pageable pageable = PageRequest.of(Math.max(page, 0), Math.max(size, 1), Sort.by(direction, sort));

        Page<Teacher> teachers;

        // Apply filters using Faculty
        if ((q == null || q.isBlank()) && (faculty == null || faculty.isBlank())) {
            teachers = teacherRepository.findAllWithUser(pageable);
        } else if (faculty != null && !faculty.isBlank() && (q == null || q.isBlank())) {
            // Kiểm tra xem faculty là ID hay tên
            try {
                Long facultyId = Long.parseLong(faculty);
                teachers = teacherRepository.findByFacultyId(facultyId, pageable);
            } catch (NumberFormatException e) {
                // Nếu không phải ID, tìm theo tên khoa
                teachers = teacherRepository.findByFacultyName(faculty, pageable);
            }
        } else if (q != null && !q.isBlank() && (faculty == null || faculty.isBlank())) {
            teachers = teacherRepository.search(q.trim(), pageable);
        } else {
            // Both q and faculty are provided
            try {
                Long facultyId = Long.parseLong(faculty);
                // Tạm thời dùng faculty name để search
                Faculty facultyObj = facultyRepository.findById(facultyId).orElse(null);
                if (facultyObj != null) {
                    teachers = teacherRepository.searchByFacultyName(q.trim(), facultyObj.getName(), pageable);
                } else {
                    teachers = teacherRepository.search(q.trim(), pageable);
                }
            } catch (NumberFormatException e) {
                teachers = teacherRepository.searchByFacultyName(q.trim(), faculty, pageable);
            }
        }

        model.addAttribute("page", teachers);
        model.addAttribute("q", q);
        model.addAttribute("faculty", faculty);
        model.addAttribute("sort", sort);
        model.addAttribute("dir", dir);
        model.addAttribute("faculties", facultyRepository.findAllOrderByName());
        return "admin/teachers";
    }

    // Thêm giáo viên
    @PostMapping("/teachers")
    @Transactional
    public String createTeacher(@RequestParam String username,
            @RequestParam String fullName,
            @RequestParam String email,
            @RequestParam(required = false) String phone,
            @RequestParam(required = false) String address,
            @RequestParam(required = false) String nationalId,
            @RequestParam(required = false) String birthDate,
            @RequestParam(required = false) Long facultyId,
            RedirectAttributes ra) {

        String u = username.trim();
        String e = email.trim();
        String fn = fullName.trim();

        if (u.isEmpty() || fn.isEmpty() || e.isEmpty()) {
            ra.addFlashAttribute("error", "Vui lòng nhập đầy đủ: Mã GV, Họ Tên, Email.");
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

        // Kiểm tra nationalId nếu có
        if (nationalId != null && !nationalId.trim().isEmpty()) {
            String nId = nationalId.trim();
            if (nId.length() != 12 || !nId.matches("\\d+")) {
                ra.addFlashAttribute("error", "CCCD phải có 12 chữ số");
                return "redirect:/admin/teachers";
            }
            if (userRepository.existsByNationalId(nId)) {
                ra.addFlashAttribute("error", "CCCD đã tồn tại: " + nId);
                return "redirect:/admin/teachers";
            }
        }

        // Tách họ tên thành fname và lname
        String[] nameParts = fn.split("\\s+", 2);
        String firstName = nameParts[0];
        String lastName = nameParts.length > 1 ? nameParts[1] : "";

        // 1) User với mật khẩu mặc định là mã giáo viên
        User teacherUser = new User();
        teacherUser.setUsername(u);
        teacherUser.setPassword(passwordEncoder.encode(u)); // Mật khẩu mặc định = mã giáo viên
        teacherUser.setFname(firstName);
        teacherUser.setLname(lastName);
        teacherUser.setEmail(e);
        teacherUser.setPhone(phone);
        teacherUser.setAddress(address);
        teacherUser.setNationalId(nationalId != null && !nationalId.trim().isEmpty() ? nationalId.trim() : null);

        // Xử lý ngày sinh
        if (birthDate != null && !birthDate.trim().isEmpty()) {
            try {
                teacherUser.setBirthDate(java.time.LocalDate.parse(birthDate.trim()));
            } catch (Exception ex) {
                ra.addFlashAttribute("error",
                        "Định dạng ngày sinh không hợp lệ. Vui lòng sử dụng định dạng: YYYY-MM-DD");
                return "redirect:/admin/teachers";
            }
        }

        teacherUser.setRole(User.Role.TEACHER);
        teacherUser = userRepository.save(teacherUser);

        // 2) Teacher với Faculty
        Teacher teacher = new Teacher();
        teacher.setUser(teacherUser);
        // Không set department nữa vì đã bỏ trường này

        // Liên kết với Faculty nếu có
        if (facultyId != null && facultyId > 0) {
            Faculty faculty = facultyRepository.findById(facultyId).orElse(null);
            if (faculty != null) {
                teacher.setFaculty(faculty);
            }
        }

        teacherRepository.save(teacher);

        ra.addFlashAttribute("success", "Đã tạo giáo viên: " + u + " (mật khẩu mặc định: " + u + ")");
        return "redirect:/admin/teachers";
    } // Chỉnh sửa giáo viên

    @PostMapping("/teachers/{teacherId}/edit")
    @Transactional
    public String editTeacher(@PathVariable Long teacherId,
            @RequestParam String username,
            @RequestParam String fullName,
            @RequestParam String email,
            @RequestParam(required = false) String phone,
            @RequestParam(required = false) String address,
            @RequestParam(required = false) String nationalId,
            @RequestParam(required = false) String birthDate,
            @RequestParam(required = false) Long facultyId,
            RedirectAttributes ra) {

        Teacher teacher = teacherRepository.findById(teacherId).orElse(null);
        if (teacher == null) {
            ra.addFlashAttribute("error", "Không tìm thấy giáo viên");
            return "redirect:/admin/teachers";
        }

        User user = teacher.getUser();
        String e = email.trim();
        String fn = fullName.trim();

        if (fn.isEmpty() || e.isEmpty()) {
            ra.addFlashAttribute("error", "Vui lòng nhập đầy đủ: Họ Tên, Email.");
            return "redirect:/admin/teachers";
        }

        // Kiểm tra email trùng (trừ user hiện tại)
        if (!user.getEmail().equals(e) && userRepository.existsByEmail(e)) {
            ra.addFlashAttribute("error", "Email đã tồn tại: " + e);
            return "redirect:/admin/teachers";
        }

        // Kiểm tra nationalId nếu có
        if (nationalId != null && !nationalId.trim().isEmpty()) {
            String nId = nationalId.trim();
            if (nId.length() != 12 || !nId.matches("\\d+")) {
                ra.addFlashAttribute("error", "CCCD phải có 12 chữ số");
                return "redirect:/admin/teachers";
            }
            // Kiểm tra CCCD trùng (trừ user hiện tại)
            if (!nId.equals(user.getNationalId()) && userRepository.existsByNationalId(nId)) {
                ra.addFlashAttribute("error", "CCCD đã tồn tại: " + nId);
                return "redirect:/admin/teachers";
            }
        }

        // Tách họ tên thành fname và lname
        String[] nameParts = fn.split("\\s+", 2);
        String firstName = nameParts[0];
        String lastName = nameParts.length > 1 ? nameParts[1] : "";

        // Cập nhật thông tin
        user.setFname(firstName);
        user.setLname(lastName);
        user.setEmail(e);
        user.setPhone(phone);
        user.setAddress(address);
        user.setNationalId(nationalId != null && !nationalId.trim().isEmpty() ? nationalId.trim() : null);

        // Xử lý ngày sinh
        if (birthDate != null && !birthDate.trim().isEmpty()) {
            try {
                user.setBirthDate(java.time.LocalDate.parse(birthDate.trim()));
            } catch (Exception ex) {
                ra.addFlashAttribute("error",
                        "Định dạng ngày sinh không hợp lệ. Vui lòng sử dụng định dạng: YYYY-MM-DD");
                return "redirect:/admin/teachers";
            }
        } else {
            user.setBirthDate(null);
        }

        userRepository.save(user);

        // Cập nhật Faculty cho teacher nếu có
        if (facultyId != null && facultyId > 0) {
            Faculty faculty = facultyRepository.findById(facultyId).orElse(null);
            teacher.setFaculty(faculty);
        } else {
            teacher.setFaculty(null);
        }

        teacherRepository.save(teacher);

        ra.addFlashAttribute("success", "Đã cập nhật giáo viên: " + user.getUsername());
        return "redirect:/admin/teachers";
    }

    // Kiểm tra có thể xóa giáo viên không (API endpoint)
    @GetMapping("/teachers/{teacherId}/can-delete")
    @ResponseBody
    public Map<String, Object> canDeleteTeacher(@PathVariable Long teacherId) {
        Map<String, Object> response = new HashMap<>();

        Teacher teacher = teacherRepository.findById(teacherId).orElse(null);
        if (teacher == null) {
            response.put("canDelete", false);
            response.put("reason", "Không tìm thấy giáo viên");
            return response;
        }

        // Kiểm tra xem giáo viên có đang là chủ nhiệm không
        boolean isHomeRoomTeacher = classroomTeacherService.isCurrentHomeRoomTeacher(teacherId);

        response.put("canDelete", !isHomeRoomTeacher);
        if (isHomeRoomTeacher) {
            response.put("reason", "Giáo viên đang là chủ nhiệm của một lớp học");
        }

        return response;
    }

    // Xóa giáo viên
    @PostMapping("/teachers/{teacherId}/delete")
    @Transactional
    public String deleteTeacher(@PathVariable Long teacherId, RedirectAttributes ra) {
        Teacher teacher = teacherRepository.findById(teacherId).orElse(null);
        if (teacher == null) {
            ra.addFlashAttribute("error", "Không tìm thấy giáo viên");
            return "redirect:/admin/teachers";
        }

        // Kiểm tra xem giáo viên có đang là chủ nhiệm không
        boolean isHomeRoomTeacher = classroomTeacherService.isCurrentHomeRoomTeacher(teacherId);
        if (isHomeRoomTeacher) {
            ra.addFlashAttribute("error", "Không thể xóa giáo viên đang là chủ nhiệm của một lớp học");
            return "redirect:/admin/teachers";
        }

        String username = teacher.getUser().getUsername();

        // Xóa teacher trước, sau đó xóa user
        teacherRepository.delete(teacher);
        userRepository.delete(teacher.getUser());

        ra.addFlashAttribute("success", "Đã xóa giáo viên: " + username);
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
                ? subjectRepository.findAll(pageable)
                : subjectRepository.search(q.trim(), pageable);

        // Lấy danh sách ngành học để hiển thị trong form thêm môn học
        List<Major> majors = majorRepository.findAll();

        model.addAttribute("page", subjects);
        model.addAttribute("majors", majors);
        model.addAttribute("q", q);
        model.addAttribute("sort", sort);
        model.addAttribute("dir", dir);
        model.addAttribute("faculties", facultyRepository.findAllOrderByName());
        return "admin/subjects";
    }

    // Thêm môn học
    @PostMapping("/subjects")
    public String createSubject(@RequestParam String subjectCode,
            @RequestParam String subjectName,
            @RequestParam int credit,
            @RequestParam(required = false, defaultValue = "10") Float attendanceWeight,
            @RequestParam(required = false, defaultValue = "30") Float midtermWeight,
            @RequestParam(required = false, defaultValue = "60") Float finalWeight,
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

        // Kiểm tra tổng hệ số
        float totalWeight = attendanceWeight + midtermWeight + finalWeight;
        if (Math.abs(totalWeight - 100.0f) > 0.1f) {
            ra.addFlashAttribute("error", "Tổng hệ số điểm phải bằng 100%");
            return "redirect:/admin/majors";
        }

        Subject subject = new Subject();
        subject.setSubjectCode(code);
        subject.setSubjectName(name);
        subject.setCredit(credit);
        // Chuyển đổi từ % về dạng thập phân
        subject.setAttendanceWeight(attendanceWeight / 100.0f);
        subject.setMidtermWeight(midtermWeight / 100.0f);
        subject.setFinalWeight(finalWeight / 100.0f);

        subjectRepository.save(subject);

        ra.addFlashAttribute("success",
                "Đã tạo môn học độc lập: " + code + " - " + name + ". Bạn có thể gán vào ngành sau.");
        return "redirect:/admin/majors?viewAll=true";
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

        // Lấy danh sách môn học chưa thuộc ngành này để có thể thêm vào
        List<Subject> availableSubjects = subjectRepository.findAll();
        if (major.getSubjects() != null) {
            availableSubjects.removeAll(major.getSubjects());
        }

        model.addAttribute("major", major);
        model.addAttribute("page", subjects);
        model.addAttribute("availableSubjects", availableSubjects);
        model.addAttribute("q", q);
        model.addAttribute("sort", sort);
        model.addAttribute("dir", dir);
        return "admin/major-subjects";
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
            return "redirect:/admin/majors?selectedMajorId=" + majorId;
        }

        Major major = majorRepository.findById(majorId).orElse(null);
        if (major == null) {
            ra.addFlashAttribute("error", "Ngành học không tồn tại.");
            return "redirect:/admin/majors";
        }

        // Chỉ xóa liên kết giữa ngành và môn học, không xóa môn học
        if (major.getSubjects() != null) {
            major.getSubjects().remove(subject);
            majorRepository.save(major);
        }

        ra.addFlashAttribute("success", "Đã xóa môn học khỏi ngành: " + subject.getSubjectCode());
        return "redirect:/admin/majors?selectedMajorId=" + majorId;
    }

    // ===========================
    // CLASSROOM TEACHER MANAGEMENT
    // ===========================

    /**
     * Xem các lớp mà giáo viên đang chủ nhiệm
     */
    @GetMapping("/teachers/{teacherId}/current-classes")
    public String viewTeacherCurrentClasses(@PathVariable Long teacherId,
            Authentication auth, Model model) {
        addUserInfo(auth, model);
        model.addAttribute("activeTab", "teachers");

        Teacher teacher = teacherRepository.findById(teacherId).orElse(null);
        if (teacher == null) {
            model.addAttribute("error", "Không tìm thấy giáo viên");
            return "redirect:/admin/teachers";
        }

        model.addAttribute("teacher", teacher);
        model.addAttribute("currentClasses", classroomTeacherService.getCurrentClassroomsByTeacher(teacherId));
        model.addAttribute("teacherHistory", classroomTeacherService.getTeacherHomeRoomHistory(teacherId));

        return "admin/teacher-classroom-history";
    }

    // FACULTY MANAGEMENT
    // ==================

    // ============= FACULTY MANAGEMENT TAB =============

    /**
     * Tab Khoa - Hiển thị danh sách khoa với thống kê
     */
    @GetMapping("/faculties/manage")
    public String manageFaculties(Authentication auth, Model model,
            @RequestParam(defaultValue = "") String q,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(defaultValue = "name") String sort,
            @RequestParam(defaultValue = "asc") String dir) {
        addUserInfo(auth, model);
        model.addAttribute("activeTab", "faculties");

        Sort.Direction direction = "desc".equalsIgnoreCase(dir) ? Sort.Direction.DESC : Sort.Direction.ASC;

        // Validate sort parameter và xử lý các loại sắp xếp khác nhau
        Page<Faculty> faculties;
        boolean isSearching = q != null && !q.isBlank();
        String trimmedQuery = isSearching ? q.trim() : "";

        if ("teacherCount".equals(sort)) {
            // Sắp xếp theo số lượng giáo viên
            Pageable pageable = PageRequest.of(Math.max(page, 0), Math.max(size, 1));
            if (isSearching) {
                faculties = direction == Sort.Direction.ASC
                        ? facultyRepository.searchOrderByTeacherCountAsc(trimmedQuery, pageable)
                        : facultyRepository.searchOrderByTeacherCountDesc(trimmedQuery, pageable);
            } else {
                faculties = direction == Sort.Direction.ASC
                        ? facultyRepository.findAllOrderByTeacherCountAsc(pageable)
                        : facultyRepository.findAllOrderByTeacherCountDesc(pageable);
            }
        } else if ("majorCount".equals(sort)) {
            // Sắp xếp theo số lượng ngành
            Pageable pageable = PageRequest.of(Math.max(page, 0), Math.max(size, 1));
            if (isSearching) {
                faculties = direction == Sort.Direction.ASC
                        ? facultyRepository.searchOrderByMajorCountAsc(trimmedQuery, pageable)
                        : facultyRepository.searchOrderByMajorCountDesc(trimmedQuery, pageable);
            } else {
                faculties = direction == Sort.Direction.ASC
                        ? facultyRepository.findAllOrderByMajorCountAsc(pageable)
                        : facultyRepository.findAllOrderByMajorCountDesc(pageable);
            }
        } else if ("studentCount".equals(sort)) {
            // Sắp xếp theo số lượng sinh viên
            Pageable pageable = PageRequest.of(Math.max(page, 0), Math.max(size, 1));
            if (isSearching) {
                faculties = direction == Sort.Direction.ASC
                        ? facultyRepository.searchOrderByStudentCountAsc(trimmedQuery, pageable)
                        : facultyRepository.searchOrderByStudentCountDesc(trimmedQuery, pageable);
            } else {
                faculties = direction == Sort.Direction.ASC
                        ? facultyRepository.findAllOrderByStudentCountAsc(pageable)
                        : facultyRepository.findAllOrderByStudentCountDesc(pageable);
            }
        } else {
            // Sắp xếp thông thường theo name, facultyCode, description
            String validSort = ("name".equals(sort) || "description".equals(sort) || "facultyCode".equals(sort)) ? sort
                    : "name";
            Pageable pageable = PageRequest.of(Math.max(page, 0), Math.max(size, 1), Sort.by(direction, validSort));
            faculties = isSearching
                    ? facultyRepository.search(trimmedQuery, pageable)
                    : facultyRepository.findAll(pageable);
        }

        // Tính toán thống kê cho mỗi khoa
        Map<Long, Map<String, Long>> facultyStats = new HashMap<>();
        for (Faculty faculty : faculties.getContent()) {
            Map<String, Long> stats = new HashMap<>();

            // Số giáo viên thuộc khoa
            Long teacherCount = teacherRepository.countByFacultyId(faculty.getId());
            stats.put("teacherCount", teacherCount);

            // Số ngành thuộc khoa (đơn giản hóa: đếm từ số sinh viên có ngành)
            Long majorCount = 0L; // Tạm thời để 0, sẽ update sau
            stats.put("majorCount", majorCount);

            // Số sinh viên thuộc khoa (tạm thời để 0)
            Long studentCount = 0L; // Tạm thời để 0 do query phức tạp
            stats.put("studentCount", studentCount);

            facultyStats.put(faculty.getId(), stats);
        }

        model.addAttribute("page", faculties);
        model.addAttribute("facultyStats", facultyStats);
        model.addAttribute("q", q);
        model.addAttribute("sort", sort);
        model.addAttribute("dir", dir);

        return "admin/faculties";
    }

    /**
     * Tạo khoa mới
     */
    @PostMapping("/faculties")
    @Transactional
    public String createFaculty(@RequestParam String facultyCode,
            @RequestParam String name,
            @RequestParam(required = false) String description,
            RedirectAttributes ra) {

        // Kiểm tra trùng mã khoa
        if (facultyRepository.existsByFacultyCode(facultyCode.trim())) {
            ra.addFlashAttribute("error", "Mã khoa \"" + facultyCode.trim() + "\" đã tồn tại. Vui lòng chọn mã khác.");
            return "redirect:/admin/faculties/manage";
        }

        // Kiểm tra trùng tên khoa
        if (facultyRepository.existsByName(name.trim())) {
            ra.addFlashAttribute("error", "Tên khoa \"" + name.trim() + "\" đã tồn tại. Vui lòng chọn tên khác.");
            return "redirect:/admin/faculties/manage";
        }

        Faculty faculty = new Faculty(facultyCode.trim(), name.trim(), description != null ? description.trim() : null);
        facultyRepository.save(faculty);

        ra.addFlashAttribute("success", "Thêm khoa thành công.");
        return "redirect:/admin/faculties/manage";
    }

    /**
     * Cập nhật khoa
     */
    @PostMapping("/faculties/{id}")
    @Transactional
    public String updateFaculty(@PathVariable Long id,
            @RequestParam String facultyCode,
            @RequestParam String name,
            @RequestParam(required = false) String description,
            RedirectAttributes ra) {

        Faculty faculty = facultyRepository.findById(id).orElse(null);
        if (faculty == null) {
            ra.addFlashAttribute("error", "Không tìm thấy khoa.");
            return "redirect:/admin/faculties/manage";
        }

        // Kiểm tra trùng mã khoa với khoa khác
        if (facultyRepository.existsByFacultyCodeAndIdNot(facultyCode.trim(), id)) {
            ra.addFlashAttribute("error", "Mã khoa \"" + facultyCode.trim() + "\" đã tồn tại. Vui lòng chọn mã khác.");
            return "redirect:/admin/faculties/manage";
        }

        // Kiểm tra trùng tên khoa với khoa khác
        if (facultyRepository.existsByNameAndIdNot(name.trim(), id)) {
            ra.addFlashAttribute("error", "Tên khoa \"" + name.trim() + "\" đã tồn tại. Vui lòng chọn tên khác.");
            return "redirect:/admin/faculties/manage";
        }

        faculty.setFacultyCode(facultyCode.trim());
        faculty.setName(name.trim());
        faculty.setDescription(description != null ? description.trim() : null);
        facultyRepository.save(faculty);

        ra.addFlashAttribute("success", "Cập nhật khoa thành công.");
        return "redirect:/admin/faculties/manage";
    }

    /**
     * Xóa khoa
     */
    @PostMapping("/faculties/{id}/delete")
    @Transactional
    public String deleteFaculty(@PathVariable Long id, RedirectAttributes ra) {
        Faculty faculty = facultyRepository.findById(id).orElse(null);
        if (faculty == null) {
            ra.addFlashAttribute("error", "Không tìm thấy khoa.");
            return "redirect:/admin/faculties/manage";
        }

        // Kiểm tra xem có giáo viên thuộc khoa này không
        Long teacherCount = teacherRepository.countByFacultyId(id);

        // Kiểm tra xem có ngành học thuộc khoa này không
        Long majorCount = majorRepository.countByFacultyId(id);

        // Kiểm tra xem có sinh viên thuộc khoa này (thông qua ngành) không
        Long studentCount = 0L;
        if (majorCount > 0) {
            // Đếm sinh viên thuộc các ngành của khoa này
            studentCount = studentRepository.countByFacultyId(id);
        }

        // Không cho phép xóa nếu có dữ liệu liên quan
        if (teacherCount > 0 || majorCount > 0 || studentCount > 0) {
            StringBuilder errorMsg = new StringBuilder("Không thể xóa khoa \"" + faculty.getName() + "\" vì còn có: ");

            boolean hasContent = false;
            if (teacherCount > 0) {
                errorMsg.append(teacherCount).append(" giáo viên");
                hasContent = true;
            }
            if (majorCount > 0) {
                if (hasContent)
                    errorMsg.append(", ");
                errorMsg.append(majorCount).append(" ngành học");
                hasContent = true;
            }
            if (studentCount > 0) {
                if (hasContent)
                    errorMsg.append(", ");
                errorMsg.append(studentCount).append(" sinh viên");
            }
            errorMsg.append(" thuộc khoa này.");

            ra.addFlashAttribute("error", errorMsg.toString());
            return "redirect:/admin/faculties/manage";
        }

        try {
            facultyRepository.delete(faculty);
            ra.addFlashAttribute("success", "Xóa khoa \"" + faculty.getName() + "\" thành công.");
        } catch (Exception e) {
            ra.addFlashAttribute("error", "Có lỗi xảy ra khi xóa khoa. Vui lòng thử lại.");
        }

        return "redirect:/admin/faculties/manage";
    }

    /**
     * AJAX endpoint to check faculty code uniqueness
     */
    @GetMapping("/faculties/check-code")
    @ResponseBody
    public Map<String, Boolean> checkFacultyCode(@RequestParam String facultyCode,
            @RequestParam(required = false) Long excludeId) {
        boolean exists = (excludeId == null)
                ? facultyRepository.existsByFacultyCode(facultyCode.trim())
                : facultyRepository.existsByFacultyCodeAndIdNot(facultyCode.trim(), excludeId);

        Map<String, Boolean> response = new HashMap<>();
        response.put("exists", exists);
        return response;
    }

    /**
     * AJAX endpoint to check faculty name uniqueness
     */
    @GetMapping("/faculties/check-name")
    @ResponseBody
    public Map<String, Boolean> checkFacultyName(@RequestParam String name,
            @RequestParam(required = false) Long excludeId) {
        boolean exists = (excludeId == null)
                ? facultyRepository.existsByName(name.trim())
                : facultyRepository.existsByNameAndIdNot(name.trim(), excludeId);

        Map<String, Boolean> response = new HashMap<>();
        response.put("exists", exists);
        return response;
    }

    // ============= MAJOR-SUBJECT MANAGEMENT TAB =============

    /**
     * Tab Ngành - Môn học (Layout 2 panel)
     */
    @GetMapping("/majors")
    public String majorSubjectManagement(Authentication auth, Model model,
            @RequestParam(defaultValue = "") String q,
            @RequestParam(required = false) Long facultyId,
            @RequestParam(required = false) Long selectedMajorId,
            @RequestParam(defaultValue = "") String subjectSearch,
            @RequestParam(defaultValue = "subjectCode") String subjectSort,
            @RequestParam(defaultValue = "asc") String subjectDir,
            @RequestParam(defaultValue = "false") String viewAll) {
        addUserInfo(auth, model);
        model.addAttribute("activeTab", "majors");

        // Lấy danh sách ngành với filter
        List<Major> majors;
        if (q != null && !q.isBlank()) {
            if (facultyId != null) {
                majors = majorRepository.searchByCodeOrNameAndFaculty(q.trim(), facultyId);
            } else {
                majors = majorRepository.searchByCodeOrName(q.trim());
            }
        } else {
            if (facultyId != null) {
                majors = majorRepository.findByFacultyIdWithSubjectCount(facultyId);
            } else {
                majors = majorRepository.findAllWithSubjectCount();
            }
        }

        model.addAttribute("majors", majors);
        model.addAttribute("q", q);
        model.addAttribute("facultyId", facultyId);

        // Thêm danh sách các khoa để tạo/sửa ngành
        model.addAttribute("faculties", facultyRepository.findAllOrderByName());

        // Xử lý chế độ xem môn học
        if (selectedMajorId != null || "true".equals(viewAll)) {
            Major selectedMajor = null;
            if (selectedMajorId != null) {
                selectedMajor = majorRepository.findById(selectedMajorId).orElse(null);
                if (selectedMajor != null) {
                    model.addAttribute("selectedMajor", selectedMajor);
                    model.addAttribute("selectedMajorId", selectedMajorId);
                }
            }

            // Lấy danh sách môn học với sắp xếp
            Sort.Direction direction = "desc".equalsIgnoreCase(subjectDir) ? Sort.Direction.DESC
                    : Sort.Direction.ASC;
            Sort sort = Sort.by(direction, subjectSort);

            List<Subject> subjects;

            // Kiểm tra chế độ xem: theo ngành hoặc tất cả môn học
            if ("true".equals(viewAll)) {
                // Chế độ xem tất cả môn học
                if (subjectSearch != null && !subjectSearch.isBlank()) {
                    subjects = subjectRepository.findAllBySearchWithSort(subjectSearch.trim(), sort);
                } else {
                    subjects = subjectRepository.findAll(sort);
                }
            } else if (selectedMajor != null) {
                // Chế độ xem theo ngành đã chọn
                if (subjectSearch != null && !subjectSearch.isBlank()) {
                    subjects = subjectRepository.findByMajorIdAndSearchWithSort(selectedMajorId,
                            subjectSearch.trim(), sort);
                } else {
                    subjects = subjectRepository.findByMajorIdWithSort(selectedMajorId, sort);
                }
            } else {
                // Trường hợp không có ngành được chọn
                subjects = new ArrayList<>();
            }

            model.addAttribute("subjects", subjects);
            model.addAttribute("viewAll", viewAll);

            // Debug log
            System.out.println("DEBUG: viewAll=" + viewAll + ", selectedMajorId=" + selectedMajorId + ", subjects.size="
                    + subjects.size());
        }

        return "admin/majors";
    }

    /**
     * Tạo môn học mới cho ngành đã chọn
     */
    @PostMapping("/majors/{majorId}/subjects")
    @Transactional
    public String createSubject(@PathVariable Long majorId,
            @RequestParam String subjectCode,
            @RequestParam String subjectName,
            @RequestParam(defaultValue = "0") int credit,
            RedirectAttributes ra) {

        Major major = majorRepository.findById(majorId).orElse(null);
        if (major == null) {
            ra.addFlashAttribute("error", "Không tìm thấy ngành.");
            return "redirect:/admin/majors";
        }

        // Kiểm tra trùng mã môn học
        if (subjectRepository.existsBySubjectCode(subjectCode.trim())) {
            ra.addFlashAttribute("error", "Mã môn học đã tồn tại.");
            return "redirect:/admin/majors?selectedMajorId=" + majorId;
        }

        Subject subject = new Subject();
        subject.setSubjectCode(subjectCode.trim());
        subject.setSubjectName(subjectName.trim());
        subject.setCredit(credit);

        // Lưu subject trước để có ID
        subject = subjectRepository.save(subject);

        // Thêm vào ngành
        List<Subject> subjects = major.getSubjects();
        if (subjects == null) {
            subjects = new ArrayList<>();
            major.setSubjects(subjects);
        }
        subjects.add(subject);
        majorRepository.save(major);

        ra.addFlashAttribute("success", "Thêm môn học thành công.");
        return "redirect:/admin/majors?selectedMajorId=" + majorId;
    }

    /**
     * Get available subjects that are not in the specified major
     */
    @GetMapping("/majors/{majorId}/available-subjects")
    @ResponseBody
    public List<Subject> getAvailableSubjects(@PathVariable Long majorId) {
        try {
            // Get all subjects that are not in this major
            return subjectRepository.findSubjectsNotInMajor(majorId);
        } catch (Exception e) {
            logger.error("Error getting available subjects for major {}: {}", majorId, e.getMessage());
            return new ArrayList<>();
        }
    }

    /**
     * Add existing subjects to a major
     */
    @PostMapping("/majors/{majorId}/add-subjects")
    @Transactional
    public String addSubjectsToMajor(@PathVariable Long majorId,
            @RequestParam List<Long> subjectIds,
            RedirectAttributes redirectAttributes) {
        try {
            Major major = majorRepository.findById(majorId)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy ngành học"));

            List<Subject> subjects = subjectRepository.findAllById(subjectIds);
            int addedCount = 0;

            for (Subject subject : subjects) {
                if (subject.getMajors() == null) {
                    subject.setMajors(new ArrayList<>());
                }
                if (major.getSubjects() == null) {
                    major.setSubjects(new ArrayList<>());
                }
                if (!subject.getMajors().contains(major)) {
                    subject.getMajors().add(major);
                    major.getSubjects().add(subject);
                    addedCount++;
                }
            }

            if (addedCount > 0) {
                majorRepository.save(major);
            }

            redirectAttributes.addFlashAttribute("success",
                    "Đã thêm " + addedCount + " môn học vào ngành " + major.getMajorName());

        } catch (Exception e) {
            logger.error("Error adding subjects to major {}: {}", majorId, e.getMessage());
            redirectAttributes.addFlashAttribute("error", "Lỗi khi thêm môn học: " + e.getMessage());
        }

        return "redirect:/admin/majors?selectedMajorId=" + majorId;
    }

    /**
     * Cập nhật môn học
     */
    @PostMapping("/subjects/{subjectId}")
    @Transactional
    public String updateSubject(@PathVariable Long subjectId,
            @RequestParam(required = false) Long majorId,
            @RequestParam String subjectCode,
            @RequestParam String subjectName,
            @RequestParam(defaultValue = "0") int credit,
            RedirectAttributes ra) {

        Subject subject = subjectRepository.findById(subjectId).orElse(null);
        if (subject == null) {
            ra.addFlashAttribute("error", "Không tìm thấy môn học.");
            return majorId != null ? "redirect:/admin/majors?selectedMajorId=" + majorId : "redirect:/admin/majors";
        }

        // Kiểm tra trùng mã môn học với các môn khác
        Subject existingSubject = subjectRepository.findBySubjectCode(subjectCode.trim()).orElse(null);
        if (existingSubject != null && !existingSubject.getId().equals(subjectId)) {
            ra.addFlashAttribute("error", "Mã môn học đã tồn tại.");
            return majorId != null ? "redirect:/admin/majors?selectedMajorId=" + majorId : "redirect:/admin/majors";
        }

        subject.setSubjectCode(subjectCode.trim());
        subject.setSubjectName(subjectName.trim());
        subject.setCredit(credit);

        subjectRepository.save(subject);

        ra.addFlashAttribute("success", "Cập nhật môn học thành công.");
        return majorId != null ? "redirect:/admin/majors?selectedMajorId=" + majorId : "redirect:/admin/majors";
    }

    /**
     * Xóa môn học khỏi ngành
     */
    @PostMapping("/majors/{majorId}/subjects/{subjectId}/remove")
    @Transactional
    public String removeSubjectFromMajor(@PathVariable Long majorId,
            @PathVariable Long subjectId,
            RedirectAttributes ra) {

        Major major = majorRepository.findById(majorId).orElse(null);
        Subject subject = subjectRepository.findById(subjectId).orElse(null);

        if (major == null || subject == null) {
            ra.addFlashAttribute("error", "Không tìm thấy ngành hoặc môn học.");
            return "redirect:/admin/majors?selectedMajorId=" + majorId;
        }

        // Kiểm tra xem có điểm số nào liên quan không
        Long scoreCount = scoreRepository.countBySubjectId(subjectId);
        if (scoreCount > 0) {
            ra.addFlashAttribute("error", "Không thể xóa môn học vì còn có " + scoreCount + " điểm số liên quan.");
            return "redirect:/admin/majors?selectedMajorId=" + majorId;
        }

        // Xóa môn học khỏi ngành
        major.getSubjects().remove(subject);
        subject.getMajors().remove(major);

        majorRepository.save(major);

        // Nếu môn học không còn thuộc ngành nào thì xóa hoàn toàn
        if (subject.getMajors().isEmpty()) {
            subjectRepository.delete(subject);
        } else {
            subjectRepository.save(subject);
        }

        ra.addFlashAttribute("success", "Xóa môn học khỏi ngành thành công.");
        return "redirect:/admin/majors?selectedMajorId=" + majorId;
    }

    /**
     * Thêm môn học có sẵn vào ngành
     */
    @PostMapping("/majors/{majorId}/subjects/add-existing")
    @Transactional
    public String addExistingSubjectToMajor(@PathVariable Long majorId,
            @RequestParam Long subjectId,
            RedirectAttributes ra) {

        Major major = majorRepository.findById(majorId).orElse(null);
        Subject subject = subjectRepository.findById(subjectId).orElse(null);

        if (major == null || subject == null) {
            ra.addFlashAttribute("error", "Không tìm thấy ngành hoặc môn học.");
            return "redirect:/admin/majors?selectedMajorId=" + majorId;
        }

        // Kiểm tra xem môn học đã thuộc ngành chưa
        if (major.getSubjects().contains(subject)) {
            ra.addFlashAttribute("error", "Môn học đã thuộc ngành này.");
            return "redirect:/admin/majors?selectedMajorId=" + majorId;
        }

        major.getSubjects().add(subject);
        subject.getMajors().add(major);

        majorRepository.save(major);

        ra.addFlashAttribute("success", "Thêm môn học vào ngành thành công.");
        return "redirect:/admin/majors?selectedMajorId=" + majorId;
    }

    /**
     * Tạo ngành học mới
     */
    @PostMapping("/majors")
    public String createMajor(@RequestParam String majorCode,
            @RequestParam String majorName,
            @RequestParam(required = false) String description,
            @RequestParam Long facultyId,
            RedirectAttributes ra) {
        try {
            // Kiểm tra faculty tồn tại
            Faculty faculty = facultyRepository.findById(facultyId).orElse(null);
            if (faculty == null) {
                ra.addFlashAttribute("error", "Không tìm thấy khoa");
                return "redirect:/admin/majors";
            }

            // Kiểm tra mã ngành đã tồn tại chưa
            if (majorRepository.existsByMajorCode(majorCode)) {
                ra.addFlashAttribute("error", "Mã ngành \"" + majorCode + "\" đã tồn tại. Vui lòng chọn mã khác.");
                return "redirect:/admin/majors";
            }

            // Tạo ngành mới
            Major major = new Major();
            major.setMajorCode(majorCode);
            major.setMajorName(majorName);
            major.setDescription(description);
            major.setFaculty(faculty);

            majorRepository.save(major);

            ra.addFlashAttribute("success", "Thêm ngành học thành công");
            return "redirect:/admin/majors";
        } catch (Exception e) {
            ra.addFlashAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            return "redirect:/admin/majors";
        }
    }

    /**
     * Cập nhật ngành học
     */
    @PostMapping("/majors/edit")
    public String updateMajor(@RequestParam Long id,
            @RequestParam String majorCode,
            @RequestParam String majorName,
            @RequestParam(required = false) String description,
            @RequestParam Long facultyId,
            RedirectAttributes ra) {
        try {
            Major major = majorRepository.findById(id).orElse(null);
            if (major == null) {
                ra.addFlashAttribute("error", "Không tìm thấy ngành học");
                return "redirect:/admin/majors";
            }

            // Kiểm tra faculty tồn tại
            Faculty faculty = facultyRepository.findById(facultyId).orElse(null);
            if (faculty == null) {
                ra.addFlashAttribute("error", "Không tìm thấy khoa");
                return "redirect:/admin/majors";
            }

            // Kiểm tra mã ngành đã tồn tại ở ngành khác chưa
            if (majorRepository.existsByMajorCodeAndIdNot(majorCode, id)) {
                ra.addFlashAttribute("error", "Mã ngành \"" + majorCode + "\" đã tồn tại. Vui lòng chọn mã khác.");
                return "redirect:/admin/majors";
            }

            // Cập nhật thông tin ngành
            major.setMajorCode(majorCode);
            major.setMajorName(majorName);
            major.setDescription(description);
            major.setFaculty(faculty);

            majorRepository.save(major);

            ra.addFlashAttribute("success", "Cập nhật ngành học thành công");
            return "redirect:/admin/majors";
        } catch (Exception e) {
            ra.addFlashAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            return "redirect:/admin/majors";
        }
    }

    /**
     * Xóa ngành học
     */
    @PostMapping("/majors/delete")
    @Transactional
    public String deleteMajor(@RequestParam Long id, RedirectAttributes ra) {
        try {
            Major major = majorRepository.findById(id).orElse(null);
            if (major == null) {
                ra.addFlashAttribute("error", "Không tìm thấy ngành học");
                return "redirect:/admin/majors";
            }

            // Kiểm tra xem có sinh viên nào thuộc ngành này không
            long studentCount = studentRepository.countByMajorId(id);
            if (studentCount > 0) {
                ra.addFlashAttribute("error",
                        "Không thể xóa ngành học vì có " + studentCount + " sinh viên thuộc ngành này");
                return "redirect:/admin/majors";
            }

            // Xóa các mối quan hệ với môn học trước
            if (major.getSubjects() != null) {
                major.getSubjects().clear();
                majorRepository.save(major);
            }

            // Xóa ngành học
            majorRepository.delete(major);

            ra.addFlashAttribute("success", "Xóa ngành học thành công");
            return "redirect:/admin/majors";
        } catch (Exception e) {
            ra.addFlashAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            return "redirect:/admin/majors";
        }
    }

    /**
     * Lấy thống kê của ngành học
     */
    @GetMapping("/majors/{majorId}/statistics")
    @ResponseBody
    public Map<String, Object> getMajorStatistics(@PathVariable Long majorId) {
        Map<String, Object> statistics = new HashMap<>();

        try {
            Major major = majorRepository.findById(majorId).orElse(null);
            if (major != null) {
                // Đếm số môn học
                int subjectCount = major.getSubjects() != null ? major.getSubjects().size() : 0;

                // Tính tổng tín chỉ
                int totalCredits = 0;
                if (major.getSubjects() != null) {
                    totalCredits = major.getSubjects().stream()
                            .mapToInt(subject -> subject.getCredit() != null ? subject.getCredit() : 0)
                            .sum();
                }

                statistics.put("subjectCount", subjectCount);
                statistics.put("totalCredits", totalCredits);
            } else {
                statistics.put("subjectCount", 0);
                statistics.put("totalCredits", 0);
            }
        } catch (Exception e) {
            statistics.put("subjectCount", 0);
            statistics.put("totalCredits", 0);
        }

        return statistics;
    }

    /**
     * Cập nhật môn học
     */
    @PostMapping("/subjects/edit")
    @Transactional
    public String editSubject(@RequestParam Long id,
            @RequestParam(required = false) Long majorId,
            @RequestParam String subjectCode,
            @RequestParam String subjectName,
            @RequestParam int credit,
            @RequestParam(required = false, defaultValue = "10") Float attendanceWeight,
            @RequestParam(required = false, defaultValue = "30") Float midtermWeight,
            @RequestParam(required = false, defaultValue = "60") Float finalWeight,
            RedirectAttributes ra) {
        try {
            Subject subject = subjectRepository.findById(id).orElse(null);
            if (subject == null) {
                ra.addFlashAttribute("error", "Không tìm thấy môn học");
                return majorId != null ? "redirect:/admin/majors?selectedMajorId=" + majorId : "redirect:/admin/majors";
            }

            // Kiểm tra mã môn học đã tồn tại ở môn khác chưa
            Subject existingSubject = subjectRepository.findBySubjectCode(subjectCode).orElse(null);
            if (existingSubject != null && !existingSubject.getId().equals(id)) {
                ra.addFlashAttribute("error", "Mã môn học đã tồn tại");
                return majorId != null ? "redirect:/admin/majors?selectedMajorId=" + majorId : "redirect:/admin/majors";
            }

            // Kiểm tra tổng hệ số
            float totalWeight = attendanceWeight + midtermWeight + finalWeight;
            if (Math.abs(totalWeight - 100.0f) > 0.1f) {
                ra.addFlashAttribute("error", "Tổng hệ số điểm phải bằng 100%");
                return majorId != null ? "redirect:/admin/majors?selectedMajorId=" + majorId : "redirect:/admin/majors";
            }

            // Cập nhật thông tin môn học
            subject.setSubjectCode(subjectCode);
            subject.setSubjectName(subjectName);
            subject.setCredit(credit);
            // Chuyển đổi từ % về dạng thập phân
            subject.setAttendanceWeight(attendanceWeight / 100.0f);
            subject.setMidtermWeight(midtermWeight / 100.0f);
            subject.setFinalWeight(finalWeight / 100.0f);

            subjectRepository.save(subject);

            // Cập nhật lại điểm trung bình cho tất cả điểm của môn học này
            updateScoresForSubject(subject);

            ra.addFlashAttribute("success", "Cập nhật môn học thành công");
            return majorId != null ? "redirect:/admin/majors?selectedMajorId=" + majorId : "redirect:/admin/majors";
        } catch (Exception e) {
            ra.addFlashAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            return majorId != null ? "redirect:/admin/majors?selectedMajorId=" + majorId : "redirect:/admin/majors";
        }
    }

    /**
     * Xóa môn học
     */
    @PostMapping("/subjects/delete")
    @Transactional
    public String deleteSubject(@RequestParam Long id,
            @RequestParam(required = false) Long majorId,
            RedirectAttributes ra) {
        try {
            Subject subject = subjectRepository.findById(id).orElse(null);
            if (subject == null) {
                ra.addFlashAttribute("error", "Không tìm thấy môn học");
                return majorId != null ? "redirect:/admin/majors?selectedMajorId=" + majorId : "redirect:/admin/majors";
            }

            // Kiểm tra xem môn học có đang thuộc ngành nào không
            long majorCount = majorRepository.countBySubjectsContaining(subject);
            if (majorCount > 0) {
                ra.addFlashAttribute("error", "Không thể xóa môn học vì đang thuộc " + majorCount
                        + " ngành học. Hãy gỡ môn học khỏi tất cả ngành trước khi xóa.");
                return majorId != null ? "redirect:/admin/majors?selectedMajorId=" + majorId : "redirect:/admin/majors";
            }

            // Kiểm tra xem có điểm số nào liên quan không
            long scoreCount = scoreRepository.countBySubjectId(id);
            if (scoreCount > 0) {
                ra.addFlashAttribute("error", "Không thể xóa môn học vì có " + scoreCount + " điểm số liên quan");
                return majorId != null ? "redirect:/admin/majors?selectedMajorId=" + majorId : "redirect:/admin/majors";
            }

            // Xóa môn học
            subjectRepository.delete(subject);

            ra.addFlashAttribute("success", "Xóa môn học thành công");
            return majorId != null ? "redirect:/admin/majors?selectedMajorId=" + majorId : "redirect:/admin/majors";
        } catch (Exception e) {
            ra.addFlashAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            return majorId != null ? "redirect:/admin/majors?selectedMajorId=" + majorId : "redirect:/admin/majors";
        }
    }

    // ===============================
    // SCORES MANAGEMENT
    // ===============================

    /**
     * Quản lý điểm sinh viên (Admin)
     */
    @GetMapping("/scores")
    public String manageScores(Authentication auth, Model model,
            @RequestParam(required = false) Long classroomId,
            @RequestParam(required = false) Long subjectId,
            @RequestParam(required = false) String search) {

        // Lấy tất cả lớp học
        List<Classroom> allClasses = classroomRepository.findAll();

        // Lấy tất cả môn học
        List<Subject> subjects = subjectRepository.findAll();

        // Nếu có chọn lớp cụ thể
        List<Student> students = new ArrayList<>();
        List<com.StudentManagement.entity.Score> scores = new ArrayList<>();

        if (classroomId != null) {
            students = studentRepository.findByClassroomId(classroomId);

            if (subjectId != null) {
                // Lọc điểm theo môn học cụ thể
                scores = scoreRepository.findByStudentClassroomIdAndSubjectId(classroomId, subjectId);
            } else {
                // Lấy tất cả điểm của lớp (tất cả môn học)
                Page<com.StudentManagement.entity.Score> scorePages = scoreRepository.findByClassroomId(classroomId,
                        Pageable.unpaged());
                scores = scorePages.getContent();
            }
        } else {
            // Tất cả lớp - lấy tất cả sinh viên và điểm
            for (Classroom classroom : allClasses) {
                students.addAll(studentRepository.findByClassroomId(classroom.getId()));

                if (subjectId != null) {
                    // Lọc điểm theo môn học cụ thể cho tất cả lớp
                    scores.addAll(scoreRepository.findByStudentClassroomIdAndSubjectId(classroom.getId(), subjectId));
                } else {
                    // Lấy tất cả điểm của tất cả lớp
                    Page<com.StudentManagement.entity.Score> scorePages = scoreRepository
                            .findByClassroomId(classroom.getId(), Pageable.unpaged());
                    scores.addAll(scorePages.getContent());
                }
            }
        }

        // Lọc sinh viên theo tìm kiếm nếu có
        if (search != null && !search.trim().isEmpty()) {
            String searchTerm = search.trim().toLowerCase();
            students = students.stream()
                    .filter(student -> student.getUser().getUsername().toLowerCase().contains(searchTerm) ||
                            (student.getUser().getFname() + " " + student.getUser().getLname()).toLowerCase()
                                    .contains(searchTerm))
                    .collect(java.util.stream.Collectors.toList());

            // Lọc điểm tương ứng với sinh viên đã lọc
            List<Long> filteredStudentIds = students.stream()
                    .map(Student::getId)
                    .collect(java.util.stream.Collectors.toList());

            scores = scores.stream()
                    .filter(score -> filteredStudentIds.contains(score.getStudent().getId()))
                    .collect(java.util.stream.Collectors.toList());
        }

        model.addAttribute("assignedClasses", allClasses);
        model.addAttribute("subjects", subjects);
        model.addAttribute("students", students);
        model.addAttribute("scores", scores);
        model.addAttribute("selectedClassroomId", classroomId);
        model.addAttribute("selectedSubjectId", subjectId);
        model.addAttribute("search", search);
        model.addAttribute("activeTab", "scores");

        // Thêm thông tin user cho header
        String firstName = "User";
        String roleDisplay = "Người dùng";
        if (auth != null) {
            Optional<User> u = userRepository.findByUsername(auth.getName());
            if (u.isPresent()) {
                firstName = (u.get().getFname() != null && !u.get().getFname().isBlank()) ? u.get().getFname()
                        : u.get().getUsername();
                roleDisplay = switch (u.get().getRole()) {
                    case ADMIN -> "Quản trị viên";
                    case TEACHER -> "Giáo viên";
                    case STUDENT -> "Sinh viên";
                };
            }
        }
        model.addAttribute("firstName", firstName);
        model.addAttribute("roleDisplay", roleDisplay);

        return "admin/scores";
    }

    /**
     * Export bảng điểm ra PDF
     */
    @GetMapping("/scores/export-pdf")
    public ResponseEntity<byte[]> exportScoresPdf(
            @RequestParam(required = false) Long classroomId,
            @RequestParam(required = false) Long subjectId,
            @RequestParam(required = false) String search) {

        try {
            // Lấy tất cả lớp học
            List<Classroom> allClasses = classroomRepository.findAll();

            // Lấy tất cả môn học
            List<Subject> subjects = subjectRepository.findAll();

            // Logic tương tự như manageScores để lấy dữ liệu cần export
            List<Student> students = new ArrayList<>();
            List<com.StudentManagement.entity.Score> scores = new ArrayList<>();

            if (classroomId != null) {
                students = studentRepository.findByClassroomId(classroomId);

                if (subjectId != null) {
                    scores = scoreRepository.findByStudentClassroomIdAndSubjectId(classroomId, subjectId);
                } else {
                    Page<com.StudentManagement.entity.Score> scorePages = scoreRepository.findByClassroomId(classroomId,
                            Pageable.unpaged());
                    scores = scorePages.getContent();
                }
            } else {
                for (Classroom classroom : allClasses) {
                    students.addAll(studentRepository.findByClassroomId(classroom.getId()));

                    if (subjectId != null) {
                        scores.addAll(
                                scoreRepository.findByStudentClassroomIdAndSubjectId(classroom.getId(), subjectId));
                    } else {
                        Page<com.StudentManagement.entity.Score> scorePages = scoreRepository
                                .findByClassroomId(classroom.getId(), Pageable.unpaged());
                        scores.addAll(scorePages.getContent());
                    }
                }
            }

            // Lọc theo tìm kiếm nếu có
            if (search != null && !search.trim().isEmpty()) {
                String searchTerm = search.trim().toLowerCase();
                students = students.stream()
                        .filter(student -> student.getUser().getUsername().toLowerCase().contains(searchTerm) ||
                                (student.getUser().getFname() + " " + student.getUser().getLname()).toLowerCase()
                                        .contains(searchTerm))
                        .collect(java.util.stream.Collectors.toList());

                List<Long> filteredStudentIds = students.stream()
                        .map(Student::getId)
                        .collect(java.util.stream.Collectors.toList());

                scores = scores.stream()
                        .filter(score -> filteredStudentIds.contains(score.getStudent().getId()))
                        .collect(java.util.stream.Collectors.toList());
            }

            // Lấy tên lớp và môn học
            String classroomName = null;
            String subjectName = null;

            if (classroomId != null) {
                Optional<Classroom> classroom = classroomRepository.findById(classroomId);
                if (classroom.isPresent()) {
                    classroomName = classroom.get().getClassCode();
                }
            }

            if (subjectId != null) {
                Optional<Subject> subject = subjectRepository.findById(subjectId);
                if (subject.isPresent()) {
                    subjectName = subject.get().getSubjectName();
                }
            }

            // Tạo PDF
            byte[] pdfData = pdfService.generateScoresPdf(scores, classroomId, subjectId, classroomName, subjectName);

            // Tạo tên file
            String fileName = "BangDiem";
            if (classroomName != null) {
                fileName += "_" + classroomName.replaceAll("[^\\w\\s-]", "");
            }
            if (subjectName != null) {
                fileName += "_" + subjectName.replaceAll("[^\\w\\s-]", "");
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
            // Log error
            e.printStackTrace();
            return ResponseEntity.internalServerError().build();
        }
    }

    /**
     * Cập nhật điểm sinh viên (Admin)
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

        try {
            // Lấy thông tin user hiện tại
            String username = auth.getName();
            Optional<User> currentUserOpt = userRepository.findByUsername(username);
            User currentUser = null;
            if (currentUserOpt.isPresent()) {
                currentUser = currentUserOpt.get();
            }

            // Tìm điểm hiện tại hoặc tạo mới
            Optional<com.StudentManagement.entity.Score> existingScore = scoreRepository
                    .findByStudentIdAndSubjectId(studentId, subjectId);
            com.StudentManagement.entity.Score score;
            boolean isNewScore = false;

            if (existingScore.isPresent()) {
                score = existingScore.get();
            } else {
                score = new com.StudentManagement.entity.Score();
                score.setStudent(studentRepository.findById(studentId).orElse(null));
                score.setSubject(subjectRepository.findById(subjectId).orElse(null));
                isNewScore = true;
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
            if (notes != null) {
                score.setNotes(notes);
            }

            // Lưu điểm
            score = scoreRepository.save(score);

            // Tạo lịch sử thay đổi
            if (currentUser != null) {
                ScoreHistory.ActionType actionType = isNewScore ? ScoreHistory.ActionType.CREATE
                        : ScoreHistory.ActionType.UPDATE;
                String changeDescription = isNewScore ? "Tạo điểm mới" : "Cập nhật điểm";

                ScoreHistory history = new ScoreHistory(score, currentUser, actionType, changeDescription);
                scoreHistoryRepository.save(history);
            }

            ra.addFlashAttribute("success", "Cập nhật điểm thành công");

        } catch (Exception e) {
            ra.addFlashAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
        }

        return "redirect:/admin/scores";
    }

    /**
     * Lấy lịch sử thay đổi điểm (AJAX endpoint)
     */
    @GetMapping("/scores/history/{scoreId}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getScoreHistory(@PathVariable Long scoreId) {
        try {
            // Tìm điểm số
            Optional<com.StudentManagement.entity.Score> scoreOpt = scoreRepository.findById(scoreId);
            if (!scoreOpt.isPresent()) {
                return ResponseEntity.notFound().build();
            }

            com.StudentManagement.entity.Score score = scoreOpt.get();

            // Lấy lịch sử thay đổi điểm
            List<ScoreHistory> histories = scoreHistoryRepository.findByScoreIdOrderByChangedAtDesc(scoreId);

            // Tạo response data
            Map<String, Object> response = new HashMap<>();
            response.put("score", Map.of(
                    "id", score.getId(),
                    "student", Map.of(
                            "name",
                            score.getStudent().getUser().getFname() + " " + score.getStudent().getUser().getLname(),
                            "studentId", score.getStudent().getId()),
                    "subject", Map.of(
                            "name", score.getSubject().getSubjectName(),
                            "subjectId", score.getSubject().getSubjectCode())));

            // Convert histories to simplified format for JSON
            List<Map<String, Object>> historyData = new ArrayList<>();
            for (ScoreHistory history : histories) {
                Map<String, Object> historyItem = new HashMap<>();
                historyItem.put("id", history.getId());
                historyItem.put("actionType", history.getActionType().toString());
                historyItem.put("attendanceScore", history.getAttendanceScore());
                historyItem.put("midtermScore", history.getMidtermScore());
                historyItem.put("finalScore", history.getFinalScore());
                historyItem.put("averageScore", history.getAvgScore());
                historyItem.put("changeDescription", history.getChangeDescription());
                historyItem.put("changedAt", history.getChangedAt());
                historyItem.put("changedBy", Map.of(
                        "name",
                        history.getChangedByUser().getFname() + " " + history.getChangedByUser().getLname(),
                        "username", history.getChangedByUser().getUsername()));
                historyData.add(historyItem);
            }

            response.put("histories", historyData);

            return ResponseEntity.ok(response);

        } catch (Exception e) {
            logger.error("Error loading score history for scoreId: " + scoreId, e);
            return ResponseEntity.status(500).body(Map.of("error", "Có lỗi xảy ra khi tải lịch sử điểm"));
        }
    }

    /**
     * Validate course year format YYYY-YYYY
     */
    private boolean isValidCourseYearFormat(String courseYear) {
        if (courseYear == null || courseYear.trim().isEmpty()) {
            return false;
        }

        // Pattern: YYYY-YYYY (e.g., 2023-2027)
        String pattern = "^\\d{4}-\\d{4}$";
        if (!courseYear.matches(pattern)) {
            return false;
        }

        // Extract start and end years
        String[] years = courseYear.split("-");
        try {
            int startYear = Integer.parseInt(years[0]);
            int endYear = Integer.parseInt(years[1]);

            // Validate logical years (end year should be after start year)
            if (endYear <= startYear) {
                return false;
            }

            // Validate reasonable year range (current year ± 20 years)
            int currentYear = java.time.Year.now().getValue();
            if (startYear < currentYear - 20 || startYear > currentYear + 20) {
                return false;
            }

            return true;
        } catch (NumberFormatException e) {
            return false;
        }
    }

    // ===============================
    // CLASSROOM DETAILS & HISTORY
    // ===============================

    /**
     * Xem chi tiết lớp học và lịch sử chủ nhiệm
     */
    @GetMapping("/classrooms/{classroomId}/details")
    public String viewClassroomDetails(@PathVariable Long classroomId, Model model) {
        try {
            // Lấy thông tin lớp học
            Classroom classroom = classroomRepository.findById(classroomId)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy lớp học"));

            // Lấy danh sách sinh viên trong lớp
            List<Student> students = studentRepository.findByClassroomId(classroomId);

            // Lấy lịch sử giáo viên chủ nhiệm
            List<com.StudentManagement.entity.ClassroomTeacher> teacherHistory = classroomTeacherService
                    .getHomeRoomTeacherHistory(classroomId);

            // Lấy giáo viên chủ nhiệm hiện tại
            Optional<com.StudentManagement.entity.ClassroomTeacher> currentTeacher = classroomTeacherService
                    .getCurrentHomeRoomTeacher(classroomId);

            // Thống kê nhanh
            model.addAttribute("classroom", classroom);
            model.addAttribute("students", students);
            model.addAttribute("studentCount", students.size());
            model.addAttribute("teacherHistory", teacherHistory);
            model.addAttribute("currentTeacher", currentTeacher.orElse(null));
            model.addAttribute("activeTab", "classrooms");

            // Thêm date formatter helper cho JSP
            model.addAttribute("dateFormatter", new DateFormatHelper());

            return "admin/classroom-details";

        } catch (Exception e) {
            model.addAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            return "redirect:/admin/classrooms";
        }
    }

    // Kiểm tra xem giáo viên có khác nhau không
    private boolean isTeacherSame(Teacher oldTeacher, Teacher newTeacher) {
        if (oldTeacher == null && newTeacher == null) {
            return true;
        }
        if (oldTeacher == null || newTeacher == null) {
            return false;
        }
        return oldTeacher.getId().equals(newTeacher.getId());
    }

    // Cập nhật lịch sử chủ nhiệm
    private void updateTeacherHistory(Classroom classroom, Teacher newTeacher, String notes) {
        try {
            if (newTeacher != null) {
                classroomTeacherService.assignHomeRoomTeacher(classroom.getId(), newTeacher.getId(), notes);
            } else {
                // Nếu gỡ bỏ giáo viên chủ nhiệm, chỉ cần kết thúc lịch sử hiện tại
                classroomTeacherService.endHomeRoomAssignment(classroom.getId(), notes);
            }
        } catch (Exception e) {
            System.out.println("Warning: Could not update teacher history: " + e.getMessage());
            // Không throw exception để không làm gián đoạn việc cập nhật chính
        }
    }

    // API lấy danh sách mã ngành duy nhất
    @GetMapping("/api/major-codes")
    @ResponseBody
    public ResponseEntity<List<String>> getMajorCodes() {
        try {
            List<String> majorCodes = majorRepository.findDistinctMajorCodes();
            return ResponseEntity.ok(majorCodes);
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }

    // API lấy chi tiết ngành học
    @GetMapping("/api/major-details/{majorId}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getMajorDetails(@PathVariable Long majorId) {
        try {
            Optional<Major> majorOpt = majorRepository.findById(majorId);
            if (majorOpt.isEmpty()) {
                return ResponseEntity.notFound().build();
            }

            Major major = majorOpt.get();
            Map<String, Object> response = new HashMap<>();

            // Basic info
            response.put("majorCode", major.getMajorCode());
            response.put("majorName", major.getMajorName());
            response.put("description", major.getDescription());
            response.put("faculty", major.getFaculty() != null ? major.getFaculty().getName() : "Chưa phân khoa");

            // Subject statistics
            List<Subject> subjects = major.getSubjects();
            response.put("subjectCount", subjects.size());

            int totalCredits = subjects.stream()
                    .mapToInt(Subject::getCredit)
                    .sum();
            response.put("totalCredits", totalCredits);

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }

    // API lấy thông tin ngành theo mã ngành
    @GetMapping("/api/major")
    @ResponseBody
    public ResponseEntity<Major> getMajorByCode(@RequestParam String majorCode) {
        try {
            List<Major> majors = majorRepository.findByMajorCode(majorCode);
            if (!majors.isEmpty()) {
                return ResponseEntity.ok(majors.get(0));
            }
            return ResponseEntity.notFound().build();
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }

    @GetMapping("/students/api/all")
    @ResponseBody
    public ResponseEntity<List<Map<String, Object>>> getAllStudentsApi() {
        try {
            List<Student> students = studentRepository.findAll(Sort.by("user.username"));
            List<Map<String, Object>> result = new ArrayList<>();

            for (Student student : students) {
                Map<String, Object> studentData = new HashMap<>();
                studentData.put("id", student.getId());
                studentData.put("username", student.getUser().getUsername());
                studentData.put("fname", student.getUser().getFname());
                studentData.put("lname", student.getUser().getLname());
                studentData.put("email", student.getUser().getEmail());

                if (student.getClassroom() != null) {
                    studentData.put("classroomId", student.getClassroom().getId());
                    studentData.put("classroomName", student.getClassroom().getClassCode());
                } else {
                    studentData.put("classroomId", null);
                    studentData.put("classroomName", null);
                }

                if (student.getMajor() != null) {
                    studentData.put("majorId", student.getMajor().getId());
                    studentData.put("majorName", student.getMajor().getMajorName());
                } else {
                    studentData.put("majorId", null);
                    studentData.put("majorName", null);
                }

                result.add(studentData);
            }

            return ResponseEntity.ok(result);
        } catch (Exception e) {
            logger.error("Error fetching students API", e);
            return ResponseEntity.badRequest().build();
        }
    }

    /**
     * Cập nhật lại điểm trung bình cho tất cả điểm của môn học khi thay đổi hệ số
     */
    @Transactional
    private void updateScoresForSubject(Subject subject) {
        try {
            // Lấy tất cả điểm của môn học này
            List<Score> scores = scoreRepository.findBySubjectId(subject.getId());

            for (Score score : scores) {
                // Tính lại điểm trung bình với hệ số mới
                score.updateAvgScore();
                scoreRepository.save(score);
            }

            logger.info("Updated {} scores for subject {}", scores.size(), subject.getSubjectCode());
        } catch (Exception e) {
            logger.error("Error updating scores for subject {}: {}", subject.getSubjectCode(), e.getMessage());
        }
    }

    @PostMapping("/update-profile")
    public String updateProfile(@RequestParam("username") String username,
            @RequestParam("fullName") String fullName,
            @RequestParam("email") String email,
            @RequestParam(value = "phone", required = false) String phone,
            @RequestParam(value = "address", required = false) String address,
            @RequestParam(value = "birthDate", required = false) String birthDate,
            Authentication authentication,
            RedirectAttributes redirectAttributes) {
        try {
            // Get current user
            String currentUsername = authentication.getName();
            User user = userRepository.findByUsername(currentUsername).orElse(null);

            if (user == null) {
                redirectAttributes.addFlashAttribute("error", "Không tìm thấy tài khoản");
                return "redirect:/admin/overview";
            }

            // Check if email is already used by another user
            if (!user.getEmail().equals(email)) {
                User existingUser = userRepository.findByEmail(email).orElse(null);
                if (existingUser != null && !existingUser.getId().equals(user.getId())) {
                    redirectAttributes.addFlashAttribute("error", "Email này đã được sử dụng bởi tài khoản khác");
                    return "redirect:/admin/overview";
                }
            }

            // Update user information - split fullName into fname and lname
            String[] nameParts = fullName.trim().split("\\s+", 2);
            if (nameParts.length == 1) {
                user.setFname(nameParts[0]);
                user.setLname("");
            } else {
                user.setFname(nameParts[0]);
                user.setLname(nameParts[1]);
            }

            user.setEmail(email);
            user.setPhone(phone);
            user.setAddress(address);

            // Parse and set birth date
            if (birthDate != null && !birthDate.trim().isEmpty()) {
                try {
                    user.setBirthDate(java.time.LocalDate.parse(birthDate));
                } catch (Exception e) {
                    logger.warn("Invalid birth date format: {}", birthDate);
                }
            }

            userRepository.save(user);

            redirectAttributes.addFlashAttribute("success", "Cập nhật thông tin thành công");
            logger.info("Profile updated successfully for user: {}", currentUsername);

        } catch (Exception e) {
            logger.error("Error updating profile: {}", e.getMessage());
            redirectAttributes.addFlashAttribute("error", "Có lỗi xảy ra khi cập nhật thông tin");
        }

        return "redirect:/admin/overview";
    }

    @PostMapping("/update-email")
    public String updateEmail(@RequestParam("newEmail") String newEmail,
            @RequestParam("currentPassword") String currentPassword,
            Authentication authentication,
            RedirectAttributes redirectAttributes) {
        try {
            // Get current user
            String currentUsername = authentication.getName();
            User user = userRepository.findByUsername(currentUsername).orElse(null);

            if (user == null) {
                redirectAttributes.addFlashAttribute("error", "Không tìm thấy tài khoản");
                return "redirect:/admin/overview";
            }

            // Verify current password
            if (!passwordEncoder.matches(currentPassword, user.getPassword())) {
                redirectAttributes.addFlashAttribute("error", "Mật khẩu hiện tại không đúng");
                return "redirect:/admin/overview";
            }

            // Check if email is already used by another user
            User existingUser = userRepository.findByEmail(newEmail).orElse(null);
            if (existingUser != null && !existingUser.getId().equals(user.getId())) {
                redirectAttributes.addFlashAttribute("error", "Email này đã được sử dụng bởi tài khoản khác");
                return "redirect:/admin/overview";
            }

            // Update email
            user.setEmail(newEmail);
            userRepository.save(user);

            redirectAttributes.addFlashAttribute("success", "Cập nhật email thành công");
            logger.info("Email updated successfully for user: {}", currentUsername);

        } catch (Exception e) {
            logger.error("Error updating email: {}", e.getMessage());
            redirectAttributes.addFlashAttribute("error", "Có lỗi xảy ra khi cập nhật email");
        }

        return "redirect:/admin/overview";
    }

    @PostMapping("/change-password")
    public String changePassword(@RequestParam("oldPassword") String oldPassword,
            @RequestParam("newPassword") String newPassword,
            @RequestParam("confirmPassword") String confirmPassword,
            Authentication authentication,
            RedirectAttributes redirectAttributes) {
        try {
            // Get current user
            String currentUsername = authentication.getName();
            User user = userRepository.findByUsername(currentUsername).orElse(null);

            if (user == null) {
                redirectAttributes.addFlashAttribute("error", "Không tìm thấy tài khoản");
                return "redirect:/admin/overview";
            }

            // Verify old password
            if (!passwordEncoder.matches(oldPassword, user.getPassword())) {
                redirectAttributes.addFlashAttribute("error", "Mật khẩu hiện tại không đúng");
                return "redirect:/admin/overview";
            }

            // Validate new password
            if (newPassword == null || newPassword.length() < 5) {
                redirectAttributes.addFlashAttribute("error", "Mật khẩu mới phải có ít nhất 5 ký tự");
                return "redirect:/admin/overview";
            }

            if (!newPassword.equals(confirmPassword)) {
                redirectAttributes.addFlashAttribute("error", "Mật khẩu mới và xác nhận mật khẩu không khớp");
                return "redirect:/admin/overview";
            }

            // Update password
            user.setPassword(passwordEncoder.encode(newPassword));
            userRepository.save(user);

            redirectAttributes.addFlashAttribute("success", "Đổi mật khẩu thành công");
            logger.info("Password changed successfully for user: {}", currentUsername);

        } catch (Exception e) {
            logger.error("Error changing password: {}", e.getMessage());
            redirectAttributes.addFlashAttribute("error", "Có lỗi xảy ra khi đổi mật khẩu");
        }

        return "redirect:/admin/overview";
    }
}