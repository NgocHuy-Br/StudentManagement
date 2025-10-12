<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1">
                <title>Quản lý môn học</title>
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

                    .subject-toolbar .search .form-control {
                        min-width: 260px
                    }

                    .table-subjects tbody tr:hover {
                        background: #fffaf7;
                    }

                    .sort-link {
                        text-decoration: none;
                        color: inherit
                    }

                    .sort-link .bi {
                        opacity: .5
                    }

                    .badge {
                        font-size: 0.75em;
                    }
                </style>
            </head>

            <body>
                <%@ include file="../common/header.jsp" %>
                    <main class="container-fluid main-wrap py-3">
                        <%@ include file="_nav.jsp" %>

                            <div class="card mt-3">
                                <div class="card-body">
                                    <!-- Toolbar -->
                                    <div class="d-flex justify-content-between align-items-center mb-3 subject-toolbar">
                                        <h5 class="mb-0"><i class="bi bi-book me-2"></i>Quản lý môn học & khoa</h5>
                                        <div class="btn-group">
                                            <button class="btn btn-primary" data-bs-toggle="modal"
                                                data-bs-target="#modalCreate">
                                                <i class="bi bi-plus-circle me-1"></i>Thêm môn học
                                            </button>
                                            <button class="btn btn-success" data-bs-toggle="modal"
                                                data-bs-target="#modalCreateFaculty">
                                                <i class="bi bi-building-add me-1"></i>Thêm khoa mới
                                            </button>
                                        </div>
                                    </div>

                                    <!-- Tabs Navigation -->
                                    <ul class="nav nav-tabs mb-3" id="subjectTabs" role="tablist">
                                        <li class="nav-item" role="presentation">
                                            <button class="nav-link active" id="subjects-tab" data-bs-toggle="tab"
                                                data-bs-target="#subjects-pane" type="button" role="tab">
                                                <i class="bi bi-book me-2"></i>Môn học
                                            </button>
                                        </li>
                                        <li class="nav-item" role="presentation">
                                            <button class="nav-link" id="faculties-tab" data-bs-toggle="tab"
                                                data-bs-target="#faculties-pane" type="button" role="tab">
                                                <i class="bi bi-building me-2"></i>Khoa
                                            </button>
                                        </li>
                                    </ul>

                                    <!-- Tab Content -->
                                    <div class="tab-content" id="subjectTabContent">
                                        <!-- Tab môn học -->
                                        <div class="tab-pane fade show active" id="subjects-pane" role="tabpanel">
                                            <!-- Error messages -->
                                            <c:if test="${not empty error}">
                                                <div class="alert alert-danger alert-dismissible">
                                                    <i class="bi bi-exclamation-triangle me-2"></i>${error}
                                                    <button type="button" class="btn-close"
                                                        data-bs-dismiss="alert"></button>
                                                </div>
                                            </c:if>
                                            <c:if test="${not empty success}">
                                                <div class="alert alert-success alert-dismissible">
                                                    <i class="bi bi-check-circle me-2"></i>${success}
                                                    <button type="button" class="btn-close"
                                                        data-bs-dismiss="alert"></button>
                                                </div>
                                            </c:if>

                                            <!-- Tìm kiếm và lọc -->
                                            <form method="get" class="d-flex gap-2 mb-3 flex-wrap">
                                                <div class="search flex-grow-1">
                                                    <div class="input-group">
                                                        <span class="input-group-text"><i
                                                                class="bi bi-search"></i></span>
                                                        <input class="form-control" name="q" value="${fn:escapeXml(q)}"
                                                            placeholder="Tìm mã môn, tên môn...">
                                                    </div>
                                                </div>
                                                <button class="btn btn-outline-primary" type="submit">Tìm</button>
                                                <c:if test="${not empty q}">
                                                    <a class="btn btn-outline-secondary" href="?">Xóa</a>
                                                </c:if>
                                            </form>

                                            <!-- Bảng danh sách môn học -->
                                            <div class="table-responsive">
                                                <table class="table table-hover align-middle table-subjects">
                                                    <thead class="table-light">
                                                        <tr>
                                                            <th>Mã môn
                                                                <a class="sort-link"
                                                                    href="?q=${fn:escapeXml(q)}&majorId=${majorId}&size=${page.size}&sort=subjectCode&dir=${dir=='asc' && sort=='subjectCode' ? 'desc' : 'asc'}">
                                                                    <i class="bi bi-arrow-down-up"></i>
                                                                </a>
                                                            </th>
                                                            <th>Tên môn học
                                                                <a class="sort-link"
                                                                    href="?q=${fn:escapeXml(q)}&majorId=${majorId}&size=${page.size}&sort=subjectName&dir=${dir=='asc' && sort=='subjectName' ? 'desc' : 'asc'}">
                                                                    <i class="bi bi-arrow-down-up"></i>
                                                                </a>
                                                            </th>
                                                            <th>Tín chỉ
                                                                <a class="sort-link"
                                                                    href="?q=${fn:escapeXml(q)}&size=${page.size}&sort=credit&dir=${dir=='asc' && sort=='credit' ? 'desc' : 'asc'}">
                                                                    <i class="bi bi-arrow-down-up"></i>
                                                                </a>
                                                            </th>
                                                            <th>Các ngành</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:if test="${page.totalElements == 0}">
                                                            <tr>
                                                                <td colspan="4" class="text-center text-muted py-4">Chưa
                                                                    có môn
                                                                    học nào.</td>
                                                            </tr>
                                                        </c:if>

                                                        <c:forEach var="sub" items="${page.content}">
                                                            <tr>
                                                                <td><strong>${sub.subjectCode}</strong></td>
                                                                <td>${sub.subjectName}</td>
                                                                <td>
                                                                    <span class="badge bg-info">${sub.credit} TC</span>
                                                                </td>
                                                                <td>
                                                                    <c:choose>
                                                                        <c:when test="${empty sub.majors}">
                                                                            <span class="text-muted">Chưa thuộc ngành
                                                                                nào</span>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <c:forEach var="major" items="${sub.majors}"
                                                                                varStatus="status">
                                                                                <span
                                                                                    class="badge bg-secondary me-1">${major.majorCode}</span>
                                                                                <c:if test="${!status.last}">
                                                                                </c:if>
                                                                            </c:forEach>
                                                                            <br>
                                                                            <c:forEach var="major" items="${sub.majors}"
                                                                                varStatus="status">
                                                                                <small
                                                                                    class="text-muted">${major.majorName}</small>
                                                                                <c:if test="${!status.last}">, </c:if>
                                                                            </c:forEach>
                                                                        </c:otherwise>
                                                                    </c:choose>
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

                                        <!-- Tab khoa -->
                                        <div class="tab-pane fade" id="faculties-pane" role="tabpanel">
                                            <!-- Bảng danh sách khoa -->
                                            <div class="table-responsive">
                                                <table class="table table-hover align-middle">
                                                    <thead class="table-light">
                                                        <tr>
                                                            <th width="15%">STT</th>
                                                            <th width="30%">Tên khoa</th>
                                                            <th width="35%">Mô tả</th>
                                                            <th width="20%" class="text-center">Thao tác</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody id="facultyTableBody">
                                                        <c:if test="${empty faculties}">
                                                            <tr>
                                                                <td colspan="4" class="text-center text-muted py-4">
                                                                    Chưa có khoa nào.
                                                                </td>
                                                            </tr>
                                                        </c:if>
                                                        <c:forEach var="faculty" items="${faculties}"
                                                            varStatus="status">
                                                            <tr data-faculty-id="${faculty.id}">
                                                                <td>${status.index + 1}</td>
                                                                <td><strong>${faculty.name}</strong></td>
                                                                <td>
                                                                    <c:choose>
                                                                        <c:when test="${not empty faculty.description}">
                                                                            ${faculty.description}
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span class="text-muted">Chưa có mô
                                                                                tả</span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                                <td class="text-center">
                                                                    <div class="btn-group btn-group-sm">
                                                                        <button
                                                                            class="btn btn-outline-primary btn-edit-faculty"
                                                                            data-faculty-id="${faculty.id}"
                                                                            data-faculty-name="${faculty.name}"
                                                                            data-faculty-description="${faculty.description != null ? faculty.description : ''}"
                                                                            data-bs-toggle="modal"
                                                                            data-bs-target="#modalEditFaculty">
                                                                            <i class="bi bi-pencil"></i>
                                                                        </button>
                                                                        <button
                                                                            class="btn btn-outline-danger btn-delete-faculty"
                                                                            data-faculty-id="${faculty.id}"
                                                                            data-faculty-name="${faculty.name}">
                                                                            <i class="bi bi-trash"></i>
                                                                        </button>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </c:forEach>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                    </main>

                    <!-- Modal: Thêm môn học -->
                    <div class="modal fade" id="modalCreate" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog modal-lg modal-dialog-centered">
                            <form class="modal-content" method="post"
                                action="${pageContext.request.contextPath}/admin/subjects">
                                <div class="modal-header">
                                    <h5 class="modal-title"><i class="bi bi-book-fill me-2"></i>Thêm môn học</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                </div>
                                <div class="modal-body">
                                    <div class="row g-3">
                                        <div class="col-sm-6">
                                            <label class="form-label">Mã môn học</label>
                                            <input name="subjectCode" class="form-control" required
                                                placeholder="VD: INT1154">
                                        </div>
                                        <div class="col-sm-6">
                                            <label class="form-label">Số tín chỉ</label>
                                            <input name="credit" type="number" min="1" max="10" class="form-control"
                                                required>
                                        </div>
                                        <div class="col-12">
                                            <label class="form-label">Tên môn học</label>
                                            <input name="subjectName" class="form-control" required
                                                placeholder="VD: Tin học cơ sở">
                                        </div>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <c:if test="${not empty _csrf}">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                                    </c:if>
                                    <button class="btn btn-primary" type="submit"><i
                                            class="bi bi-save2 me-1"></i>Lưu</button>
                                    <button class="btn btn-outline-secondary" type="button"
                                        data-bs-dismiss="modal">Hủy</button>
                                </div>
                            </form>
                        </div>
                    </div>

                    <!-- Modal: Thêm khoa mới -->
                    <div class="modal fade" id="modalCreateFaculty" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog modal-lg modal-dialog-centered">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title"><i class="bi bi-building-fill me-2"></i>Thêm khoa mới</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                </div>
                                <div class="modal-body">
                                    <form id="formCreateFaculty">
                                        <div class="row g-3">
                                            <div class="col-12">
                                                <label class="form-label required">Tên khoa</label>
                                                <input name="name" id="createFacultyName" class="form-control" required
                                                    placeholder="VD: Khoa Công nghệ thông tin">
                                            </div>
                                            <div class="col-12">
                                                <label class="form-label">Mô tả</label>
                                                <textarea name="description" id="createFacultyDescription"
                                                    class="form-control" rows="3"
                                                    placeholder="Mô tả ngắn về khoa (không bắt buộc)"></textarea>
                                            </div>
                                        </div>
                                    </form>
                                </div>
                                <div class="modal-footer">
                                    <button class="btn btn-primary" onclick="createFaculty()">
                                        <i class="bi bi-save2 me-1"></i>Tạo khoa
                                    </button>
                                    <button class="btn btn-outline-secondary" type="button"
                                        data-bs-dismiss="modal">Hủy</button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Modal: Sửa khoa -->
                    <div class="modal fade" id="modalEditFaculty" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog modal-lg modal-dialog-centered">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title"><i class="bi bi-building-gear me-2"></i>Sửa thông tin khoa
                                    </h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                </div>
                                <div class="modal-body">
                                    <form id="formEditFaculty">
                                        <input type="hidden" id="editFacultyId" name="id">
                                        <div class="row g-3">
                                            <div class="col-12">
                                                <label class="form-label required">Tên khoa</label>
                                                <input name="name" id="editFacultyName" class="form-control" required>
                                            </div>
                                            <div class="col-12">
                                                <label class="form-label">Mô tả</label>
                                                <textarea name="description" id="editFacultyDescription"
                                                    class="form-control" rows="3"></textarea>
                                            </div>
                                        </div>
                                    </form>
                                </div>
                                <div class="modal-footer">
                                    <button class="btn btn-primary" onclick="saveFacultyEdit()">
                                        <i class="bi bi-save2 me-1"></i>Cập nhật
                                    </button>
                                    <button class="btn btn-outline-secondary" type="button"
                                        data-bs-dismiss="modal">Hủy</button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
                    <script>
                        // Faculty management JavaScript
                        function createFaculty() {
                            const form = document.getElementById('formCreateFaculty');
                            const formData = new FormData(form);

                            fetch('${pageContext.request.contextPath}/admin/faculties/create', {
                                method: 'POST',
                                headers: {
                                    'Content-Type': 'application/x-www-form-urlencoded',
                                },
                                body: new URLSearchParams(formData)
                            })
                                .then(response => response.json())
                                .then(data => {
                                    if (data.success) {
                                        showFacultyMessage(data.message, 'success');
                                        bootstrap.Modal.getInstance(document.getElementById('modalCreateFaculty')).hide();
                                        form.reset();
                                        reloadFacultyTable();
                                    } else {
                                        showFacultyMessage(data.message, 'danger');
                                    }
                                })
                                .catch(error => {
                                    console.error('Error:', error);
                                    showFacultyMessage('Có lỗi xảy ra khi tạo khoa', 'danger');
                                });
                        }

                        function saveFacultyEdit() {
                            const form = document.getElementById('formEditFaculty');
                            const formData = new FormData(form);
                            const facultyId = document.getElementById('editFacultyId').value;

                            fetch('${pageContext.request.contextPath}/admin/faculties/' + facultyId + '/edit', {
                                method: 'POST',
                                headers: {
                                    'Content-Type': 'application/x-www-form-urlencoded',
                                },
                                body: new URLSearchParams(formData)
                            })
                                .then(response => response.json())
                                .then(data => {
                                    if (data.success) {
                                        showFacultyMessage(data.message, 'success');
                                        bootstrap.Modal.getInstance(document.getElementById('modalEditFaculty')).hide();
                                        reloadFacultyTable();
                                    } else {
                                        showFacultyMessage(data.message, 'danger');
                                    }
                                })
                                .catch(error => {
                                    console.error('Error:', error);
                                    showFacultyMessage('Có lỗi xảy ra khi cập nhật khoa', 'danger');
                                });
                        }

                        function deleteFaculty(facultyId, facultyName) {
                            if (!confirm('Bạn có chắc chắn muốn xóa khoa "' + facultyName + '"?\\n\\nLưu ý: Chỉ có thể xóa khoa khi không còn giáo viên nào thuộc khoa này.')) {
                                return;
                            }

                            fetch('${pageContext.request.contextPath}/admin/faculties/' + facultyId + '/delete', {
                                method: 'POST',
                                headers: {
                                    'Content-Type': 'application/x-www-form-urlencoded',
                                }
                            })
                                .then(response => response.json())
                                .then(data => {
                                    if (data.success) {
                                        showFacultyMessage(data.message, 'success');
                                        reloadFacultyTable();
                                    } else {
                                        showFacultyMessage(data.message, 'danger');
                                    }
                                })
                                .catch(error => {
                                    console.error('Error:', error);
                                    showFacultyMessage('Có lỗi xảy ra khi xóa khoa', 'danger');
                                });
                        }

                        function showFacultyMessage(message, type) {
                            // Remove existing alerts
                            const existingAlerts = document.querySelectorAll('.alert');
                            existingAlerts.forEach(alert => alert.remove());

                            const alertClass = type === 'success' ? 'alert-success' : 'alert-danger';
                            const icon = type === 'success' ? 'bi-check-circle' : 'bi-exclamation-triangle';

                            const alertHtml = '<div class="alert ' + alertClass + ' alert-dismissible">' +
                                '<i class="bi ' + icon + ' me-2"></i>' + message +
                                '<button type="button" class="btn-close" data-bs-dismiss="alert"></button>' +
                                '</div>';

                            const facultiesPane = document.getElementById('faculties-pane');
                            facultiesPane.insertAdjacentHTML('afterbegin', alertHtml);
                        }

                        function reloadFacultyTable() {
                            fetch('${pageContext.request.contextPath}/admin/faculties')
                                .then(response => response.json())
                                .then(faculties => {
                                    const tbody = document.getElementById('facultyTableBody');

                                    if (faculties.length === 0) {
                                        tbody.innerHTML = '<tr><td colspan="4" class="text-center text-muted py-4">Chưa có khoa nào.</td></tr>';
                                        return;
                                    }

                                    let html = '';
                                    faculties.forEach((faculty, index) => {
                                        html += '<tr data-faculty-id="' + faculty.id + '">' +
                                            '<td>' + (index + 1) + '</td>' +
                                            '<td><strong>' + faculty.name + '</strong></td>' +
                                            '<td>' + (faculty.description || '<span class="text-muted">Chưa có mô tả</span>') + '</td>' +
                                            '<td class="text-center">' +
                                            '<div class="btn-group btn-group-sm">' +
                                            '<button class="btn btn-outline-primary btn-edit-faculty" ' +
                                            'data-faculty-id="' + faculty.id + '" ' +
                                            'data-faculty-name="' + faculty.name + '" ' +
                                            'data-faculty-description="' + (faculty.description || '') + '" ' +
                                            'data-bs-toggle="modal" data-bs-target="#modalEditFaculty">' +
                                            '<i class="bi bi-pencil"></i>' +
                                            '</button>' +
                                            '<button class="btn btn-outline-danger btn-delete-faculty" ' +
                                            'data-faculty-id="' + faculty.id + '" ' +
                                            'data-faculty-name="' + faculty.name + '">' +
                                            '<i class="bi bi-trash"></i>' +
                                            '</button>' +
                                            '</div>' +
                                            '</td>' +
                                            '</tr>';
                                    });

                                    tbody.innerHTML = html;

                                    // Re-attach event listeners
                                    attachFacultyEventListeners();
                                })
                                .catch(error => {
                                    console.error('Error reloading faculty table:', error);
                                    showFacultyMessage('Lỗi khi tải lại danh sách khoa', 'danger');
                                });
                        }

                        function attachFacultyEventListeners() {
                            // Edit faculty buttons
                            document.querySelectorAll('.btn-edit-faculty').forEach(button => {
                                button.addEventListener('click', function () {
                                    const facultyId = this.dataset.facultyId;
                                    const facultyName = this.dataset.facultyName;
                                    const facultyDescription = this.dataset.facultyDescription;

                                    document.getElementById('editFacultyId').value = facultyId;
                                    document.getElementById('editFacultyName').value = facultyName;
                                    document.getElementById('editFacultyDescription').value = facultyDescription;
                                });
                            });

                            // Delete faculty buttons
                            document.querySelectorAll('.btn-delete-faculty').forEach(button => {
                                button.addEventListener('click', function () {
                                    const facultyId = this.dataset.facultyId;
                                    const facultyName = this.dataset.facultyName;
                                    deleteFaculty(facultyId, facultyName);
                                });
                            });
                        }

                        // Initialize event listeners on page load
                        document.addEventListener('DOMContentLoaded', function () {
                            attachFacultyEventListeners();
                        });
                    </script>
            </body>

            </html>