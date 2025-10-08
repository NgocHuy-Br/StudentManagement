<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Chi tiết sinh viên - ${student.user.fname} ${student.user.lname}</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
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

                    .student-avatar {
                        width: 120px;
                        height: 120px;
                        border-radius: 50%;
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        color: white;
                        font-weight: 600;
                        font-size: 36px;
                        margin: 0 auto;
                    }

                    .card {
                        border-radius: 12px;
                        box-shadow: 0 10px 25px rgba(0, 0, 0, .06);
                        border: none;
                    }

                    .info-item {
                        padding: 1rem 0;
                        border-bottom: 1px solid #eee;
                    }

                    .info-item:last-child {
                        border-bottom: none;
                    }

                    .info-label {
                        font-weight: 600;
                        color: #495057;
                        margin-bottom: 0.25rem;
                    }

                    .info-value {
                        color: #212529;
                        font-size: 1.1rem;
                    }
                </style>
            </head>

            <body>
                <%@include file="../common/header.jsp" %>

                    <div class="container-fluid my-4">
                        <c:set var="activeTab" value="classes" />
                        <%@include file="_nav.jsp" %>

                            <!-- Breadcrumb -->
                            <nav aria-label="breadcrumb" class="mb-4">
                                <ol class="breadcrumb">
                                    <li class="breadcrumb-item">
                                        <a href="/teacher/classes" class="text-decoration-none">
                                            <i class="bi bi-house"></i> Quản lý lớp
                                        </a>
                                    </li>
                                    <li class="breadcrumb-item active" aria-current="page">
                                        Chi tiết sinh viên
                                    </li>
                                </ol>
                            </nav>

                            <div class="row">
                                <div class="col-md-4">
                                    <!-- Student Avatar & Basic Info -->
                                    <div class="card mb-4">
                                        <div class="card-body text-center">
                                            <div class="student-avatar mb-3">
                                                ${fn:substring(student.user.fname, 0,
                                                1)}${fn:substring(student.user.lname, 0, 1)}
                                            </div>
                                            <h4 class="card-title">${student.user.fname} ${student.user.lname}</h4>
                                            <p class="text-muted mb-2">
                                                <i class="bi bi-person-badge"></i>
                                                ${student.user.username}
                                            </p>
                                            <p class="text-muted">
                                                <i class="bi bi-building"></i>
                                                ${student.classroom.classCode}
                                            </p>
                                        </div>
                                    </div>

                                    <!-- Quick Actions -->
                                    <div class="card">
                                        <div class="card-header">
                                            <h6 class="card-title mb-0">
                                                <i class="bi bi-lightning"></i> Thao tác nhanh
                                            </h6>
                                        </div>
                                        <div class="card-body">
                                            <a href="/teacher/student/${student.id}/scores"
                                                class="btn btn-outline-primary w-100 mb-2">
                                                <i class="bi bi-clipboard-data"></i> Xem điểm số
                                            </a>
                                            <a href="/teacher/classes" class="btn btn-outline-secondary w-100">
                                                <i class="bi bi-arrow-left"></i> Quay lại danh sách
                                            </a>
                                        </div>
                                    </div>
                                </div>

                                <div class="col-md-8">
                                    <!-- Detailed Information -->
                                    <div class="card">
                                        <div class="card-header">
                                            <h5 class="card-title mb-0">
                                                <i class="bi bi-info-circle"></i> Thông tin chi tiết
                                            </h5>
                                        </div>
                                        <div class="card-body">
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <div class="info-item">
                                                        <div class="info-label">Mã số sinh viên</div>
                                                        <div class="info-value">
                                                            <strong
                                                                class="text-primary">${student.user.username}</strong>
                                                        </div>
                                                    </div>

                                                    <div class="info-item">
                                                        <div class="info-label">Họ và tên</div>
                                                        <div class="info-value">${student.user.fname}
                                                            ${student.user.lname}</div>
                                                    </div>

                                                    <div class="info-item">
                                                        <div class="info-label">Email</div>
                                                        <div class="info-value">
                                                            <c:choose>
                                                                <c:when test="${not empty student.user.email}">
                                                                    <a href="mailto:${student.user.email}"
                                                                        class="text-decoration-none">
                                                                        ${student.user.email}
                                                                    </a>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="text-muted">Chưa cập nhật</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                    </div>
                                                </div>

                                                <div class="col-md-6">
                                                    <div class="info-item">
                                                        <div class="info-label">Số điện thoại</div>
                                                        <div class="info-value">
                                                            <c:choose>
                                                                <c:when test="${not empty student.user.phone}">
                                                                    <a href="tel:${student.user.phone}"
                                                                        class="text-decoration-none">
                                                                        ${student.user.phone}
                                                                    </a>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="text-muted">Chưa cập nhật</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                    </div>

                                                    <div class="info-item">
                                                        <div class="info-label">Lớp học</div>
                                                        <div class="info-value">
                                                            <span
                                                                class="badge bg-primary">${student.classroom.classCode}</span>
                                                        </div>
                                                    </div>

                                                    <div class="info-item">
                                                        <div class="info-label">Ngành học</div>
                                                        <div class="info-value">${student.classroom.major.majorName}
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Academic Information -->
                                    <div class="card mt-4">
                                        <div class="card-header">
                                            <h5 class="card-title mb-0">
                                                <i class="bi bi-book"></i> Thông tin học tập
                                            </h5>
                                        </div>
                                        <div class="card-body">
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <div class="info-item">
                                                        <div class="info-label">Khoa</div>
                                                        <div class="info-value">${student.classroom.major.faculty.name}
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="col-md-6">
                                                    <div class="info-item">
                                                        <div class="info-label">Giáo viên chủ nhiệm</div>
                                                        <div class="info-value">
                                                            ${student.classroom.homeRoomTeacher.user.fname}
                                                            ${student.classroom.homeRoomTeacher.user.lname}
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="mt-3">
                                                <a href="/teacher/student/${student.id}/scores" class="btn btn-primary">
                                                    <i class="bi bi-clipboard-data"></i> Xem kết quả học tập
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