<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Quản lý Lớp - Sinh viên</title>
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

                        .classroom-row:hover {
                            background-color: #f8f9fa;
                        }

                        .classroom-row.table-primary {
                            background-color: #cce7ff !important;
                        }

                        .student-row:hover {
                            background-color: #f8f9fa;
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

                        /* Course year validation styles */
                        .form-control.is-invalid {
                            border-color: #dc3545;
                            box-shadow: 0 0 0 0.2rem rgba(220, 53, 69, 0.25);
                        }

                        .form-control.is-valid {
                            border-color: #198754;
                            box-shadow: 0 0 0 0.2rem rgba(25, 135, 84, 0.25);
                        }

                        .form-text.text-muted {
                            font-size: 0.85em;
                            color: #6c757d !important;
                        }

                        .invalid-feedback {
                            display: block;
                            color: #dc3545;
                            font-size: 0.85em;
                            margin-top: 0.25rem;
                        }
                    </style>
                </head>

                <body>
                    <div class="container-fluid" style="padding: 0 clamp(12px, 4vw, 36px);">
                        <%@include file="../common/header.jsp" %>

                            <c:set var="activeTab" value="classrooms" scope="request" />
                            <%@include file="_nav.jsp" %>

                                <div class="mt-4">
                                    <!-- Include notification modal -->
                                    <%@ include file="../common/notification-modal.jsp" %>

                                        <div class="row g-4">
                                            <!-- Left Panel - Classrooms List -->
                                            <div class="col-lg-6">
                                                <div class="card shadow-sm h-100">
                                                    <div
                                                        class="card-header d-flex justify-content-between align-items-center">
                                                        <h6 class="mb-0">
                                                            <i class="bi bi-door-open-fill me-2"></i>
                                                            Danh sách Lớp học
                                                        </h6>
                                                        <button type="button" class="btn btn-success btn-sm"
                                                            data-bs-toggle="modal" data-bs-target="#addClassroomModal">
                                                            <i class="bi bi-plus-lg me-1"></i>Thêm lớp
                                                        </button>
                                                    </div>
                                                    <div class="card-body">
                                                        <!-- Filter and Search -->
                                                        <div class="mb-3">
                                                            <form method="get" id="filterSearchForm">
                                                                <div class="row g-2">
                                                                    <!-- Major Filter -->
                                                                    <div class="col-md-6">
                                                                        <div class="input-group input-group-sm">
                                                                            <span class="input-group-text">
                                                                                <i class="bi bi-funnel"></i>
                                                                            </span>
                                                                            <select name="majorId"
                                                                                class="form-select form-select-sm"
                                                                                id="majorFilter">
                                                                                <option value="">Tất cả ngành</option>
                                                                                <c:forEach var="major"
                                                                                    items="${majors}">
                                                                                    <option value="${major.id}"
                                                                                        ${param.majorId==major.id
                                                                                        ? 'selected' : '' }>
                                                                                        ${major.majorCode} -
                                                                                        ${major.majorName}
                                                                                    </option>
                                                                                </c:forEach>
                                                                            </select>
                                                                        </div>
                                                                    </div>

                                                                    <!-- Search -->
                                                                    <div class="col-md-6">
                                                                        <div class="input-group input-group-sm">
                                                                            <button type="submit"
                                                                                class="btn btn-outline-primary btn-sm">
                                                                                <i class="bi bi-search"></i>
                                                                            </button>
                                                                            <input type="text" name="search"
                                                                                value="${search}"
                                                                                class="form-control form-control-sm"
                                                                                placeholder="Tìm theo mã lớp...">
                                                                            <c:if test="${not empty search}">
                                                                                <a href="${pageContext.request.contextPath}/admin/classrooms"
                                                                                    class="btn btn-outline-secondary btn-sm">
                                                                                    <i class="bi bi-x-circle"></i>
                                                                                </a>
                                                                            </c:if>
                                                                        </div>
                                                                    </div>
                                                                </div>

                                                                <!-- Preserve parameters -->
                                                                <c:if test="${not empty selectedClassroomId}">
                                                                    <input type="hidden" name="selectedClassroomId"
                                                                        value="${selectedClassroomId}">
                                                                </c:if>
                                                            </form>
                                                        </div>

                                                        <!-- Classrooms Table -->
                                                        <div class="table-responsive"
                                                            style="max-height: 500px; overflow-y: auto;">
                                                            <table class="table table-hover table-sm mb-0">
                                                                <thead class="table-light sticky-top">
                                                                    <tr>
                                                                        <th style="width: 50px;">STT</th>
                                                                        <th class="sortable" data-sort="classCode">Mã
                                                                            lớp
                                                                            <i
                                                                                class="bi bi-arrow-down-up sort-icon"></i>
                                                                        </th>
                                                                        <th class="sortable" data-sort="courseYear">Khóa
                                                                            <i
                                                                                class="bi bi-arrow-down-up sort-icon"></i>
                                                                        </th>
                                                                        <th class="sortable" data-sort="major">Ngành
                                                                            <i
                                                                                class="bi bi-arrow-down-up sort-icon"></i>
                                                                        </th>
                                                                        <th>SV</th>
                                                                        <th>Thao tác</th>
                                                                    </tr>
                                                                </thead>
                                                                <tbody>
                                                                    <c:choose>
                                                                        <c:when test="${empty classrooms}">
                                                                            <tr>
                                                                                <td colspan="6"
                                                                                    class="text-center py-4 text-muted">
                                                                                    <i
                                                                                        class="bi bi-inbox display-6 d-block mb-2"></i>
                                                                                    Không tìm thấy lớp học nào
                                                                                </td>
                                                                            </tr>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <c:forEach items="${classrooms}"
                                                                                var="classroom" varStatus="status">
                                                                                <tr class="classroom-row ${classroom.id == selectedClassroomId ? 'table-primary' : ''}"
                                                                                    style="cursor: pointer;"
                                                                                    onclick="selectClassroom(<c:out value='${classroom.id}' />)">
                                                                                    <td class="text-center">
                                                                                        ${status.index +
                                                                                        1}</td>
                                                                                    <td
                                                                                        class="fw-semibold text-primary">
                                                                                        ${classroom.classCode}</td>
                                                                                    <td class="fw-medium">
                                                                                        ${classroom.courseYear}</td>
                                                                                    <td>
                                                                                        <c:choose>
                                                                                            <c:when
                                                                                                test="${not empty classroom.major}">
                                                                                                <span
                                                                                                    class="badge bg-primary">${classroom.major.majorCode}</span>
                                                                                            </c:when>
                                                                                            <c:otherwise>
                                                                                                <span
                                                                                                    class="text-muted">Chưa
                                                                                                    phân ngành</span>
                                                                                            </c:otherwise>
                                                                                        </c:choose>
                                                                                    </td>
                                                                                    <td>
                                                                                        <span
                                                                                            class="badge bg-info">${fn:length(classroom.students)}</span>
                                                                                    </td>
                                                                                    <td>
                                                                                        <div
                                                                                            class="btn-group btn-group-sm">
                                                                                            <button type="button"
                                                                                                class="btn btn-outline-primary btn-sm"
                                                                                                onclick="event.stopPropagation(); editClassroom(<c:out value='${classroom.id}' />)"
                                                                                                title="Sửa">
                                                                                                <i
                                                                                                    class="bi bi-pencil"></i>
                                                                                            </button>
                                                                                            <button type="button"
                                                                                                class="btn btn-outline-danger btn-sm"
                                                                                                onclick="event.stopPropagation(); deleteClassroom(<c:out value='${classroom.id}' />)"
                                                                                                title="Xóa">
                                                                                                <i
                                                                                                    class="bi bi-trash"></i>
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
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- Right Panel - Students List -->
                                            <div class="col-lg-6">
                                                <div class="card shadow-sm h-100">
                                                    <div
                                                        class="card-header d-flex justify-content-between align-items-center">
                                                        <h6 class="mb-0">
                                                            <i class="bi bi-people-fill me-2"></i>
                                                            <span id="studentsTitle">Chọn lớp để xem danh sách sinh
                                                                viên</span>
                                                        </h6>
                                                        <button type="button" class="btn btn-success btn-sm"
                                                            data-bs-toggle="modal" data-bs-target="#addStudentModal">
                                                            <i class="bi bi-person-plus me-1"></i>Thêm sinh viên
                                                        </button>
                                                    </div>
                                                    <div class="card-body">
                                                        <!-- Classroom Selector and Search -->
                                                        <div class="mb-3">
                                                            <div class="row g-2">
                                                                <!-- Classroom Selector -->
                                                                <div class="col-md-6">
                                                                    <div class="input-group input-group-sm">
                                                                        <span class="input-group-text">
                                                                            <i class="bi bi-door-open"></i>
                                                                        </span>
                                                                        <select class="form-select form-select-sm"
                                                                            id="classroomSelector">
                                                                            <option value="">Tất cả lớp</option>
                                                                            <c:forEach var="classroom"
                                                                                items="${classrooms}">
                                                                                <option value="${classroom.id}"
                                                                                    ${classroom.id==selectedClassroomId
                                                                                    ? 'selected' : '' }>
                                                                                    ${classroom.classCode}
                                                                                    (${classroom.courseYear})
                                                                                </option>
                                                                            </c:forEach>
                                                                        </select>
                                                                    </div>
                                                                </div>

                                                                <!-- Search Students -->
                                                                <div class="col-md-6">
                                                                    <div class="input-group input-group-sm">
                                                                        <button class="btn btn-outline-primary btn-sm"
                                                                            type="button" id="studentSearchBtn">
                                                                            <i class="bi bi-search"></i>
                                                                        </button>
                                                                        <input type="text"
                                                                            class="form-control form-control-sm"
                                                                            id="studentSearch"
                                                                            placeholder="Tìm sinh viên...">
                                                                        <button class="btn btn-outline-secondary btn-sm"
                                                                            type="button" id="clearSearchBtn"
                                                                            style="display: none;" title="Xóa tìm kiếm">
                                                                            <i class="bi bi-x-circle"></i>
                                                                        </button>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>

                                                        <!-- Students Table -->
                                                        <div class="table-responsive"
                                                            style="max-height: 500px; overflow-y: auto;">
                                                            <table class="table table-hover table-sm mb-0">
                                                                <thead class="table-light sticky-top">
                                                                    <tr>
                                                                        <th width="50">STT</th>
                                                                        <th class="sortable" data-sort="username">MSSV
                                                                            <i
                                                                                class="bi bi-arrow-down-up sort-icon"></i>
                                                                        </th>
                                                                        <th class="sortable" data-sort="name">Họ tên
                                                                            <i
                                                                                class="bi bi-arrow-down-up sort-icon"></i>
                                                                        </th>
                                                                        <th class="sortable" data-sort="classroom">Lớp
                                                                            <i
                                                                                class="bi bi-arrow-down-up sort-icon"></i>
                                                                        </th>
                                                                        <th>Thao tác</th>
                                                                    </tr>
                                                                </thead>
                                                                <tbody id="studentsTableBody">
                                                                    <tr>
                                                                        <td colspan="5"
                                                                            class="text-center py-4 text-muted">
                                                                            <i
                                                                                class="bi bi-arrow-left display-6 d-block mb-2"></i>
                                                                            Vui lòng chọn một lớp từ danh sách bên trái
                                                                        </td>
                                                                    </tr>
                                                                </tbody>
                                                            </table>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                </div>

                                <!-- Add Classroom Modal -->
                                <div class="modal fade" id="addClassroomModal" tabindex="-1">
                                    <div class="modal-dialog">
                                        <div class="modal-content">
                                            <div class="modal-header">
                                                <h5 class="modal-title">
                                                    <i class="bi bi-plus-circle me-2"></i>Thêm lớp học mới
                                                </h5>
                                                <button type="button" class="btn-close"
                                                    data-bs-dismiss="modal"></button>
                                            </div>
                                            <form action="${pageContext.request.contextPath}/admin/classrooms/add"
                                                method="post">
                                                <div class="modal-body">
                                                    <div class="mb-3">
                                                        <label class="form-label">Mã lớp <span
                                                                class="text-danger">*</span></label>
                                                        <input type="text" class="form-control" name="classCode"
                                                            required>
                                                    </div>
                                                    <div class="mb-3">
                                                        <label class="form-label">Khóa học <span
                                                                class="text-danger">*</span></label>
                                                        <input type="text" class="form-control" name="courseYear"
                                                            pattern="[0-9]{4}-[0-9]{4}" placeholder="VD: 2025-2029"
                                                            title="Vui lòng nhập đúng định dạng YYYY-YYYY" required>
                                                        <small class="form-text text-muted">Định dạng: YYYY-YYYY (VD:
                                                            2025-2029)</small>
                                                    </div>
                                                    <div class="mb-3">
                                                        <label class="form-label">Ngành học</label>
                                                        <select class="form-select" name="majorId">
                                                            <option value="">-- Chọn ngành --</option>
                                                            <c:forEach var="major" items="${majors}">
                                                                <option value="${major.id}">${major.majorCode} -
                                                                    ${major.majorName}</option>
                                                            </c:forEach>
                                                        </select>
                                                    </div>
                                                </div>
                                                <div class="modal-footer">
                                                    <button type="button" class="btn btn-secondary"
                                                        data-bs-dismiss="modal">Hủy</button>
                                                    <button type="submit" class="btn btn-success">
                                                        <i class="bi bi-check-lg me-1"></i>Thêm lớp
                                                    </button>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </div>

                                <!-- Edit Classroom Modal -->
                                <div class="modal fade" id="editClassroomModal" tabindex="-1">
                                    <div class="modal-dialog">
                                        <div class="modal-content">
                                            <div class="modal-header">
                                                <h5 class="modal-title">
                                                    <i class="bi bi-pencil-square me-2"></i>Chỉnh sửa lớp học
                                                </h5>
                                                <button type="button" class="btn-close"
                                                    data-bs-dismiss="modal"></button>
                                            </div>
                                            <form id="editClassroomForm"
                                                action="${pageContext.request.contextPath}/admin/classrooms/update"
                                                method="post">
                                                <input type="hidden" name="${_csrf.parameterName}"
                                                    value="${_csrf.token}" />
                                                <input type="hidden" id="editClassroomId" name="id">

                                                <div class="modal-body">
                                                    <!-- Warning message for classes with students -->
                                                    <div id="editWarningMessage" class="alert alert-warning d-none">
                                                        <i class="bi bi-exclamation-triangle me-2"></i>
                                                        <strong>Lưu ý:</strong> Lớp học đã có sinh viên. Chỉ có thể thay
                                                        đổi giáo viên chủ nhiệm.
                                                    </div>

                                                    <div class="mb-3" id="editClassCodeGroup">
                                                        <label for="editClassCode" class="form-label">
                                                            Mã lớp <span class="text-danger">*</span>
                                                        </label>
                                                        <input type="text" class="form-control" id="editClassCode"
                                                            name="classCode" required>
                                                    </div>

                                                    <div class="mb-3" id="editCourseYearGroup">
                                                        <label for="editCourseYear" class="form-label">
                                                            Khóa học <span class="text-danger">*</span>
                                                        </label>
                                                        <input type="text" class="form-control" id="editCourseYear"
                                                            name="courseYear" pattern="[0-9]{4}-[0-9]{4}"
                                                            placeholder="VD: 2025-2029"
                                                            title="Vui lòng nhập đúng định dạng YYYY-YYYY" required>
                                                        <small class="form-text text-muted">Định dạng: YYYY-YYYY (VD:
                                                            2025-2029)</small>
                                                    </div>

                                                    <div class="mb-3" id="editMajorGroup">
                                                        <label for="editMajorId" class="form-label">
                                                            Ngành <span class="text-danger">*</span>
                                                        </label>
                                                        <select class="form-select" id="editMajorId" name="majorId"
                                                            required>
                                                            <option value="">Chọn ngành...</option>
                                                            <c:forEach var="major" items="${majors}">
                                                                <option value="${major.id}">${major.majorCode} -
                                                                    ${major.majorName}</option>
                                                            </c:forEach>
                                                        </select>
                                                    </div>

                                                    <div class="mb-3">
                                                        <label for="editTeacherId" class="form-label">
                                                            Giáo viên chủ nhiệm
                                                        </label>
                                                        <select class="form-select" id="editTeacherId" name="teacherId">
                                                            <option value="">Chọn giáo viên...</option>
                                                            <c:forEach var="teacher" items="${teachers}">
                                                                <option value="${teacher.id}">${teacher.user.username} -
                                                                    ${teacher.user.lname} ${teacher.user.fname}</option>
                                                            </c:forEach>
                                                        </select>
                                                    </div>

                                                    <div class="mb-3" id="editTeacherNotesGroup" style="display: none;">
                                                        <label for="editTeacherChangeNotes" class="form-label">
                                                            Ghi chú thay đổi chủ nhiệm
                                                        </label>
                                                        <textarea class="form-control" id="editTeacherChangeNotes"
                                                            name="teacherChangeNotes" rows="3"
                                                            placeholder="Nhập lý do thay đổi giáo viên chủ nhiệm..."></textarea>
                                                        <small class="form-text text-muted">
                                                            Ghi chú này sẽ được lưu vào lịch sử thay đổi chủ nhiệm
                                                        </small>
                                                    </div>
                                                </div>

                                                <div class="modal-footer">
                                                    <button type="button" class="btn btn-secondary"
                                                        data-bs-dismiss="modal">Hủy</button>
                                                    <button type="submit" class="btn btn-primary">
                                                        <i class="bi bi-check-lg me-1"></i>Cập nhật
                                                    </button>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </div>

                                <!-- Add Student Modal -->
                                <div class="modal fade" id="addStudentModal" tabindex="-1">
                                    <div class="modal-dialog modal-lg">
                                        <div class="modal-content">
                                            <div class="modal-header">
                                                <h5 class="modal-title">
                                                    <i class="bi bi-person-plus me-2"></i>Thêm sinh viên mới
                                                </h5>
                                                <button type="button" class="btn-close"
                                                    data-bs-dismiss="modal"></button>
                                            </div>
                                            <form action="${pageContext.request.contextPath}/admin/students/add"
                                                method="post">
                                                <div class="modal-body">
                                                    <div class="row">
                                                        <div class="col-md-6">
                                                            <div class="mb-3">
                                                                <label class="form-label">MSSV <span
                                                                        class="text-danger">*</span></label>
                                                                <input type="text" class="form-control" name="username"
                                                                    required>
                                                            </div>
                                                            <div class="mb-3">
                                                                <label class="form-label">Họ <span
                                                                        class="text-danger">*</span></label>
                                                                <input type="text" class="form-control" name="fname"
                                                                    required>
                                                            </div>
                                                            <div class="mb-3">
                                                                <label class="form-label">Tên <span
                                                                        class="text-danger">*</span></label>
                                                                <input type="text" class="form-control" name="lname"
                                                                    required>
                                                            </div>
                                                            <div class="mb-3">
                                                                <label class="form-label">Email</label>
                                                                <input type="email" class="form-control" name="email">
                                                            </div>
                                                        </div>
                                                        <div class="col-md-6">
                                                            <div class="mb-3">
                                                                <label class="form-label">Số điện thoại</label>
                                                                <input type="text" class="form-control" name="phone">
                                                            </div>
                                                            <div class="mb-3">
                                                                <label class="form-label">Ngày sinh</label>
                                                                <input type="date" class="form-control"
                                                                    name="birthDate">
                                                            </div>
                                                            <div class="mb-3">
                                                                <label class="form-label">Lớp học</label>
                                                                <select class="form-select" name="classroomId"
                                                                    id="studentClassroomSelect">
                                                                    <option value="">-- Chưa phân lớp --</option>
                                                                    <c:forEach var="classroom" items="${classrooms}">
                                                                        <option value="${classroom.id}">
                                                                            ${classroom.classCode}
                                                                            (${classroom.courseYear})</option>
                                                                    </c:forEach>
                                                                </select>
                                                            </div>
                                                            <div class="mb-3">
                                                                <label class="form-label">Ngành học</label>
                                                                <select class="form-select" name="majorId" required>
                                                                    <option value="">-- Chọn ngành --</option>
                                                                    <c:forEach var="major" items="${majors}">
                                                                        <option value="${major.id}">${major.majorCode} -
                                                                            ${major.majorName}</option>
                                                                    </c:forEach>
                                                                </select>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="modal-footer">
                                                    <button type="button" class="btn btn-secondary"
                                                        data-bs-dismiss="modal">Hủy</button>
                                                    <button type="submit" class="btn btn-success">
                                                        <i class="bi bi-check-lg me-1"></i>Thêm sinh viên
                                                    </button>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </div>

                                <script
                                    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
                                <script>
                                    // Global variables
                                    let selectedClassroomId = <c:choose><c:when test="${selectedClassroomId != null}">${selectedClassroomId}</c:when><c:otherwise>null</c:otherwise></c:choose>;
                                    let allStudents = [];

                                    // Notification function
                                    function showNotification(type, message, title) {
                                        // Create notification container if it doesn't exist
                                        let container = document.getElementById('notification-container');
                                        if (!container) {
                                            container = document.createElement('div');
                                            container.id = 'notification-container';
                                            container.style.cssText = 'position: fixed; top: 20px; right: 20px; z-index: 9999; max-width: 350px;';
                                            document.body.appendChild(container);
                                        }

                                        // Create notification element
                                        const notification = document.createElement('div');
                                        const alertClass = type === 'success' ? 'alert-success' : 'alert-danger';
                                        const icon = type === 'success' ? 'bi-check-circle-fill' : 'bi-exclamation-triangle-fill';

                                        notification.className = `alert ${alertClass} alert-dismissible fade show mb-2`;
                                        notification.innerHTML = `
                                            <div class="d-flex">
                                                <i class="bi ${icon} me-2 flex-shrink-0"></i>
                                                <div>
                                                    <strong>${title}:</strong> ${message}
                                                </div>
                                                <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert"></button>
                                            </div>
                                        `;

                                        container.appendChild(notification);

                                        // Auto remove after 5 seconds
                                        setTimeout(() => {
                                            notification.remove();
                                        }, 5000);
                                    }

                                    // Initialize page
                                    document.addEventListener('DOMContentLoaded', function () {
                                        loadAllStudents();
                                        setupEventListeners();

                                        // Auto-select classroom if provided
                                        if (selectedClassroomId) {
                                            updateStudentsDisplay(selectedClassroomId);
                                        }
                                    });

                                    function setupEventListeners() {
                                        // Classroom selector change
                                        document.getElementById('classroomSelector').addEventListener('change', function () {
                                            const classroomId = this.value;
                                            updateStudentsDisplay(classroomId);
                                            updateURL(classroomId);
                                        });

                                        // Student search
                                        document.getElementById('studentSearch').addEventListener('input', function () {
                                            filterStudents(this.value);
                                            toggleClearButton(this.value);
                                        });

                                        // Clear search button
                                        document.getElementById('clearSearchBtn').addEventListener('click', function () {
                                            document.getElementById('studentSearch').value = '';
                                            filterStudents('');
                                            toggleClearButton('');
                                        });

                                        // Filter form change
                                        document.getElementById('majorFilter').addEventListener('change', function () {
                                            document.getElementById('filterSearchForm').submit();
                                        });

                                        // Classroom search - only submit on Enter key
                                        const classroomSearchInput = document.querySelector('input[name="search"]');
                                        if (classroomSearchInput) {
                                            // Submit on Enter key
                                            classroomSearchInput.addEventListener('keypress', function (e) {
                                                if (e.key === 'Enter') {
                                                    e.preventDefault();
                                                    document.getElementById('filterSearchForm').submit();
                                                }
                                            });
                                        }

                                        // Add click handlers for sortable table headers
                                        document.querySelectorAll('.sortable').forEach(header => {
                                            header.style.cursor = 'pointer';
                                            header.addEventListener('click', function () {
                                                const sortField = this.getAttribute('data-sort');
                                                if (sortField) {
                                                    const currentUrl = new URL(window.location.href);
                                                    const currentSort = currentUrl.searchParams.get('sort');
                                                    const currentDir = currentUrl.searchParams.get('dir') || 'asc';

                                                    // Toggle direction if same field, otherwise use asc
                                                    const newDir = (currentSort === sortField && currentDir === 'asc') ? 'desc' : 'asc';

                                                    currentUrl.searchParams.set('sort', sortField);
                                                    currentUrl.searchParams.set('dir', newDir);
                                                    currentUrl.searchParams.set('page', '0'); // Reset to first page

                                                    window.location.href = currentUrl.toString();
                                                }
                                            });
                                        });
                                    }

                                    function selectClassroom(classroomId) {
                                        selectedClassroomId = classroomId;

                                        // Update visual selection
                                        document.querySelectorAll('.classroom-row').forEach(row => {
                                            row.classList.remove('table-primary');
                                        });
                                        event.currentTarget.classList.add('table-primary');

                                        // Update classroom selector
                                        document.getElementById('classroomSelector').value = classroomId;

                                        // Update students display
                                        updateStudentsDisplay(classroomId);
                                        updateURL(classroomId);
                                    }

                                    function updateStudentsDisplay(classroomId) {
                                        const title = document.getElementById('studentsTitle');
                                        const tbody = document.getElementById('studentsTableBody');

                                        if (!classroomId) {
                                            title.textContent = 'Tất cả sinh viên';
                                            displayStudents(allStudents);
                                        } else {
                                            const classroom = getClassroomById(classroomId);
                                            if (classroom) {
                                                title.textContent = 'Sinh viên lớp ' + classroom.classCode;
                                                const classroomStudents = allStudents.filter(s => s.classroomId == classroomId);
                                                displayStudents(classroomStudents);
                                            }
                                        }
                                    }

                                    function displayStudents(students) {
                                        const tbody = document.getElementById('studentsTableBody');

                                        if (students.length === 0) {
                                            tbody.innerHTML =
                                                '<tr>' +
                                                '<td colspan="5" class="text-center py-4 text-muted">' +
                                                '<i class="bi bi-inbox display-6 d-block mb-2"></i>' +
                                                'Không có sinh viên nào' +
                                                '</td>' +
                                                '</tr>';
                                            return;
                                        }

                                        tbody.innerHTML = students.map((student, index) => {
                                            const classroomName = student.classroomName || 'Chưa phân lớp';

                                            return '<tr class="student-row">' +
                                                '<td class="text-center fw-bold">' + (index + 1) + '</td>' +
                                                '<td class="fw-semibold text-primary">' + student.username + '</td>' +
                                                '<td class="fw-medium">' + student.fname + ' ' + student.lname + '</td>' +
                                                '<td>' +
                                                (student.classroomId ?
                                                    '<span class="badge bg-info">' + classroomName + '</span>' :
                                                    '<span class="text-muted">Chưa phân lớp</span>') +
                                                '</td>' +
                                                '<td>' +
                                                '<div class="btn-group btn-group-sm">' +
                                                '<button type="button" class="btn btn-outline-primary btn-sm" onclick="editStudent(' + student.id + ')" title="Sửa">' +
                                                '<i class="bi bi-pencil"></i>' +
                                                '</button>' +
                                                '<button type="button" class="btn btn-outline-danger btn-sm" onclick="deleteStudent(' + student.id + ')" title="Xóa">' +
                                                '<i class="bi bi-trash"></i>' +
                                                '</button>' +
                                                '</div>' +
                                                '</td>' +
                                                '</tr>';
                                        }).join('');
                                    }

                                    function filterStudents(searchTerm) {
                                        const classroomId = document.getElementById('classroomSelector').value;
                                        let students = classroomId ?
                                            allStudents.filter(s => s.classroomId == classroomId) :
                                            allStudents;

                                        if (searchTerm) {
                                            students = students.filter(s =>
                                                s.username.toLowerCase().includes(searchTerm.toLowerCase()) ||
                                                (s.fname + ' ' + s.lname).toLowerCase().includes(searchTerm.toLowerCase())
                                            );
                                        }

                                        displayStudents(students);
                                    }

                                    function getClassroomById(id) {
                                        // Sample classroom data - this should come from server
                                        const classroomData = [
                                            <c:forEach var="classroom" items="${classrooms}" varStatus="status">
                                                {
                                                    id: ${classroom.id},
                                                classCode: '${classroom.classCode}',
                                                courseYear: '${classroom.courseYear}'
                                                }<c:if test="${!status.last}">,</c:if>
                                            </c:forEach>
                                        ];
                                        return classroomData.find(c => c.id == id);
                                    }

                                    function updateURL(classroomId) {
                                        const url = new URL(window.location);
                                        if (classroomId) {
                                            url.searchParams.set('selectedClassroomId', classroomId);
                                        } else {
                                            url.searchParams.delete('selectedClassroomId');
                                        }
                                        window.history.pushState({}, '', url);
                                    }

                                    function loadAllStudents() {
                                        // Load students via AJAX
                                        fetch('${pageContext.request.contextPath}/admin/students/api/all')
                                            .then(response => response.json())
                                            .then(data => {
                                                allStudents = data;
                                                if (selectedClassroomId) {
                                                    updateStudentsDisplay(selectedClassroomId);
                                                }
                                            })
                                            .catch(error => {
                                                console.error('Error loading students:', error);
                                                // Use sample data for now
                                                allStudents = [];
                                            });
                                    }

                                    function toggleClearButton(searchValue) {
                                        const clearBtn = document.getElementById('clearSearchBtn');
                                        if (searchValue && searchValue.trim() !== '') {
                                            clearBtn.style.display = 'block';
                                        } else {
                                            clearBtn.style.display = 'none';
                                        }
                                    }

                                    // CRUD operation functions
                                    function editClassroom(id) {
                                        console.log('Edit classroom clicked:', id);

                                        // Get classroom data from API
                                        fetch('${pageContext.request.contextPath}/admin/classrooms/' + id + '/api')
                                            .then(response => {
                                                if (!response.ok) {
                                                    throw new Error('Classroom not found');
                                                }
                                                return response.json();
                                            })
                                            .then(classroom => {
                                                // Populate the edit modal
                                                document.getElementById('editClassroomId').value = classroom.id;
                                                document.getElementById('editClassCode').value = classroom.classCode || '';
                                                document.getElementById('editCourseYear').value = classroom.courseYear || '';
                                                document.getElementById('editMajorId').value = classroom.majorId || '';
                                                document.getElementById('editTeacherId').value = classroom.teacherId || '';

                                                // Clear teacher change notes
                                                document.getElementById('editTeacherChangeNotes').value = '';

                                                // Handle restrictions for classes with students
                                                if (classroom.hasStudents) {
                                                    document.getElementById('editWarningMessage').classList.remove('d-none');
                                                    document.getElementById('editClassCodeGroup').style.display = 'none';
                                                    document.getElementById('editCourseYearGroup').style.display = 'none';
                                                    document.getElementById('editMajorGroup').style.display = 'none';
                                                    document.getElementById('editTeacherNotesGroup').style.display = 'block';

                                                    // Remove required attributes
                                                    document.getElementById('editClassCode').removeAttribute('required');
                                                    document.getElementById('editCourseYear').removeAttribute('required');
                                                    document.getElementById('editMajorId').removeAttribute('required');
                                                } else {
                                                    document.getElementById('editWarningMessage').classList.add('d-none');
                                                    document.getElementById('editClassCodeGroup').style.display = 'block';
                                                    document.getElementById('editCourseYearGroup').style.display = 'block';
                                                    document.getElementById('editMajorGroup').style.display = 'block';
                                                    document.getElementById('editTeacherNotesGroup').style.display = 'none';

                                                    // Add required attributes back
                                                    document.getElementById('editClassCode').setAttribute('required', 'required');
                                                    document.getElementById('editCourseYear').setAttribute('required', 'required');
                                                    document.getElementById('editMajorId').setAttribute('required', 'required');
                                                }

                                                // Show the modal
                                                const modal = new bootstrap.Modal(document.getElementById('editClassroomModal'));
                                                modal.show();
                                            })
                                            .catch(error => {
                                                console.error('Error loading classroom data:', error);
                                                alert('Có lỗi xảy ra khi tải dữ liệu lớp học!');
                                            });
                                    }

                                    function deleteClassroom(id) {
                                        console.log('Delete classroom clicked:', id);
                                        if (confirm('Bạn có chắc chắn muốn xóa lớp này?\n\nChú ý: Chỉ có thể xóa lớp không có sinh viên.')) {
                                            // Create and submit form with CSRF token
                                            const form = document.createElement('form');
                                            form.method = 'POST';
                                            form.action = '${pageContext.request.contextPath}/admin/classrooms/delete';

                                            // Add CSRF token
                                            const csrfToken = document.createElement('input');
                                            csrfToken.type = 'hidden';
                                            csrfToken.name = '${_csrf.parameterName}';
                                            csrfToken.value = '${_csrf.token}';
                                            form.appendChild(csrfToken);

                                            // Add classroom ID
                                            const idInput = document.createElement('input');
                                            idInput.type = 'hidden';
                                            idInput.name = 'id';
                                            idInput.value = id;
                                            form.appendChild(idInput);

                                            document.body.appendChild(form);
                                            form.submit();
                                        }
                                    }

                                    function editStudent(id) {
                                        // Implement edit student modal
                                        alert('Edit student: ' + id);
                                    }

                                    function deleteStudent(id) {
                                        if (confirm('Bạn có chắc chắn muốn xóa sinh viên này?')) {
                                            window.location.href = '${pageContext.request.contextPath}/admin/students/delete/' + id;
                                        }
                                    }

                                    // Auto-select classroom when adding student
                                    document.addEventListener('DOMContentLoaded', function () {
                                        const addStudentModal = document.getElementById('addStudentModal');
                                        if (addStudentModal) {
                                            addStudentModal.addEventListener('show.bs.modal', function () {
                                                if (selectedClassroomId) {
                                                    document.getElementById('studentClassroomSelect').value = selectedClassroomId;
                                                }
                                            });
                                        }

                                        // Reset edit modal when closed
                                        const editClassroomModal = document.getElementById('editClassroomModal');
                                        if (editClassroomModal) {
                                            editClassroomModal.addEventListener('hidden.bs.modal', function () {
                                                // Reset form
                                                document.getElementById('editClassroomForm').reset();

                                                // Reset visibility of fields
                                                document.getElementById('editWarningMessage').classList.add('d-none');
                                                document.getElementById('editClassCodeGroup').style.display = 'block';
                                                document.getElementById('editCourseYearGroup').style.display = 'block';
                                                document.getElementById('editMajorGroup').style.display = 'block';
                                                document.getElementById('editTeacherNotesGroup').style.display = 'none';

                                                // Restore required attributes
                                                document.getElementById('editClassCode').setAttribute('required', 'required');
                                                document.getElementById('editCourseYear').setAttribute('required', 'required');
                                                document.getElementById('editMajorId').setAttribute('required', 'required');
                                            });
                                        }

                                        // Handle edit form submission with AJAX
                                        const editClassroomForm = document.getElementById('editClassroomForm');
                                        if (editClassroomForm) {
                                            editClassroomForm.addEventListener('submit', function (e) {
                                                e.preventDefault(); // Prevent normal form submission

                                                // Get form data
                                                const formData = new FormData(this);

                                                // Show loading state
                                                const submitBtn = this.querySelector('button[type="submit"]');
                                                const originalText = submitBtn.innerHTML;
                                                submitBtn.innerHTML = '<i class="bi bi-hourglass-split me-1"></i>Đang cập nhật...';
                                                submitBtn.disabled = true;

                                                // Submit via AJAX
                                                fetch(this.action, {
                                                    method: 'POST',
                                                    body: formData
                                                })
                                                    .then(response => {
                                                        if (response.ok) {
                                                            // Close modal
                                                            const modal = bootstrap.Modal.getInstance(editClassroomModal);
                                                            modal.hide();

                                                            // Show success message
                                                            showNotification('success', 'Cập nhật lớp học thành công!', 'Thành công');

                                                            // Reload page to reflect changes
                                                            setTimeout(() => {
                                                                window.location.reload();
                                                            }, 1000);
                                                        } else {
                                                            throw new Error('Update failed');
                                                        }
                                                    })
                                                    .catch(error => {
                                                        console.error('Error updating classroom:', error);
                                                        showNotification('error', 'Có lỗi xảy ra khi cập nhật lớp học!', 'Lỗi');
                                                    })
                                                    .finally(() => {
                                                        // Restore button state
                                                        submitBtn.innerHTML = originalText;
                                                        submitBtn.disabled = false;
                                                    });
                                            });
                                        }

                                        // Setup course year validation
                                        setupCourseYearValidation();

                                        // Check for flash messages on page load
                                        const successMessage = '${success}';
                                        if (successMessage && successMessage.trim() !== '') {
                                            showNotification('success', successMessage, 'Thành công');
                                        }

                                        const errorMessage = '${error}';
                                        if (errorMessage && errorMessage.trim() !== '') {
                                            showNotification('error', errorMessage, 'Lỗi');
                                        }
                                    });

                                    // Function to setup course year validation
                                    function setupCourseYearValidation() {
                                        // Add modal course year validation
                                        const addCourseYearInput = document.querySelector('#addClassroomModal input[name="courseYear"]');
                                        if (addCourseYearInput) {
                                            addCourseYearInput.addEventListener('input', function () {
                                                validateCourseYear(this);
                                            });
                                            addCourseYearInput.addEventListener('invalid', function () {
                                                this.setCustomValidity('Vui lòng nhập đúng định dạng YYYY-YYYY (VD: 2025-2029)');
                                            });
                                        }

                                        // Edit modal course year validation
                                        const editCourseYearInput = document.getElementById('editCourseYear');
                                        if (editCourseYearInput) {
                                            editCourseYearInput.addEventListener('input', function () {
                                                validateCourseYear(this);
                                            });
                                            editCourseYearInput.addEventListener('invalid', function () {
                                                this.setCustomValidity('Vui lòng nhập đúng định dạng YYYY-YYYY (VD: 2025-2029)');
                                            });
                                        }
                                    }

                                    // Function to validate course year format
                                    function validateCourseYear(input) {
                                        const pattern = /^[0-9]{4}-[0-9]{4}$/;
                                        const value = input.value.trim();

                                        // Remove any existing custom validity
                                        input.setCustomValidity('');

                                        if (value && !pattern.test(value)) {
                                            input.setCustomValidity('Vui lòng nhập đúng định dạng YYYY-YYYY (VD: 2025-2029)');
                                            input.classList.add('is-invalid');
                                        } else if (value && pattern.test(value)) {
                                            // Additional validation: check if years are logical
                                            const years = value.split('-');
                                            const startYear = parseInt(years[0]);
                                            const endYear = parseInt(years[1]);

                                            if (endYear <= startYear) {
                                                input.setCustomValidity('Năm kết thúc phải lớn hơn năm bắt đầu');
                                                input.classList.add('is-invalid');
                                            } else if (endYear - startYear > 10) {
                                                input.setCustomValidity('Khóa học không nên dài quá 10 năm');
                                                input.classList.add('is-invalid');
                                            } else {
                                                input.classList.remove('is-invalid');
                                                input.classList.add('is-valid');
                                            }
                                        } else {
                                            input.classList.remove('is-invalid', 'is-valid');
                                        }
                                    }
                                </script>
                </body>

                </html>