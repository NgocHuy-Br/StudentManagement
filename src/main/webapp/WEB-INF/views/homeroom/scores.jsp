<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
            <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Quản lý điểm số - Lớp ${classroom.classCode}</title>
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                        rel="stylesheet">
                    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"
                        rel="stylesheet">
                    <style>
                        .score-input {
                            width: 80px;
                        }

                        .score-good {
                            background-color: #d4edda;
                            color: #155724;
                        }

                        .score-average {
                            background-color: #fff3cd;
                            color: #856404;
                        }

                        .score-poor {
                            background-color: #f8d7da;
                            color: #721c24;
                        }

                        .filter-card {
                            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                            color: white;
                        }

                        .table-responsive {
                            max-height: 600px;
                            overflow-y: auto;
                        }

                        .sticky-header {
                            position: sticky;
                            top: 0;
                            z-index: 10;
                        }
                    </style>
                </head>

                <body class="bg-light">
                    <!-- Header -->
                    <nav class="navbar navbar-expand-lg navbar-dark bg-primary shadow-sm">
                        <div class="container">
                            <a class="navbar-brand" href="/homeroom">
                                <i class="fas fa-chalkboard-teacher me-2"></i>
                                Giáo viên chủ nhiệm
                            </a>
                            <div class="navbar-nav ms-auto">
                                <span class="navbar-text me-3">
                                    <i class="fas fa-user me-1"></i>
                                    ${teacher.user.fname} ${teacher.user.lname}
                                </span>
                                <a class="btn btn-outline-light btn-sm" href="/logout">
                                    <i class="fas fa-sign-out-alt me-1"></i>Đăng xuất
                                </a>
                            </div>
                        </div>
                    </nav>

                    <div class="container my-4">
                        <!-- Breadcrumb -->
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item"><a href="/homeroom">Dashboard</a></li>
                                <li class="breadcrumb-item"><a href="/homeroom/classroom/${classroom.id}/students">Lớp
                                        ${classroom.classCode}</a></li>
                                <li class="breadcrumb-item active">Quản lý điểm số</li>
                            </ol>
                        </nav>

                        <!-- Alert Messages -->
                        <c:if test="${not empty success}">
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                <i class="fas fa-check-circle me-2"></i>
                                ${success}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <c:if test="${not empty error}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="fas fa-exclamation-triangle me-2"></i>
                                ${error}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <!-- Thông tin lớp -->
                        <div class="card mb-4">
                            <div class="card-body">
                                <div class="row align-items-center">
                                    <div class="col-md-8">
                                        <h4 class="card-title mb-2">
                                            <i class="fas fa-chart-line me-2"></i>
                                            Quản lý điểm số - Lớp ${classroom.classCode}
                                        </h4>
                                        <p class="mb-1"><strong>Ngành:</strong> ${classroom.major.majorName}</p>
                                        <p class="mb-1"><strong>Khóa:</strong> ${classroom.courseYear}</p>
                                        <p class="mb-0"><strong>Sĩ số:</strong>
                                            ${classroom.studentCount}/${classroom.maxSize} học sinh</p>
                                    </div>
                                    <div class="col-md-4 text-end">
                                        <a href="/homeroom/classroom/${classroom.id}/students"
                                            class="btn btn-outline-primary me-2">
                                            <i class="fas fa-users me-1"></i>
                                            Danh sách học sinh
                                        </a>
                                        <button class="btn btn-success" onclick="window.print()">
                                            <i class="fas fa-print me-1"></i>
                                            In báo cáo
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Bộ lọc -->
                        <div class="card mb-4 filter-card">
                            <div class="card-body">
                                <h5 class="card-title mb-3">
                                    <i class="fas fa-filter me-2"></i>
                                    Bộ lọc điểm số
                                </h5>
                                <form method="GET" action="/homeroom/classroom/${classroom.id}/scores">
                                    <div class="row g-3 align-items-end">
                                        <div class="col-md-4">
                                            <label for="subjectId" class="form-label">Môn học</label>
                                            <select class="form-select" id="subjectId" name="subjectId">
                                                <option value="">-- Tất cả môn học --</option>
                                                <c:forEach var="subject" items="${subjects}">
                                                    <option value="${subject.id}" ${selectedSubjectId==subject.id
                                                        ? 'selected' : '' }>
                                                        ${subject.subjectCode} - ${subject.subjectName}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-md-4">
                                            <button type="submit" class="btn btn-light">
                                                <i class="fas fa-search me-1"></i>
                                                Lọc
                                            </button>
                                            <a href="/homeroom/classroom/${classroom.id}/scores"
                                                class="btn btn-outline-light ms-2">
                                                <i class="fas fa-refresh me-1"></i>
                                                Xóa lọc
                                            </a>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>

                        <!-- Bảng điểm -->
                        <div class="card">
                            <div class="card-header">
                                <div class="row align-items-center">
                                    <div class="col">
                                        <h5 class="card-title mb-0">
                                            <i class="fas fa-table me-2"></i>
                                            Bảng điểm
                                            <c:if test="${not empty selectedSubjectId}">
                                                <small class="text-muted">
                                                    (Đã lọc)
                                                </small>
                                            </c:if>
                                        </h5>
                                    </div>
                                    <div class="col-auto">
                                        <small class="text-muted">
                                            Tổng cộng: <strong>${scores.totalElements}</strong> bản ghi
                                        </small>
                                    </div>
                                </div>
                            </div>
                            <div class="card-body p-0">
                                <c:if test="${empty scores.content}">
                                    <div class="text-center py-5">
                                        <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                                        <h5 class="text-muted">Không có dữ liệu điểm</h5>
                                        <p class="text-muted">
                                            <c:if test="${not empty selectedSubjectId}">
                                                Thử thay đổi bộ lọc để xem kết quả khác.
                                            </c:if>
                                            <c:if test="${empty selectedSubjectId}">
                                                Chưa có điểm nào được nhập cho lớp này.
                                            </c:if>
                                        </p>
                                    </div>
                                </c:if>

                                <c:if test="${not empty scores.content}">
                                    <div class="table-responsive">
                                        <table class="table table-hover mb-0">
                                            <thead class="table-primary sticky-header">
                                                <tr>
                                                    <th scope="col" style="width: 50px;">#</th>
                                                    <th scope="col" style="width: 120px;">Mã SV</th>
                                                    <th scope="col" style="width: 200px;">Họ và tên</th>
                                                    <th scope="col" style="width: 150px;">Môn học</th>
                                                    <th scope="col" style="width: 100px;">Học kỳ</th>
                                                    <th scope="col" style="width: 100px;">Điểm TB</th>
                                                    <th scope="col">Ghi chú</th>
                                                    <th scope="col" style="width: 120px;">Thao tác</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="score" items="${scores.content}" varStatus="status">
                                                    <tr>
                                                        <td>
                                                            ${(scores.number * scores.size) + status.index + 1}
                                                        </td>
                                                        <td>
                                                            <strong>${score.student.studentCode}</strong>
                                                        </td>
                                                        <td>
                                                            <div class="d-flex align-items-center">
                                                                <i class="fas fa-user-graduate me-2 text-primary"></i>
                                                                <div>
                                                                    <div>${score.student.user.fname}
                                                                        ${score.student.user.lname}</div>
                                                                    <small
                                                                        class="text-muted">${score.student.user.username}</small>
                                                                </div>
                                                            </div>
                                                        </td>
                                                        <td>
                                                            <div>
                                                                <strong>${score.subject.subjectCode}</strong>
                                                            </div>
                                                            <small
                                                                class="text-muted">${score.subject.subjectName}</small>
                                                        </td>
                                                        <td>
                                                            <span class="badge bg-secondary">
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${score.avgScore >= 8.0}">
                                                                    <span class="badge bg-success fs-6">
                                                                        <fmt:formatNumber value="${score.avgScore}"
                                                                            maxFractionDigits="1" />
                                                                    </span>
                                                                </c:when>
                                                                <c:when test="${score.avgScore >= 6.5}">
                                                                    <span class="badge bg-warning fs-6">
                                                                        <fmt:formatNumber value="${score.avgScore}"
                                                                            maxFractionDigits="1" />
                                                                    </span>
                                                                </c:when>
                                                                <c:when test="${score.avgScore >= 5.0}">
                                                                    <span class="badge bg-info fs-6">
                                                                        <fmt:formatNumber value="${score.avgScore}"
                                                                            maxFractionDigits="1" />
                                                                    </span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge bg-danger fs-6">
                                                                        <fmt:formatNumber value="${score.avgScore}"
                                                                            maxFractionDigits="1" />
                                                                    </span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <c:if test="${not empty score.notes}">
                                                                <span class="text-muted" title="${score.notes}">
                                                                    <c:choose>
                                                                        <c:when test="${fn:length(score.notes) > 50}">
                                                                            ${fn:substring(score.notes, 0, 50)}...
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            ${score.notes}
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </span>
                                                            </c:if>
                                                            <c:if test="${empty score.notes}">
                                                                <span class="text-muted fst-italic">Không có ghi
                                                                    chú</span>
                                                            </c:if>
                                                        </td>
                                                        <td>
                                                            <button class="btn btn-sm btn-outline-primary"
                                                                data-score-id="${score.id}"
                                                                data-student-name="${score.student.user.fname} ${score.student.user.lname}"
                                                                data-subject-name="${score.subject.subjectName}"
                                                                data-avg-score="${score.avgScore}"
                                                                data-notes="${score.notes}"
                                                                onclick="editScoreFromData(this)">
                                                                <i class="fas fa-edit me-1"></i>
                                                                Sửa
                                                            </button>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>

                                    <!-- Pagination -->
                                    <c:if test="${scores.totalPages > 1}">
                                        <div class="card-footer">
                                            <nav aria-label="Page navigation">
                                                <ul class="pagination justify-content-center mb-0">
                                                    <c:if test="${scores.hasPrevious()}">
                                                        <li class="page-item">
                                                            <a class="page-link"
                                                                href="?page=${scores.number - 1}&size=${scores.size}&subjectId=${selectedSubjectId}">
                                                                <i class="fas fa-chevron-left"></i> Trước
                                                            </a>
                                                        </li>
                                                    </c:if>

                                                    <c:set var="startPage"
                                                        value="${scores.number - 2 < 0 ? 0 : scores.number - 2}" />
                                                    <c:set var="endPage"
                                                        value="${startPage + 4 >= scores.totalPages ? scores.totalPages - 1 : startPage + 4}" />

                                                    <c:forEach var="i" begin="${startPage}" end="${endPage}">
                                                        <li class="page-item ${i == scores.number ? 'active' : ''}">
                                                            <a class="page-link"
                                                                href="?page=${i}&size=${scores.size}&subjectId=${selectedSubjectId}">
                                                                ${i + 1}
                                                            </a>
                                                        </li>
                                                    </c:forEach>

                                                    <c:if test="${scores.hasNext()}">
                                                        <li class="page-item">
                                                            <a class="page-link"
                                                                href="?page=${scores.number + 1}&size=${scores.size}&subjectId=${selectedSubjectId}">
                                                                Sau <i class="fas fa-chevron-right"></i>
                                                            </a>
                                                        </li>
                                                    </c:if>
                                                </ul>
                                            </nav>
                                        </div>
                                    </c:if>
                                </c:if>
                            </div>
                        </div>
                    </div>

                    <!-- Modal sửa điểm -->
                    <div class="modal fade" id="editScoreModal" tabindex="-1">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title">
                                        <i class="fas fa-edit me-2"></i>
                                        Chỉnh sửa điểm số
                                    </h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                </div>
                                <form id="editScoreForm" method="POST">
                                    <div class="modal-body">
                                        <div class="mb-3">
                                            <label class="form-label"><strong>Học sinh:</strong></label>
                                            <p id="studentName" class="text-muted"></p>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label"><strong>Môn học:</strong></label>
                                            <p id="subjectName" class="text-muted"></p>
                                        </div>
                                        <div class="mb-3">
                                            <label for="avgScore" class="form-label">Điểm trung bình <span
                                                    class="text-danger">*</span></label>
                                            <input type="number" class="form-control" id="avgScore" name="avgScore"
                                                min="0" max="10" step="0.1" required>
                                            <div class="form-text">Nhập điểm từ 0.0 đến 10.0</div>
                                        </div>
                                        <div class="mb-3">
                                            <label for="notes" class="form-label">Ghi chú</label>
                                            <textarea class="form-control" id="notes" name="notes" rows="3"
                                                placeholder="Nhập ghi chú (không bắt buộc)"></textarea>
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                                            <i class="fas fa-times me-1"></i>
                                            Hủy
                                        </button>
                                        <button type="submit" class="btn btn-primary">
                                            <i class="fas fa-save me-1"></i>
                                            Lưu thay đổi
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>

                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                    <script>
                        function editScore(scoreId, studentName, subjectName, avgScore, notes) {
                            // Cập nhật form action
                            document.getElementById('editScoreForm').action = '/homeroom/scores/' + scoreId;

                            // Cập nhật thông tin
                            document.getElementById('studentName').textContent = studentName;
                            document.getElementById('subjectName').textContent = subjectName;
                            document.getElementById('avgScore').value = avgScore;
                            document.getElementById('notes').value = notes || '';

                            // Hiển thị modal
                            new bootstrap.Modal(document.getElementById('editScoreModal')).show();
                        }

                        function editScoreFromData(button) {
                            const scoreId = button.getAttribute('data-score-id');
                            const studentName = button.getAttribute('data-student-name');
                            const subjectName = button.getAttribute('data-subject-name');
                            const avgScore = button.getAttribute('data-avg-score');
                            const notes = button.getAttribute('data-notes');

                            editScore(scoreId, studentName, subjectName, avgScore, notes);
                        }

                        // Auto-dismiss alerts after 5 seconds
                        setTimeout(function () {
                            const alerts = document.querySelectorAll('.alert');
                            alerts.forEach(function (alert) {
                                const bsAlert = new bootstrap.Alert(alert);
                                bsAlert.close();
                            });
                        }, 5000);

                        // Print styles
                        window.addEventListener('beforeprint', function () {
                            document.body.classList.add('printing');
                        });

                        window.addEventListener('afterprint', function () {
                            document.body.classList.remove('printing');
                        });
                    </script>

                    <style>
                        @media print {

                            .navbar,
                            .breadcrumb,
                            .filter-card,
                            .pagination,
                            .btn,
                            .modal {
                                display: none !important;
                            }

                            .card {
                                border: none !important;
                                box-shadow: none !important;
                            }

                            .table {
                                font-size: 12px;
                            }

                            .printing .table-responsive {
                                max-height: none;
                                overflow: visible;
                            }
                        }
                    </style>
                </body>

                </html>