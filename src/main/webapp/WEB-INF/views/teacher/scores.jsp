<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Quản lý điểm sinh viên</title>
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

                        .score-input {
                            width: 80px;
                        }

                        .student-avatar {
                            width: 32px;
                            height: 32px;
                            border-radius: 50%;
                            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            color: white;
                            font-weight: 600;
                            font-size: 12px;
                        }

                        .avg-score {
                            font-weight: 700;
                            font-size: 1.1rem;
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

                        .quick-stats {
                            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                            color: white;
                            border-radius: 12px;
                            padding: 1rem;
                            margin-bottom: 1.5rem;
                        }

                        .stat-item {
                            text-align: center;
                        }

                        .stat-number {
                            font-size: 2rem;
                            font-weight: 700;
                            display: block;
                        }

                        .stat-label {
                            font-size: 0.875rem;
                            opacity: 0.9;
                        }
                    </style>
                </head>

                <body>
                    <%@include file="../common/header.jsp" %>

                        <div class="container-fluid my-4">
                            <c:set var="activeTab" value="scores" />
                            <%@include file="_nav.jsp" %>

                                <!-- Flash Messages -->
                                <c:if test="${not empty success}">
                                    <div class="alert alert-success alert-dismissible fade show">
                                        <i class="bi bi-check-circle me-2"></i>${success}
                                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                    </div>
                                </c:if>
                                <c:if test="${not empty error}">
                                    <div class="alert alert-danger alert-dismissible fade show">
                                        <i class="bi bi-exclamation-triangle me-2"></i>${error}
                                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                    </div>
                                </c:if>

                                <!-- Filter Section -->
                                <div class="filter-section">
                                    <form method="GET" action="/teacher/scores" class="row g-3">
                                        <div class="col-md-3">
                                            <label for="classroomSelect" class="form-label fw-semibold">
                                                <i class="bi bi-building"></i> Chọn lớp học
                                            </label>
                                            <select class="form-select" id="classroomSelect" name="classroomId"
                                                onchange="this.form.submit()">
                                                <option value="">-- Chọn lớp --</option>
                                                <c:forEach items="${assignedClasses}" var="classroom">
                                                    <option value="${classroom.id}" ${selectedClassroomId==classroom.id
                                                        ? 'selected' : '' }>
                                                        ${classroom.classCode}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>

                                        <div class="col-md-3">
                                            <label for="subjectSelect" class="form-label fw-semibold">
                                                <i class="bi bi-book"></i> Chọn môn học
                                            </label>
                                            <select class="form-select" id="subjectSelect" name="subjectId"
                                                onchange="this.form.submit()">
                                                <option value="">-- Chọn môn --</option>
                                                <c:forEach items="${subjects}" var="subject">
                                                    <option value="${subject.id}" ${selectedSubjectId==subject.id
                                                        ? 'selected' : '' }>
                                                        ${subject.subjectCode} - ${subject.subjectName}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>

                                        <div class="col-md-4">
                                            <label class="form-label fw-semibold text-transparent">.</label>
                                            <div>
                                                <button type="submit" class="btn btn-primary">
                                                    <i class="bi bi-search"></i> Lọc kết quả
                                                </button>
                                                <button type="button" class="btn btn-outline-secondary"
                                                    onclick="clearFilters()">
                                                    <i class="bi bi-arrow-clockwise"></i> Đặt lại
                                                </button>
                                            </div>
                                        </div>
                                    </form>
                                </div>

                                <c:if
                                    test="${not empty students and not empty selectedClassroomId and not empty selectedSubjectId}">
                                    <!-- Quick Stats -->
                                    <div class="quick-stats">
                                        <div class="row">
                                            <div class="col-md-3">
                                                <div class="stat-item">
                                                    <span class="stat-number">${fn:length(students)}</span>
                                                    <span class="stat-label">Tổng sinh viên</span>
                                                </div>
                                            </div>
                                            <div class="col-md-3">
                                                <div class="stat-item">
                                                    <span class="stat-number">${fn:length(scores)}</span>
                                                    <span class="stat-label">Đã có điểm</span>
                                                </div>
                                            </div>
                                            <div class="col-md-3">
                                                <div class="stat-item">
                                                    <span class="stat-number">${fn:length(students) -
                                                        fn:length(scores)}</span>
                                                    <span class="stat-label">Chưa có điểm</span>
                                                </div>
                                            </div>
                                            <div class="col-md-3">
                                                <div class="stat-item">
                                                    <span class="stat-number">
                                                        <c:if test="${fn:length(students) > 0}">
                                                            <fmt:formatNumber
                                                                value="${(fn:length(scores) * 100) / fn:length(students)}"
                                                                maxFractionDigits="1" />%
                                                        </c:if>
                                                        <c:if test="${fn:length(students) == 0}">0%</c:if>
                                                    </span>
                                                    <span class="stat-label">Tiến độ</span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Scores Management Table -->
                                    <div class="card">
                                        <div class="card-header d-flex justify-content-between align-items-center">
                                            <h5 class="card-title mb-0">
                                                <i class="bi bi-journal-text"></i> Quản lý điểm sinh viên
                                            </h5>
                                            <button type="button" class="btn btn-success" data-bs-toggle="modal"
                                                data-bs-target="#addScoreModal">
                                                <i class="bi bi-plus-circle"></i> Thêm điểm mới
                                            </button>
                                        </div>
                                        <div class="card-body p-0">
                                            <div class="table-responsive">
                                                <table class="table table-hover mb-0">
                                                    <thead class="bg-light">
                                                        <tr>
                                                            <th style="width: 50px;">TT</th>
                                                            <th style="width: 100px;">MSSV</th>
                                                            <th>Sinh viên</th>
                                                            <th style="width: 100px;">Điểm chuyên cần</th>
                                                            <th style="width: 100px;">Điểm giữa kỳ</th>
                                                            <th style="width: 100px;">Điểm cuối kỳ</th>
                                                            <th style="width: 100px;">Điểm TB</th>
                                                            <th style="width: 120px;">Kết quả</th>
                                                            <th>Ghi chú</th>
                                                            <th style="width: 120px;">Thao tác</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:forEach items="${students}" var="student" varStatus="status">
                                                            <c:set var="studentScore" value="${null}" />
                                                            <c:forEach items="${scores}" var="score">
                                                                <c:if test="${score.student.id == student.id}">
                                                                    <c:set var="studentScore" value="${score}" />
                                                                </c:if>
                                                            </c:forEach>

                                                            <tr>
                                                                <td>${status.index + 1}</td>
                                                                <td>
                                                                    <span
                                                                        class="fw-semibold text-primary">${student.user.username}</span>
                                                                </td>
                                                                <td>
                                                                    <div class="d-flex align-items-center">
                                                                        <div class="student-avatar me-2">
                                                                            ${fn:substring(student.user.fname, 0,
                                                                            1)}${fn:substring(student.user.lname, 0, 1)}
                                                                        </div>
                                                                        <div>
                                                                            <div class="fw-semibold">
                                                                                ${student.user.fname}
                                                                                ${student.user.lname}</div>
                                                                            <small
                                                                                class="text-muted">${student.user.email}</small>
                                                                        </div>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <c:choose>
                                                                        <c:when
                                                                            test="${studentScore != null and studentScore.attendanceScore != null}">
                                                                            <span
                                                                                class="fw-semibold">${studentScore.attendanceScore}</span>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span class="text-muted">--</span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                                <td>
                                                                    <c:choose>
                                                                        <c:when
                                                                            test="${studentScore != null and studentScore.midtermScore != null}">
                                                                            <span
                                                                                class="fw-semibold">${studentScore.midtermScore}</span>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span class="text-muted">--</span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                                <td>
                                                                    <c:choose>
                                                                        <c:when
                                                                            test="${studentScore != null and studentScore.finalScore != null}">
                                                                            <span
                                                                                class="fw-semibold">${studentScore.finalScore}</span>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span class="text-muted">--</span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                                <td>
                                                                    <c:choose>
                                                                        <c:when
                                                                            test="${studentScore != null and studentScore.avgScore != null}">
                                                                            <c:choose>
                                                                                <c:when
                                                                                    test="${studentScore.avgScore >= 8.5}">
                                                                                    <span
                                                                                        class="avg-score score-excellent">
                                                                                        <fmt:formatNumber
                                                                                            value="${studentScore.avgScore}"
                                                                                            maxFractionDigits="1" />
                                                                                    </span>
                                                                                </c:when>
                                                                                <c:when
                                                                                    test="${studentScore.avgScore >= 7.0}">
                                                                                    <span class="avg-score score-good">
                                                                                        <fmt:formatNumber
                                                                                            value="${studentScore.avgScore}"
                                                                                            maxFractionDigits="1" />
                                                                                    </span>
                                                                                </c:when>
                                                                                <c:when
                                                                                    test="${studentScore.avgScore >= 5.5}">
                                                                                    <span
                                                                                        class="avg-score score-average">
                                                                                        <fmt:formatNumber
                                                                                            value="${studentScore.avgScore}"
                                                                                            maxFractionDigits="1" />
                                                                                    </span>
                                                                                </c:when>
                                                                                <c:otherwise>
                                                                                    <span class="avg-score score-poor">
                                                                                        <fmt:formatNumber
                                                                                            value="${studentScore.avgScore}"
                                                                                            maxFractionDigits="1" />
                                                                                    </span>
                                                                                </c:otherwise>
                                                                            </c:choose>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span class="text-muted">--</span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                                <td>
                                                                    <c:choose>
                                                                        <c:when
                                                                            test="${studentScore != null and studentScore.avgScore != null}">
                                                                            <c:choose>
                                                                                <c:when
                                                                                    test="${studentScore.avgScore >= 5.0}">
                                                                                    <span class="badge bg-success fs-6">
                                                                                        <i
                                                                                            class="bi bi-check-circle"></i>
                                                                                        Đạt
                                                                                    </span>
                                                                                </c:when>
                                                                                <c:otherwise>
                                                                                    <span class="badge bg-danger fs-6">
                                                                                        <i class="bi bi-x-circle"></i>
                                                                                        Không đạt
                                                                                    </span>
                                                                                </c:otherwise>
                                                                            </c:choose>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span class="badge bg-secondary">Chưa đánh
                                                                                giá</span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                                <td>
                                                                    <c:choose>
                                                                        <c:when
                                                                            test="${studentScore != null and not empty studentScore.notes}">
                                                                            <small>${studentScore.notes}</small>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span class="text-muted">--</span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                                <td>
                                                                    <c:choose>
                                                                        <c:when test="${studentScore != null}">
                                                                            <button type="button"
                                                                                class="btn btn-outline-primary btn-sm me-1 edit-score-btn"
                                                                                data-score-id="${studentScore.id}"
                                                                                data-student-id="${student.id}"
                                                                                data-student-name="${student.user.fname} ${student.user.lname}"
                                                                                data-attendance-score="${studentScore.attendanceScore}"
                                                                                data-midterm-score="${studentScore.midtermScore}"
                                                                                data-final-score="${studentScore.finalScore}"
                                                                                data-notes="${studentScore.notes}"
                                                                                title="Chỉnh sửa điểm">
                                                                                <i class="bi bi-pencil-square"></i>
                                                                            </button>
                                                                            <button type="button"
                                                                                class="btn btn-outline-danger btn-sm delete-score-btn"
                                                                                data-score-id="${studentScore.id}"
                                                                                data-student-name="${student.user.fname} ${student.user.lname}"
                                                                                title="Xóa điểm">
                                                                                <i class="bi bi-trash"></i>
                                                                            </button>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <button type="button"
                                                                                class="btn btn-outline-success btn-sm add-score-btn"
                                                                                data-student-id="${student.id}"
                                                                                data-student-name="${student.user.fname} ${student.user.lname}"
                                                                                title="Nhập điểm mới">
                                                                                <i class="bi bi-plus-square"></i>
                                                                            </button>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                            </tr>
                                                        </c:forEach>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>
                                    </div>
                                </c:if>

                                <c:if test="${empty selectedClassroomId or empty selectedSubjectId}">
                                    <div class="text-center py-5">
                                        <i class="bi bi-journal-text text-muted" style="font-size: 4rem;"></i>
                                        <h4 class="text-muted mt-3">Chọn điều kiện để quản lý điểm</h4>
                                        <p class="text-muted">Vui lòng chọn lớp học và môn học để bắt đầu quản
                                            lý điểm sinh viên.</p>
                                    </div>
                                </c:if>
                        </div>

                        <!-- Add/Edit Score Modal -->
                        <div class="modal fade" id="scoreModal" tabindex="-1">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="scoreModalTitle">Nhập điểm sinh viên</h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                    </div>
                                    <form id="scoreForm" method="POST" action="/teacher/scores/update">
                                        <div class="modal-body">
                                            <input type="hidden" name="studentId" id="studentId">
                                            <input type="hidden" name="subjectId" value="${selectedSubjectId}">

                                            <div class="mb-3">
                                                <label class="form-label fw-semibold">Sinh viên</label>
                                                <div id="studentInfo"
                                                    class="form-control-plaintext fw-semibold text-primary"></div>
                                            </div>

                                            <div class="row">
                                                <div class="col-md-4">
                                                    <div class="mb-3">
                                                        <label for="attendanceScore" class="form-label">Điểm chuyên cần
                                                            (10%)</label>
                                                        <input type="number" class="form-control" id="attendanceScore"
                                                            name="attendanceScore" min="0" max="10" step="0.1"
                                                            placeholder="0.0">
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="mb-3">
                                                        <label for="midtermScore" class="form-label">Điểm giữa kỳ
                                                            (30%)</label>
                                                        <input type="number" class="form-control" id="midtermScore"
                                                            name="midtermScore" min="0" max="10" step="0.1"
                                                            placeholder="0.0">
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="mb-3">
                                                        <label for="finalScore" class="form-label">Điểm cuối kỳ
                                                            (60%)</label>
                                                        <input type="number" class="form-control" id="finalScore"
                                                            name="finalScore" min="0" max="10" step="0.1"
                                                            placeholder="0.0">
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="mb-3">
                                                <label for="notes" class="form-label">Ghi chú</label>
                                                <textarea class="form-control" id="notes" name="notes" rows="3"
                                                    placeholder="Ghi chú về quá trình học tập..."></textarea>
                                            </div>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-secondary"
                                                data-bs-dismiss="modal">Hủy</button>
                                            <button type="submit" class="btn btn-primary">Lưu điểm</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>

                        <!-- Delete Confirmation Modal -->
                        <div class="modal fade" id="deleteModal" tabindex="-1">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title">Xác nhận xóa điểm</h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                    </div>
                                    <div class="modal-body">
                                        <p>Bạn có chắc chắn muốn xóa điểm của sinh viên <strong
                                                id="deleteStudentName"></strong>?</p>
                                        <p class="text-muted">Hành động này không thể hoàn tác.</p>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary"
                                            data-bs-dismiss="modal">Hủy</button>
                                        <form id="deleteForm" method="POST" action="/teacher/scores/delete"
                                            style="display: inline;">
                                            <input type="hidden" name="scoreId" id="deleteScoreId">
                                            <button type="submit" class="btn btn-danger">Xóa điểm</button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <script
                            src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
                        <script>
                            // Event listeners for buttons
                            document.addEventListener('DOMContentLoaded', function () {
                                // Add score button handler
                                document.addEventListener('click', function (e) {
                                    if (e.target.closest('.add-score-btn')) {
                                        const btn = e.target.closest('.add-score-btn');
                                        const studentId = btn.dataset.studentId;
                                        const studentName = btn.dataset.studentName;
                                        addScore(studentId, studentName);
                                    }
                                });

                                // Edit score button handler
                                document.addEventListener('click', function (e) {
                                    if (e.target.closest('.edit-score-btn')) {
                                        const btn = e.target.closest('.edit-score-btn');
                                        const scoreId = btn.dataset.scoreId;
                                        const studentId = btn.dataset.studentId;
                                        const studentName = btn.dataset.studentName;
                                        const attendanceScore = btn.dataset.attendanceScore === 'null' || btn.dataset.attendanceScore === '' ? null : parseFloat(btn.dataset.attendanceScore);
                                        const midtermScore = btn.dataset.midtermScore === 'null' || btn.dataset.midtermScore === '' ? null : parseFloat(btn.dataset.midtermScore);
                                        const finalScore = btn.dataset.finalScore === 'null' || btn.dataset.finalScore === '' ? null : parseFloat(btn.dataset.finalScore);
                                        const notes = btn.dataset.notes === 'null' ? '' : btn.dataset.notes;
                                        editScore(scoreId, studentId, studentName, attendanceScore, midtermScore, finalScore, notes);
                                    }
                                });

                                // Delete score button handler
                                document.addEventListener('click', function (e) {
                                    if (e.target.closest('.delete-score-btn')) {
                                        const btn = e.target.closest('.delete-score-btn');
                                        const scoreId = btn.dataset.scoreId;
                                        const studentName = btn.dataset.studentName;
                                        deleteScore(scoreId, studentName);
                                    }
                                });
                            });

                            function clearFilters() {
                                window.location.href = '/teacher/scores';
                            }

                            function addScore(studentId, studentName) {
                                document.getElementById('scoreModalTitle').textContent = 'Thêm điểm mới';
                                document.getElementById('studentId').value = studentId;
                                document.getElementById('studentInfo').textContent = studentName;
                                document.getElementById('attendanceScore').value = '';
                                document.getElementById('midtermScore').value = '';
                                document.getElementById('finalScore').value = '';
                                document.getElementById('notes').value = '';

                                new bootstrap.Modal(document.getElementById('scoreModal')).show();
                            }

                            function editScore(scoreId, studentId, studentName, attendance, midterm, final, notes) {
                                document.getElementById('scoreModalTitle').textContent = 'Chỉnh sửa điểm';
                                document.getElementById('studentId').value = studentId;
                                document.getElementById('studentInfo').textContent = studentName;
                                document.getElementById('attendanceScore').value = attendance || '';
                                document.getElementById('midtermScore').value = midterm || '';
                                document.getElementById('finalScore').value = final || '';
                                document.getElementById('notes').value = notes || '';

                                new bootstrap.Modal(document.getElementById('scoreModal')).show();
                            }

                            function deleteScore(scoreId, studentName) {
                                document.getElementById('deleteScoreId').value = scoreId;
                                document.getElementById('deleteStudentName').textContent = studentName;

                                new bootstrap.Modal(document.getElementById('deleteModal')).show();
                            }
                        </script>
                </body>

                </html>