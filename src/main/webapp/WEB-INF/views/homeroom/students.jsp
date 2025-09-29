<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Danh sách học sinh - Lớp ${classroom.classCode}</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
                <style>
                    .sort-link {
                        color: inherit;
                        text-decoration: none;
                        display: inline-flex;
                        align-items: center;
                        gap: 5px;
                    }

                    .sort-link:hover {
                        color: #0d6efd;
                        text-decoration: none;
                    }

                    .sort-icon {
                        opacity: 0.6;
                        font-size: 0.8em;
                    }

                    .sort-link:hover .sort-icon {
                        opacity: 1;
                    }
                </style>
            </head>

            <body class="bg-light">
                <!-- Header -->
                <nav class="navbar navbar-expand-lg navbar-dark bg-primary shadow-sm">
                    <div class="container">
                        <a class="navbar-brand" href="/homeroom">
                            <i class="fas fa-chalkboard-teacher me-2"></i>
                            Giáo viên chủ nhiệm
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
                    <!-- Breadcrumb -->
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item"><a href="/homeroom">Dashboard</a></li>
                            <li class="breadcrumb-item active">Lớp ${classroom.classCode}</li>
                            <li class="breadcrumb-item active">Học sinh</li>
                        </ol>
                    </nav>

                    <!-- Thông tin lớp -->
                    <div class="card mb-4">
                        <div class="card-body">
                            <div class="row align-items-center">
                                <div class="col-md-8">
                                    <h4 class="card-title mb-2">
                                        <i class="fas fa-door-open me-2"></i>
                                        Lớp ${classroom.classCode}
                                    </h4>
                                    <p class="mb-1"><strong>Ngành:</strong> ${classroom.major.majorName}</p>
                                    <p class="mb-1"><strong>Khóa:</strong> ${classroom.courseYear}</p>
                                    <p class="mb-0"><strong>Sĩ số:</strong>
                                        ${classroom.studentCount}/${classroom.maxSize} học sinh</p>
                                </div>
                                <div class="col-md-4 text-end">
                                    <a href="/homeroom/classroom/${classroom.id}/scores" class="btn btn-primary">
                                        <i class="fas fa-chart-line me-1"></i>
                                        Xem điểm số
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Danh sách học sinh -->
                    <div class="card">
                        <div class="card-header">
                            <h5 class="card-title mb-0">
                                <i class="fas fa-users me-2"></i>
                                Danh sách học sinh
                            </h5>
                        </div>
                        <div class="card-body">
                            <c:if test="${empty students.content}">
                                <div class="alert alert-info text-center">
                                    <i class="fas fa-info-circle me-2"></i>
                                    Lớp này chưa có học sinh nào.
                                </div>
                            </c:if>

                            <c:if test="${not empty students.content}">
                                <div class="table-responsive">
                                    <table class="table table-hover">
                                        <thead class="table-primary">
                                            <tr>
                                                <th scope="col">#</th>
                                                <th scope="col">
                                                    <a href="?classroomId=${classroom.id}&sort=studentCode&dir=${param.sort == 'studentCode' && param.dir == 'asc' ? 'desc' : 'asc'}&page=0&size=${students.size}"
                                                        class="sort-link">
                                                        Mã sinh viên
                                                        <i class="fas fa-sort sort-icon"></i>
                                                    </a>
                                                </th>
                                                <th scope="col">
                                                    <a href="?classroomId=${classroom.id}&sort=user.fname&dir=${param.sort == 'user.fname' && param.dir == 'asc' ? 'desc' : 'asc'}&page=0&size=${students.size}"
                                                        class="sort-link">
                                                        Họ và tên
                                                        <i class="fas fa-sort sort-icon"></i>
                                                    </a>
                                                </th>
                                                <th scope="col">Ngày sinh</th>
                                                <th scope="col">Giới tính</th>
                                                <th scope="col">
                                                    <a href="?classroomId=${classroom.id}&sort=email&dir=${param.sort == 'email' && param.dir == 'asc' ? 'desc' : 'asc'}&page=0&size=${students.size}"
                                                        class="sort-link">
                                                        Email
                                                        <i class="fas fa-sort sort-icon"></i>
                                                    </a>
                                                </th>
                                                <th scope="col">Số điện thoại</th>
                                                <th scope="col">Thao tác</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="student" items="${students.content}" varStatus="status">
                                                <tr>
                                                    <td>
                                                        ${(students.number * students.size) + status.index + 1}
                                                    </td>
                                                    <td>
                                                        <strong>${student.studentCode}</strong>
                                                    </td>
                                                    <td>
                                                        <div class="d-flex align-items-center">
                                                            <i class="fas fa-user-graduate me-2 text-primary"></i>
                                                            ${student.user.fname} ${student.user.lname}
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <c:if test="${not empty student.dateOfBirth}">
                                                            ${student.dateOfBirth}
                                                        </c:if>
                                                        <c:if test="${empty student.dateOfBirth}">
                                                            <span class="text-muted">Chưa cập nhật</span>
                                                        </c:if>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${student.gender == 'MALE'}">
                                                                <span class="badge bg-primary">
                                                                    <i class="fas fa-mars me-1"></i>Nam
                                                                </span>
                                                            </c:when>
                                                            <c:when test="${student.gender == 'FEMALE'}">
                                                                <span class="badge bg-info">
                                                                    <i class="fas fa-venus me-1"></i>Nữ
                                                                </span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="text-muted">Chưa xác định</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <c:if test="${not empty student.email}">
                                                            <a href="mailto:${student.email}"
                                                                class="text-decoration-none">
                                                                ${student.email}
                                                            </a>
                                                        </c:if>
                                                        <c:if test="${empty student.email}">
                                                            <span class="text-muted">Chưa cập nhật</span>
                                                        </c:if>
                                                    </td>
                                                    <td>
                                                        <c:if test="${not empty student.phoneNumber}">
                                                            ${student.phoneNumber}
                                                        </c:if>
                                                        <c:if test="${empty student.phoneNumber}">
                                                            <span class="text-muted">Chưa cập nhật</span>
                                                        </c:if>
                                                    </td>
                                                    <td>
                                                        <a href="/homeroom/classroom/${classroom.id}/scores?studentId=${student.id}"
                                                            class="btn btn-sm btn-outline-primary">
                                                            <i class="fas fa-chart-line me-1"></i>
                                                            Xem điểm
                                                        </a>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>

                                <!-- Pagination -->
                                <c:if test="${students.totalPages > 1}">
                                    <nav aria-label="Page navigation">
                                        <ul class="pagination justify-content-center">
                                            <c:if test="${students.hasPrevious()}">
                                                <li class="page-item">
                                                    <a class="page-link"
                                                        href="?classroomId=${classroom.id}&sort=${param.sort}&dir=${param.dir}&page=${students.number - 1}&size=${students.size}">
                                                        Trước
                                                    </a>
                                                </li>
                                            </c:if>

                                            <c:forEach var="i" begin="0" end="${students.totalPages - 1}">
                                                <li class="page-item ${i == students.number ? 'active' : ''}">
                                                    <a class="page-link"
                                                        href="?classroomId=${classroom.id}&sort=${param.sort}&dir=${param.dir}&page=${i}&size=${students.size}">
                                                        ${i + 1}
                                                    </a>
                                                </li>
                                            </c:forEach>

                                            <c:if test="${students.hasNext()}">
                                                <li class="page-item">
                                                    <a class="page-link"
                                                        href="?classroomId=${classroom.id}&sort=${param.sort}&dir=${param.dir}&page=${students.number + 1}&size=${students.size}">
                                                        Sau
                                                    </a>
                                                </li>
                                            </c:if>
                                        </ul>
                                    </nav>
                                </c:if>
                            </c:if>
                        </div>
                    </div>
                </div>

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            </body>

            </html>