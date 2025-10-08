<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
            <!DOCTYPE html>
            <html>

            <head>
                <title>Teacher Dashboard</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
                <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
                    rel="stylesheet">
            </head>

            <body>
                <!-- Navigation Bar -->
                <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
                    <div class="container">
                        <a class="navbar-brand" href="/teacher">
                            <i class="bi bi-mortarboard-fill"></i> Teacher Dashboard
                        </a>
                        <div class="navbar-nav ms-auto">
                            <div class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle text-white" href="#" id="navbarDropdown"
                                    role="button" data-bs-toggle="dropdown">
                                    <i class="bi bi-person-circle"></i> ${teacher.user.fname} ${teacher.user.lname}
                                </a>
                                <ul class="dropdown-menu">
                                    <li><a class="dropdown-item" href="/teacher/profile"><i class="bi bi-person"></i>
                                            Thông tin cá nhân</a></li>
                                    <li>
                                        <hr class="dropdown-divider">
                                    </li>
                                    <li><a class="dropdown-item" href="/logout"><i class="bi bi-box-arrow-right"></i>
                                            Đăng xuất</a></li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </nav>

                <div class="container mt-4">
                    <div class="row">
                        <div class="col-12">
                            <div class="card">
                                <div class="card-header bg-primary text-white">
                                    <h4><i class="bi bi-speedometer2"></i> Dashboard Giáo viên</h4>
                                </div>
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col-md-6">
                                            <h5>Thông tin cá nhân</h5>
                                            <p><strong>Họ tên:</strong> ${teacher.user.fname} ${teacher.user.lname}</p>
                                            <p><strong>Mã giáo viên:</strong> ${teacher.teacherCode}</p>
                                            <p><strong>Bộ môn:</strong> ${teacher.department}</p>
                                            <p><strong>Email:</strong> ${teacher.user.email}</p>
                                        </div>
                                        <div class="col-md-6">
                                            <h5>Lớp phụ trách</h5>
                                            <c:choose>
                                                <c:when test="${not empty classrooms}">
                                                    <ul class="list-group">
                                                        <c:forEach items="${classrooms}" var="classroom">
                                                            <li
                                                                class="list-group-item d-flex justify-content-between align-items-center">
                                                                ${classroom.classCode}
                                                                <span
                                                                    class="badge bg-primary rounded-pill">${classroom.currentSize}/${classroom.maxSize}</span>
                                                            </li>
                                                        </c:forEach>
                                                    </ul>
                                                </c:when>
                                                <c:otherwise>
                                                    <p class="text-muted">Chưa được phân công lớp nào</p>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>

                                    <hr>

                                    <div class="row">
                                        <div class="col-md-12">
                                            <h5>Chức năng nhanh</h5>
                                            <div class="row">
                                                <div class="col-md-3">
                                                    <a href="/teacher/classes"
                                                        class="btn btn-outline-primary w-100 mb-2">
                                                        <i class="bi bi-people-fill"></i><br>Quản lý lớp
                                                    </a>
                                                </div>
                                                <div class="col-md-3">
                                                    <a href="/teacher/scores"
                                                        class="btn btn-outline-success w-100 mb-2">
                                                        <i class="bi bi-journal-text"></i><br>Nhập điểm
                                                    </a>
                                                </div>
                                                <div class="col-md-3">
                                                    <a href="/teacher/schedule" class="btn btn-outline-info w-100 mb-2">
                                                        <i class="bi bi-calendar3"></i><br>Lịch giảng dạy
                                                    </a>
                                                </div>
                                                <div class="col-md-3">
                                                    <a href="/teacher/notifications"
                                                        class="btn btn-outline-warning w-100 mb-2">
                                                        <i class="bi bi-bell-fill"></i><br>Thông báo
                                                    </a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
            </body>

            </html>