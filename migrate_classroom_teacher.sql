-- Migration script để chuyển dữ liệu từ homeRoomTeacher sang ClassroomTeacher
-- Chạy script này sau khi đã tạo bảng classroom_teachers

-- 1. Tạo bảng classroom_teachers nếu chưa có
CREATE TABLE IF NOT EXISTS classroom_teachers (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    classroom_id BIGINT NOT NULL,
    teacher_id BIGINT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NULL,
    notes VARCHAR(500) NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (classroom_id) REFERENCES classrooms(id) ON DELETE CASCADE,
    FOREIGN KEY (teacher_id) REFERENCES teachers(id) ON DELETE CASCADE
);

-- 2. Chuyển dữ liệu từ classrooms.teacher_id sang classroom_teachers
INSERT INTO classroom_teachers (classroom_id, teacher_id, start_date, notes)
SELECT 
    c.id as classroom_id,
    c.teacher_id as teacher_id,
    COALESCE(
        -- Ưu tiên ngày tạo lớp học nếu có
        DATE(c.created_at),
        -- Nếu không có thì dùng ngày đầu năm học
        STR_TO_DATE(CONCAT(SUBSTRING(c.course_year, 1, 4), '-09-01'), '%Y-%m-%d'),
        -- Fallback: ngày hiện tại
        CURDATE()
    ) as start_date,
    'Dữ liệu chuyển đổi từ hệ thống cũ' as notes
FROM classrooms c
WHERE c.teacher_id IS NOT NULL
-- Chỉ chuyển những bản ghi chưa tồn tại
AND NOT EXISTS (
    SELECT 1 FROM classroom_teachers ct 
    WHERE ct.classroom_id = c.id 
    AND ct.teacher_id = c.teacher_id 
    AND ct.end_date IS NULL
);

-- 3. Kiểm tra kết quả migration
SELECT 
    'Migration Summary' as info,
    COUNT(*) as total_migrated_records
FROM classroom_teachers
WHERE notes LIKE '%chuyển đổi từ hệ thống cũ%';

-- 4. Hiển thị thống kê sau migration
SELECT 
    'Statistics' as type,
    'Total classrooms' as description,
    COUNT(*) as count
FROM classrooms
UNION ALL
SELECT 
    'Statistics' as type,
    'Classrooms with homeroom teacher' as description,
    COUNT(*) as count
FROM classrooms 
WHERE teacher_id IS NOT NULL
UNION ALL
SELECT 
    'Statistics' as type,
    'ClassroomTeacher records created' as description,
    COUNT(*) as count
FROM classroom_teachers
UNION ALL
SELECT 
    'Statistics' as type,
    'Current homeroom assignments' as description,
    COUNT(*) as count
FROM classroom_teachers
WHERE end_date IS NULL;

-- 5. Validation: Kiểm tra tính nhất quán dữ liệu
SELECT 
    c.id as classroom_id,
    c.class_code,
    c.teacher_id as old_teacher_id,
    ct.teacher_id as new_teacher_id,
    ct.start_date,
    ct.end_date,
    CASE 
        WHEN c.teacher_id = ct.teacher_id THEN 'CONSISTENT'
        ELSE 'INCONSISTENT'
    END as status
FROM classrooms c
LEFT JOIN classroom_teachers ct ON c.id = ct.classroom_id AND ct.end_date IS NULL
WHERE c.teacher_id IS NOT NULL
ORDER BY c.class_code;

-- 6. Optional: Backup dữ liệu cũ trước khi xóa
-- CREATE TABLE classroom_teacher_backup AS 
-- SELECT id, teacher_id, 'homeroom_teacher_backup' as source, NOW() as backup_date
-- FROM classrooms WHERE teacher_id IS NOT NULL;

-- 7. Optional: Sau khi xác nhận migration thành công, có thể comment out để giữ tương thích
-- ALTER TABLE classrooms DROP FOREIGN KEY IF EXISTS fk_classroom_teacher;
-- ALTER TABLE classrooms DROP COLUMN IF EXISTS teacher_id;

COMMIT;