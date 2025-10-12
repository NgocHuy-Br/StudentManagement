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
                            border-radius: 10px;
                            padding: 0.8rem 1.2rem;
                            margin-bottom: 1.5rem;
                        }

                        .stat-item {
                            text-align: center;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            gap: 0.4rem;
                        }

                        .stat-label {
                            font-size: 1.1rem;
                            opacity: 0.95;
                            display: inline;
                            font-weight: 600;
                        }

                        .stat-number {
                            font-size: 1.1rem;
                            font-weight: 700;
                            display: inline;
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
                                    <form method="GET" action="/admin/scores" class="row g-3">
                                        <div class="col-md-3">
                                            <label for="classroomSelect" class="form-label fw-semibold">
                                                <i class="bi bi-building"></i> Chọn lớp học
                                            </label>
                                            <select class="form-select" id="classroomSelect" name="classroomId"
                                                onchange="this.form.submit()">
                                                <option value="">-- Tất cả lớp --</option>
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
                                                <option value="">-- Tất cả môn học --</option>
                                                <c:forEach items="${subjects}" var="subject">
                                                    <option value="${subject.id}" ${selectedSubjectId==subject.id
                                                        ? 'selected' : '' }>
                                                        ${subject.subjectCode} - ${subject.subjectName}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>

                                        <!-- Khoảng trống giữa các phần -->
                                        <div class="col-md-1"></div>

                                        <div class="col-md-5">
                                            <label for="searchInput" class="form-label fw-semibold">
                                                <i class="bi bi-funnel"></i> Lọc sinh viên
                                            </label>
                                            <div class="input-group">
                                                <input type="text" class="form-control" id="searchInput" name="search"
                                                    placeholder="Nhập MSSV hoặc họ tên..." value="${param.search}"
                                                    onkeypress="if(event.key==='Enter') this.form.submit()">
                                                <button type="button" class="btn btn-outline-secondary"
                                                    onclick="clearSearch()" title="Xóa bộ lọc">
                                                    <i class="bi bi-x-lg"></i>
                                                </button>
                                            </div>
                                        </div>
                                    </form>
                                </div>

                                <c:if test="${not empty students or not empty scores}">
                                    <!-- Quick Stats -->
                                    <div class="quick-stats">
                                        <div class="row">
                                            <div class="col-md-3">
                                                <div class="stat-item">
                                                    <span class="stat-label">Tổng sinh viên:</span>
                                                    <span class="stat-number">${fn:length(students)}</span>
                                                </div>
                                            </div>
                                            <div class="col-md-3">
                                                <div class="stat-item">
                                                    <span class="stat-label">Đã có điểm:</span>
                                                    <span class="stat-number">${fn:length(scores)}</span>
                                                </div>
                                            </div>
                                            <div class="col-md-3">
                                                <div class="stat-item">
                                                    <span class="stat-label">Chưa có điểm:</span>
                                                    <span class="stat-number">${fn:length(students) -
                                                        fn:length(scores)}</span>
                                                </div>
                                            </div>
                                            <div class="col-md-3">
                                                <div class="stat-item">
                                                    <span class="stat-label">Tỷ lệ hoàn thành:</span>
                                                    <span class="stat-number">
                                                        <c:choose>
                                                            <c:when test="${fn:length(students) > 0}">
                                                                <fmt:formatNumber
                                                                    value="${(fn:length(scores) / fn:length(students)) * 100}"
                                                                    pattern="#0" />%
                                                            </c:when>
                                                            <c:otherwise>0%</c:otherwise>
                                                        </c:choose>
                                                    </span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:if>

                                <!-- Scores Table -->
                                <c:choose>
                                    <c:when test="${not empty scores}">
                                        <div class="card">
                                            <div class="card-header d-flex justify-content-between align-items-center">
                                                <h5 class="mb-0">
                                                    <i class="bi bi-journal-text me-2"></i>Bảng điểm sinh viên
                                                </h5>
                                                <small class="text-muted">
                                                    Hiển thị ${fn:length(scores)} kết quả
                                                </small>
                                            </div>
                                            <div class="card-body p-0">
                                                <div class="table-responsive">
                                                    <table class="table table-striped table-hover mb-0">
                                                        <thead class="table-light">
                                                            <tr>
                                                                <th style="width: 50px;">#</th>
                                                                <th style="width: 120px;">MSSV</th>
                                                                <th>Họ và tên</th>
                                                                <th style="width: 200px;">Lớp</th>
                                                                <th style="width: 200px;">Môn học</th>
                                                                <th style="width: 80px;">Chuyên cần</th>
                                                                <th style="width: 80px;">Giữa kỳ</th>
                                                                <th style="width: 80px;">Cuối kỳ</th>
                                                                <th style="width: 80px;">Trung bình</th>
                                                                <th style="width: 100px;">Thao tác</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <c:forEach items="${scores}" var="score" varStatus="status">
                                                                <tr>
                                                                    <td class="text-center">${status.index + 1}</td>
                                                                    <td class="fw-semibold">
                                                                        ${score.student.user.username}</td>
                                                                    <td>
                                                                        <div class="d-flex align-items-center">
                                                                            <div class="student-avatar me-2">
                                                                                ${fn:toUpperCase(fn:substring(score.student.user.fname,
                                                                                0,
                                                                                1))}${fn:toUpperCase(fn:substring(score.student.user.lname,
                                                                                0, 1))}
                                                                            </div>
                                                                            <div>
                                                                                <div class="fw-semibold">
                                                                                    ${score.student.user.fname}
                                                                                    ${score.student.user.lname}
                                                                                </div>
                                                                                <small
                                                                                    class="text-muted">${score.student.user.email}</small>
                                                                            </div>
                                                                        </div>
                                                                    </td>
                                                                    <td>
                                                                        <span
                                                                            class="badge bg-info">${score.student.classroom.classCode}</span>
                                                                    </td>
                                                                    <td>
                                                                        <small
                                                                            class="text-muted">${score.subject.subjectCode}</small><br>
                                                                        <strong>${score.subject.subjectName}</strong>
                                                                    </td>
                                                                    <td class="text-center">
                                                                        <c:choose>
                                                                            <c:when
                                                                                test="${score.attendanceScore != null}">
                                                                                <span
                                                                                    class="badge bg-light text-dark">${score.attendanceScore}</span>
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
                                                                                <span
                                                                                    class="badge bg-light text-dark">${score.midtermScore}</span>
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <span class="text-muted">-</span>
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </td>
                                                                    <td class="text-center">
                                                                        <c:choose>
                                                                            <c:when test="${score.finalScore != null}">
                                                                                <span
                                                                                    class="badge bg-light text-dark">${score.finalScore}</span>
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <span class="text-muted">-</span>
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </td>
                                                                    <td class="text-center">
                                                                        <c:if test="${score.avgScore != null}">
                                                                            <span class="avg-score 
                                                                                <c:choose>
                                                                                    <c:when test=" ${score.avgScore>=
                                                                                8.5}">score-excellent
                                    </c:when>
                                    <c:when test="${score.avgScore >= 7.0}">score-good</c:when>
                                    <c:when test="${score.avgScore >= 5.5}">score-average</c:when>
                                    <c:otherwise>score-poor</c:otherwise>
                                </c:choose>
                                ">
                                <fmt:formatNumber value="${score.avgScore}" pattern="#0.0" />
                                </span>
                                </c:if>
                                </td>
                                <td class="text-center">
                                    <button type="button" class="btn btn-sm btn-outline-primary"
                                        onclick="editScore('${score.student.id}', '${score.subject.id}', '${score.attendanceScore}', '${score.midtermScore}', '${score.finalScore}', '${score.notes}')">
                                        <i class="bi bi-pencil"></i>
                                    </button>
                                </td>
                                </tr>
                                </c:forEach>
                                </tbody>
                                </table>
                        </div>
                        </div>
                        </div>
                        </c:when>
                        <c:when test="${empty students and empty scores}">
                            <div class="text-center py-5">
                                <i class="bi bi-journal-x text-muted" style="font-size: 4rem;"></i>
                                <h4 class="text-muted mt-3">Chưa có dữ liệu</h4>
                                <p class="text-muted">Vui lòng chọn lớp học hoặc môn học để xem điểm số.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-5">
                                <i class="bi bi-search text-muted" style="font-size: 4rem;"></i>
                                <h4 class="text-muted mt-3">Không có điểm nào được tìm thấy</h4>
                                <p class="text-muted">Thử thay đổi bộ lọc hoặc tìm kiếm khác.</p>
                            </div>
                        </c:otherwise>
                        </c:choose>

                        <!-- Edit Score Modal -->
                        <div class="modal fade" id="editScoreModal" tabindex="-1" aria-labelledby="editScoreModalLabel"
                            aria-hidden="true">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="editScoreModalLabel">
                                            <i class="bi bi-pencil-square me-2"></i>Cập nhật điểm
                                        </h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal"
                                            aria-label="Close"></button>
                                    </div>
                                    <form method="POST" action="/admin/scores/update">
                                        <div class="modal-body">
                                            <input type="hidden" id="editStudentId" name="studentId">
                                            <input type="hidden" id="editSubjectId" name="subjectId">

                                            <div class="row g-3">
                                                <div class="col-md-4">
                                                    <label for="editAttendanceScore" class="form-label">Điểm chuyên
                                                        cần</label>
                                                    <input type="number" class="form-control" id="editAttendanceScore"
                                                        name="attendanceScore" min="0" max="10" step="0.1">
                                                </div>
                                                <div class="col-md-4">
                                                    <label for="editMidtermScore" class="form-label">Điểm giữa
                                                        kỳ</label>
                                                    <input type="number" class="form-control" id="editMidtermScore"
                                                        name="midtermScore" min="0" max="10" step="0.1">
                                                </div>
                                                <div class="col-md-4">
                                                    <label for="editFinalScore" class="form-label">Điểm cuối kỳ</label>
                                                    <input type="number" class="form-control" id="editFinalScore"
                                                        name="finalScore" min="0" max="10" step="0.1">
                                                </div>
                                            </div>

                                            <div class="mt-3">
                                                <label for="editNotes" class="form-label">Ghi chú</label>
                                                <textarea class="form-control" id="editNotes" name="notes"
                                                    rows="3"></textarea>
                                            </div>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-secondary"
                                                data-bs-dismiss="modal">Hủy</button>
                                            <button type="submit" class="btn btn-primary">
                                                <i class="bi bi-check-lg me-1"></i>Cập nhật
                                            </button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>

                        </div>

                        <script
                            src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
                        <script>
                            function clearSearch() {
                                document.getElementById('searchInput').value = '';
                                document.querySelector('form').submit();
                            }

                            function editScore(studentId, subjectId, attendanceScore, midtermScore, finalScore, notes) {
                                document.getElementById('editStudentId').value = studentId;
                                document.getElementById('editSubjectId').value = subjectId;

                                // Set values, handling null/undefined
                                document.getElementById('editAttendanceScore').value = (attendanceScore && attendanceScore !== 'null') ? attendanceScore : '';
                                document.getElementById('editMidtermScore').value = (midtermScore && midtermScore !== 'null') ? midtermScore : '';
                                document.getElementById('editFinalScore').value = (finalScore && finalScore !== 'null') ? finalScore : '';
                                document.getElementById('editNotes').value = (notes && notes !== 'null') ? notes : '';

                                // Show modal
                                new bootstrap.Modal(document.getElementById('editScoreModal')).show();
                            }
                        </script>
                </body>

                </html>