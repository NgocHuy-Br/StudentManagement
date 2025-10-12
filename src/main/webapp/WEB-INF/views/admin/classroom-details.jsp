<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Chi tiết lớp học - ${classroom.classCode}</title>
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
                        }

                        .card {
                            border-radius: 12px;
                            box-shadow: 0 10px 25px rgba(0, 0, 0, .06);
                            border: none;
                        }

                        .info-card {
                            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                            color: white;
                            border-radius: 12px;
                            padding: 1.5rem;
                        }

                        .stat-box {
                            background: rgba(255, 255, 255, 0.1);
                            border-radius: 8px;
                            padding: 1rem;
                            text-align: center;
                        }

                        .stat-number {
                            font-size: 2rem;
                            font-weight: 700;
                            line-height: 1;
                        }

                        .stat-label {
                            font-size: 0.9rem;
                            opacity: 0.9;
                            margin-top: 0.5rem;
                        }

                        .timeline {
                            position: relative;
                            padding-left: 30px;
                        }

                        .timeline::before {
                            content: '';
                            position: absolute;
                            left: 15px;
                            top: 0;
                            bottom: 0;
                            width: 2px;
                            background: #dee2e6;
                        }

                        .timeline-item {
                            position: relative;
                            margin-bottom: 1.5rem;
                            background: white;
                            border-radius: 8px;
                            padding: 1rem;
                            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                        }

                        .timeline-item::before {
                            content: '';
                            position: absolute;
                            left: -23px;
                            top: 1rem;
                            width: 12px;
                            height: 12px;
                            border-radius: 50%;
                            background: #28a745;
                            border: 3px solid white;
                            box-shadow: 0 0 0 2px #28a745;
                        }

                        .timeline-item.current::before {
                            background: #007bff;
                            box-shadow: 0 0 0 2px #007bff;
                            animation: pulse 2s infinite;
                        }

                        .timeline-item.ended::before {
                            background: #6c757d;
                            box-shadow: 0 0 0 2px #6c757d;
                        }

                        @keyframes pulse {
                            0% {
                                box-shadow: 0 0 0 2px #007bff, 0 0 0 4px rgba(0, 123, 255, 0.3);
                            }

                            50% {
                                box-shadow: 0 0 0 2px #007bff, 0 0 0 8px rgba(0, 123, 255, 0.1);
                            }

                            100% {
                                box-shadow: 0 0 0 2px #007bff, 0 0 0 4px rgba(0, 123, 255, 0.3);
                            }
                        }

                        .student-avatar {
                            width: 32px;
                            height: 32px;
                            border-radius: 50%;
                            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            color: white;
                            font-weight: 600;
                            font-size: 12px;
                        }

                        .breadcrumb {
                            background: none;
                            padding: 0;
                        }

                        .breadcrumb-item a {
                            text-decoration: none;
                            color: #6c757d;
                        }

                        .breadcrumb-item a:hover {
                            color: var(--primary-color);
                        }
                    </style>
                </head>

                <body>
                    <%@include file="../common/header.jsp" %>

                        <div class="container-fluid my-4">
                            <c:set var="activeTab" value="classrooms" />
                            <%@include file="_nav.jsp" %>

                                <!-- Breadcrumb -->
                                <nav aria-label="breadcrumb" class="mb-4">
                                    <ol class="breadcrumb">
                                        <li class="breadcrumb-item">
                                            <a href="${pageContext.request.contextPath}/admin/classrooms">
                                                <i class="bi bi-house-door"></i> Quản lý lớp học
                                            </a>
                                        </li>
                                        <li class="breadcrumb-item active" aria-current="page">
                                            ${classroom.classCode}
                                        </li>
                                    </ol>
                                </nav>

                                <!-- Header -->
                                <div class="d-flex justify-content-between align-items-center mb-4">
                                    <div>
                                        <h2 class="mb-1">
                                            <i class="bi bi-building text-primary me-2"></i>
                                            Chi tiết lớp ${classroom.classCode}
                                        </h2>
                                        <p class="text-muted mb-0">
                                            Thông tin chi tiết và lịch sử giáo viên chủ nhiệm
                                        </p>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/admin/classrooms"
                                        class="btn btn-outline-secondary">
                                        <i class="bi bi-arrow-left me-1"></i>Quay lại
                                    </a>
                                </div>

                                <!-- Thông tin tổng quan -->
                                <div class="info-card mb-4">
                                    <div class="row">
                                        <div class="col-md-6">
                                            <h3 class="mb-3">
                                                <i class="bi bi-info-circle me-2"></i>Thông tin lớp học
                                            </h3>
                                            <div class="row g-3">
                                                <div class="col-6">
                                                    <strong>Mã lớp:</strong><br>
                                                    <span class="fs-5">${classroom.classCode}</span>
                                                </div>
                                                <div class="col-6">
                                                    <strong>Khóa học:</strong><br>
                                                    <span class="fs-5">${classroom.courseYear}</span>
                                                </div>
                                                <div class="col-12">
                                                    <strong>Ngành học:</strong><br>
                                                    <span class="fs-5">${classroom.major.majorName}</span>
                                                    <small
                                                        class="d-block opacity-75">${classroom.major.faculty.name}</small>
                                                </div>
                                                <div class="col-12">
                                                    <strong>Giáo viên chủ nhiệm hiện tại:</strong><br>
                                                    <c:choose>
                                                        <c:when test="${currentTeacher != null}">
                                                            <span class="fs-5">
                                                                ${currentTeacher.teacher.user.fname}
                                                                ${currentTeacher.teacher.user.lname}
                                                            </span>
                                                            <small class="d-block opacity-75">
                                                                Từ ngày:
                                                                ${dateFormatter.format(currentTeacher.startDate)}
                                                            </small>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="fs-5 text-warning">Chưa có chủ nhiệm</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <h3 class="mb-3">
                                                <i class="bi bi-bar-chart me-2"></i>Thống kê
                                            </h3>
                                            <div class="row g-3">
                                                <div class="col-6">
                                                    <div class="stat-box">
                                                        <div class="stat-number">${studentCount}</div>
                                                        <div class="stat-label">Sinh viên</div>
                                                    </div>
                                                </div>
                                                <div class="col-6">
                                                    <div class="stat-box">
                                                        <div class="stat-number">${fn:length(teacherHistory)}</div>
                                                        <div class="stat-label">Lịch sử CN</div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="row">
                                    <!-- Lịch sử giáo viên chủ nhiệm -->
                                    <div class="col-md-6">
                                        <div class="card">
                                            <div class="card-header">
                                                <h5 class="mb-0">
                                                    <i class="bi bi-clock-history me-2"></i>Lịch sử giáo viên chủ nhiệm
                                                </h5>
                                            </div>
                                            <div class="card-body">
                                                <c:choose>
                                                    <c:when test="${not empty teacherHistory}">
                                                        <div class="timeline">
                                                            <c:forEach items="${teacherHistory}" var="history">
                                                                <div
                                                                    class="timeline-item ${history.endDate == null ? 'current' : 'ended'}">
                                                                    <div
                                                                        class="d-flex justify-content-between align-items-start">
                                                                        <div class="flex-grow-1">
                                                                            <h6 class="mb-1 fw-bold">
                                                                                ${history.teacher.user.fname}
                                                                                ${history.teacher.user.lname}
                                                                            </h6>
                                                                            <small class="text-muted">
                                                                                ${history.teacher.user.email}
                                                                            </small>
                                                                        </div>
                                                                        <c:if test="${history.endDate == null}">
                                                                            <span class="badge bg-success">Hiện
                                                                                tại</span>
                                                                        </c:if>
                                                                    </div>
                                                                    <div class="mt-2">
                                                                        <small class="text-muted">
                                                                            <i class="bi bi-calendar-event me-1"></i>
                                                                            <strong>Từ:</strong>
                                                                            ${dateFormatter.format(history.startDate)}
                                                                            <c:if test="${history.endDate != null}">
                                                                                <br>
                                                                                <i class="bi bi-calendar-x me-1"></i>
                                                                                <strong>Đến:</strong>
                                                                                ${dateFormatter.format(history.endDate)}
                                                                            </c:if>
                                                                        </small>
                                                                    </div>
                                                                    <c:if test="${not empty history.notes}">
                                                                        <div class="mt-2">
                                                                            <small class="text-info">
                                                                                <i
                                                                                    class="bi bi-chat-left-text me-1"></i>
                                                                                ${history.notes}
                                                                            </small>
                                                                        </div>
                                                                    </c:if>
                                                                </div>
                                                            </c:forEach>
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="text-center py-4">
                                                            <i class="bi bi-clock-history text-muted"
                                                                style="font-size: 3rem;"></i>
                                                            <h5 class="text-muted mt-3">Chưa có lịch sử</h5>
                                                            <p class="text-muted">Lớp này chưa có giáo viên chủ nhiệm
                                                                nào.</p>
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Danh sách sinh viên -->
                                    <div class="col-md-6">
                                        <div class="card">
                                            <div class="card-header d-flex justify-content-between align-items-center">
                                                <h5 class="mb-0">
                                                    <i class="bi bi-people me-2"></i>Danh sách sinh viên
                                                </h5>
                                                <span class="badge bg-primary">${studentCount} sinh viên</span>
                                            </div>
                                            <div class="card-body">
                                                <c:choose>
                                                    <c:when test="${not empty students}">
                                                        <div class="list-group list-group-flush"
                                                            style="max-height: 500px; overflow-y: auto;">
                                                            <c:forEach items="${students}" var="student"
                                                                varStatus="status">
                                                                <div class="list-group-item border-0 px-0">
                                                                    <div class="d-flex align-items-center">
                                                                        <div class="student-avatar me-3">
                                                                            ${fn:toUpperCase(fn:substring(student.user.fname,
                                                                            0,
                                                                            1))}${fn:toUpperCase(fn:substring(student.user.lname,
                                                                            0, 1))}
                                                                        </div>
                                                                        <div class="flex-grow-1">
                                                                            <h6 class="mb-1">
                                                                                ${student.user.fname}
                                                                                ${student.user.lname}
                                                                            </h6>
                                                                            <small class="text-muted">
                                                                                <i class="bi bi-person-badge me-1"></i>
                                                                                ${student.user.username}
                                                                            </small>
                                                                        </div>
                                                                        <small class="text-muted">
                                                                            #${status.index + 1}
                                                                        </small>
                                                                    </div>
                                                                </div>
                                                            </c:forEach>
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="text-center py-4">
                                                            <i class="bi bi-people text-muted"
                                                                style="font-size: 3rem;"></i>
                                                            <h5 class="text-muted mt-3">Chưa có sinh viên</h5>
                                                            <p class="text-muted">Lớp này chưa có sinh viên nào.</p>
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                        </div>

                        <script
                            src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
                </body>

                </html>