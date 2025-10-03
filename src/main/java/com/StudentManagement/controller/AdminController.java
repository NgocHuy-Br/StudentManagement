package com.StudentManagement.controller;

import com.StudentManagement.entity.Classroom;
import com.StudentManagement.entity.Faculty;
import com.StudentManagement.entity.Major;
import com.StudentManagement.entity.Student;
import com.StudentManagement.entity.Subject;
import com.StudentManagement.entity.Teacher;
import com.StudentManagement.entity.User;
import com.StudentManagement.repository.ClassroomRepository;
import com.StudentManagement.repository.FacultyRepository;
import com.StudentManagement.repository.MajorRepository;
import com.StudentManagement.repository.ScoreRepository;
import com.StudentManagement.repository.StudentRepository;
import com.StudentManagement.repository.SubjectRepository;
import com.StudentManagement.repository.TeacherRepository;
import com.StudentManagement.repository.UserRepository;
import com.StudentManagement.service.ClassroomTeacherService;
import org.springframework.data.domain.*;
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

import java.util.List;
import java.util.regex.Pattern;

@Controller
@RequestMapping("/admin")
public class AdminController {

    private final UserRepository userRepository;
    private final StudentRepository studentRepository;
    private final TeacherRepository teacherRepository;
    private final FacultyRepository facultyRepository;
    private final MajorRepository majorRepository;
    private final SubjectRepository subjectRepository;
    private final ScoreRepository scoreRepository;
    private final ClassroomRepository classroomRepository;
    private final ClassroomTeacherService classroomTeacherService;
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
            ClassroomRepository classroomRepository,
            ClassroomTeacherService classroomTeacherService,
            PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.studentRepository = studentRepository;
        this.teacherRepository = teacherRepository;
        this.facultyRepository = facultyRepository;
        this.majorRepository = majorRepository;
        this.subjectRepository = subjectRepository;
        this.scoreRepository = scoreRepository;
        this.classroomRepository = classroomRepository;
        this.classroomTeacherService = classroomTeacherService;
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
        addUserInfo(auth, model);
        model.addAttribute("activeTab", "notice");
        return "admin/admin-dashboard";
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
            @RequestParam(required = false) Long selectedClassId,
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
        model.addAttribute("selectedClassId", selectedClassId);

        // Nếu có lớp được chọn, lấy thông tin sinh viên trong lớp
        if (selectedClassId != null) {
            Classroom selectedClass = classroomRepository.findById(selectedClassId).orElse(null);
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
                Page<Student> studentsInClass = studentRepository.findByClassroomId(selectedClassId, studentPageable);

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

        return "admin/classrooms";
    }

    // Thêm lớp học mới
    @PostMapping("/classrooms")
    @Transactional
    public String createClassroom(@RequestParam String classCode,
            @RequestParam String courseYear,
            @RequestParam Long majorId,
            @RequestParam(required = false) Long teacherId,
            RedirectAttributes ra) {

        String code = classCode.trim().toUpperCase();
        String year = courseYear.trim();

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

        Major major = majorRepository.findById(majorId).orElse(null);
        if (major == null) {
            ra.addFlashAttribute("error", "Ngành học không tồn tại.");
            return "redirect:/admin/classrooms";
        }

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
        String oldYear = classroom.getCourseYear();
        String oldMajor = classroom.getMajor().getMajorName();

        try {
            // Nếu lớp đã có sinh viên, chỉ cho phép sửa giáo viên chủ nhiệm
            if (hasStudents) {
                // Chỉ cập nhật giáo viên chủ nhiệm
                Teacher newTeacher = null;
                if (teacherId != null && teacherId > 0) {
                    newTeacher = teacherRepository.findById(teacherId).orElse(null);
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

        Subject subject = new Subject();
        subject.setSubjectCode(code);
        subject.setSubjectName(name);
        subject.setCredit(credit);
        // Không cần set major nữa vì sử dụng Many-to-Many
        subjectRepository.save(subject);

        ra.addFlashAttribute("success", "Đã tạo môn học: " + code + " - " + name);
        return "redirect:/admin/subjects";
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
            return "redirect:/admin/majors/" + majorId + "/subjects";
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
        return "redirect:/admin/majors/" + majorId + "/subjects";
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
        // Validate sort parameter to prevent errors
        String validSort = ("name".equals(sort) || "description".equals(sort)) ? sort : "name";
        Pageable pageable = PageRequest.of(Math.max(page, 0), Math.max(size, 1), Sort.by(direction, validSort));

        Page<Faculty> faculties = (q == null || q.isBlank())
                ? facultyRepository.findAll(pageable)
                : facultyRepository.search(q.trim(), pageable);

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
    public String createFaculty(@RequestParam String name,
            @RequestParam(required = false) String description,
            RedirectAttributes ra) {

        if (facultyRepository.existsByName(name.trim())) {
            ra.addFlashAttribute("error", "Tên khoa đã tồn tại.");
            return "redirect:/admin/faculties/manage";
        }

        Faculty faculty = new Faculty(name.trim(), description != null ? description.trim() : null);
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
            @RequestParam String name,
            @RequestParam(required = false) String description,
            RedirectAttributes ra) {

        Faculty faculty = facultyRepository.findById(id).orElse(null);
        if (faculty == null) {
            ra.addFlashAttribute("error", "Không tìm thấy khoa.");
            return "redirect:/admin/faculties/manage";
        }

        if (facultyRepository.existsByNameAndIdNot(name.trim(), id)) {
            ra.addFlashAttribute("error", "Tên khoa đã tồn tại.");
            return "redirect:/admin/faculties/manage";
        }

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
        if (teacherCount > 0) {
            ra.addFlashAttribute("error",
                    "Không thể xóa khoa vì còn có " + teacherCount + " giáo viên thuộc khoa này.");
            return "redirect:/admin/faculties/manage";
        }

        facultyRepository.delete(faculty);
        ra.addFlashAttribute("success", "Xóa khoa thành công.");
        return "redirect:/admin/faculties/manage";
    }

    // ============= MAJOR-SUBJECT MANAGEMENT TAB =============

    /**
     * Tab Ngành - Môn học (Layout 2 panel)
     */
    @GetMapping("/majors")
    public String majorSubjectManagement(Authentication auth, Model model,
            @RequestParam(defaultValue = "") String q,
            @RequestParam(required = false) Long selectedMajorId,
            @RequestParam(defaultValue = "") String subjectSearch,
            @RequestParam(defaultValue = "subjectCode") String subjectSort,
            @RequestParam(defaultValue = "asc") String subjectDir) {
        addUserInfo(auth, model);
        model.addAttribute("activeTab", "majors");

        // Lấy danh sách ngành
        List<Major> majors;
        if (q != null && !q.isBlank()) {
            majors = majorRepository.searchByCodeOrName(q.trim());
        } else {
            majors = majorRepository.findAllWithSubjectCount();
        }

        model.addAttribute("majors", majors);
        model.addAttribute("q", q);

        // Nếu có ngành được chọn, lấy thông tin môn học
        if (selectedMajorId != null) {
            Major selectedMajor = majorRepository.findById(selectedMajorId).orElse(null);
            if (selectedMajor != null) {
                model.addAttribute("selectedMajor", selectedMajor);
                model.addAttribute("selectedMajorId", selectedMajorId);

                // Lấy danh sách môn học với sắp xếp
                Sort.Direction direction = "desc".equalsIgnoreCase(subjectDir) ? Sort.Direction.DESC
                        : Sort.Direction.ASC;
                Sort sort = Sort.by(direction, subjectSort);

                List<Subject> subjects;
                if (subjectSearch != null && !subjectSearch.isBlank()) {
                    subjects = subjectRepository.findByMajorIdAndSearchWithSort(selectedMajorId, subjectSearch.trim(),
                            sort);
                } else {
                    subjects = subjectRepository.findByMajorIdWithSort(selectedMajorId, sort);
                }

                model.addAttribute("subjects", subjects);
            }
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
     * Cập nhật môn học
     */
    @PostMapping("/subjects/{subjectId}")
    @Transactional
    public String updateSubject(@PathVariable Long subjectId,
            @RequestParam Long majorId,
            @RequestParam String subjectCode,
            @RequestParam String subjectName,
            @RequestParam(defaultValue = "0") int credit,
            RedirectAttributes ra) {

        Subject subject = subjectRepository.findById(subjectId).orElse(null);
        if (subject == null) {
            ra.addFlashAttribute("error", "Không tìm thấy môn học.");
            return "redirect:/admin/majors?selectedMajorId=" + majorId;
        }

        // Kiểm tra trùng mã môn học với các môn khác
        Subject existingSubject = subjectRepository.findBySubjectCode(subjectCode.trim()).orElse(null);
        if (existingSubject != null && !existingSubject.getId().equals(subjectId)) {
            ra.addFlashAttribute("error", "Mã môn học đã tồn tại.");
            return "redirect:/admin/majors?selectedMajorId=" + majorId;
        }

        subject.setSubjectCode(subjectCode.trim());
        subject.setSubjectName(subjectName.trim());
        subject.setCredit(credit);

        subjectRepository.save(subject);

        ra.addFlashAttribute("success", "Cập nhật môn học thành công.");
        return "redirect:/admin/majors?selectedMajorId=" + majorId;
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
            @RequestParam Long existingSubjectId,
            RedirectAttributes ra) {

        Major major = majorRepository.findById(majorId).orElse(null);
        Subject subject = subjectRepository.findById(existingSubjectId).orElse(null);

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
            @RequestParam String courseYear,
            @RequestParam(required = false) String description,
            RedirectAttributes ra) {
        try {
            // Validate course year format
            if (!isValidCourseYearFormat(courseYear)) {
                ra.addFlashAttribute("error", "Khóa học phải có định dạng YYYY-YYYY (ví dụ: 2023-2027)");
                return "redirect:/admin/majors";
            }

            // Kiểm tra mã ngành + khóa học đã tồn tại chưa
            List<Major> existingMajors = majorRepository.findAll();
            boolean exists = existingMajors.stream()
                    .anyMatch(m -> m.getMajorCode().equals(majorCode) && m.getCourseYear().equals(courseYear));

            if (exists) {
                ra.addFlashAttribute("error", "Ngành " + majorCode + " khóa " + courseYear + " đã tồn tại");
                return "redirect:/admin/majors";
            }

            // Tạo ngành mới
            Major major = new Major();
            major.setMajorCode(majorCode);
            major.setMajorName(majorName);
            major.setCourseYear(courseYear);
            major.setDescription(description);

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
            @RequestParam String courseYear,
            @RequestParam(required = false) String description,
            RedirectAttributes ra) {
        try {
            // Validate course year format
            if (!isValidCourseYearFormat(courseYear)) {
                ra.addFlashAttribute("error", "Khóa học phải có định dạng YYYY-YYYY (ví dụ: 2023-2027)");
                return "redirect:/admin/majors";
            }

            Major major = majorRepository.findById(id).orElse(null);
            if (major == null) {
                ra.addFlashAttribute("error", "Không tìm thấy ngành học");
                return "redirect:/admin/majors";
            }

            // Kiểm tra mã ngành + khóa học đã tồn tại ở ngành khác chưa
            List<Major> existingMajors = majorRepository.findAll();
            boolean exists = existingMajors.stream()
                    .anyMatch(m -> m.getMajorCode().equals(majorCode)
                            && m.getCourseYear().equals(courseYear)
                            && !m.getId().equals(id));

            if (exists) {
                ra.addFlashAttribute("error", "Ngành " + majorCode + " khóa " + courseYear + " đã tồn tại");
                return "redirect:/admin/majors";
            }

            // Cập nhật thông tin ngành
            major.setMajorCode(majorCode);
            major.setMajorName(majorName);
            major.setCourseYear(courseYear);
            major.setDescription(description);

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
     * Cập nhật môn học
     */
    @PostMapping("/subjects/edit")
    @Transactional
    public String editSubject(@RequestParam Long id,
            @RequestParam Long majorId,
            @RequestParam String subjectCode,
            @RequestParam String subjectName,
            @RequestParam int credit,
            RedirectAttributes ra) {
        try {
            Subject subject = subjectRepository.findById(id).orElse(null);
            if (subject == null) {
                ra.addFlashAttribute("error", "Không tìm thấy môn học");
                return "redirect:/admin/majors?selectedMajorId=" + majorId;
            }

            // Kiểm tra mã môn học đã tồn tại ở môn khác chưa
            Subject existingSubject = subjectRepository.findBySubjectCode(subjectCode).orElse(null);
            if (existingSubject != null && !existingSubject.getId().equals(id)) {
                ra.addFlashAttribute("error", "Mã môn học đã tồn tại");
                return "redirect:/admin/majors?selectedMajorId=" + majorId;
            }

            // Cập nhật thông tin môn học
            subject.setSubjectCode(subjectCode);
            subject.setSubjectName(subjectName);
            subject.setCredit(credit);

            subjectRepository.save(subject);

            ra.addFlashAttribute("success", "Cập nhật môn học thành công");
            return "redirect:/admin/majors?selectedMajorId=" + majorId;
        } catch (Exception e) {
            ra.addFlashAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            return "redirect:/admin/majors?selectedMajorId=" + majorId;
        }
    }

    /**
     * Xóa môn học
     */
    @PostMapping("/subjects/delete")
    @Transactional
    public String deleteSubject(@RequestParam Long id,
            @RequestParam Long majorId,
            RedirectAttributes ra) {
        try {
            Subject subject = subjectRepository.findById(id).orElse(null);
            if (subject == null) {
                ra.addFlashAttribute("error", "Không tìm thấy môn học");
                return "redirect:/admin/majors?selectedMajorId=" + majorId;
            }

            // Kiểm tra xem có điểm số nào liên quan không
            long scoreCount = scoreRepository.countBySubjectId(id);
            if (scoreCount > 0) {
                ra.addFlashAttribute("error", "Không thể xóa môn học vì có " + scoreCount + " điểm số liên quan");
                return "redirect:/admin/majors?selectedMajorId=" + majorId;
            }

            // Xóa môn học khỏi tất cả ngành
            List<Major> majors = majorRepository.findAll();
            for (Major major : majors) {
                if (major.getSubjects() != null) {
                    major.getSubjects().removeIf(s -> s.getId().equals(id));
                }
            }

            // Xóa môn học
            subjectRepository.delete(subject);

            ra.addFlashAttribute("success", "Xóa môn học thành công");
            return "redirect:/admin/majors?selectedMajorId=" + majorId;
        } catch (Exception e) {
            ra.addFlashAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            return "redirect:/admin/majors?selectedMajorId=" + majorId;
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

    /**
     * API lấy danh sách môn học chưa thuộc ngành để thêm vào
     */
    @GetMapping("/majors/{majorId}/available-subjects")
    @ResponseBody
    public List<Subject> getAvailableSubjects(@PathVariable Long majorId) {
        return subjectRepository.findSubjectsNotInMajor(majorId);
    }
}