<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Quản lý Ngành - Môn học</title>
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
                        rel="stylesheet">
                    <link rel="stylesheet"
                        href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
                    <style>
                        .left-panel,
                        .right-panel {
                            height: 80vh;
                            overflow-y: auto;
                        }

                        .major-item {
                            cursor: pointer;
                            transition: background-color 0.2s;
                        }

                        .major-item:hover {
                            background-color: #f8f9fa;
                        }

                        .major-item.active {
                            background-color: #e3f2fd;
                            border-left: 4px solid #2196f3;
                        }

                        .sort-link {
                            color: inherit;
                            text-decoration: none;
                            display: inline-flex;
                            align-items: center;
                            gap: 5px;
                        }

                        .sort-link:hover {
                            color: #0d6efd;
                            text-decoration: none;
                        }

                        .sort-icon {
                            opacity: 0.6;
                            font-size: 0.8em;
                        }

                        .sort-link:hover .sort-icon {
                            opacity: 1;
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

                                <div class="row">
                                    <!-- Left Panel: Majors -->
                                    <div class="col-md-4">
                                        <div class="card shadow-sm">
                                            <div class="card-header bg-success text-white">
                                                <h5 class="card-title mb-0">
                                                    <i class="bi bi-mortarboard-fill me-2"></i>
                                                    Danh sách ngành học
                                                </h5>
                                            </div>
                                            <div class="card-body left-panel">
                                                <!-- Search Form -->
                                                <form method="get" class="mb-3">
                                                    <div class="input-group">
                                                        <input type="text" class="form-control" name="search"
                                                            placeholder="Tìm kiếm theo mã ngành, tên ngành..."
                                                            value="${param.search}">
                                                        <button class="btn btn-outline-secondary" type="submit">
                                                            <i class="bi bi-search"></i>
                                                        </button>
                                                    </div>
                                                    <input type="hidden" name="selectedMajorId"
                                                        value="${param.selectedMajorId}">
                                                </form>

                                                <!-- Add Major Button -->
                                                <div class="d-grid gap-2 mb-3">
                                                    <button type="button" class="btn btn-success" data-bs-toggle="modal"
                                                        data-bs-target="#modalCreateMajor">
                                                        <i class="bi bi-plus-circle me-1"></i>Thêm ngành
                                                    </button>
                                                </div>

                                                <!-- Major List -->
                                                <div class="list-group">
                                                    <c:forEach var="major" items="${majors}">
                                                        <div class="list-group-item major-item ${major.id == selectedMajorId ? 'active' : ''}"
                                                            onclick="selectMajor(${major.id})">
                                                            <div class="d-flex w-100 justify-content-between">
                                                                <div>
                                                                    <h6 class="mb-1">${major.majorCode}</h6>
                                                                    <p class="mb-1">${major.majorName}</p>
                                                                    <small>Số môn học: <span
                                                                            class="badge bg-primary">${major.subjectCount}</span></small>
                                                                </div>
                                                                <div class="dropdown">
                                                                    <button class="btn btn-sm btn-outline-secondary"
                                                                        type="button" data-bs-toggle="dropdown"
                                                                        onclick="event.stopPropagation()">
                                                                        <i class="bi bi-three-dots-vertical"></i>
                                                                    </button>
                                                                    <ul class="dropdown-menu">
                                                                        <li>
                                                                            <a class="dropdown-item edit-major" href="#"
                                                                                data-major-id="${major.id}"
                                                                                data-major-code="${fn:escapeXml(major.majorCode)}"
                                                                                data-major-name="${fn:escapeXml(major.majorName)}"
                                                                                data-major-description="${fn:escapeXml(major.description)}"
                                                                                data-bs-toggle="modal"
                                                                                data-bs-target="#modalEditMajor">
                                                                                <i class="bi bi-pencil me-1"></i>Sửa
                                                                            </a>
                                                                        </li>
                                                                        <li>
                                                                            <hr class="dropdown-divider">
                                                                        </li>
                                                                        <li>
                                                                            <a class="dropdown-item text-danger delete-major"
                                                                                href="#" data-major-id="${major.id}"
                                                                                data-major-name="${fn:escapeXml(major.majorName)}"
                                                                                data-bs-toggle="modal"
                                                                                data-bs-target="#modalDeleteMajor">
                                                                                <i class="bi bi-trash me-1"></i>Xóa
                                                                            </a>
                                                                        </li>
                                                                    </ul>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </c:forEach>
                                                </div>

                                                <c:if test="${empty majors}">
                                                    <div class="text-center text-muted py-4">
                                                        <i class="bi bi-folder2-open display-6"></i>
                                                        <p class="mt-2">Chưa có ngành học nào.</p>
                                                    </div>
                                                </c:if>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Right Panel: Subjects -->
                                    <div class="col-md-8">
                                        <div class="card shadow-sm">
                                            <div class="card-header bg-primary text-white">
                                                <div class="d-flex justify-content-between align-items-center">
                                                    <h5 class="card-title mb-0">
                                                        <i class="bi bi-book me-2"></i>
                                                        <span id="selectedMajorName">
                                                            <c:choose>
                                                                <c:when test="${selectedMajor != null}">
                                                                    Môn học - ${selectedMajor.majorName}
                                                                </c:when>
                                                                <c:otherwise>
                                                                    Chọn ngành để xem danh sách môn học
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </span>
                                                    </h5>
                                                    <c:if test="${selectedMajor != null}">
                                                        <button type="button" class="btn btn-light btn-sm"
                                                            data-bs-toggle="modal" data-bs-target="#modalCreateSubject">
                                                            <i class="bi bi-plus-circle me-1"></i>Thêm môn học
                                                        </button>
                                                    </c:if>
                                                </div>
                                            </div>
                                            <div class="card-body right-panel">
                                                <c:choose>
                                                    <c:when test="${selectedMajor == null}">
                                                        <div class="text-center text-muted py-5">
                                                            <i class="bi bi-arrow-left-circle display-4"></i>
                                                            <p class="mt-3">Vui lòng chọn một ngành từ danh sách bên
                                                                trái</p>
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <!-- Subject Search -->
                                                        <form method="get" class="row g-3 mb-3">
                                                            <div class="col-md-6">
                                                                <input type="text" class="form-control"
                                                                    name="subjectSearch"
                                                                    placeholder="Tìm kiếm môn học..."
                                                                    value="${param.subjectSearch}">
                                                                <input type="hidden" name="selectedMajorId"
                                                                    value="${selectedMajor.id}">
                                                            </div>
                                                            <div class="col-md-2">
                                                                <button type="submit"
                                                                    class="btn btn-primary">Tìm</button>
                                                            </div>
                                                        </form>

                                                        <!-- Subject List -->
                                                        <c:if test="${not empty subjects}">
                                                            <div class="table-responsive">
                                                                <table class="table table-hover">
                                                                    <thead class="table-light">
                                                                        <tr>
                                                                            <th>Mã môn
                                                                                <a class="sort-link"
                                                                                    href="?selectedMajorId=${selectedMajor.id}&subjectSearch=${param.subjectSearch}&subjectSort=subjectCode&subjectDir=${param.subjectSort == 'subjectCode' && param.subjectDir == 'asc' ? 'desc' : 'asc'}">
                                                                                    <i
                                                                                        class="bi bi-arrow-down-up sort-icon"></i>
                                                                                </a>
                                                                            </th>
                                                                            <th>Tên môn học
                                                                                <a class="sort-link"
                                                                                    href="?selectedMajorId=${selectedMajor.id}&subjectSearch=${param.subjectSearch}&subjectSort=subjectName&subjectDir=${param.subjectSort == 'subjectName' && param.subjectDir == 'asc' ? 'desc' : 'asc'}">
                                                                                    <i
                                                                                        class="bi bi-arrow-down-up sort-icon"></i>
                                                                                </a>
                                                                            </th>
                                                                            <th class="text-center">Số TC
                                                                                <a class="sort-link"
                                                                                    href="?selectedMajorId=${selectedMajor.id}&subjectSearch=${param.subjectSearch}&subjectSort=credit&subjectDir=${param.subjectSort == 'credit' && param.subjectDir == 'asc' ? 'desc' : 'asc'}">
                                                                                    <i
                                                                                        class="bi bi-arrow-down-up sort-icon"></i>
                                                                                </a>
                                                                            </th>
                                                                            <th class="text-center">Thao tác</th>
                                                                        </tr>
                                                                    </thead>
                                                                    <tbody>
                                                                        <c:forEach var="subject" items="${subjects}">
                                                                            <tr>
                                                                                <td><strong>${subject.subjectCode}</strong>
                                                                                </td>
                                                                                <td>${subject.subjectName}</td>
                                                                                <td class="text-center">
                                                                                    <span
                                                                                        class="badge bg-info">${subject.credit}</span>
                                                                                </td>
                                                                                <td class="text-center">
                                                                                    <div class="btn-group" role="group">
                                                                                        <button type="button"
                                                                                            class="btn btn-sm btn-outline-primary edit-subject"
                                                                                            data-subject-id="${subject.id}"
                                                                                            data-subject-code="${fn:escapeXml(subject.subjectCode)}"
                                                                                            data-subject-name="${fn:escapeXml(subject.subjectName)}"
                                                                                            data-subject-credit="${subject.credit}"
                                                                                            data-bs-toggle="modal"
                                                                                            data-bs-target="#modalEditSubject">
                                                                                            <i class="bi bi-pencil"></i>
                                                                                        </button>
                                                                                        <button type="button"
                                                                                            class="btn btn-sm btn-outline-danger delete-subject"
                                                                                            data-subject-id="${subject.id}"
                                                                                            data-subject-name="${fn:escapeXml(subject.subjectName)}"
                                                                                            data-bs-toggle="modal"
                                                                                            data-bs-target="#modalDeleteSubject">
                                                                                            <i class="bi bi-trash"></i>
                                                                                        </button>
                                                                                    </div>
                                                                                </td>
                                                                            </tr>
                                                                        </c:forEach>
                                                                    </tbody>
                                                                </table>
                                                            </div>
                                                        </c:if>

                                                        <c:if test="${empty subjects}">
                                                            <div class="text-center text-muted py-4">
                                                                <i class="bi bi-book display-6"></i>
                                                                <p class="mt-2">
                                                                    <c:choose>
                                                                        <c:when test="${not empty param.subjectSearch}">
                                                                            Không tìm thấy môn học nào với từ khóa
                                                                            "${param.subjectSearch}".
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            Ngành này chưa có môn học nào.
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </p>
                                                            </div>
                                                        </c:if>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Modals will be added here -->
                                <%-- Include modal files --%>
                                    <%@include file="modals/major-modals.jsp" %>
                                        <%@include file="modals/subject-modals.jsp" %>

                                            <script
                                                src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
                                            <script>
                                                function selectMajor(majorId) {
                                                    const url = new URL(window.location);
                                                    url.searchParams.set('selectedMajorId', majorId);
                                                    window.location.href = url.toString();
                                                }

                                                document.addEventListener('DOMContentLoaded', function () {
                                                    // Edit Major Modal
                                                    document.querySelectorAll('.edit-major').forEach(function (btn) {
                                                        btn.addEventListener('click', function () {
                                                            const majorId = this.getAttribute('data-major-id');
                                                            const majorCode = this.getAttribute('data-major-code');
                                                            const majorName = this.getAttribute('data-major-name');
                                                            const majorDescription = this.getAttribute('data-major-description');

                                                            document.getElementById('editMajorCode').value = majorCode;
                                                            document.getElementById('editMajorName').value = majorName;
                                                            document.getElementById('editMajorDescription').value = majorDescription || '';
                                                            document.getElementById('editMajorForm').action = '/admin/majors/' + majorId;
                                                        });
                                                    });

                                                    // Delete Major Modal
                                                    document.querySelectorAll('.delete-major').forEach(function (btn) {
                                                        btn.addEventListener('click', function () {
                                                            const majorId = this.getAttribute('data-major-id');
                                                            const majorName = this.getAttribute('data-major-name');

                                                            document.getElementById('deleteMajorName').textContent = majorName;
                                                            document.getElementById('deleteMajorForm').action = '/admin/majors/' + majorId + '/delete';
                                                        });
                                                    });

                                                    // Edit Subject Modal
                                                    document.querySelectorAll('.edit-subject').forEach(function (btn) {
                                                        btn.addEventListener('click', function () {
                                                            const subjectId = this.getAttribute('data-subject-id');
                                                            const subjectCode = this.getAttribute('data-subject-code');
                                                            const subjectName = this.getAttribute('data-subject-name');
                                                            const subjectCredit = this.getAttribute('data-subject-credit');

                                                            document.getElementById('editSubjectCode').value = subjectCode;
                                                            document.getElementById('editSubjectName').value = subjectName;
                                                            document.getElementById('editSubjectCredit').value = subjectCredit;
                                                            document.getElementById('editSubjectForm').action = '/admin/subjects/' + subjectId;
                                                        });
                                                    });

                                                    // Delete Subject Modal
                                                    document.querySelectorAll('.delete-subject').forEach(function (btn) {
                                                        btn.addEventListener('click', function () {
                                                            const subjectId = this.getAttribute('data-subject-id');
                                                            const subjectName = this.getAttribute('data-subject-name');

                                                            document.getElementById('deleteSubjectName').textContent = subjectName;
                                                            document.getElementById('deleteSubjectForm').action = '/admin/subjects/' + subjectId + '/delete';
                                                        });
                                                    });
                                                });
                                            </script>
                </body>

                </html>
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
                                                                        <td colspan="6"
                                                                            class="text-center py-4 text-muted">
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
                                                                            <td class="fw-medium">${major.majorName}
                                                                            </td>
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
                                                                                                    <small>Xem
                                                                                                        thêm</small>
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
                                                                                <span
                                                                                    class="badge bg-secondary">N/A</span>
                                                                            </td>
                                                                            <td class="text-center">
                                                                                <div class="dropdown action-dropdown">
                                                                                    <button
                                                                                        class="btn btn-sm btn-outline-primary dropdown-toggle"
                                                                                        type="button"
                                                                                        data-bs-toggle="dropdown">
                                                                                        <i
                                                                                            class="bi bi-gear me-1"></i>Thao
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
                                                                                            <hr
                                                                                                class="dropdown-divider">
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
                                                        name="majorName" placeholder="VD: Công nghệ thông tin..."
                                                        required maxlength="200">
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
                                            <p>Bạn có chắc chắn muốn xóa ngành học <strong
                                                    id="deleteMajorName"></strong>?
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