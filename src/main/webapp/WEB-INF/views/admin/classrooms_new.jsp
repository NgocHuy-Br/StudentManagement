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
                                                                            <span class="input-group-text">
                                                                                <i class="bi bi-search"></i>
                                                                            </span>
                                                                            <input type="text" name="q" value="${q}"
                                                                                class="form-control form-control-sm"
                                                                                placeholder="Tìm lớp...">
                                                                            <c:if test="${not empty q}">
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
                                                                        <span class="input-group-text">
                                                                            <i class="bi bi-search"></i>
                                                                        </span>
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
                                                            placeholder="Ví dụ: 2024" required>
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
                                                    id: <c:out value="${classroom.id}" />,
                                                classCode: '<c:out value="${classroom.classCode}" />',
                                                courseYear: '<c:out value="${classroom.courseYear}" />'
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
                                        // Implement edit classroom modal
                                        alert('Edit classroom: ' + id);
                                    }

                                    function deleteClassroom(id) {
                                        if (confirm('Bạn có chắc chắn muốn xóa lớp này?')) {
                                            window.location.href = '${pageContext.request.contextPath}/admin/classrooms/delete/' + id;
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
                                            }
                                        });

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
                                </script>
                </body>

                </html>