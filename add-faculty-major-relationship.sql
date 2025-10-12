-- Add faculty_id column to majors table to establish relationship
-- One faculty has many majors, each major belongs to one faculty

-- Step 1: Add faculty_id column (nullable first to allow existing data)
ALTER TABLE majors ADD COLUMN faculty_id BIGINT;

-- Step 2: Add foreign key constraint
ALTER TABLE majors ADD CONSTRAINT fk_majors_faculty 
    FOREIGN KEY (faculty_id) REFERENCES faculties(id) ON DELETE CASCADE;

-- Step 3: Update existing majors with default faculty (you need to adjust based on your data)
-- This is just an example - you should update based on your actual faculty data
-- Uncomment and modify the following lines based on your faculty setup:

-- UPDATE majors SET faculty_id = (SELECT id FROM faculties WHERE faculty_code = 'CNTT' LIMIT 1) 
-- WHERE major_code IN ('CNTT', 'KHMT', 'ATTT');

-- UPDATE majors SET faculty_id = (SELECT id FROM faculties WHERE faculty_code = 'DTVT' LIMIT 1) 
-- WHERE major_code IN ('DTVT', 'KTDT');

-- UPDATE majors SET faculty_id = (SELECT id FROM faculties WHERE faculty_code = 'KT' LIMIT 1) 
-- WHERE major_code IN ('KT', 'QTKD');

-- Step 4: Make faculty_id NOT NULL after assigning values
-- ALTER TABLE majors MODIFY COLUMN faculty_id BIGINT NOT NULL;

-- Check the result
SELECT 
    m.id, 
    m.major_code, 
    m.major_name, 
    f.faculty_code, 
    f.name as faculty_name 
FROM majors m 
LEFT JOIN faculties f ON m.faculty_id = f.id 
ORDER BY f.faculty_code, m.major_code;