<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Dashboard Giáo viên chủ nhiệm - ${teacher.user.fname} ${teacher.user.lname}</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
                <style>
                    .dashboard-card {
                        transition: transform 0.2s ease-in-out;
                        border: none;
                        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                    }

                    .dashboard-card:hover {
                        transform: translateY(-2px);
                        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
                    }

                    .stats-card {
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        color: white;
                    }

                    .classroom-card {
                        background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
                        color: white;
                    }

                    .quick-actions {
                        background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
                        color: white;
                    }
                </style>
            </head>

            <body class="bg-light">
                <!-- Header -->
                <nav class="navbar navbar-expand-lg navbar-dark bg-primary shadow-sm">
                    <div class="container">
                        <a class="navbar-brand" href="/homeroom">
                            <i class="fas fa-chalkboard-teacher me-2"></i>
                            Dashboard Giáo viên chủ nhiệm
                        </a>
                        <div class="navbar-nav ms-auto">
                            <span class="navbar-text me-3">
                                <i class="fas fa-user me-1"></i>
                                ${teacher.user.fname} ${teacher.user.lname}
                            </span>
                            <a class="btn btn-outline-light btn-sm" href="/logout">
                                <i class="fas fa-sign-out-alt me-1"></i>Đăng xuất
                            </a>
                        </div>
                    </div>
                </nav>

                <div class="container my-4">
                    <!-- Thông tin giáo viên -->
                    <div class="row mb-4">
                        <div class="col-12">
                            <div class="card dashboard-card stats-card">
                                <div class="card-body">
                                    <div class="row align-items-center">
                                        <div class="col-md-8">
                                            <h4 class="card-title mb-2">
                                                <i class="fas fa-user-tie me-2"></i>
                                                Thông tin giáo viên
                                            </h4>
                                            <p class="mb-1"><strong>Mã giáo viên:</strong> ${teacher.teacherCode}</p>
                                            <p class="mb-1"><strong>Bộ môn:</strong> ${teacher.department}</p>
                                            <p class="mb-0"><strong>Số lớp đang chủ nhiệm:</strong>
                                                ${fn:length(classrooms)} lớp</p>
                                        </div>
                                        <div class="col-md-4 text-center">
                                            <i class="fas fa-chalkboard-teacher fa-4x opacity-50"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Danh sách lớp chủ nhiệm -->
                    <div class="row">
                        <div class="col-12">
                            <h5 class="mb-3">
                                <i class="fas fa-users me-2"></i>
                                Các lớp đang chủ nhiệm
                            </h5>

                            <c:if test="${empty classrooms}">
                                <div class="alert alert-info text-center">
                                    <i class="fas fa-info-circle me-2"></i>
                                    Hiện tại bạn chưa được phân công chủ nhiệm lớp nào.
                                </div>
                            </c:if>

                            <c:if test="${not empty classrooms}">
                                <div class="row">
                                    <c:forEach var="classroom" items="${classrooms}">
                                        <div class="col-md-6 col-lg-4 mb-4">
                                            <div class="card dashboard-card classroom-card h-100">
                                                <div class="card-body">
                                                    <h5 class="card-title">
                                                        <i class="fas fa-door-open me-2"></i>
                                                        ${classroom.classCode}
                                                    </h5>
                                                    <p class="card-text">
                                                        <small class="opacity-75">
                                                            <i class="fas fa-graduation-cap me-1"></i>
                                                            ${classroom.major.majorName}
                                                        </small><br>
                                                        <small class="opacity-75">
                                                            <i class="fas fa-calendar me-1"></i>
                                                            Khóa: ${classroom.courseYear}
                                                        </small><br>
                                                        <small class="opacity-75">
                                                            <i class="fas fa-users me-1"></i>
                                                            Số học sinh: ${classroom.studentCount} /
                                                            ${classroom.maxSize}
                                                        </small>
                                                    </p>

                                                    <div class="mt-3">
                                                        <div class="row g-2">
                                                            <div class="col-6">
                                                                <a href="/homeroom/classroom/${classroom.id}/students"
                                                                    class="btn btn-light btn-sm w-100">
                                                                    <i class="fas fa-user-graduate me-1"></i>
                                                                    Học sinh
                                                                </a>
                                                            </div>
                                                            <div class="col-6">
                                                                <a href="/homeroom/classroom/${classroom.id}/scores"
                                                                    class="btn btn-outline-light btn-sm w-100">
                                                                    <i class="fas fa-chart-line me-1"></i>
                                                                    Điểm số
                                                                </a>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:if>
                        </div>
                    </div>

                    <!-- Quick Actions -->
                    <c:if test="${not empty classrooms}">
                        <div class="row mt-4">
                            <div class="col-12">
                                <div class="card dashboard-card quick-actions">
                                    <div class="card-body">
                                        <h5 class="card-title">
                                            <i class="fas fa-bolt me-2"></i>
                                            Thao tác nhanh
                                        </h5>
                                        <div class="row">
                                            <div class="col-md-4 mb-2">
                                                <a href="/homeroom/classroom/${classrooms[0].id}/scores"
                                                    class="btn btn-light w-100">
                                                    <i class="fas fa-edit me-2"></i>
                                                    Nhập điểm
                                                </a>
                                            </div>
                                            <div class="col-md-4 mb-2">
                                                <a href="/homeroom/classroom/${classrooms[0].id}/students"
                                                    class="btn btn-outline-light w-100">
                                                    <i class="fas fa-list me-2"></i>
                                                    Danh sách học sinh
                                                </a>
                                            </div>
                                            <div class="col-md-4 mb-2">
                                                <button class="btn btn-outline-light w-100" onclick="window.print()">
                                                    <i class="fas fa-print me-2"></i>
                                                    In báo cáo
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:if>
                </div>

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            </body>

            </html>