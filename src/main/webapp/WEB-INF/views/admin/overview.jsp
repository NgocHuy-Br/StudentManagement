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
            </head>

            <body>
                <div class="container-fluid" style="padding: 0 clamp(12px, 4vw, 36px);">
                    <jsp:include page="../common/_header.jsp">
                        <jsp:param name="pageTitle" value="Tổng quan" />
                    </jsp:include>

                    <c:set var="activeTab" value="overview" scope="request" />
                    <jsp:include page="_nav.jsp" />

                    <div class="row mt-4">
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
                                            <td class="fw-bold text-muted" style="width: 40%;">ID:</td>
                                            <td>${currentUser.id}</td>
                                        </tr>
                                        <tr>
                                            <td class="fw-bold text-muted">Username:</td>
                                            <td>${currentUser.username}</td>
                                        </tr>
                                        <tr>
                                            <td class="fw-bold text-muted">Họ tên:</td>
                                            <td>${currentUser.fullName != null ? currentUser.fullName : 'Chưa cập nhật'}
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="fw-bold text-muted">Email:</td>
                                            <td>${currentUser.email != null ? currentUser.email : 'Chưa cập nhật'}</td>
                                        </tr>
                                        <tr>
                                            <td class="fw-bold text-muted">Số điện thoại:</td>
                                            <td>${currentUser.phone != null ? currentUser.phone : 'Chưa cập nhật'}</td>
                                        </tr>
                                        <tr>
                                            <td class="fw-bold text-muted">Vai trò:</td>
                                            <td>
                                                <span class="badge bg-danger">${currentUser.role}</span>
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
                                    </table>
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
                                                                <i class="bi bi-building text-primary me-2"></i>
                                                                <div>
                                                                    <div class="fw-bold">${facultyStat.facultyName}
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
                                                            <i class="bi bi-inbox display-4 d-block mb-2"></i>
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
                                                    <th class="text-center">Khóa học</th>
                                                    <th class="text-center">Số Học sinh</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="majorStat" items="${majorStats}">
                                                    <tr>
                                                        <td>
                                                            <div class="d-flex align-items-center">
                                                                <i class="bi bi-mortarboard text-success me-2"></i>
                                                                <div>
                                                                    <div class="fw-bold">${majorStat.majorName}</div>
                                                                    <small
                                                                        class="text-muted">${majorStat.majorCode}</small>
                                                                </div>
                                                            </div>
                                                        </td>
                                                        <td>
                                                            <small class="text-muted">${majorStat.facultyName}</small>
                                                        </td>
                                                        <td class="text-center">
                                                            <span
                                                                class="badge bg-secondary rounded-pill">${majorStat.courseYear}</span>
                                                        </td>
                                                        <td class="text-center">
                                                            <span
                                                                class="badge bg-warning rounded-pill">${majorStat.studentCount}</span>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                                <c:if test="${empty majorStats}">
                                                    <tr>
                                                        <td colspan="4" class="text-center text-muted py-4">
                                                            <i class="bi bi-inbox display-4 d-block mb-2"></i>
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

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
            </body>

            </html>