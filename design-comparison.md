# 📋 So sánh các phương án thiết kế

## Option 1: ClassroomTeacher (RECOMMENDED ⭐)

### ✅ Ưu điểm:
- **Tách biệt rõ ràng**: Quản lý riêng giáo viên chủ nhiệm vs giáo viên dạy môn
- **Lịch sử đầy đủ**: Lưu trữ tất cả thay đổi giáo viên chủ nhiệm
- **Không ảnh hưởng**: Giữ nguyên TeacherSubject cho việc quản lý giáo viên dạy môn
- **Dễ query**: Dễ tìm giáo viên hiện tại (endDate = null)
- **Audit trail**: Có thể xem lịch sử thay đổi

### ⚠️ Nhược điểm:
- Thêm 1 entity mới
- Cần migration data

## Option 2: TeacherClassroom (thay thế TeacherSubject)

### ✅ Ưu điểm:
- **Liên kết đúng**: Dùng Classroom entity thay vì String className
- **Đa chức năng**: Có thể mở rộng cho nhiều loại quan hệ
- **Tiết kiệm**: Chỉ cần 1 entity

### ⚠️ Nhược điểm:
- **Trộn lẫn**: Vẫn có thể gây confusion giữa các role
- **Migration phức tạp**: Phải chuyển đổi toàn bộ TeacherSubject
- **Mất dữ liệu**: Thông tin về subject/semester có thể bị mất

## 🏆 KHUYẾN NGHỊ: Option 1 - ClassroomTeacher

### 🎯 Thiết kế cuối cùng:

```
Classroom (1) -----> (*) ClassroomTeacher (*) <----- (1) Teacher
    |                                                     |
    |-- homeRoomTeacher: Teacher (current)               |
    |-- classroomTeachers: List<ClassroomTeacher>        |-- teacherSubjects: List<TeacherSubject>
                                                          |-- classroomTeachers: List<ClassroomTeacher>

TeacherSubject: Quản lý giáo viên dạy môn học
ClassroomTeacher: Quản lý giáo viên chủ nhiệm lớp
```

### 🔧 Cập nhật cần thiết:

1. **Tạo ClassroomTeacher entity** ✅
2. **Cập nhật Classroom entity**:
   - Thêm quan hệ với ClassroomTeacher
   - Giữ homeRoomTeacher cho query nhanh
3. **Cập nhật Teacher entity**:
   - Thêm quan hệ với ClassroomTeacher
4. **Tạo Repository và Service**
5. **Tạo UI quản lý**

### 🎲 Use Cases:

```java
// Tìm giáo viên chủ nhiệm hiện tại
ClassroomTeacher current = classroomTeacherRepo.findByClassroomAndEndDateIsNull(classroom);

// Lịch sử giáo viên chủ nhiệm
List<ClassroomTeacher> history = classroomTeacherRepo.findByClassroomOrderByStartDateDesc(classroom);

// Thay đổi giáo viên chủ nhiệm
ClassroomTeacher oldTeacher = getCurrentHomeRoomTeacher(classroom);
oldTeacher.setEndDate(LocalDate.now());
oldTeacher.setNotes("Chuyển công tác");

ClassroomTeacher newTeacher = new ClassroomTeacher(classroom, newTeacher, LocalDate.now(), "Nhận chuyển giao");
```