<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1">
                <title>Quản lý khoa</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
                <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
                    rel="stylesheet">
                <style>
                    body {
                        background: #f7f7f9
                    }

                    .card {
                        border-radius: 12px;
                        box-shadow: 0 10px 25px rgba(0, 0, 0, .06)
                    }

                    .faculty-toolbar .search .form-control {
                        min-width: 200px;
                        max-width: 300px
                    }

                    .search-clear-btn {
                        border: 1px solid #dee2e6;
                        border-left: 0;
                        background: white;
                        cursor: pointer;
                        border-radius: 0 0.375rem 0.375rem 0
                    }

                    .search-clear-btn:hover {
                        background: #f8f9fa
                    }

                    .table-faculties tbody tr:hover {
                        background: #fffaf7;
                    }

                    .sort-link {
                        text-decoration: none;
                        color: inherit
                    }

                    .sort-link .bi {
                        opacity: .5
                    }

                    /* Đảm bảo dropdown không bị che */
                    .table-responsive {
                        overflow: visible;
                    }

                    .dropdown-menu {
                        z-index: 1050;
                    }

                    .faculty-badge {
                        font-size: 0.85em;
                        padding: 0.3em 0.6em;
                    }
                </style>
            </head>

            <body>
                <div class="container-fluid" style="padding: 0 clamp(12px, 4vw, 36px);">
                    <%@ include file="../common/header.jsp" %>

                        <c:set var="activeTab" value="faculties" scope="request" />
                        <%@ include file="_nav.jsp" %>

                            <div class="card mt-3">
                                <div class="card-body">
                                    <!-- Flash messages -->
                                    <c:if test="${not empty success}">
                                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                                            ${success}
                                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                        </div>
                                    </c:if>
                                    <c:if test="${not empty error}">
                                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                            ${error}
                                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                        </div>
                                    </c:if>

                                    <!-- Toolbar: tìm kiếm + Thêm mới -->
                                    <form class="faculty-toolbar d-flex flex-wrap align-items-center gap-2 mb-3"
                                        method="get" action="">
                                        <div class="d-flex">
                                            <div class="input-group search">
                                                <span class="input-group-text"><i class="bi bi-search"></i></span>
                                                <input name="q" id="searchInput" class="form-control"
                                                    placeholder="Tìm tên khoa, mô tả..." value="${q}" />
                                            </div>
                                            <c:if test="${not empty q}">
                                                <button type="button" class="btn search-clear-btn"
                                                    onclick="clearSearch()" title="Xóa tìm kiếm">
                                                    <i class="bi bi-x"></i>
                                                </button>
                                            </c:if>
                                        </div>

                                        <div class="ms-auto"></div>

                                        <label class="me-1 text-muted small">Hiển thị</label>
                                        <select class="form-select" name="size" style="width:100px"
                                            onchange="this.form.submit()">
                                            <option value="10" ${param.size=='10' ?'selected':''}>10</option>
                                            <option value="20" ${param.size=='20' ?'selected':''}>20</option>
                                            <option value="50" ${param.size=='50' ?'selected':''}>50</option>
                                            <option value="100" ${param.size=='100' ?'selected':''}>100</option>
                                        </select>
                                        <input type="hidden" name="sort" value="${sort}">
                                        <input type="hidden" name="dir" value="${dir}">

                                        <button type="button" class="btn btn-primary ms-auto" data-bs-toggle="modal"
                                            data-bs-target="#modalCreate">
                                            <i class="bi bi-plus-lg me-1"></i> Thêm mới
                                        </button>
                                    </form>

                                    <!-- Bảng danh sách khoa -->
                                    <div class="table-responsive">
                                        <table class="table table-hover align-middle table-faculties">
                                            <thead class="table-light">
                                                <tr>
                                                    <th width="60px">STT</th>
                                                    <th width="120px">Mã khoa
                                                        <a class="sort-link"
                                                            href="?q=${fn:escapeXml(q)}&size=${page.size}&sort=facultyCode&dir=${dir=='asc' && sort=='facultyCode' ? 'desc' : 'asc'}">
                                                            <i class="bi bi-arrow-down-up"></i>
                                                        </a>
                                                    </th>
                                                    <th width="220px">Tên khoa
                                                        <a class="sort-link"
                                                            href="?q=${fn:escapeXml(q)}&size=${page.size}&sort=name&dir=${dir=='asc' && sort=='name' ? 'desc' : 'asc'}">
                                                            <i class="bi bi-arrow-down-up"></i>
                                                        </a>
                                                    </th>
                                                    <th width="180px">Mô tả</th>
                                                    <th width="100px" class="text-center">Số ngành
                                                        <a class="sort-link"
                                                            href="?q=${fn:escapeXml(q)}&size=${page.size}&sort=majorCount&dir=${dir=='asc' && sort=='majorCount' ? 'desc' : 'asc'}">
                                                            <i class="bi bi-arrow-down-up"></i>
                                                        </a>
                                                    </th>
                                                    <th width="100px" class="text-center">Số giáo viên
                                                        <a class="sort-link"
                                                            href="?q=${fn:escapeXml(q)}&size=${page.size}&sort=teacherCount&dir=${dir=='asc' && sort=='teacherCount' ? 'desc' : 'asc'}">
                                                            <i class="bi bi-arrow-down-up"></i>
                                                        </a>
                                                    </th>
                                                    <th width="100px" class="text-center">Số sinh viên
                                                        <a class="sort-link"
                                                            href="?q=${fn:escapeXml(q)}&size=${page.size}&sort=studentCount&dir=${dir=='asc' && sort=='studentCount' ? 'desc' : 'asc'}">
                                                            <i class="bi bi-arrow-down-up"></i>
                                                        </a>
                                                    </th>
                                                    <th width="120px" class="text-center">Thao tác</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:if test="${page.totalElements == 0}">
                                                    <tr>
                                                        <td colspan="8" class="text-center text-muted py-4">Chưa có khoa
                                                            nào.</td>
                                                    </tr>
                                                </c:if>

                                                <c:forEach var="faculty" items="${page.content}" varStatus="status">
                                                    <tr>
                                                        <td class="text-center fw-semibold text-muted">${status.index +
                                                            1 + (page.number * page.size)}</td>
                                                        <td><span class="badge bg-primary">${faculty.facultyCode}</span>
                                                        </td>
                                                        <td>${faculty.name}</td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${not empty faculty.description}">
                                                                    ${faculty.description}
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="text-muted">Chưa có mô tả</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td class="text-center">
                                                            <span
                                                                class="badge faculty-badge bg-info">${facultyStats[faculty.id]['majorCount']}</span>
                                                        </td>
                                                        <td class="text-center">
                                                            <span
                                                                class="badge faculty-badge bg-success">${facultyStats[faculty.id]['teacherCount']}</span>
                                                        </td>
                                                        <td class="text-center">
                                                            <span
                                                                class="badge faculty-badge bg-warning">${facultyStats[faculty.id]['studentCount']}</span>
                                                        </td>
                                                        <td>
                                                            <!-- Direct Action Buttons -->
                                                            <div class="d-flex gap-1 justify-content-center">
                                                                <button type="button"
                                                                    class="btn btn-sm btn-outline-primary edit-faculty"
                                                                    data-faculty-id="${faculty.id}"
                                                                    data-faculty-code="${fn:escapeXml(faculty.facultyCode)}"
                                                                    data-name="${fn:escapeXml(faculty.name)}"
                                                                    data-description="${fn:escapeXml(faculty.description)}"
                                                                    data-bs-toggle="tooltip" data-bs-placement="top"
                                                                    title="Chỉnh sửa">
                                                                    <i class="bi bi-pencil-square"></i>
                                                                </button>
                                                                <button type="button"
                                                                    class="btn btn-sm btn-outline-danger delete-faculty"
                                                                    data-faculty-id="${faculty.id}"
                                                                    data-faculty-code="${fn:escapeXml(faculty.facultyCode)}"
                                                                    data-name="${fn:escapeXml(faculty.name)}"
                                                                    data-bs-toggle="tooltip" data-bs-placement="top"
                                                                    title="Xóa">
                                                                    <i class="bi bi-trash"></i>
                                                                </button>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>

                                    <!-- Phân trang -->
                                    <c:if test="${page.totalPages > 1}">
                                        <nav class="d-flex justify-content-end">
                                            <ul class="pagination pagination-sm mb-0">
                                                <li class="page-item ${page.first ? 'disabled' : ''}">
                                                    <a class="page-link"
                                                        href="?q=${fn:escapeXml(q)}&page=${page.number-1}&size=${page.size}&sort=${sort}&dir=${dir}">«</a>
                                                </li>
                                                <c:forEach var="i" begin="0" end="${page.totalPages-1}">
                                                    <li class="page-item ${i==page.number ? 'active' : ''}">
                                                        <a class="page-link"
                                                            href="?q=${fn:escapeXml(q)}&page=${i}&size=${page.size}&sort=${sort}&dir=${dir}">${i+1}</a>
                                                    </li>
                                                </c:forEach>
                                                <li class="page-item ${page.last ? 'disabled' : ''}">
                                                    <a class="page-link"
                                                        href="?q=${fn:escapeXml(q)}&page=${page.number+1}&size=${page.size}&sort=${sort}&dir=${dir}">»</a>
                                                </li>
                                            </ul>
                                        </nav>
                                    </c:if>
                                </div>
                            </div>
                </div>
                </div>

                <!-- Modal: Thêm khoa -->
                <div class="modal fade" id="modalCreate" tabindex="-1" aria-hidden="true">
                    <div class="modal-dialog modal-lg modal-dialog-centered">
                        <form class="modal-content" method="post"
                            action="${pageContext.request.contextPath}/admin/faculties">
                            <div class="modal-header">
                                <h5 class="modal-title">
                                    <i class="bi bi-plus-circle me-2"></i>Thêm khoa mới
                                </h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                            </div>
                            <div class="modal-body">
                                <div class="mb-3">
                                    <label for="createFacultyCode" class="form-label">Mã khoa <span
                                            class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="createFacultyCode" name="facultyCode"
                                        placeholder="Nhập mã khoa (vd: CNTT, KTMT)" required maxlength="20">
                                </div>
                                <div class="mb-3">
                                    <label for="createName" class="form-label">Tên khoa <span
                                            class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="createName" name="name"
                                        placeholder="Nhập tên khoa" required>
                                </div>
                                <div class="mb-3">
                                    <label for="createDescription" class="form-label">Mô tả</label>
                                    <textarea class="form-control" id="createDescription" name="description" rows="3"
                                        placeholder="Mô tả về khoa (tùy chọn)"></textarea>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                                <button type="submit" class="btn btn-primary">
                                    <i class="bi bi-check-lg me-1"></i>Lưu
                                </button>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Modal: Chỉnh sửa khoa -->
                <div class="modal fade" id="modalEdit" tabindex="-1" aria-hidden="true">
                    <div class="modal-dialog modal-lg modal-dialog-centered">
                        <form class="modal-content" method="post" id="editForm">
                            <input type="hidden" id="editId" name="id">
                            <div class="modal-header">
                                <h5 class="modal-title">
                                    <i class="bi bi-pencil-square me-2"></i>Chỉnh sửa khoa
                                </h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                            </div>
                            <div class="modal-body">
                                <div class="mb-3">
                                    <label for="editFacultyCode" class="form-label">Mã khoa <span
                                            class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="editFacultyCode" name="facultyCode"
                                        required maxlength="20">
                                </div>
                                <div class="mb-3">
                                    <label for="editName" class="form-label">Tên khoa <span
                                            class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="editName" name="name" required>
                                </div>
                                <div class="mb-3">
                                    <label for="editDescription" class="form-label">Mô tả</label>
                                    <textarea class="form-control" id="editDescription" name="description"
                                        rows="3"></textarea>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                                <button type="submit" class="btn btn-primary">
                                    <i class="bi bi-check-lg me-1"></i>Cập nhật
                                </button>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Modal: Xác nhận xóa -->
                <div class="modal fade" id="modalDelete" tabindex="-1" aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title text-danger">
                                    <i class="bi bi-exclamation-triangle me-2"></i>Xác nhận xóa
                                </h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                            </div>
                            <div class="modal-body">
                                <p>Bạn có chắc chắn muốn xóa khoa <strong id="deleteFacultyName"
                                        class="text-danger"></strong> không?</p>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                                <form method="post" id="deleteForm" class="d-inline">
                                    <input type="hidden" id="deleteId" name="id">
                                    <button type="submit" class="btn btn-danger">
                                        <i class="bi bi-trash me-1"></i>Xác nhận xóa
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
                <script>
                    // Get context path from JSP
                    const contextPath = '${pageContext.request.contextPath}';

                    document.addEventListener('DOMContentLoaded', function () {
                        // Initialize tooltips
                        var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
                        var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
                            return new bootstrap.Tooltip(tooltipTriggerEl);
                        });

                        // Handle Edit Faculty
                        const editButtons = document.querySelectorAll('.edit-faculty');
                        editButtons.forEach(button => {
                            button.addEventListener('click', function (e) {
                                e.preventDefault();
                                const id = this.getAttribute('data-faculty-id');
                                const facultyCode = this.getAttribute('data-faculty-code');
                                const name = this.getAttribute('data-name');
                                const description = this.getAttribute('data-description');

                                document.getElementById('editId').value = id;
                                document.getElementById('editFacultyCode').value = facultyCode || '';
                                document.getElementById('editName').value = name || '';
                                document.getElementById('editDescription').value = description || '';

                                // Set form action
                                const editForm = document.getElementById('editForm');
                                editForm.action = contextPath + '/admin/faculties/' + id;

                                // Show modal
                                const modal = new bootstrap.Modal(document.getElementById('modalEdit'));
                                modal.show();
                            });
                        });

                        // Handle Delete Faculty
                        const deleteButtons = document.querySelectorAll('.delete-faculty');
                        deleteButtons.forEach(button => {
                            button.addEventListener('click', function (e) {
                                e.preventDefault();
                                const id = this.getAttribute('data-faculty-id');
                                const facultyCode = this.getAttribute('data-faculty-code');
                                const name = this.getAttribute('data-name');

                                document.getElementById('deleteId').value = id;
                                document.getElementById('deleteFacultyName').textContent = name || '';

                                // Set form action
                                const deleteForm = document.getElementById('deleteForm');
                                deleteForm.action = contextPath + '/admin/faculties/' + id + '/delete';

                                // Show modal
                                const modal = new bootstrap.Modal(document.getElementById('modalDelete'));
                                modal.show();
                            });
                        });

                        // Function to clear search
                        window.clearSearch = function () {
                            const searchInput = document.getElementById('searchInput');
                            searchInput.value = '';

                            // Get current URL without query params
                            const url = new URL(window.location);
                            url.searchParams.delete('q'); // Remove search query
                            url.searchParams.set('page', '0'); // Reset to first page

                            // Redirect to the new URL
                            window.location.href = url.toString();
                        };

                        // Faculty validation functions
                        window.validateFacultyCode = function (facultyCode, excludeId = null) {
                            return fetch(contextPath + '/admin/faculties/check-code?facultyCode=' + encodeURIComponent(facultyCode) +
                                (excludeId ? '&excludeId=' + excludeId : ''))
                                .then(response => response.json())
                                .then(data => data.exists);
                        };

                        window.validateFacultyName = function (name, excludeId = null) {
                            return fetch(contextPath + '/admin/faculties/check-name?name=' + encodeURIComponent(name) +
                                (excludeId ? '&excludeId=' + excludeId : ''))
                                .then(response => response.json())
                                .then(data => data.exists);
                        };

                        // Add validation to create form
                        const createForm = document.querySelector('#modalCreate form');
                        if (createForm) {
                            createForm.addEventListener('submit', async function (e) {
                                e.preventDefault();

                                const submitBtn = this.querySelector('button[type="submit"]');
                                const originalText = submitBtn.innerHTML;

                                // Show loading state
                                submitBtn.disabled = true;
                                submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-1"></span>Đang kiểm tra...';

                                const facultyCode = document.getElementById('createFacultyCode').value.trim();
                                const name = document.getElementById('createName').value.trim();

                                if (!facultyCode || !name) {
                                    alert('Vui lòng nhập đầy đủ mã khoa và tên khoa.');
                                    submitBtn.disabled = false;
                                    submitBtn.innerHTML = originalText;
                                    return;
                                }

                                try {
                                    const [codeExists, nameExists] = await Promise.all([
                                        validateFacultyCode(facultyCode),
                                        validateFacultyName(name)
                                    ]);

                                    if (codeExists) {
                                        alert('Mã khoa "' + facultyCode + '" đã tồn tại. Vui lòng chọn mã khác.');
                                        document.getElementById('createFacultyCode').focus();
                                        submitBtn.disabled = false;
                                        submitBtn.innerHTML = originalText;
                                        return;
                                    }

                                    if (nameExists) {
                                        alert('Tên khoa "' + name + '" đã tồn tại. Vui lòng chọn tên khác.');
                                        document.getElementById('createName').focus();
                                        submitBtn.disabled = false;
                                        submitBtn.innerHTML = originalText;
                                        return;
                                    }

                                    // If validation passes, submit the form
                                    submitBtn.innerHTML = '<i class="bi bi-check-lg me-1"></i>Lưu';
                                    this.submit();
                                } catch (error) {
                                    console.error('Validation error:', error);
                                    submitBtn.disabled = false;
                                    submitBtn.innerHTML = originalText;
                                    // If validation fails, still allow submission (server will handle it)
                                    this.submit();
                                }
                            });
                        }

                        // Add validation to edit form
                        const editForm = document.getElementById('editForm');
                        if (editForm) {
                            editForm.addEventListener('submit', async function (e) {
                                e.preventDefault();

                                const submitBtn = this.querySelector('button[type="submit"]');
                                const originalText = submitBtn.innerHTML;

                                // Show loading state
                                submitBtn.disabled = true;
                                submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-1"></span>Đang kiểm tra...';

                                const facultyCode = document.getElementById('editFacultyCode').value.trim();
                                const name = document.getElementById('editName').value.trim();
                                const excludeId = document.getElementById('editId').value;

                                if (!facultyCode || !name) {
                                    alert('Vui lòng nhập đầy đủ mã khoa và tên khoa.');
                                    submitBtn.disabled = false;
                                    submitBtn.innerHTML = originalText;
                                    return;
                                }

                                try {
                                    const [codeExists, nameExists] = await Promise.all([
                                        validateFacultyCode(facultyCode, excludeId),
                                        validateFacultyName(name, excludeId)
                                    ]);

                                    if (codeExists) {
                                        alert('Mã khoa "' + facultyCode + '" đã tồn tại. Vui lòng chọn mã khác.');
                                        document.getElementById('editFacultyCode').focus();
                                        submitBtn.disabled = false;
                                        submitBtn.innerHTML = originalText;
                                        return;
                                    }

                                    if (nameExists) {
                                        alert('Tên khoa "' + name + '" đã tồn tại. Vui lòng chọn tên khác.');
                                        document.getElementById('editName').focus();
                                        submitBtn.disabled = false;
                                        submitBtn.innerHTML = originalText;
                                        return;
                                    }

                                    // If validation passes, submit the form
                                    submitBtn.innerHTML = '<i class="bi bi-check-lg me-1"></i>Cập nhật';
                                    this.submit();
                                } catch (error) {
                                    console.error('Validation error:', error);
                                    submitBtn.disabled = false;
                                    submitBtn.innerHTML = originalText;
                                    // If validation fails, still allow submission (server will handle it)
                                    this.submit();
                                }
                            });
                        }
                    });
                </script>
            </body>

            </html>