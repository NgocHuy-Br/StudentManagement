-- Script để dọn dẹp và loại bỏ AcademicProgram
-- Cleanup: Remove AcademicProgram Implementation

-- Bước 1: Xóa ràng buộc foreign key từ classrooms
ALTER TABLE classrooms DROP FOREIGN KEY IF EXISTS fk_classroom_academic_program;

-- Bước 2: Xóa cột academic_program_id từ bảng classrooms
ALTER TABLE classrooms DROP COLUMN IF EXISTS academic_program_id;

-- Bước 3: Đảm bảo major_id là NOT NULL trong classrooms
ALTER TABLE classrooms MODIFY COLUMN major_id BIGINT NOT NULL;

-- Bước 4: Xóa bảng academic_program_subjects (many-to-many)
DROP TABLE IF EXISTS academic_program_subjects;

-- Bước 5: Xóa bảng program_subjects (nếu có)
DROP TABLE IF EXISTS program_subjects;

-- Bước 6: Xóa bảng academic_programs
DROP TABLE IF EXISTS academic_programs;

-- Bước 7: Xóa view nếu có
DROP VIEW IF EXISTS v_classroom_program_info;

-- Bước 8: Xóa stored procedure nếu có
DROP PROCEDURE IF EXISTS CreateAcademicProgram;

-- Kiểm tra kết quả
SELECT 'Cleanup completed successfully!' as status;

-- Hiển thị cấu trúc bảng classrooms sau khi cleanup
DESCRIBE classrooms;

-- Hiển thị thống kê
SELECT 
    m.major_code,
    m.major_name,
    m.course_year,
    COUNT(c.id) as classroom_count,
    COUNT(s.id) as student_count
FROM majors m
LEFT JOIN classrooms c ON c.major_id = m.id
LEFT JOIN students s ON s.classroom_id = c.id
GROUP BY m.id, m.major_code, m.major_name, m.course_year
ORDER BY m.major_code, m.course_year;