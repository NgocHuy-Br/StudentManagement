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

                    .faculty-toolbar .search .form-control {
                        min-width: 260px
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

                    .stats-badge {
                        font-size: 0.85em;
                        padding: 0.3em 0.6em;
                    }
                </style>
            </head>

            <body>
                <%@ include file="../common/header.jsp" %>
                    <main class="container-fluid main-wrap py-3">
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
                            background: var(--primary-red);
                            border: none;
                            border-radius: 8px;
                            padding: 0.75rem 1.5rem;
                            font-weight: 600;
                            transition: all 0.2s ease;
                        }

                        .btn-search:hover {
                            background: #b91c1c;
                            transform: translateY(-1px);
                        }

                        .btn-add {
                            background: var(--primary-green);
                            border: none;
                            border-radius: 8px;
                            padding: 0.75rem 1.5rem;
                            font-weight: 600;
                            transition: all 0.2s ease;
                        }

                        .btn-add:hover {
                            background: #15803d;
                            transform: translateY(-1px);
                        }

                        .size-select {
                            border: 2px solid #e5e7eb;
                            border-radius: 8px;
                            padding: 0.5rem;
                            min-width: 80px;
                        }

                        .size-select:focus {
                            border-color: var(--primary-green);
                            box-shadow: 0 0 0 3px rgba(22, 163, 74, 0.1);
                        }

                        .sort-link {
                            color: inherit;
                            text-decoration: none;
                            display: inline-flex;
                            align-items: center;
                            gap: 5px;
                            transition: color 0.2s ease;
                        }

                        .sort-link:hover {
                            color: var(--primary-red);
                            text-decoration: none;
                        }

                        .sort-icon {
                            opacity: 0.6;
                            font-size: 0.8em;
                        }

                        .sort-link:hover .sort-icon {
                            opacity: 1;
                        }

                        .table thead th {
                            background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
                            border-bottom: 2px solid var(--primary-red);
                            font-weight: 600;
                            color: #374151;
                            padding: 1rem 0.75rem;
                        }

                        .table tbody tr {
                            transition: all 0.2s ease;
                        }

                        .table tbody tr:hover {
                            background: #f8fafc;
                            transform: translateY(-1px);
                            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
                        }

                        .stats-badge {
                            padding: 0.4rem 0.8rem;
                            border-radius: 20px;
                            font-weight: 600;
                            font-size: 0.85rem;
                        }

                        .stats-badge.ngành {
                            background: rgba(220, 38, 38, 0.1);
                            color: var(--primary-red);
                        }

                        .stats-badge.giáo-viên {
                            background: rgba(22, 163, 74, 0.1);
                            color: var(--primary-green);
                        }

                        .stats-badge.sinh-viên {
                            background: rgba(251, 191, 36, 0.1);
                            color: #d97706;
                        }

                        .action-btn {
                            border: none;
                            border-radius: 6px;
                            padding: 0.4rem 0.8rem;
                            font-size: 0.85rem;
                            font-weight: 500;
                            transition: all 0.2s ease;
                            margin: 0 0.1rem;
                        }

                        .action-btn.edit {
                            background: rgba(22, 163, 74, 0.1);
                            color: var(--primary-green);
                        }

                        .action-btn.edit:hover {
                            background: var(--primary-green);
                            color: white;
                        }

                        .action-btn.delete {
                            background: rgba(220, 38, 38, 0.1);
                            color: var(--primary-red);
                        }

                        .action-btn.delete:hover {
                            background: var(--primary-red);
                            color: white;
                        }

                        .table-responsive {
                            overflow: visible;
                        }

                        .dropdown-menu {
                            z-index: 1050;
                        }
                    </style>
                </head>

                <body>
                    <%@include file="../common/header.jsp" %>

                        <div class="container-fluid my-4">
                            <%@include file="_nav.jsp" %>

                                <!-- Content Wrapper với top margin -->
                                <div class="content-wrapper">
                                    <!-- Filter Toolbar -->
                                    <div class="filter-toolbar">
                                        <form method="get" class="row g-3 align-items-end">
                                            <!-- Search Box -->
                                            <div class="col-md-5">
                                                <input name="q" class="form-control search-input"
                                                    placeholder="Tìm tên khoa, mô tả..." value="${q}" />
                                            </div>

                                            <!-- Buttons -->
                                            <div class="col-md-4">
                                                <button type="submit" class="btn btn-search text-white me-2">
                                                    <i class="bi bi-search me-1"></i>Tìm kiếm
                                                </button>
                                                <c:if test="${not empty q}">
                                                    <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/admin/faculties/manage">
                                                        <i class="bi bi-x-circle me-1"></i>Xóa bộ lọc
                                                    </a>
                                                </c:if>
                                            </div>

                                            <!-- Size selector và Add button -->
                                            <div class="col-md-3 d-flex align-items-end justify-content-end gap-3">
                                                <div>
                                                    <label class="form-label fw-semibold text-gray-700 mb-2 d-block">
                                                        Hiển thị
                                                    </label>
                                                    <select class="form-select size-select" name="size"
                                                        onchange="this.form.submit()">
                                                        <option value="10" ${param.size=='10' ?'selected':''}>10</option>
                                                        <option value="20" ${param.size=='20' ?'selected':''}>20</option>
                                                        <option value="50" ${param.size=='50' ?'selected':''}>50</option>
                                                        <option value="100" ${param.size=='100' ?'selected':''}>100</option>
                                                    </select>
                                                </div>

                                                <button type="button" class="btn btn-add text-white"
                                                    data-bs-toggle="modal" data-bs-target="#modalCreate">
                                                    <i class="bi bi-plus-lg me-1"></i>Thêm khoa
                                                </button>
                                            </div>

                                            <!-- Hidden inputs -->
                                            <input type="hidden" name="sort" value="${sort}">
                                            <input type="hidden" name="dir" value="${dir}">
                                        </form>
                                    </div>

                                    <!-- Faculty table -->
                                    <div class="table-responsive">
                                        <table class="table table-hover align-middle mb-0">
                                            <thead>
                                                <tr>
                                                    <th width="60px">STT</th>
                                                    <th>Tên khoa
                                                        <a class="sort-link"
                                                            href="?q=${fn:escapeXml(q)}&size=${page.size}&sort=name&dir=${dir=='asc' && sort=='name' ? 'desc' : 'asc'}">
                                                            <i class="bi bi-arrow-down-up sort-icon"></i>
                                                        </a>
                                                    </th>
                                                    <th>Mô tả</th>
                                                    <th class="text-center">Số ngành</th>
                                                    <th class="text-center">Số giáo viên</th>
                                                    <th class="text-center">Số sinh viên</th>
                                                    <th class="text-center">Thao tác</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:if test="${page.totalElements == 0}">
                                                    <tr>
                                                        <td colspan="7" class="text-center text-muted py-5">
                                                            <div class="d-flex flex-column align-items-center">
                                                                <i class="bi bi-inbox display-1 text-muted mb-3"></i>
                                                                <c:choose>
                                                                    <c:when test="${not empty q}">
                                                                        <h5 class="text-muted">Không tìm thấy khoa nào</h5>
                                                                        <p class="text-muted">Không có khoa nào khớp với từ khóa "${q}"</p>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <h5 class="text-muted">Chưa có khoa nào</h5>
                                                                        <p class="text-muted">Hãy thêm khoa đầu tiên</p>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:if>

                                                <c:forEach var="faculty" items="${page.content}" varStatus="status">
                                                    <tr>
                                                        <td>
                                                            <span class="badge bg-light text-dark fw-semibold">
                                                                ${page.number * page.size + status.index + 1}
                                                            </span>
                                                        </td>
                                                        <td>
                                                            <div class="d-flex align-items-center">
                                                                <div class="avatar-sm bg-gradient bg-primary text-white rounded-circle me-3 d-flex align-items-center justify-content-center" style="width: 40px; height: 40px;">
                                                                    <i class="bi bi-building"></i>
                                                                </div>
                                                                <div>
                                                                    <h6 class="mb-0 fw-semibold">${faculty.name}</h6>
                                                                    <small class="text-muted">ID: ${faculty.id}</small>
                                                                </div>
                                                            </div>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${not empty faculty.description}">
                                                                    <span class="text-muted">${faculty.description}</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <em class="text-muted">Chưa có mô tả</em>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td class="text-center">
                                                            <span class="stats-badge ngành">${facultyStats[faculty.id]['majorCount']}</span>
                                                        </td>
                                                        <td class="text-center">
                                                            <span class="stats-badge giáo-viên">${facultyStats[faculty.id]['teacherCount']}</span>
                                                        </td>
                                                        <td class="text-center">
                                                            <span class="stats-badge sinh-viên">${facultyStats[faculty.id]['studentCount']}</span>
                                                        </td>
                                                        <td class="text-center">
                                                            <button class="btn action-btn edit" 
                                                                data-bs-toggle="modal" 
                                                                data-bs-target="#modalEdit"
                                                                data-id="${faculty.id}"
                                                                data-name="${faculty.name}"
                                                                data-description="${faculty.description}">
                                                                <i class="bi bi-pencil-square"></i>
                                                            </button>
                                                            <button class="btn action-btn delete" 
                                                                data-bs-toggle="modal" 
                                                                data-bs-target="#modalDelete"
                                                                data-id="${faculty.id}"
                                                                data-name="${faculty.name}">
                                                                <i class="bi bi-trash"></i>
                                                            </button>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>

                                    <!-- Pagination -->
                                    <c:if test="${page.totalPages > 1}">
                                        <div class="d-flex justify-content-between align-items-center p-3 border-top">
                                            <div class="text-muted">
                                                Hiển thị ${page.numberOfElements} trong tổng số ${page.totalElements} khoa
                                            </div>
                                            <nav aria-label="Page navigation">
                                                <ul class="pagination mb-0">
                                                    <c:if test="${page.hasPrevious()}">
                                                        <li class="page-item">
                                                            <a class="page-link"
                                                                href="?q=${fn:escapeXml(q)}&sort=${sort}&dir=${dir}&page=${page.number - 1}&size=${page.size}">
                                                                <i class="bi bi-chevron-left"></i>
                                                            </a>
                                                        </li>
                                                    </c:if>

                                                    <c:set var="startPage" value="${page.number - 2 < 0 ? 0 : page.number - 2}" />
                                                    <c:set var="endPage" value="${startPage + 4 >= page.totalPages ? page.totalPages - 1 : startPage + 4}" />
                                                    
                                                    <c:forEach var="i" begin="${startPage}" end="${endPage}">
                                                        <li class="page-item ${i == page.number ? 'active' : ''}">
                                                            <a class="page-link"
                                                                href="?q=${fn:escapeXml(q)}&sort=${sort}&dir=${dir}&page=${i}&size=${page.size}">
                                                                ${i + 1}
                                                            </a>
                                                        </li>
                                                    </c:forEach>

                                                    <c:if test="${page.hasNext()}">
                                                        <li class="page-item">
                                                            <a class="page-link"
                                                                href="?q=${fn:escapeXml(q)}&sort=${sort}&dir=${dir}&page=${page.number + 1}&size=${page.size}">
                                                                <i class="bi bi-chevron-right"></i>
                                                            </a>
                                                        </li>
                                                    </c:if>
                                                </ul>
                                            </nav>
                                        </div>
                                    </c:if>
                                </div>

                <!-- Create Faculty Modal -->
                <div class="modal fade" id="modalCreate" tabindex="-1">
                    <div class="modal-dialog modal-dialog-centered">
                        <div class="modal-content border-0 shadow-lg">
                            <div class="modal-header" style="background: linear-gradient(135deg, var(--primary-green), #22c55e); color: white; border: none;">
                                <h5 class="modal-title fw-bold">
                                    <i class="bi bi-plus-circle me-2"></i>Thêm khoa mới
                                </h5>
                                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                            </div>
                            <form method="post" action="${pageContext.request.contextPath}/admin/faculties">
                                <div class="modal-body p-4">
                                    <div class="mb-4">
                                        <label for="createFacultyCode" class="form-label fw-semibold">
                                            <i class="bi bi-tag me-1 text-muted"></i>Mã khoa <span class="text-danger">*</span>
                                        </label>
                                        <input type="text" class="form-control form-control-lg" id="createFacultyCode"
                                            name="facultyCode" placeholder="Nhập mã khoa (VD: CNTT)" required>
                                    </div>
                                    <div class="mb-4">
                                        <label for="createFacultyName" class="form-label fw-semibold">
                                            <i class="bi bi-building me-1 text-muted"></i>Tên khoa <span class="text-danger">*</span>
                                        </label>
                                        <input type="text" class="form-control form-control-lg" id="createFacultyName"
                                            name="facultyName" placeholder="Nhập tên khoa" required>
                                    </div>
                                    <div class="mb-3">
                                        <label for="createDescription" class="form-label fw-semibold">
                                            <i class="bi bi-file-text me-1 text-muted"></i>Mô tả
                                        </label>
                                        <textarea class="form-control" id="createDescription"
                                            name="description" rows="3" placeholder="Mô tả về khoa (tùy chọn)"></textarea>
                                    </div>
                                </div>
                                <div class="modal-footer border-0 p-4">
                                    <button type="button" class="btn btn-outline-secondary px-4" data-bs-dismiss="modal">
                                        <i class="bi bi-x-circle me-1"></i>Hủy
                                    </button>
                                    <button type="submit" class="btn btn-add text-white px-4">
                                        <i class="bi bi-check-lg me-1"></i>Thêm khoa
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- Edit Faculty Modal -->
                <div class="modal fade" id="modalEdit" tabindex="-1">
                    <div class="modal-dialog modal-dialog-centered">
                        <div class="modal-content border-0 shadow-lg">
                            <div class="modal-header" style="background: linear-gradient(135deg, var(--primary-green), #22c55e); color: white; border: none;">
                                <h5 class="modal-title fw-bold">
                                    <i class="bi bi-pencil me-2"></i>Chỉnh sửa khoa
                                </h5>
                                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                            </div>
                            <form method="post" id="editForm">
                                <input type="hidden" id="editId" name="id">
                                <div class="modal-body p-4">
                                    <div class="mb-4">
                                        <label for="editFacultyName" class="form-label fw-semibold">
                                            <i class="bi bi-building me-1 text-muted"></i>Tên khoa <span class="text-danger">*</span>
                                        </label>
                                        <input type="text" class="form-control form-control-lg" id="editFacultyName"
                                            name="name" required>
                                    </div>
                                    <div class="mb-3">
                                        <label for="editDescription" class="form-label fw-semibold">
                                            <i class="bi bi-file-text me-1 text-muted"></i>Mô tả
                                        </label>
                                        <textarea class="form-control" id="editDescription"
                                            name="description" rows="3"></textarea>
                                    </div>
                                </div>
                                <div class="modal-footer border-0 p-4">
                                    <button type="button" class="btn btn-outline-secondary px-4" data-bs-dismiss="modal">
                                        <i class="bi bi-x-circle me-1"></i>Hủy
                                    </button>
                                    <button type="submit" class="btn btn-add text-white px-4">
                                        <i class="bi bi-check-lg me-1"></i>Cập nhật
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- Delete Faculty Modal -->
                <div class="modal fade" id="modalDelete" tabindex="-1">
                    <div class="modal-dialog modal-dialog-centered">
                        <div class="modal-content border-0 shadow-lg">
                            <div class="modal-header" style="background: linear-gradient(135deg, var(--primary-red), #ef4444); color: white; border: none;">
                                <h5 class="modal-title fw-bold">
                                    <i class="bi bi-exclamation-triangle me-2"></i>Xác nhận xóa
                                </h5>
                                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                            </div>
                            <div class="modal-body p-4">
                                <div class="text-center mb-4">
                                    <div class="mx-auto mb-3 d-flex align-items-center justify-content-center" 
                                         style="width: 64px; height: 64px; background: rgba(220, 38, 38, 0.1); border-radius: 50%;">
                                        <i class="bi bi-exclamation-triangle" style="font-size: 2rem; color: var(--primary-red);"></i>
                                    </div>
                                    <h6 class="mb-2">Bạn có chắc chắn muốn xóa khoa này?</h6>
                                    <p class="text-muted mb-0">Khoa: <strong id="deleteFacultyName" class="text-dark"></strong></p>
                                </div>
                                <div class="alert alert-warning border-0" style="background: var(--light-red);">
                                    <i class="bi bi-exclamation-triangle me-2 text-warning"></i>
                                    <strong>Lưu ý:</strong> Việc xóa khoa có thể ảnh hưởng đến dữ liệu giáo viên và ngành học thuộc khoa này.
                                </div>
                            </div>
                            <div class="modal-footer border-0 p-4">
                                <button type="button" class="btn btn-outline-secondary px-4" data-bs-dismiss="modal">
                                    <i class="bi bi-x-circle me-1"></i>Hủy
                                </button>
                                <form method="post" id="deleteForm" class="d-inline">
                                    <input type="hidden" id="deleteId" name="id">
                                    <button type="submit" class="btn text-white px-4" style="background: var(--primary-red);">
                                        <i class="bi bi-trash me-1"></i>Xóa khoa
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
                <script>
                    document.addEventListener('DOMContentLoaded', function () {
                        // Handle Edit Faculty Modal
                        const editButtons = document.querySelectorAll('.action-btn.edit');
                        editButtons.forEach(button => {
                            button.addEventListener('click', function() {
                                const id = this.getAttribute('data-id');
                                const name = this.getAttribute('data-name');
                                const description = this.getAttribute('data-description');
                                
                                document.getElementById('editId').value = id;
                                document.getElementById('editFacultyName').value = name || '';
                                document.getElementById('editDescription').value = description || '';
                                
                                // Set form action to correct URL
                                const editForm = document.getElementById('editForm');
                                editForm.action = `${window.location.origin}/admin/faculties/${id}`;
                            });
                        });

                        // Handle Delete Faculty Modal
                        const deleteButtons = document.querySelectorAll('.action-btn.delete');
                        deleteButtons.forEach(button => {
                            button.addEventListener('click', function() {
                                const id = this.getAttribute('data-id');
                                const name = this.getAttribute('data-name');
                                
                                document.getElementById('deleteId').value = id;
                                document.getElementById('deleteFacultyName').textContent = name || '';
                                
                                // Set form action to correct URL
                                const deleteForm = document.getElementById('deleteForm');
                                deleteForm.action = `${window.location.origin}/admin/faculties/${id}/delete`;
                            });
                        });

                        // Show success/error messages
                        <c:if test="${not empty success}">
                            showToast('success', '${success}');
                        </c:if>
                        <c:if test="${not empty error}">
                            showToast('error', '${error}');
                        </c:if>
                    });

                    function showToast(type, message) {
                        const toastContainer = document.getElementById('toastContainer') || createToastContainer();
                        const toastId = 'toast-' + Date.now();
                        const bgClass = type === 'success' ? 'bg-success' : 'bg-danger';
                        const iconClass = type === 'success' ? 'check-circle' : 'exclamation-triangle';
                        
                        const toastHTML = `
                            <div class="toast ` + bgClass + ` text-white border-0" id="` + toastId + `" role="alert">
                                <div class="d-flex">
                                    <div class="toast-body">
                                        <i class="bi bi-` + iconClass + ` me-2"></i>
                                        ` + message + `
                                    </div>
                                    <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
                                </div>
                            </div>
                        `;
                        
                        toastContainer.insertAdjacentHTML('beforeend', toastHTML);
                        const toastElement = document.getElementById(toastId);
                        const toast = new bootstrap.Toast(toastElement, { delay: 5000 });
                        toast.show();
                        
                        toastElement.addEventListener('hidden.bs.toast', () => {
                            toastElement.remove();
                        });
                    }

                    function createToastContainer() {
                        const container = document.createElement('div');
                        container.id = 'toastContainer';
                        container.className = 'toast-container position-fixed top-0 end-0 p-3';
                        container.style.zIndex = '1055';
                        document.body.appendChild(container);
                        return container;
                    }
                </script>
            </body>
            </html>