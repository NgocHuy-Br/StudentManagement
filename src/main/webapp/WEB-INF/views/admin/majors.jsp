<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Quản lý Ngành học</title>
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
                        rel="stylesheet">
                    <link rel="stylesheet"
                        href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
                    <style>
                        body {
                            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                        }
                    </style>
                </head>

                <body>
                    <%@include file="../common/header.jsp" %>

                        <div class="container-fluid my-4">
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

                                <div class="row">
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
                                                                <button class="btn btn-outline-primary"
                                                                    type="submit">Tìm kiếm</button>
                                                                <c:if test="${not empty q}">
                                                                    <a href="${pageContext.request.contextPath}/admin/majors"
                                                                        class="btn btn-outline-secondary">
                                                                        <i class="bi bi-x-circle"></i> Xóa bộ lọc
                                                                    </a>
                                                                </c:if>
                                                            </div>
                                                        </form>
                                                    </div>
                                                    <div class="col-md-6 text-end">
                                                        <span class="text-muted">
                                                            Tổng: ${fn:length(majors)} ngành học
                                                        </span>
                                                    </div>
                                                </div>

                                                <!-- Table -->
                                                <div class="table-responsive">
                                                    <table class="table table-hover align-middle">
                                                        <thead class="table-light">
                                                            <tr>
                                                                <th>Mã ngành</th>
                                                                <th>Tên ngành</th>
                                                                <th>Mô tả</th>
                                                                <th class="text-center">Số môn học</th>
                                                                <th class="text-center">Thao tác</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <c:choose>
                                                                <c:when test="${empty majors}">
                                                                    <tr>
                                                                        <td colspan="5"
                                                                            class="text-center py-4 text-muted">
                                                                            <i
                                                                                class="bi bi-inbox display-1 d-block mb-3"></i>
                                                                            Không tìm thấy ngành học nào
                                                                        </td>
                                                                    </tr>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <c:forEach items="${majors}" var="major">
                                                                        <tr>
                                                                            <td class="fw-semibold text-primary">
                                                                                ${major.majorCode}</td>
                                                                            <td class="fw-medium">${major.majorName}
                                                                            </td>
                                                                            <td>
                                                                                <c:choose>
                                                                                    <c:when
                                                                                        test="${not empty major.description}">
                                                                                        ${major.description}
                                                                                    </c:when>
                                                                                    <c:otherwise>
                                                                                        <span
                                                                                            class="text-muted fst-italic">Chưa
                                                                                            có mô tả</span>
                                                                                    </c:otherwise>
                                                                                </c:choose>
                                                                            </td>
                                                                            <td class="text-center">
                                                                                <span
                                                                                    class="badge bg-info">${fn:length(major.subjects)}</span>
                                                                            </td>
                                                                            <td class="text-center">
                                                                                <button
                                                                                    class="btn btn-sm btn-outline-warning me-1 edit-major-btn"
                                                                                    data-id="${major.id}"
                                                                                    data-code="${major.majorCode}"
                                                                                    data-name="${major.majorName}"
                                                                                    data-description="${major.description}">
                                                                                    <i class="bi bi-pencil"></i> Sửa
                                                                                </button>
                                                                                <button
                                                                                    class="btn btn-sm btn-outline-danger delete-major-btn"
                                                                                    data-id="${major.id}"
                                                                                    data-code="${major.majorCode}">
                                                                                    <i class="bi bi-trash"></i> Xóa
                                                                                </button>
                                                                            </td>
                                                                        </tr>
                                                                    </c:forEach>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                        </div>

                        <!-- Add Major Modal -->
                        <div class="modal fade" id="addMajorModal" tabindex="-1">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <form method="post" action="${pageContext.request.contextPath}/admin/majors">
                                        <div class="modal-header">
                                            <h5 class="modal-title">Thêm ngành học mới</h5>
                                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                        </div>
                                        <div class="modal-body">
                                            <div class="mb-3">
                                                <label class="form-label">Mã ngành</label>
                                                <input type="text" class="form-control" name="majorCode" required
                                                    placeholder="VD: CNTT">
                                            </div>
                                            <div class="mb-3">
                                                <label class="form-label">Tên ngành</label>
                                                <input type="text" class="form-control" name="majorName" required
                                                    placeholder="VD: Công nghệ thông tin">
                                            </div>
                                            <div class="mb-3">
                                                <label class="form-label">Mô tả</label>
                                                <textarea class="form-control" name="description" rows="3"
                                                    placeholder="Mô tả về ngành học"></textarea>
                                            </div>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-secondary"
                                                data-bs-dismiss="modal">Hủy</button>
                                            <button type="submit" class="btn btn-success">Thêm ngành học</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>

                        <!-- Edit Major Modal -->
                        <div class="modal fade" id="editMajorModal" tabindex="-1">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <form method="post" action="${pageContext.request.contextPath}/admin/majors/edit">
                                        <div class="modal-header">
                                            <h5 class="modal-title">Chỉnh sửa ngành học</h5>
                                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                        </div>
                                        <div class="modal-body">
                                            <input type="hidden" id="editMajorId" name="id">
                                            <div class="mb-3">
                                                <label class="form-label">Mã ngành</label>
                                                <input type="text" class="form-control" id="editMajorCode"
                                                    name="majorCode" required>
                                            </div>
                                            <div class="mb-3">
                                                <label class="form-label">Tên ngành</label>
                                                <input type="text" class="form-control" id="editMajorName"
                                                    name="majorName" required>
                                            </div>
                                            <div class="mb-3">
                                                <label class="form-label">Mô tả</label>
                                                <textarea class="form-control" id="editMajorDescription"
                                                    name="description" rows="3"></textarea>
                                            </div>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-secondary"
                                                data-bs-dismiss="modal">Hủy</button>
                                            <button type="submit" class="btn btn-warning">Cập nhật</button>
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
                                        <h5 class="modal-title">Xác nhận xóa</h5>
                                        <button type="button" class="btn-close btn-close-white"
                                            data-bs-dismiss="modal"></button>
                                    </div>
                                    <div class="modal-body">
                                        <p>Bạn có chắc chắn muốn xóa ngành học <strong id="deleteMajorName"></strong>?
                                        </p>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary"
                                            data-bs-dismiss="modal">Hủy</button>
                                        <form method="post"
                                            action="${pageContext.request.contextPath}/admin/majors/delete"
                                            style="display: inline;">
                                            <input type="hidden" id="deleteMajorId" name="id">
                                            <button type="submit" class="btn btn-danger">Xóa</button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <script
                            src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
                        <script>
                            // Edit Major
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

                            // Enter key search
                            document.querySelector('input[name="q"]').addEventListener('keypress', function (e) {
                                if (e.key === 'Enter') {
                                    e.preventDefault();
                                    this.form.submit();
                                }
                            });
                        </script>
                </body>

                </html>