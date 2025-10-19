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
                        .form-control.is-invalid,
                        .form-select.is-invalid {
                            border-color: #dc3545;
                            box-shadow: 0 0 0 0.2rem rgba(220, 53, 69, 0.25);
                        }

                        .form-control.is-valid,
                        .form-select.is-valid {
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
                                                        <div class="d-flex gap-2">
                                                            <button type="button" class="btn btn-success btn-sm"
                                                                data-bs-toggle="modal" data-bs-target="#addStudentModal"
                                                                id="addStudentBtn">
                                                                <i class="bi bi-person-plus me-1"></i>
                                                                <span id="addStudentText">Thêm sinh viên</span>
                                                            </button>
                                                            <button type="button" class="btn btn-primary btn-sm"
                                                                data-bs-toggle="modal"
                                                                data-bs-target="#assignStudentModal"
                                                                id="assignStudentBtn" style="display: none;">
                                                                <i class="bi bi-person-check me-1"></i>Gán sinh viên vào
                                                                lớp
                                                            </button>
                                                        </div>
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
                                            <form id="addClassroomForm"
                                                action="${pageContext.request.contextPath}/admin/classrooms/add"
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
                                                        <label class="form-label">Ngành học <span
                                                                class="text-danger">*</span></label>
                                                        <select class="form-select" name="majorId" required>
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
                                                                <label class="form-label">Mật khẩu</label>
                                                                <input type="password" class="form-control"
                                                                    name="password"
                                                                    placeholder="Để trống để dùng MSSV làm mật khẩu">
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
                                                                <label class="form-label">Địa chỉ</label>
                                                                <input type="text" class="form-control" name="address">
                                                            </div>
                                                            <div class="mb-3">
                                                                <label class="form-label">Lớp học</label>
                                                                <select class="form-select" name="classId"
                                                                    id="studentClassroomSelect">
                                                                    <option value="">-- Chưa phân lớp --</option>
                                                                    <c:forEach var="classroom" items="${classrooms}">
                                                                        <option value="${classroom.id}"
                                                                            data-major-id="${classroom.major.id}">
                                                                            ${classroom.classCode}
                                                                            (${classroom.courseYear})</option>
                                                                    </c:forEach>
                                                                </select>
                                                            </div>
                                                            <div class="mb-3">
                                                                <label class="form-label">Ngành học</label>
                                                                <select class="form-select" name="majorId"
                                                                    id="studentMajorSelect" required>
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

                                <!-- Edit Student Modal -->
                                <div class="modal fade" id="editStudentModal" tabindex="-1">
                                    <div class="modal-dialog modal-lg">
                                        <div class="modal-content">
                                            <div class="modal-header">
                                                <h5 class="modal-title">
                                                    <i class="bi bi-pencil me-2"></i>Chỉnh sửa sinh viên
                                                </h5>
                                                <button type="button" class="btn-close"
                                                    data-bs-dismiss="modal"></button>
                                            </div>
                                            <form action="${pageContext.request.contextPath}/admin/students/edit"
                                                method="post">
                                                <input type="hidden" id="editStudentId" name="studentId" value="">
                                                <div class="modal-body">
                                                    <div class="row g-3">
                                                        <!-- Username (readonly) -->
                                                        <div class="col-md-6">
                                                            <label for="editUsername" class="form-label">
                                                                <span class="text-danger">*</span> MSSV
                                                            </label>
                                                            <input type="text" class="form-control" id="editUsername"
                                                                name="username" readonly>
                                                        </div>

                                                        <!-- Full Name -->
                                                        <div class="col-md-6">
                                                            <label for="editFullName" class="form-label">
                                                                <span class="text-danger">*</span> Họ và tên
                                                            </label>
                                                            <input type="text" class="form-control" id="editFullName"
                                                                name="fullName" required>
                                                        </div>

                                                        <!-- Email -->
                                                        <div class="col-md-6">
                                                            <label for="editEmail" class="form-label">Email</label>
                                                            <input type="email" class="form-control" id="editEmail"
                                                                name="email">
                                                        </div>

                                                        <!-- Phone -->
                                                        <div class="col-md-6">
                                                            <label for="editPhone" class="form-label">Số điện
                                                                thoại</label>
                                                            <input type="tel" class="form-control" id="editPhone"
                                                                name="phone">
                                                        </div>

                                                        <!-- Address -->
                                                        <div class="col-12">
                                                            <label for="editAddress" class="form-label">Địa chỉ</label>
                                                            <input type="text" class="form-control" id="editAddress"
                                                                name="address">
                                                        </div>

                                                        <!-- Birth Date -->
                                                        <div class="col-md-6">
                                                            <label for="editBirthDate" class="form-label">Ngày
                                                                sinh</label>
                                                            <input type="date" class="form-control" id="editBirthDate"
                                                                name="birthDate">
                                                        </div>

                                                        <!-- Classroom -->
                                                        <div class="col-md-6">
                                                            <label for="editClassroomSelect" class="form-label">Lớp
                                                                học</label>
                                                            <select class="form-select" id="editClassroomSelect"
                                                                name="classId">
                                                                <option value="">Chưa phân lớp</option>
                                                                <c:forEach var="classroom" items="${classrooms}">
                                                                    <option value="${classroom.id}"
                                                                        data-major-id="${classroom.major.id}">
                                                                        ${classroom.classCode} (${classroom.courseYear})
                                                                    </option>
                                                                </c:forEach>
                                                            </select>
                                                        </div>

                                                        <!-- Major -->
                                                        <div class="col-md-6">
                                                            <label for="editMajorSelect" class="form-label">
                                                                <span class="text-danger">*</span> Ngành học
                                                            </label>
                                                            <select class="form-select" id="editMajorSelect"
                                                                name="majorId" required>
                                                                <c:forEach var="major" items="${majors}">
                                                                    <option value="${major.id}">
                                                                        ${major.majorName} (${major.majorCode})
                                                                    </option>
                                                                </c:forEach>
                                                            </select>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="modal-footer">
                                                    <button type="button" class="btn btn-danger me-auto"
                                                        id="resetStudentPasswordBtn">
                                                        <i class="bi bi-key me-2"></i>Đặt lại mật khẩu
                                                    </button>
                                                    <button type="button" class="btn btn-secondary"
                                                        data-bs-dismiss="modal">
                                                        <i class="bi bi-x-circle me-1"></i>Hủy
                                                    </button>
                                                    <button type="submit" class="btn btn-primary">
                                                        <i class="bi bi-check-circle me-1"></i>Cập nhật
                                                    </button>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </div>

                                <!-- Student Password Reset Modal -->
                                <div class="modal fade" id="passwordResetStudentModal" tabindex="-1"
                                    aria-labelledby="passwordResetStudentModalLabel" aria-hidden="true">
                                    <div class="modal-dialog modal-dialog-centered">
                                        <div class="modal-content">
                                            <div class="modal-header">
                                                <h5 class="modal-title" id="passwordResetStudentModalLabel">
                                                    <i class="bi bi-shield-lock me-2"></i>Xác nhận đặt lại mật khẩu
                                                </h5>
                                                <button type="button" class="btn-close" data-bs-dismiss="modal"
                                                    aria-label="Close"></button>
                                            </div>
                                            <form id="passwordResetStudentForm">
                                                <div class="modal-body">
                                                    <p class="mb-3">
                                                        <i class="bi bi-exclamation-triangle text-warning me-2"></i>
                                                        Để xác nhận đặt lại mật khẩu sinh viên, vui lòng nhập mật khẩu
                                                        của bạn:
                                                    </p>
                                                    <div class="mb-3">
                                                        <label for="adminPasswordStudent" class="form-label">Mật khẩu
                                                            Admin</label>
                                                        <input type="password" class="form-control"
                                                            id="adminPasswordStudent" placeholder="Nhập mật khẩu admin"
                                                            required>
                                                        <input type="hidden" id="resetStudentId" name="studentId"
                                                            value="">
                                                    </div>
                                                </div>
                                                <div class="modal-footer">
                                                    <button type="button" class="btn btn-secondary"
                                                        data-bs-dismiss="modal">Hủy</button>
                                                    <button type="submit" class="btn btn-danger">
                                                        <i class="bi bi-key me-2"></i>Xác nhận đặt lại
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

                                    // Custom Confirmation Modal Functions
                                    function showConfirmModal(title, message, note, onConfirm) {
                                        const modal = document.getElementById('confirmModal');
                                        const titleEl = document.getElementById('confirmModalTitle');
                                        const messageEl = document.getElementById('confirmModalMessage');
                                        const noteEl = document.getElementById('confirmModalNote');
                                        const okBtn = document.getElementById('confirmModalOkBtn');

                                        titleEl.textContent = title;
                                        messageEl.textContent = message;
                                        noteEl.textContent = note || '';
                                        noteEl.style.display = note ? 'block' : 'none';

                                        // Remove old event listeners
                                        const newOkBtn = okBtn.cloneNode(true);
                                        okBtn.parentNode.replaceChild(newOkBtn, okBtn);

                                        // Add new event listener
                                        newOkBtn.addEventListener('click', function () {
                                            const bootstrapModal = bootstrap.Modal.getInstance(modal);
                                            bootstrapModal.hide();
                                            if (onConfirm) onConfirm();
                                        });

                                        // Show modal
                                        const bootstrapModal = new bootstrap.Modal(modal);
                                        bootstrapModal.show();
                                    }

                                    // Custom Warning Modal Function
                                    function showWarningModal(title, message, note) {
                                        const modal = document.getElementById('warningModal');
                                        const titleEl = document.getElementById('warningModalTitle');
                                        const messageEl = document.getElementById('warningModalMessage');
                                        const noteEl = document.getElementById('warningModalNote');

                                        titleEl.textContent = title;
                                        messageEl.textContent = message;
                                        noteEl.textContent = note || '';
                                        noteEl.style.display = note ? 'block' : 'none';

                                        // Show modal
                                        const bootstrapModal = new bootstrap.Modal(modal);
                                        bootstrapModal.show();
                                    }

                                    // Initialize page
                                    document.addEventListener('DOMContentLoaded', function () {
                                        loadAllStudents(); // This will handle the initial display
                                        setupEventListeners();
                                    });

                                    function setupEventListeners() {
                                        // Classroom selector change
                                        document.getElementById('classroomSelector').addEventListener('change', function () {
                                            const classroomId = this.value;
                                            updateStudentsDisplay(classroomId);
                                            updateURL(classroomId);
                                        });

                                        // Student search - only on search button click or Enter key
                                        function performSearch() {
                                            const searchValue = document.getElementById('studentSearch').value;
                                            filterStudents(searchValue);
                                            toggleClearButton(searchValue);
                                        }

                                        // Search button click
                                        document.getElementById('studentSearchBtn').addEventListener('click', performSearch);

                                        // Search on Enter key
                                        document.getElementById('studentSearch').addEventListener('keydown', function (e) {
                                            if (e.key === 'Enter') {
                                                e.preventDefault();
                                                performSearch();
                                            }
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

                                        // Form validation for classroom forms
                                        setupClassroomFormValidation();
                                    }

                                    function setupClassroomFormValidation() {
                                        // Add classroom form validation
                                        const addForm = document.getElementById('addClassroomForm');
                                        if (addForm) {
                                            addForm.addEventListener('submit', function (e) {
                                                const majorSelect = addForm.querySelector('select[name="majorId"]');
                                                if (!majorSelect.value || majorSelect.value === '') {
                                                    e.preventDefault();
                                                    showWarningModal(
                                                        'Thiếu thông tin bắt buộc',
                                                        'Vui lòng chọn ngành học cho lớp.',
                                                        'Ngành học là thông tin bắt buộc khi tạo lớp mới.'
                                                    );
                                                    // Focus on the major select
                                                    majorSelect.focus();
                                                    majorSelect.classList.add('is-invalid');
                                                    return false;
                                                }
                                                majorSelect.classList.remove('is-invalid');
                                            });
                                        }

                                        // Edit classroom form validation
                                        const editForm = document.getElementById('editClassroomForm');
                                        if (editForm) {
                                            editForm.addEventListener('submit', function (e) {
                                                const majorSelect = editForm.querySelector('select[name="majorId"]');
                                                if (!majorSelect.value || majorSelect.value === '') {
                                                    e.preventDefault();
                                                    showWarningModal(
                                                        'Thiếu thông tin bắt buộc',
                                                        'Vui lòng chọn ngành học cho lớp.',
                                                        'Ngành học là thông tin bắt buộc.'
                                                    );
                                                    // Focus on the major select
                                                    majorSelect.focus();
                                                    majorSelect.classList.add('is-invalid');
                                                    return false;
                                                }
                                                majorSelect.classList.remove('is-invalid');
                                            });
                                        }

                                        // Remove invalid class when user selects a major
                                        document.querySelectorAll('select[name="majorId"]').forEach(select => {
                                            select.addEventListener('change', function () {
                                                if (this.value && this.value !== '') {
                                                    this.classList.remove('is-invalid');
                                                }
                                            });

                                            // Custom validation message for HTML5 validation
                                            select.addEventListener('invalid', function () {
                                                if (this.validity.valueMissing) {
                                                    this.setCustomValidity('Vui lòng chọn một ngành');
                                                }
                                            });

                                            // Clear custom message when user interacts
                                            select.addEventListener('input', function () {
                                                this.setCustomValidity('');
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
                                        const addStudentText = document.getElementById('addStudentText');
                                        const assignStudentBtn = document.getElementById('assignStudentBtn');

                                        if (!classroomId) {
                                            title.textContent = 'Tất cả sinh viên';
                                            addStudentText.textContent = 'Thêm sinh viên';
                                            assignStudentBtn.style.display = 'none';
                                            displayStudents(allStudents);
                                        } else {
                                            const classroom = getClassroomById(classroomId);
                                            if (classroom) {
                                                title.textContent = 'Sinh viên lớp ' + classroom.classCode;
                                                addStudentText.textContent = 'Thêm sinh viên mới';
                                                assignStudentBtn.style.display = 'block';
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
                                            const fullName = (student.lname ? student.lname + ' ' : '') + (student.fname || '');

                                            // Determine which delete action to show
                                            const currentClassroomId = document.getElementById('classroomSelector').value;
                                            let deleteButton = '';

                                            if (currentClassroomId && currentClassroomId !== '') {
                                                // In specific classroom: show remove from class button
                                                deleteButton = '<button type="button" class="btn btn-outline-warning btn-sm" onclick="removeFromClass(' + student.id + ', ' + currentClassroomId + ')" title="Xóa khỏi lớp">' +
                                                    '<i class="bi bi-person-dash"></i>' +
                                                    '</button>';
                                            } else {
                                                // In "All classes": show delete student button only for unassigned students
                                                if (!student.classroomId) {
                                                    deleteButton = '<button type="button" class="btn btn-outline-danger btn-sm" onclick="deleteStudent(' + student.id + ')" title="Xóa sinh viên">' +
                                                        '<i class="bi bi-trash"></i>' +
                                                        '</button>';
                                                } else {
                                                    deleteButton = '<button type="button" class="btn btn-outline-secondary btn-sm" disabled title="Không thể xóa - sinh viên đã có lớp">' +
                                                        '<i class="bi bi-shield-lock"></i>' +
                                                        '</button>';
                                                }
                                            }

                                            return '<tr class="student-row">' +
                                                '<td class="text-center fw-bold">' + (index + 1) + '</td>' +
                                                '<td class="fw-semibold text-primary">' + student.username + '</td>' +
                                                '<td class="fw-medium">' + fullName + '</td>' +
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
                                                deleteButton +
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
                                                ((s.lname || '') + ' ' + (s.fname || '')).toLowerCase().includes(searchTerm.toLowerCase())
                                            );
                                        }

                                        displayStudents(students);
                                    }

                                    function getClassroomById(id) {
                                        if (!id) return null;

                                        // Get classroom data from selector options
                                        const selector = document.getElementById('classroomSelector');

                                        // Find the option with matching value
                                        let foundOption = null;
                                        for (let i = 0; i < selector.options.length; i++) {
                                            const option = selector.options[i];
                                            if (option.value === id.toString()) {
                                                foundOption = option;
                                                break;
                                            }
                                        }

                                        if (foundOption) {
                                            const text = foundOption.textContent.trim();
                                            const matches = text.match(/^(.+?)\s*\((.+?)\)$/);
                                            if (matches) {
                                                return {
                                                    id: parseInt(id),
                                                    classCode: matches[1].trim(),
                                                    courseYear: matches[2].trim()
                                                };
                                            }
                                        }
                                        return null;
                                    } function updateURL(classroomId) {
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
                                                // Always update display after loading data
                                                if (selectedClassroomId) {
                                                    updateStudentsDisplay(selectedClassroomId);
                                                } else {
                                                    // Show all students by default
                                                    updateStudentsDisplay(null);
                                                }
                                            })
                                            .catch(error => {
                                                console.error('Error loading students:', error);
                                                // Use empty array as fallback
                                                allStudents = [];
                                                updateStudentsDisplay(null);
                                            });
                                    }

                                    function updateDebug(message) {
                                        const debugElement = document.getElementById('debugText');
                                        if (debugElement) {
                                            debugElement.textContent = message;
                                        }
                                    }

                                    function debugDropdownOptions() {
                                        const selector = document.getElementById('classroomSelector');
                                        console.log('Dropdown options:');
                                        console.log('Total options:', selector.options.length);
                                        for (let i = 0; i < selector.options.length; i++) {
                                            const option = selector.options[i];
                                            console.log(`Option ${i}: value="${option.value}", text="${option.textContent.trim()}"`);
                                        }
                                        console.log('Selected value:', selector.value);
                                        console.log('Selected index:', selector.selectedIndex);
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

                                        // Kiểm tra trước khi xóa
                                        fetch('${pageContext.request.contextPath}/admin/classrooms/check-before-delete/' + id)
                                            .then(response => response.json())
                                            .then(data => {
                                                console.log('Check result:', data);

                                                if (data.canDelete) {
                                                    // Có thể xóa - hiển thị confirm dialog
                                                    showConfirmModal(
                                                        'Xóa lớp học',
                                                        'Bạn có chắc chắn muốn xóa lớp "' + data.classCode + '"?',
                                                        'Hành động này không thể hoàn tác.',
                                                        function () {
                                                            // Thực hiện xóa
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
                                                    );
                                                } else {
                                                    // Không thể xóa - hiển thị cảnh báo
                                                    showWarningModal(
                                                        'Không thể xóa lớp học',
                                                        data.message,
                                                        data.studentCount ?
                                                            'Vui lòng chuyển tất cả sinh viên ra khỏi lớp trước khi xóa.' :
                                                            'Hãy kiểm tra lại thông tin lớp học.'
                                                    );
                                                }
                                            })
                                            .catch(error => {
                                                console.error('Error checking classroom:', error);
                                                showWarningModal(
                                                    'Lỗi',
                                                    'Có lỗi xảy ra khi kiểm tra thông tin lớp học.',
                                                    'Vui lòng thử lại sau.'
                                                );
                                            });
                                    }

                                    function editStudent(id) {
                                        // Find student data from allStudents array
                                        const student = allStudents.find(s => s.id == id);
                                        if (!student) {
                                            alert('Không tìm thấy thông tin sinh viên');
                                            return;
                                        }

                                        // Populate modal with student data
                                        document.getElementById('editStudentId').value = student.id;
                                        document.getElementById('editUsername').value = student.username;
                                        document.getElementById('editFullName').value = (student.lname ? student.lname + ' ' : '') + (student.fname || '');
                                        document.getElementById('editEmail').value = student.email || '';
                                        document.getElementById('editPhone').value = student.phone || '';
                                        document.getElementById('editAddress').value = student.address || '';
                                        document.getElementById('editBirthDate').value = student.birthDate || '';

                                        // Set classroom and major
                                        document.getElementById('editClassroomSelect').value = student.classroomId || '';
                                        document.getElementById('editMajorSelect').value = student.majorId || '';

                                        // Reset password reset button to original state
                                        const resetBtn = document.getElementById('resetStudentPasswordBtn');
                                        if (resetBtn) {
                                            resetBtn.innerHTML = '<i class="bi bi-key me-2"></i>Đặt lại mật khẩu';
                                            resetBtn.classList.remove('btn-success');
                                            resetBtn.classList.add('btn-danger');
                                            resetBtn.disabled = false;
                                        }

                                        // Show modal
                                        const modal = new bootstrap.Modal(document.getElementById('editStudentModal'));
                                        modal.show();
                                    }

                                    function deleteStudent(id) {
                                        showConfirmModal(
                                            'Xóa sinh viên',
                                            'Bạn có chắc chắn muốn xóa sinh viên này hoàn toàn?',
                                            'Hành động này không thể hoàn tác.',
                                            function () {
                                                window.location.href = '${pageContext.request.contextPath}/admin/students/delete/' + id;
                                            }
                                        );
                                    }

                                    function removeFromClass(studentId, classroomId) {
                                        console.log('removeFromClass called with:', { studentId, classroomId });
                                        showConfirmModal(
                                            'Xóa khỏi lớp',
                                            'Bạn có chắc chắn muốn xóa sinh viên này khỏi lớp?',
                                            'Sinh viên sẽ chuyển về trạng thái "Chưa phân lớp".',
                                            function () {
                                                console.log('Confirmation confirmed, proceeding with removal...');

                                                // Create form data for remove from class request
                                                const formData = new FormData();
                                                formData.append('studentId', studentId);
                                                // Add CSRF token
                                                formData.append('${_csrf.parameterName}', '${_csrf.token}');

                                                console.log('FormData prepared for remove from class:', {
                                                    studentId: formData.get('studentId'),
                                                    csrfToken: formData.get('${_csrf.parameterName}')
                                                });

                                                // Submit the remove from class form
                                                console.log('Sending AJAX request to /admin/students/remove-from-class');
                                                fetch('${pageContext.request.contextPath}/admin/students/remove-from-class', {
                                                    method: 'POST',
                                                    body: formData
                                                }).then(response => {
                                                    console.log('Response received:', response);
                                                    console.log('Response status:', response.status);
                                                    console.log('Response ok:', response.ok);
                                                    if (response.ok) {
                                                        console.log('Response OK, reloading page...');
                                                        // Reload the page to show updated data
                                                        window.location.reload();
                                                    } else {
                                                        console.error('Response not OK, status:', response.status);
                                                        response.text().then(text => {
                                                            console.error('Response text:', text);
                                                        });
                                                        alert('Có lỗi xảy ra khi xóa sinh viên khỏi lớp!');
                                                    }
                                                }).catch(error => {
                                                    console.error('Fetch error:', error);
                                                    alert('Có lỗi xảy ra khi xóa sinh viên khỏi lớp!');
                                                });
                                            }
                                        );
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

                                    // Auto-select classroom when adding student
                                    document.addEventListener('DOMContentLoaded', function () {
                                        const addStudentModal = document.getElementById('addStudentModal');
                                        const classSelect = document.getElementById('studentClassroomSelect');
                                        const majorSelect = document.getElementById('studentMajorSelect');

                                        if (addStudentModal && classSelect && majorSelect) {
                                            // Function to auto-select major based on classroom
                                            function updateMajorBasedOnClassroom() {
                                                const selectedOption = classSelect.options[classSelect.selectedIndex];
                                                if (selectedOption && selectedOption.value) {
                                                    const majorId = selectedOption.getAttribute('data-major-id');
                                                    if (majorId) {
                                                        majorSelect.value = majorId;
                                                        majorSelect.disabled = true;
                                                    } else {
                                                        majorSelect.disabled = false;
                                                    }
                                                } else {
                                                    majorSelect.disabled = false;
                                                }
                                            }

                                            // Auto-select classroom when modal opens
                                            addStudentModal.addEventListener('show.bs.modal', function () {
                                                if (selectedClassroomId && !classSelect.value) {
                                                    classSelect.value = selectedClassroomId;
                                                }
                                                updateMajorBasedOnClassroom();
                                            });

                                            // Update major when classroom changes
                                            classSelect.addEventListener('change', updateMajorBasedOnClassroom);

                                            // Re-enable major select on form submit
                                            addStudentModal.querySelector('form').addEventListener('submit', function () {
                                                majorSelect.disabled = false;
                                            });
                                        }

                                        // Assign Student Modal functionality
                                        const assignStudentModal = document.getElementById('assignStudentModal');
                                        const searchUnassignedInput = document.getElementById('searchUnassignedStudents');
                                        const unassignedStudentsList = document.getElementById('unassignedStudentsList');
                                        const confirmAssignBtn = document.getElementById('confirmAssignStudents');
                                        let unassignedStudents = [];
                                        let selectedStudentsForAssign = new Set();

                                        if (assignStudentModal) {
                                            assignStudentModal.addEventListener('show.bs.modal', function () {
                                                console.log('=== Assign Student Modal opening ===');
                                                console.log('selectedClassroomId:', selectedClassroomId);
                                                if (selectedClassroomId) {
                                                    const classroom = getClassroomById(selectedClassroomId);
                                                    console.log('Found classroom:', classroom);
                                                    document.getElementById('assignToClassName').textContent = classroom ? classroom.classCode : '';
                                                    loadUnassignedStudents();
                                                } else {
                                                    console.log('No classroom selected');
                                                }
                                            });

                                            assignStudentModal.addEventListener('hidden.bs.modal', function () {
                                                selectedStudentsForAssign.clear();
                                                updateSelectedStudentsDisplay();
                                                searchUnassignedInput.value = '';
                                            });
                                        }

                                        function loadUnassignedStudents() {
                                            console.log('=== loadUnassignedStudents called ===');
                                            const loadingDiv = document.getElementById('unassignedStudentsLoading');
                                            loadingDiv.style.display = 'block';
                                            unassignedStudentsList.innerHTML = '';

                                            console.log('Making fetch request to /admin/students/unassigned');
                                            fetch('/admin/students/unassigned')
                                                .then(response => {
                                                    console.log('Response status:', response.status);
                                                    console.log('Response ok:', response.ok);
                                                    return response.json();
                                                })
                                                .then(data => {
                                                    console.log('Received data:', data);
                                                    unassignedStudents = data;
                                                    displayUnassignedStudents(unassignedStudents);
                                                })
                                                .catch(error => {
                                                    console.error('Error loading unassigned students:', error);
                                                    // Fallback to mock data if API fails
                                                    console.log('Using mock data as fallback');
                                                    const mockData = [
                                                        {
                                                            id: 101,
                                                            username: "SV001",
                                                            fname: "Nguyễn Văn",
                                                            lname: "A",
                                                            majorName: "Công nghệ thông tin"
                                                        },
                                                        {
                                                            id: 102,
                                                            username: "SV002",
                                                            fname: "Trần Thị",
                                                            lname: "B",
                                                            majorName: "Kỹ thuật phần mềm"
                                                        },
                                                        {
                                                            id: 103,
                                                            username: "SV003",
                                                            fname: "Lê Văn",
                                                            lname: "C",
                                                            majorName: "An toàn thông tin"
                                                        }
                                                    ];
                                                    unassignedStudents = mockData;
                                                    displayUnassignedStudents(unassignedStudents);
                                                })
                                                .finally(() => {
                                                    loadingDiv.style.display = 'none';
                                                });
                                        }

                                        function displayUnassignedStudents(students) {
                                            if (students.length === 0) {
                                                unassignedStudentsList.innerHTML = '<div class="alert alert-info"><i class="bi bi-info-circle me-2"></i>Không có sinh viên nào chưa được phân lớp</div>';
                                                return;
                                            }

                                            const html = students.map(student => `
                                                <div class="card mb-2">
                                                    <div class="card-body py-2">
                                                        <div class="form-check">
                                                            <input class="form-check-input student-checkbox" type="checkbox" 
                                                                   id="student-\${student.id}" 
                                                                   value="\${student.id}"
                                                                   data-student-id="\${student.id}">
                                                            <label class="form-check-label w-100" for="student-\${student.id}">
                                                                <div class="d-flex justify-content-between align-items-center">
                                                                    <div>
                                                                        <strong>\${student.username}</strong> - \${student.lname} \${student.fname}
                                                                        <br><small class="text-muted">\${student.majorName ? student.majorName : 'Chưa có ngành'}</small>
                                                                    </div>
                                                                </div>
                                                            </label>
                                                        </div>
                                                    </div>
                                                </div>
                                            `).join('');
                                            unassignedStudentsList.innerHTML = html;

                                            // Add event listeners to checkboxes
                                            document.querySelectorAll('.student-checkbox').forEach(checkbox => {
                                                checkbox.addEventListener('change', function () {
                                                    const studentId = parseInt(this.getAttribute('data-student-id'));
                                                    const isSelected = this.checked;
                                                    toggleStudentSelection(studentId, isSelected);
                                                });
                                            });
                                        }

                                        function toggleStudentSelection(studentId, isSelected) {
                                            if (isSelected) {
                                                selectedStudentsForAssign.add(studentId);
                                            } else {
                                                selectedStudentsForAssign.delete(studentId);
                                            }
                                            updateSelectedStudentsDisplay();
                                        }

                                        function updateSelectedStudentsDisplay() {
                                            const count = selectedStudentsForAssign.size;
                                            const countSpan = document.getElementById('selectedStudentsCount');
                                            const selectedSection = document.getElementById('selectedStudentsSection');
                                            const selectedList = document.getElementById('selectedStudentsList');

                                            countSpan.textContent = count;
                                            confirmAssignBtn.disabled = count === 0;

                                            if (count > 0) {
                                                selectedSection.style.display = 'block';
                                                const selectedStudentsList = Array.from(selectedStudentsForAssign).map(id => {
                                                    const student = unassignedStudents.find(s => s.id == id);
                                                    return student ? `<span class="badge bg-primary me-1">\${student.username} - \${student.lname} \${student.fname}</span>` : '';
                                                }).join('');
                                                selectedList.innerHTML = selectedStudentsList;
                                            } else {
                                                selectedSection.style.display = 'none';
                                            }
                                        }

                                        // Search functionality for unassigned students
                                        if (searchUnassignedInput) {
                                            searchUnassignedInput.addEventListener('input', function () {
                                                const searchTerm = this.value.toLowerCase();
                                                const filteredStudents = unassignedStudents.filter(student =>
                                                    student.username.toLowerCase().includes(searchTerm) ||
                                                    student.fname.toLowerCase().includes(searchTerm) ||
                                                    student.lname.toLowerCase().includes(searchTerm)
                                                );
                                                displayUnassignedStudents(filteredStudents);
                                            });
                                        }

                                        // Confirm assign students
                                        if (confirmAssignBtn) {
                                            confirmAssignBtn.addEventListener('click', function () {
                                                if (selectedStudentsForAssign.size === 0 || !selectedClassroomId) return;

                                                const button = this;
                                                const originalText = button.innerHTML;
                                                button.innerHTML = '<i class="bi bi-hourglass-split me-1"></i>Đang gán...';
                                                button.disabled = true;

                                                const formData = new FormData();
                                                formData.append('classroomId', selectedClassroomId);
                                                selectedStudentsForAssign.forEach(studentId => {
                                                    formData.append('studentIds', studentId);
                                                });

                                                // Add CSRF token
                                                const csrfToken = document.querySelector('meta[name="_csrf"]')?.getAttribute('content');
                                                const csrfHeader = document.querySelector('meta[name="_csrf_header"]')?.getAttribute('content');
                                                if (csrfToken && csrfHeader) {
                                                    formData.append(csrfHeader.substring(csrfHeader.lastIndexOf('-') + 1), csrfToken);
                                                }

                                                fetch('/admin/students/assign-to-class', {
                                                    method: 'POST',
                                                    body: formData
                                                })
                                                    .then(response => response.json())
                                                    .then(data => {
                                                        if (data.success) {
                                                            // Close modal
                                                            const modal = bootstrap.Modal.getInstance(assignStudentModal);
                                                            modal.hide();

                                                            // Refresh page to show updated data
                                                            window.location.reload();
                                                        } else {
                                                            alert('Lỗi: ' + (data.message || 'Không thể gán sinh viên vào lớp'));
                                                        }
                                                    })
                                                    .catch(error => {
                                                        console.error('Error assigning students:', error);
                                                        alert('Có lỗi xảy ra khi gán sinh viên vào lớp');
                                                    })
                                                    .finally(() => {
                                                        button.innerHTML = originalText;
                                                        button.disabled = false;
                                                    });
                                            });
                                        }
                                    });

                                    // Student Password reset functionality
                                    let studentPasswordResetRequested = false;
                                    let currentStudentId = null;
                                    let currentStudentUsername = null;
                                    let currentStudentName = null;

                                    // Clean up any stuck backdrop on page load for student
                                    document.addEventListener('DOMContentLoaded', function () {
                                        setTimeout(() => {
                                            const backdrops = document.querySelectorAll('.modal-backdrop');
                                            backdrops.forEach(backdrop => backdrop.remove());
                                            document.body.classList.remove('modal-open');
                                            document.body.style.overflow = '';
                                            document.body.style.paddingRight = '';
                                        }, 100);
                                    });

                                    // Emergency backdrop cleanup on Escape key for student
                                    document.addEventListener('keydown', function (e) {
                                        if (e.key === 'Escape') {
                                            setTimeout(() => {
                                                const backdrops = document.querySelectorAll('.modal-backdrop');
                                                backdrops.forEach(backdrop => backdrop.remove());
                                                document.body.classList.remove('modal-open');
                                                document.body.style.overflow = '';
                                                document.body.style.paddingRight = '';
                                            }, 500);
                                        }
                                    });

                                    // Handle reset student password button click
                                    document.getElementById('resetStudentPasswordBtn').addEventListener('click', function () {
                                        studentPasswordResetRequested = true;

                                        // Get current student info from edit form
                                        currentStudentId = document.getElementById('editStudentId').value;
                                        currentStudentUsername = document.getElementById('editUsername').value;
                                        currentStudentName = document.getElementById('editFullName').value;

                                        // Update button state to show password will be reset
                                        document.getElementById('resetStudentPasswordBtn').innerHTML = '<i class="bi bi-check me-2"></i>Sẽ đặt lại mật khẩu';
                                        document.getElementById('resetStudentPasswordBtn').classList.remove('btn-danger');
                                        document.getElementById('resetStudentPasswordBtn').classList.add('btn-success');
                                        document.getElementById('resetStudentPasswordBtn').disabled = true;
                                    });

                                    // Handle edit student form submission
                                    document.querySelector('#editStudentModal form').addEventListener('submit', function (e) {
                                        if (studentPasswordResetRequested) {
                                            e.preventDefault();

                                            // Set values for password reset modal
                                            document.getElementById('resetStudentId').value = currentStudentId;

                                            // Hide edit modal and show password reset modal
                                            const editModal = bootstrap.Modal.getInstance(document.getElementById('editStudentModal'));
                                            editModal.hide();

                                            const resetModal = new bootstrap.Modal(document.getElementById('passwordResetStudentModal'));
                                            resetModal.show();
                                        }
                                    });

                                    // Handle student password reset form submission
                                    document.getElementById('passwordResetStudentForm').addEventListener('submit', function (e) {
                                        e.preventDefault();

                                        const adminPassword = document.getElementById('adminPasswordStudent').value;
                                        const studentId = document.getElementById('resetStudentId').value;

                                        if (!adminPassword.trim()) {
                                            alert('Vui lòng nhập mật khẩu admin');
                                            return;
                                        }

                                        // Submit password reset request
                                        const formData = new FormData();
                                        formData.append('adminPassword', adminPassword);
                                        formData.append('studentId', studentId);

                                        const csrfToken = document.querySelector('input[name="${_csrf.parameterName}"]');
                                        if (csrfToken) {
                                            formData.append(csrfToken.name, csrfToken.value);
                                        }

                                        fetch('${pageContext.request.contextPath}/admin/students/reset-password', {
                                            method: 'POST',
                                            body: formData
                                        })
                                            .then(response => response.json())
                                            .then(data => {
                                                const resetModal = bootstrap.Modal.getInstance(document.getElementById('passwordResetStudentModal'));
                                                resetModal.hide();

                                                // Force remove any remaining backdrop
                                                setTimeout(() => {
                                                    const backdrops = document.querySelectorAll('.modal-backdrop');
                                                    backdrops.forEach(backdrop => backdrop.remove());
                                                    document.body.classList.remove('modal-open');
                                                    document.body.style.overflow = '';
                                                    document.body.style.paddingRight = '';
                                                }, 300);

                                                if (data.success) {
                                                    // Add resetPassword parameter to the form before submitting
                                                    const editForm = document.querySelector('#editStudentModal form');
                                                    const hiddenInput = document.createElement('input');
                                                    hiddenInput.type = 'hidden';
                                                    hiddenInput.name = 'resetPassword';
                                                    hiddenInput.value = 'true';
                                                    editForm.appendChild(hiddenInput);

                                                    // Submit the edit form after successful password reset
                                                    editForm.submit();
                                                } else {
                                                    alert(data.message || 'Mật khẩu admin không đúng');

                                                    // Reset password reset state
                                                    studentPasswordResetRequested = false;
                                                    const resetBtn = document.getElementById('resetStudentPasswordBtn');
                                                    resetBtn.innerHTML = '<i class="bi bi-key me-2"></i>Đặt lại mật khẩu';
                                                    resetBtn.classList.remove('btn-success');
                                                    resetBtn.classList.add('btn-danger');
                                                    resetBtn.disabled = false;

                                                    // Show edit modal again
                                                    const editModal = new bootstrap.Modal(document.getElementById('editStudentModal'));
                                                    editModal.show();
                                                }
                                            })
                                            .catch(error => {
                                                console.error('Error:', error);
                                                alert('Có lỗi xảy ra khi đặt lại mật khẩu');

                                                // Force remove any remaining backdrop
                                                setTimeout(() => {
                                                    const backdrops = document.querySelectorAll('.modal-backdrop');
                                                    backdrops.forEach(backdrop => backdrop.remove());
                                                    document.body.classList.remove('modal-open');
                                                    document.body.style.overflow = '';
                                                    document.body.style.paddingRight = '';
                                                }, 300);
                                            });
                                    });

                                </script>

                                <!-- Custom Confirmation Modal -->
                                <div class="modal fade" id="confirmModal" tabindex="-1"
                                    aria-labelledby="confirmModalLabel" aria-hidden="true">
                                    <div class="modal-dialog modal-dialog-centered">
                                        <div class="modal-content">
                                            <div class="modal-header border-0 pb-1">
                                                <h5 class="modal-title" id="confirmModalTitle">Xác nhận</h5>
                                                <button type="button" class="btn-close" data-bs-dismiss="modal"
                                                    aria-label="Close"></button>
                                            </div>
                                            <div class="modal-body py-3">
                                                <div class="d-flex align-items-start">
                                                    <div class="me-3">
                                                        <i
                                                            class="bi bi-exclamation-triangle-fill text-warning fs-2"></i>
                                                    </div>
                                                    <div>
                                                        <p class="mb-2 fw-semibold" id="confirmModalMessage">Bạn có chắc
                                                            chắn muốn thực hiện hành động này?</p>
                                                        <p class="mb-0 text-muted small" id="confirmModalNote"></p>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="modal-footer border-0 pt-1">
                                                <button type="button" class="btn btn-secondary"
                                                    data-bs-dismiss="modal">Hủy</button>
                                                <button type="button" class="btn btn-danger" id="confirmModalOkBtn">Xác
                                                    nhận</button>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Custom Warning Modal -->
                                <div class="modal fade" id="warningModal" tabindex="-1"
                                    aria-labelledby="warningModalLabel" aria-hidden="true">
                                    <div class="modal-dialog modal-dialog-centered">
                                        <div class="modal-content">
                                            <div class="modal-header border-0 pb-1">
                                                <h5 class="modal-title" id="warningModalTitle">Cảnh báo</h5>
                                                <button type="button" class="btn-close" data-bs-dismiss="modal"
                                                    aria-label="Close"></button>
                                            </div>
                                            <div class="modal-body py-3">
                                                <div class="d-flex align-items-start">
                                                    <div class="me-3">
                                                        <i class="bi bi-exclamation-circle-fill text-danger fs-2"></i>
                                                    </div>
                                                    <div>
                                                        <p class="mb-2 fw-semibold" id="warningModalMessage">Thông báo
                                                        </p>
                                                        <p class="mb-0 text-muted small" id="warningModalNote"></p>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="modal-footer border-0 pt-1">
                                                <button type="button" class="btn btn-primary" data-bs-dismiss="modal">Đã
                                                    hiểu</button>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Assign Student to Class Modal -->
                                <div class="modal fade" id="assignStudentModal" tabindex="-1"
                                    aria-labelledby="assignStudentModalLabel" aria-hidden="true">
                                    <div class="modal-dialog modal-lg">
                                        <div class="modal-content">
                                            <div class="modal-header">
                                                <h5 class="modal-title" id="assignStudentModalLabel">
                                                    <i class="bi bi-person-check me-2"></i>Gán sinh viên vào lớp
                                                    <span id="assignToClassName" class="text-primary"></span>
                                                </h5>
                                                <button type="button" class="btn-close"
                                                    data-bs-dismiss="modal"></button>
                                            </div>
                                            <div class="modal-body">
                                                <!-- Search unassigned students -->
                                                <div class="mb-3">
                                                    <div class="input-group">
                                                        <span class="input-group-text">
                                                            <i class="bi bi-search"></i>
                                                        </span>
                                                        <input type="text" class="form-control"
                                                            id="searchUnassignedStudents"
                                                            placeholder="Tìm kiếm sinh viên chưa phân lớp...">
                                                    </div>
                                                </div>

                                                <!-- Loading indicator -->
                                                <div id="unassignedStudentsLoading" class="text-center py-3"
                                                    style="display: none;">
                                                    <div class="spinner-border spinner-border-sm" role="status">
                                                        <span class="visually-hidden">Đang tải...</span>
                                                    </div>
                                                    <span class="ms-2">Đang tải danh sách sinh viên...</span>
                                                </div>

                                                <!-- Unassigned students list -->
                                                <div id="unassignedStudentsList">
                                                    <div class="alert alert-info">
                                                        <i class="bi bi-info-circle me-2"></i>
                                                        Chọn lớp để xem danh sách sinh viên chưa phân lớp
                                                    </div>
                                                </div>

                                                <!-- Selected students -->
                                                <div id="selectedStudentsSection" style="display: none;">
                                                    <hr>
                                                    <h6 class="mb-2">
                                                        <i class="bi bi-check-square me-2"></i>Sinh viên đã chọn:
                                                        <span id="selectedStudentsCount"
                                                            class="badge bg-primary">0</span>
                                                    </h6>
                                                    <div id="selectedStudentsList" class="mb-3"></div>
                                                </div>
                                            </div>
                                            <div class="modal-footer">
                                                <button type="button" class="btn btn-secondary"
                                                    data-bs-dismiss="modal">Hủy</button>
                                                <button type="button" class="btn btn-primary" id="confirmAssignStudents"
                                                    disabled>
                                                    <i class="bi bi-check-lg me-1"></i>Gán sinh viên vào lớp
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                </body>

                </html>