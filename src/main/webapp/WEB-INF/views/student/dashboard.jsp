<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Tổng quan sinh viên</title>
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
                        rel="stylesheet">
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
                        rel="stylesheet">
                    <style>
                        :root {
                            --primary-color: #dc3545;
                            --primary-light: #f8d7da;
                        }

                        body {
                            background: #f7f7f9;
                            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                            /* Ensure consistent scrollbar with other pages */
                            overflow-x: hidden !important;
                            overflow-y: scroll !important;
                            min-height: 100vh !important;
                        }

                        .card {
                            border-radius: 12px;
                            box-shadow: 0 10px 25px rgba(0, 0, 0, .06);
                            border: none;
                        }

                        .dashboard-card {
                            transition: all 0.3s ease;
                            height: 100%;
                        }

                        .dashboard-card:hover {
                            transform: translateY(-5px);
                            box-shadow: 0 20px 40px rgba(0, 0, 0, .12);
                        }

                        .stat-icon {
                            width: 50px;
                            height: 50px;
                            border-radius: 50%;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            font-size: 24px;
                            color: white;
                        }

                        .stat-number {
                            font-size: 2rem;
                            font-weight: 700;
                            color: var(--primary-color);
                        }

                        .quick-action-btn {
                            padding: 0.75rem 1.5rem;
                            border-radius: 8px;
                            border: none;
                            font-weight: 500;
                            text-decoration: none;
                            transition: all 0.3s ease;
                            display: inline-flex;
                            align-items: center;
                            gap: 0.5rem;
                        }

                        .quick-action-btn:hover {
                            transform: translateY(-2px);
                            box-shadow: 0 10px 25px rgba(0, 0, 0, .15);
                            text-decoration: none;
                        }

                        .btn-primary-custom {
                            background: var(--primary-color);
                            color: white;
                        }

                        .btn-success-custom {
                            background: #28a745;
                            color: white;
                        }

                        .btn-info-custom {
                            background: #17a2b8;
                            color: white;
                        }

                        .welcome-section {
                            background: linear-gradient(135deg, var(--primary-color) 0%, #991b1b 100%);
                            color: white;
                            border-radius: 12px;
                            padding: 2rem;
                            margin-bottom: 2rem;
                        }

                        .student-info {
                            background: white;
                            border-radius: 12px;
                            padding: 1.5rem;
                            margin-bottom: 2rem;
                        }

                        .info-row {
                            display: flex;
                            justify-content: space-between;
                            align-items: center;
                            padding: 0.75rem 0;
                            border-bottom: 1px solid #e9ecef;
                        }

                        .info-row:last-child {
                            border-bottom: none;
                        }

                        .info-label {
                            font-weight: 600;
                            color: #6c757d;
                        }

                        .info-value {
                            color: #212529;
                            font-weight: 500;
                        }

                        .recent-scores {
                            background: white;
                            border-radius: 12px;
                            padding: 1.5rem;
                            margin-bottom: 2rem;
                        }

                        .score-item {
                            display: flex;
                            justify-content: space-between;
                            align-items: center;
                            padding: 0.75rem 0;
                            border-bottom: 1px solid #e9ecef;
                        }

                        .score-item:last-child {
                            border-bottom: none;
                        }

                        .score-badge {
                            padding: 0.25rem 0.75rem;
                            border-radius: 20px;
                            font-weight: 600;
                            font-size: 0.85rem;
                        }

                        .score-excellent {
                            background: #d4edda;
                            color: #155724;
                        }

                        .score-good {
                            background: #cce7ff;
                            color: #004085;
                        }

                        .score-average {
                            background: #fff3cd;
                            color: #856404;
                        }

                        .score-poor {
                            background: #f8d7da;
                            color: #721c24;
                        }
                    </style>
                </head>

                <body>
                    <div class="container-fluid" style="padding: 0 clamp(12px, 4vw, 36px);">
                        <%@ include file="../common/header.jsp" %>

                            <c:set var="activeTab" value="dashboard" scope="request" />
                            <%@ include file="_nav.jsp" %>

                                <div class="mt-4">

                                    <!-- Welcome Section -->
                                    <div class="welcome-section">
                                        <h2><i class="bi bi-speedometer2 me-2"></i>Tổng quan học tập</h2>
                                        <p class="mb-0">Chào mừng bạn đến với hệ thống quản lý học tập</p>
                                    </div>

                                    <!-- Student Information -->
                                    <div class="student-info">
                                        <h5 class="mb-3"><i class="bi bi-person-badge me-2"></i>Thông tin sinh viên</h5>
                                        <c:if test="${not empty student}">
                                            <div class="info-row">
                                                <span class="info-label">Họ và tên:</span>
                                                <span class="info-value">${student.user.fname}
                                                    ${student.user.lname}</span>
                                            </div>
                                            <div class="info-row">
                                                <span class="info-label">Mã sinh viên:</span>
                                                <span class="info-value">${student.user.username}</span>
                                            </div>
                                            <div class="info-row">
                                                <span class="info-label">Ngành học:</span>
                                                <span class="info-value">${student.major.majorName}</span>
                                            </div>
                                            <div class="info-row">
                                                <span class="info-label">Lớp:</span>
                                                <span class="info-value">${student.classroom.classCode}</span>
                                            </div>
                                            <div class="info-row">
                                                <span class="info-label">Email:</span>
                                                <span class="info-value">${student.user.email}</span>
                                            </div>
                                            <div class="info-row">
                                                <span class="info-label">Số điện thoại:</span>
                                                <span class="info-value">${student.user.phone}</span>
                                            </div>
                                        </c:if>
                                    </div>

                                    <!-- Statistics Cards -->
                                    <div class="row mb-4">
                                        <div class="col-md-4 mb-3">
                                            <div class="card dashboard-card">
                                                <div class="card-body text-center">
                                                    <div class="stat-icon mx-auto mb-3" style="background: #28a745;">
                                                        <i class="bi bi-trophy-fill"></i>
                                                    </div>
                                                    <div class="stat-number">
                                                        <fmt:formatNumber value="${gpa}" maxFractionDigits="2" />
                                                    </div>
                                                    <h6 class="card-title mb-0">GPA</h6>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-4 mb-3">
                                            <div class="card dashboard-card">
                                                <div class="card-body text-center">
                                                    <div class="stat-icon mx-auto mb-3" style="background: #17a2b8;">
                                                        <i class="bi bi-journal-text"></i>
                                                    </div>
                                                    <div class="stat-number">${fn:length(recentScores)}</div>
                                                    <h6 class="card-title mb-0">Môn đã có điểm</h6>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-4 mb-3">
                                            <div class="card dashboard-card">
                                                <div class="card-body text-center">
                                                    <div class="stat-icon mx-auto mb-3" style="background: #ffc107;">
                                                        <i class="bi bi-calendar-check"></i>
                                                    </div>
                                                    <div class="stat-number">
                                                        <c:choose>
                                                            <c:when test="${gpa >= 8.5}">Xuất sắc</c:when>
                                                            <c:when test="${gpa >= 7.0}">Giỏi</c:when>
                                                            <c:when test="${gpa >= 6.5}">Khá</c:when>
                                                            <c:when test="${gpa >= 5.0}">Trung bình</c:when>
                                                            <c:otherwise>Yếu</c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                    <h6 class="card-title mb-0">Xếp loại học lực</h6>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Recent Scores -->
                                    <div class="recent-scores">
                                        <h5 class="mb-3"><i class="bi bi-bar-chart me-2"></i>Điểm gần đây</h5>
                                        <c:choose>
                                            <c:when test="${not empty recentScores}">
                                                <c:forEach var="score" items="${recentScores}" varStatus="status">
                                                    <c:if test="${status.index < 5}">
                                                        <div class="score-item">
                                                            <div>
                                                                <strong>${score.subject.subjectName}</strong>
                                                                <br>
                                                                <small
                                                                    class="text-muted">${score.subject.subjectCode}</small>
                                                            </div>
                                                            <div>
                                                                <c:choose>
                                                                    <c:when test="${score.finalScore >= 8.5}">
                                                                        <span class="score-badge score-excellent">
                                                                            <fmt:formatNumber
                                                                                value="${score.finalScore}"
                                                                                maxFractionDigits="1" />
                                                                        </span>
                                                                    </c:when>
                                                                    <c:when test="${score.finalScore >= 7.0}">
                                                                        <span class="score-badge score-good">
                                                                            <fmt:formatNumber
                                                                                value="${score.finalScore}"
                                                                                maxFractionDigits="1" />
                                                                        </span>
                                                                    </c:when>
                                                                    <c:when test="${score.finalScore >= 5.0}">
                                                                        <span class="score-badge score-average">
                                                                            <fmt:formatNumber
                                                                                value="${score.finalScore}"
                                                                                maxFractionDigits="1" />
                                                                        </span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="score-badge score-poor">
                                                                            <fmt:formatNumber
                                                                                value="${score.finalScore}"
                                                                                maxFractionDigits="1" />
                                                                        </span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </div>
                                                        </div>
                                                    </c:if>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="text-center text-muted py-4">
                                                    <i class="bi bi-info-circle me-2"></i>
                                                    Chưa có điểm nào được ghi nhận
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                    <!-- Quick Actions -->
                                    <div class="card">
                                        <div class="card-header">
                                            <h5 class="mb-0"><i class="bi bi-lightning me-2"></i>Thao tác nhanh</h5>
                                        </div>
                                        <div class="card-body">
                                            <div class="row">
                                                <div class="col-md-4 mb-3">
                                                    <a href="/student/scores"
                                                        class="quick-action-btn btn-primary-custom w-100">
                                                        <i class="bi bi-bar-chart"></i>Xem kết quả học tập
                                                    </a>
                                                </div>
                                                <div class="col-md-4 mb-3">
                                                    <a href="/student/subjects"
                                                        class="quick-action-btn btn-info-custom w-100">
                                                        <i class="bi bi-book"></i>Xem môn học ngành
                                                    </a>
                                                </div>
                                                <div class="col-md-4 mb-3">
                                                    <a href="/auth/logout" class="quick-action-btn btn-secondary w-100">
                                                        <i class="bi bi-box-arrow-right"></i>Đăng xuất
                                                    </a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                </div>
                    </div>

                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
                </body>

                </html>