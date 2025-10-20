<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Tổng quan - Hệ thống quản lý học tập</title>
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
                        rel="stylesheet">
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
                        rel="stylesheet">
                    <style>
                        /* Ensure consistent layout - prevent horizontal overflow */
                        .content-row {
                            margin-left: 0 !important;
                            margin-right: 0 !important;
                            max-width: 100%;
                            overflow-x: hidden;
                        }

                        .card {
                            border: none;
                            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                            border-radius: 8px;
                        }

                        /* Account Info Card - Simple Blue */
                        .account-info-card .card-header {
                            background-color: #4e73df;
                        }

                        /* Stats Overview Card - Simple Green */
                        .stats-overview-card .card-header {
                            background-color: #1cc88a;
                        }

                        /* Class List Card - Simple Purple */
                        .class-list-card .card-header {
                            background-color: #6f42c1;
                        }

                        .stat-card {
                            border-radius: 8px;
                        }

                        .stat-icon {
                            width: 50px;
                            height: 50px;
                            border-radius: 50%;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            font-size: 24px;
                            color: white;
                        }

                        /* Simple solid colors for icons */
                        .stat-icon.green {
                            background-color: #28a745;
                        }

                        .stat-icon.blue {
                            background-color: #007bff;
                        }

                        .stat-icon.orange {
                            background-color: #fd7e14;
                        }

                        .stat-number {
                            font-size: 2rem;
                            font-weight: 700;
                            color: #5a5c69;
                        }

                        /* Simple class card styling */
                        .class-detail-card {
                            border-radius: 8px;
                        }

                        .class-title {
                            color: #007bff;
                            font-weight: 600;
                        }
                    </style>
                </head>

                <body>
                    <div class="container-fluid" style="padding: 0 clamp(12px, 4vw, 36px);">
                        <%@ include file="../common/header.jsp" %>

                            <c:set var="activeTab" value="dashboard" scope="request" />
                            <%@ include file="_nav.jsp" %>

                                <!-- Include notification modal -->
                                <%@ include file="../common/notification-modal.jsp" %>

                                    <div class="row mt-4 content-row">
                                        <!-- Thông tin tài khoản Giáo viên -->
                                        <div class="col-xl-4 col-lg-5 mb-4">
                                            <div class="card h-100 account-info-card">
                                                <div class="card-header text-white">
                                                    <h5 class="card-title mb-0">
                                                        <i class="bi bi-person-circle me-2"></i>Thông tin tài khoản
                                                    </h5>
                                                </div>
                                                <div class="card-body">
                                                    <table class="table table-borderless">
                                                        <tr>
                                                            <td class="fw-bold text-muted" style="width: 40%;">Họ tên:
                                                            </td>
                                                            <td>${teacher.user.lname} ${teacher.user.fname}</td>
                                                        </tr>
                                                        <tr>
                                                            <td class="fw-bold text-muted">Mã giáo viên:</td>
                                                            <td>${teacher.teacherCode != null ? teacher.teacherCode :
                                                                teacher.user.username}</td>
                                                        </tr>
                                                        <tr>
                                                            <td class="fw-bold text-muted">Khoa:</td>
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${teacher.faculty != null}">
                                                                        ${teacher.faculty.name}
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        ${teacher.department != null ?
                                                                        teacher.department : 'Chưa cập nhật'}
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="fw-bold text-muted">Ngày sinh:</td>
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${teacher.user.birthDate != null}">
                                                                        ${teacher.user.birthDate}
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        Chưa cập nhật
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="fw-bold text-muted">Email:</td>
                                                            <td>${teacher.user.email != null ? teacher.user.email :
                                                                'Chưa cập nhật'}</td>
                                                        </tr>
                                                        <tr>
                                                            <td class="fw-bold text-muted">Số điện thoại:</td>
                                                            <td>${teacher.user.phone != null ? teacher.user.phone :
                                                                'Chưa cập nhật'}</td>
                                                        </tr>
                                                        <tr>
                                                            <td class="fw-bold text-muted">Vai trò:</td>
                                                            <td>
                                                                <span class="badge bg-success">GIÁO VIÊN</span>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="fw-bold text-muted">Tài khoản đăng nhập:</td>
                                                            <td>${teacher.user.username}</td>
                                                        </tr>
                                                        <tr>
                                                            <td class="fw-bold text-muted">Mật khẩu:</td>
                                                            <td>
                                                                <span class="text-muted">••••••••••</span>
                                                                <button type="button"
                                                                    class="btn btn-outline-secondary btn-sm ms-2"
                                                                    id="changePasswordBtn" data-bs-toggle="tooltip"
                                                                    data-bs-placement="top" title="Đổi mật khẩu">
                                                                    <i class="bi bi-key me-1"></i>Đổi mật khẩu
                                                                </button>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Thống kê hoạt động giảng dạy -->
                                        <div class="col-xl-8 col-lg-7">
                                            <div class="row">
                                                <!-- Thống kê tổng quan -->
                                                <div class="col-12 mb-4">
                                                    <div class="card stats-overview-card">
                                                        <div class="card-header text-white">
                                                            <h5 class="card-title mb-0">
                                                                <i class="bi bi-bar-chart me-2"></i>Tổng quan giảng dạy
                                                            </h5>
                                                        </div>
                                                        <div class="card-body">
                                                            <div class="row">
                                                                <!-- Số lớp phụ trách -->
                                                                <div class="col-md-4 mb-3">
                                                                    <div class="card stat-card">
                                                                        <div class="card-body text-center">
                                                                            <div class="stat-icon mx-auto mb-3 green">
                                                                                <i class="bi bi-house-door-fill"></i>
                                                                            </div>
                                                                            <div class="stat-number mb-2">
                                                                                ${fn:length(assignedClasses)}
                                                                            </div>
                                                                            <h6 class="card-title mb-0 text-muted">Lớp
                                                                                phụ trách</h6>
                                                                        </div>
                                                                    </div>
                                                                </div>

                                                                <!-- Tổng sinh viên -->
                                                                <div class="col-md-4 mb-3">
                                                                    <div class="card stat-card">
                                                                        <div class="card-body text-center">
                                                                            <div class="stat-icon mx-auto mb-3 blue">
                                                                                <i class="bi bi-people-fill"></i>
                                                                            </div>
                                                                            <div class="stat-number mb-2">
                                                                                <c:set var="totalStudents" value="0" />
                                                                                <c:forEach var="classroom"
                                                                                    items="${assignedClasses}">
                                                                                    <c:set var="totalStudents"
                                                                                        value="${totalStudents + classroom.currentSize}" />
                                                                                </c:forEach>
                                                                                ${totalStudents}
                                                                            </div>
                                                                            <h6 class="card-title mb-0 text-muted">Sinh
                                                                                viên</h6>
                                                                        </div>
                                                                    </div>
                                                                </div>

                                                                <!-- Tổng môn học của lớp -->
                                                                <div class="col-md-4 mb-3">
                                                                    <div class="card stat-card">
                                                                        <div class="card-body text-center">
                                                                            <div class="stat-icon mx-auto mb-3 orange">
                                                                                <i class="bi bi-journal-text"></i>
                                                                            </div>
                                                                            <div class="stat-number mb-2">
                                                                                <c:set var="totalSubjects" value="0" />
                                                                                <c:forEach var="classroom"
                                                                                    items="${assignedClasses}">
                                                                                    <c:set var="totalSubjects"
                                                                                        value="${totalSubjects + fn:length(classroom.major.subjects)}" />
                                                                                </c:forEach>
                                                                                ${totalSubjects}
                                                                            </div>
                                                                            <h6 class="card-title mb-0 text-muted">Tổng
                                                                                môn học</h6>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- Chi tiết lớp phụ trách -->
                                                <div class="col-12 mb-4">
                                                    <div class="card class-list-card">
                                                        <div class="card-header text-white">
                                                            <h5 class="card-title mb-0">
                                                                <i class="bi bi-list-ul me-2"></i>Danh sách lớp phụ
                                                                trách
                                                            </h5>
                                                        </div>
                                                        <div class="card-body">
                                                            <c:choose>
                                                                <c:when test="${not empty assignedClasses}">
                                                                    <div class="row">
                                                                        <c:forEach var="classroom"
                                                                            items="${assignedClasses}">
                                                                            <div class="col-md-6 mb-3">
                                                                                <div
                                                                                    class="card class-detail-card border-blue">
                                                                                    <div class="card-body">
                                                                                        <h6
                                                                                            class="card-title class-title">
                                                                                            <i
                                                                                                class="bi bi-house-door me-2"></i>${classroom.classCode}
                                                                                        </h6>
                                                                                        <p class="text-muted mb-2">
                                                                                            <strong>Ngành:</strong>
                                                                                            ${classroom.major.majorName}
                                                                                        </p>
                                                                                        <p class="text-muted mb-2">
                                                                                            <strong>Khóa:</strong>
                                                                                            ${classroom.courseYear}
                                                                                        </p>
                                                                                        <p class="text-muted mb-2">
                                                                                            <strong>Sinh viên:</strong>
                                                                                            ${classroom.currentSize}/${classroom.maxSize}
                                                                                        </p>
                                                                                        <p class="text-muted mb-3">
                                                                                            <strong>Môn học:</strong>
                                                                                            ${fn:length(classroom.major.subjects)}
                                                                                            môn
                                                                                        </p>
                                                                                        <div class="d-flex gap-2">
                                                                                            <a href="/teacher/classes?classId=${classroom.id}"
                                                                                                class="btn btn-modern btn-outline-primary btn-sm">
                                                                                                <i
                                                                                                    class="bi bi-eye me-1"></i>Xem
                                                                                                chi tiết
                                                                                            </a>
                                                                                            <a href="/teacher/scores?classroomId=${classroom.id}"
                                                                                                class="btn btn-modern btn-outline-success btn-sm">
                                                                                                <i
                                                                                                    class="bi bi-clipboard-data me-1"></i>Quản
                                                                                                lý điểm
                                                                                            </a>
                                                                                        </div>
                                                                                    </div>
                                                                                </div>
                                                                            </div>
                                                                        </c:forEach>
                                                                    </div>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <div class="text-center text-muted py-4">
                                                                        <i class="bi bi-info-circle me-2"></i>
                                                                        Bạn chưa được phân công lớp nào
                                                                    </div>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                    </div>
                                                </div>


                                            </div>
                                        </div>
                                    </div>

                                    <!-- Change Password Modal -->
                                    <div class="modal fade" id="changePasswordModal" tabindex="-1"
                                        aria-labelledby="changePasswordModalLabel" aria-hidden="true">
                                        <div class="modal-dialog">
                                            <div class="modal-content">
                                                <div class="modal-header">
                                                    <h5 class="modal-title" id="changePasswordModalLabel">
                                                        <i class="bi bi-key me-2"></i>Đổi mật khẩu
                                                    </h5>
                                                    <button type="button" class="btn-close" data-bs-dismiss="modal"
                                                        aria-label="Close"></button>
                                                </div>
                                                <form id="changePasswordForm" method="post"
                                                    action="${pageContext.request.contextPath}/teacher/change-password">
                                                    <div class="modal-body">
                                                        <div class="mb-3">
                                                            <label for="currentPassword" class="form-label">Mật khẩu
                                                                hiện
                                                                tại <span class="text-danger">*</span></label>
                                                            <div class="input-group">
                                                                <input type="password" class="form-control"
                                                                    id="currentPassword" name="currentPassword"
                                                                    required>
                                                                <button class="btn btn-outline-secondary" type="button"
                                                                    onclick="togglePasswordVisibility('currentPassword')">
                                                                    <i class="bi bi-eye" id="currentPasswordIcon"></i>
                                                                </button>
                                                            </div>
                                                            <div class="invalid-feedback">
                                                                Vui lòng nhập mật khẩu hiện tại.
                                                            </div>
                                                        </div>
                                                        <div class="mb-3">
                                                            <label for="newPassword" class="form-label">Mật khẩu mới
                                                                <span class="text-danger">*</span></label>
                                                            <div class="input-group">
                                                                <input type="password" class="form-control"
                                                                    id="newPassword" name="newPassword" required
                                                                    minlength="6">
                                                                <button class="btn btn-outline-secondary" type="button"
                                                                    onclick="togglePasswordVisibility('newPassword')">
                                                                    <i class="bi bi-eye" id="newPasswordIcon"></i>
                                                                </button>
                                                            </div>
                                                            <div class="invalid-feedback">
                                                                Mật khẩu mới phải có ít nhất 6 ký tự.
                                                            </div>
                                                        </div>
                                                        <div class="mb-3">
                                                            <label for="confirmPassword" class="form-label">Xác nhận mật
                                                                khẩu mới <span class="text-danger">*</span></label>
                                                            <div class="input-group">
                                                                <input type="password" class="form-control"
                                                                    id="confirmPassword" name="confirmPassword" required
                                                                    minlength="6">
                                                                <button class="btn btn-outline-secondary" type="button"
                                                                    onclick="togglePasswordVisibility('confirmPassword')">
                                                                    <i class="bi bi-eye" id="confirmPasswordIcon"></i>
                                                                </button>
                                                            </div>
                                                            <div class="invalid-feedback">
                                                                Xác nhận mật khẩu không khớp.
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="modal-footer">
                                                        <button type="button" class="btn btn-secondary"
                                                            data-bs-dismiss="modal">Hủy</button>
                                                        <button type="submit" class="btn btn-primary">
                                                            <i class="bi bi-check-lg me-1"></i>Cập nhật
                                                        </button>
                                                    </div>
                                                </form>
                                            </div>
                                        </div>
                                    </div>

                    </div>

                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
                    <script>
                        document.addEventListener('DOMContentLoaded', function () {
                            // Initialize tooltips
                            var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
                            var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
                                return new bootstrap.Tooltip(tooltipTriggerEl);
                            });

                            // Handle change password modal
                            const changePasswordBtn = document.getElementById('changePasswordBtn');
                            const changePasswordModal = new bootstrap.Modal(document.getElementById('changePasswordModal'));

                            if (changePasswordBtn) {
                                changePasswordBtn.addEventListener('click', function () {
                                    changePasswordModal.show();
                                });
                            }

                            // Handle password form validation
                            const changePasswordForm = document.getElementById('changePasswordForm');
                            changePasswordForm.addEventListener('submit', function (e) {
                                e.preventDefault();

                                const newPassword = document.getElementById('newPassword').value;
                                const confirmPassword = document.getElementById('confirmPassword').value;

                                // Reset previous validation
                                document.querySelectorAll('.is-invalid').forEach(el => el.classList.remove('is-invalid'));

                                if (newPassword !== confirmPassword) {
                                    document.getElementById('confirmPassword').classList.add('is-invalid');
                                    return false;
                                }

                                if (newPassword.length < 6) {
                                    document.getElementById('newPassword').classList.add('is-invalid');
                                    return false;
                                }

                                // If validation passes, submit the form
                                this.submit();
                            });

                            // Real-time password confirmation validation
                            document.getElementById('confirmPassword').addEventListener('input', function () {
                                const newPassword = document.getElementById('newPassword').value;
                                const confirmPassword = this.value;

                                if (confirmPassword && newPassword !== confirmPassword) {
                                    this.classList.add('is-invalid');
                                } else {
                                    this.classList.remove('is-invalid');
                                }
                            });
                        });

                        // Toggle password visibility
                        function togglePasswordVisibility(fieldId) {
                            const passwordField = document.getElementById(fieldId);
                            const icon = document.getElementById(fieldId + 'Icon');

                            if (passwordField.type === 'password') {
                                passwordField.type = 'text';
                                icon.classList.remove('bi-eye');
                                icon.classList.add('bi-eye-slash');
                            } else {
                                passwordField.type = 'password';
                                icon.classList.remove('bi-eye-slash');
                                icon.classList.add('bi-eye');
                            }
                        }
                    </script>
                </body>

                </html>