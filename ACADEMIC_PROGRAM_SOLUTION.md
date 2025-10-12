# GIẢI PHÁP QUẢN LÝ QUAN HỆ CHƯƠNG TRÌNH ĐÀO TẠO

## 🎯 VẤN ĐỀ ĐÃ GIẢI QUYẾT

**Câu hỏi của bạn:** "làm sao để quản lý đơn giản quan hệ này"

**Vấn đề cũ:**
- Quan hệ trực tiếp giữa Lớp học ↔ Ngành học
- Khó quản lý thay đổi chương trình đào tạo theo năm
- Không linh hoạt khi ngành có nhiều chương trình khác nhau
- Dữ liệu bị trùng lặp và khó bảo trì

**Giải pháp mới:**
```
Lớp học → Chương trình đào tạo → Ngành học
        ↓
    Danh sách môn học
```

## 🏗️ KIẾN TRÚC GIẢI PHÁP

### 1. Entity Mới: `AcademicProgram`
```java
// Chương trình đào tạo làm trung gian
Classroom → AcademicProgram → Major
                ↓
            List<Subject>
```

### 2. Quan Hệ Cơ Sở Dữ Liệu
```sql
academic_programs (bảng chính)
├── id (Primary Key)
├── program_code (Mã chương trình: CNTT2301)
├── program_name (Tên chương trình)
├── academic_year (Năm học: 2023-2024)
├── major_id (Ngành học)
├── status (ACTIVE/INACTIVE/DRAFT)
└── created_at, updated_at

academic_program_subjects (Many-to-Many)
├── academic_program_id
└── subject_id

classrooms (đã cập nhật)
├── academic_program_id (Mới)
└── major_id (Giữ lại cho backward compatibility)
```

### 3. Luồng Quản Lý
```
1. Tạo Chương trình đào tạo mới
   ├── Chọn ngành học
   ├── Định nghĩa năm học
   ├── Chọn các môn học
   └── Tự động tạo mã chương trình

2. Gán Lớp học vào Chương trình
   ├── Chọn chương trình đào tạo
   ├── Tự động kế thừa ngành học
   └── Tự động có danh sách môn học

3. Quản lý Thay đổi
   ├── Kích hoạt/vô hiệu hóa chương trình
   ├── Cập nhật môn học theo từng chương trình
   └── Theo dõi lịch sử thay đổi
```

## 📁 CÁC FILE ĐÃ TẠO/CẬP NHẬT

### 1. Entity Layer
- ✅ `AcademicProgram.java` - Entity chương trình đào tạo
- ✅ `Classroom.java` - Cập nhật quan hệ với AcademicProgram

### 2. Repository Layer  
- ✅ `AcademicProgramRepository.java` - Truy vấn chương trình đào tạo

### 3. Service Layer
- ✅ `AcademicProgramService.java` - Business logic quản lý chương trình

### 4. Controller Layer
- ✅ `AcademicProgramController.java` - REST API và Web Controller

### 5. Database Migration
- ✅ `migrate_academic_program.sql` - Script migration tự động

## 🚀 CÁCH TRIỂN KHAI

### Bước 1: Chạy Migration
```sql
-- Chạy file migrate_academic_program.sql
mysql -u root -p student_management < migrate_academic_program.sql
```

### Bước 2: Restart Application
```bash
# Build và restart ứng dụng để load các entity mới
mvn clean install
java -jar target/StudentManagement-0.0.1-SNAPSHOT.jar
```

### Bước 3: Truy Cập Giao Diện Quản Lý
```
http://localhost:8080/admin/academic-programs
```

## 💡 LỢI ÍCH CỦA GIẢI PHÁP

### 1. **Đơn Giản Hóa Quản Lý**
- 1 bảng trung gian thay vì nhiều quan hệ phức tạp
- Tự động tạo mã chương trình
- Dễ dàng thêm/xóa môn học theo chương trình

### 2. **Tính Linh Hoạt**
- Một ngành có thể có nhiều chương trình khác nhau
- Chương trình có thể kích hoạt/vô hiệu hóa
- Dễ dàng cập nhật môn học theo từng năm

### 3. **Khả Năng Mở Rộng**
- Có thể thêm thông tin chi tiết cho từng chương trình
- Hỗ trợ versioning chương trình đào tạo
- Tích hợp với hệ thống điểm số hiện tại

### 4. **Bảo Trì Dữ Liệu**
- Giảm trùng lặp dữ liệu
- Đảm bảo tính nhất quán
- Dễ dàng backup và restore

## 🔧 API ENDPOINTS

### Quản Lý Chương Trình
```
GET    /admin/academic-programs           # Danh sách chương trình
GET    /admin/academic-programs/create    # Form tạo mới
POST   /admin/academic-programs/create    # Xử lý tạo mới
GET    /admin/academic-programs/{id}      # Chi tiết chương trình
GET    /admin/academic-programs/{id}/edit # Form chỉnh sửa
POST   /admin/academic-programs/{id}/edit # Cập nhật chương trình
POST   /admin/academic-programs/{id}/delete # Xóa chương trình
```

### API Ajax
```
GET    /admin/academic-programs/by-major/{majorId}     # Lấy chương trình theo ngành
GET    /admin/academic-programs/generate-code          # Tạo mã tự động
POST   /admin/academic-programs/{id}/activate         # Kích hoạt
POST   /admin/academic-programs/{id}/deactivate       # Vô hiệu hóa
```

## 📊 THỐNG KÊ SAU MIGRATION

Migration sẽ tự động:
- Tạo chương trình đào tạo cho các ngành hiện có
- Gán các lớp học vào chương trình tương ứng  
- Liên kết môn học với chương trình
- Tạo view để truy vấn thông tin tổng hợp

## 🎉 KẾT QUẢ

**Trước:** Lớp → Ngành (Phức tạp, khó bảo trì)
**Sau:** Lớp → Chương trình → Ngành (Đơn giản, linh hoạt)

Giải pháp này giúp bạn:
✅ Quản lý quan hệ đơn giản hơn
✅ Dễ dàng thay đổi chương trình đào tạo
✅ Tăng tính linh hoạt của hệ thống
✅ Chuẩn bị tốt cho việc mở rộng tương lai

**Sẵn sàng triển khai ngay!** 🚀