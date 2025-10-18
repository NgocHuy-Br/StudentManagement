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
                        :root {
                            --brand: #b91c1c;
                        }

                        body {
                            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                            background: #f7f7f9;
                        }

                        .major-row:hover {
                            background-color: #f8f9fa;
                        }

                        .major-row.table-primary {
                            background-color: #cce7ff !important;
                        }

                        /* Sortable table headers */
                        .sortable {
                            cursor: pointer;
                            user-select: none;
                            position: relative;
                        }

                        .sortable:hover {
                            background-color: #e2e6ea !important;
                        }

                        .sort-icon {
                            font-size: 11px;
                            color: #6c757d;
                            margin-left: 4px;
                        }

                        .sortable:hover .sort-icon {
                            color: #495057;
                        }
                    </style>
                </head>

                <body>
                    <div class="container-fluid" style="padding: 0 clamp(12px, 4vw, 36px);">
                        <%@include file="../common/header.jsp" %>

                            <c:set var="activeTab" value="majors" scope="request" />
                            <%@include file="_nav.jsp" %>

                                <div class="mt-4">
                                    <!-- Flash Messages (Hidden - now using modal notifications) -->
                                    <c:if test="${not empty success}">
                                        <div class="alert alert-success alert-dismissible fade show d-none">
                                            <i class="bi bi-check-circle me-2"></i>${success}
                                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                        </div>
                                    </c:if>
                                    <c:if test="${not empty error}">
                                        <div class="alert alert-danger alert-dismissible fade show d-none">
                                            <i class="bi bi-exclamation-triangle me-2"></i>${error}
                                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                        </div>
                                    </c:if>
                                    <div class="row g-4">
                                        <!-- Left Panel - Majors List -->
                                        <div class="col-lg-6">
                                            <div class="card shadow-sm h-100">
                                                <div
                                                    class="card-header d-flex justify-content-between align-items-center">
                                                    <h6 class="mb-0">
                                                        <i class="bi bi-mortarboard-fill me-2"></i>
                                                        Danh sách Ngành học
                                                    </h6>
                                                    <button type="button" class="btn btn-success btn-sm"
                                                        data-bs-toggle="modal" data-bs-target="#addMajorModal">
                                                        <i class="bi bi-plus-lg me-1"></i>Thêm ngành
                                                    </button>
                                                </div>
                                                <div class="card-body">
                                                    <!-- Filter and Search -->
                                                    <div class="mb-3">
                                                        <form method="get" id="filterSearchForm">
                                                            <div class="row g-2">
                                                                <!-- Faculty Filter -->
                                                                <div class="col-md-6">
                                                                    <div class="input-group input-group-sm">
                                                                        <span class="input-group-text">
                                                                            <i class="bi bi-funnel"></i>
                                                                        </span>
                                                                        <select name="facultyId"
                                                                            class="form-select form-select-sm"
                                                                            id="facultyFilter">
                                                                            <option value="">Tất cả khoa</option>
                                                                            <c:forEach var="faculty"
                                                                                items="${faculties}">
                                                                                <option value="${faculty.id}"
                                                                                    ${param.facultyId==faculty.id
                                                                                    ? 'selected' : '' }>
                                                                                    ${faculty.facultyCode} -
                                                                                    ${faculty.name}
                                                                                </option>
                                                                            </c:forEach>
                                                                        </select>
                                                                    </div>
                                                                </div>

                                                                <!-- Search -->
                                                                <div class="col-md-6">
                                                                    <div class="input-group input-group-sm">
                                                                        <span class="input-group-text">
                                                                            <i class="bi bi-search"></i>
                                                                        </span>
                                                                        <input type="text" name="q" value="${q}"
                                                                            class="form-control form-control-sm"
                                                                            placeholder="Tìm ngành...">
                                                                        <c:if test="${not empty q}">
                                                                            <a href="${pageContext.request.contextPath}/admin/majors"
                                                                                class="btn btn-outline-secondary btn-sm">
                                                                                <i class="bi bi-x-circle"></i>
                                                                            </a>
                                                                        </c:if>
                                                                    </div>
                                                                </div>
                                                            </div>

                                                            <!-- Preserve parameters -->
                                                            <c:if test="${not empty selectedMajorId}">
                                                                <input type="hidden" name="selectedMajorId"
                                                                    value="${selectedMajorId}">
                                                            </c:if>
                                                        </form>
                                                    </div>

                                                    <!-- Majors Table -->
                                                    <div class="table-responsive"
                                                        style="max-height: 500px; overflow-y: auto;">
                                                        <table class="table table-hover table-sm mb-0">
                                                            <thead class="table-light sticky-top">
                                                                <tr>
                                                                    <th style="width: 50px;">STT</th>
                                                                    <th class="sortable" data-sort="majorCode">Mã ngành
                                                                        <i class="bi bi-arrow-down-up sort-icon"></i>
                                                                    </th>
                                                                    <th class="sortable" data-sort="majorName">Tên ngành
                                                                        <i class="bi bi-arrow-down-up sort-icon"></i>
                                                                    </th>
                                                                    <th class="sortable" data-sort="faculty">Khoa <i
                                                                            class="bi bi-arrow-down-up sort-icon"></i>
                                                                    </th>
                                                                    <th>Thao tác</th>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                                <c:choose>
                                                                    <c:when test="${empty majors}">
                                                                        <tr>
                                                                            <td colspan="5"
                                                                                class="text-center py-4 text-muted">
                                                                                <i
                                                                                    class="bi bi-inbox display-6 d-block mb-2"></i>
                                                                                Không tìm thấy ngành học nào
                                                                            </td>
                                                                        </tr>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <c:forEach items="${majors}" var="major"
                                                                            varStatus="status">
                                                                            <tr class="major-row ${major.id == selectedMajorId ? 'table-primary' : ''}"
                                                                                style="cursor: pointer;"
                                                                                onclick="selectMajor(${major.id})">
                                                                                <td class="text-center">${status.index +
                                                                                    1}</td>
                                                                                <td class="fw-semibold text-primary">
                                                                                    ${major.majorCode}</td>
                                                                                <td class="fw-medium">${major.majorName}
                                                                                </td>
                                                                                <td>
                                                                                    <c:choose>
                                                                                        <c:when
                                                                                            test="${not empty major.faculty}">
                                                                                            <span
                                                                                                class="badge bg-primary">${major.faculty.name}</span>
                                                                                        </c:when>
                                                                                        <c:otherwise>
                                                                                            <span
                                                                                                class="text-muted">Chưa
                                                                                                phân khoa</span>
                                                                                        </c:otherwise>
                                                                                    </c:choose>
                                                                                </td>
                                                                                <td class="text-center">
                                                                                    <button
                                                                                        class="btn btn-sm btn-outline-info me-1 view-detail-btn"
                                                                                        data-id="${major.id}"
                                                                                        data-code="${major.majorCode}"
                                                                                        data-name="${major.majorName}"
                                                                                        data-description="${major.description}"
                                                                                        data-faculty="${not empty major.faculty ? major.faculty.name : 'Chưa phân khoa'}"
                                                                                        type="button"
                                                                                        title="Xem chi tiết">
                                                                                        <i class="bi bi-eye"></i>
                                                                                    </button>
                                                                                    <button
                                                                                        class="btn btn-sm btn-outline-warning me-1 edit-major-btn"
                                                                                        data-id="${major.id}"
                                                                                        data-code="${major.majorCode}"
                                                                                        data-name="${major.majorName}"
                                                                                        data-description="${major.description}"
                                                                                        data-faculty-id="${not empty major.faculty ? major.faculty.id : ''}"
                                                                                        type="button">
                                                                                        <i class="bi bi-pencil"></i>
                                                                                    </button>
                                                                                    <button
                                                                                        class="btn btn-sm btn-outline-danger delete-major-btn"
                                                                                        data-id="${major.id}"
                                                                                        data-code="${major.majorCode}"
                                                                                        data-name="${major.majorName}"
                                                                                        type="button">
                                                                                        <i class="bi bi-trash"></i>
                                                                                    </button>
                                                                                </td>
                                                                            </tr>
                                                                        </c:forEach>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </tbody>
                                                        </table>
                                                    </div>

                                                    <div class="mt-2 text-center">
                                                        <small class="text-muted">Tổng: ${fn:length(majors)} ngành
                                                            học</small>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Right Panel - Subjects of Selected Major -->
                                        <div class="col-lg-6">
                                            <div class="card shadow-sm h-100">
                                                <c:choose>
                                                    <c:when
                                                        test="${not empty selectedMajor or param.viewAll eq 'true'}">
                                                        <div class="card-header">
                                                            <h6 class="mb-0">
                                                                <i class="bi bi-book me-2"></i>
                                                                <span id="subjectsTitle">Môn học</span>
                                                            </h6>
                                                        </div>
                                                        <div class="card-body">
                                                            <!-- Major Selection Dropdown -->
                                                            <div
                                                                class="mb-3 d-flex justify-content-between align-items-center">
                                                                <div class="d-flex align-items-center">
                                                                    <label for="majorSelect"
                                                                        class="form-label me-2 mb-0 fw-medium">
                                                                        <i class="bi bi-filter me-1"></i>Xem môn học
                                                                        của:
                                                                    </label>
                                                                    <select class="form-select form-select-sm"
                                                                        id="majorSelect" style="min-width: 200px;">
                                                                        <option value="all" ${param.viewAll eq 'true' or
                                                                            empty selectedMajorId ? 'selected' : '' }>
                                                                            📚 Tất cả ngành
                                                                        </option>
                                                                        <c:forEach items="${majors}" var="major">
                                                                            <option value="${major.id}"
                                                                                ${selectedMajorId eq major.id and
                                                                                param.viewAll ne 'true' ? 'selected'
                                                                                : '' }>
                                                                                🎓 ${major.majorName}
                                                                            </option>
                                                                        </c:forEach>
                                                                    </select>
                                                                </div>
                                                                <small class="text-muted" id="subjectCount">
                                                                    <c:choose>
                                                                        <c:when
                                                                            test="${param.viewAll eq 'true' or empty selectedMajorId}">
                                                                            Tổng: ${fn:length(subjects)} môn học
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            Tổng: ${fn:length(subjects)} môn học
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                    <br>
                                                                    <c:set var="totalCredits" value="0" />
                                                                    <c:forEach var="subject" items="${subjects}">
                                                                        <c:set var="totalCredits"
                                                                            value="${totalCredits + subject.credit}" />
                                                                    </c:forEach>
                                                                    Tổng tín chỉ: ${totalCredits}
                                                                </small>
                                                            </div>

                                                            <!-- Action Buttons and Search in one row -->
                                                            <div
                                                                class="mb-3 d-flex justify-content-between align-items-center">
                                                                <!-- Left side: Action Buttons -->
                                                                <div class="d-flex gap-2">
                                                                    <!-- Always show "Add New Subject" button -->
                                                                    <button type="button" class="btn btn-primary btn-sm"
                                                                        data-bs-toggle="modal"
                                                                        data-bs-target="#addSubjectModal">
                                                                        <i class="bi bi-plus-lg me-1"></i>Thêm môn mới
                                                                    </button>

                                                                    <!-- Show "Add Existing Subject" only when specific major is selected -->
                                                                    <c:if
                                                                        test="${param.viewAll ne 'true' and not empty selectedMajor}">
                                                                        <button type="button"
                                                                            class="btn btn-success btn-sm"
                                                                            data-bs-toggle="modal"
                                                                            data-bs-target="#addExistingSubjectModal">
                                                                            <i class="bi bi-plus-square me-1"></i>Thêm
                                                                            môn có sẵn
                                                                        </button>
                                                                    </c:if>
                                                                </div>

                                                                <!-- Right side: Search -->
                                                                <div class="flex-shrink-0">
                                                                    <form method="get" class="d-flex">
                                                                        <div class="input-group input-group-sm">
                                                                            <span class="input-group-text">
                                                                                <i class="bi bi-search"></i>
                                                                            </span>
                                                                            <input type="text" name="subjectSearch"
                                                                                value="${param.subjectSearch}"
                                                                                class="form-control form-control-sm"
                                                                                placeholder="Tìm môn học..."
                                                                                style="width: 280px;"
                                                                                id="subjectSearchInput">
                                                                            <c:if
                                                                                test="${not empty param.subjectSearch}">
                                                                                <c:choose>
                                                                                    <c:when
                                                                                        test="${not empty selectedMajorId}">
                                                                                        <a href="${pageContext.request.contextPath}/admin/majors?selectedMajorId=${selectedMajorId}"
                                                                                            class="btn btn-outline-secondary btn-sm"
                                                                                            title="Xóa tìm kiếm">
                                                                                            <i class="bi bi-x"></i>
                                                                                        </a>
                                                                                    </c:when>
                                                                                    <c:when
                                                                                        test="${param.viewAll eq 'true'}">
                                                                                        <a href="${pageContext.request.contextPath}/admin/majors?viewAll=true"
                                                                                            class="btn btn-outline-secondary btn-sm"
                                                                                            title="Xóa tìm kiếm">
                                                                                            <i class="bi bi-x"></i>
                                                                                        </a>
                                                                                    </c:when>
                                                                                    <c:otherwise>
                                                                                        <a href="${pageContext.request.contextPath}/admin/majors"
                                                                                            class="btn btn-outline-secondary btn-sm"
                                                                                            title="Xóa tìm kiếm">
                                                                                            <i class="bi bi-x"></i>
                                                                                        </a>
                                                                                    </c:otherwise>
                                                                                </c:choose>
                                                                            </c:if>
                                                                        </div>
                                                                        <input type="hidden" name="selectedMajorId"
                                                                            id="selectedMajorIdInput"
                                                                            value="${selectedMajorId}">
                                                                        <input type="hidden" name="viewAll"
                                                                            id="viewAllInput"
                                                                            value="${param.viewAll eq 'true' ? 'true' : 'false'}">
                                                                        <c:if test="${not empty q}">
                                                                            <input type="hidden" name="q" value="${q}">
                                                                        </c:if>
                                                                    </form>
                                                                </div>
                                                            </div>

                                                            <!-- Subjects Table -->
                                                            <div class="table-responsive"
                                                                style="max-height: 350px; overflow-y: auto;">
                                                                <table class="table table-hover table-sm mb-0">
                                                                    <thead class="table-light sticky-top">
                                                                        <tr>
                                                                            <th style="width: 50px;">STT</th>
                                                                            <th class="sortable"
                                                                                data-sort="subjectCode">
                                                                                Mã môn <i
                                                                                    class="bi bi-arrow-down-up sort-icon"></i>
                                                                            </th>
                                                                            <th class="sortable"
                                                                                data-sort="subjectName">
                                                                                Tên môn học <i
                                                                                    class="bi bi-arrow-down-up sort-icon"></i>
                                                                            </th>
                                                                            <c:if test="${param.viewAll eq 'true'}">
                                                                                <th class="sortable" data-sort="major">
                                                                                    Ngành <i
                                                                                        class="bi bi-arrow-down-up sort-icon"></i>
                                                                                </th>
                                                                            </c:if>
                                                                            <th class="sortable" data-sort="credit">
                                                                                Tín chỉ <i
                                                                                    class="bi bi-arrow-down-up sort-icon"></i>
                                                                            </th>
                                                                            <th>Hệ số điểm</th>
                                                                            <th>Thao tác</th>
                                                                        </tr>
                                                                    </thead>
                                                                    <tbody>
                                                                        <c:choose>
                                                                            <c:when test="${empty subjects}">
                                                                                <tr>
                                                                                    <td colspan="${param.viewAll eq 'true' ? '7' : '6'}"
                                                                                        class="text-center py-4 text-muted">
                                                                                        <i
                                                                                            class="bi bi-journals display-6 d-block mb-2"></i>
                                                                                        Chưa có môn học nào
                                                                                    </td>
                                                                                </tr>
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <c:forEach items="${subjects}"
                                                                                    var="subject" varStatus="status">
                                                                                    <tr>
                                                                                        <td class="text-center">
                                                                                            ${status.index + 1}</td>
                                                                                        <td
                                                                                            class="fw-semibold text-success">
                                                                                            ${subject.subjectCode}</td>
                                                                                        <td class="fw-medium">
                                                                                            ${subject.subjectName}</td>
                                                                                        <c:if
                                                                                            test="${param.viewAll eq 'true'}">
                                                                                            <td>
                                                                                                <c:if
                                                                                                    test="${not empty subject.major}">
                                                                                                    <span
                                                                                                        class="badge bg-info me-1 mb-1">${subject.major.majorCode}</span>
                                                                                                </c:if>
                                                                                                <c:if
                                                                                                    test="${empty subject.major}">
                                                                                                    <small
                                                                                                        class="text-muted">Chưa
                                                                                                        gán
                                                                                                        ngành</small>
                                                                                                </c:if>
                                                                                            </td>
                                                                                        </c:if>
                                                                                        <td class="text-center">
                                                                                            <span
                                                                                                class="badge bg-secondary">${subject.credit}</span>
                                                                                        </td>
                                                                                        <td class="text-center">
                                                                                            <small
                                                                                                class="text-muted fw-semibold">
                                                                                                ${subject.weightDisplayFormat}
                                                                                            </small>
                                                                                        </td>
                                                                                        <td class="text-center">
                                                                                            <button
                                                                                                class="btn btn-sm btn-outline-warning me-1 edit-subject-btn"
                                                                                                data-id="${subject.id}"
                                                                                                data-code="${subject.subjectCode}"
                                                                                                data-name="${subject.subjectName}"
                                                                                                data-credit="${subject.credit}"
                                                                                                data-attendance-weight="${subject.attendanceWeight != null ? Math.round(subject.attendanceWeight * 100) : 10}"
                                                                                                data-midterm-weight="${subject.midtermWeight != null ? Math.round(subject.midtermWeight * 100) : 30}"
                                                                                                data-final-weight="${subject.finalWeight != null ? Math.round(subject.finalWeight * 100) : 60}">
                                                                                                <i
                                                                                                    class="bi bi-pencil"></i>
                                                                                            </button>
                                                                                            <button
                                                                                                class="btn btn-sm btn-danger remove-subject-button"
                                                                                                data-subject-id="${subject.id}"
                                                                                                data-subject-code="${subject.subjectCode}">
                                                                                                <i
                                                                                                    class="bi bi-x-circle"></i>
                                                                                            </button>
                                                                                        </td>
                                                                                    </tr>
                                                                                </c:forEach>
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </tbody>
                                                                </table>
                                                            </div>

                                                            <!-- Summary Info -->
                                                            <div class="mt-3 text-center">
                                                                <small class="text-muted">Tổng: ${fn:length(subjects)}
                                                                    môn
                                                                    học</small>
                                                            </div>
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="card-body d-flex align-items-center justify-content-center"
                                                            style="min-height: 400px;">
                                                            <div class="text-center text-muted">
                                                                <i class="bi bi-arrow-left-circle display-1 mb-3"></i>
                                                                <h5>Chọn một ngành học</h5>
                                                                <p>Chọn ngành từ danh sách bên trái hoặc dropdown phía
                                                                    trên
                                                                    để xem các môn học</p>
                                                            </div>
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Add Major Modal -->
                                <div class="modal fade" id="addMajorModal" tabindex="-1">
                                    <div class="modal-dialog">
                                        <div class="modal-content">
                                            <form method="post"
                                                action="${pageContext.request.contextPath}/admin/majors">
                                                <div class="modal-header">
                                                    <h5 class="modal-title">Thêm ngành học mới</h5>
                                                    <button type="button" class="btn-close"
                                                        data-bs-dismiss="modal"></button>
                                                </div>
                                                <div class="modal-body">
                                                    <div class="mb-3">
                                                        <label class="form-label">Khoa</label>
                                                        <select class="form-select" name="facultyId" required>
                                                            <option value="">-- Chọn khoa --</option>
                                                            <c:forEach var="faculty" items="${faculties}">
                                                                <option value="${faculty.id}">${faculty.facultyCode} -
                                                                    ${faculty.name}</option>
                                                            </c:forEach>
                                                        </select>
                                                    </div>
                                                    <div class="mb-3">
                                                        <label class="form-label">Mã ngành</label>
                                                        <input type="text" class="form-control" name="majorCode"
                                                            required placeholder="VD: CNTT">
                                                    </div>
                                                    <div class="mb-3">
                                                        <label class="form-label">Tên ngành</label>
                                                        <input type="text" class="form-control" name="majorName"
                                                            required placeholder="VD: Công nghệ thông tin">
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
                                                    <button type="submit" class="btn btn-success">Thêm ngành
                                                        học</button>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </div>

                                <!-- Edit Major Modal -->
                                <div class="modal fade" id="editMajorModal" tabindex="-1">
                                    <div class="modal-dialog">
                                        <div class="modal-content">
                                            <form method="post"
                                                action="${pageContext.request.contextPath}/admin/majors/edit">
                                                <div class="modal-header">
                                                    <h5 class="modal-title">Chỉnh sửa ngành học</h5>
                                                    <button type="button" class="btn-close"
                                                        data-bs-dismiss="modal"></button>
                                                </div>
                                                <div class="modal-body">
                                                    <input type="hidden" id="editMajorId" name="id">
                                                    <div class="mb-3">
                                                        <label class="form-label">Khoa</label>
                                                        <select class="form-select" id="editMajorFacultyId"
                                                            name="facultyId" required>
                                                            <option value="">-- Chọn khoa --</option>
                                                            <c:forEach var="faculty" items="${faculties}">
                                                                <option value="${faculty.id}">${faculty.facultyCode} -
                                                                    ${faculty.name}</option>
                                                            </c:forEach>
                                                        </select>
                                                    </div>
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

                                <!-- Delete Major Modal -->
                                <div class="modal fade" id="deleteMajorModal" tabindex="-1">
                                    <div class="modal-dialog modal-dialog-centered">
                                        <div class="modal-content">
                                            <div class="modal-header bg-danger text-white">
                                                <h5 class="modal-title">Xác nhận xóa ngành học</h5>
                                                <button type="button" class="btn-close btn-close-white"
                                                    data-bs-dismiss="modal"></button>
                                            </div>
                                            <div class="modal-body text-center">
                                                <h5 class="mb-3">Bạn có chắc chắn muốn xóa ngành học này?</h5>
                                                <div class="alert alert-light border">
                                                    <strong>Ngành:</strong> <span id="deleteConfirmMajorCode"
                                                        class="fw-bold text-primary"></span> -
                                                    <span id="deleteConfirmMajorName"></span>
                                                </div>
                                            </div>
                                            <div class="modal-footer justify-content-center">
                                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                                                    Hủy bỏ
                                                </button>
                                                <form method="post"
                                                    action="${pageContext.request.contextPath}/admin/majors/delete"
                                                    style="display: inline;">
                                                    <input type="hidden" id="deleteMajorId" name="id">
                                                    <button type="submit" class="btn btn-danger">
                                                        Xác nhận xóa
                                                    </button>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Notification Modal -->
                                <div class="modal fade" id="notificationModal" tabindex="-1">
                                    <div class="modal-dialog modal-dialog-centered">
                                        <div class="modal-content">
                                            <div class="modal-header" id="notificationHeader">
                                                <h5 class="modal-title" id="notificationTitle">
                                                    <i id="notificationIcon" class="me-2"></i>
                                                    <span id="notificationTitleText">Thông báo</span>
                                                </h5>
                                                <button type="button" class="btn-close" data-bs-dismiss="modal"
                                                    id="notificationCloseBtn"></button>
                                            </div>
                                            <div class="modal-body text-center">
                                                <div class="mb-3">
                                                    <i id="notificationMainIcon" style="font-size: 3rem;"></i>
                                                </div>
                                                <h5 id="notificationMessage" class="mb-3"></h5>
                                                <p id="notificationDetails" class="text-muted mb-0"></p>
                                            </div>
                                            <div class="modal-footer justify-content-center">
                                                <button type="button" class="btn" data-bs-dismiss="modal"
                                                    id="notificationOkBtn">
                                                    Đóng
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Major Detail Modal -->
                                <div class="modal fade" id="majorDetailModal" tabindex="-1">
                                    <div class="modal-dialog modal-lg">
                                        <div class="modal-content">
                                            <div class="modal-header bg-info text-white">
                                                <h5 class="modal-title">
                                                    <i class="bi bi-info-circle me-2"></i>Chi tiết ngành học
                                                </h5>
                                                <button type="button" class="btn-close btn-close-white"
                                                    data-bs-dismiss="modal"></button>
                                            </div>
                                            <div class="modal-body">
                                                <div class="row">
                                                    <div class="col-md-6">
                                                        <div class="card h-100">
                                                            <div class="card-header bg-light">
                                                                <h6 class="card-title mb-0">
                                                                    <i class="bi bi-mortarboard me-2"></i>Thông tin cơ
                                                                    bản
                                                                </h6>
                                                            </div>
                                                            <div class="card-body">
                                                                <table class="table table-borderless">
                                                                    <tr>
                                                                        <td><strong>Mã ngành:</strong></td>
                                                                        <td><span id="detailMajorCode"
                                                                                class="badge bg-primary"></span></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td><strong>Tên ngành:</strong></td>
                                                                        <td id="detailMajorName"></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td><strong>Thuộc khoa:</strong></td>
                                                                        <td><span id="detailFaculty"
                                                                                class="badge bg-secondary"></span></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td><strong>Mô tả:</strong></td>
                                                                        <td id="detailDescription" class="text-muted">
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-6">
                                                        <div class="card h-100">
                                                            <div class="card-header bg-light">
                                                                <h6 class="card-title mb-0">
                                                                    <i class="bi bi-graph-up me-2"></i>Thống kê
                                                                </h6>
                                                            </div>
                                                            <div class="card-body">
                                                                <div class="row text-center">
                                                                    <div class="col-6">
                                                                        <div class="border rounded p-3 mb-3">
                                                                            <h3 class="text-info mb-1"
                                                                                id="detailSubjectCount">0
                                                                            </h3>
                                                                            <small class="text-muted">Tổng môn
                                                                                học</small>
                                                                        </div>
                                                                    </div>
                                                                    <div class="col-6">
                                                                        <div class="border rounded p-3 mb-3">
                                                                            <h3 class="text-success mb-1"
                                                                                id="detailTotalCredits">0
                                                                            </h3>
                                                                            <small class="text-muted">Tổng tín
                                                                                chỉ</small>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div id="detailLoading" class="text-center d-none">
                                                                    <div class="spinner-border spinner-border-sm"
                                                                        role="status">
                                                                        <span class="visually-hidden">Loading...</span>
                                                                    </div>
                                                                    <p class="mt-2 mb-0">Đang tải dữ liệu...</p>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="modal-footer">
                                                <button type="button" class="btn btn-secondary"
                                                    data-bs-dismiss="modal">Đóng</button>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Add Subject Modal -->
                                <div class="modal fade" id="addSubjectModal" tabindex="-1">
                                    <div class="modal-dialog">
                                        <div class="modal-content">
                                            <form method="post" id="addSubjectForm"
                                                action="${pageContext.request.contextPath}/admin/subjects">
                                                <div class="modal-header">
                                                    <h5 class="modal-title">Thêm môn học mới</h5>
                                                    <button type="button" class="btn-close"
                                                        data-bs-dismiss="modal"></button>
                                                </div>
                                                <div class="modal-body">
                                                    <!-- Hidden field để truyền majorId khi đang ở ngành cụ thể -->
                                                    <c:if
                                                        test="${param.viewAll ne 'true' and not empty selectedMajorId}">
                                                        <input type="hidden" name="majorId" value="${selectedMajorId}">
                                                    </c:if>

                                                    <div class="mb-3">
                                                        <label class="form-label">Mã môn học</label>
                                                        <input type="text" class="form-control" name="subjectCode"
                                                            required placeholder="VD: IT101">
                                                    </div>
                                                    <div class="mb-3">
                                                        <label class="form-label">Tên môn học</label>
                                                        <input type="text" class="form-control" name="subjectName"
                                                            required placeholder="VD: Lập trình cơ bản">
                                                    </div>
                                                    <div class="mb-3">
                                                        <label class="form-label">Số tín chỉ</label>
                                                        <input type="number" class="form-control" name="credit" min="1"
                                                            max="10" value="3" required>
                                                    </div>

                                                    <!-- Hệ số điểm -->
                                                    <div class="mb-3">
                                                        <label class="form-label">Hệ số điểm</label>
                                                        <div class="row g-2">
                                                            <div class="col-md-4">
                                                                <label class="form-label small">Chuyên cần (%)</label>
                                                                <input type="number"
                                                                    class="form-control form-control-sm"
                                                                    name="attendanceWeight" min="0" max="100" value="10"
                                                                    placeholder="10" step="5">
                                                            </div>
                                                            <div class="col-md-4">
                                                                <label class="form-label small">Giữa kỳ (%)</label>
                                                                <input type="number"
                                                                    class="form-control form-control-sm"
                                                                    name="midtermWeight" min="0" max="100" value="30"
                                                                    placeholder="30" step="5">
                                                            </div>
                                                            <div class="col-md-4">
                                                                <label class="form-label small">Cuối kỳ (%)</label>
                                                                <input type="number"
                                                                    class="form-control form-control-sm"
                                                                    name="finalWeight" min="0" max="100" value="60"
                                                                    placeholder="60" step="5">
                                                            </div>
                                                        </div>
                                                        <small class="text-muted">Tổng hệ số phải bằng 100%</small>
                                                    </div>
                                                    <c:if test="${param.viewAll ne 'true' and not empty selectedMajor}">
                                                        <div class="alert alert-info">
                                                            <i class="fas fa-info-circle"></i>
                                                            Môn học sẽ được tự động gán vào ngành:
                                                            <strong>${selectedMajor.majorName}</strong>
                                                        </div>
                                                    </c:if>
                                                    <c:if test="${param.viewAll eq 'true' or empty selectedMajor}">
                                                        <div class="alert alert-warning">
                                                            <i class="fas fa-exclamation-triangle"></i>
                                                            Môn học sẽ được tạo độc lập, chưa gán vào ngành nào. Bạn có
                                                            thể gán vào ngành sau.
                                                        </div>
                                                    </c:if>
                                                </div>
                                                <div class="modal-footer">
                                                    <button type="button" class="btn btn-secondary"
                                                        data-bs-dismiss="modal">Hủy</button>
                                                    <button type="submit" class="btn btn-primary">Thêm môn mới</button>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </div>

                                <!-- Edit Subject Modal -->
                                <div class="modal fade" id="editSubjectModal" tabindex="-1">
                                    <div class="modal-dialog">
                                        <div class="modal-content">
                                            <form method="post"
                                                action="${pageContext.request.contextPath}/admin/subjects/edit"
                                                id="editSubjectForm">
                                                <div class="modal-header">
                                                    <h5 class="modal-title">Chỉnh sửa môn học</h5>
                                                    <button type="button" class="btn-close"
                                                        data-bs-dismiss="modal"></button>
                                                </div>
                                                <div class="modal-body">
                                                    <input type="hidden" id="editSubjectId" name="id">
                                                    <input type="hidden" name="majorId" value="${selectedMajorId}">
                                                    <div class="mb-3">
                                                        <label class="form-label">Mã môn học</label>
                                                        <input type="text" class="form-control" id="editSubjectCode"
                                                            name="subjectCode" required>
                                                    </div>
                                                    <div class="mb-3">
                                                        <label class="form-label">Tên môn học</label>
                                                        <input type="text" class="form-control" id="editSubjectName"
                                                            name="subjectName" required>
                                                    </div>
                                                    <div class="mb-3">
                                                        <label class="form-label">Số tín chỉ</label>
                                                        <input type="number" class="form-control" id="editSubjectCredit"
                                                            name="credit" min="1" max="10" required>
                                                    </div>

                                                    <!-- Hệ số điểm -->
                                                    <div class="mb-3">
                                                        <label class="form-label">Hệ số điểm</label>
                                                        <div class="row g-2">
                                                            <div class="col-md-4">
                                                                <label class="form-label small">Chuyên cần (%)</label>
                                                                <input type="number"
                                                                    class="form-control form-control-sm"
                                                                    id="editAttendanceWeight" name="attendanceWeight"
                                                                    min="0" max="100" placeholder="10" step="5">
                                                            </div>
                                                            <div class="col-md-4">
                                                                <label class="form-label small">Giữa kỳ (%)</label>
                                                                <input type="number"
                                                                    class="form-control form-control-sm"
                                                                    id="editMidtermWeight" name="midtermWeight" min="0"
                                                                    max="100" placeholder="30" step="5">
                                                            </div>
                                                            <div class="col-md-4">
                                                                <label class="form-label small">Cuối kỳ (%)</label>
                                                                <input type="number"
                                                                    class="form-control form-control-sm"
                                                                    id="editFinalWeight" name="finalWeight" min="0"
                                                                    max="100" placeholder="60" step="5">
                                                            </div>
                                                        </div>
                                                        <small class="text-muted">Tổng hệ số phải bằng 100%</small>
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

                                <!-- Add Existing Subject to Major Modal -->
                                <div class="modal fade" id="addExistingSubjectModal" tabindex="-1">
                                    <div class="modal-dialog modal-lg">
                                        <div class="modal-content">
                                            <div class="modal-header">
                                                <h5 class="modal-title">
                                                    <i class="bi bi-plus-square me-2"></i>
                                                    Thêm môn học có sẵn vào ngành: <span
                                                        class="text-primary">${selectedMajor.majorName}</span>
                                                </h5>
                                                <button type="button" class="btn-close"
                                                    data-bs-dismiss="modal"></button>
                                            </div>
                                            <div class="modal-body">
                                                <div class="mb-3">
                                                    <label class="form-label">Tìm kiếm môn học:</label>
                                                    <div class="input-group">
                                                        <span class="input-group-text">
                                                            <i class="bi bi-search"></i>
                                                        </span>
                                                        <input type="text" class="form-control"
                                                            id="searchExistingSubject"
                                                            placeholder="Nhập mã môn hoặc tên môn học...">
                                                        <button type="button" class="btn btn-outline-secondary"
                                                            id="clearSearchExistingSubject" style="display: none;"
                                                            title="Xóa tìm kiếm">
                                                            <i class="bi bi-x"></i>
                                                        </button>
                                                    </div>
                                                </div>

                                                <div class="table-responsive"
                                                    style="max-height: 400px; overflow-y: auto;">
                                                    <table class="table table-hover table-sm">
                                                        <thead class="table-light sticky-top">
                                                            <tr>
                                                                <th width="60px">Chọn</th>
                                                                <th>Mã môn</th>
                                                                <th>Tên môn học</th>
                                                                <th>Tín chỉ</th>
                                                                <th>Trạng thái</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody id="existingSubjectsTable">
                                                            <!-- Will be populated by JavaScript -->
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </div>
                                            <div class="modal-footer">
                                                <button type="button" class="btn btn-secondary"
                                                    data-bs-dismiss="modal">Đóng</button>
                                                <button type="button" class="btn btn-success" id="addSelectedSubjects"
                                                    disabled>
                                                    <i class="bi bi-check-lg me-1"></i>Thêm môn học đã chọn
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- NEW Simple Delete Subject Confirmation Modal -->
                                <div class="modal fade" id="confirmDeleteSubjectModal" tabindex="-1">
                                    <div class="modal-dialog">
                                        <div class="modal-content">
                                            <div class="modal-header bg-danger text-white">
                                                <h5 class="modal-title">
                                                    <i class="bi bi-exclamation-triangle me-2"></i>
                                                    Xác nhận xóa môn học
                                                </h5>
                                                <button type="button" class="btn-close btn-close-white"
                                                    data-bs-dismiss="modal"></button>
                                            </div>
                                            <div class="modal-body">
                                                <div id="deleteConfirmMessage" class="text-center">
                                                    <!-- Message will be set dynamically -->
                                                </div>
                                            </div>
                                            <div class="modal-footer">
                                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                                                    <i class="bi bi-x-circle me-1"></i>Hủy
                                                </button>
                                                <form id="confirmDeleteForm" method="POST" style="display: inline;">
                                                    <button type="submit" id="confirmDeleteButton"
                                                        class="btn btn-danger">
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

                                    // Notification Modal Function
                                    window.showNotification = function (type, title, message, details) {
                                        const modal = document.getElementById('notificationModal');
                                        const header = document.getElementById('notificationHeader');
                                        const titleIcon = document.getElementById('notificationIcon');
                                        const titleText = document.getElementById('notificationTitleText');
                                        const mainIcon = document.getElementById('notificationMainIcon');
                                        const messageEl = document.getElementById('notificationMessage');
                                        const detailsEl = document.getElementById('notificationDetails');
                                        const okBtn = document.getElementById('notificationOkBtn');
                                        const closeBtn = document.getElementById('notificationCloseBtn');

                                        // Configure based on type
                                        if (type === 'success') {
                                            header.className = 'modal-header bg-success text-white';
                                            titleIcon.className = 'bi bi-check-circle me-2';
                                            mainIcon.className = 'bi bi-check-circle text-success';
                                            okBtn.className = 'btn btn-success';
                                            closeBtn.className = 'btn-close btn-close-white';
                                        } else if (type === 'error') {
                                            header.className = 'modal-header bg-danger text-white';
                                            titleIcon.className = 'bi bi-exclamation-triangle me-2';
                                            mainIcon.className = 'bi bi-exclamation-triangle text-danger';
                                            okBtn.className = 'btn btn-danger';
                                            closeBtn.className = 'btn-close btn-close-white';
                                        } else if (type === 'warning') {
                                            header.className = 'modal-header bg-warning text-dark';
                                            titleIcon.className = 'bi bi-exclamation-triangle me-2';
                                            mainIcon.className = 'bi bi-exclamation-triangle text-warning';
                                            okBtn.className = 'btn btn-warning';
                                            closeBtn.className = 'btn-close';
                                        } else { // info
                                            header.className = 'modal-header bg-info text-white';
                                            titleIcon.className = 'bi bi-info-circle me-2';
                                            mainIcon.className = 'bi bi-info-circle text-info';
                                            okBtn.className = 'btn btn-info';
                                            closeBtn.className = 'btn-close btn-close-white';
                                        }

                                        titleText.textContent = title;
                                        messageEl.textContent = message;
                                        detailsEl.textContent = details || '';
                                        detailsEl.style.display = details ? 'block' : 'none';

                                        // Show modal
                                        const bsModal = new bootstrap.Modal(modal);
                                        bsModal.show();
                                    };

                                    // MAJOR MANAGEMENT
                                    document.addEventListener('DOMContentLoaded', function () {
                                        console.log('🚀 New simple script loaded!');

                                        // Major Selection function
                                        window.selectMajor = function (majorId) {
                                            const url = new URL(window.location);
                                            url.searchParams.set('selectedMajorId', majorId);
                                            url.searchParams.delete('viewAll');
                                            url.searchParams.delete('subjectSearch');
                                            window.location.href = url.toString();
                                        };

                                        // Major Selection Dropdown
                                        const majorSelect = document.getElementById('majorSelect');
                                        if (majorSelect) {
                                            majorSelect.addEventListener('change', function () {
                                                const selectedValue = this.value;
                                                const url = new URL(window.location);

                                                if (selectedValue === 'all') {
                                                    url.searchParams.set('viewAll', 'true');
                                                    url.searchParams.delete('selectedMajorId');
                                                } else {
                                                    url.searchParams.set('selectedMajorId', selectedValue);
                                                    url.searchParams.delete('viewAll');
                                                }

                                                url.searchParams.delete('subjectSearch');
                                                window.location.href = url.toString();
                                            });
                                        }

                                        // View Detail Major Button
                                        document.querySelectorAll('.view-detail-btn').forEach(function (button) {
                                            button.addEventListener('click', function (e) {
                                                e.stopPropagation(); // Prevent row selection

                                                const majorId = this.getAttribute('data-id');
                                                const majorCode = this.getAttribute('data-code');
                                                const majorName = this.getAttribute('data-name');
                                                const majorDescription = this.getAttribute('data-description');
                                                const facultyName = this.getAttribute('data-faculty');

                                                // Fill modal with major details
                                                document.getElementById('detailMajorCode').textContent = majorCode;
                                                document.getElementById('detailMajorName').textContent = majorName;
                                                document.getElementById('detailFaculty').textContent = facultyName;
                                                document.getElementById('detailDescription').textContent = majorDescription || 'Chưa có mô tả';

                                                // Show loading and reset statistics
                                                document.getElementById('detailLoading').classList.remove('d-none');
                                                document.getElementById('detailSubjectCount').textContent = '...';
                                                document.getElementById('detailTotalCredits').textContent = '...';

                                                // Show modal
                                                const detailModal = new bootstrap.Modal(document.getElementById('majorDetailModal'));
                                                detailModal.show();

                                                // Fetch subject statistics
                                                fetch(`/admin/majors/${majorId}/statistics`)
                                                    .then(response => response.json())
                                                    .then(data => {
                                                        document.getElementById('detailSubjectCount').textContent = data.subjectCount || 0;
                                                        document.getElementById('detailTotalCredits').textContent = data.totalCredits || 0;
                                                        document.getElementById('detailLoading').classList.add('d-none');
                                                    })
                                                    .catch(error => {
                                                        console.error('Error fetching statistics:', error);
                                                        document.getElementById('detailSubjectCount').textContent = 'N/A';
                                                        document.getElementById('detailTotalCredits').textContent = 'N/A';
                                                        document.getElementById('detailLoading').classList.add('d-none');
                                                    });
                                            });
                                        });

                                        // Edit Major Button
                                        document.querySelectorAll('.edit-major-btn').forEach(function (button) {
                                            button.addEventListener('click', function (e) {
                                                e.stopPropagation(); // Prevent row selection

                                                const majorId = this.getAttribute('data-id');
                                                const majorCode = this.getAttribute('data-code');
                                                const majorName = this.getAttribute('data-name');
                                                const majorDescription = this.getAttribute('data-description');
                                                const facultyId = this.getAttribute('data-faculty-id');

                                                // Fill edit form
                                                document.getElementById('editMajorId').value = majorId;
                                                document.getElementById('editMajorCode').value = majorCode;
                                                document.getElementById('editMajorName').value = majorName;
                                                document.getElementById('editMajorDescription').value = majorDescription || '';

                                                // Select faculty
                                                const facultySelect = document.getElementById('editMajorFacultyId');
                                                if (facultySelect && facultyId) {
                                                    facultySelect.value = facultyId;
                                                }

                                                // Show edit modal
                                                const editModal = new bootstrap.Modal(document.getElementById('editMajorModal'));
                                                editModal.show();
                                            });
                                        });

                                        // Delete Major Button
                                        document.querySelectorAll('.delete-major-btn').forEach(function (button) {
                                            button.addEventListener('click', function (e) {
                                                e.stopPropagation(); // Prevent row selection

                                                const majorId = this.getAttribute('data-id');
                                                const majorCode = this.getAttribute('data-code');
                                                const majorName = this.getAttribute('data-name');

                                                // Fill delete confirmation modal
                                                document.getElementById('deleteConfirmMajorCode').textContent = majorCode;
                                                document.getElementById('deleteConfirmMajorName').textContent = majorName;
                                                document.getElementById('deleteMajorId').value = majorId;

                                                // Show delete confirmation modal
                                                const deleteModal = new bootstrap.Modal(document.getElementById('deleteMajorModal'));
                                                deleteModal.show();
                                            });
                                        });

                                        // Function to get selectedMajorId from URL or JSP
                                        function getSelectedMajorIdFromUrl() {
                                            const urlParams = new URLSearchParams(window.location.search);
                                            const urlMajorId = urlParams.get('selectedMajorId');
                                            const jspMajorId = '${selectedMajorId}';

                                            console.log('URL search params:', window.location.search);
                                            console.log('URL majorId:', urlMajorId);
                                            console.log('JSP majorId:', jspMajorId);

                                            // Use URL majorId first, then fallback to JSP majorId
                                            return urlMajorId || (jspMajorId && jspMajorId !== 'null' ? jspMajorId : null);
                                        }

                                        // Add Existing Subject Modal Event
                                        const addExistingSubjectModal = document.getElementById('addExistingSubjectModal');
                                        if (addExistingSubjectModal) {
                                            addExistingSubjectModal.addEventListener('shown.bs.modal', function () {
                                                const majorId = getSelectedMajorIdFromUrl();
                                                console.log('Modal opened with majorId from URL:', majorId);
                                                console.log('JSP selectedMajorId:', '${selectedMajorId}');
                                                if (majorId && majorId.trim() !== '' && majorId !== 'null') {
                                                    loadAvailableSubjects(majorId);
                                                } else {
                                                    const tableBody = document.getElementById('existingSubjectsTable');
                                                    tableBody.innerHTML = '<tr><td colspan="5" class="text-center text-warning">Vui lòng chọn một ngành để thêm môn học</td></tr>';
                                                }
                                            });
                                        }

                                        // Function to load available subjects
                                        function loadAvailableSubjects(majorId) {
                                            console.log('=== loadAvailableSubjects called ===');
                                            console.log('majorId parameter:', majorId, typeof majorId);

                                            const tableBody = document.getElementById('existingSubjectsTable');
                                            const addButton = document.getElementById('addSelectedSubjects');

                                            if (!majorId || majorId === 'null' || majorId.toString().trim() === '') {
                                                console.error('Invalid majorId provided:', majorId);
                                                tableBody.innerHTML = '<tr><td colspan="5" class="text-center text-danger">ID ngành không hợp lệ</td></tr>';
                                                return;
                                            }

                                            // Show loading
                                            tableBody.innerHTML = '<tr><td colspan="5" class="text-center">Đang tải...</td></tr>';

                                            console.log('Loading subjects for major ID:', majorId);
                                            const url = '${pageContext.request.contextPath}/admin/majors/' + majorId + '/available-subjects';
                                            console.log('Fetch URL:', url);

                                            fetch(url)
                                                .then(response => {
                                                    console.log('Response status:', response.status);
                                                    console.log('Response headers:', response.headers.get('content-type'));

                                                    if (!response.ok) {
                                                        return response.text().then(text => {
                                                            console.error('Error response body:', text);
                                                            throw new Error('HTTP ' + response.status + ': ' + text.substring(0, 200));
                                                        });
                                                    }

                                                    // Check if response is JSON
                                                    const contentType = response.headers.get('content-type');
                                                    if (!contentType || !contentType.includes('application/json')) {
                                                        return response.text().then(text => {
                                                            console.error('Non-JSON response:', text);
                                                            throw new Error('Server returned non-JSON response');
                                                        });
                                                    }

                                                    return response.json();
                                                })
                                                .then(subjects => {
                                                    console.log('Received subjects:', subjects);
                                                    if (subjects.length === 0) {
                                                        tableBody.innerHTML = '<tr><td colspan="5" class="text-center text-muted">Không có môn học nào khả dụng</td></tr>';
                                                        return;
                                                    }

                                                    let html = '';
                                                    subjects.forEach(subject => {
                                                        html += `
                                                            <tr>
                                                                <td>
                                                                    <div class="form-check">
                                                                        <input class="form-check-input subject-checkbox" 
                                                                               type="checkbox" 
                                                                               value="\${subject.id}">
                                                                    </div>
                                                                </td>
                                                                <td>\${subject.subjectCode}</td>
                                                                <td>\${subject.subjectName}</td>
                                                                <td>\${subject.credit}</td>
                                                                <td>
                                                                    <span class="badge bg-success">Khả dụng</span>
                                                                </td>
                                                            </tr>
                                                        `;
                                                    });
                                                    tableBody.innerHTML = html;

                                                    // Add event listeners to checkboxes after HTML is created
                                                    document.querySelectorAll('.subject-checkbox').forEach(checkbox => {
                                                        checkbox.addEventListener('change', toggleAddButton);
                                                    });
                                                })
                                                .catch(error => {
                                                    console.error('Error loading subjects:', error);
                                                    console.error('Error details:', error.message);
                                                    console.error('Fetch URL was:', url);
                                                    tableBody.innerHTML = '<tr><td colspan="5" class="text-center text-danger">Lỗi khi tải dữ liệu: ' + error.message + '</td></tr>';
                                                });
                                        }

                                        // Toggle add button based on checkbox selection
                                        function toggleAddButton() {
                                            const checkboxes = document.querySelectorAll('.subject-checkbox:checked');
                                            const addButton = document.getElementById('addSelectedSubjects');
                                            addButton.disabled = checkboxes.length === 0;
                                        }

                                        // Search existing subjects
                                        const searchInput = document.getElementById('searchExistingSubject');
                                        const clearButton = document.getElementById('clearSearchExistingSubject');

                                        searchInput.addEventListener('input', function () {
                                            const filter = this.value.toLowerCase();
                                            const rows = document.querySelectorAll('#existingSubjectsTable tr');

                                            // Show/hide clear button
                                            clearButton.style.display = this.value.trim() ? 'block' : 'none';

                                            rows.forEach(row => {
                                                const cells = row.querySelectorAll('td');
                                                if (cells.length > 1) {
                                                    const code = cells[1].textContent.toLowerCase();
                                                    const name = cells[2].textContent.toLowerCase();
                                                    const show = code.includes(filter) || name.includes(filter);
                                                    row.style.display = show ? '' : 'none';
                                                }
                                            });
                                        });

                                        // Clear search button
                                        clearButton.addEventListener('click', function () {
                                            searchInput.value = '';
                                            clearButton.style.display = 'none';

                                            // Show all rows
                                            const rows = document.querySelectorAll('#existingSubjectsTable tr');
                                            rows.forEach(row => {
                                                row.style.display = '';
                                            });
                                        });

                                        // Add selected subjects to major
                                        document.getElementById('addSelectedSubjects').addEventListener('click', function () {
                                            const checkboxes = document.querySelectorAll('.subject-checkbox:checked');
                                            const subjectIds = Array.from(checkboxes).map(cb => cb.value);
                                            const majorId = getSelectedMajorIdFromUrl();

                                            if (subjectIds.length === 0 || !majorId || majorId.trim() === '' || majorId === 'null') {
                                                alert('Vui lòng chọn môn học và đảm bảo đã chọn ngành');
                                                return;
                                            }

                                            // Create form and submit
                                            const form = document.createElement('form');
                                            form.method = 'POST';
                                            form.action = '${pageContext.request.contextPath}/admin/majors/' + majorId + '/add-subjects';

                                            subjectIds.forEach(id => {
                                                const input = document.createElement('input');
                                                input.type = 'hidden';
                                                input.name = 'subjectIds';
                                                input.value = id;
                                                form.appendChild(input);
                                            });

                                            document.body.appendChild(form);
                                            form.submit();
                                        });

                                        // Edit Subject Button
                                        document.querySelectorAll('.edit-subject-btn').forEach(function (button) {
                                            button.addEventListener('click', function (e) {
                                                e.stopPropagation(); // Prevent row selection

                                                const subjectId = this.getAttribute('data-id');
                                                const subjectCode = this.getAttribute('data-code');
                                                const subjectName = this.getAttribute('data-name');
                                                const subjectCredit = this.getAttribute('data-credit');
                                                const attendanceWeight = this.getAttribute('data-attendance-weight');
                                                const midtermWeight = this.getAttribute('data-midterm-weight');
                                                const finalWeight = this.getAttribute('data-final-weight');

                                                // Fill edit form
                                                document.getElementById('editSubjectId').value = subjectId;
                                                document.getElementById('editSubjectCode').value = subjectCode;
                                                document.getElementById('editSubjectName').value = subjectName;
                                                document.getElementById('editSubjectCredit').value = subjectCredit;

                                                // Set weight values if they exist
                                                const attendanceWeightField = document.getElementById('editAttendanceWeight');
                                                const midtermWeightField = document.getElementById('editMidtermWeight');
                                                const finalWeightField = document.getElementById('editFinalWeight');

                                                if (attendanceWeightField) attendanceWeightField.value = attendanceWeight || 10;
                                                if (midtermWeightField) midtermWeightField.value = midtermWeight || 30;
                                                if (finalWeightField) finalWeightField.value = finalWeight || 60;

                                                // Show edit modal
                                                const editModal = new bootstrap.Modal(document.getElementById('editSubjectModal'));
                                                editModal.show();
                                            });
                                        });

                                        // Handle table sorting
                                        function setupTableSorting() {
                                            const sortableHeaders = document.querySelectorAll('.sortable');

                                            sortableHeaders.forEach(header => {
                                                header.style.cursor = 'pointer';
                                                header.addEventListener('click', function () {
                                                    const sortField = this.getAttribute('data-sort');
                                                    const currentUrl = new URL(window.location);

                                                    // Determine if this is in subjects table or majors table
                                                    const isSubjectSort = ['subjectCode', 'subjectName', 'major', 'credit'].includes(sortField);

                                                    let currentSort, currentDir, sortParam, dirParam;

                                                    if (isSubjectSort) {
                                                        // Subject sorting
                                                        currentSort = currentUrl.searchParams.get('subjectSort') || 'subjectCode';
                                                        currentDir = currentUrl.searchParams.get('subjectDir') || 'asc';
                                                        sortParam = 'subjectSort';
                                                        dirParam = 'subjectDir';
                                                    } else {
                                                        // Major sorting  
                                                        currentSort = currentUrl.searchParams.get('sort') || 'majorCode';
                                                        currentDir = currentUrl.searchParams.get('dir') || 'asc';
                                                        sortParam = 'sort';
                                                        dirParam = 'dir';
                                                    }

                                                    // Toggle sort direction
                                                    let newDir = 'asc';
                                                    if (currentSort === sortField && currentDir === 'asc') {
                                                        newDir = 'desc';
                                                    }

                                                    // Update URL parameters
                                                    currentUrl.searchParams.set(sortParam, sortField);
                                                    currentUrl.searchParams.set(dirParam, newDir);

                                                    // Redirect to sorted URL
                                                    window.location.href = currentUrl.toString();
                                                });
                                            });

                                            // Update sort icons based on current sort
                                            const currentUrl = new URL(window.location);
                                            const majorSort = currentUrl.searchParams.get('sort') || 'majorCode';
                                            const majorDir = currentUrl.searchParams.get('dir') || 'asc';
                                            const subjectSort = currentUrl.searchParams.get('subjectSort') || 'subjectCode';
                                            const subjectDir = currentUrl.searchParams.get('subjectDir') || 'asc';

                                            sortableHeaders.forEach(header => {
                                                const sortField = header.getAttribute('data-sort');
                                                const icon = header.querySelector('.sort-icon');

                                                if (icon) {
                                                    // Always keep the double arrow icon, only change color
                                                    icon.className = 'bi bi-arrow-down-up sort-icon text-muted';

                                                    // Determine which sort applies to this field
                                                    const isSubjectSort = ['subjectCode', 'subjectName', 'major', 'credit'].includes(sortField);
                                                    const currentSort = isSubjectSort ? subjectSort : majorSort;
                                                    const currentDir = isSubjectSort ? subjectDir : majorDir;

                                                    // Set active state - only change color to primary
                                                    if (currentSort === sortField) {
                                                        icon.className = 'bi bi-arrow-down-up sort-icon text-primary';
                                                    }
                                                }
                                            });
                                        }

                                        // Initialize sorting when page loads
                                        setupTableSorting();

                                        // NEW Delete Subject Functionality
                                        document.querySelectorAll('.remove-subject-button').forEach(function (button) {
                                            button.addEventListener('click', function (e) {
                                                e.preventDefault();
                                                e.stopPropagation();

                                                const subjectId = this.getAttribute('data-subject-id');
                                                const subjectCode = this.getAttribute('data-subject-code');

                                                // Get current context
                                                const urlParams = new URLSearchParams(window.location.search);
                                                const isViewAll = urlParams.get('viewAll') === 'true';
                                                const selectedMajorId = '${selectedMajorId}';

                                                // Setup modal content
                                                const messageDiv = document.getElementById('deleteConfirmMessage');
                                                const form = document.getElementById('confirmDeleteForm');
                                                const button = document.getElementById('confirmDeleteButton');

                                                if (isViewAll || !selectedMajorId || selectedMajorId === '' || selectedMajorId === 'null') {
                                                    // Complete deletion
                                                    messageDiv.innerHTML = `
                                                        <p>Bạn có chắc chắn muốn <strong class="text-danger">xóa hoàn toàn</strong> môn học:</p>
                                                        <h5 class="text-primary">${subjectCode}</h5>
                                                    `;
                                                    form.action = '${pageContext.request.contextPath}/admin/subjects/delete';
                                                    form.innerHTML = `
                                                        <input type="hidden" name="id" value="${subjectId}">
                                                        <button type="submit" class="btn btn-danger">
                                                            <i class="bi bi-trash me-1"></i>Xóa hoàn toàn
                                                        </button>
                                                    `;
                                                } else {
                                                    // Remove from major only
                                                    messageDiv.innerHTML = `
                                                        <p>Bạn có chắc chắn muốn <strong class="text-warning">gỡ môn học</strong>:</p>
                                                        <h5 class="text-primary">${subjectCode}</h5>
                                                        <p>khỏi ngành này?</p>
                                                    `;
                                                    form.action = '${pageContext.request.contextPath}/admin/majors/' + selectedMajorId + '/subjects/delete';
                                                    form.innerHTML = `
                                                        <input type="hidden" name="subjectId" value="${subjectId}">
                                                        <button type="submit" class="btn btn-warning">
                                                            <i class="bi bi-x-circle me-1"></i>Gỡ khỏi ngành
                                                        </button>
                                                    `;
                                                }

                                                // Show modal using Bootstrap
                                                const modal = new bootstrap.Modal(document.getElementById('confirmDeleteSubjectModal'));
                                                modal.show();
                                            });
                                        });



                                        // Check for flash messages and show notifications
                                        <c:if test="${not empty success}">
                                            setTimeout(function() {
                                                showNotification('success', 'Thành công', '${success}');
                                            }, 500);
                                        </c:if>

                                        <c:if test="${not empty error}">
                                            setTimeout(function() {
                                                showNotification('error', 'Lỗi', '${error}');
                                            }, 500);
                                        </c:if>

                                        <c:if test="${not empty warning}">
                                            setTimeout(function() {
                                                showNotification('warning', 'Cảnh báo', '${warning}');
                                            }, 500);
                                        </c:if>

                                        <c:if test="${not empty info}">
                                            setTimeout(function() {
                                                showNotification('info', 'Thông tin', '${info}');
                                            }, 500);
                                        </c:if>
                                    });
                                </script>
                </body>

                </html>