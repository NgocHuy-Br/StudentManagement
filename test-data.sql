-- Script SQL để tạo dữ liệu test cho hệ thống Student Management (Updated Structure)
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

-- Students (updated with huy3, huy4 from your screenshot)
('huy3', '$2a$10$9j8YgUqVjK8RJ2vXDu0bceK5kAX5pOJy4.fJhf8wR6K8vNJyJKJy.', '333', '', '333@11', '333', 'STUDENT'),
('huy4', '$2a$10$9j8YgUqVjK8RJ2vXDu0bceK5kAX5pOJy4.fJhf8wR6K8vNJyJKJy.', '123', '456', '222@gmail', '123', 'STUDENT'),
('B21DCCN001', '$2a$10$9j8YgUqVjK8RJ2vXDu0bceK5kAX5pOJy4.fJhf8wR6K8vNJyJKJy.', 'Phạm Minh', 'Đức', 'pmd@student.ptit.edu.vn', '0123456701', 'STUDENT'),
('B21DCCN002', '$2a$10$9j8YgUqVjK8RJ2vXDu0bceK5kAX5pOJy4.fJhf8wR6K8vNJyJKJy.', 'Vũ Thị', 'Emi', 've@student.ptit.edu.vn', '0123456702', 'STUDENT'),
('B21DCCN003', '$2a$10$9j8YgUqVjK8RJ2vXDu0bceK5kAX5pOJy4.fJhf8wR6K8vNJyJKJy.', 'Hoàng Văn', 'Phúc', 'hvp@student.ptit.edu.vn', '0123456703', 'STUDENT');

-- 2. Thêm dữ liệu majors (ngành học)
INSERT INTO majors (major_code, major_name, description) VALUES
('CNTT', 'Công nghệ thông tin', 'Ngành đào tạo chuyên gia về công nghệ thông tin và phần mềm'),
('KHMT', 'Khoa học máy tính', 'Ngành nghiên cứu về khoa học máy tính và trí tuệ nhân tạo'),
('KTPM', 'Kỹ thuật phần mềm', 'Ngành đào tạo kỹ sư phần mềm chuyên nghiệp'),
('HTTT', 'Hệ thống thông tin', 'Ngành về quản lý và phân tích hệ thống thông tin');

-- 3. Thêm dữ liệu teachers
INSERT INTO teachers (id, teacher_code, department) VALUES
(2, 'GV001', 'Khoa học máy tính'),
(3, 'GV002', 'Toán ứng dụng'),
(4, 'GV003', 'Kỹ thuật phần mềm');

-- 4. Thêm dữ liệu students (với major_id thay vì faculty)
INSERT INTO students (id, class_name, major_id) VALUES
(5, 'aaa', 1), -- huy3 - CNTT
(6, 'l4', 2),  -- huy4 - KHMT  
(7, 'D21CQCN01-B', 1), -- B21DCCN001 - CNTT
(8, 'D21CQCN02-B', 1), -- B21DCCN002 - CNTT
(9, 'D21CQCN03-B', 1); -- B21DCCN003 - CNTT

-- 5. Thêm dữ liệu subjects (môn học với major_id)
INSERT INTO subjects (subject_code, subject_name, credit, major_id) VALUES
-- Môn chung cho CNTT
('INT1154', 'Tin học cơ sở', 4, 1),
('INT1155', 'Lập trình căn bản', 4, 1),
('INT1339', 'Ngôn ngữ lập trình Java', 4, 1),
('INT2204', 'Lập trình hướng đối tượng', 3, 1),
('INT2210', 'Cấu trúc dữ liệu và giải thuật', 4, 1),
('INT3306', 'Phát triển ứng dụng web', 3, 1),

-- Môn cho KHMT
('INT3505', 'Kiến trúc máy tính', 3, 2),
('INT3401', 'Trí tuệ nhân tạo', 3, 2),
('INT3402', 'Học máy', 4, 2),

-- Môn cho KTPM
('INT3501', 'Quản lý dự án phần mềm', 3, 3),
('INT3502', 'Kiểm thử phần mềm', 3, 3),

-- Môn cơ bản
('MAT1093', 'Đại số tuyến tính', 3, 1),
('MAT1041', 'Giải tích 1', 4, 1),
('PHY1110', 'Vật lý đại cương', 4, 1);

-- 6. Thêm dữ liệu teacher_subjects (phân công giảng dạy)
INSERT INTO teacher_subjects (teacher_id, subject_id, semester, class_name) VALUES
-- GV001 dạy các môn CNTT
(2, 1, '2024-1', 'N1'), -- INT1154
(2, 2, '2024-1', 'N1'), -- INT1155
(2, 3, '2024-2', 'N1'), -- INT1339

-- GV002 dạy toán
(3, 11, '2024-1', 'N1'), -- MAT1093
(3, 12, '2024-1', 'N2'), -- MAT1041

-- GV003 dạy KTPM
(4, 10, '2024-1', 'N1'), -- INT3501
(4, 11, '2024-2', 'N1'); -- INT3502

-- 7. Thêm dữ liệu scores (điểm số đơn giản)
INSERT INTO scores (student_id, subject_id, avg_score, semester, notes) VALUES
-- Điểm của huy3 (student_id = 5)
(5, 1, 8.5, '2024-1', 'Học tốt'),
(5, 2, 7.0, '2024-1', null),
(5, 11, 9.0, '2024-1', 'Xuất sắc'),

-- Điểm của huy4 (student_id = 6) 
(6, 7, 8.0, '2024-1', null),
(6, 8, 7.5, '2024-1', 'Khá'),
(6, 12, 6.5, '2024-1', null),

-- Điểm của B21DCCN001 (student_id = 7)
(7, 1, 8.8, '2024-1', null),
(7, 2, 9.2, '2024-1', 'Rất tốt'),
(7, 3, 8.0, '2024-2', null),

-- Điểm của B21DCCN002 (student_id = 8)
(8, 1, 7.2, '2024-1', null),
(8, 2, 8.5, '2024-1', null),
(8, 11, 8.0, '2024-1', null),

-- Điểm của B21DCCN003 (student_id = 9)
(9, 1, 9.0, '2024-1', 'Xuất sắc'),
(9, 2, 8.3, '2024-1', null),
(9, 3, 8.7, '2024-2', 'Tốt');
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