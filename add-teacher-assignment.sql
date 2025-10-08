-- Script để thêm classroom và assign teacher 111 (ID: 18) vào lớp
-- Chạy script này để test teacher dashboard

USE student_management;

-- 1. Thêm classrooms nếu chưa có
INSERT IGNORE INTO classrooms (class_code, class_name, major_id, course_year, description) VALUES
('D21CQCN01-B', 'Lớp Công nghệ thông tin 1B', 1, '2021-2025', 'Lớp chính quy CNTT khóa 2021'),
('D21CQCN02-B', 'Lớp Công nghệ thông tin 2B', 1, '2021-2025', 'Lớp chính quy CNTT khóa 2021'),
('D21KHMT01-B', 'Lớp Khoa học máy tính 1B', 2, '2021-2025', 'Lớp chính quy KHMT khóa 2021');

-- 2. Kiểm tra ID của classrooms vừa tạo
SELECT id, class_code, class_name FROM classrooms WHERE class_code IN ('D21CQCN01-B', 'D21CQCN02-B', 'D21KHMT01-B');

-- 3. Assign teacher 111 (ID: 18) làm chủ nhiệm cho các lớp này
INSERT IGNORE INTO classroom_teachers (classroom_id, teacher_id, start_date, notes) VALUES
((SELECT id FROM classrooms WHERE class_code = 'D21CQCN01-B'), 18, '2024-09-01', 'Chủ nhiệm lớp CNTT 1B'),
((SELECT id FROM classrooms WHERE class_code = 'D21CQCN02-B'), 18, '2024-09-01', 'Chủ nhiệm lớp CNTT 2B');

-- 4. Cập nhật các students để thuộc về classroom thay vì chỉ có class_name
UPDATE students s 
JOIN classrooms c ON s.class_name = c.class_code 
SET s.classroom_id = c.id;

-- Hoặc thêm students mới thuộc các lớp này
INSERT IGNORE INTO students (id, class_name, major_id, classroom_id) VALUES
(10, 'D21CQCN01-B', 1, (SELECT id FROM classrooms WHERE class_code = 'D21CQCN01-B')),
(11, 'D21CQCN01-B', 1, (SELECT id FROM classrooms WHERE class_code = 'D21CQCN01-B')),
(12, 'D21CQCN02-B', 1, (SELECT id FROM classrooms WHERE class_code = 'D21CQCN02-B')),
(13, 'D21CQCN02-B', 1, (SELECT id FROM classrooms WHERE class_code = 'D21CQCN02-B'));

-- 5. Thêm users tương ứng nếu chưa có
INSERT IGNORE INTO users (id, username, password, fname, lname, email, phone, role) VALUES
(10, 'B21DCCN010', '$2a$10$9j8YgUqVjK8RJ2vXDu0bceK5kAX5pOJy4.fJhf8wR6K8vNJyJKJy.', 'Nguyễn', 'Văn A', 'nva10@student.ptit.edu.vn', '0123456710', 'STUDENT'),
(11, 'B21DCCN011', '$2a$10$9j8YgUqVjK8RJ2vXDu0bceK5kAX5pOJy4.fJhf8wR6K8vNJyJKJy.', 'Trần', 'Thị B', 'ttb11@student.ptit.edu.vn', '0123456711', 'STUDENT'),
(12, 'B21DCCN012', '$2a$10$9j8YgUqVjK8RJ2vXDu0bceK5kAX5pOJy4.fJhf8wR6K8vNJyJKJy.', 'Lê', 'Văn C', 'lvc12@student.ptit.edu.vn', '0123456712', 'STUDENT'),
(13, 'B21DCCN013', '$2a$10$9j8YgUqVjK8RJ2vXDu0bceK5kAX5pOJy4.fJhf8wR6K8vNJyJKJy.', 'Phạm', 'Thị D', 'ptd13@student.ptit.edu.vn', '0123456713', 'STUDENT');

-- 6. Kiểm tra kết quả
SELECT 
    'Teacher Assignment Check' as type,
    t.id as teacher_id,
    u.username,
    u.fname,
    u.lname,
    ct.classroom_id,
    c.class_code,
    c.class_name,
    ct.start_date,
    ct.end_date
FROM teachers t
JOIN users u ON t.id = u.id
LEFT JOIN classroom_teachers ct ON t.id = ct.teacher_id AND ct.end_date IS NULL
LEFT JOIN classrooms c ON ct.classroom_id = c.id
WHERE u.username = '111' OR t.id = 18;

SELECT 
    'Students in Classes' as type,
    c.class_code,
    COUNT(s.id) as student_count
FROM classrooms c
LEFT JOIN students s ON c.id = s.classroom_id
WHERE c.class_code IN ('D21CQCN01-B', 'D21CQCN02-B', 'D21KHMT01-B')
GROUP BY c.id, c.class_code;

-- 7. Debug: Hiển thị tất cả assignments của teacher ID 18
SELECT 
    'All Teacher 18 Assignments' as debug_info,
    ct.*,
    c.class_code,
    c.class_name
FROM classroom_teachers ct
JOIN classrooms c ON ct.classroom_id = c.id
WHERE ct.teacher_id = 18;