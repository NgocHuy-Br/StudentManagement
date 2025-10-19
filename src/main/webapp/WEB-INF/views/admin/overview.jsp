<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <!DOCTYPE html>
            <html>

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Tổng quan - Hệ thống quản lý sinh viên</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
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
                </style>
            </head>

            <body>
                <div class="container-fluid" style="padding: 0 clamp(12px, 4vw, 36px);">
                    <%@ include file="../common/header.jsp" %>

                        <c:set var="activeTab" value="overview" scope="request" />
                        <%@ include file="_nav.jsp" %>

                            <!-- Include notification modal -->
                            <%@ include file="../common/notification-modal.jsp" %>

                                <div class="row mt-4 content-row">
                                    <!-- Thông tin tài khoản Admin -->
                                    <div class="col-xl-4 col-lg-5 mb-4">
                                        <div class="card h-100">
                                            <div class="card-header bg-primary text-white">
                                                <h5 class="card-title mb-0">
                                                    <i class="bi bi-person-circle me-2"></i>Thông tin tài khoản
                                                </h5>
                                            </div>
                                            <div class="card-body">
                                                <div class="text-center mb-3">
                                                    <i class="bi bi-person-circle display-4 text-primary"></i>
                                                </div>
                                                <table class="table table-borderless">
                                                    <tr>
                                                        <td class="fw-bold text-muted" style="width: 40%;">Họ tên:</td>
                                                        <td>${currentUser.fullName != null ? currentUser.fullName :
                                                            'Chưa
                                                            cập nhật'}
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="fw-bold text-muted">Ngày sinh:</td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${currentUser.birthDate != null}">
                                                                    ${currentUser.birthDate}
                                                                </c:when>
                                                                <c:otherwise>
                                                                    Chưa cập nhật
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="fw-bold text-muted">Email:</td>
                                                        <td>${currentUser.email != null ? currentUser.email : 'Chưa cập
                                                            nhật'}</td>
                                                    </tr>
                                                    <tr>
                                                        <td class="fw-bold text-muted">Số điện thoại:</td>
                                                        <td>${currentUser.phone != null ? currentUser.phone : 'Chưa cập
                                                            nhật'}</td>
                                                    </tr>
                                                    <tr>
                                                        <td class="fw-bold text-muted">Vai trò:</td>
                                                        <td>
                                                            <span class="badge bg-danger">${currentUser.role}</span>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="fw-bold text-muted">Tài khoản đăng nhập:</td>
                                                        <td>${currentUser.username}</td>
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
                                                <div class="text-center mt-3">
                                                    <button type="button" class="btn btn-outline-primary btn-sm"
                                                        id="editProfileBtn" data-bs-toggle="tooltip"
                                                        data-bs-placement="top" title="Chỉnh sửa thông tin cá nhân">
                                                        <i class="bi bi-person-gear me-1"></i>Chỉnh sửa thông tin
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Thống kê tổng quan -->
                                    <div class="col-xl-8 col-lg-7">
                                        <!-- Thống kê tổng quát -->
                                        <div class="row mb-4">
                                            <div class="col-lg-3 col-md-6 mb-3">
                                                <div class="card bg-primary text-white">
                                                    <div class="card-body">
                                                        <div class="d-flex justify-content-between">
                                                            <div>
                                                                <h6 class="card-title mb-1">Tổng số Khoa</h6>
                                                                <h2 class="mb-0">${totalStats.totalFaculties}</h2>
                                                            </div>
                                                            <div class="align-self-center">
                                                                <i class="bi bi-building display-5"></i>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="col-lg-3 col-md-6 mb-3">
                                                <div class="card bg-success text-white">
                                                    <div class="card-body">
                                                        <div class="d-flex justify-content-between">
                                                            <div>
                                                                <h6 class="card-title mb-1">Tổng số Ngành</h6>
                                                                <h2 class="mb-0">${totalStats.totalMajors}</h2>
                                                            </div>
                                                            <div class="align-self-center">
                                                                <i class="bi bi-mortarboard display-5"></i>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="col-lg-3 col-md-6 mb-3">
                                                <div class="card bg-info text-white">
                                                    <div class="card-body">
                                                        <div class="d-flex justify-content-between">
                                                            <div>
                                                                <h6 class="card-title mb-1">Tổng Giáo viên</h6>
                                                                <h2 class="mb-0">${totalStats.totalTeachers}</h2>
                                                            </div>
                                                            <div class="align-self-center">
                                                                <i class="bi bi-people display-5"></i>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="col-lg-3 col-md-6 mb-3">
                                                <div class="card bg-warning text-white">
                                                    <div class="card-body">
                                                        <div class="d-flex justify-content-between">
                                                            <div>
                                                                <h6 class="card-title mb-1">Tổng Học sinh</h6>
                                                                <h2 class="mb-0">${totalStats.totalStudents}</h2>
                                                            </div>
                                                            <div class="align-self-center">
                                                                <i class="bi bi-person-graduation display-5"></i>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Thống kê theo khoa -->
                                        <div class="card">
                                            <div class="card-header bg-secondary text-white">
                                                <h5 class="card-title mb-0">
                                                    <i class="bi bi-bar-chart me-2"></i>Thống kê theo Khoa
                                                </h5>
                                            </div>
                                            <div class="card-body">
                                                <div class="table-responsive">
                                                    <table class="table table-hover">
                                                        <thead class="table-light">
                                                            <tr>
                                                                <th>Khoa</th>
                                                                <th class="text-center">Số Ngành</th>
                                                                <th class="text-center">Số Giáo viên</th>
                                                                <th class="text-center">Số Học sinh</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <c:forEach var="facultyStat" items="${facultyStats}">
                                                                <tr>
                                                                    <td>
                                                                        <div class="d-flex align-items-center">
                                                                            <i
                                                                                class="bi bi-building text-primary me-2"></i>
                                                                            <div>
                                                                                <div class="fw-bold">
                                                                                    ${facultyStat.facultyName}
                                                                                </div>
                                                                                <small
                                                                                    class="text-muted">${facultyStat.facultyCode}</small>
                                                                            </div>
                                                                        </div>
                                                                    </td>
                                                                    <td class="text-center">
                                                                        <span
                                                                            class="badge bg-success rounded-pill">${facultyStat.majorCount}</span>
                                                                    </td>
                                                                    <td class="text-center">
                                                                        <span
                                                                            class="badge bg-info rounded-pill">${facultyStat.teacherCount}</span>
                                                                    </td>
                                                                    <td class="text-center">
                                                                        <span
                                                                            class="badge bg-warning rounded-pill">${facultyStat.studentCount}</span>
                                                                    </td>
                                                                </tr>
                                                            </c:forEach>
                                                            <c:if test="${empty facultyStats}">
                                                                <tr>
                                                                    <td colspan="4" class="text-center text-muted py-4">
                                                                        <i
                                                                            class="bi bi-inbox display-4 d-block mb-2"></i>
                                                                        Chưa có dữ liệu thống kê
                                                                    </td>
                                                                </tr>
                                                            </c:if>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Thống kê theo ngành -->
                                        <div class="card mt-4">
                                            <div class="card-header bg-dark text-white">
                                                <h5 class="card-title mb-0">
                                                    <i class="bi bi-graph-up me-2"></i>Thống kê theo Ngành
                                                </h5>
                                            </div>
                                            <div class="card-body">
                                                <div class="table-responsive">
                                                    <table class="table table-hover">
                                                        <thead class="table-light">
                                                            <tr>
                                                                <th>Ngành</th>
                                                                <th>Thuộc Khoa</th>
                                                                <th class="text-center">Số Học sinh</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <c:forEach var="majorStat" items="${majorStats}">
                                                                <tr>
                                                                    <td>
                                                                        <div class="d-flex align-items-center">
                                                                            <i
                                                                                class="bi bi-mortarboard text-success me-2"></i>
                                                                            <div>
                                                                                <div class="fw-bold">
                                                                                    ${majorStat.majorName}
                                                                                </div>
                                                                                <small
                                                                                    class="text-muted">${majorStat.majorCode}</small>
                                                                            </div>
                                                                        </div>
                                                                    </td>
                                                                    <td>
                                                                        <small
                                                                            class="text-muted">${majorStat.facultyName}</small>
                                                                    </td>
                                                                    <td class="text-center">
                                                                        <span
                                                                            class="badge bg-warning rounded-pill">${majorStat.studentCount}</span>
                                                                    </td>
                                                                </tr>
                                                            </c:forEach>
                                                            <c:if test="${empty majorStats}">
                                                                <tr>
                                                                    <td colspan="3" class="text-center text-muted py-4">
                                                                        <i
                                                                            class="bi bi-inbox display-4 d-block mb-2"></i>
                                                                        Chưa có dữ liệu thống kê
                                                                    </td>
                                                                </tr>
                                                            </c:if>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                </div>

                <!-- Profile Edit Modal -->
                <div class="modal fade" id="editProfileModal" tabindex="-1" aria-labelledby="editProfileModalLabel"
                    aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="editProfileModalLabel">Chỉnh sửa thông tin tài khoản</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"
                                    aria-label="Close"></button>
                            </div>
                            <form id="editProfileForm" action="${pageContext.request.contextPath}/admin/update-profile"
                                method="post">
                                <div class="modal-body">
                                    <div class="mb-3">
                                        <label for="editUsername" class="form-label">Tên đăng nhập</label>
                                        <input type="text" class="form-control" id="editUsername" name="username"
                                            value="${currentUser.username}" readonly style="background-color: #f8f9fa;">
                                    </div>
                                    <div class="mb-3">
                                        <label for="editFullName" class="form-label">Họ và tên</label>
                                        <input type="text" class="form-control" id="editFullName" name="fullName"
                                            value="${currentUser.fullName}" required>
                                    </div>
                                    <div class="mb-3">
                                        <label for="editBirthDate" class="form-label">Ngày sinh</label>
                                        <input type="date" class="form-control" id="editBirthDate" name="birthDate"
                                            value="${currentUser.birthDate}">
                                    </div>
                                    <div class="mb-3">
                                        <label for="editEmail" class="form-label">Email</label>
                                        <input type="email" class="form-control" id="editEmail" name="email"
                                            value="${currentUser.email}" required>
                                    </div>
                                    <div class="mb-3">
                                        <label for="editPhone" class="form-label">Số điện thoại</label>
                                        <input type="text" class="form-control" id="editPhone" name="phone"
                                            value="${currentUser.phone}">
                                    </div>
                                    <div class="mb-3">
                                        <label for="editAddress" class="form-label">Địa chỉ</label>
                                        <textarea class="form-control" id="editAddress" name="address"
                                            rows="1">${currentUser.address}</textarea>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                                    <button type="submit" class="btn btn-primary">
                                        <i class="bi bi-check-lg"></i> Cập nhật
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- Email Confirmation Modal -->
                <div class="modal fade" id="emailConfirmModal" tabindex="-1" aria-labelledby="emailConfirmModalLabel"
                    aria-hidden="true">
                    <div class="modal-dialog modal-sm">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="emailConfirmModalLabel">Xác nhận đổi email</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"
                                    aria-label="Close"></button>
                            </div>
                            <form id="emailConfirmForm" action="${pageContext.request.contextPath}/admin/update-email"
                                method="post">
                                <div class="modal-body">
                                    <p class="text-muted">Để đổi email, vui lòng nhập mật khẩu hiện tại:</p>
                                    <input type="hidden" id="newEmailValue" name="newEmail">
                                    <div class="mb-3">
                                        <label for="emailPassword" class="form-label">Mật khẩu hiện tại</label>
                                        <input type="password" class="form-control" id="emailPassword"
                                            name="currentPassword" required placeholder="Nhập mật khẩu hiện tại">
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                                    <button type="submit" class="btn btn-primary">Xác nhận</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- Change Password Modal -->
                <div class="modal fade" id="changePasswordModal" tabindex="-1"
                    aria-labelledby="changePasswordModalLabel" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="changePasswordModalLabel">Đổi mật khẩu</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"
                                    aria-label="Close"></button>
                            </div>
                            <form id="changePasswordForm"
                                action="${pageContext.request.contextPath}/admin/change-password" method="post">
                                <div class="modal-body">
                                    <div class="mb-3">
                                        <label for="oldPassword" class="form-label">Mật khẩu hiện tại</label>
                                        <div class="input-group">
                                            <input type="password" class="form-control" id="oldPassword"
                                                name="oldPassword" required placeholder="Nhập mật khẩu hiện tại">
                                            <button class="btn btn-outline-secondary" type="button"
                                                onclick="togglePasswordVisibility('oldPassword', this)"
                                                data-bs-toggle="tooltip" data-bs-placement="top"
                                                title="Hiển thị mật khẩu">
                                                <i class="bi bi-eye"></i>
                                            </button>
                                        </div>
                                    </div>
                                    <div class="mb-3">
                                        <label for="newPassword" class="form-label">Mật khẩu mới</label>
                                        <div class="input-group">
                                            <input type="password" class="form-control" id="newPassword"
                                                name="newPassword" required placeholder="Nhập mật khẩu mới"
                                                minlength="5">
                                            <button class="btn btn-outline-secondary" type="button"
                                                onclick="togglePasswordVisibility('newPassword', this)"
                                                data-bs-toggle="tooltip" data-bs-placement="top"
                                                title="Hiển thị mật khẩu">
                                                <i class="bi bi-eye"></i>
                                            </button>
                                        </div>
                                        <div class="form-text">Mật khẩu phải có ít nhất 5 ký tự</div>
                                    </div>
                                    <div class="mb-3">
                                        <label for="confirmPassword" class="form-label">Xác nhận mật khẩu mới</label>
                                        <div class="input-group">
                                            <input type="password" class="form-control" id="confirmPassword"
                                                name="confirmPassword" required placeholder="Nhập lại mật khẩu mới">
                                            <button class="btn btn-outline-secondary" type="button"
                                                onclick="togglePasswordVisibility('confirmPassword', this)"
                                                data-bs-toggle="tooltip" data-bs-placement="top"
                                                title="Hiển thị mật khẩu">
                                                <i class="bi bi-eye"></i>
                                            </button>
                                        </div>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                                    <button type="submit" class="btn btn-primary">
                                        <i class="bi bi-key me-1"></i> Đổi mật khẩu
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
                <script>
                    let originalEmail = '${currentUser.email}';

                    // Initialize tooltips
                    document.addEventListener('DOMContentLoaded', function () {
                        var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
                        var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
                            return new bootstrap.Tooltip(tooltipTriggerEl);
                        });
                    });

                    // Handle profile edit button click
                    document.getElementById('editProfileBtn').addEventListener('click', function () {
                        var editModal = new bootstrap.Modal(document.getElementById('editProfileModal'));
                        editModal.show();
                    });

                    // Handle change password button click
                    document.getElementById('changePasswordBtn').addEventListener('click', function () {
                        var changePasswordModal = new bootstrap.Modal(document.getElementById('changePasswordModal'));
                        changePasswordModal.show();
                    });

                    // Handle profile form submission
                    document.getElementById('editProfileForm').addEventListener('submit', function (e) {
                        const currentEmail = document.getElementById('editEmail').value;

                        // Check if email changed
                        if (currentEmail !== originalEmail) {
                            e.preventDefault();

                            // Show email confirmation modal
                            document.getElementById('newEmailValue').value = currentEmail;

                            // Hide profile modal and show email confirmation
                            bootstrap.Modal.getInstance(document.getElementById('editProfileModal')).hide();
                            var emailModal = new bootstrap.Modal(document.getElementById('emailConfirmModal'));
                            emailModal.show();

                            return false;
                        }

                        // If email not changed, proceed normally (no password required)
                        return true;
                    });

                    // Handle change password form validation
                    document.getElementById('changePasswordForm').addEventListener('submit', function (e) {
                        const newPassword = document.getElementById('newPassword').value;
                        const confirmPassword = document.getElementById('confirmPassword').value;

                        if (newPassword !== confirmPassword) {
                            e.preventDefault();
                            alert('Mật khẩu mới và xác nhận mật khẩu không khớp');
                            return false;
                        }

                        if (newPassword.length < 5) {
                            e.preventDefault();
                            alert('Mật khẩu phải có ít nhất 5 ký tự');
                            return false;
                        }
                    });

                    // Handle email confirmation form submission
                    document.getElementById('emailConfirmForm').addEventListener('submit', function (e) {
                        const password = document.getElementById('emailPassword').value;
                        if (!password.trim()) {
                            e.preventDefault();
                            alert('Vui lòng nhập mật khẩu hiện tại');
                            return false;
                        }
                    });

                    // Toggle password visibility function
                    function togglePasswordVisibility(inputId, button) {
                        const passwordInput = document.getElementById(inputId);
                        const icon = button.querySelector('i');

                        if (passwordInput.type === 'password') {
                            passwordInput.type = 'text';
                            icon.classList.remove('bi-eye');
                            icon.classList.add('bi-eye-slash');
                            button.setAttribute('title', 'Ẩn mật khẩu');
                        } else {
                            passwordInput.type = 'password';
                            icon.classList.remove('bi-eye-slash');
                            icon.classList.add('bi-eye');
                            button.setAttribute('title', 'Hiển thị mật khẩu');
                        }
                    }
                </script>
            </body>

            </html>