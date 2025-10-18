-- Script để chuyển đổi mối quan hệ giữa Subject và Major từ Many-to-Many sang One-to-Many
-- Bước 1: Thêm cột major_id vào bảng subjects
ALTER TABLE subjects ADD COLUMN major_id BIGINT;

-- Bước 2: Migrate dữ liệu từ bảng major_subjects sang cột major_id trong subjects
-- Chỉ lấy quan hệ đầu tiên nếu môn học thuộc nhiều ngành
UPDATE subjects s 
SET major_id = (
    SELECT ms.major_id 
    FROM major_subjects ms 
    WHERE ms.subject_id = s.id 
    LIMIT 1
)
WHERE EXISTS (
    SELECT 1 FROM major_subjects ms WHERE ms.subject_id = s.id
);

-- Bước 3: Thêm foreign key constraint (tùy chọn)
-- ALTER TABLE subjects ADD CONSTRAINT FK_subject_major FOREIGN KEY (major_id) REFERENCES majors(id);

-- Bước 4: Xóa bảng major_subjects (sau khi đã migrate xong)
DROP TABLE IF EXISTS major_subjects;

-- Bước 5: Cập nhật các môn học chưa có ngành về null (để xử lý sau)
-- Các môn học này sẽ không hiển thị trong danh sách "thêm môn có sẵn" cho đến khi được gán ngành