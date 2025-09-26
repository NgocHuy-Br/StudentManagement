<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <c:set var="contextPath" value="${pageContext.request.contextPath}" />
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Môn học của tôi - PTIT SMS</title>
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

                    .subject-card {
                        border-left: 4px solid var(--ptit-blue);
                        transition: all 0.3s ease;
                    }

                    .subject-card:hover {
                        box-shadow: 0 4px 15px rgba(0, 102, 204, 0.2);
                        transform: translateY(-2px);
                    }

                    .credit-badge {
                        background: linear-gradient(45deg, var(--ptit-blue), #0056b3);
                        color: white;
                        font-weight: 600;
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
                                <!-- Main Content -->
                                <div class="col-12">
                                    <div class="card shadow-sm">
                                        <div class="card-header d-flex justify-content-between align-items-center">
                                            <h5 class="mb-0">
                                                <i class="bi bi-book me-2"></i>
                                                Môn học của tôi - Ngành ${student.major.majorName}
                                            </h5>
                                            <span class="badge bg-light text-dark">
                                                Tổng: ${subjects.size()} môn học
                                            </span>
                                        </div>
                                        <div class="card-body">
                                            <!-- Major Info -->
                                            <div class="row mb-4">
                                                <div class="col-12">
                                                    <div class="alert alert-info d-flex align-items-center">
                                                        <i class="bi bi-info-circle me-2"></i>
                                                        <div>
                                                            <strong>Ngành học:</strong> ${student.major.majorName}
                                                            (${student.major.majorCode})
                                                            <c:if test="${not empty student.major.description}">
                                                                <br><small
                                                                    class="text-muted">${student.major.description}</small>
                                                            </c:if>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- Subjects Grid -->
                                            <c:choose>
                                                <c:when test="${empty subjects}">
                                                    <div class="text-center py-5">
                                                        <i class="bi bi-book text-muted" style="font-size: 4rem;"></i>
                                                        <h4 class="text-muted mt-3">Chưa có môn học nào</h4>
                                                        <p class="text-muted">Ngành học của bạn chưa được cấu hình môn
                                                            học.</p>
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="row g-4">
                                                        <c:forEach items="${subjects}" var="subject">
                                                            <div class="col-lg-6 col-xl-4">
                                                                <div class="card subject-card h-100">
                                                                    <div class="card-header bg-white border-0 pb-0">
                                                                        <div
                                                                            class="d-flex justify-content-between align-items-start">
                                                                            <h6
                                                                                class="card-title text-primary fw-bold mb-1">
                                                                                ${subject.subjectCode}
                                                                            </h6>
                                                                            <span class="badge credit-badge">
                                                                                ${subject.credit} TC
                                                                            </span>
                                                                        </div>
                                                                    </div>
                                                                    <div class="card-body pt-2">
                                                                        <h6 class="card-subtitle text-dark mb-3">
                                                                            ${subject.subjectName}
                                                                        </h6>

                                                                        <!-- Score Info -->
                                                                        <c:set var="hasScore" value="false" />
                                                                        <c:set var="latestScore" value="" />
                                                                        <c:forEach items="${scores}" var="score">
                                                                            <c:if
                                                                                test="${score.subject.id == subject.id}">
                                                                                <c:set var="hasScore" value="true" />
                                                                                <c:set var="latestScore"
                                                                                    value="${score}" />
                                                                            </c:if>
                                                                        </c:forEach>

                                                                        <div
                                                                            class="d-flex justify-content-between align-items-center mb-3">
                                                                            <span class="text-muted small">
                                                                                <i class="bi bi-award me-1"></i>Điểm số:
                                                                            </span>
                                                                            <c:choose>
                                                                                <c:when test="${hasScore}">
                                                                                    <c:set var="scoreClass" value="" />
                                                                                    <c:choose>
                                                                                        <c:when
                                                                                            test="${latestScore.avgScore >= 8.5}">
                                                                                            <c:set var="scoreClass"
                                                                                                value="text-success fw-bold" />
                                                                                        </c:when>
                                                                                        <c:when
                                                                                            test="${latestScore.avgScore >= 7.0}">
                                                                                            <c:set var="scoreClass"
                                                                                                value="text-primary fw-bold" />
                                                                                        </c:when>
                                                                                        <c:when
                                                                                            test="${latestScore.avgScore >= 5.5}">
                                                                                            <c:set var="scoreClass"
                                                                                                value="text-warning fw-bold" />
                                                                                        </c:when>
                                                                                        <c:when
                                                                                            test="${latestScore.avgScore >= 4.0}">
                                                                                            <c:set var="scoreClass"
                                                                                                value="text-orange fw-bold" />
                                                                                        </c:when>
                                                                                        <c:otherwise>
                                                                                            <c:set var="scoreClass"
                                                                                                value="text-danger fw-bold" />
                                                                                        </c:otherwise>
                                                                                    </c:choose>
                                                                                    <span class="${scoreClass}">
                                                                                        <fmt:formatNumber
                                                                                            value="${latestScore.avgScore}"
                                                                                            maxFractionDigits="1" />
                                                                                    </span>
                                                                                </c:when>
                                                                                <c:otherwise>
                                                                                    <span class="text-muted">Chưa
                                                                                        có</span>
                                                                                </c:otherwise>
                                                                            </c:choose>
                                                                        </div>

                                                                        <!-- Quick Actions -->
                                                                        <div class="d-grid gap-2">
                                                                            <a href="${contextPath}/student/scores?subjectId=${subject.id}"
                                                                                class="btn btn-outline-primary btn-sm">
                                                                                <i class="bi bi-graph-up me-1"></i>
                                                                                Xem điểm chi tiết
                                                                            </a>
                                                                        </div>
                                                                    </div>

                                                                    <!-- Footer with additional info -->
                                                                    <div class="card-footer bg-light border-0 pt-0">
                                                                        <div
                                                                            class="d-flex justify-content-between align-items-center">
                                                                            <small class="text-muted">
                                                                                <i class="bi bi-building me-1"></i>
                                                                                ${subject.major.majorCode}
                                                                            </small>
                                                                            <c:if test="${hasScore}">
                                                                                <small class="text-muted">
                                                                                    <i class="bi bi-calendar3 me-1"></i>
                                                                                    HK ${latestScore.semester}
                                                                                </small>
                                                                            </c:if>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </c:forEach>
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