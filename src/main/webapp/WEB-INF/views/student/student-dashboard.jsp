<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1">
                <title>Bảng điều khiển - Sinh viên</title>
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

                    .gpa-card {
                        background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
                    }

                    .major-card {
                        background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
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

                    .score-excellent {
                        color: #28a745;
                    }

                    .score-good {
                        color: #17a2b8;
                    }

                    .score-average {
                        color: #ffc107;
                    }

                    .score-poor {
                        color: #dc3545;
                    }
                </style>
            </head>

            <body>
                <%@ include file="../common/header.jsp" %>
                    <main class="container-fluid main-wrap py-3">
                        <%@ include file="_nav.jsp" %>

                            <!-- Student Info Card -->
                            <div class="card mt-3">
                                <div class="card-body">
                                    <div class="row align-items-center">
                                        <div class="col-md-8">
                                            <h5 class="mb-1">Thông tin sinh viên</h5>
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <p class="mb-1"><strong>MSSV:</strong> ${student.user.username}</p>
                                                    <p class="mb-1"><strong>Họ tên:</strong> ${student.user.fname}
                                                        ${student.user.lname}</p>
                                                    <p class="mb-0"><strong>Email:</strong> ${student.user.email}</p>
                                                </div>
                                                <div class="col-md-6">
                                                    <p class="mb-1"><strong>Lớp:</strong> ${student.className}</p>
                                                    <p class="mb-1"><strong>Ngành:</strong> ${student.major.majorName}
                                                    </p>
                                                    <p class="mb-0"><strong>SĐT:</strong> ${student.user.phone}</p>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-4 text-center">
                                            <i class="bi bi-person-circle display-1 text-primary"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Thống kê -->
                            <div class="row mt-3">
                                <div class="col-md-6 col-lg-3 mb-3">
                                    <div class="card stats-card">
                                        <div class="card-body">
                                            <div class="d-flex justify-content-between align-items-center">
                                                <div>
                                                    <h6 class="text-white-50 mb-1">Điểm TBC tích lũy</h6>
                                                    <h2 class="mb-0">${gpa}</h2>
                                                </div>
                                                <i class="bi bi-trophy fs-1 text-white-50"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6 col-lg-3 mb-3">
                                    <div class="card stats-card gpa-card">
                                        <div class="card-body">
                                            <div class="d-flex justify-content-between align-items-center">
                                                <div>
                                                    <h6 class="text-white-50 mb-1">Ngành học</h6>
                                                    <h5 class="mb-0">${student.major.majorCode}</h5>
                                                </div>
                                                <i class="bi bi-mortarboard fs-1 text-white-50"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6 col-lg-3 mb-3">
                                    <div class="card stats-card major-card">
                                        <div class="card-body">
                                            <div class="d-flex justify-content-between align-items-center">
                                                <div>
                                                    <h6 class="text-white-50 mb-1">Lớp</h6>
                                                    <h5 class="mb-0">${student.className}</h5>
                                                </div>
                                                <i class="bi bi-people fs-1 text-white-50"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Recent Scores -->
                            <div class="row">
                                <div class="col-md-8">
                                    <div class="card">
                                        <div class="card-body">
                                            <h6 class="mb-3"><i class="bi bi-clock-history me-2"></i>Điểm gần nhất</h6>

                                            <c:if test="${empty recentScores}">
                                                <div class="text-center py-4">
                                                    <i class="bi bi-inbox fs-1 text-muted"></i>
                                                    <p class="text-muted mt-2">Chưa có điểm nào.</p>
                                                </div>
                                            </c:if>

                                            <c:if test="${not empty recentScores}">
                                                <div class="table-responsive">
                                                    <table class="table table-sm">
                                                        <thead>
                                                            <tr>
                                                                <th>Môn học</th>
                                                                <th>Điểm</th>
                                                                <th>Ghi chú</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <c:forEach var="score" items="${recentScores}">
                                                                <tr>
                                                                    <td>
                                                                        <strong>${score.subject.subjectCode}</strong>
                                                                        <br><small
                                                                            class="text-muted">${score.subject.subjectName}</small>
                                                                    </td>
                                                                    <td>
                                                                        <c:choose>
                                                                            <c:when test="${score.avgScore == null}">
                                                                                <span class="text-muted">Chưa có</span>
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <c:choose>
                                                                                    <c:when
                                                                                        test="${score.avgScore >= 8.5}">
                                                                                        <span
                                                                                            class="score-excellent fw-bold">${score.avgScore}</span>
                                                                                    </c:when>
                                                                                    <c:when
                                                                                        test="${score.avgScore >= 7.0}">
                                                                                        <span
                                                                                            class="score-good fw-bold">${score.avgScore}</span>
                                                                                    </c:when>
                                                                                    <c:when
                                                                                        test="${score.avgScore >= 5.0}">
                                                                                        <span
                                                                                            class="score-average fw-bold">${score.avgScore}</span>
                                                                                    </c:when>
                                                                                    <c:otherwise>
                                                                                        <span
                                                                                            class="score-poor fw-bold">${score.avgScore}</span>
                                                                                    </c:otherwise>
                                                                                </c:choose>
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </td>
                                                                    <td><small class="text-muted">${score.notes}</small>
                                                                    </td>
                                                                </tr>
                                                            </c:forEach>
                                                        </tbody>
                                                    </table>
                                                </div>
                                                <div class="text-center mt-3">
                                                    <a href="${pageContext.request.contextPath}/student/scores"
                                                        class="btn btn-outline-primary btn-sm">
                                                        <i class="bi bi-eye me-1"></i>Xem tất cả điểm
                                                    </a>
                                                </div>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>

                                <div class="col-md-4">
                                    <div class="card">
                                        <div class="card-body">
                                            <h6 class="mb-3"><i class="bi bi-link-45deg me-2"></i>Liên kết nhanh</h6>
                                            <div class="d-grid gap-2">
                                                <a href="${pageContext.request.contextPath}/student/subjects"
                                                    class="btn btn-outline-primary">
                                                    <i class="bi bi-book me-2"></i>Môn học ngành
                                                </a>
                                                <a href="${pageContext.request.contextPath}/student/scores"
                                                    class="btn btn-outline-success">
                                                    <i class="bi bi-bar-chart me-2"></i>Kết quả học tập
                                                </a>
                                            </div>

                                            <hr class="my-3">

                                            <h6 class="mb-3"><i class="bi bi-info-circle me-2"></i>Hướng dẫn</h6>
                                            <ul class="list-unstyled small text-muted">
                                                <li class="mb-2"><i class="bi bi-dot"></i>Xem điểm các môn học trong
                                                    ngành</li>
                                                <li class="mb-2"><i class="bi bi-dot"></i>Theo dõi GPA tích lũy</li>
                                            </ul>
                                        </div>
                                    </div>
                                </div>
                            </div>
                    </main>

                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
            </body>

            </html>