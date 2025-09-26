<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1">
                <title>Môn học phụ trách</title>
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

                    .subject-card {
                        transition: transform 0.2s ease;
                        cursor: pointer;
                        border: 2px solid transparent;
                    }

                    .subject-card:hover {
                        transform: translateY(-5px);
                        border-color: #0d6efd;
                    }

                    .semester-badge {
                        font-size: 0.75em;
                        padding: 0.25rem 0.5rem;
                    }
                </style>
            </head>

            <body>
                <%@ include file="../common/header.jsp" %>
                    <main class="container-fluid main-wrap py-3">
                        <%@ include file="_nav.jsp" %>

                            <div class="card mt-3">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-center mb-4">
                                        <h5 class="mb-0"><i class="bi bi-book me-2"></i>Môn học phụ trách</h5>
                                        <span class="text-muted">Tổng cộng:
                                            <strong>${fn:length(teacherSubjects)}</strong> môn</span>
                                    </div>

                                    <c:if test="${empty teacherSubjects}">
                                        <div class="text-center py-5">
                                            <i class="bi bi-inbox fs-1 text-muted"></i>
                                            <h5 class="text-muted mt-3">Chưa có môn học nào</h5>
                                            <p class="text-muted">Bạn chưa được phân công dạy môn học nào. Vui lòng liên
                                                hệ admin để được phân công.</p>
                                        </div>
                                    </c:if>

                                    <div class="row">
                                        <c:forEach var="ts" items="${teacherSubjects}" varStatus="status">
                                            <div class="col-md-6 col-lg-4 col-xl-3 mb-4">
                                                <div class="card subject-card h-100"
                                                    onclick="location.href='${pageContext.request.contextPath}/teacher/subjects/${ts.subject.id}/students?semester=${ts.semester}'">
                                                    <div class="card-body d-flex flex-column">
                                                        <!-- Header -->
                                                        <div
                                                            class="d-flex justify-content-between align-items-start mb-3">
                                                            <div>
                                                                <h6 class="text-primary fw-bold mb-1">
                                                                    ${ts.subject.subjectCode}</h6>
                                                                <small
                                                                    class="text-muted">${ts.subject.major.majorCode}</small>
                                                            </div>
                                                            <span class="badge bg-info">${ts.subject.credit} TC</span>
                                                        </div>

                                                        <!-- Subject Name -->
                                                        <h6 class="mb-3 flex-grow-1">${ts.subject.subjectName}</h6>

                                                        <!-- Info -->
                                                        <div class="small text-muted mb-3">
                                                            <div class="mb-1">
                                                                <i class="bi bi-calendar3 me-1 text-primary"></i>
                                                                <span
                                                                    class="badge semester-badge bg-secondary">${ts.semester}</span>
                                                            </div>
                                                            <div class="mb-1">
                                                                <i class="bi bi-people me-1 text-primary"></i>
                                                                Lớp: <strong>${ts.className}</strong>
                                                            </div>
                                                            <div>
                                                                <i class="bi bi-mortarboard me-1 text-primary"></i>
                                                                ${ts.subject.major.majorName}
                                                            </div>
                                                        </div>

                                                        <!-- Actions -->
                                                        <div class="mt-auto pt-3 border-top">
                                                            <div class="d-grid">
                                                                <a href="${pageContext.request.contextPath}/teacher/subjects/${ts.subject.id}/students?semester=${ts.semester}"
                                                                    class="btn btn-outline-primary btn-sm">
                                                                    <i class="bi bi-people me-1"></i>Quản lý điểm
                                                                </a>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <!-- Card footer -->
                                                    <div class="card-footer bg-light border-top-0 py-2">
                                                        <small class="text-muted">
                                                            <i class="bi bi-clock me-1"></i>
                                                            Cập nhật gần nhất: Hôm nay
                                                        </small>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>

                                    <!-- Group by semester if there are many subjects -->
                                    <c:if test="${fn:length(teacherSubjects) > 6}">
                                        <div class="mt-5">
                                            <h6 class="text-muted mb-3">Phân theo học kỳ</h6>

                                            <!-- Group subjects by semester -->
                                            <c:set var="currentSemester" value="" />
                                            <c:forEach var="ts" items="${teacherSubjects}">
                                                <c:if test="${currentSemester != ts.semester}">
                                                    <c:set var="currentSemester" value="${ts.semester}" />
                                                    <div class="mt-4">
                                                        <h6 class="text-primary">
                                                            <i class="bi bi-calendar-week me-2"></i>
                                                            Học kỳ ${ts.semester}
                                                        </h6>
                                                        <div class="row">
                                                            <!-- Loop through subjects of this semester -->
                                                            <c:forEach var="ts2" items="${teacherSubjects}">
                                                                <c:if test="${ts2.semester == currentSemester}">
                                                                    <div class="col-auto">
                                                                        <span
                                                                            class="badge bg-light text-dark border me-2 mb-2">
                                                                            ${ts2.subject.subjectCode}
                                                                        </span>
                                                                    </div>
                                                                </c:if>
                                                            </c:forEach>
                                                        </div>
                                                    </div>
                                                </c:if>
                                            </c:forEach>
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                    </main>

                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
            </body>

            </html>