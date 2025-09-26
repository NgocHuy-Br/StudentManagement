<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1">
                <title>Quản lý điểm - ${subject.subjectName}</title>
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

                    .table-scores tbody tr:hover {
                        background: #fffaf7;
                    }

                    .score-input {
                        width: 80px;
                        text-align: center;
                    }

                    .score-excellent {
                        color: #28a745;
                        font-weight: bold;
                    }

                    .score-good {
                        color: #17a2b8;
                        font-weight: bold;
                    }

                    .score-average {
                        color: #ffc107;
                        font-weight: bold;
                    }

                    .score-poor {
                        color: #dc3545;
                        font-weight: bold;
                    }
                </style>
            </head>

            <body>
                <%@ include file="../common/header.jsp" %>
                    <main class="container-fluid main-wrap py-3">
                        <%@ include file="_nav.jsp" %>

                            <!-- Subject Info -->
                            <div class="card mt-3">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-start">
                                        <div>
                                            <h5 class="mb-1">${subject.subjectCode} - ${subject.subjectName}</h5>
                                            <div class="text-muted">
                                                <i class="bi bi-mortarboard me-1"></i>${subject.major.majorName}
                                                | <i class="bi bi-credit-card me-1"></i>${subject.credit} tín chỉ
                                                <c:if test="${not empty semester}">
                                                    | <i class="bi bi-calendar3 me-1"></i>Học kỳ ${semester}
                                                </c:if>
                                            </div>
                                        </div>
                                        <a href="${pageContext.request.contextPath}/teacher/subjects"
                                            class="btn btn-outline-secondary">
                                            <i class="bi bi-arrow-left me-1"></i>Quay lại
                                        </a>
                                    </div>
                                </div>
                            </div>

                            <!-- Scores Management -->
                            <div class="card mt-3">
                                <div class="card-body">
                                    <!-- Thông báo -->
                                    <c:if test="${not empty error}">
                                        <div class="alert alert-danger alert-dismissible">
                                            <i class="bi bi-exclamation-triangle me-2"></i>${error}
                                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                        </div>
                                    </c:if>
                                    <c:if test="${not empty success}">
                                        <div class="alert alert-success alert-dismissible">
                                            <i class="bi bi-check-circle me-2"></i>${success}
                                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                        </div>
                                    </c:if>

                                    <div class="d-flex justify-content-between align-items-center mb-3">
                                        <h6 class="mb-0"><i class="bi bi-table me-2"></i>Bảng điểm sinh viên</h6>
                                        <span class="text-muted">Tổng: <strong>${scores.totalElements}</strong> sinh
                                            viên</span>
                                    </div>

                                    <!-- Scores Table -->
                                    <div class="table-responsive">
                                        <table class="table table-hover align-middle table-scores">
                                            <thead class="table-light">
                                                <tr>
                                                    <th>STT</th>
                                                    <th>MSSV</th>
                                                    <th>Họ và tên</th>
                                                    <th>Lớp</th>
                                                    <th>Điểm TB môn</th>
                                                    <th>Ghi chú</th>
                                                    <th>Thao tác</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:if test="${scores.totalElements == 0}">
                                                    <tr>
                                                        <td colspan="7" class="text-center text-muted py-4">
                                                            Chưa có sinh viên nào đăng ký môn học này.
                                                        </td>
                                                    </tr>
                                                </c:if>

                                                <c:forEach var="score" items="${scores.content}" varStatus="status">
                                                    <tr>
                                                        <td>${(scores.number * scores.size) + status.index + 1}</td>
                                                        <td><strong>${score.student.user.username}</strong></td>
                                                        <td>${score.student.user.fname} ${score.student.user.lname}</td>
                                                        <td>${score.student.className}</td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${score.avgScore == null}">
                                                                    <span class="text-muted">Chưa có</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <c:choose>
                                                                        <c:when test="${score.avgScore >= 8.5}">
                                                                            <span
                                                                                class="score-excellent">${score.avgScore}</span>
                                                                        </c:when>
                                                                        <c:when test="${score.avgScore >= 7.0}">
                                                                            <span
                                                                                class="score-good">${score.avgScore}</span>
                                                                        </c:when>
                                                                        <c:when test="${score.avgScore >= 5.0}">
                                                                            <span
                                                                                class="score-average">${score.avgScore}</span>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span
                                                                                class="score-poor">${score.avgScore}</span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <small class="text-muted">${score.notes}</small>
                                                        </td>
                                                        <td>
                                                            <button class="btn btn-outline-primary btn-sm"
                                                                data-bs-toggle="modal" data-bs-target="#modalEditScore"
                                                                onclick="editScore(${score.id}, '${score.student.user.username}', '${score.student.user.fname} ${score.student.user.lname}', '${score.avgScore}', '${fn:escapeXml(score.notes)}')">
                                                                <i class="bi bi-pencil"></i>
                                                            </button>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>

                                    <!-- Pagination -->
                                    <c:if test="${scores.totalPages > 1}">
                                        <nav class="d-flex justify-content-end mt-3">
                                            <ul class="pagination pagination-sm mb-0">
                                                <li class="page-item ${scores.first ? 'disabled' : ''}">
                                                    <a class="page-link"
                                                        href="?semester=${semester}&page=${scores.number-1}&size=${scores.size}">«</a>
                                                </li>
                                                <c:forEach var="i" begin="0" end="${scores.totalPages-1}">
                                                    <li class="page-item ${i==scores.number ? 'active' : ''}">
                                                        <a class="page-link"
                                                            href="?semester=${semester}&page=${i}&size=${scores.size}">${i+1}</a>
                                                    </li>
                                                </c:forEach>
                                                <li class="page-item ${scores.last ? 'disabled' : ''}">
                                                    <a class="page-link"
                                                        href="?semester=${semester}&page=${scores.number+1}&size=${scores.size}">»</a>
                                                </li>
                                            </ul>
                                        </nav>
                                    </c:if>
                                </div>
                            </div>
                    </main>

                    <!-- Modal: Edit Score -->
                    <div class="modal fade" id="modalEditScore" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog modal-dialog-centered">
                            <form class="modal-content" method="post" id="scoreForm">
                                <div class="modal-header">
                                    <h5 class="modal-title"><i class="bi bi-pencil-square me-2"></i>Cập nhật điểm</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                </div>
                                <div class="modal-body">
                                    <div class="mb-3">
                                        <label class="form-label">Sinh viên</label>
                                        <div class="form-control-plaintext" id="studentInfo">
                                            <!-- Student info will be filled by JavaScript -->
                                        </div>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Điểm trung bình môn (0-10)</label>
                                        <input name="avgScore" type="number" class="form-control" min="0" max="10"
                                            step="0.1" id="scoreInput" required>
                                        <div class="form-text">Nhập điểm từ 0 đến 10</div>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Ghi chú</label>
                                        <textarea name="notes" class="form-control" rows="2" id="notesInput"
                                            placeholder="Ghi chú về điểm số..."></textarea>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <c:if test="${not empty _csrf}">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                                    </c:if>
                                    <button class="btn btn-primary" type="submit">
                                        <i class="bi bi-save me-1"></i>Lưu điểm
                                    </button>
                                    <button class="btn btn-outline-secondary" type="button" data-bs-dismiss="modal">
                                        Hủy
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>

                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
                    <script>
                        function editScore(scoreId, mssv, fullName, avgScore, notes) {
                            // Set form action
                            document.getElementById('scoreForm').action =
                                '${pageContext.request.contextPath}/teacher/scores/' + scoreId;

                            // Set student info
                            document.getElementById('studentInfo').innerHTML =
                                '<strong>' + mssv + '</strong> - ' + fullName;

                            // Set current values
                            document.getElementById('scoreInput').value = avgScore || '';
                            document.getElementById('notesInput').value = notes || '';
                        }
                    </script>
            </body>

            </html>