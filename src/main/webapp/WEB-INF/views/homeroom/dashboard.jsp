<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Dashboard Giáo viên - ${teacher.user.fname} ${teacher.user.lname}</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
                <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css"
                    rel="stylesheet">
                <style>
                    body {
                        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                        background-color: #f8f9fa;
                    }

                    .navbar-brand {
                        font-weight: 600;
                    }

                    .tab-content {
                        background: white;
                        border-radius: 0 0 0.5rem 0.5rem;
                        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                    }

                    .nav-tabs {
                        border-bottom: 2px solid #dee2e6;
                        background: white;
                        border-radius: 0.5rem 0.5rem 0 0;
                        box-shadow: 0 -2px 4px rgba(0, 0, 0, 0.1);
                    }

                    .nav-tabs .nav-link {
                        border: none;
                        color: #6c757d;
                        font-weight: 500;
                        padding: 1rem 1.5rem;
                        transition: all 0.3s ease;
                    }

                    .nav-tabs .nav-link:hover {
                        border: none;
                        color: #0d6efd;
                        background-color: #f8f9fa;
                    }

                    .nav-tabs .nav-link.active {
                        color: #0d6efd;
                        background-color: white;
                        border: none;
                        border-bottom: 3px solid #0d6efd;
                    }

                    .stats-card {
                        border: none;
                        border-radius: 0.75rem;
                        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                        transition: transform 0.2s ease;
                    }

                    .stats-card:hover {
                        transform: translateY(-2px);
                        box-shadow: 0 4px 16px rgba(0, 0, 0, 0.15);
                    }

                    .stats-number {
                        font-size: 2rem;
                        font-weight: 700;
                        color: #0d6efd;
                    }

                    .classroom-card {
                        border: none;
                        border-radius: 0.75rem;
                        transition: all 0.2s ease;
                        cursor: pointer;
                    }

                    .classroom-card:hover {
                        transform: translateY(-2px);
                        box-shadow: 0 4px 16px rgba(0, 0, 0, 0.15);
                    }

                    .table-responsive {
                        border-radius: 0.5rem;
                        overflow: hidden;
                    }

                    /* Sortable table headers */
                    .sortable {
                        cursor: pointer;
                        user-select: none;
                        position: relative;
                    }

                    .sortable:hover {
                        background-color: #e2e6ea !important;
                    }

                    .sort-icon {
                        font-size: 11px;
                        color: #6c757d;
                        margin-left: 4px;
                    }

                    .sortable:hover .sort-icon {
                        color: #495057;
                    }
                </style>
            </head>

            <body>
                <%@include file="../common/header.jsp" %>

                    <div class="container-fluid my-4">
                        <!-- Navigation Tabs -->
                        <ul class="nav nav-tabs" id="teacherTabs" role="tablist">
                            <li class="nav-item" role="presentation">
                                <button class="nav-link active" id="dashboard-tab" data-bs-toggle="tab"
                                    data-bs-target="#dashboard" type="button" role="tab" aria-controls="dashboard"
                                    aria-selected="true">
                                    <i class="bi bi-speedometer2 me-2"></i>Tổng quan
                                </button>
                            </li>
                            <li class="nav-item" role="presentation">
                                <button class="nav-link" id="notifications-tab" data-bs-toggle="tab"
                                    data-bs-target="#notifications" type="button" role="tab"
                                    aria-controls="notifications" aria-selected="false">
                                    <i class="bi bi-bell me-2"></i>Thông báo
                                </button>
                            </li>
                            <li class="nav-item" role="presentation">
                                <button class="nav-link" id="profile-tab" data-bs-toggle="tab" data-bs-target="#profile"
                                    type="button" role="tab" aria-controls="profile" aria-selected="false">
                                    <i class="bi bi-person-circle me-2"></i>Thông tin cá nhân
                                </button>
                            </li>
                            <li class="nav-item" role="presentation">
                                <button class="nav-link" id="classrooms-tab" data-bs-toggle="tab"
                                    data-bs-target="#classrooms" type="button" role="tab" aria-controls="classrooms"
                                    aria-selected="false">
                                    <i class="bi bi-people me-2"></i>Lớp sinh viên
                                </button>
                            </li>
                            <li class="nav-item" role="presentation">
                                <button class="nav-link" id="scores-tab" data-bs-toggle="tab" data-bs-target="#scores"
                                    type="button" role="tab" aria-controls="scores" aria-selected="false">
                                    <i class="bi bi-clipboard-data me-2"></i>Nhập điểm
                                </button>
                            </li>
                            <li class="nav-item" role="presentation">
                                <button class="nav-link" id="schedule-tab" data-bs-toggle="tab"
                                    data-bs-target="#schedule" type="button" role="tab" aria-controls="schedule"
                                    aria-selected="false">
                                    <i class="bi bi-calendar3 me-2"></i>Lịch giảng dạy
                                </button>
                            </li>
                        </ul>

                        <!-- Tab Content -->
                        <div class="tab-content" id="teacherTabContent">
                            <!-- Dashboard Tab -->
                            <div class="tab-pane fade show active" id="dashboard" role="tabpanel"
                                aria-labelledby="dashboard-tab">
                                <div class="p-4">
                                    <!-- Stats Cards -->
                                    <div class="row mb-4">
                                        <div class="col-lg-3 col-md-6 mb-3">
                                            <div class="card stats-card">
                                                <div class="card-body">
                                                    <div class="d-flex align-items-center">
                                                        <div class="flex-grow-1">
                                                            <h6 class="card-title text-muted mb-1">Lớp chủ nhiệm</h6>
                                                            <div class="stats-number">${fn:length(classrooms)}</div>
                                                        </div>
                                                        <div class="text-primary opacity-75">
                                                            <i class="bi bi-door-open display-6"></i>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-lg-3 col-md-6 mb-3">
                                            <div class="card stats-card">
                                                <div class="card-body">
                                                    <div class="d-flex align-items-center">
                                                        <div class="flex-grow-1">
                                                            <h6 class="card-title text-muted mb-1">Tổng sinh viên</h6>
                                                            <div class="stats-number">
                                                                <c:set var="totalStudents" value="0" />
                                                                <c:forEach var="classroom" items="${classrooms}">
                                                                    <c:set var="totalStudents"
                                                                        value="${totalStudents + fn:length(classroom.students)}" />
                                                                </c:forEach>
                                                                ${totalStudents}
                                                            </div>
                                                        </div>
                                                        <div class="text-success opacity-75">
                                                            <i class="bi bi-people display-6"></i>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-lg-3 col-md-6 mb-3">
                                            <div class="card stats-card">
                                                <div class="card-body">
                                                    <div class="d-flex align-items-center">
                                                        <div class="flex-grow-1">
                                                            <h6 class="card-title text-muted mb-1">Bộ môn</h6>
                                                            <div class="h5 mb-0">${teacher.department}</div>
                                                        </div>
                                                        <div class="text-warning opacity-75">
                                                            <i class="bi bi-book display-6"></i>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-lg-3 col-md-6 mb-3">
                                            <div class="card stats-card">
                                                <div class="card-body">
                                                    <div class="d-flex align-items-center">
                                                        <div class="flex-grow-1">
                                                            <h6 class="card-title text-muted mb-1">Mã giáo viên</h6>
                                                            <div class="h5 mb-0">${teacher.teacherCode}</div>
                                                        </div>
                                                        <div class="text-info opacity-75">
                                                            <i class="bi bi-person-badge display-6"></i>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Recent Activities -->
                                    <div class="row">
                                        <div class="col-12">
                                            <div class="card">
                                                <div class="card-header">
                                                    <h5 class="mb-0">
                                                        <i class="bi bi-clock-history me-2"></i>Hoạt động gần đây
                                                    </h5>
                                                </div>
                                                <div class="card-body">
                                                    <div class="alert alert-info">
                                                        <i class="bi bi-info-circle me-2"></i>
                                                        Chức năng theo dõi hoạt động sẽ được cập nhật trong phiên bản
                                                        tiếp theo.
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Notifications Tab -->
                            <div class="tab-pane fade" id="notifications" role="tabpanel"
                                aria-labelledby="notifications-tab">
                                <div class="p-4">
                                    <div class="row">
                                        <div class="col-12">
                                            <div class="card">
                                                <div class="card-header">
                                                    <h5 class="mb-0">
                                                        <i class="bi bi-bell me-2"></i>Thông báo mới
                                                    </h5>
                                                </div>
                                                <div class="card-body">
                                                    <div class="alert alert-info">
                                                        <i class="bi bi-info-circle me-2"></i>
                                                        Hiện tại chưa có thông báo mới nào.
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Profile Tab -->
                            <div class="tab-pane fade" id="profile" role="tabpanel" aria-labelledby="profile-tab">
                                <div class="p-4">
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="card">
                                                <div class="card-header">
                                                    <h5 class="mb-0">
                                                        <i class="bi bi-person-circle me-2"></i>Thông tin cá nhân
                                                    </h5>
                                                </div>
                                                <div class="card-body">
                                                    <div class="row mb-3">
                                                        <div class="col-sm-4"><strong>Họ và tên:</strong></div>
                                                        <div class="col-sm-8">${teacher.user.fname}
                                                            ${teacher.user.lname}</div>
                                                    </div>
                                                    <div class="row mb-3">
                                                        <div class="col-sm-4"><strong>Mã giáo viên:</strong></div>
                                                        <div class="col-sm-8">${teacher.teacherCode}</div>
                                                    </div>
                                                    <div class="row mb-3">
                                                        <div class="col-sm-4"><strong>Email:</strong></div>
                                                        <div class="col-sm-8">${teacher.user.email}</div>
                                                    </div>
                                                    <div class="row mb-3">
                                                        <div class="col-sm-4"><strong>Bộ môn:</strong></div>
                                                        <div class="col-sm-8">${teacher.department}</div>
                                                    </div>
                                                    <div class="row mb-3">
                                                        <div class="col-sm-4"><strong>Vai trò:</strong></div>
                                                        <div class="col-sm-8">
                                                            <span class="badge bg-success">Giáo viên chủ nhiệm</span>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="card">
                                                <div class="card-header">
                                                    <h5 class="mb-0">
                                                        <i class="bi bi-bar-chart me-2"></i>Thống kê công việc
                                                    </h5>
                                                </div>
                                                <div class="card-body">
                                                    <div class="d-flex justify-content-between align-items-center mb-3">
                                                        <span>Số lớp chủ nhiệm:</span>
                                                        <span
                                                            class="badge bg-primary fs-6">${fn:length(classrooms)}</span>
                                                    </div>
                                                    <div class="d-flex justify-content-between align-items-center mb-3">
                                                        <span>Tổng sinh viên quản lý:</span>
                                                        <span class="badge bg-success fs-6">
                                                            <c:set var="totalStudents" value="0" />
                                                            <c:forEach var="classroom" items="${classrooms}">
                                                                <c:set var="totalStudents"
                                                                    value="${totalStudents + fn:length(classroom.students)}" />
                                                            </c:forEach>
                                                            ${totalStudents}
                                                        </span>
                                                    </div>
                                                    <div class="d-flex justify-content-between align-items-center">
                                                        <span>Trạng thái tài khoản:</span>
                                                        <span class="badge bg-success">Hoạt động</span>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Classrooms Tab -->
                            <div class="tab-pane fade" id="classrooms" role="tabpanel" aria-labelledby="classrooms-tab">
                                <div class="p-4">
                                    <div class="card">
                                        <div class="card-header d-flex justify-content-between align-items-center">
                                            <h5 class="mb-0">
                                                <i class="bi bi-people me-2"></i>Danh sách lớp chủ nhiệm
                                            </h5>
                                            <span class="badge bg-primary">${fn:length(classrooms)} lớp</span>
                                        </div>
                                        <div class="card-body">
                                            <c:if test="${empty classrooms}">
                                                <div class="text-center py-4">
                                                    <i class="bi bi-people display-1 text-muted"></i>
                                                    <p class="text-muted mt-3">Hiện tại bạn chưa được phân công chủ
                                                        nhiệm lớp nào.</p>
                                                </div>
                                            </c:if>

                                            <c:if test="${not empty classrooms}">
                                                <div class="table-responsive">
                                                    <table class="table table-hover">
                                                        <thead class="table-light">
                                                            <tr>
                                                                <th class="sortable" data-sort="classCode">
                                                                    Mã lớp <i class="bi bi-arrow-down-up sort-icon"></i>
                                                                </th>
                                                                <th class="sortable" data-sort="majorName">
                                                                    Ngành học <i
                                                                        class="bi bi-arrow-down-up sort-icon"></i>
                                                                </th>
                                                                <th class="sortable" data-sort="courseYear">
                                                                    Khóa học <i
                                                                        class="bi bi-arrow-down-up sort-icon"></i>
                                                                </th>
                                                                <th class="sortable" data-sort="studentCount">
                                                                    Số sinh viên <i
                                                                        class="bi bi-arrow-down-up sort-icon"></i>
                                                                </th>
                                                                <th>Thao tác</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <c:forEach var="classroom" items="${classrooms}">
                                                                <tr>
                                                                    <td class="fw-semibold text-primary">
                                                                        ${classroom.classCode}</td>
                                                                    <td>${classroom.major.majorName}</td>
                                                                    <td>${classroom.courseYear}</td>
                                                                    <td>
                                                                        <span
                                                                            class="badge bg-info">${fn:length(classroom.students)}
                                                                            sinh viên</span>
                                                                    </td>
                                                                    <td>
                                                                        <a href="${pageContext.request.contextPath}/homeroom/students?classroomId=${classroom.id}"
                                                                            class="btn btn-outline-primary btn-sm">
                                                                            <i class="bi bi-eye me-1"></i>Xem chi tiết
                                                                        </a>
                                                                    </td>
                                                                </tr>
                                                            </c:forEach>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Scores Tab -->
                            <div class="tab-pane fade" id="scores" role="tabpanel" aria-labelledby="scores-tab">
                                <div class="p-4">
                                    <div class="card">
                                        <div class="card-header">
                                            <h5 class="mb-0">
                                                <i class="bi bi-clipboard-data me-2"></i>Quản lý điểm số
                                            </h5>
                                        </div>
                                        <div class="card-body">
                                            <c:if test="${empty classrooms}">
                                                <div class="alert alert-info">
                                                    <i class="bi bi-info-circle me-2"></i>
                                                    Bạn cần có lớp chủ nhiệm để có thể nhập điểm.
                                                </div>
                                            </c:if>

                                            <c:if test="${not empty classrooms}">
                                                <div class="row">
                                                    <c:forEach var="classroom" items="${classrooms}">
                                                        <div class="col-md-6 col-lg-4 mb-3">
                                                            <div class="card classroom-card">
                                                                <div class="card-body">
                                                                    <h6 class="card-title">
                                                                        <i
                                                                            class="bi bi-door-open me-2"></i>${classroom.classCode}
                                                                    </h6>
                                                                    <p class="card-text small text-muted">
                                                                        ${classroom.major.majorName}<br>
                                                                        Khóa: ${classroom.courseYear}
                                                                    </p>
                                                                    <a href="${pageContext.request.contextPath}/homeroom/scores?classroomId=${classroom.id}"
                                                                        class="btn btn-primary btn-sm">
                                                                        <i class="bi bi-pencil-square me-1"></i>Nhập
                                                                        điểm
                                                                    </a>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </c:forEach>
                                                </div>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Schedule Tab -->
                            <div class="tab-pane fade" id="schedule" role="tabpanel" aria-labelledby="schedule-tab">
                                <div class="p-4">
                                    <div class="card">
                                        <div class="card-header">
                                            <h5 class="mb-0">
                                                <i class="bi bi-calendar3 me-2"></i>Lịch giảng dạy
                                            </h5>
                                        </div>
                                        <div class="card-body">
                                            <div class="alert alert-info">
                                                <i class="bi bi-info-circle me-2"></i>
                                                Chức năng lịch giảng dạy sẽ được cập nhật trong phiên bản tiếp theo.
                                            </div>

                                            <!-- Placeholder for schedule -->
                                            <div class="row">
                                                <div class="col-12">
                                                    <div class="table-responsive">
                                                        <table class="table table-bordered">
                                                            <thead class="table-primary">
                                                                <tr>
                                                                    <th>Thời gian</th>
                                                                    <th>Thứ 2</th>
                                                                    <th>Thứ 3</th>
                                                                    <th>Thứ 4</th>
                                                                    <th>Thứ 5</th>
                                                                    <th>Thứ 6</th>
                                                                    <th>Thứ 7</th>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                                <tr>
                                                                    <td class="fw-semibold">7:30 - 9:00</td>
                                                                    <td class="text-center text-muted">-</td>
                                                                    <td class="text-center text-muted">-</td>
                                                                    <td class="text-center text-muted">-</td>
                                                                    <td class="text-center text-muted">-</td>
                                                                    <td class="text-center text-muted">-</td>
                                                                    <td class="text-center text-muted">-</td>
                                                                </tr>
                                                                <tr>
                                                                    <td class="fw-semibold">9:15 - 10:45</td>
                                                                    <td class="text-center text-muted">-</td>
                                                                    <td class="text-center text-muted">-</td>
                                                                    <td class="text-center text-muted">-</td>
                                                                    <td class="text-center text-muted">-</td>
                                                                    <td class="text-center text-muted">-</td>
                                                                    <td class="text-center text-muted">-</td>
                                                                </tr>
                                                                <tr>
                                                                    <td class="fw-semibold">13:00 - 14:30</td>
                                                                    <td class="text-center text-muted">-</td>
                                                                    <td class="text-center text-muted">-</td>
                                                                    <td class="text-center text-muted">-</td>
                                                                    <td class="text-center text-muted">-</td>
                                                                    <td class="text-center text-muted">-</td>
                                                                    <td class="text-center text-muted">-</td>
                                                                </tr>
                                                                <tr>
                                                                    <td class="fw-semibold">14:45 - 16:15</td>
                                                                    <td class="text-center text-muted">-</td>
                                                                    <td class="text-center text-muted">-</td>
                                                                    <td class="text-center text-muted">-</td>
                                                                    <td class="text-center text-muted">-</td>
                                                                    <td class="text-center text-muted">-</td>
                                                                    <td class="text-center text-muted">-</td>
                                                                </tr>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Scripts -->
                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
                    <script>
                        document.addEventListener('DOMContentLoaded', function () {
                            // Table sorting functionality
                            const sortableHeaders = document.querySelectorAll('.sortable');
                            let currentSort = { column: null, direction: 'asc' };

                            sortableHeaders.forEach(header => {
                                header.addEventListener('click', function () {
                                    const sortField = this.dataset.sort;
                                    const table = this.closest('table');
                                    const tbody = table.querySelector('tbody');
                                    const rows = Array.from(tbody.querySelectorAll('tr'));

                                    // Skip if no data rows
                                    if (rows.length === 0 || (rows.length === 1 && rows[0].cells.length === 1)) {
                                        return;
                                    }

                                    // Determine sort direction
                                    if (currentSort.column === sortField) {
                                        currentSort.direction = currentSort.direction === 'asc' ? 'desc' : 'asc';
                                    } else {
                                        currentSort.direction = 'asc';
                                    }
                                    currentSort.column = sortField;

                                    // Update header styles
                                    const tableHeaders = table.querySelectorAll('.sortable');
                                    tableHeaders.forEach(h => {
                                        h.classList.remove('asc', 'desc');
                                    });
                                    this.classList.add(currentSort.direction);

                                    // Sort rows
                                    rows.sort((a, b) => {
                                        let aValue, bValue;
                                        const colIndex = this.cellIndex;
                                        aValue = a.cells[colIndex].textContent.trim();
                                        bValue = b.cells[colIndex].textContent.trim();

                                        // Handle numeric fields
                                        if (sortField.includes('Count') || sortField.includes('Year')) {
                                            aValue = parseInt(aValue.replace(/\D/g, '')) || 0;
                                            bValue = parseInt(bValue.replace(/\D/g, '')) || 0;
                                            return currentSort.direction === 'asc' ? aValue - bValue : bValue - aValue;
                                        } else {
                                            // Handle text fields
                                            if (currentSort.direction === 'asc') {
                                                return aValue.localeCompare(bValue, 'vi', { numeric: true });
                                            } else {
                                                return bValue.localeCompare(aValue, 'vi', { numeric: true });
                                            }
                                        }
                                    });

                                    // Re-append sorted rows
                                    rows.forEach(row => tbody.appendChild(row));
                                });
                            });
                        });
                    </script>
            </body>

            </html>