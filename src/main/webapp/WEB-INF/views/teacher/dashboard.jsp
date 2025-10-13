<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Tổng quan giáo viên</title>
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

                        .quick-action-btn {
                            padding: 0.75rem 1.5rem;
                            border-radius: 8px;
                            border: none;
                            font-weight: 500;
                            text-decoration: none;
                            transition: all 0.3s ease;
                            display: inline-flex;
                            align-items: center;
                            gap: 0.5rem;
                        }

                        .quick-action-btn:hover {
                            transform: translateY(-2px);
                            box-shadow: 0 10px 25px rgba(0, 0, 0, .15);
                            text-decoration: none;
                        }

                        .btn-primary-custom {
                            background: var(--primary-color);
                            color: white;
                        }

                        .btn-success-custom {
                            background: #28a745;
                            color: white;
                        }

                        .btn-info-custom {
                            background: #17a2b8;
                            color: white;
                        }

                        .welcome-section {
                            background: linear-gradient(135deg, var(--primary-color) 0%, #991b1b 100%);
                            color: white;
                            border-radius: 12px;
                            padding: 2rem;
                            margin-bottom: 2rem;
                        }

                        .teacher-info {
                            background: white;
                            border-radius: 12px;
                            padding: 1.5rem;
                            margin-bottom: 2rem;
                        }

                        .info-row {
                            display: flex;
                            justify-content: space-between;
                            align-items: center;
                            padding: 0.75rem 0;
                            border-bottom: 1px solid #e9ecef;
                        }

                        .info-row:last-child {
                            border-bottom: none;
                        }

                        .info-label {
                            font-weight: 600;
                            color: #6c757d;
                        }

                        .info-value {
                            color: #212529;
                            font-weight: 500;
                        }
                    </style>
                </head>

                <body>
                    <div class="container-fluid" style="padding: 0 clamp(12px, 4vw, 36px);">
                        <%@ include file="../common/header.jsp" %>

                            <c:set var="activeTab" value="dashboard" scope="request" />
                            <%@ include file="_nav.jsp" %>

                                <div class="mt-4">
                                    <!-- Welcome Section -->
                                    <div class="welcome-section">
                                        <h2><i class="bi bi-speedometer2 me-2"></i>Tổng quan hệ thống</h2>
                                        <p class="mb-0">Chào mừng bạn đến với hệ thống quản lý học sinh</p>
                                    </div>

                                    <!-- Teacher Information -->
                                    <div class="teacher-info">
                                        <h5 class="mb-3"><i class="bi bi-person-badge me-2"></i>Thông tin giáo viên</h5>
                                        <div class="info-row">
                                            <span class="info-label">Họ và tên:</span>
                                            <span class="info-value">${teacher.user.fname} ${teacher.user.lname}</span>
                                        </div>
                                        <div class="info-row">
                                            <span class="info-label">Mã giáo viên:</span>
                                            <span class="info-value">${teacher.teacherCode}</span>
                                        </div>
                                        <div class="info-row">
                                            <span class="info-label">Khoa:</span>
                                            <span class="info-value">${teacher.faculty.name}</span>
                                        </div>
                                        <div class="info-row">
                                            <span class="info-label">Email:</span>
                                            <span class="info-value">${teacher.user.email}</span>
                                        </div>
                                        <div class="info-row">
                                            <span class="info-label">Số điện thoại:</span>
                                            <span class="info-value">${teacher.user.phone}</span>
                                        </div>
                                    </div>

                                    <!-- Statistics Cards -->
                                    <div class="row mb-4">
                                        <div class="col-md-4 mb-3">
                                            <div class="card dashboard-card">
                                                <div class="card-body text-center">
                                                    <div class="stat-icon mx-auto mb-3" style="background: #28a745;">
                                                        <i class="bi bi-people-fill"></i>
                                                    </div>
                                                    <div class="stat-number">${fn:length(assignedClasses)}</div>
                                                    <h6 class="card-title mb-0">Lớp được phân công</h6>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-4 mb-3">
                                            <div class="card dashboard-card">
                                                <div class="card-body text-center">
                                                    <div class="stat-icon mx-auto mb-3" style="background: #17a2b8;">
                                                        <i class="bi bi-person-check-fill"></i>
                                                    </div>
                                                    <div class="stat-number">
                                                        <c:set var="totalStudents" value="0" />
                                                        <c:forEach var="classroom" items="${assignedClasses}">
                                                            <c:set var="totalStudents"
                                                                value="${totalStudents + fn:length(classroom.students)}" />
                                                        </c:forEach>
                                                        ${totalStudents}
                                                    </div>
                                                    <h6 class="card-title mb-0">Tổng sinh viên</h6>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-4 mb-3">
                                            <div class="card dashboard-card">
                                                <div class="card-body text-center">
                                                    <div class="stat-icon mx-auto mb-3" style="background: #ffc107;">
                                                        <i class="bi bi-journal-text"></i>
                                                    </div>
                                                    <div class="stat-number">${fn:length(subjects)}</div>
                                                    <h6 class="card-title mb-0">Môn học phụ trách</h6>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Assigned Classes -->
                                    <div class="card mb-4">
                                        <div class="card-header">
                                            <h5 class="mb-0"><i class="bi bi-house-door me-2"></i>Lớp được phân công
                                            </h5>
                                        </div>
                                        <div class="card-body">
                                            <c:choose>
                                                <c:when test="${not empty assignedClasses}">
                                                    <div class="row">
                                                        <c:forEach var="classroom" items="${assignedClasses}">
                                                            <div class="col-md-6 col-lg-4 mb-3">
                                                                <div class="card h-100">
                                                                    <div class="card-body">
                                                                        <h6 class="card-title">${classroom.name}</h6>
                                                                        <p class="text-muted mb-2">
                                                                            <i class="bi bi-people me-1"></i>
                                                                            ${fn:length(classroom.students)} sinh viên
                                                                        </p>
                                                                        <p class="text-muted mb-2">
                                                                            <i class="bi bi-building me-1"></i>
                                                                            ${classroom.major.name}
                                                                        </p>
                                                                        <a href="/teacher/classes?classId=${classroom.id}"
                                                                            class="quick-action-btn btn-info-custom">
                                                                            <i class="bi bi-eye"></i>Xem chi tiết
                                                                        </a>
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

                                    <!-- Quick Actions -->
                                    <div class="card">
                                        <div class="card-header">
                                            <h5 class="mb-0"><i class="bi bi-lightning me-2"></i>Thao tác nhanh</h5>
                                        </div>
                                        <div class="card-body">
                                            <div class="row">
                                                <div class="col-md-4 mb-3">
                                                    <a href="/teacher/classes"
                                                        class="quick-action-btn btn-primary-custom w-100">
                                                        <i class="bi bi-people"></i>Quản lý lớp học
                                                    </a>
                                                </div>
                                                <div class="col-md-4 mb-3">
                                                    <a href="/teacher/scores"
                                                        class="quick-action-btn btn-success-custom w-100">
                                                        <i class="bi bi-clipboard-data"></i>Quản lý điểm số
                                                    </a>
                                                </div>
                                                <div class="col-md-4 mb-3">
                                                    <a href="/auth/logout" class="quick-action-btn btn-secondary w-100">
                                                        <i class="bi bi-box-arrow-right"></i>Đăng xuất
                                                    </a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                </div>
                    </div>

                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
                </body>

                </html>