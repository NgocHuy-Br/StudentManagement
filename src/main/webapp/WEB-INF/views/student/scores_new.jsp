<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Kết quả học tập</title>
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

                        .filter-section {
                            background: white;
                            border-radius: 12px;
                            padding: 1.5rem;
                            margin-bottom: 1.5rem;
                            box-shadow: 0 10px 25px rgba(0, 0, 0, .06);
                        }

                        .gpa-card {
                            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
                            color: white;
                            border-radius: 12px;
                            padding: 1.5rem;
                            margin-bottom: 1.5rem;
                            text-align: center;
                        }

                        .gpa-number {
                            font-size: 2.5rem;
                            font-weight: 700;
                            margin-bottom: 0.5rem;
                        }

                        .table-scores {
                            background: white;
                            border-radius: 12px;
                            overflow: hidden;
                        }

                        .table-scores th {
                            background: var(--primary-color);
                            color: white;
                            border: none;
                            font-weight: 600;
                            padding: 1rem 0.75rem;
                        }

                        .table-scores td {
                            padding: 1rem 0.75rem;
                            vertical-align: middle;
                            border-bottom: 1px solid #e9ecef;
                        }

                        .table-scores tbody tr:hover {
                            background: #fffaf7;
                        }

                        .score-badge {
                            padding: 0.4rem 0.8rem;
                            border-radius: 20px;
                            font-weight: 600;
                            font-size: 0.85rem;
                            display: inline-block;
                            min-width: 50px;
                            text-align: center;
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

                        .subject-code {
                            font-weight: 600;
                            color: var(--primary-color);
                        }

                        .subject-credits {
                            color: #6c757d;
                            font-size: 0.9rem;
                        }

                        .stats-cards {
                            display: grid;
                            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                            gap: 1rem;
                            margin-bottom: 2rem;
                        }

                        .stat-card {
                            background: white;
                            border-radius: 12px;
                            padding: 1.5rem;
                            text-align: center;
                            box-shadow: 0 10px 25px rgba(0, 0, 0, .06);
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
                            margin: 0 auto 1rem;
                        }

                        .stat-number {
                            font-size: 1.5rem;
                            font-weight: 700;
                            color: var(--primary-color);
                        }

                        .empty-state {
                            text-align: center;
                            padding: 3rem;
                            color: #6c757d;
                        }

                        .empty-state i {
                            font-size: 3rem;
                            margin-bottom: 1rem;
                            color: #dee2e6;
                        }
                    </style>
                </head>

                <body>
                    <div class="container-fluid" style="padding: 0 clamp(12px, 4vw, 36px);">
                        <%@ include file="../common/header.jsp" %>

                            <c:set var="activeTab" value="scores" scope="request" />
                            <%@ include file="_nav.jsp" %>

                                <div class="mt-4">

                                    <!-- GPA Card -->
                                    <div class="gpa-card">
                                        <div class="gpa-number">
                                            <fmt:formatNumber value="${gpa}" maxFractionDigits="2" />
                                        </div>
                                        <h5 class="mb-1">Điểm trung bình tích lũy (GPA)</h5>
                                        <p class="mb-0">
                                            Xếp loại:
                                            <strong>
                                                <c:choose>
                                                    <c:when test="${gpa >= 8.5}">Xuất sắc</c:when>
                                                    <c:when test="${gpa >= 7.0}">Giỏi</c:when>
                                                    <c:when test="${gpa >= 6.5}">Khá</c:when>
                                                    <c:when test="${gpa >= 5.0}">Trung bình</c:when>
                                                    <c:otherwise>Yếu</c:otherwise>
                                                </c:choose>
                                            </strong>
                                        </p>
                                    </div>

                                    <!-- Statistics -->
                                    <div class="stats-cards">
                                        <div class="stat-card">
                                            <div class="stat-icon" style="background: #28a745;">
                                                <i class="bi bi-journal-text"></i>
                                            </div>
                                            <div class="stat-number">${fn:length(scores)}</div>
                                            <div>Môn đã có điểm</div>
                                        </div>
                                        <div class="stat-card">
                                            <div class="stat-icon" style="background: #17a2b8;">
                                                <i class="bi bi-trophy"></i>
                                            </div>
                                            <div class="stat-number">
                                                <c:set var="excellentCount" value="0" />
                                                <c:forEach var="score" items="${scores}">
                                                    <c:if test="${score.finalScore >= 8.5}">
                                                        <c:set var="excellentCount" value="${excellentCount + 1}" />
                                                    </c:if>
                                                </c:forEach>
                                                ${excellentCount}
                                            </div>
                                            <div>Môn xuất sắc</div>
                                        </div>
                                        <div class="stat-card">
                                            <div class="stat-icon" style="background: #ffc107;">
                                                <i class="bi bi-award"></i>
                                            </div>
                                            <div class="stat-number">
                                                <c:set var="goodCount" value="0" />
                                                <c:forEach var="score" items="${scores}">
                                                    <c:if test="${score.finalScore >= 7.0 && score.finalScore < 8.5}">
                                                        <c:set var="goodCount" value="${goodCount + 1}" />
                                                    </c:if>
                                                </c:forEach>
                                                ${goodCount}
                                            </div>
                                            <div>Môn giỏi</div>
                                        </div>
                                        <div class="stat-card">
                                            <div class="stat-icon" style="background: #dc3545;">
                                                <i class="bi bi-exclamation-triangle"></i>
                                            </div>
                                            <div class="stat-number">
                                                <c:set var="poorCount" value="0" />
                                                <c:forEach var="score" items="${scores}">
                                                    <c:if test="${score.finalScore < 5.0}">
                                                        <c:set var="poorCount" value="${poorCount + 1}" />
                                                    </c:if>
                                                </c:forEach>
                                                ${poorCount}
                                            </div>
                                            <div>Môn yếu</div>
                                        </div>
                                    </div>

                                    <!-- Filter Section -->
                                    <div class="filter-section">
                                        <div class="row align-items-center">
                                            <div class="col-md-6">
                                                <h5 class="mb-0"><i class="bi bi-filter me-2"></i>Kết quả học tập</h5>
                                            </div>
                                            <div class="col-md-6">
                                                <form method="get" class="d-flex gap-2">
                                                    <select name="subjectId" class="form-select">
                                                        <option value="">Tất cả môn học</option>
                                                        <c:forEach var="subject" items="${subjects}">
                                                            <option value="${subject.id}" ${param.subjectId==subject.id
                                                                ? 'selected' : '' }>
                                                                ${subject.subjectCode} - ${subject.subjectName}
                                                            </option>
                                                        </c:forEach>
                                                    </select>
                                                    <button type="submit" class="btn btn-primary">
                                                        <i class="bi bi-search"></i>
                                                    </button>
                                                </form>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Scores Table -->
                                    <div class="card">
                                        <c:choose>
                                            <c:when test="${not empty scores}">
                                                <div class="table-responsive">
                                                    <table class="table table-scores mb-0">
                                                        <thead>
                                                            <tr>
                                                                <th>Mã môn</th>
                                                                <th>Tên môn học</th>
                                                                <th class="text-center">Tín chỉ</th>
                                                                <th class="text-center">Điểm CC</th>
                                                                <th class="text-center">Điểm BT</th>
                                                                <th class="text-center">Điểm GK</th>
                                                                <th class="text-center">Điểm CK</th>
                                                                <th class="text-center">Điểm TK</th>
                                                                <th class="text-center">Xếp loại</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <c:forEach var="score" items="${scores}">
                                                                <tr>
                                                                    <td>
                                                                        <span
                                                                            class="subject-code">${score.subject.subjectCode}</span>
                                                                    </td>
                                                                    <td>
                                                                        <div>
                                                                            <strong>${score.subject.subjectName}</strong>
                                                                            <br>
                                                                            <span class="subject-credits">
                                                                                <i class="bi bi-bookmark me-1"></i>
                                                                                ${score.subject.credits} tín chỉ
                                                                            </span>
                                                                        </div>
                                                                    </td>
                                                                    <td class="text-center">
                                                                        <strong>${score.subject.credits}</strong>
                                                                    </td>
                                                                    <td class="text-center">
                                                                        <c:choose>
                                                                            <c:when
                                                                                test="${score.attendanceScore != null}">
                                                                                <fmt:formatNumber
                                                                                    value="${score.attendanceScore}"
                                                                                    maxFractionDigits="1" />
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <span class="text-muted">-</span>
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </td>
                                                                    <td class="text-center">
                                                                        <c:choose>
                                                                            <c:when
                                                                                test="${score.exerciseScore != null}">
                                                                                <fmt:formatNumber
                                                                                    value="${score.exerciseScore}"
                                                                                    maxFractionDigits="1" />
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <span class="text-muted">-</span>
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </td>
                                                                    <td class="text-center">
                                                                        <c:choose>
                                                                            <c:when
                                                                                test="${score.midtermScore != null}">
                                                                                <fmt:formatNumber
                                                                                    value="${score.midtermScore}"
                                                                                    maxFractionDigits="1" />
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <span class="text-muted">-</span>
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </td>
                                                                    <td class="text-center">
                                                                        <c:choose>
                                                                            <c:when
                                                                                test="${score.finalExamScore != null}">
                                                                                <fmt:formatNumber
                                                                                    value="${score.finalExamScore}"
                                                                                    maxFractionDigits="1" />
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <span class="text-muted">-</span>
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </td>
                                                                    <td class="text-center">
                                                                        <c:choose>
                                                                            <c:when test="${score.finalScore != null}">
                                                                                <strong>
                                                                                    <fmt:formatNumber
                                                                                        value="${score.finalScore}"
                                                                                        maxFractionDigits="1" />
                                                                                </strong>
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <span class="text-muted">-</span>
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </td>
                                                                    <td class="text-center">
                                                                        <c:if test="${score.finalScore != null}">
                                                                            <c:choose>
                                                                                <c:when
                                                                                    test="${score.finalScore >= 8.5}">
                                                                                    <span
                                                                                        class="score-badge score-excellent">Xuất
                                                                                        sắc</span>
                                                                                </c:when>
                                                                                <c:when
                                                                                    test="${score.finalScore >= 7.0}">
                                                                                    <span
                                                                                        class="score-badge score-good">Giỏi</span>
                                                                                </c:when>
                                                                                <c:when
                                                                                    test="${score.finalScore >= 6.5}">
                                                                                    <span
                                                                                        class="score-badge score-average">Khá</span>
                                                                                </c:when>
                                                                                <c:when
                                                                                    test="${score.finalScore >= 5.0}">
                                                                                    <span
                                                                                        class="score-badge score-average">Trung
                                                                                        bình</span>
                                                                                </c:when>
                                                                                <c:otherwise>
                                                                                    <span
                                                                                        class="score-badge score-poor">Yếu</span>
                                                                                </c:otherwise>
                                                                            </c:choose>
                                                                        </c:if>
                                                                    </td>
                                                                </tr>
                                                            </c:forEach>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="empty-state">
                                                    <i class="bi bi-clipboard-x"></i>
                                                    <h5>Chưa có kết quả học tập</h5>
                                                    <p class="text-muted">Hiện tại bạn chưa có điểm nào được ghi nhận
                                                        trong hệ thống.</p>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                </div>
                    </div>

                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
                </body>

                </html>