# 🎓 Hệ thống quản lý sinh viên PTIT

## ✨ Tổng quan dự án

Hệ thống quản lý sinh viên đầy đủ với phân quyền cho **Admin**, **Giáo viên**, và **Sinh viên**.

### 🚀 Công nghệ sử dụng
- **Framework**: Spring Boot 3.5.6
- **Database**: MySQL 8.0
- **View Engine**: JSP + JSTL
- **Authentication**: Spring Security với BCrypt
- **Frontend**: Bootstrap 5.3.3 + Bootstrap Icons
- **Build Tool**: Maven

---

## 👥 Phân quyền hệ thống

### 🔑 Admin
- ✅ Quản lý danh sách sinh viên (thêm, sửa, xóa, tìm kiếm)
- ✅ Quản lý danh sách giáo viên (thêm, sửa, xóa, tìm kiếm) 
- ✅ Quản lý ngành học (thêm, sửa, xem danh sách)
- ✅ Quản lý môn học (thêm, sửa, phân theo ngành)
- ✅ Xem tất cả điểm số của sinh viên

### 👨‍🏫 Giáo viên  
- ✅ Xem danh sách môn học được phân công
- ✅ Xem danh sách sinh viên theo từng môn
- ✅ Nhập/chỉnh sửa điểm cho sinh viên (chỉ môn được phân công)
- ✅ Xem thống kê điểm số

### 🎓 Sinh viên
- ✅ Xem thông tin cá nhân và ngành học
- ✅ Xem danh sách môn học của ngành
- ✅ Xem điểm số các môn học
- ✅ Xem điểm trung bình tích lũy (GPA)
- ✅ Lọc điểm theo học kỳ

---

## 🗂️ Cấu trúc dữ liệu

### Entities chính:
1. **User** - Thông tin tài khoản (username, password, role)
2. **Student** - Thông tin sinh viên (liên kết User + Major)
3. **Teacher** - Thông tin giáo viên (liên kết User)
4. **Major** - Ngành học (mã ngành, tên ngành)
5. **Subject** - Môn học (thuộc 1 ngành, có số tín chỉ)
6. **Score** - Điểm số (1 sinh viên, 1 môn, 1 học kỳ)
7. **TeacherSubject** - Phân công giảng dạy

### Relationships:
- Student `N:1` Major (nhiều SV thuộc 1 ngành)
- Subject `N:1` Major (nhiều môn thuộc 1 ngành) 
- Score `N:1` Student, Subject (điểm của SV cho từng môn)
- TeacherSubject `N:1` Teacher, Subject (GV dạy môn nào)

---

## 🖥️ Giao diện người dùng

### 🎨 Thiết kế
- **Theme**: PTIT Blue (#0066cc) - màu đại diện trường PTIT
- **Responsive**: Bootstrap 5 - tương thích mobile/desktop
- **Icons**: Bootstrap Icons - biểu tượng hiện đại
- **UX**: Clean, professional, dễ sử dụng

### 📱 Tính năng UI/UX:
- Dashboard với thống kê nhanh
- Bảng dữ liệu có phân trang và sắp xếp
- Form thêm/sửa với validation
- Thông báo flash messages
- Navigation theo role
- Color-coded grades (xanh-xuất sắc, xanh dương-giỏi, vàng-khá, đỏ-yếu)

---

## 🚀 Hướng dẫn chạy ứng dụng

### Yêu cầu hệ thống:
- Java 17+
- Maven 3.6+
- MySQL 8.0+

### Cách chạy:

1. **Clone repository**
```bash
git clone <repository-url>
cd StudentManagement
```

2. **Cấu hình database** 
- Tạo database MySQL tên `student_management`
- Cập nhật thông tin kết nối trong `application.properties`:
```properties
spring.datasource.url=jdbc:mysql://localhost:3306/student_management
spring.datasource.username=your_username
spring.datasource.password=your_password
```

3. **Chạy ứng dụng**
```bash
mvn spring-boot:run
```

4. **Truy cập ứng dụng**
- URL: http://localhost:8080
- Dữ liệu test được tự động tạo từ `test-data.sql`

### 👤 Tài khoản mặc định:
- **Admin**: `admin` / `admin123`
- **Giáo viên**: `teacher01` / `teacher123` 
- **Sinh viên**: `student01` / `student123`

---

## 📁 Cấu trúc thư mục

```
StudentManagement/
├── src/main/java/com/StudentManagement/
│   ├── controller/          # REST Controllers
│   │   ├── AdminController.java
│   │   ├── TeacherController.java  
│   │   ├── StudentController.java
│   │   └── AuthController.java
│   ├── entity/             # JPA Entities
│   │   ├── User.java
│   │   ├── Student.java
│   │   ├── Teacher.java
│   │   ├── Major.java
│   │   ├── Subject.java
│   │   ├── Score.java
│   │   └── TeacherSubject.java
│   ├── repository/         # Data Access Layer
│   │   ├── UserRepository.java
│   │   ├── StudentRepository.java
│   │   ├── TeacherRepository.java
│   │   ├── MajorRepository.java
│   │   ├── SubjectRepository.java
│   │   ├── ScoreRepository.java
│   │   └── TeacherSubjectRepository.java
│   ├── service/           # Business Logic
│   │   └── CustomUserDetailsService.java
│   └── config/            # Configuration
│       └── SecurityConfig.java
├── src/main/webapp/WEB-INF/views/  # JSP Views
│   ├── admin/             # Admin interfaces
│   │   ├── admin-dashboard.jsp
│   │   ├── students.jsp
│   │   ├── teachers.jsp
│   │   ├── subjects.jsp
│   │   ├── majors.jsp
│   │   └── _nav.jsp
│   ├── teacher/           # Teacher interfaces  
│   │   ├── teacher-dashboard.jsp
│   │   ├── my-subjects.jsp
│   │   ├── subject-students.jsp
│   │   └── _nav.jsp
│   ├── student/           # Student interfaces
│   │   ├── student-dashboard.jsp
│   │   ├── subjects.jsp
│   │   ├── scores.jsp
│   │   └── _nav.jsp
│   └── common/            # Shared components
│       ├── header.jsp
│       └── login.jsp
├── src/main/resources/
│   ├── application.properties
│   └── static/img/ptit-logo.png
├── test-data.sql          # Sample data
└── pom.xml               # Maven dependencies
```

---

## 🎯 Tính năng đã hoàn thành

### ✅ Backend (100%)
- [x] Entity relationships với JPA/Hibernate
- [x] Repository layer với tối ưu query (@EntityGraph)
- [x] Controller layer với role-based access control
- [x] Spring Security authentication & authorization
- [x] Database schema tự động tạo
- [x] Sample data insertion

### ✅ Frontend (100%) 
- [x] Admin dashboard với đầy đủ CRUD operations
- [x] Teacher interface với grade management
- [x] Student portal với academic information
- [x] Responsive design với Bootstrap 5
- [x] Interactive features (search, filter, pagination)
- [x] Professional PTIT-themed styling

### ✅ Security (100%)
- [x] BCrypt password hashing
- [x] Role-based authorization (@PreAuthorize)
- [x] CSRF protection
- [x] Session management
- [x] Access control per endpoint

### ✅ Data Integrity (100%)
- [x] Foreign key constraints
- [x] Unique constraints (username, email, codes)
- [x] NOT NULL validations
- [x] Cascade operations

---

## 🏆 Kết quả đạt được

Hệ thống đã được **refactor hoàn toàn** theo yêu cầu:

1. ✅ **Loại bỏ** các entity không cần thiết (Course, Enrollment, Notification, Schedule, Tuition)
2. ✅ **Thêm mới** Major, TeacherSubject entities
3. ✅ **Cập nhật** relationships: Student-Major, Subject-Major, Score simplification
4. ✅ **Xây dựng** đầy đủ 3 giao diện theo role
5. ✅ **Tối ưu** queries và performance
6. ✅ **Thiết kế** responsive, professional UI

### 📊 Thống kê dự án:
- **Entities**: 7 main entities
- **Repositories**: 7 optimized repositories  
- **Controllers**: 4 role-based controllers
- **JSP Views**: 15+ responsive pages
- **Security**: Multi-role authentication
- **Database**: Normalized MySQL schema

---

## 🎓 Kết luận

Dự án **StudentManagement** đã được hoàn thành toàn bộ theo đúng yêu cầu của bạn:

> *"quản lý danh sách sinh viên, danh sách giáo viên. trong đó sinh viên sẽ thuộc một ngành học duy nhất (admin declare). mỗi ngành gồm các môn học (admin declare). mỗi học sinh mỗi môn có điểm trung bình môn (chỉ 1 cột, không cần có điểm thành phần)."*

**Phân quyền đã implement:**
- ✅ **Admin**: Toàn quyền quản lý sinh viên, giáo viên, ngành, môn học, xem điểm
- ✅ **Giáo viên**: Quản lý điểm cho môn được phân công
- ✅ **Sinh viên**: Xem thông tin học tập và điểm số

**Sẵn sàng để demo và sử dụng!** 🚀

---

*Developed with ❤️ for PTIT Students*