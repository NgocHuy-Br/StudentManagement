<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1">
                <title>Bảng điều khiển - Giáo viên</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
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

                    .stats-card {
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        color: white;
                    }

                    .stats-card .card-body {
                        position: relative;
                        overflow: hidden;
                    }

                    .stats-card .card-body::before {
                        content: '';
                        position: absolute;
                        top: 0;
                        right: 0;
                        width: 100px;
                        height: 100px;
                        background: rgba(255, 255, 255, 0.1);
                        border-radius: 50%;
                        transform: translate(30px, -30px);
                    }

                    .subject-card {
                        transition: transform 0.2s ease;
                        cursor: pointer;
                    }

                    .subject-card:hover {
                        transform: translateY(-5px);
                    }
                </style>
            </head>

            <body>
                <%@ include file="../common/header.jsp" %>
                    <main class="container-fluid main-wrap py-3">
                        <%@ include file="_nav.jsp" %>

                            <!-- Thống kê tổng quan -->
                            <div class="row mt-3">
                                <div class="col-md-6 col-lg-3 mb-3">
                                    <div class="card stats-card">
                                        <div class="card-body">
                                            <div class="d-flex justify-content-between align-items-center">
                                                <div>
                                                    <h6 class="text-white-50 mb-1">Môn phụ trách</h6>
                                                    <h3 class="mb-0">${fn:length(teacherSubjects)}</h3>
                                                </div>
                                                <i class="bi bi-book fs-1 text-white-50"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6 col-lg-3 mb-3">
                                    <div class="card stats-card"
                                        style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);">
                                        <div class="card-body">
                                            <div class="d-flex justify-content-between align-items-center">
                                                <div>
                                                    <h6 class="text-white-50 mb-1">Học kỳ hiện tại</h6>
                                                    <h3 class="mb-0">2024-2</h3>
                                                </div>
                                                <i class="bi bi-calendar-week fs-1 text-white-50"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6 col-lg-3 mb-3">
                                    <div class="card stats-card"
                                        style="background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);">
                                        <div class="card-body">
                                            <div class="d-flex justify-content-between align-items-center">
                                                <div>
                                                    <h6 class="text-white-50 mb-1">Lớp dạy</h6>
                                                    <h3 class="mb-0">
                                                        <c:set var="uniqueClasses"
                                                            value="${fn:join(teacherSubjects.stream().map(ts -> ts.className).distinct().collect(Collectors.toList()), ', ')}" />
                                                        ${fn:length(fn:split(uniqueClasses, ','))}
                                                    </h3>
                                                </div>
                                                <i class="bi bi-people fs-1 text-white-50"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6 col-lg-3 mb-3">
                                    <div class="card stats-card"
                                        style="background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);">
                                        <div class="card-body">
                                            <div class="d-flex justify-content-between align-items-center">
                                                <div>
                                                    <h6 class="text-white-50 mb-1">Chức vụ</h6>
                                                    <h3 class="mb-0">Giáo viên</h3>
                                                </div>
                                                <i class="bi bi-person-badge fs-1 text-white-50"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Danh sách môn học phụ trách -->
                            <div class="row">
                                <div class="col-12">
                                    <div class="card">
                                        <div class="card-body">
                                            <h5 class="mb-4"><i class="bi bi-list-ul me-2"></i>Môn học phụ trách</h5>

                                            <c:if test="${empty teacherSubjects}">
                                                <div class="text-center py-5">
                                                    <i class="bi bi-inbox fs-1 text-muted"></i>
                                                    <p class="text-muted mt-3">Bạn chưa được phân công dạy môn học nào.
                                                    </p>
                                                </div>
                                            </c:if>

                                            <div class="row">
                                                <c:forEach var="ts" items="${teacherSubjects}">
                                                    <div class="col-md-6 col-lg-4 mb-3">
                                                        <div class="card subject-card border-0 shadow-sm"
                                                            onclick="location.href='${pageContext.request.contextPath}/teacher/subjects/${ts.subject.id}/students?semester=${ts.semester}'">
                                                            <div class="card-body">
                                                                <div
                                                                    class="d-flex justify-content-between align-items-start mb-2">
                                                                    <h6 class="text-primary fw-bold mb-0">
                                                                        ${ts.subject.subjectCode}</h6>
                                                                    <span class="badge bg-info">${ts.subject.credit}
                                                                        TC</span>
                                                                </div>
                                                                <h6 class="mb-2">${ts.subject.subjectName}</h6>
                                                                <div class="small text-muted">
                                                                    <div><i class="bi bi-mortarboard me-1"></i>Ngành:
                                                                        ${ts.subject.major.majorCode}</div>
                                                                    <div><i class="bi bi-calendar3 me-1"></i>HK:
                                                                        ${ts.semester}</div>
                                                                    <div><i class="bi bi-people me-1"></i>Lớp:
                                                                        ${ts.className}</div>
                                                                </div>
                                                                <div class="mt-3 pt-2 border-top">
                                                                    <a href="${pageContext.request.contextPath}/teacher/subjects/${ts.subject.id}/students?semester=${ts.semester}"
                                                                        class="btn btn-outline-primary btn-sm">
                                                                        <i class="bi bi-eye me-1"></i>Xem sinh viên
                                                                    </a>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </c:forEach>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                    </main>

                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
            </body>

            </html>