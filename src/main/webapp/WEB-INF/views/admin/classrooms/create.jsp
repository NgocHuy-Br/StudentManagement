<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Thêm Lớp Học Mới - StudentManagement</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
            <style>
                .form-container {
                    max-width: 600px;
                    margin: 2rem auto;
                    padding: 2rem;
                    background: #fff;
                    border-radius: 10px;
                    box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
                }

                .required {
                    color: red;
                }
            </style>
        </head>

        <body class="bg-light">
            <div class="container">
                <div class="form-container">
                    <h2 class="text-center mb-4 text-primary">
                        <i class="fas fa-plus-circle"></i> Thêm Lớp Học Mới
                    </h2>

                    <!-- Hiển thị thông báo -->
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-triangle"></i> ${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <c:if test="${not empty success}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <i class="fas fa-check-circle"></i> ${success}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <form action="/admin/classrooms" method="post" id="classroomForm">
                        <!-- Mã lớp -->
                        <div class="mb-3">
                            <label for="classCode" class="form-label">
                                Mã lớp <span class="required">*</span>
                            </label>
                            <input type="text" class="form-control" id="classCode" name="classCode"
                                placeholder="Ví dụ: D20CQCN01-N" required maxlength="20">
                            <div class="form-text">Mã lớp phải duy nhất trong hệ thống</div>
                        </div>

                        <!-- Chọn ngành -->
                        <div class="mb-3">
                            <label for="majorCode" class="form-label">
                                Ngành học <span class="required">*</span>
                            </label>
                            <select class="form-select" id="majorCode" name="majorCode" required>
                                <option value="">-- Chọn ngành học --</option>
                            </select>
                            <div class="form-text">Chọn ngành đào tạo</div>
                        </div>

                        <!-- Chọn khóa học -->
                        <div class="mb-3">
                            <label for="courseYear" class="form-label">
                                Khóa học <span class="required">*</span>
                            </label>
                            <select class="form-select" id="courseYear" name="courseYear" required disabled>
                                <option value="">-- Chọn khóa học --</option>
                            </select>
                            <div class="form-text">Khóa học sẽ được tải sau khi chọn ngành</div>
                        </div>

                        <!-- Giáo viên chủ nhiệm -->
                        <div class="mb-3">
                            <label for="teacherId" class="form-label">
                                Giáo viên chủ nhiệm
                            </label>
                            <select class="form-select" id="teacherId" name="teacherId">
                                <option value="">-- Chọn giáo viên chủ nhiệm (tùy chọn) --</option>
                                <c:forEach var="teacher" items="${teachers}">
                                    <option value="${teacher.id}">
                                        ${teacher.teacherCode} - ${teacher.lastName} ${teacher.firstName}
                                    </option>
                                </c:forEach>
                            </select>
                            <div class="form-text">Có thể để trống và gán sau</div>
                        </div>

                        <!-- Nút thao tác -->
                        <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                            <a href="/admin/classrooms" class="btn btn-secondary me-md-2">
                                <i class="fas fa-arrow-left"></i> Quay lại
                            </a>
                            <button type="submit" class="btn btn-primary" id="submitBtn">
                                <i class="fas fa-save"></i> Tạo lớp học
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
            <script src="https://kit.fontawesome.com/yourkitcode.js"></script>

            <script>
                document.addEventListener('DOMContentLoaded', function () {
                    const majorCodeSelect = document.getElementById('majorCode');
                    const courseYearSelect = document.getElementById('courseYear');
                    const submitBtn = document.getElementById('submitBtn');

                    // Load danh sách mã ngành
                    loadMajorCodes();

                    // Lắng nghe thay đổi ngành
                    majorCodeSelect.addEventListener('change', function () {
                        const selectedMajor = this.value;
                        if (selectedMajor) {
                            loadCourseYears(selectedMajor);
                        } else {
                            courseYearSelect.innerHTML = '<option value="">-- Chọn khóa học --</option>';
                            courseYearSelect.disabled = true;
                        }
                    });

                    // Load danh sách mã ngành
                    function loadMajorCodes() {
                        fetch('/admin/api/major-codes')
                            .then(response => response.json())
                            .then(data => {
                                majorCodeSelect.innerHTML = '<option value="">-- Chọn ngành học --</option>';
                                data.forEach(majorCode => {
                                    const option = document.createElement('option');
                                    option.value = majorCode;
                                    option.textContent = majorCode;
                                    majorCodeSelect.appendChild(option);
                                });
                            })
                            .catch(error => {
                                console.error('Lỗi khi tải danh sách ngành:', error);
                                alert('Không thể tải danh sách ngành. Vui lòng thử lại.');
                            });
                    }

                    // Load danh sách khóa học theo ngành
                    function loadCourseYears(majorCode) {
                        courseYearSelect.disabled = true;
                        courseYearSelect.innerHTML = '<option value="">Đang tải...</option>';

                        fetch(`/admin/api/course-years/${majorCode}`)
                            .then(response => response.json())
                            .then(data => {
                                courseYearSelect.innerHTML = '<option value="">-- Chọn khóa học --</option>';
                                data.forEach(courseYear => {
                                    const option = document.createElement('option');
                                    option.value = courseYear;
                                    option.textContent = courseYear;
                                    courseYearSelect.appendChild(option);
                                });
                                courseYearSelect.disabled = false;
                            })
                            .catch(error => {
                                console.error('Lỗi khi tải danh sách khóa:', error);
                                courseYearSelect.innerHTML = '<option value="">Lỗi tải dữ liệu</option>';
                                alert('Không thể tải danh sách khóa học. Vui lòng thử lại.');
                            });
                    }

                    // Validation form trước khi submit
                    document.getElementById('classroomForm').addEventListener('submit', function (e) {
                        const classCode = document.getElementById('classCode').value.trim();
                        const majorCode = document.getElementById('majorCode').value;
                        const courseYear = document.getElementById('courseYear').value;

                        if (!classCode) {
                            e.preventDefault();
                            alert('Vui lòng nhập mã lớp!');
                            return;
                        }

                        if (!majorCode) {
                            e.preventDefault();
                            alert('Vui lòng chọn ngành học!');
                            return;
                        }

                        if (!courseYear) {
                            e.preventDefault();
                            alert('Vui lòng chọn khóa học!');
                            return;
                        }

                        // Disable submit button để tránh double submit
                        submitBtn.disabled = true;
                        submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang tạo...';
                    });
                });
            </script>
        </body>

        </html>