<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Tổng quan sinh viên</title>
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
                        rel="stylesheet">
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
                        rel="stylesheet">
                    <style>
                        :root {
                            --primary-color: #dc3545;
                            --primary-light: #f8d7da;
                        }

                        body {
                            background: #f7f7f9;
                            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                            /* Ensure consistent scrollbar with other pages */
                            overflow-x: hidden !important;
                            overflow-y: scroll !important;
                            min-height: 100vh !important;
                        }

                        .card {
                            border-radius: 12px;
                            box-shadow: 0 10px 25px rgba(0, 0, 0, .06);
                            border: none;
                        }

                        .dashboard-card {
                            transition: all 0.3s ease;
                            height: 100%;
                        }

                        .dashboard-card:hover {
                            transform: translateY(-5px);
                            box-shadow: 0 20px 40px rgba(0, 0, 0, .12);
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

                        .stat-number {
                            font-size: 2rem;
                            font-weight: 700;
                            color: var(--primary-color);
                        }





                        .student-info {
                            background: white;
                            border-radius: 12px;
                            padding: 1.5rem;
                            margin-bottom: 2rem;
                        }

                        .info-row {
                            display: flex;
                            align-items: center;
                            padding: 0.5rem 0;
                            border-bottom: 1px solid #f0f0f0;
                        }

                        .info-row:last-child {
                            border-bottom: none;
                        }

                        .info-label {
                            font-weight: 600;
                            color: #495057;
                            min-width: 180px;
                            margin-right: 1rem;
                        }

                        .info-value {
                            color: #212529;
                            font-weight: 500;
                            flex: 1;
                        }

                        .password-field {
                            display: flex;
                            align-items: center;
                            gap: 1rem;
                            flex: 1;
                        }

                        .password-hidden {
                            font-family: monospace;
                            letter-spacing: 2px;
                            color: #6c757d;
                        }

                        .btn-change-password {
                            background: #dc3545;
                            color: white;
                            border: none;
                            padding: 0.25rem 0.75rem;
                            border-radius: 4px;
                            font-size: 0.875rem;
                            cursor: pointer;
                            transition: background-color 0.2s;
                        }

                        .btn-change-password:hover {
                            background: #c82333;
                        }
                    </style>
                </head>

                <body>
                    <div class="container-fluid" style="padding: 0 clamp(12px, 4vw, 36px);">
                        <%@ include file="../common/header.jsp" %>

                            <c:set var="activeTab" value="dashboard" scope="request" />
                            <%@ include file="_nav.jsp" %>

                                <div class="mt-4">

                                    <!-- Student Information -->
                                    <div class="student-info">
                                        <h5 class="mb-3"><i class="bi bi-person-badge me-2"></i>Thông tin sinh viên</h5>
                                        <c:if test="${not empty student}">
                                            <div class="info-row">
                                                <span class="info-label">Họ và tên:</span>
                                                <span class="info-value">${student.user.lname}
                                                    ${student.user.fname}</span>
                                            </div>
                                            <div class="info-row">
                                                <span class="info-label">Mã sinh viên:</span>
                                                <span class="info-value">${student.user.username}</span>
                                            </div>
                                            <div class="info-row">
                                                <span class="info-label">Ngành học:</span>
                                                <span class="info-value">${student.major.majorName}</span>
                                            </div>
                                            <div class="info-row">
                                                <span class="info-label">Lớp:</span>
                                                <span class="info-value">${student.classroom.classCode}</span>
                                            </div>
                                            <div class="info-row">
                                                <span class="info-label">Email:</span>
                                                <span class="info-value">${student.user.email}</span>
                                            </div>
                                            <div class="info-row">
                                                <span class="info-label">Ngày sinh:</span>
                                                <span class="info-value">
                                                    <c:choose>
                                                        <c:when test="${not empty student.user.birthDate}">
                                                            <fmt:formatDate value="${student.user.birthDate}"
                                                                pattern="dd/MM/yyyy" />
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted">Chưa cập nhật</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </div>
                                            <div class="info-row">
                                                <span class="info-label">Địa chỉ:</span>
                                                <span class="info-value">
                                                    <c:choose>
                                                        <c:when test="${not empty student.user.address}">
                                                            ${student.user.address}
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted">Chưa cập nhật</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </div>
                                            <div class="info-row">
                                                <span class="info-label">Số điện thoại:</span>
                                                <span class="info-value">
                                                    <c:choose>
                                                        <c:when test="${not empty student.user.phone}">
                                                            ${student.user.phone}
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted">Chưa cập nhật</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </div>
                                            <div class="info-row">
                                                <span class="info-label">Số CCCD:</span>
                                                <span class="info-value">
                                                    <c:choose>
                                                        <c:when test="${not empty student.user.nationalId}">
                                                            ${student.user.nationalId}
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted">Chưa cập nhật</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </div>
                                            <div class="info-row">
                                                <span class="info-label">Tài khoản đăng nhập:</span>
                                                <span class="info-value">${student.user.username}</span>
                                            </div>
                                            <div class="info-row">
                                                <span class="info-label">Mật khẩu:</span>
                                                <div class="password-field">
                                                    <span class="password-hidden">••••••••</span>
                                                    <button type="button" class="btn-change-password"
                                                        onclick="openChangePasswordModal()">
                                                        <i class="bi bi-key me-1"></i>Đổi mật khẩu
                                                    </button>
                                                </div>
                                            </div>
                                        </c:if>
                                    </div>

                                    <!-- Statistics Cards -->
                                    <div class="row mb-4">
                                        <div class="col-md-4 mb-3">
                                            <div class="card dashboard-card">
                                                <div class="card-body text-center">
                                                    <div class="stat-icon mx-auto mb-3" style="background: #17a2b8;">
                                                        <i class="bi bi-bookmark-check-fill"></i>
                                                    </div>
                                                    <div class="stat-number">${totalCredits}</div>
                                                    <h6 class="card-title mb-0">Số tín chỉ tích lũy</h6>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-4 mb-3">
                                            <div class="card dashboard-card">
                                                <div class="card-body text-center">
                                                    <div class="stat-icon mx-auto mb-3" style="background: #28a745;">
                                                        <i class="bi bi-trophy-fill"></i>
                                                    </div>
                                                    <div class="stat-number">
                                                        <fmt:formatNumber value="${gpa}" minFractionDigits="1"
                                                            maxFractionDigits="1" />
                                                    </div>
                                                    <h6 class="card-title mb-0">Điểm trung bình tích lũy</h6>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-4 mb-3">
                                            <div class="card dashboard-card">
                                                <div class="card-body text-center">
                                                    <div class="stat-icon mx-auto mb-3" style="background: #ffc107;">
                                                        <i class="bi bi-award-fill"></i>
                                                    </div>
                                                    <div class="stat-number">
                                                        <c:choose>
                                                            <c:when test="${gpa >= 8.5}">Xuất sắc</c:when>
                                                            <c:when test="${gpa >= 7.0}">Giỏi</c:when>
                                                            <c:when test="${gpa >= 6.5}">Khá</c:when>
                                                            <c:when test="${gpa >= 5.0}">Trung bình</c:when>
                                                            <c:otherwise>Yếu</c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                    <h6 class="card-title mb-0">Xếp loại điểm trung bình tích lũy</h6>
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
                                            <form id="changePasswordForm">
                                                <div class="modal-body">
                                                    <div class="mb-3">
                                                        <label for="currentPassword" class="form-label">Mật khẩu hiện
                                                            tại</label>
                                                        <div class="input-group">
                                                            <input type="password" class="form-control"
                                                                id="currentPassword" name="currentPassword" required>
                                                            <button class="btn btn-outline-secondary" type="button"
                                                                onclick="togglePassword('currentPassword')">
                                                                <i class="bi bi-eye" id="currentPasswordIcon"></i>
                                                            </button>
                                                        </div>
                                                    </div>
                                                    <div class="mb-3">
                                                        <label for="newPassword" class="form-label">Mật khẩu mới</label>
                                                        <div class="input-group">
                                                            <input type="password" class="form-control" id="newPassword"
                                                                name="newPassword" required minlength="6">
                                                            <button class="btn btn-outline-secondary" type="button"
                                                                onclick="togglePassword('newPassword')">
                                                                <i class="bi bi-eye" id="newPasswordIcon"></i>
                                                            </button>
                                                        </div>
                                                        <div class="form-text">Mật khẩu phải có ít nhất 6 ký tự</div>
                                                    </div>
                                                    <div class="mb-3">
                                                        <label for="confirmPassword" class="form-label">Xác nhận mật
                                                            khẩu mới</label>
                                                        <div class="input-group">
                                                            <input type="password" class="form-control"
                                                                id="confirmPassword" name="confirmPassword" required>
                                                            <button class="btn btn-outline-secondary" type="button"
                                                                onclick="togglePassword('confirmPassword')">
                                                                <i class="bi bi-eye" id="confirmPasswordIcon"></i>
                                                            </button>
                                                        </div>
                                                    </div>
                                                    <div id="passwordError" class="alert alert-danger d-none"></div>
                                                    <div id="passwordSuccess" class="alert alert-success d-none"></div>
                                                </div>
                                                <div class="modal-footer">
                                                    <button type="button" class="btn btn-secondary"
                                                        data-bs-dismiss="modal">Hủy</button>
                                                    <button type="submit" class="btn btn-primary">
                                                        <i class="bi bi-check-lg me-1"></i>Đổi mật khẩu
                                                    </button>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                    </div>

                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
                    <script>
                        function openChangePasswordModal() {
                            const modal = new bootstrap.Modal(document.getElementById('changePasswordModal'));
                            modal.show();
                        }

                        function togglePassword(fieldId) {
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

                        document.getElementById('changePasswordForm').addEventListener('submit', function (e) {
                            e.preventDefault();

                            const currentPassword = document.getElementById('currentPassword').value;
                            const newPassword = document.getElementById('newPassword').value;
                            const confirmPassword = document.getElementById('confirmPassword').value;

                            // Clear previous messages
                            document.getElementById('passwordError').classList.add('d-none');
                            document.getElementById('passwordSuccess').classList.add('d-none');

                            // Validate passwords match
                            if (newPassword !== confirmPassword) {
                                document.getElementById('passwordError').textContent = 'Mật khẩu mới và xác nhận mật khẩu không khớp';
                                document.getElementById('passwordError').classList.remove('d-none');
                                return;
                            }

                            // Send request to server
                            const formData = new FormData();
                            formData.append('currentPassword', currentPassword);
                            formData.append('newPassword', newPassword);

                            fetch('/student/change-password', {
                                method: 'POST',
                                headers: {
                                    'X-Requested-With': 'XMLHttpRequest'
                                },
                                body: formData
                            })
                                .then(response => response.json())
                                .then(data => {
                                    if (data.success) {
                                        document.getElementById('passwordSuccess').textContent = 'Đổi mật khẩu thành công!';
                                        document.getElementById('passwordSuccess').classList.remove('d-none');

                                        // Reset form
                                        document.getElementById('changePasswordForm').reset();

                                        // Close modal after 2 seconds
                                        setTimeout(() => {
                                            bootstrap.Modal.getInstance(document.getElementById('changePasswordModal')).hide();
                                        }, 2000);
                                    } else {
                                        document.getElementById('passwordError').textContent = data.message || 'Có lỗi xảy ra khi đổi mật khẩu';
                                        document.getElementById('passwordError').classList.remove('d-none');
                                    }
                                })
                                .catch(error => {
                                    console.error('Error:', error);
                                    document.getElementById('passwordError').textContent = 'Có lỗi xảy ra. Vui lòng thử lại sau.';
                                    document.getElementById('passwordError').classList.remove('d-none');
                                });
                        });
                    </script>
                </body>

                </html>