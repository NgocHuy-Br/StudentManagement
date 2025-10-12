-- Insert sample faculty data for testing Faculty-Major relationship

INSERT INTO faculties (faculty_code, name, description, created_at, updated_at) VALUES
('CNTT', 'Công nghệ thông tin', 'Khoa Công nghệ thông tin', NOW(), NOW()),
('DTVT', 'Điện tử viễn thông', 'Khoa Điện tử viễn thông', NOW(), NOW()),
('KT', 'Kinh tế', 'Khoa Kinh tế', NOW(), NOW()),
('CK', 'Cơ khí', 'Khoa Cơ khí', NOW(), NOW()),
('HH', 'Hóa học', 'Khoa Hóa học', NOW(), NOW());

-- Update existing majors to assign them to faculties
-- Assuming there are some majors in the database, update them with faculty_id

-- Update majors related to IT to CNTT faculty
UPDATE majors 
SET faculty_id = (SELECT id FROM faculties WHERE faculty_code = 'CNTT' LIMIT 1)
WHERE major_code IN ('CNTT', 'KHMT', 'ATTT', 'MMT') OR major_name LIKE '%công nghệ thông tin%' OR major_name LIKE '%khoa học máy tính%';

-- Update majors related to Electronics to DTVT faculty  
UPDATE majors 
SET faculty_id = (SELECT id FROM faculties WHERE faculty_code = 'DTVT' LIMIT 1)
WHERE major_code IN ('DTVT', 'KTDT', 'TT') OR major_name LIKE '%điện tử%' OR major_name LIKE '%viễn thông%';

-- Update majors related to Economics to KT faculty
UPDATE majors 
SET faculty_id = (SELECT id FROM faculties WHERE faculty_code = 'KT' LIMIT 1)  
WHERE major_code IN ('KT', 'QTKD', 'TC', 'KT') OR major_name LIKE '%kinh tế%' OR major_name LIKE '%quản trị%';

-- Update majors related to Mechanical to CK faculty
UPDATE majors 
SET faculty_id = (SELECT id FROM faculties WHERE faculty_code = 'CK' LIMIT 1)
WHERE major_code IN ('CK', 'CNCK', 'OTO') OR major_name LIKE '%cơ khí%' OR major_name LIKE '%ô tô%';

-- For any remaining majors without faculty, assign to CNTT as default
UPDATE majors 
SET faculty_id = (SELECT id FROM faculties WHERE faculty_code = 'CNTT' LIMIT 1)
WHERE faculty_id IS NULL;

-- Verify the results
SELECT 
    m.id, 
    m.major_code, 
    m.major_name, 
    f.faculty_code, 
    f.name as faculty_name 
FROM majors m 
LEFT JOIN faculties f ON m.faculty_id = f.id 
ORDER BY f.faculty_code, m.major_code;