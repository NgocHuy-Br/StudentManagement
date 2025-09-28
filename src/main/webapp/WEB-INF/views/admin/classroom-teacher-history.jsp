<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
            <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1">
                    <title>Lịch sử giáo viên chủ nhiệm - ${classroom.classCode}</title>
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
                        rel="stylesheet">
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
                        rel="stylesheet">
                    <style>
                        :root {
                            --page-x: clamp(12px, 4vw, 36px)
                        }

                        body {
                            background: #f7f7f9
                        }

                        .main-wrap {
                            padding-left: var(--page-x);
                            padding-right: var(--page-x)
                        }

                        .card {
                            border-radius: 12px;
                            box-shadow: 0 10px 25px rgba(0, 0, 0, .06)
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
                            height: 100%;
                            width: 2px;
                            background: #dee2e6;
                        }

                        .timeline-item {
                            position: relative;
                            margin-bottom: 30px;
                        }

                        .timeline-item::before {
                            content: '';
                            position: absolute;
                            left: -22px;
                            top: 8px;
                            width: 12px;
                            height: 12px;
                            border-radius: 50%;
                            background: #28a745;
                            border: 3px solid #fff;
                            box-shadow: 0 0 0 3px #dee2e6;
                        }

                        .timeline-item.current::before {
                            background: #007bff;
                            box-shadow: 0 0 0 3px #007bff20;
                        }

                        .timeline-item.ended::before {
                            background: #6c757d;
                        }

                        .teacher-card {
                            transition: transform 0.2s ease;
                        }

                        .teacher-card:hover {
                            transform: translateY(-2px);
                        }
                    </style>
                </head>

                <body>
                    <jsp:include page="../common/header.jsp" />

                    <div class="main-wrap">
                        <div class="container-fluid py-4">
                            <!-- Breadcrumb -->
                            <nav aria-label="breadcrumb" class="mb-4">
                                <ol class="breadcrumb">
                                    <li class="breadcrumb-item"><a href="/admin/dashboard">Dashboard</a></li>
                                    <li class="breadcrumb-item"><a href="/admin/classrooms">Quản lý lớp học</a></li>
                                    <li class="breadcrumb-item active">Lịch sử giáo viên chủ nhiệm</li>
                                </ol>
                            </nav>

                            <!-- Page Header -->
                            <div class="row mb-4">
                                <div class="col">
                                    <div class="card border-0">
                                        <div class="card-body">
                                            <div class="d-flex justify-content-between align-items-center">
                                                <div>
                                                    <h1 class="h3 mb-1">
                                                        <i class="bi bi-clock-history text-primary me-2"></i>
                                                        Lịch sử giáo viên chủ nhiệm
                                                    </h1>
                                                    <p class="text-muted mb-0">
                                                        Lớp: <strong>${classroom.classCode}</strong> |
                                                        Ngành: <strong>${classroom.major.majorName}</strong> |
                                                        Khóa: <strong>${classroom.courseYear}</strong>
                                                    </p>
                                                </div>
                                                <div>
                                                    <a href="/admin/classrooms?selectedClassId=${classroom.id}"
                                                        class="btn btn-outline-secondary">
                                                        <i class="bi bi-arrow-left me-2"></i>Quay lại
                                                    </a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Current Teacher -->
                            <c:if test="${currentTeacher != null}">
                                <div class="row mb-4">
                                    <div class="col">
                                        <div class="card border-0 border-start border-4 border-primary">
                                            <div class="card-body">
                                                <div class="d-flex align-items-center">
                                                    <div class="flex-shrink-0 me-3">
                                                        <div class="bg-primary rounded-circle d-flex align-items-center justify-content-center"
                                                            style="width: 50px; height: 50px;">
                                                            <i class="bi bi-person-check text-white"></i>
                                                        </div>
                                                    </div>
                                                    <div class="flex-grow-1">
                                                        <h5 class="mb-1">
                                                            Giáo viên chủ nhiệm hiện tại
                                                            <span class="badge bg-primary ms-2">Đang nhiệm kỳ</span>
                                                        </h5>
                                                        <h6 class="text-primary mb-1">
                                                            <c:choose>
                                                                <c:when
                                                                    test="${not empty currentTeacher.teacher.teacherCode}">
                                                                    ${currentTeacher.teacher.teacherCode}
                                                                </c:when>
                                                                <c:otherwise>
                                                                    ${currentTeacher.teacher.user.username}
                                                                </c:otherwise>
                                                            </c:choose>
                                                            -
                                                            <c:choose>
                                                                <c:when
                                                                    test="${not empty currentTeacher.teacher.user.fname and not empty currentTeacher.teacher.user.lname}">
                                                                    ${currentTeacher.teacher.user.lname}
                                                                    ${currentTeacher.teacher.user.fname}
                                                                </c:when>
                                                                <c:otherwise>
                                                                    ${currentTeacher.teacher.user.username}
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </h6>
                                                        <p class="text-muted mb-0">
                                                            <i class="bi bi-calendar-check me-1"></i>
                                                            Bắt đầu:
                                                            <fmt:formatDate value="${currentTeacher.startDate}"
                                                                pattern="dd/MM/yyyy" />
                                                            <c:if test="${not empty currentTeacher.notes}">
                                                                | <i
                                                                    class="bi bi-sticky me-1"></i>${currentTeacher.notes}
                                                            </c:if>
                                                        </p>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:if>

                            <!-- History Timeline -->
                            <div class="row">
                                <div class="col">
                                    <div class="card border-0">
                                        <div class="card-header bg-light">
                                            <h5 class="mb-0">
                                                <i class="bi bi-timeline me-2"></i>Lịch sử thay đổi
                                            </h5>
                                        </div>
                                        <div class="card-body">
                                            <c:choose>
                                                <c:when test="${not empty teacherHistory}">
                                                    <div class="timeline">
                                                        <c:forEach var="record" items="${teacherHistory}"
                                                            varStatus="status">
                                                            <div
                                                                class="timeline-item ${record.endDate == null ? 'current' : 'ended'}">
                                                                <div class="teacher-card card border-0 shadow-sm">
                                                                    <div class="card-body">
                                                                        <div class="row align-items-center">
                                                                            <div class="col-md-8">
                                                                                <h6 class="mb-1">
                                                                                    <c:choose>
                                                                                        <c:when
                                                                                            test="${not empty record.teacher.teacherCode}">
                                                                                            ${record.teacher.teacherCode}
                                                                                        </c:when>
                                                                                        <c:otherwise>
                                                                                            ${record.teacher.user.username}
                                                                                        </c:otherwise>
                                                                                    </c:choose>
                                                                                    -
                                                                                    <c:choose>
                                                                                        <c:when
                                                                                            test="${not empty record.teacher.user.fname and not empty record.teacher.user.lname}">
                                                                                            ${record.teacher.user.lname}
                                                                                            ${record.teacher.user.fname}
                                                                                        </c:when>
                                                                                        <c:otherwise>
                                                                                            ${record.teacher.user.username}
                                                                                        </c:otherwise>
                                                                                    </c:choose>
                                                                                    <c:if
                                                                                        test="${record.endDate == null}">
                                                                                        <span
                                                                                            class="badge bg-success ms-2">Hiện
                                                                                            tại</span>
                                                                                    </c:if>
                                                                                </h6>
                                                                                <p class="text-muted mb-0">
                                                                                    <i
                                                                                        class="bi bi-calendar-event me-1"></i>
                                                                                    <fmt:formatDate
                                                                                        value="${record.startDate}"
                                                                                        pattern="dd/MM/yyyy" />
                                                                                    <c:if
                                                                                        test="${record.endDate != null}">
                                                                                        →
                                                                                        <fmt:formatDate
                                                                                            value="${record.endDate}"
                                                                                            pattern="dd/MM/yyyy" />
                                                                                    </c:if>
                                                                                    <c:if
                                                                                        test="${not empty record.notes}">
                                                                                        <br>
                                                                                        <i
                                                                                            class="bi bi-sticky me-1"></i>
                                                                                        <em>${record.notes}</em>
                                                                                    </c:if>
                                                                                </p>
                                                                            </div>
                                                                            <div class="col-md-4 text-end">
                                                                                <c:if
                                                                                    test="${not empty record.teacher.user.email}">
                                                                                    <small class="text-muted d-block">
                                                                                        <i
                                                                                            class="bi bi-envelope me-1"></i>${record.teacher.user.email}
                                                                                    </small>
                                                                                </c:if>
                                                                                <c:if
                                                                                    test="${not empty record.teacher.user.phone}">
                                                                                    <small class="text-muted d-block">
                                                                                        <i
                                                                                            class="bi bi-telephone me-1"></i>${record.teacher.user.phone}
                                                                                    </small>
                                                                                </c:if>
                                                                                <c:if
                                                                                    test="${not empty record.teacher.department}">
                                                                                    <small class="text-muted d-block">
                                                                                        <i
                                                                                            class="bi bi-building me-1"></i>${record.teacher.department}
                                                                                    </small>
                                                                                </c:if>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </c:forEach>
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="text-center py-5">
                                                        <i class="bi bi-clock-history text-muted"
                                                            style="font-size: 3rem;"></i>
                                                        <h5 class="text-muted mt-3">Chưa có lịch sử</h5>
                                                        <p class="text-muted">Lớp học này chưa có giáo viên chủ nhiệm
                                                            nào.</p>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
                </body>

                </html>