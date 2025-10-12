-- Script migration: Từ mô hình lớp-ngành trực tiếp sang mô hình chương trình đào tạo
-- Migration: Academic Program Implementation

-- Bước 1: Tạo bảng academic_programs
CREATE TABLE IF NOT EXISTS academic_programs (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    program_code VARCHAR(20) UNIQUE NOT NULL COMMENT 'Mã chương trình: CNTT2301, etc.',
    program_name VARCHAR(255) NOT NULL COMMENT 'Tên chương trình đào tạo',
    description TEXT COMMENT 'Mô tả chương trình',
    academic_year VARCHAR(10) NOT NULL COMMENT 'Năm học: 2023-2024',
    major_id BIGINT NOT NULL COMMENT 'Ngành đào tạo',
    status ENUM('ACTIVE', 'INACTIVE', 'DRAFT') DEFAULT 'DRAFT' COMMENT 'Trạng thái chương trình',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (major_id) REFERENCES majors(id) ON DELETE CASCADE,
    INDEX idx_program_code (program_code),
    INDEX idx_major_year (major_id, academic_year),
    INDEX idx_status (status)
) COMMENT='Bảng chương trình đào tạo';

-- Bước 2: Tạo bảng liên kết academic_program_subjects (Many-to-Many)
CREATE TABLE IF NOT EXISTS academic_program_subjects (
    academic_program_id BIGINT NOT NULL,
    subject_id BIGINT NOT NULL,
    
    PRIMARY KEY (academic_program_id, subject_id),
    FOREIGN KEY (academic_program_id) REFERENCES academic_programs(id) ON DELETE CASCADE,
    FOREIGN KEY (subject_id) REFERENCES subjects(id) ON DELETE CASCADE
) COMMENT='Bảng liên kết chương trình đào tạo và môn học';

-- Bước 3: Thêm cột academic_program_id vào bảng classrooms
ALTER TABLE classrooms 
ADD COLUMN academic_program_id BIGINT NULL COMMENT 'Chương trình đào tạo' AFTER major_id,
ADD INDEX idx_academic_program (academic_program_id);

-- Bước 4: Tạo chương trình đào tạo mặc định cho từng ngành học và năm học
-- Lấy danh sách ngành và năm học hiện có
INSERT INTO academic_programs (program_code, program_name, academic_year, major_id, status)
SELECT 
    CONCAT(m.major_code, SUBSTRING(c.course_year, 3), '01') as program_code,
    CONCAT('Chương trình ', m.major_name, ' - Khóa ', c.course_year) as program_name,
    CONCAT(c.course_year, '-', (CAST(c.course_year AS UNSIGNED) + 4)) as academic_year,
    m.id as major_id,
    'ACTIVE' as status
FROM 
    (SELECT DISTINCT major_id, course_year FROM classrooms) c
    INNER JOIN majors m ON c.major_id = m.id
WHERE NOT EXISTS (
    SELECT 1 FROM academic_programs ap 
    WHERE ap.major_id = m.id 
    AND ap.academic_year = CONCAT(c.course_year, '-', (CAST(c.course_year AS UNSIGNED) + 4))
);

-- Bước 5: Gán môn học vào chương trình đào tạo dựa trên quan hệ hiện tại
-- Lấy danh sách môn học của từng lớp và gán vào chương trình tương ứng
INSERT INTO academic_program_subjects (academic_program_id, subject_id)
SELECT DISTINCT 
    ap.id as academic_program_id,
    cs.subject_id
FROM academic_programs ap
INNER JOIN classrooms c ON c.major_id = ap.major_id 
    AND ap.academic_year = CONCAT(c.course_year, '-', (CAST(c.course_year AS UNSIGNED) + 4))
INNER JOIN classroom_subjects cs ON cs.classroom_id = c.id
WHERE NOT EXISTS (
    SELECT 1 FROM academic_program_subjects aps 
    WHERE aps.academic_program_id = ap.id 
    AND aps.subject_id = cs.subject_id
);

-- Bước 6: Cập nhật academic_program_id cho các lớp học
UPDATE classrooms c
INNER JOIN academic_programs ap ON c.major_id = ap.major_id 
    AND ap.academic_year = CONCAT(c.course_year, '-', (CAST(c.course_year AS UNSIGNED) + 4))
SET c.academic_program_id = ap.id
WHERE c.academic_program_id IS NULL;

-- Bước 7: Thêm ràng buộc foreign key cho academic_program_id
ALTER TABLE classrooms 
ADD CONSTRAINT fk_classroom_academic_program 
FOREIGN KEY (academic_program_id) REFERENCES academic_programs(id) ON DELETE RESTRICT;

-- Bước 8: Tạo view để dễ dàng truy vấn thông tin đầy đủ
CREATE OR REPLACE VIEW v_classroom_program_info AS
SELECT 
    c.id as classroom_id,
    c.class_code,
    c.course_year,
    m.major_name,
    m.major_code,
    ap.program_code,
    ap.program_name,
    ap.academic_year,
    ap.status as program_status,
    COUNT(DISTINCT s.id) as student_count,
    COUNT(DISTINCT aps.subject_id) as subject_count
FROM classrooms c
LEFT JOIN majors m ON c.major_id = m.id
LEFT JOIN academic_programs ap ON c.academic_program_id = ap.id
LEFT JOIN students s ON s.classroom_id = c.id
LEFT JOIN academic_program_subjects aps ON aps.academic_program_id = ap.id
GROUP BY c.id, c.class_code, c.course_year, m.major_name, m.major_code, 
         ap.program_code, ap.program_name, ap.academic_year, ap.status;

-- Bước 9: Thêm một số chỉ mục để tối ưu hiệu suất
CREATE INDEX idx_classroom_program_major ON classrooms(academic_program_id, major_id);
CREATE INDEX idx_program_major_year ON academic_programs(major_id, academic_year);

-- Bước 10: Tạo stored procedure để tạo chương trình mới
DELIMITER //
CREATE PROCEDURE CreateAcademicProgram(
    IN p_major_id BIGINT,
    IN p_academic_year VARCHAR(10),
    IN p_program_name VARCHAR(255),
    IN p_description TEXT,
    OUT p_program_id BIGINT,
    OUT p_program_code VARCHAR(20)
)
BEGIN
    DECLARE v_major_code VARCHAR(10);
    DECLARE v_year_code VARCHAR(2);
    DECLARE v_sequence INT DEFAULT 1;
    DECLARE v_temp_code VARCHAR(20);
    
    -- Lấy mã ngành
    SELECT major_code INTO v_major_code FROM majors WHERE id = p_major_id;
    
    -- Lấy 2 số cuối của năm
    SET v_year_code = RIGHT(SUBSTRING_INDEX(p_academic_year, '-', 1), 2);
    
    -- Tìm số thứ tự tiếp theo
    REPEAT
        SET v_temp_code = CONCAT(v_major_code, v_year_code, LPAD(v_sequence, 2, '0'));
        SET v_sequence = v_sequence + 1;
    UNTIL NOT EXISTS (SELECT 1 FROM academic_programs WHERE program_code = v_temp_code)
    END REPEAT;
    
    SET p_program_code = v_temp_code;
    
    -- Tạo chương trình mới
    INSERT INTO academic_programs (program_code, program_name, description, academic_year, major_id, status)
    VALUES (p_program_code, p_program_name, p_description, p_academic_year, p_major_id, 'DRAFT');
    
    SET p_program_id = LAST_INSERT_ID();
END //
DELIMITER ;

-- Script hoàn thành
SELECT 'Migration completed successfully!' as status,
       COUNT(*) as total_programs
FROM academic_programs;

-- Hiển thị thống kê sau migration
SELECT 
    m.major_name,
    COUNT(DISTINCT ap.id) as program_count,
    COUNT(DISTINCT c.id) as classroom_count,
    COUNT(DISTINCT s.id) as student_count
FROM majors m
LEFT JOIN academic_programs ap ON m.id = ap.major_id
LEFT JOIN classrooms c ON c.academic_program_id = ap.id  
LEFT JOIN students s ON s.classroom_id = c.id
GROUP BY m.id, m.major_name
ORDER BY m.major_name;