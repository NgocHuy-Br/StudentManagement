-- Script SQL để tạo dữ liệu test cho hệ thống Student Management
-- Chạy script này trong MySQL Workbench sau khi đã tạo database student_management

USE student_management;

-- 1. Thêm dữ liệu users (mật khẩu đã được mã hóa BCrypt cho "123456")
INSERT INTO users (username, password, fname, lname, email, phone, role) VALUES
-- Admin
('admin', '$2a$10$9j8YgUqVjK8RJ2vXDu0bceK5kAX5pOJy4.fJhf8wR6K8vNJyJKJy.', 'Admin', 'System', 'admin@ptit.edu.vn', '0123456789', 'ADMIN'),

-- Teachers
('GV001', '$2a$10$9j8YgUqVjK8RJ2vXDu0bceK5kAX5pOJy4.fJhf8wR6K8vNJyJKJy.', 'Nguyễn Văn', 'An', 'nva@ptit.edu.vn', '0987654321', 'TEACHER'),
('GV002', '$2a$10$9j8YgUqVjK8RJ2vXDu0bceK5kAX5pOJy4.fJhf8wR6K8vNJyJKJy.', 'Trần Thị', 'Bình', 'ttb@ptit.edu.vn', '0987654322', 'TEACHER'),
('GV003', '$2a$10$9j8YgUqVjK8RJ2vXDu0bceK5kAX5pOJy4.fJhf8wR6K8vNJyJKJy.', 'Lê Hoàng', 'Cường', 'lhc@ptit.edu.vn', '0987654323', 'TEACHER'),

-- Students
('B21DCCN001', '$2a$10$9j8YgUqVjK8RJ2vXDu0bceK5kAX5pOJy4.fJhf8wR6K8vNJyJKJy.', 'Phạm Minh', 'Đức', 'pmd@student.ptit.edu.vn', '0123456701', 'STUDENT'),
('B21DCCN002', '$2a$10$9j8YgUqVjK8RJ2vXDu0bceK5kAX5pOJy4.fJhf8wR6K8vNJyJKJy.', 'Vũ Thị', 'Emi', 've@student.ptit.edu.vn', '0123456702', 'STUDENT'),
('B21DCCN003', '$2a$10$9j8YgUqVjK8RJ2vXDu0bceK5kAX5pOJy4.fJhf8wR6K8vNJyJKJy.', 'Hoàng Văn', 'Phúc', 'hvp@student.ptit.edu.vn', '0123456703', 'STUDENT'),
('B21DCCN004', '$2a$10$9j8YgUqVjK8RJ2vXDu0bceK5kAX5pOJy4.fJhf8wR6K8vNJyJKJy.', 'Đỗ Thị', 'Giang', 'dtg@student.ptit.edu.vn', '0123456704', 'STUDENT'),
('B21DCCN005', '$2a$10$9j8YgUqVjK8RJ2vXDu0bceK5kAX5pOJy4.fJhf8wR6K8vNJyJKJy.', 'Ngô Minh', 'Hải', 'nmh@student.ptit.edu.vn', '0123456705', 'STUDENT');

-- 2. Thêm dữ liệu teachers
INSERT INTO teachers (id, department) VALUES
(2, 'Khoa học máy tính'),
(3, 'Toán ứng dụng'),
(4, 'Kỹ thuật phần mềm');

-- 3. Thêm dữ liệu students
INSERT INTO students (id, class_name, faculty) VALUES
(5, 'D21CQCN01-B', 'Công nghệ thông tin'),
(6, 'D21CQCN02-B', 'Công nghệ thông tin'),
(7, 'D21CQCN03-B', 'Công nghệ thông tin'),
(8, 'D21CQCN04-B', 'Công nghệ thông tin'),
(9, 'D21CQCN05-B', 'Công nghệ thông tin');

-- 4. Thêm dữ liệu subjects (môn học)
INSERT INTO subjects (subject_code, subject_name, credit) VALUES
('INT1154', 'Tin học cơ sở', 4),
('INT1155', 'Lập trình căn bản', 4),
('INT1339', 'Ngôn ngữ lập trình Java', 4),
('INT2204', 'Lập trình hướng đối tượng', 3),
('INT2210', 'Cấu trúc dữ liệu và giải thuật', 4),
('INT3306', 'Phát triển ứng dụng web', 3),
('INT3505', 'Kiến trúc máy tính', 3),
('MAT1093', 'Đại số tuyến tính', 3),
('MAT1041', 'Giải tích 1', 4),
('PHY1110', 'Vật lý đại cương', 4);

-- 5. Thêm dữ liệu courses (lớp học phần)
INSERT INTO courses (subject_id, teacher_id, semester, group_name) VALUES
-- Học kỳ 2024.1
(1, 2, '2024.1', 'Nhóm 1'),
(2, 2, '2024.1', 'Nhóm 1'),
(3, 4, '2024.1', 'Nhóm 1'),
(8, 3, '2024.1', 'Nhóm 1'),
(9, 3, '2024.1', 'Nhóm 1'),
-- Học kỳ 2024.2
(4, 2, '2024.2', 'Nhóm 1'),
(5, 4, '2024.2', 'Nhóm 1'),
(6, 4, '2024.2', 'Nhóm 1'),
(7, 2, '2024.2', 'Nhóm 1'),
(10, 3, '2024.2', 'Nhóm 1');

-- 6. Thêm dữ liệu enrollments (đăng ký học phần)
INSERT INTO enrollments (student_id, course_id) VALUES
-- Sinh viên B21DCCN001 (id=5)
(5, 1), (5, 2), (5, 8), (5, 9),
-- Sinh viên B21DCCN002 (id=6)
(6, 1), (6, 2), (6, 3), (6, 8),
-- Sinh viên B21DCCN003 (id=7)
(7, 1), (7, 2), (7, 3), (7, 9),
-- Sinh viên B21DCCN004 (id=8)
(8, 2), (8, 3), (8, 8), (8, 9),
-- Sinh viên B21DCCN005 (id=9)
(9, 1), (9, 3), (9, 8), (9, 10);

-- 7. Thêm dữ liệu schedules (thời khóa biểu)
INSERT INTO schedules (day_of_week, period, course_id, room, link_online) VALUES
-- Thứ 2
(2, 1, 1, 'TC-201', 'https://meet.google.com/abc-def-ghi'),
(2, 3, 2, 'TC-202', 'https://meet.google.com/def-ghi-jkl'),
-- Thứ 3
(3, 1, 3, 'TC-301', 'https://meet.google.com/ghi-jkl-mno'),
(3, 3, 8, 'TC-101', 'https://meet.google.com/jkl-mno-pqr'),
-- Thứ 4
(4, 1, 4, 'TC-302', 'https://meet.google.com/mno-pqr-stu'),
(4, 3, 9, 'TC-102', 'https://meet.google.com/pqr-stu-vwx'),
-- Thứ 5
(5, 1, 5, 'TC-303', 'https://meet.google.com/stu-vwx-yza'),
(5, 3, 10, 'TC-103', 'https://meet.google.com/vwx-yza-bcd');

-- 8. Thêm dữ liệu scores (điểm số)
INSERT INTO scores (student_id, course_id, score, type) VALUES
-- Sinh viên B21DCCN001
(5, 1, 8.5, 'Giữa kỳ'), (5, 1, 9.0, 'Cuối kỳ'),
(5, 2, 7.5, 'Giữa kỳ'), (5, 2, 8.0, 'Cuối kỳ'),
(5, 8, 8.0, 'Giữa kỳ'), (5, 8, 8.5, 'Cuối kỳ'),
-- Sinh viên B21DCCN002
(6, 1, 7.0, 'Giữa kỳ'), (6, 1, 7.5, 'Cuối kỳ'),
(6, 2, 8.5, 'Giữa kỳ'), (6, 2, 9.0, 'Cuối kỳ'),
(6, 3, 8.0, 'Giữa kỳ'), (6, 3, 8.5, 'Cuối kỳ');

-- 9. Thêm dữ liệu tuitions (học phí)
INSERT INTO tuitions (student_id, amount, status, semester) VALUES
(5, 2500000.00, 'Paid', '2024.1'),
(5, 2500000.00, 'Unpaid', '2024.2'),
(6, 2500000.00, 'Paid', '2024.1'),
(6, 2500000.00, 'Paid', '2024.2'),
(7, 2500000.00, 'Unpaid', '2024.1'),
(7, 2500000.00, 'Unpaid', '2024.2'),
(8, 2500000.00, 'Paid', '2024.1'),
(8, 2500000.00, 'Unpaid', '2024.2'),
(9, 2500000.00, 'Paid', '2024.1'),
(9, 2500000.00, 'Paid', '2024.2');

-- 10. Thêm dữ liệu notifications (thông báo)
INSERT INTO notifications (title, content, created_at, created_by, target_role) VALUES
('Thông báo lịch thi cuối kỳ', 'Lịch thi cuối kỳ học kỳ 2024.2 đã được cập nhật. Sinh viên vui lòng kiểm tra thông tin chi tiết.', NOW(), 1, 'STUDENT'),
('Họp khoa định kỳ', 'Thông báo họp khoa định kỳ tháng 9/2024 vào ngày 25/09/2024 lúc 14:00.', NOW(), 1, 'TEACHER'),
('Bảo trì hệ thống', 'Hệ thống sẽ được bảo trì vào ngày 30/09/2024 từ 22:00 đến 02:00 ngày hôm sau.', NOW(), 1, 'ADMIN');

-- Xem kết quả sau khi insert
SELECT 'Users:' as 'Table';
SELECT username, fname, lname, role FROM users;

SELECT 'Teachers:' as 'Table';
SELECT u.username, u.fname, u.lname, t.department 
FROM teachers t JOIN users u ON t.id = u.id;

SELECT 'Students:' as 'Table';
SELECT u.username, u.fname, u.lname, s.class_name, s.faculty 
FROM students s JOIN users u ON s.id = u.id;

/*
THÔNG TIN ĐĂNG NHẬP TEST:

1. Admin:
   - Username: admin
   - Password: 123456
   
2. Giáo viên:
   - Username: GV001, GV002, GV003
   - Password: 123456 (cho tất cả)
   
3. Sinh viên:
   - Username: B21DCCN001, B21DCCN002, B21DCCN003, B21DCCN004, B21DCCN005
   - Password: 123456 (cho tất cả)

Lưu ý: Mật khẩu đã được mã hóa bằng BCrypt với độ mạnh 10.
Mật khẩu gốc là "123456" cho tất cả tài khoản test.
*/