-- Fix dữ liệu classroom_teachers cho lớp K22
INSERT INTO classroom_teachers (classroom_id, teacher_id, start_date, notes) 
VALUES (1, 18, '2024-09-01', 'Fixed from admin assignment');

-- Kiểm tra kết quả
SELECT 
    c.class_code,
    c.teacher_id as classroom_teacher_id,
    ct.teacher_id as ct_teacher_id,
    ct.start_date,
    ct.end_date
FROM classrooms c
LEFT JOIN classroom_teachers ct ON c.id = ct.classroom_id AND ct.end_date IS NULL
WHERE c.class_code = 'K22';