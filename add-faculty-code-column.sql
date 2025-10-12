-- Migration script: Add faculty_code column to faculties table
-- Ngày tạo: 12/10/2025

-- Thêm cột faculty_code vào bảng faculties
ALTER TABLE faculties ADD COLUMN faculty_code VARCHAR(20) NOT NULL DEFAULT '' AFTER id;

-- Tạo unique index cho faculty_code
ALTER TABLE faculties ADD CONSTRAINT uk_faculties_faculty_code UNIQUE (faculty_code);

-- Cập nhật dữ liệu mẫu cho faculty_code (tùy chọn)
-- Bạn có thể thêm dữ liệu mẫu theo nhu cầu thực tế
-- UPDATE faculties SET faculty_code = 'CNTT' WHERE name LIKE '%Công nghệ thông tin%';
-- UPDATE faculties SET faculty_code = 'KTMT' WHERE name LIKE '%Kỹ thuật máy tính%';
-- UPDATE faculties SET faculty_code = 'KT' WHERE name LIKE '%Kinh tế%';
-- UPDATE faculties SET faculty_code = 'NN' WHERE name LIKE '%Ngoại ngữ%';

-- Xóa DEFAULT constraint sau khi cập nhật dữ liệu
ALTER TABLE faculties ALTER COLUMN faculty_code DROP DEFAULT;