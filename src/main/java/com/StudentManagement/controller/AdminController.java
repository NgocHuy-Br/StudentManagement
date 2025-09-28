package com.StudentManagement.controller;

import com.StudentManagement.entity.Classroom;
import com.StudentManagement.entity.Major;
import com.StudentManagement.entity.Student;
import com.StudentManagement.entity.Subject;
import com.StudentManagement.entity.Teacher;
import com.StudentManagement.entity.User;
import com.StudentManagement.repository.ClassroomRepository;
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
import java.util.regex.Pattern;

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
    private final ClassroomRepository classroomRepository;
    private final PasswordEncoder passwordEncoder;

    // Pattern for course year validation
    private static final Pattern COURSE_YEAR_PATTERN = Pattern.compile("^[0-9]{4}-[0-9]{4}$");

    public AdminController(UserRepository userRepository,
            StudentRepository studentRepository,
            TeacherRepository teacherRepository,
            MajorRepository majorRepository,
            SubjectRepository subjectRepository,
            ScoreRepository scoreRepository,
            TeacherSubjectRepository teacherSubjectRepository,
            ClassroomRepository classroomRepository,
            PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.studentRepository = studentRepository;
        this.teacherRepository = teacherRepository;
        this.majorRepository = majorRepository;
        this.subjectRepository = subjectRepository;
        this.scoreRepository = scoreRepository;
        this.teacherSubjectRepository = teacherSubjectRepository;
        this.classroomRepository = classroomRepository;
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
        svUser.setNationalId(nationalId != null ? nationalId.trim() : null);

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
        svUser.setNationalId(nationalId != null ? nationalId.trim() : null);

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
            @RequestParam(required = false) String address,
            @RequestParam(required = false) String nationalId,
            @RequestParam(required = false) String birthDate,
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

        // 1) User
        User teacherUser = new User();
        teacherUser.setUsername(u);
        teacherUser.setPassword(passwordEncoder.encode(password));
        teacherUser.setFname(fname);
        teacherUser.setLname(lname);
        teacherUser.setEmail(e);
        teacherUser.setPhone(phone);
        teacherUser.setAddress(address);
        teacherUser.setNationalId(nationalId != null ? nationalId.trim() : null);

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
                ? subjectRepository.findAll(pageable)
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
        subject = subjectRepository.save(subject);

        // Thêm môn học vào danh sách của ngành
        if (major.getSubjects() == null) {
            major.setSubjects(new java.util.ArrayList<>());
        }
        major.getSubjects().add(subject);
        majorRepository.save(major);

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

    // Thêm môn học có sẵn vào ngành
    @PostMapping("/majors/{majorId}/subjects/add-existing")
    @Transactional
    public String addExistingSubjectToMajor(@PathVariable Long majorId,
            @RequestParam Long subjectId,
            RedirectAttributes ra) {

        Major major = majorRepository.findById(majorId).orElse(null);
        if (major == null) {
            ra.addFlashAttribute("error", "Ngành học không tồn tại.");
            return "redirect:/admin/majors";
        }

        Subject subject = subjectRepository.findById(subjectId).orElse(null);
        if (subject == null) {
            ra.addFlashAttribute("error", "Môn học không tồn tại.");
            return "redirect:/admin/majors/" + majorId + "/subjects";
        }

        // Kiểm tra xem môn học đã thuộc ngành này chưa
        if (major.getSubjects() != null && major.getSubjects().contains(subject)) {
            ra.addFlashAttribute("error", "Môn học đã thuộc ngành này: " + subject.getSubjectCode());
            return "redirect:/admin/majors/" + majorId + "/subjects";
        }

        // Thêm môn học vào ngành
        if (major.getSubjects() == null) {
            major.setSubjects(new java.util.ArrayList<>());
        }
        major.getSubjects().add(subject);
        majorRepository.save(major);

        ra.addFlashAttribute("success", "Đã thêm môn học vào ngành: " + subject.getSubjectCode());
        return "redirect:/admin/majors/" + majorId + "/subjects";
    }
}