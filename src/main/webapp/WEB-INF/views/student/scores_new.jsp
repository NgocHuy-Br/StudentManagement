<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Chi tiết điểm</title>
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

                        .table-header-light th {
                            background: #28a745 !important;
                            color: white !important;
                            border: none;
                            font-weight: 600;
                            padding: 1rem 0.75rem;
                        }

                        .score-detail-btn {
                            border-radius: 25px;
                            font-weight: 600;
                            transition: all 0.3s ease;
                            padding: 0.5rem 1rem;
                            border: 2px solid #007bff;
                            background: white;
                            color: #007bff;
                            min-width: 100px;
                        }

                        .score-detail-btn:hover {
                            transform: translateY(-2px);
                            box-shadow: 0 6px 15px rgba(0, 123, 255, 0.3);
                            background: #007bff;
                            color: white;
                            border-color: #007bff;
                        }

                        .row-number {
                            font-weight: 700;
                            color: #495057;
                            background: #f8f9fa;
                            border-radius: 50%;
                            width: 30px;
                            height: 30px;
                            display: inline-flex;
                            align-items: center;
                            justify-content: center;
                            margin: 0 auto;
                        }

                        .subject-code {
                            background: #e9ecef;
                            padding: 0.25rem 0.5rem;
                            border-radius: 0.375rem;
                            font-weight: 600;
                            color: #495057;
                        }

                        .table-scores td {
                            padding: 1.2rem 0.75rem;
                            vertical-align: middle;
                            border-bottom: 1px solid #dee2e6;
                        }

                        .table-scores tbody tr:hover {
                            background: linear-gradient(135deg, #f8f9ff 0%, #fff5f5 100%);
                            transform: translateY(-1px);
                            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                            transition: all 0.2s ease;
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

                        .academic-summary-row {
                            margin-bottom: 2rem;
                        }

                        .summary-card {
                            background: white;
                            border-radius: 12px;
                            padding: 1.5rem;
                            box-shadow: 0 10px 25px rgba(0, 0, 0, .06);
                            border: none;
                            height: 100%;
                            display: flex;
                            align-items: center;
                            gap: 1rem;
                        }

                        .summary-icon {
                            width: 60px;
                            height: 60px;
                            border-radius: 12px;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            font-size: 24px;
                            color: white;
                            flex-shrink: 0;
                        }

                        .summary-content {
                            flex: 1;
                        }

                        .summary-number {
                            font-size: 1.8rem;
                            font-weight: 700;
                            color: #333;
                            margin-bottom: 0.25rem;
                        }

                        .summary-label {
                            color: #6c757d;
                            font-size: 0.9rem;
                            font-weight: 500;
                            line-height: 1.3;
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

                                    <!-- Academic Summary Row -->
                                    <div class="academic-summary-row">
                                        <div class="row">
                                            <div class="col-md-3 mb-3">
                                                <div class="summary-card">
                                                    <div class="summary-icon" style="background: #17a2b8;">
                                                        <i class="bi bi-bookmark-check-fill"></i>
                                                    </div>
                                                    <div class="summary-content">
                                                        <div class="summary-number">${totalCredits}</div>
                                                        <div class="summary-label">Số tín chỉ tích lũy</div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-md-3 mb-3">
                                                <div class="summary-card">
                                                    <div class="summary-icon" style="background: #28a745;">
                                                        <i class="bi bi-calculator"></i>
                                                    </div>
                                                    <div class="summary-content">
                                                        <div class="summary-number">
                                                            <fmt:formatNumber value="${gpa}" minFractionDigits="1"
                                                                maxFractionDigits="1" />
                                                        </div>
                                                        <div class="summary-label">Điểm trung bình tích lũy</div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-md-3 mb-3">
                                                <div class="summary-card">
                                                    <div class="summary-icon" style="background: #ffc107;">
                                                        <i class="bi bi-award"></i>
                                                    </div>
                                                    <div class="summary-content">
                                                        <div class="summary-number">
                                                            <c:choose>
                                                                <c:when test="${gpa >= 8.5}">Xuất sắc</c:when>
                                                                <c:when test="${gpa >= 7.0}">Giỏi</c:when>
                                                                <c:when test="${gpa >= 6.5}">Khá</c:when>
                                                                <c:when test="${gpa >= 5.0}">Trung bình</c:when>
                                                                <c:otherwise>Yếu</c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                        <div class="summary-label">Xếp loại theo điểm TB tích lũy</div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-md-3 mb-3">
                                                <div class="summary-card">
                                                    <div class="summary-icon" style="background: #dc3545;">
                                                        <i class="bi bi-exclamation-triangle"></i>
                                                    </div>
                                                    <div class="summary-content">
                                                        <div class="summary-number">${failedCredits}</div>
                                                        <div class="summary-label">Số tín chỉ chưa đạt</div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Filter Section -->
                                    <div class="filter-section">
                                        <div class="row align-items-center">
                                            <div class="col-md-6">
                                                <h5 class="mb-0"><i class="bi bi-list-task me-2"></i>Chi tiết điểm</h5>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="filter-dropdown">
                                                    <div class="input-group">
                                                        <span class="input-group-text bg-white">
                                                            <i class="bi bi-funnel text-primary"></i>
                                                        </span>
                                                        <select name="subjectId" class="form-select" id="subjectFilter"
                                                            onchange="filterSubjects()">
                                                            <option value="">Tất cả môn học</option>
                                                            <c:forEach var="subject" items="${subjects}">
                                                                <option value="${subject.id}"
                                                                    ${param.subjectId==subject.id ? 'selected' : '' }>
                                                                    ${subject.subjectCode} - ${subject.subjectName}
                                                                </option>
                                                            </c:forEach>
                                                        </select>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Scores Table -->
                                    <div class="card">
                                        <c:choose>
                                            <c:when test="${not empty scores}">
                                                <div class="table-responsive">
                                                    <table class="table table-scores mb-0">
                                                        <thead class="table-header-light">
                                                            <tr>
                                                                <th class="text-center" style="width: 5%;">TT</th>
                                                                <th style="width: 40%;">Tên môn</th>
                                                                <th class="text-center" style="width: 12%;">Mã môn</th>
                                                                <th class="text-center" style="width: 10%;">Số tín chỉ
                                                                </th>
                                                                <th class="text-center" style="width: 18%;">Điểm trung
                                                                    bình</th>
                                                                <th class="text-center" style="width: 15%;">Kết quả</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <c:forEach var="score" items="${scores}" varStatus="status">
                                                                <tr>
                                                                    <td class="text-center">
                                                                        <span class="row-number">${status.index +
                                                                            1}</span>
                                                                    </td>
                                                                    <td>
                                                                        <strong>${score.subject.subjectName}</strong>
                                                                    </td>
                                                                    <td class="text-center">
                                                                        <span
                                                                            class="subject-code">${score.subject.subjectCode}</span>
                                                                    </td>
                                                                    <td class="text-center">
                                                                        <strong>${score.subject.credit}</strong>
                                                                    </td>
                                                                    <td class="text-center">
                                                                        <c:choose>
                                                                            <c:when test="${score.avgScore != null}">
                                                                                <button
                                                                                    class="btn btn-sm btn-outline-primary score-detail-btn"
                                                                                    data-subject-name="${score.subject.subjectName}"
                                                                                    data-subject-code="${score.subject.subjectCode}"
                                                                                    data-attendance="${score.attendanceScore}"
                                                                                    data-midterm="${score.midtermScore}"
                                                                                    data-finalexam="${score.finalScore}"
                                                                                    data-avg="${score.avgScore}"
                                                                                    data-result="${score.avgScore >= 5.0 ? 'Đạt' : 'Không đạt'}"
                                                                                    onclick="showScoreDetail(this)">
                                                                                    <fmt:formatNumber
                                                                                        value="${score.avgScore}"
                                                                                        minFractionDigits="1"
                                                                                        maxFractionDigits="1" />
                                                                                    <i
                                                                                        class="bi bi-info-circle ms-1"></i>
                                                                                </button>
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <span class="text-muted">Chưa có
                                                                                    điểm</span>
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </td>
                                                                    <td class="text-center">
                                                                        <c:choose>
                                                                            <c:when test="${score.avgScore != null}">
                                                                                <c:choose>
                                                                                    <c:when
                                                                                        test="${score.avgScore >= 5.0}">
                                                                                        <span
                                                                                            class="badge bg-success">Đạt</span>
                                                                                    </c:when>
                                                                                    <c:otherwise>
                                                                                        <span
                                                                                            class="badge bg-danger">Không
                                                                                            đạt</span>
                                                                                    </c:otherwise>
                                                                                </c:choose>
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <span class="badge bg-secondary">Chưa có
                                                                                    kết quả</span>
                                                                            </c:otherwise>
                                                                        </c:choose>
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

                    <!-- Score Detail Modal -->
                    <div class="modal fade" id="scoreDetailModal" tabindex="-1" aria-labelledby="scoreDetailModalLabel"
                        aria-hidden="true">
                        <div class="modal-dialog modal-lg">
                            <div class="modal-content">
                                <div class="modal-header bg-primary text-white">
                                    <h5 class="modal-title" id="scoreDetailModalLabel">
                                        <i class="bi bi-clipboard-data me-2"></i>Chi tiết điểm số
                                    </h5>
                                    <button type="button" class="btn-close btn-close-white"
                                        data-bs-dismiss="modal"></button>
                                </div>
                                <div class="modal-body">
                                    <div class="mb-3">
                                        <h6 class="text-primary">Thông tin môn học</h6>
                                        <div class="row">
                                            <div class="col-md-6">
                                                <strong>Tên môn:</strong> <span id="modalSubjectName"></span>
                                            </div>
                                            <div class="col-md-6">
                                                <strong>Mã môn:</strong> <span id="modalSubjectCode"></span>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="mb-3">
                                        <h6 class="text-primary">Điểm thành phần</h6>
                                        <div class="table-responsive">
                                            <table class="table table-sm table-bordered">
                                                <thead class="table-light">
                                                    <tr>
                                                        <th>Loại điểm</th>
                                                        <th class="text-center">Điểm số</th>
                                                        <th class="text-center">Trọng số</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <tr>
                                                        <td><i class="bi bi-person-check me-2 text-info"></i>Chuyên cần
                                                        </td>
                                                        <td class="text-center" id="modalAttendance">-</td>
                                                        <td class="text-center">10%</td>
                                                    </tr>
                                                    <tr>
                                                        <td><i class="bi bi-clock me-2 text-primary"></i>Giữa kỳ</td>
                                                        <td class="text-center" id="modalMidterm">-</td>
                                                        <td class="text-center">30%</td>
                                                    </tr>
                                                    <tr>
                                                        <td><i class="bi bi-journal-text me-2 text-danger"></i>Cuối kỳ
                                                        </td>
                                                        <td class="text-center" id="modalFinalExam">-</td>
                                                        <td class="text-center">60%</td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="card bg-light">
                                                <div class="card-body text-center">
                                                    <h5 class="text-primary mb-1">Điểm trung bình</h5>
                                                    <h3 class="text-dark mb-0" id="modalAvgScore">-</h3>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="card bg-light">
                                                <div class="card-body text-center">
                                                    <h5 class="text-primary mb-1">Kết quả</h5>
                                                    <h4 class="mb-0" id="modalResult">-</h4>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <script>
                        function filterSubjects() {
                            const select = document.getElementById('subjectFilter');
                            const subjectId = select.value;

                            // Tạo URL với tham số filter
                            const url = new URL(window.location);
                            if (subjectId) {
                                url.searchParams.set('subjectId', subjectId);
                            } else {
                                url.searchParams.delete('subjectId');
                            }

                            // Chuyển hướng với URL mới
                            window.location.href = url.toString();
                        }

                        function showScoreDetail(button) {
                            const subjectName = button.dataset.subjectName;
                            const subjectCode = button.dataset.subjectCode;
                            const attendance = button.dataset.attendance;
                            const midterm = button.dataset.midterm;
                            const finalexam = button.dataset.finalexam;
                            const avg = button.dataset.avg;
                            const result = button.dataset.result;

                            // Cập nhật thông tin trong modal
                            document.getElementById('modalSubjectName').textContent = subjectName;
                            document.getElementById('modalSubjectCode').textContent = subjectCode;
                            document.getElementById('modalAttendance').textContent = attendance !== 'null' && attendance !== 'undefined' && attendance !== '' ? parseFloat(attendance).toFixed(1) : '-';
                            document.getElementById('modalMidterm').textContent = midterm !== 'null' && midterm !== 'undefined' && midterm !== '' ? parseFloat(midterm).toFixed(1) : '-';
                            document.getElementById('modalFinalExam').textContent = finalexam !== 'null' && finalexam !== 'undefined' && finalexam !== '' ? parseFloat(finalexam).toFixed(1) : '-';
                            document.getElementById('modalAvgScore').textContent = avg !== 'null' && avg !== 'undefined' && avg !== '' ? parseFloat(avg).toFixed(1) : '-';

                            const resultElement = document.getElementById('modalResult');
                            if (result === 'Đạt') {
                                resultElement.innerHTML = '<span class="badge bg-success fs-6">Đạt</span>';
                            } else {
                                resultElement.innerHTML = '<span class="badge bg-danger fs-6">Không đạt</span>';
                            }

                            // Hiển thị modal
                            const modal = new bootstrap.Modal(document.getElementById('scoreDetailModal'));
                            modal.show();
                        }
                    </script>
                </body>

                </html>