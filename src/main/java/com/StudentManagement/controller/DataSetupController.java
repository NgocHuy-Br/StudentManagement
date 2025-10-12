package com.StudentManagement.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.StudentManagement.repository.FacultyRepository;
import com.StudentManagement.repository.MajorRepository;
import com.StudentManagement.entity.Faculty;

@RestController
public class DataSetupController {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Autowired
    private FacultyRepository facultyRepository;

    @Autowired
    private MajorRepository majorRepository;

    @GetMapping("/setup-test-data")
    public String setupTestData() {
        try {
            System.out.println("=== Setting up test data for teacher assignments ===");

            // 1. Create classrooms
            jdbcTemplate.execute(
                    "INSERT IGNORE INTO classrooms (class_code, class_name, major_id, course_year, description) VALUES "
                            +
                            "('D21CQCN01-B', 'Lớp Công nghệ thông tin 1B', 1, '2021-2025', 'Lớp chính quy CNTT khóa 2021'), "
                            +
                            "('D21CQCN02-B', 'Lớp Công nghệ thông tin 2B', 1, '2021-2025', 'Lớp chính quy CNTT khóa 2021')");

            // 2. Get classroom IDs
            var classroom1 = jdbcTemplate.queryForMap("SELECT id FROM classrooms WHERE class_code = 'D21CQCN01-B'");
            var classroom2 = jdbcTemplate.queryForMap("SELECT id FROM classrooms WHERE class_code = 'D21CQCN02-B'");

            Long classroom1Id = ((Number) classroom1.get("id")).longValue();
            Long classroom2Id = ((Number) classroom2.get("id")).longValue();

            // 3. Assign teacher 18 to these classrooms
            jdbcTemplate.update(
                    "INSERT IGNORE INTO classroom_teachers (classroom_id, teacher_id, start_date, notes) VALUES (?, 18, '2024-09-01', 'Chủ nhiệm lớp CNTT 1B')",
                    classroom1Id);

            jdbcTemplate.update(
                    "INSERT IGNORE INTO classroom_teachers (classroom_id, teacher_id, start_date, notes) VALUES (?, 18, '2024-09-01', 'Chủ nhiệm lớp CNTT 2B')",
                    classroom2Id);

            // 4. Add some students to these classrooms
            jdbcTemplate.execute(
                    "INSERT IGNORE INTO users (id, username, password, fname, lname, email, phone, role) VALUES " +
                            "(100, 'B21DCCN100', '$2a$10$9j8YgUqVjK8RJ2vXDu0bceK5kAX5pOJy4.fJhf8wR6K8vNJyJKJy.', 'Nguyễn', 'Văn A', 'nva100@student.ptit.edu.vn', '0123456700', 'STUDENT'), "
                            +
                            "(101, 'B21DCCN101', '$2a$10$9j8YgUqVjK8RJ2vXDu0bceK5kAX5pOJy4.fJhf8wR6K8vNJyJKJy.', 'Trần', 'Thị B', 'ttb101@student.ptit.edu.vn', '0123456701', 'STUDENT'), "
                            +
                            "(102, 'B21DCCN102', '$2a$10$9j8YgUqVjK8RJ2vXDu0bceK5kAX5pOJy4.fJhf8wR6K8vNJyJKJy.', 'Lê', 'Văn C', 'lvc102@student.ptit.edu.vn', '0123456702', 'STUDENT'), "
                            +
                            "(103, 'B21DCCN103', '$2a$10$9j8YgUqVjK8RJ2vXDu0bceK5kAX5pOJy4.fJhf8wR6K8vNJyJKJy.', 'Phạm', 'Thị D', 'ptd103@student.ptit.edu.vn', '0123456703', 'STUDENT')");

            jdbcTemplate.update(
                    "INSERT IGNORE INTO students (id, class_name, major_id, classroom_id) VALUES (100, 'D21CQCN01-B', 1, ?)",
                    classroom1Id);

            jdbcTemplate.update(
                    "INSERT IGNORE INTO students (id, class_name, major_id, classroom_id) VALUES (101, 'D21CQCN01-B', 1, ?)",
                    classroom1Id);

            jdbcTemplate.update(
                    "INSERT IGNORE INTO students (id, class_name, major_id, classroom_id) VALUES (102, 'D21CQCN02-B', 1, ?)",
                    classroom2Id);

            jdbcTemplate.update(
                    "INSERT IGNORE INTO students (id, class_name, major_id, classroom_id) VALUES (103, 'D21CQCN02-B', 1, ?)",
                    classroom2Id);

            // 5. Check results
            var assignments = jdbcTemplate.queryForList(
                    "SELECT ct.id, ct.classroom_id, c.class_code, c.class_name, ct.start_date " +
                            "FROM classroom_teachers ct " +
                            "JOIN classrooms c ON ct.classroom_id = c.id " +
                            "WHERE ct.teacher_id = 18 AND ct.end_date IS NULL");

            var studentCounts = jdbcTemplate.queryForList(
                    "SELECT c.class_code, COUNT(s.id) as student_count " +
                            "FROM classrooms c " +
                            "LEFT JOIN students s ON c.id = s.classroom_id " +
                            "WHERE c.class_code IN ('D21CQCN01-B', 'D21CQCN02-B') " +
                            "GROUP BY c.id, c.class_code");

            StringBuilder result = new StringBuilder();
            result.append("Test data setup completed successfully!\n\n");
            result.append("Teacher 18 assignments: ").append(assignments.size()).append("\n");
            for (var assignment : assignments) {
                result.append("- Class: ").append(assignment.get("class_code"))
                        .append(" (").append(assignment.get("class_name")).append(")\n");
            }

            result.append("\nStudent counts:\n");
            for (var count : studentCounts) {
                result.append("- ").append(count.get("class_code"))
                        .append(": ").append(count.get("student_count")).append(" students\n");
            }

            return result.toString();

        } catch (Exception e) {
            return "Error setting up test data: " + e.getMessage();
        }
    }

    @GetMapping("/check-teacher-data")
    @ResponseBody
    public String checkTeacherData() {
        try {
            // Check what classrooms have teacher assignments
            var classroomTeachers = jdbcTemplate.queryForList(
                    "SELECT c.id, c.class_code, c.home_room_teacher_id, ct.teacher_id as ct_teacher_id, ct.start_date, ct.end_date "
                            +
                            "FROM classrooms c " +
                            "LEFT JOIN classroom_teachers ct ON c.id = ct.classroom_id AND ct.end_date IS NULL " +
                            "ORDER BY c.class_code");

            StringBuilder result = new StringBuilder();
            result.append("=== CLASSROOM TEACHER DATA ===\n\n");

            for (var row : classroomTeachers) {
                result.append("Class: ").append(row.get("class_code")).append("\n");
                result.append("- Classroom ID: ").append(row.get("id")).append("\n");
                result.append("- homeRoomTeacher ID: ").append(row.get("home_room_teacher_id")).append("\n");
                result.append("- ClassroomTeacher teacher_id: ").append(row.get("ct_teacher_id")).append("\n");
                result.append("- Start date: ").append(row.get("start_date")).append("\n");
                result.append("- End date: ").append(row.get("end_date")).append("\n\n");
            }

            // Check teacher 18 specifically
            var teacher18 = jdbcTemplate.queryForList(
                    "SELECT ct.* FROM classroom_teachers ct WHERE ct.teacher_id = 18");

            result.append("=== TEACHER 18 ASSIGNMENTS ===\n");
            result.append("Total assignments: ").append(teacher18.size()).append("\n");
            for (var assignment : teacher18) {
                result.append("- Classroom ID: ").append(assignment.get("classroom_id"));
                result.append(", Start: ").append(assignment.get("start_date"));
                result.append(", End: ").append(assignment.get("end_date")).append("\n");
            }

            return result.toString();

        } catch (Exception e) {
            return "Error checking data: " + e.getMessage();
        }
    }

    @GetMapping("/fix-k22-teacher")
    @ResponseBody
    public String fixK22Teacher() {
        try {
            // Directly insert the record for K22 (classroom_id=1, teacher_id=18)
            int result = jdbcTemplate.update(
                    "INSERT IGNORE INTO classroom_teachers (classroom_id, teacher_id, start_date, notes) VALUES (1, 18, '2024-09-01', 'Fixed from admin assignment')");

            if (result > 0) {
                return "SUCCESS: Created ClassroomTeacher record for K22 (classroom_id=1, teacher_id=18)";
            } else {
                return "INFO: ClassroomTeacher record already exists for K22";
            }

        } catch (Exception e) {
            return "ERROR: " + e.getMessage();
        }
    }

    @GetMapping("/verify-teacher-111")
    @ResponseBody
    public String verifyTeacher111() {
        try {
            // Check teacher 111 assignments
            var assignments = jdbcTemplate.queryForList(
                    "SELECT ct.*, c.class_code FROM classroom_teachers ct " +
                            "JOIN classrooms c ON ct.classroom_id = c.id " +
                            "WHERE ct.teacher_id = 18 AND ct.end_date IS NULL");

            StringBuilder result = new StringBuilder();
            result.append("Teacher 18 (username 111) assignments: ").append(assignments.size()).append("\n");
            for (var assignment : assignments) {
                result.append("- Class: ").append(assignment.get("class_code"));
                result.append(", Start: ").append(assignment.get("start_date"));
                result.append(", End: ").append(assignment.get("end_date")).append("\n");
            }

            return result.toString();

        } catch (Exception e) {
            return "ERROR: " + e.getMessage();
        }
    }

    @GetMapping("/setup-faculties")
    @ResponseBody
    public String setupFaculties() {
        try {
            System.out.println("=== Setting up faculty data ===");

            // Insert sample faculties
            jdbcTemplate.execute(
                    "INSERT IGNORE INTO faculties (faculty_code, name, description, created_at, updated_at) VALUES " +
                            "('CNTT', 'Công nghệ thông tin', 'Khoa Công nghệ thông tin', NOW(), NOW()), " +
                            "('DTVT', 'Điện tử viễn thông', 'Khoa Điện tử viễn thông', NOW(), NOW()), " +
                            "('KT', 'Kinh tế', 'Khoa Kinh tế', NOW(), NOW()), " +
                            "('CK', 'Cơ khí', 'Khoa Cơ khí', NOW(), NOW()), " +
                            "('HH', 'Hóa học', 'Khoa Hóa học', NOW(), NOW())");

            // Get CNTT faculty ID
            var cnttFaculty = jdbcTemplate.queryForMap("SELECT id FROM faculties WHERE faculty_code = 'CNTT'");
            Long cnttFacultyId = ((Number) cnttFaculty.get("id")).longValue();

            // Update existing majors to assign them to CNTT faculty as default
            int updatedMajors = jdbcTemplate.update(
                    "UPDATE majors SET faculty_id = ? WHERE faculty_id IS NULL OR faculty_id = 0",
                    cnttFacultyId);

            return "SUCCESS: Created faculties and updated " + updatedMajors + " majors with faculty assignment.";

        } catch (Exception e) {
            return "ERROR: " + e.getMessage();
        }
    }
}