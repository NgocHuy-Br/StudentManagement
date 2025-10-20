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
                                                    <fmt:formatNumber value="${gpa}" minFractionDigits="1"
                                                        maxFractionDigits="1" />
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

                                            </div>
                                        </div>
                                        <div class="card-body p-0">
                                            <c:choose>
                                                <c:when test="${empty scores}">
                                                    <div class="text-center py-5">
                                                        <i class="bi bi-clipboard-data text-muted"
                                                            style="font-size: 4rem;"></i>
                                                        <h4 class="text-muted mt-3">Chưa có điểm số</h4>
                                                        <p class="text-muted">Bạn chưa có điểm số nào được ghi nhận.</p>
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <!-- Scores Table -->
                                                    <div class="table-responsive">
                                                        <table class="table table-hover mb-0">
                                                            <thead class="table-light">
                                                                <tr>
                                                                    <th>Mã môn</th>
                                                                    <th>Tên môn học</th>
                                                                    <th class="text-center">Số TC</th>
                                                                    <th class="text-center">Điểm TB</th>
                                                                    <th class="text-center">Kết quả</th>
                                                                    <th class="text-center">Ghi chú</th>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                                <c:forEach items="${scores}" var="score">
                                                                    <tr data-subject="${score.subject.id}">
                                                                        <td class="fw-semibold">
                                                                            ${score.subject.subjectCode}</td>
                                                                        <td>${score.subject.subjectName}</td>
                                                                        <td class="text-center">
                                                                            ${score.subject.credits}</td>
                                                                        <td class="text-center">
                                                                            <c:choose>
                                                                                <c:when test="${score.avgScore >= 8.0}">
                                                                                    <span class="badge bg-success fs-6">
                                                                                        <fmt:formatNumber
                                                                                            value="${score.avgScore}"
                                                                                            maxFractionDigits="1" />
                                                                                    </span>
                                                                                </c:when>
                                                                                <c:when test="${score.avgScore >= 6.5}">
                                                                                    <span class="badge bg-warning fs-6">
                                                                                        <fmt:formatNumber
                                                                                            value="${score.avgScore}"
                                                                                            maxFractionDigits="1" />
                                                                                    </span>
                                                                                </c:when>
                                                                                <c:when test="${score.avgScore >= 5.0}">
                                                                                    <span class="badge bg-info fs-6">
                                                                                        <fmt:formatNumber
                                                                                            value="${score.avgScore}"
                                                                                            maxFractionDigits="1" />
                                                                                    </span>
                                                                                </c:when>
                                                                                <c:otherwise>
                                                                                    <span class="badge bg-danger fs-6">
                                                                                        <fmt:formatNumber
                                                                                            value="${score.avgScore}"
                                                                                            maxFractionDigits="1" />
                                                                                    </span>
                                                                                </c:otherwise>
                                                                            </c:choose>
                                                                        </td>
                                                                        <td class="text-center">
                                                                            <c:choose>
                                                                                <c:when test="${score.avgScore >= 5.0}">
                                                                                    <i
                                                                                        class="bi bi-check-circle-fill text-success fs-5"></i>
                                                                                </c:when>
                                                                                <c:otherwise>
                                                                                    <i
                                                                                        class="bi bi-x-circle-fill text-danger fs-5"></i>
                                                                                </c:otherwise>
                                                                            </c:choose>
                                                                        </td>
                                                                        <td class="text-center">
                                                                            <c:if test="${not empty score.notes}">
                                                                                <span
                                                                                    class="text-muted small">${score.notes}</span>
                                                                            </c:if>
                                                                        </td>
                                                                    </tr>
                                                                </c:forEach>
                                                            </tbody>
                                                        </table>
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
                        <script>
                            // Filter functionality
                            document.addEventListener('DOMContentLoaded', function () {
                                const subjectFilter = document.getElementById('subjectFilter');

                                function applyFilters() {
                                    const subjectId = subjectFilter ? subjectFilter.value : '';

                                    // Show/hide individual rows
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

                                // Apply initial filters
                                applyFilters();
                            });
                        </script>
            </body>

            </html>