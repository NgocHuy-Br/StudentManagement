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
                    <link rel="stylesheet"
                        href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
                    <style>
                        body {
                            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                        }

                        .info-card {
                            border: 1px solid #e9ecef;
                            border-radius: .5rem;
                            padding: 1.5rem;
                            background: #f8f9fa;
                            height: 100%;
                        }

                        .info-card h6 {
                            color: #495057;
                            font-weight: 600;
                            margin-bottom: 1rem;
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

                        .quick-actions .btn {
                            border-radius: .5rem;
                            padding: .75rem 1rem;
                            font-weight: 500;
                            transition: all 0.2s;
                        }

                        .classroom-item {
                            display: flex;
                            justify-content: space-between;
                            align-items: center;
                            padding: .75rem;
                            background: #fff;
                            border: 1px solid #e9ecef;
                            border-radius: .5rem;
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
                            border-radius: .25rem;
                            font-size: .875rem;
                        }
                    </style>
                </head>

                <body>
                    <%@include file="../common/header.jsp" %>

                        <div class="container-fluid my-4">
                            <c:set var="activeTab" value="dashboard" />
                            <%@include file="_nav.jsp" %>

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

                                <div class="row g-4">
                                    <!-- Thông tin cá nhân -->
                                    <div class="col-lg-6">
                                        <div class="info-card">
                                            <h6>
                                                <i class="bi bi-person-fill me-2 text-primary"></i>
                                                Thông tin cá nhân
                                            </h6>
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

                                    <!-- Lớp phụ trách -->
                                    <div class="col-lg-6">
                                        <div class="info-card">
                                            <h6>
                                                <i class="bi bi-people-fill me-2 text-success"></i>
                                                Lớp phụ trách
                                                <span class="badge bg-primary ms-2">${fn:length(classrooms)}</span>
                                            </h6>
                                            <c:choose>
                                                <c:when test="${not empty classrooms}">
                                                    <c:forEach items="${classrooms}" var="classroom">
                                                        <div class="classroom-item">
                                                            <div>
                                                                <div class="classroom-name">${classroom.classCode}</div>
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
                                                        <p class="text-muted mt-2">Chưa được phân công lớp nào</p>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>

                                <!-- Chức năng nhanh -->
                                <div class="row mt-4">
                                    <div class="col-12">
                                        <div class="info-card">
                                            <h6>
                                                <i class="bi bi-lightning-fill me-2 text-warning"></i>
                                                Chức năng nhanh
                                            </h6>
                                            <div class="row quick-actions">
                                                <div class="col-md-3 mb-3">
                                                    <a href="/teacher/classes" class="btn btn-outline-primary w-100">
                                                        <i class="bi bi-people-fill d-block mb-2"
                                                            style="font-size: 1.5rem;"></i>
                                                        Quản lý lớp
                                                    </a>
                                                </div>
                                                <div class="col-md-3 mb-3">
                                                    <a href="/teacher/scores" class="btn btn-outline-success w-100">
                                                        <i class="bi bi-journal-text d-block mb-2"
                                                            style="font-size: 1.5rem;"></i>
                                                        Nhập điểm
                                                    </a>
                                                </div>
                                                <div class="col-md-3 mb-3">
                                                    <a href="/teacher/schedule" class="btn btn-outline-info w-100">
                                                        <i class="bi bi-calendar3 d-block mb-2"
                                                            style="font-size: 1.5rem;"></i>
                                                        Lịch giảng dạy
                                                    </a>
                                                </div>
                                                <div class="col-md-3 mb-3">
                                                    <a href="/teacher/notifications"
                                                        class="btn btn-outline-warning w-100">
                                                        <i class="bi bi-bell-fill d-block mb-2"
                                                            style="font-size: 1.5rem;"></i>
                                                        Thông báo
                                                    </a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Thống kê nhanh -->
                                <div class="row mt-4">
                                    <div class="col-md-3">
                                        <div class="card text-center border-primary">
                                            <div class="card-body">
                                                <i class="bi bi-people-fill text-primary" style="font-size: 2rem;"></i>
                                                <h4 class="card-title mt-2">${fn:length(classrooms)}</h4>
                                                <p class="card-text text-muted">Lớp phụ trách</p>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="card text-center border-success">
                                            <div class="card-body">
                                                <i class="bi bi-person-check-fill text-success"
                                                    style="font-size: 2rem;"></i>
                                                <h4 class="card-title mt-2">
                                                    <c:set var="totalStudents" value="0" />
                                                    <c:forEach items="${classrooms}" var="classroom">
                                                        <c:set var="totalStudents"
                                                            value="${totalStudents + classroom.currentSize}" />
                                                    </c:forEach>
                                                    ${totalStudents}
                                                </h4>
                                                <p class="card-text text-muted">Tổng sinh viên</p>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="card text-center border-info">
                                            <div class="card-body">
                                                <i class="bi bi-calendar-event text-info" style="font-size: 2rem;"></i>
                                                <h4 class="card-title mt-2">0</h4>
                                                <p class="card-text text-muted">Lịch hôm nay</p>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="card text-center border-warning">
                                            <div class="card-body">
                                                <i class="bi bi-exclamation-triangle-fill text-warning"
                                                    style="font-size: 2rem;"></i>
                                                <h4 class="card-title mt-2">0</h4>
                                                <p class="card-text text-muted">Thông báo mới</p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                        </div>

                        <script
                            src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
                </body>

                </html>