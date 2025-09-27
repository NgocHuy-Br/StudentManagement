<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <c:set var="contextPath" value="${pageContext.request.contextPath}" />
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Quản lý môn học - ${major.majorName} - PTIT SMS</title>
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

                    .table-hover tbody tr:hover {
                        background-color: var(--ptit-light-blue);
                    }

                    .breadcrumb-item a {
                        color: var(--ptit-blue);
                        text-decoration: none;
                    }

                    .major-header {
                        background: linear-gradient(135deg, var(--ptit-blue), #0056b3);
                        color: white;
                        padding: 2rem;
                        border-radius: 10px;
                        margin-bottom: 2rem;
                    }
                </style>
            </head>

            <body class="bg-light">
                <!-- Header -->
                <%@ include file="../common/header.jsp" %>

                    <!-- Navigation -->
                    <%@ include file="_nav.jsp" %>

                        <div class="container-fluid py-4">
                            <!-- Breadcrumb -->
                            <nav aria-label="breadcrumb" class="mb-3">
                                <ol class="breadcrumb">
                                    <li class="breadcrumb-item">
                                        <a href="${contextPath}/admin">Admin</a>
                                    </li>
                                    <li class="breadcrumb-item">
                                        <a href="${contextPath}/admin/majors">Ngành học</a>
                                    </li>
                                    <li class="breadcrumb-item active">${major.majorCode}</li>
                                </ol>
                            </nav>

                            <!-- Major Info Header -->
                            <div class="major-header">
                                <div class="row align-items-center">
                                    <div class="col-md-8">
                                        <h2 class="mb-2">
                                            <i class="bi bi-mortarboard-fill me-3"></i>
                                            ${major.majorName}
                                        </h2>
                                        <p class="mb-1">
                                            <strong>Mã ngành:</strong> ${major.majorCode}
                                        </p>
                                        <c:if test="${not empty major.description}">
                                            <p class="mb-0 opacity-90">
                                                <i class="bi bi-info-circle me-2"></i>
                                                ${major.description}
                                            </p>
                                        </c:if>
                                    </div>
                                    <div class="col-md-4 text-md-end">
                                        <div class="d-flex flex-column gap-2 align-items-md-end">
                                            <div class="badge bg-light text-dark fs-6">
                                                <i class="bi bi-book me-1"></i>
                                                ${page.totalElements} môn học
                                            </div>
                                            <a href="${contextPath}/admin/majors" class="btn btn-outline-light">
                                                <i class="bi bi-arrow-left me-1"></i>Quay lại
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>

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

                            <div class="row">
                                <!-- Main Content -->
                                <div class="col-12">
                                    <div class="card shadow-sm">
                                        <div class="card-header d-flex justify-content-between align-items-center">
                                            <h5 class="mb-0">
                                                <i class="bi bi-book me-2"></i>
                                                Danh sách môn học
                                            </h5>
                                            <button type="button" class="btn btn-success" data-bs-toggle="modal"
                                                data-bs-target="#addSubjectModal">
                                                <i class="bi bi-plus-lg me-1"></i>Thêm môn học
                                            </button>
                                        </div>
                                        <div class="card-body">
                                            <!-- Search and Filter -->
                                            <div class="row mb-3">
                                                <div class="col-md-6">
                                                    <form method="get" class="d-flex">
                                                        <div class="input-group">
                                                            <span class="input-group-text">
                                                                <i class="bi bi-search"></i>
                                                            </span>
                                                            <input type="text" name="q" value="${q}"
                                                                class="form-control"
                                                                placeholder="Tìm kiếm theo mã môn, tên môn...">
                                                            <input type="hidden" name="sort" value="${sort}">
                                                            <input type="hidden" name="dir" value="${dir}">
                                                            <button class="btn btn-outline-primary" type="submit">
                                                                Tìm kiếm
                                                            </button>
                                                            <c:if test="${not empty q}">
                                                                <a href="${contextPath}/admin/majors/${major.id}/subjects"
                                                                    class="btn btn-outline-secondary">
                                                                    <i class="bi bi-x"></i>
                                                                </a>
                                                            </c:if>
                                                        </div>
                                                    </form>
                                                </div>
                                                <div class="col-md-6 text-end">
                                                    <span class="text-muted">
                                                        Tổng: ${page.totalElements} môn học
                                                    </span>
                                                </div>
                                            </div>

                                            <!-- Table -->
                                            <div class="table-responsive">
                                                <table class="table table-hover align-middle">
                                                    <thead class="table-light">
                                                        <tr>
                                                            <th>
                                                                <a href="?q=${q}&sort=subjectCode&dir=${sort == 'subjectCode' and dir == 'asc' ? 'desc' : 'asc'}"
                                                                    class="text-decoration-none">
                                                                    Mã môn
                                                                    <c:if test="${sort == 'subjectCode'}">
                                                                        <i
                                                                            class="bi bi-arrow-${dir == 'asc' ? 'up' : 'down'}"></i>
                                                                    </c:if>
                                                                </a>
                                                            </th>
                                                            <th>
                                                                <a href="?q=${q}&sort=subjectName&dir=${sort == 'subjectName' and dir == 'asc' ? 'desc' : 'asc'}"
                                                                    class="text-decoration-none">
                                                                    Tên môn học
                                                                    <c:if test="${sort == 'subjectName'}">
                                                                        <i
                                                                            class="bi bi-arrow-${dir == 'asc' ? 'up' : 'down'}"></i>
                                                                    </c:if>
                                                                </a>
                                                            </th>
                                                            <th class="text-center">
                                                                <a href="?q=${q}&sort=credit&dir=${sort == 'credit' and dir == 'asc' ? 'desc' : 'asc'}"
                                                                    class="text-decoration-none">
                                                                    Số TC
                                                                    <c:if test="${sort == 'credit'}">
                                                                        <i
                                                                            class="bi bi-arrow-${dir == 'asc' ? 'up' : 'down'}"></i>
                                                                    </c:if>
                                                                </a>
                                                            </th>
                                                            <th class="text-center">Giáo viên phụ trách</th>
                                                            <th class="text-center">Thao tác</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:choose>
                                                            <c:when test="${empty page.content}">
                                                                <tr>
                                                                    <td colspan="5" class="text-center py-5 text-muted">
                                                                        <i
                                                                            class="bi bi-book-half display-1 d-block mb-3"></i>
                                                                        <h5>Chưa có môn học nào</h5>
                                                                        <p>Ngành <strong>${major.majorName}</strong>
                                                                            chưa có môn học nào được thêm</p>
                                                                        <c:if test="${not empty q}">
                                                                            <small class="text-muted">với từ khóa
                                                                                "${q}"</small>
                                                                        </c:if>
                                                                    </td>
                                                                </tr>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <c:forEach items="${page.content}" var="subject">
                                                                    <tr>
                                                                        <td class="fw-semibold text-primary">
                                                                            ${subject.subjectCode}</td>
                                                                        <td class="fw-medium">${subject.subjectName}
                                                                        </td>
                                                                        <td class="text-center">
                                                                            <span
                                                                                class="badge bg-info">${subject.credit}</span>
                                                                        </td>
                                                                        <td class="text-center">
                                                                            <!-- TODO: Show assigned teachers -->
                                                                            <span class="text-muted small">Chưa phân
                                                                                công</span>
                                                                        </td>
                                                                        <td class="text-center">
                                                                            <div class="btn-group">
                                                                                <button type="button"
                                                                                    class="btn btn-sm btn-outline-warning"
                                                                                    onclick="editSubject('${subject.id}', '${subject.subjectCode}', '${subject.subjectName}', '${subject.credit}')">
                                                                                    <i class="bi bi-pencil"></i>
                                                                                </button>
                                                                                <button type="button"
                                                                                    class="btn btn-sm btn-outline-danger"
                                                                                    onclick="deleteSubject('${subject.id}', '${subject.subjectCode}')">
                                                                                    <i class="bi bi-trash"></i>
                                                                                </button>
                                                                            </div>
                                                                        </td>
                                                                    </tr>
                                                                </c:forEach>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </tbody>
                                                </table>
                                            </div>

                                            <!-- Pagination -->
                                            <c:if test="${page.totalPages > 1}">
                                                <nav aria-label="Pagination">
                                                    <ul class="pagination justify-content-center">
                                                        <li class="page-item ${page.first ? 'disabled' : ''}">
                                                            <a class="page-link"
                                                                href="?q=${q}&page=${page.number - 1}&sort=${sort}&dir=${dir}">
                                                                <i class="bi bi-chevron-left"></i>
                                                            </a>
                                                        </li>

                                                        <c:forEach begin="0" end="${page.totalPages - 1}" var="i">
                                                            <c:if
                                                                test="${i >= page.number - 2 && i <= page.number + 2}">
                                                                <li
                                                                    class="page-item ${i == page.number ? 'active' : ''}">
                                                                    <a class="page-link"
                                                                        href="?q=${q}&page=${i}&sort=${sort}&dir=${dir}">
                                                                        ${i + 1}
                                                                    </a>
                                                                </li>
                                                            </c:if>
                                                        </c:forEach>

                                                        <li class="page-item ${page.last ? 'disabled' : ''}">
                                                            <a class="page-link"
                                                                href="?q=${q}&page=${page.number + 1}&sort=${sort}&dir=${dir}">
                                                                <i class="bi bi-chevron-right"></i>
                                                            </a>
                                                        </li>
                                                    </ul>
                                                </nav>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Add Subject Modal -->
                        <div class="modal fade" id="addSubjectModal" tabindex="-1">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title">
                                            <i class="bi bi-plus-circle me-2"></i>Thêm môn học cho ngành
                                            ${major.majorCode}
                                        </h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                    </div>
                                    <form method="post" action="${contextPath}/admin/majors/${major.id}/subjects">
                                        <div class="modal-body">
                                            <div class="alert alert-info">
                                                <i class="bi bi-info-circle me-2"></i>
                                                Môn học sẽ được thêm vào ngành: <strong>${major.majorName}</strong>
                                            </div>
                                            <div class="mb-3">
                                                <label for="addSubjectCode" class="form-label">Mã môn học <span
                                                        class="text-danger">*</span></label>
                                                <input type="text" class="form-control" id="addSubjectCode"
                                                    name="subjectCode" placeholder="VD: CNTT101, TOAN102..." required
                                                    maxlength="20">
                                            </div>
                                            <div class="mb-3">
                                                <label for="addSubjectName" class="form-label">Tên môn học <span
                                                        class="text-danger">*</span></label>
                                                <input type="text" class="form-control" id="addSubjectName"
                                                    name="subjectName" placeholder="VD: Lập trình căn bản..." required
                                                    maxlength="200">
                                            </div>
                                            <div class="mb-3">
                                                <label for="addSubjectCredit" class="form-label">Số tín chỉ <span
                                                        class="text-danger">*</span></label>
                                                <input type="number" class="form-control" id="addSubjectCredit"
                                                    name="credit" min="1" max="10" value="3" required>
                                            </div>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-secondary"
                                                data-bs-dismiss="modal">Hủy</button>
                                            <button type="submit" class="btn btn-success">
                                                <i class="bi bi-check-lg me-1"></i>Thêm môn học
                                            </button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>

                        <!-- Delete Confirmation Modal -->
                        <div class="modal fade" id="deleteSubjectModal" tabindex="-1">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <div class="modal-header bg-danger text-white">
                                        <h5 class="modal-title">
                                            <i class="bi bi-exclamation-triangle me-2"></i>Xác nhận xóa
                                        </h5>
                                        <button type="button" class="btn-close btn-close-white"
                                            data-bs-dismiss="modal"></button>
                                    </div>
                                    <div class="modal-body">
                                        <p>Bạn có chắc chắn muốn xóa môn học <strong id="deleteSubjectName"></strong>?
                                        </p>
                                        <div class="alert alert-warning">
                                            <i class="bi bi-exclamation-triangle me-2"></i>
                                            <small>Lưu ý: Không thể xóa nếu đã có điểm số được ghi nhận cho môn học
                                                này.</small>
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary"
                                            data-bs-dismiss="modal">Hủy</button>
                                        <form method="post"
                                            action="${contextPath}/admin/majors/${major.id}/subjects/delete"
                                            style="display: inline;">
                                            <input type="hidden" id="deleteSubjectId" name="subjectId">
                                            <button type="submit" class="btn btn-danger">
                                                <i class="bi bi-trash me-1"></i>Xóa
                                            </button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <script
                            src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
                        <script>
                            // Delete Subject
                            function deleteSubject(id, code) {
                                document.getElementById('deleteSubjectId').value = id;
                                document.getElementById('deleteSubjectName').textContent = code;

                                const deleteModal = new bootstrap.Modal(document.getElementById('deleteSubjectModal'));
                                deleteModal.show();
                            }

                            // Auto-dismiss alerts
                            setTimeout(function () {
                                document.querySelectorAll('.alert').forEach(function (alert) {
                                    if (alert.querySelector('.btn-close')) {
                                        alert.querySelector('.btn-close').click();
                                    }
                                });
                            }, 5000);
                        </script>
            </body>

            </html>