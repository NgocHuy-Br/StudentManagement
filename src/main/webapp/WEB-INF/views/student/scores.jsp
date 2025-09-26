<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <c:set var="contextPath" value="${pageContext.request.contextPath}" />
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Xem điểm số - PTIT SMS</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
                <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
                    rel="stylesheet">
                <style>
                    :root {
                        --ptit-blue: #0066cc;
                        --ptit-light-blue: #e8f3ff;
                    }

                    .navbar-brand {
                        color: var(--ptit-blue) !important;
                        font-weight: bold;
                    }

                    .card-header {
                        background-color: var(--ptit-blue);
                        color: white;
                    }

                    .btn-primary {
                        background-color: var(--ptit-blue);
                        border-color: var(--ptit-blue);
                    }

                    .btn-primary:hover {
                        background-color: #0056b3;
                        border-color: #0056b3;
                    }

                    .grade-A {
                        background-color: #d4edda;
                        color: #155724;
                        font-weight: 600;
                    }

                    .grade-B {
                        background-color: #cce6ff;
                        color: #004085;
                        font-weight: 600;
                    }

                    .grade-C {
                        background-color: #fff3cd;
                        color: #856404;
                        font-weight: 600;
                    }

                    .grade-D {
                        background-color: #f8d7da;
                        color: #721c24;
                        font-weight: 600;
                    }

                    .semester-card {
                        border-left: 4px solid var(--ptit-blue);
                        transition: all 0.3s ease;
                    }

                    .semester-card:hover {
                        box-shadow: 0 2px 10px rgba(0, 102, 204, 0.1);
                    }

                    .gpa-display {
                        background: linear-gradient(135deg, var(--ptit-blue), #0056b3);
                        color: white;
                        border-radius: 15px;
                        padding: 2rem;
                        text-align: center;
                    }

                    .gpa-value {
                        font-size: 3rem;
                        font-weight: 700;
                        margin: 0;
                    }

                    .table-hover tbody tr:hover {
                        background-color: var(--ptit-light-blue);
                    }
                </style>
            </head>

            <body class="bg-light">
                <!-- Header -->
                <%@ include file="../common/header.jsp" %>

                    <!-- Navigation -->
                    <%@ include file="_nav.jsp" %>

                        <div class="container-fluid py-4">
                            <div class="row">
                                <!-- GPA Card -->
                                <div class="col-lg-3 mb-4">
                                    <div class="gpa-display">
                                        <h6 class="mb-3">
                                            <i class="bi bi-trophy-fill me-2"></i>
                                            ĐIỂM TRUNG BÌNH TÍCH LŨY
                                        </h6>
                                        <p class="gpa-value">
                                            <c:choose>
                                                <c:when test="${gpa != null}">
                                                    <fmt:formatNumber value="${gpa}" maxFractionDigits="2" />
                                                </c:when>
                                                <c:otherwise>N/A</c:otherwise>
                                            </c:choose>
                                        </p>
                                        <small class="opacity-75">
                                            <c:choose>
                                                <c:when test="${gpa >= 3.6}">Xuất sắc</c:when>
                                                <c:when test="${gpa >= 3.2}">Giỏi</c:when>
                                                <c:when test="${gpa >= 2.5}">Khá</c:when>
                                                <c:when test="${gpa >= 2.0}">Trung bình</c:when>
                                                <c:when test="${gpa != null}">Yếu</c:when>
                                                <c:otherwise>Chưa có điểm</c:otherwise>
                                            </c:choose>
                                        </small>
                                    </div>
                                </div>

                                <!-- Scores Content -->
                                <div class="col-lg-9">
                                    <div class="card shadow-sm">
                                        <div class="card-header d-flex justify-content-between align-items-center">
                                            <h5 class="mb-0">
                                                <i class="bi bi-graph-up me-2"></i>
                                                Bảng điểm
                                            </h5>
                                            <div class="d-flex gap-2">
                                                <!-- Filter by Subject -->
                                                <c:if test="${not empty subjects}">
                                                    <select class="form-select form-select-sm" id="subjectFilter"
                                                        style="width: auto;">
                                                        <option value="">Tất cả môn học</option>
                                                        <c:forEach items="${subjects}" var="subject">
                                                            <option value="${subject.id}" ${param.subjectId==subject.id
                                                                ? 'selected' : '' }>
                                                                ${subject.subjectCode} - ${subject.subjectName}
                                                            </option>
                                                        </c:forEach>
                                                    </select>
                                                </c:if>

                                                <!-- Filter by Semester -->
                                                <select class="form-select form-select-sm" id="semesterFilter"
                                                    style="width: auto;">
                                                    <option value="">Tất cả học kỳ</option>
                                                    <c:forEach items="${semesters}" var="semester">
                                                        <option value="${semester}" ${param.semester==semester
                                                            ? 'selected' : '' }>
                                                            Học kỳ ${semester}
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="card-body p-0">
                                            <c:choose>
                                                <c:when test="${empty scoresBySemester}">
                                                    <div class="text-center py-5">
                                                        <i class="bi bi-clipboard-data text-muted"
                                                            style="font-size: 4rem;"></i>
                                                        <h4 class="text-muted mt-3">Chưa có điểm số</h4>
                                                        <p class="text-muted">Bạn chưa có điểm số nào được ghi nhận.</p>
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <!-- Scores by Semester -->
                                                    <c:forEach items="${scoresBySemester}" var="semesterEntry">
                                                        <div class="semester-section"
                                                            data-semester="${semesterEntry.key}">
                                                            <div class="semester-header bg-light p-3 border-bottom">
                                                                <h6 class="mb-0 text-primary">
                                                                    <i class="bi bi-calendar3 me-2"></i>
                                                                    Học kỳ ${semesterEntry.key}
                                                                    <span class="badge bg-secondary ms-2">
                                                                        ${semesterEntry.value.size()} môn
                                                                    </span>
                                                                </h6>
                                                            </div>

                                                            <div class="table-responsive">
                                                                <table class="table table-hover mb-0">
                                                                    <thead class="table-light">
                                                                        <tr>
                                                                            <th>Mã môn</th>
                                                                            <th>Tên môn học</th>
                                                                            <th class="text-center">Số TC</th>
                                                                            <th class="text-center">Điểm TB</th>
                                                                            <th class="text-center">Xếp loại</th>
                                                                            <th class="text-center">Ghi chú</th>
                                                                        </tr>
                                                                    </thead>
                                                                    <tbody>
                                                                        <c:forEach items="${semesterEntry.value}"
                                                                            var="score">
                                                                            <tr data-subject="${score.subject.id}">
                                                                                <td class="fw-semibold">
                                                                                    ${score.subject.subjectCode}</td>
                                                                                <td>${score.subject.subjectName}</td>
                                                                                <td class="text-center">
                                                                                    ${score.subject.credit}</td>
                                                                                <td class="text-center">
                                                                                    <c:set var="gradeClass" value="" />
                                                                                    <c:choose>
                                                                                        <c:when
                                                                                            test="${score.avgScore >= 8.5}">
                                                                                            <c:set var="gradeClass"
                                                                                                value="grade-A" />
                                                                                        </c:when>
                                                                                        <c:when
                                                                                            test="${score.avgScore >= 7.0}">
                                                                                            <c:set var="gradeClass"
                                                                                                value="grade-B" />
                                                                                        </c:when>
                                                                                        <c:when
                                                                                            test="${score.avgScore >= 5.5}">
                                                                                            <c:set var="gradeClass"
                                                                                                value="grade-C" />
                                                                                        </c:when>
                                                                                        <c:otherwise>
                                                                                            <c:set var="gradeClass"
                                                                                                value="grade-D" />
                                                                                        </c:otherwise>
                                                                                    </c:choose>
                                                                                    <span class="badge ${gradeClass}">
                                                                                        <fmt:formatNumber
                                                                                            value="${score.avgScore}"
                                                                                            maxFractionDigits="1" />
                                                                                    </span>
                                                                                </td>
                                                                                <td class="text-center">
                                                                                    <c:choose>
                                                                                        <c:when
                                                                                            test="${score.avgScore >= 8.5}">
                                                                                            <span
                                                                                                class="text-success fw-semibold">Xuất
                                                                                                sắc</span>
                                                                                        </c:when>
                                                                                        <c:when
                                                                                            test="${score.avgScore >= 7.0}">
                                                                                            <span
                                                                                                class="text-primary fw-semibold">Giỏi</span>
                                                                                        </c:when>
                                                                                        <c:when
                                                                                            test="${score.avgScore >= 5.5}">
                                                                                            <span
                                                                                                class="text-warning fw-semibold">Khá</span>
                                                                                        </c:when>
                                                                                        <c:when
                                                                                            test="${score.avgScore >= 4.0}">
                                                                                            <span
                                                                                                class="text-info fw-semibold">Trung
                                                                                                bình</span>
                                                                                        </c:when>
                                                                                        <c:otherwise>
                                                                                            <span
                                                                                                class="text-danger fw-semibold">Yếu</span>
                                                                                        </c:otherwise>
                                                                                    </c:choose>
                                                                                </td>
                                                                                <td class="text-center">
                                                                                    <c:choose>
                                                                                        <c:when
                                                                                            test="${score.avgScore >= 4.0}">
                                                                                            <span
                                                                                                class="badge bg-success">Đạt</span>
                                                                                        </c:when>
                                                                                        <c:otherwise>
                                                                                            <span
                                                                                                class="badge bg-danger">Không
                                                                                                đạt</span>
                                                                                        </c:otherwise>
                                                                                    </c:choose>
                                                                                </td>
                                                                            </tr>
                                                                        </c:forEach>
                                                                    </tbody>
                                                                </table>
                                                            </div>
                                                        </div>
                                                    </c:forEach>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <script
                            src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
                        <script>
                            // Filter functionality
                            document.addEventListener('DOMContentLoaded', function () {
                                const subjectFilter = document.getElementById('subjectFilter');
                                const semesterFilter = document.getElementById('semesterFilter');

                                function applyFilters() {
                                    const subjectId = subjectFilter ? subjectFilter.value : '';
                                    const semester = semesterFilter ? semesterFilter.value : '';

                                    // Show/hide semester sections
                                    document.querySelectorAll('.semester-section').forEach(section => {
                                        const sectionSemester = section.dataset.semester;
                                        let showSection = !semester || sectionSemester === semester;

                                        if (showSection && subjectId) {
                                            // Check if this semester has the selected subject
                                            const hasSubject = section.querySelector(`tr[data-subject="${subjectId}"]`);
                                            showSection = hasSubject !== null;
                                        }

                                        section.style.display = showSection ? 'block' : 'none';
                                    });

                                    // Show/hide individual rows within visible sections
                                    if (subjectId) {
                                        document.querySelectorAll('tr[data-subject]').forEach(row => {
                                            const rowSubject = row.dataset.subject;
                                            row.style.display = (rowSubject === subjectId) ? 'table-row' : 'none';
                                        });
                                    } else {
                                        document.querySelectorAll('tr[data-subject]').forEach(row => {
                                            row.style.display = 'table-row';
                                        });
                                    }
                                }

                                if (subjectFilter) {
                                    subjectFilter.addEventListener('change', applyFilters);
                                }
                                if (semesterFilter) {
                                    semesterFilter.addEventListener('change', applyFilters);
                                }

                                // Apply initial filters based on URL parameters
                                applyFilters();
                            });
                        </script>
            </body>

            </html>