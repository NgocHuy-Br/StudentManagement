<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Dashboard Giáo viên</title>
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
                        rel="stylesheet">
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
                        rel="stylesheet">
                    <style>
                        :root {
                            --primary-color: #dc3545;
                            --primary-light: #f8d7da;
                        }

                        /* Ensure consistent layout - prevent horizontal overflow */
                        .content-row {
                            margin-left: 0 !important;
                            margin-right: 0 !important;
                            max-width: 100%;
                            overflow-x: hidden;
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

                        .student-avatar {
                            width: 40px;
                            height: 40px;
                            border-radius: 50%;
                            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            color: white;
                            font-weight: 600;
                            font-size: 14px;
                        }

                        .btn-action {
                            width: 32px;
                            height: 32px;
                            padding: 0;
                            display: inline-flex;
                            align-items: center;
                            justify-content: center;
                            border-radius: 6px;
                        }

                        .table-students tbody tr:hover {
                            background: #fffaf7;
                        }

                        .class-selector {
                            background: white;
                            border-radius: 12px;
                            padding: 1.5rem;
                            margin-bottom: 1.5rem;
                            box-shadow: 0 10px 25px rgba(0, 0, 0, .06);
                        }

                        .class-info-badge {
                            background: var(--primary-light);
                            color: var(--primary-color);
                            padding: 0.5rem 1rem;
                            border-radius: 8px;
                            font-weight: 600;
                            display: inline-flex;
                            align-items: center;
                            gap: 0.5rem;
                        }

                        .info-item {
                            display: flex;
                            justify-content: space-between;
                            align-items: center;
                            padding: .5rem 0;
                            border-bottom: 1px solid #e9ecef;
                        }

                        .info-item:last-child {
                            border-bottom: none;
                        }

                        .info-label {
                            font-weight: 500;
                            color: #6c757d;
                        }

                        .info-value {
                            font-weight: 600;
                            color: #212529;
                        }

                        .classroom-item {
                            display: flex;
                            justify-content: space-between;
                            align-items: center;
                            padding: .75rem;
                            background: #fff;
                            border: 1px solid #e9ecef;
                            border-radius: 8px;
                            margin-bottom: .5rem;
                        }

                        .classroom-item:hover {
                            box-shadow: 0 2px 4px rgba(0, 0, 0, .1);
                        }

                        .classroom-name {
                            font-weight: 600;
                            color: #212529;
                        }

                        .classroom-count {
                            background: #007bff;
                            color: white;
                            padding: .25rem .5rem;
                            border-radius: 6px;
                            font-size: .875rem;
                        }
                    </style>
                </head>

                <body>
                    <div class="container-fluid" style="padding: 0 clamp(12px, 4vw, 36px);">
                        <%@ include file="../common/header.jsp" %>

                            <c:set var="activeTab" value="dashboard" scope="request" />
                            <%@ include file="_nav.jsp" %>

                                <div class="row mt-4 content-row">

                                    <!-- Flash Messages -->
                                    <c:if test="${not empty success}">
                                        <div class="alert alert-success alert-dismissible fade show">
                                            <i class="bi bi-check-circle me-2"></i>${success}
                                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                        </div>
                                    </c:if>
                                    <c:if test="${not empty error}">
                                        <div class="alert alert-danger alert-dismissible fade show">
                                            <i class="bi bi-exclamation-triangle me-2"></i>${error}
                                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                        </div>
                                    </c:if>

                                    <!-- Teacher Info -->
                                    <div class="class-selector">
                                        <div class="row align-items-center">
                                            <div class="col-md-8">
                                                <h5 class="fw-semibold mb-0">
                                                    <i class="bi bi-person-circle"></i> Chào mừng, ${teacher.user.fname}
                                                    ${teacher.user.lname}
                                                </h5>
                                                <p class="text-muted mb-0">Mã giáo viên: ${teacher.teacherCode} | Bộ
                                                    môn: ${teacher.department}</p>
                                            </div>
                                            <div class="col-md-4">
                                                <div class="class-info-badge mt-4">
                                                    <i class="bi bi-people"></i>
                                                    <span>${fn:length(classrooms)}</span> lớp phụ trách
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Dashboard Content -->
                                    <div class="row g-4">
                                        <!-- Thông tin cá nhân -->
                                        <div class="col-lg-6">
                                            <div class="card">
                                                <div class="card-header">
                                                    <h6 class="mb-0">
                                                        <i class="bi bi-person-fill me-2 text-primary"></i>
                                                        Thông tin cá nhân
                                                    </h6>
                                                </div>
                                                <div class="card-body">
                                                    <div class="info-item">
                                                        <span class="info-label">Họ và tên:</span>
                                                        <span class="info-value">${teacher.user.fname}
                                                            ${teacher.user.lname}</span>
                                                    </div>
                                                    <div class="info-item">
                                                        <span class="info-label">Mã giáo viên:</span>
                                                        <span class="info-value">${teacher.teacherCode}</span>
                                                    </div>
                                                    <div class="info-item">
                                                        <span class="info-label">Bộ môn:</span>
                                                        <span class="info-value">${teacher.department}</span>
                                                    </div>
                                                    <div class="info-item">
                                                        <span class="info-label">Email:</span>
                                                        <span class="info-value">${teacher.user.email}</span>
                                                    </div>
                                                    <div class="info-item">
                                                        <span class="info-label">Số điện thoại:</span>
                                                        <span class="info-value">${teacher.user.phone}</span>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Lớp phụ trách -->
                                        <div class="col-lg-6">
                                            <div class="card">
                                                <div class="card-header">
                                                    <h6 class="mb-0">
                                                        <i class="bi bi-people-fill me-2 text-success"></i>
                                                        Lớp phụ trách
                                                        <span
                                                            class="badge bg-primary ms-2">${fn:length(classrooms)}</span>
                                                    </h6>
                                                </div>
                                                <div class="card-body">
                                                    <c:choose>
                                                        <c:when test="${not empty classrooms}">
                                                            <c:forEach items="${classrooms}" var="classroom">
                                                                <div class="classroom-item">
                                                                    <div>
                                                                        <div class="classroom-name">
                                                                            ${classroom.classCode}</div>
                                                                        <small class="text-muted">Lớp
                                                                            ${classroom.classCode}</small>
                                                                    </div>
                                                                    <span
                                                                        class="classroom-count">${classroom.currentSize}/${classroom.maxSize}</span>
                                                                </div>
                                                            </c:forEach>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="text-center py-4">
                                                                <i class="bi bi-info-circle text-muted"
                                                                    style="font-size: 2rem;"></i>
                                                                <p class="text-muted mt-2">Chưa được phân công lớp nào
                                                                </p>
                                                            </div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Statistics Cards -->
                                    <div class="row mt-4">
                                        <div class="col-md-3 mb-3">
                                            <div class="card text-center">
                                                <div class="card-body">
                                                    <i class="bi bi-people-fill text-primary"
                                                        style="font-size: 2rem;"></i>
                                                    <h4 class="card-title mt-2">${fn:length(classrooms)}</h4>
                                                    <p class="card-text text-muted">Lớp phụ trách</p>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-3 mb-3">
                                            <div class="card text-center">
                                                <div class="card-body">
                                                    <i class="bi bi-person-check-fill text-success"
                                                        style="font-size: 2rem;"></i>
                                                    <h4 class="card-title mt-2">0</h4>
                                                    <p class="card-text text-muted">Sinh viên</p>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-3 mb-3">
                                            <div class="card text-center">
                                                <div class="card-body">
                                                    <i class="bi bi-journal-check text-info"
                                                        style="font-size: 2rem;"></i>
                                                    <h4 class="card-title mt-2">0</h4>
                                                    <p class="card-text text-muted">Bài kiểm tra</p>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-3 mb-3">
                                            <div class="card text-center">
                                                <div class="card-body">
                                                    <i class="bi bi-exclamation-triangle-fill text-warning"
                                                        style="font-size: 2rem;"></i>
                                                    <h4 class="card-title mt-2">0</h4>
                                                    <p class="card-text text-muted">Thông báo mới</p>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Extra content to match height of classes page -->
                                    <div class="row mt-4">
                                        <div class="col-12">
                                            <div class="card">
                                                <div class="card-header">
                                                    <h6 class="mb-0">
                                                        <i class="bi bi-lightning-fill me-2 text-warning"></i>
                                                        Chức năng nhanh
                                                    </h6>
                                                </div>
                                                <div class="card-body">
                                                    <div class="row">
                                                        <div class="col-md-3 mb-3">
                                                            <a href="/teacher/classes"
                                                                class="btn btn-outline-primary w-100">
                                                                <i class="bi bi-people me-2"></i>
                                                                Quản lý lớp
                                                            </a>
                                                        </div>
                                                        <div class="col-md-3 mb-3">
                                                            <a href="/teacher/scores"
                                                                class="btn btn-outline-success w-100">
                                                                <i class="bi bi-journal-text me-2"></i>
                                                                Quản lý điểm
                                                            </a>
                                                        </div>
                                                        <div class="col-md-3 mb-3">
                                                            <button class="btn btn-outline-info w-100" disabled>
                                                                <i class="bi bi-calendar-check me-2"></i>
                                                                Lịch giảng dạy
                                                            </button>
                                                        </div>
                                                        <div class="col-md-3 mb-3">
                                                            <button class="btn btn-outline-warning w-100" disabled>
                                                                <i class="bi bi-bell me-2"></i>
                                                                Thông báo
                                                            </button>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Additional content to ensure page height matches other pages -->
                                    <div class="row mt-4" style="min-height: 300px;">
                                        <div class="col-12">
                                            <div class="card">
                                                <div class="card-body text-center py-5">
                                                    <i class="bi bi-house-door text-muted" style="font-size: 3rem;"></i>
                                                    <h5 class="mt-3 text-muted">Chào mừng bạn đến với Dashboard Giáo
                                                        viên</h5>
                                                    <p class="text-muted">Sử dụng các chức năng ở trên để quản lý lớp
                                                        học và điểm số sinh viên</p>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div style="height: 200px;"></div>
                                </div>
                    </div>

                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
                </body>

                </html>
                <tr class="student-row" data-class-id="${student.classroom.id}" data-mssv="${student.user.username}"
                    data-name="${student.user.fname} ${student.user.lname}" data-email="${student.user.email}"
                    data-phone="${student.user.phone}">
                    <td>
                        <div class="d-flex align-items-center justify-content-center">
                            <strong class="text-primary">${status.index +
                                1}</strong>
                        </div>
                    </td>
                    <td>
                        <strong class="text-primary">${student.user.username}</strong>
                    </td>
                    <td>
                        <strong>${student.user.fname}
                            ${student.user.lname}</strong>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${not empty student.user.email}">
                                ${student.user.email}
                            </c:when>
                            <c:otherwise>
                                <span class="text-muted">Chưa cập
                                    nhật</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${not empty student.user.phone}">
                                ${student.user.phone}
                            </c:when>
                            <c:otherwise>
                                <span class="text-muted">Chưa cập
                                    nhật</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <span class="badge bg-primary">${student.classroom.classCode}</span>
                    </td>
                    <td>
                        <a href="/teacher/student/${student.id}/detail" class="btn btn-outline-primary btn-action"
                            title="Xem chi tiết">
                            <i class="bi bi-eye"></i>
                        </a>
                    </td>
                </tr>
                </c:forEach>
                </tbody>
                </table>
                </div>
                </div>
                </div>

                <!-- Empty State -->
                <c:if test="${empty allStudents}">
                    <div class="text-center py-5">
                        <i class="bi bi-people text-muted" style="font-size: 4rem;"></i>
                        <h4 class="text-muted mt-3">Chưa có sinh viên nào</h4>
                        <p class="text-muted">Hiện tại chưa có sinh viên trong các lớp được phân
                            công.
                        </p>
                    </div>
                </c:if>
                </div>

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
                <script>
                    // Cache buster v2.0 - Search only by MSSV and Name, NOT email
                    console.log('JavaScript loaded - Search function updated');

                    // Filter by class
                    function filterByClass() {
                        const classId = document.getElementById('classSelect').value;
                        const rows = document.querySelectorAll('.student-row');
                        let visibleCount = 0;

                        rows.forEach(row => {
                            if (classId === '' || row.dataset.classId === classId) {
                                row.style.display = '';
                                visibleCount++;
                            } else {
                                row.style.display = 'none';
                            }
                        });

                        document.getElementById('studentCount').textContent = visibleCount;
                    }

                    // Search students (only by MSSV and name)
                    function searchStudents() {
                        const searchTerm = document.getElementById('searchInput').value.toLowerCase();
                        const rows = document.querySelectorAll('.student-row');
                        let visibleCount = 0;

                        rows.forEach(row => {
                            const mssv = row.dataset.mssv.toLowerCase();
                            const name = row.dataset.name.toLowerCase();
                            // CHỈ tìm theo MSSV và tên đầy đủ, KHÔNG tìm theo email

                            if (mssv.includes(searchTerm) || name.includes(searchTerm)) {
                                // Also check class filter
                                const classId = document.getElementById('classSelect').value;
                                if (classId === '' || row.dataset.classId === classId) {
                                    row.style.display = '';
                                    visibleCount++;
                                } else {
                                    row.style.display = 'none';
                                }
                            } else {
                                row.style.display = 'none';
                            }
                        });

                        document.getElementById('studentCount').textContent = visibleCount;
                    }
                </script>
                </div>
                </body>

                </html>