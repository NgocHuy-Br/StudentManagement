<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <c:set var="contextPath" value="${pageContext.request.contextPath}" />
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Quản lý Ngành học - PTIT SMS</title>
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

                    .action-dropdown .dropdown-menu {
                        min-width: 160px;
                    }

                    .status-badge {
                        font-size: 0.8rem;
                    }
                </style>
            </head>

            <body class="bg-light">
                <!-- Header -->
                <%@ include file="../common/header.jsp" %>

                    <!-- Navigation -->
                    <%@ include file="_nav.jsp" %>

                        <div class="container-fluid py-4">
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
                                                <i class="bi bi-mortarboard-fill me-2"></i>
                                                Quản lý Ngành học
                                            </h5>
                                            <button type="button" class="btn btn-success" data-bs-toggle="modal"
                                                data-bs-target="#addMajorModal">
                                                <i class="bi bi-plus-lg me-1"></i>Thêm ngành học
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
                                                                placeholder="Tìm kiếm theo mã ngành, tên ngành...">
                                                            <input type="hidden" name="sort" value="${sort}">
                                                            <input type="hidden" name="dir" value="${dir}">
                                                            <button class="btn btn-outline-primary" type="submit">
                                                                Tìm kiếm
                                                            </button>
                                                            <c:if test="${not empty q}">
                                                                <a href="${contextPath}/admin/majors"
                                                                    class="btn btn-outline-secondary">
                                                                    <i class="bi bi-x"></i>
                                                                </a>
                                                            </c:if>
                                                        </div>
                                                    </form>
                                                </div>
                                                <div class="col-md-6 text-end">
                                                    <span class="text-muted">
                                                        Tổng: ${page.totalElements} ngành học
                                                    </span>
                                                </div>
                                            </div>

                                            <!-- Table -->
                                            <div class="table-responsive">
                                                <table class="table table-hover align-middle">
                                                    <thead class="table-light">
                                                        <tr>
                                                            <th>
                                                                <a href="?q=${q}&sort=majorCode&dir=${sort == 'majorCode' and dir == 'asc' ? 'desc' : 'asc'}"
                                                                    class="text-decoration-none">
                                                                    Mã ngành
                                                                    <c:if test="${sort == 'majorCode'}">
                                                                        <i
                                                                            class="bi bi-arrow-${dir == 'asc' ? 'up' : 'down'}"></i>
                                                                    </c:if>
                                                                </a>
                                                            </th>
                                                            <th>
                                                                <a href="?q=${q}&sort=majorName&dir=${sort == 'majorName' and dir == 'asc' ? 'desc' : 'asc'}"
                                                                    class="text-decoration-none">
                                                                    Tên ngành
                                                                    <c:if test="${sort == 'majorName'}">
                                                                        <i
                                                                            class="bi bi-arrow-${dir == 'asc' ? 'up' : 'down'}"></i>
                                                                    </c:if>
                                                                </a>
                                                            </th>
                                                            <th>Mô tả</th>
                                                            <th class="text-center">Số môn học</th>
                                                            <th class="text-center">Số sinh viên</th>
                                                            <th class="text-center">Thao tác</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:choose>
                                                            <c:when test="${empty page.content}">
                                                                <tr>
                                                                    <td colspan="6" class="text-center py-4 text-muted">
                                                                        <i
                                                                            class="bi bi-inbox display-1 d-block mb-3"></i>
                                                                        Không tìm thấy ngành học nào
                                                                        <c:if test="${not empty q}">
                                                                            <br><small>với từ khóa "${q}"</small>
                                                                        </c:if>
                                                                    </td>
                                                                </tr>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <c:forEach items="${page.content}" var="major">
                                                                    <tr>
                                                                        <td class="fw-semibold text-primary">
                                                                            ${major.majorCode}</td>
                                                                        <td class="fw-medium">${major.majorName}</td>
                                                                        <td>
                                                                            <c:choose>
                                                                                <c:when
                                                                                    test="${not empty major.description}">
                                                                                    <c:choose>
                                                                                        <c:when
                                                                                            test="${major.description.length() > 50}">
                                                                                            <span
                                                                                                class="description-short">
                                                                                                ${major.description.substring(0,
                                                                                                50)}...
                                                                                            </span>
                                                                                            <span
                                                                                                class="description-full d-none">
                                                                                                ${major.description}
                                                                                            </span>
                                                                                            <button
                                                                                                class="btn btn-link btn-sm p-0 ms-1 toggle-description">
                                                                                                <small>Xem thêm</small>
                                                                                            </button>
                                                                                        </c:when>
                                                                                        <c:otherwise>
                                                                                            ${major.description}
                                                                                        </c:otherwise>
                                                                                    </c:choose>
                                                                                </c:when>
                                                                                <c:otherwise>
                                                                                    <span
                                                                                        class="text-muted fst-italic">Chưa
                                                                                        có mô tả</span>
                                                                                </c:otherwise>
                                                                            </c:choose>
                                                                        </td>
                                                                        <td class="text-center">
                                                                            <!-- TODO: Count subjects by major -->
                                                                            <span class="badge bg-info">N/A</span>
                                                                        </td>
                                                                        <td class="text-center">
                                                                            <!-- TODO: Count students by major -->
                                                                            <span class="badge bg-secondary">N/A</span>
                                                                        </td>
                                                                        <td class="text-center">
                                                                            <div class="dropdown action-dropdown">
                                                                                <button
                                                                                    class="btn btn-sm btn-outline-primary dropdown-toggle"
                                                                                    type="button"
                                                                                    data-bs-toggle="dropdown">
                                                                                    <i class="bi bi-gear me-1"></i>Thao
                                                                                    tác
                                                                                </button>
                                                                                <ul class="dropdown-menu">
                                                                                    <li>
                                                                                        <a class="dropdown-item"
                                                                                            href="${contextPath}/admin/majors/${major.id}/subjects">
                                                                                            <i
                                                                                                class="bi bi-book text-primary me-2"></i>
                                                                                            Quản lý môn học
                                                                                        </a>
                                                                                    </li>
                                                                                    <li>
                                                                                        <hr class="dropdown-divider">
                                                                                    </li>
                                                                                    <li>
                                                                                        <button
                                                                                            class="dropdown-item edit-major-btn"
                                                                                            data-id="${major.id}"
                                                                                            data-code="${major.majorCode}"
                                                                                            data-name="${major.majorName}"
                                                                                            data-description="${major.description}">
                                                                                            <i
                                                                                                class="bi bi-pencil text-warning me-2"></i>
                                                                                            Chỉnh sửa
                                                                                        </button>
                                                                                    </li>
                                                                                    <li>
                                                                                        <button
                                                                                            class="dropdown-item text-danger delete-major-btn"
                                                                                            data-id="${major.id}"
                                                                                            data-code="${major.majorCode}">
                                                                                            <i
                                                                                                class="bi bi-trash me-2"></i>
                                                                                            Xóa
                                                                                        </button>
                                                                                    </li>
                                                                                </ul>
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

                        <!-- Add Major Modal -->
                        <div class="modal fade" id="addMajorModal" tabindex="-1">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title">
                                            <i class="bi bi-plus-circle me-2"></i>Thêm ngành học mới
                                        </h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                    </div>
                                    <form method="post" action="${contextPath}/admin/majors">
                                        <div class="modal-body">
                                            <div class="mb-3">
                                                <label for="addMajorCode" class="form-label">Mã ngành <span
                                                        class="text-danger">*</span></label>
                                                <input type="text" class="form-control" id="addMajorCode"
                                                    name="majorCode" placeholder="VD: CNTT, DTVT..." required
                                                    maxlength="20">
                                            </div>
                                            <div class="mb-3">
                                                <label for="addMajorName" class="form-label">Tên ngành <span
                                                        class="text-danger">*</span></label>
                                                <input type="text" class="form-control" id="addMajorName"
                                                    name="majorName" placeholder="VD: Công nghệ thông tin..." required
                                                    maxlength="200">
                                            </div>
                                            <div class="mb-3">
                                                <label for="addMajorDescription" class="form-label">Mô tả</label>
                                                <textarea class="form-control" id="addMajorDescription"
                                                    name="description" rows="3" maxlength="500"
                                                    placeholder="Mô tả về ngành học (tùy chọn)"></textarea>
                                            </div>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-secondary"
                                                data-bs-dismiss="modal">Hủy</button>
                                            <button type="submit" class="btn btn-success">
                                                <i class="bi bi-check-lg me-1"></i>Thêm ngành học
                                            </button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>

                        <!-- Edit Major Modal -->
                        <div class="modal fade" id="editMajorModal" tabindex="-1">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title">
                                            <i class="bi bi-pencil-square me-2"></i>Chỉnh sửa ngành học
                                        </h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                    </div>
                                    <form method="post" action="${contextPath}/admin/majors/edit">
                                        <div class="modal-body">
                                            <input type="hidden" id="editMajorId" name="id">
                                            <div class="mb-3">
                                                <label for="editMajorCode" class="form-label">Mã ngành <span
                                                        class="text-danger">*</span></label>
                                                <input type="text" class="form-control" id="editMajorCode"
                                                    name="majorCode" required maxlength="20">
                                            </div>
                                            <div class="mb-3">
                                                <label for="editMajorName" class="form-label">Tên ngành <span
                                                        class="text-danger">*</span></label>
                                                <input type="text" class="form-control" id="editMajorName"
                                                    name="majorName" required maxlength="200">
                                            </div>
                                            <div class="mb-3">
                                                <label for="editMajorDescription" class="form-label">Mô tả</label>
                                                <textarea class="form-control" id="editMajorDescription"
                                                    name="description" rows="3" maxlength="500"></textarea>
                                            </div>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-secondary"
                                                data-bs-dismiss="modal">Hủy</button>
                                            <button type="submit" class="btn btn-warning">
                                                <i class="bi bi-check-lg me-1"></i>Cập nhật
                                            </button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>

                        <!-- Delete Confirmation Modal -->
                        <div class="modal fade" id="deleteMajorModal" tabindex="-1">
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
                                        <p>Bạn có chắc chắn muốn xóa ngành học <strong id="deleteMajorName"></strong>?
                                        </p>
                                        <div class="alert alert-warning">
                                            <i class="bi bi-exclamation-triangle me-2"></i>
                                            <small>Lưu ý: Không thể xóa nếu còn sinh viên hoặc môn học thuộc ngành
                                                này.</small>
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary"
                                            data-bs-dismiss="modal">Hủy</button>
                                        <form method="post" action="${contextPath}/admin/majors/delete"
                                            style="display: inline;">
                                            <input type="hidden" id="deleteMajorId" name="id">
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
                            // Edit Major using event delegation
                            document.addEventListener('click', function (e) {
                                if (e.target.closest('.edit-major-btn')) {
                                    const btn = e.target.closest('.edit-major-btn');
                                    const id = btn.dataset.id;
                                    const code = btn.dataset.code;
                                    const name = btn.dataset.name;
                                    const description = btn.dataset.description || '';

                                    document.getElementById('editMajorId').value = id;
                                    document.getElementById('editMajorCode').value = code;
                                    document.getElementById('editMajorName').value = name;
                                    document.getElementById('editMajorDescription').value = description;

                                    const editModal = new bootstrap.Modal(document.getElementById('editMajorModal'));
                                    editModal.show();
                                }

                                if (e.target.closest('.delete-major-btn')) {
                                    const btn = e.target.closest('.delete-major-btn');
                                    const id = btn.dataset.id;
                                    const code = btn.dataset.code;

                                    document.getElementById('deleteMajorId').value = id;
                                    document.getElementById('deleteMajorName').textContent = code;

                                    const deleteModal = new bootstrap.Modal(document.getElementById('deleteMajorModal'));
                                    deleteModal.show();
                                }
                            });

                            // Toggle description
                            document.addEventListener('DOMContentLoaded', function () {
                                document.querySelectorAll('.toggle-description').forEach(button => {
                                    button.addEventListener('click', function () {
                                        const row = this.closest('td');
                                        const shortDesc = row.querySelector('.description-short');
                                        const fullDesc = row.querySelector('.description-full');

                                        if (shortDesc.classList.contains('d-none')) {
                                            shortDesc.classList.remove('d-none');
                                            fullDesc.classList.add('d-none');
                                            this.innerHTML = '<small>Xem thêm</small>';
                                        } else {
                                            shortDesc.classList.add('d-none');
                                            fullDesc.classList.remove('d-none');
                                            this.innerHTML = '<small>Thu gọn</small>';
                                        }
                                    });
                                });
                            });

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