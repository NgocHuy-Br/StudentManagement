-- Xóa cột course_year khỏi bảng majors
-- Tạo bởi: Admin
-- Ngày: 2025-10-17
-- Lý do: Không muốn quản lý field khóa học cho ngành nữa

USE student_management;

-- Xóa cột course_year khỏi bảng majors
ALTER TABLE majors DROP COLUMN IF EXISTS course_year;

-- Hiển thị cấu trúc bảng sau khi thay đổi
DESCRIBE majors;