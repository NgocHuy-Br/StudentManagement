<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Quản lý lớp sinh viên</title>
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

                        .classroom-item {
                            cursor: pointer;
                            transition: background-color 0.2s;
                        }

                        .classroom-item:hover {
                            background-color: #f8f9fa;
                        }

                        .classroom-item.selected {
                            background-color: #e3f2fd;
                            border-color: #2196f3;
                        }

                        /* Đảm bảo dropdown không bị che */
                        .table-responsive {
                            overflow: visible;
                        }

                        .dropdown-menu {
                            z-index: 1050;
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
                    </style>
                </head>

                <body>
                    <div class="container-fluid" style="padding: 0 clamp(12px, 4vw, 36px);">
                        <%@ include file="../common/header.jsp" %>

                            <c:set var="activeTab" value="classrooms" scope="request" />
                            <%@ include file="_nav.jsp" %>

                                <div class="mt-4">
                                    <!-- Main Content Area -->
                                    <div class="row">
                                        <div class="col-md-12">
                                            <!-- Main Content Area -->
                                            <div class="main-content">
                                                <div class="row">
                                                    <!-- Left Panel - Classroom Management -->
                                                    <div class="col-md-6">
                                                        <div class="card">
                                                            <div
                                                                class="card-header d-flex justify-content-between align-items-center">
                                                                <h5 class="mb-0"><i class="bi bi-list-ul me-2"></i>Danh
                                                                    sách lớp
                                                                    học
                                                                </h5>
                                                                <button type="button" class="btn btn-primary btn-sm"
                                                                    data-bs-toggle="modal"
                                                                    data-bs-target="#addClassroomModal">
                                                                    <i class="bi bi-plus-circle me-1"></i>Thêm lớp
                                                                </button>
                                                            </div>
                                                            <div class="card-body left-panel">
                                                                <!-- Search Form -->
                                                                <form method="get"
                                                                    action="${pageContext.request.contextPath}/admin/classrooms"
                                                                    class="mb-3" id="searchForm">
                                                                    <div class="row g-2">
                                                                        <!-- Ô tìm kiếm và nút search -->
                                                                        <div class="col-md-8">
                                                                            <div class="input-group">
                                                                                <input type="text" class="form-control"
                                                                                    name="search"
                                                                                    placeholder="Tìm kiếm theo mã lớp, khóa học, tên giáo viên..."
                                                                                    value="${param.search}">
                                                                                <button
                                                                                    class="btn btn-outline-secondary"
                                                                                    type="submit">
                                                                                    <i class="bi bi-search"></i>
                                                                                </button>
                                                                            </div>
                                                                        </div>
                                                                        <!-- Dropdown lọc ngành -->
                                                                        <div class="col-md-4">
                                                                            <select name="majorId" class="form-select"
                                                                                id="majorSelect"
                                                                                onchange="autoSubmitSearch()">
                                                                                <option value="">Tất cả ngành</option>
                                                                                <c:forEach var="major"
                                                                                    items="${majors}">
                                                                                    <option value="${major.id}"
                                                                                        ${param.majorId==major.id
                                                                                        ? 'selected' : '' }>
                                                                                        ${major.majorName}</option>
                                                                                </c:forEach>
                                                                            </select>
                                                                        </div>
                                                                    </div>
                                                                </form>

                                                                <!-- Dropdown sắp xếp lớp học -->
                                                                <div class="row mb-3">
                                                                    <div class="col-md-6">
                                                                        <label class="form-label small">Sắp xếp danh
                                                                            sách
                                                                            lớp:</label>
                                                                        <select class="form-select form-select-sm"
                                                                            id="sortClassrooms"
                                                                            onchange="sortClassroomList()">
                                                                            <option value="classCode-asc"
                                                                                ${sort=='classCode' && dir=='asc' ||
                                                                                (empty sort && empty dir) ? 'selected'
                                                                                : '' }>Mã lớp (A-Z)</option>
                                                                            <option value="courseYear-asc"
                                                                                ${sort=='courseYear' && dir=='asc'
                                                                                ? 'selected' : '' }>Năm bắt đầu
                                                                                khóa
                                                                                (tăng dần)</option>
                                                                        </select>
                                                                    </div>
                                                                </div>

                                                                <!-- Classroom List -->
                                                                <div class="list-group">
                                                                    <c:forEach var="classroom" items="${classrooms}">
                                                                        <div class="list-group-item classroom-item ${selectedClassId == classroom.id ? 'selected' : ''}"
                                                                            data-classroom-id="${classroom.id}"
                                                                            onclick="selectClassroom('${classroom.id}')">
                                                                            <div
                                                                                class="d-flex justify-content-between align-items-start">
                                                                                <div class="flex-grow-1">
                                                                                    <!-- Dòng 1: Mã lớp và Ngành -->
                                                                                    <div
                                                                                        class="d-flex align-items-center mb-1">
                                                                                        <h6 class="mb-0 fw-bold me-5"
                                                                                            style="min-width: 120px;">
                                                                                            ${classroom.classCode}
                                                                                        </h6>
                                                                                        <small class="text-muted ms-3">
                                                                                            Ngành:
                                                                                            ${classroom.major.majorCode}
                                                                                            -
                                                                                            ${classroom.major.majorName}
                                                                                        </small>
                                                                                    </div>

                                                                                    <!-- Dòng 2: Khóa và Giáo viên chủ nhiệm -->
                                                                                    <div
                                                                                        class="d-flex align-items-center mb-1">
                                                                                        <small class="text-muted me-5"
                                                                                            style="min-width: 120px;">
                                                                                            Khóa:
                                                                                            ${classroom.courseYear}
                                                                                        </small>
                                                                                        <small class="text-muted ms-3">
                                                                                            Giáo viên chủ nhiệm:
                                                                                            <c:choose>
                                                                                                <c:when
                                                                                                    test="${classroom.homeRoomTeacher != null}">
                                                                                                    <c:choose>
                                                                                                        <c:when
                                                                                                            test="${not empty classroom.homeRoomTeacher.teacherCode}">
                                                                                                            ${classroom.homeRoomTeacher.teacherCode}
                                                                                                        </c:when>
                                                                                                        <c:otherwise>
                                                                                                            ${classroom.homeRoomTeacher.user.username}
                                                                                                        </c:otherwise>
                                                                                                    </c:choose>
                                                                                                    -
                                                                                                    <c:choose>
                                                                                                        <c:when
                                                                                                            test="${not empty classroom.homeRoomTeacher.user.fname and not empty classroom.homeRoomTeacher.user.lname}">
                                                                                                            ${classroom.homeRoomTeacher.user.lname}
                                                                                                            ${classroom.homeRoomTeacher.user.fname}
                                                                                                        </c:when>
                                                                                                        <c:otherwise>
                                                                                                            ${classroom.homeRoomTeacher.user.username}
                                                                                                        </c:otherwise>
                                                                                                    </c:choose>
                                                                                                </c:when>
                                                                                                <c:otherwise>
                                                                                                    <em>Chưa có</em>
                                                                                                </c:otherwise>
                                                                                            </c:choose>

                                                                                            <!-- Hiển thị giáo viên chủ nhiệm hiện tại -->
                                                                                        </small>
                                                                                    </div>

                                                                                    <!-- Dòng 3: Sĩ số -->
                                                                                    <div
                                                                                        class="d-flex align-items-center">
                                                                                        <small
                                                                                            class="text-primary fw-bold"
                                                                                            style="min-width: 120px;">
                                                                                            Sĩ số:
                                                                                            ${classroom.studentCount}
                                                                                        </small>
                                                                                    </div>
                                                                                </div>
                                                                                <!-- Direct Action Buttons -->
                                                                                <div class="d-flex gap-1"
                                                                                    onclick="event.stopPropagation();">
                                                                                    <button type="button"
                                                                                        class="btn btn-sm btn-outline-info"
                                                                                        onclick="event.preventDefault(); event.stopPropagation(); viewClassroomDetails('${classroom.id}');"
                                                                                        data-bs-toggle="tooltip"
                                                                                        data-bs-placement="top"
                                                                                        title="Xem chi tiết lớp và lịch sử chủ nhiệm">
                                                                                        <i class="bi bi-eye"></i>
                                                                                    </button>
                                                                                    <button type="button"
                                                                                        class="btn btn-sm btn-outline-primary"
                                                                                        data-classroom-id="${classroom.id}"
                                                                                        data-class-code="${classroom.classCode}"
                                                                                        data-course-year="${classroom.courseYear}"
                                                                                        data-major-id="${classroom.major.id}"
                                                                                        data-teacher-id="${empty classroom.homeRoomTeacher ? '' : classroom.homeRoomTeacher.id}"
                                                                                        onclick="event.preventDefault(); event.stopPropagation(); editClassroomWithData(this);"
                                                                                        data-bs-toggle="tooltip"
                                                                                        data-bs-placement="top"
                                                                                        title="Chỉnh sửa thông tin lớp">
                                                                                        <i
                                                                                            class="bi bi-pencil-square"></i>
                                                                                    </button>
                                                                                    <button type="button"
                                                                                        class="btn btn-sm btn-outline-danger"
                                                                                        onclick="event.preventDefault(); event.stopPropagation(); deleteClassroom('${classroom.id}', '${classroom.classCode}');"
                                                                                        data-bs-toggle="tooltip"
                                                                                        data-bs-placement="top"
                                                                                        title="Xóa lớp">
                                                                                        <i class="bi bi-trash"></i>
                                                                                    </button>
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                    </c:forEach>
                                                                </div>

                                                                <c:if test="${empty classrooms}">
                                                                    <div class="text-center text-muted py-4">
                                                                        <i class="bi bi-inbox display-4"></i>
                                                                        <p class="mt-2">Không có lớp học nào</p>
                                                                    </div>
                                                                </c:if>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <!-- Right Panel - Student Management -->
                                                    <div class="col-md-6">
                                                        <div class="card">
                                                            <div
                                                                class="card-header d-flex justify-content-between align-items-center">
                                                                <h5 class="mb-0"><i class="bi bi-people-fill me-2"></i>
                                                                    <span id="selectedClassName">
                                                                        <c:choose>
                                                                            <c:when test="${selectedClass != null}">
                                                                                Sinh viên lớp ${selectedClass.classCode}
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                Chọn lớp để xem danh sách sinh viên
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </span>
                                                                </h5>
                                                                <c:if test="${selectedClass != null}">
                                                                    <div class="btn-group">
                                                                        <button type="button"
                                                                            class="btn btn-success btn-sm"
                                                                            data-bs-toggle="modal"
                                                                            data-bs-target="#addStudentModal">
                                                                            <i class="bi bi-person-plus me-1"></i>Thêm
                                                                            SV có sẵn
                                                                        </button>
                                                                        <button type="button"
                                                                            class="btn btn-primary btn-sm"
                                                                            data-bs-toggle="modal"
                                                                            data-bs-target="#createStudentModal">
                                                                            <i class="bi bi-plus-circle me-1"></i>Tạo SV
                                                                            mới
                                                                        </button>
                                                                    </div>
                                                                </c:if>
                                                            </div>
                                                            <div class="card-body right-panel">
                                                                <c:choose>
                                                                    <c:when test="${selectedClass == null}">
                                                                        <div class="text-center text-muted py-5">
                                                                            <i
                                                                                class="bi bi-arrow-left-circle display-4"></i>
                                                                            <p class="mt-3">Vui lòng chọn một lớp từ
                                                                                danh sách
                                                                                bên
                                                                                trái
                                                                            </p>
                                                                        </div>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <!-- Student List -->
                                                                        <c:if test="${not empty classStudents}">
                                                                            <div class="table-responsive">
                                                                                <table class="table table-hover">
                                                                                    <thead class="table-light">
                                                                                        <tr>
                                                                                            <th width="60px">TT</th>
                                                                                            <th>
                                                                                                <a href="?search=${param.search}&majorId=${param.majorId}&selectedClassId=${selectedClass.id}&studentSort=username-${studentSort == 'username-asc' ? 'desc' : 'asc'}&page=${param.page}&size=${param.size}"
                                                                                                    class="sort-link">
                                                                                                    MSV
                                                                                                    <i
                                                                                                        class="bi bi-arrow-down-up sort-icon"></i>
                                                                                                </a>
                                                                                            </th>
                                                                                            <th>
                                                                                                <a href="?search=${param.search}&majorId=${param.majorId}&selectedClassId=${selectedClass.id}&studentSort=name-${studentSort == 'name-asc' ? 'desc' : 'asc'}&page=${param.page}&size=${param.size}"
                                                                                                    class="sort-link">
                                                                                                    Họ tên
                                                                                                    <i
                                                                                                        class="bi bi-arrow-down-up sort-icon"></i>
                                                                                                </a>
                                                                                            </th>
                                                                                            <th>
                                                                                                <a href="?search=${param.search}&majorId=${param.majorId}&selectedClassId=${selectedClass.id}&studentSort=email-${studentSort == 'email-asc' ? 'desc' : 'asc'}&page=${param.page}&size=${param.size}"
                                                                                                    class="sort-link">
                                                                                                    Email
                                                                                                    <i
                                                                                                        class="bi bi-arrow-down-up sort-icon"></i>
                                                                                                </a>
                                                                                            </th>
                                                                                            <th width="140px"
                                                                                                class="text-center">Thao
                                                                                                tác
                                                                                            </th>
                                                                                        </tr>
                                                                                    </thead>
                                                                                    <tbody>
                                                                                        <c:forEach var="student"
                                                                                            items="${classStudents}"
                                                                                            varStatus="status">
                                                                                            <tr>
                                                                                                <td><span
                                                                                                        class="badge bg-secondary">${status.index
                                                                                                        + 1}</span></td>
                                                                                                <td><strong>${student.user.username}</strong>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <c:choose>
                                                                                                        <c:when
                                                                                                            test="${not empty student.user.fname and not empty student.user.lname}">
                                                                                                            ${student.user.lname}
                                                                                                            ${student.user.fname}
                                                                                                        </c:when>
                                                                                                        <c:otherwise>
                                                                                                            ${student.user.username}
                                                                                                        </c:otherwise>
                                                                                                    </c:choose>
                                                                                                </td>
                                                                                                <td>${student.user.email}
                                                                                                </td>
                                                                                                <td>
                                                                                                    <!-- Direct Action Buttons -->
                                                                                                    <div
                                                                                                        class="d-flex gap-1 justify-content-center">
                                                                                                        <button
                                                                                                            type="button"
                                                                                                            class="btn btn-sm btn-outline-info view-student-detail"
                                                                                                            data-student-id="${student.id}"
                                                                                                            data-username="${fn:escapeXml(student.user.username)}"
                                                                                                            data-fullname="${fn:escapeXml(student.user.lname)} ${fn:escapeXml(student.user.fname)}"
                                                                                                            data-email="${fn:escapeXml(student.user.email)}"
                                                                                                            data-phone="${fn:escapeXml(student.user.phone)}"
                                                                                                            data-address="${fn:escapeXml(student.user.address)}"
                                                                                                            data-birthdate="${fn:escapeXml(student.user.birthDate)}"
                                                                                                            data-nationalid="${fn:escapeXml(student.user.nationalId)}"
                                                                                                            data-major="${fn:escapeXml(student.major.majorName)}"
                                                                                                            data-bs-toggle="tooltip"
                                                                                                            data-bs-placement="top"
                                                                                                            title="Xem chi tiết">
                                                                                                            <i
                                                                                                                class="bi bi-eye"></i>
                                                                                                        </button>
                                                                                                        <button
                                                                                                            type="button"
                                                                                                            class="btn btn-sm btn-outline-danger"
                                                                                                            onclick="removeStudentFromClass('${student.id}', '${student.user.username}', '${selectedClass.id}')"
                                                                                                            data-bs-toggle="tooltip"
                                                                                                            data-bs-placement="top"
                                                                                                            title="Xóa khỏi lớp">
                                                                                                            <i
                                                                                                                class="bi bi-person-dash"></i>
                                                                                                        </button>
                                                                                                    </div>
                                                                                                </td>
                                                                                            </tr>
                                                                                        </c:forEach>
                                                                                    </tbody>
                                                                                </table>
                                                                            </div>
                                                                        </c:if>

                                                                        <c:if test="${empty classStudents}">
                                                                            <div class="text-center text-muted py-4">
                                                                                <i class="bi bi-person-x display-4"></i>
                                                                                <p class="mt-2">Lớp này chưa có sinh
                                                                                    viên nào
                                                                                </p>
                                                                            </div>
                                                                        </c:if>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </div>
                                                        </div>
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
                                            <form method="post"
                                                action="${pageContext.request.contextPath}/admin/classrooms">
                                                <div class="modal-header">
                                                    <h5 class="modal-title">Thêm lớp học mới</h5>
                                                    <button type="button" class="btn-close"
                                                        data-bs-dismiss="modal"></button>
                                                </div>
                                                <div class="modal-body">
                                                    <div class="mb-3">
                                                        <label class="form-label">Mã lớp</label>
                                                        <input type="text" class="form-control" name="classCode"
                                                            required placeholder="VD: CNTT01K66">
                                                    </div>
                                                    <div class="mb-3">
                                                        <label class="form-label">Khóa học</label>
                                                        <input type="text" class="form-control" name="courseYear"
                                                            required pattern="[0-9]{4}-[0-9]{4}"
                                                            placeholder="VD: 2025-2029"
                                                            title="Định dạng: YYYY-YYYY (năm sau phải lớn hơn năm trước)"
                                                            id="addCourseYear">
                                                        <div class="invalid-feedback" id="addCourseYearError">
                                                            Vui lòng nhập đúng định dạng YYYY-YYYY và năm sau phải lớn
                                                            hơn năm
                                                            trước
                                                        </div>
                                                    </div>
                                                    <div class="mb-3">
                                                        <label class="form-label">Ngành</label>
                                                        <select class="form-select" name="majorId" required>
                                                            <option value="">Chọn ngành...</option>
                                                            <c:forEach var="major" items="${majors}">
                                                                <option value="${major.id}">${major.majorName}</option>
                                                            </c:forEach>
                                                        </select>
                                                    </div>
                                                    <div class="mb-3">
                                                        <label class="form-label">Giáo viên chủ nhiệm (tùy chọn)</label>
                                                        <select class="form-select" name="teacherId">
                                                            <option value="">Chọn giáo viên...</option>
                                                            <c:forEach var="teacher" items="${teachers}">
                                                                <option value="${teacher.id}">${teacher.user.fullName}
                                                                </option>
                                                            </c:forEach>
                                                        </select>
                                                    </div>
                                                </div>
                                                <div class="modal-footer">
                                                    <button type="button" class="btn btn-secondary"
                                                        data-bs-dismiss="modal">Hủy</button>
                                                    <button type="submit" class="btn btn-primary">Thêm lớp</button>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </div>

                                <!-- Add Existing Student Modal -->
                                <c:if test="${selectedClass != null}">
                                    <div class="modal fade" id="addStudentModal" tabindex="-1">
                                        <div class="modal-dialog">
                                            <div class="modal-content">
                                                <form method="post"
                                                    action="${pageContext.request.contextPath}/admin/classrooms/${selectedClass.id}/students/add">
                                                    <div class="modal-header">
                                                        <h5 class="modal-title">Thêm sinh viên vào lớp
                                                            ${selectedClass.classCode}
                                                        </h5>
                                                        <button type="button" class="btn-close"
                                                            data-bs-dismiss="modal"></button>
                                                    </div>
                                                    <div class="modal-body">
                                                        <div class="mb-3">
                                                            <label class="form-label">Chọn sinh viên</label>
                                                            <select class="form-select" name="studentId" required>
                                                                <option value="">Chọn sinh viên...</option>
                                                                <c:forEach var="student" items="${availableStudents}">
                                                                    <option value="${student.id}">
                                                                        ${student.user.username} -
                                                                        <c:choose>
                                                                            <c:when
                                                                                test="${not empty student.user.fname and not empty student.user.lname}">
                                                                                ${student.user.lname}
                                                                                ${student.user.fname}
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                ${student.user.username}
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </option>
                                                                </c:forEach>
                                                            </select>
                                                        </div>
                                                    </div>
                                                    <div class="modal-footer">
                                                        <button type="button" class="btn btn-secondary"
                                                            data-bs-dismiss="modal">Hủy</button>
                                                        <button type="submit" class="btn btn-success">Thêm vào
                                                            lớp</button>
                                                    </div>
                                                </form>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Create New Student Modal -->
                                    <div class="modal fade" id="createStudentModal" tabindex="-1">
                                        <div class="modal-dialog">
                                            <div class="modal-content">
                                                <form method="post"
                                                    action="${pageContext.request.contextPath}/admin/classrooms/${selectedClass.id}/students/create">
                                                    <div class="modal-header">
                                                        <h5 class="modal-title">Tạo sinh viên mới cho lớp
                                                            ${selectedClass.classCode}
                                                        </h5>
                                                        <button type="button" class="btn-close"
                                                            data-bs-dismiss="modal"></button>
                                                    </div>
                                                    <div class="modal-body">
                                                        <div class="row">
                                                            <div class="col-md-6">
                                                                <div class="mb-3">
                                                                    <label class="form-label">Mã sinh viên</label>
                                                                    <input type="text" class="form-control"
                                                                        name="username" required>
                                                                </div>
                                                            </div>
                                                            <div class="col-md-6">
                                                                <div class="mb-3">
                                                                    <label class="form-label">Họ và tên</label>
                                                                    <input type="text" class="form-control"
                                                                        name="fullName" required>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="row">
                                                            <div class="col-md-6">
                                                                <div class="mb-3">
                                                                    <label class="form-label">Email</label>
                                                                    <input type="email" class="form-control"
                                                                        name="email" required>
                                                                </div>
                                                            </div>
                                                            <div class="col-md-6">
                                                                <div class="mb-3">
                                                                    <label class="form-label">Số điện thoại</label>
                                                                    <input type="text" class="form-control"
                                                                        name="phoneNumber">
                                                                </div>
                                                            </div>
                                                            <div class="col-md-6">
                                                                <div class="mb-3">
                                                                    <label class="form-label">CCCD</label>
                                                                    <input type="text" class="form-control"
                                                                        name="nationalId" placeholder="12 chữ số"
                                                                        maxlength="12" pattern="[0-9]{12}">
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="row">
                                                            <div class="col-md-6">
                                                                <div class="mb-3">
                                                                    <label class="form-label">Ngày sinh</label>
                                                                    <input type="date" class="form-control"
                                                                        name="birthDate">
                                                                </div>
                                                            </div>
                                                            <div class="col-md-6">
                                                                <div class="mb-3">
                                                                    <label class="form-label">Địa chỉ</label>
                                                                    <input type="text" class="form-control"
                                                                        name="address">
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="modal-footer">
                                                        <button type="button" class="btn btn-secondary"
                                                            data-bs-dismiss="modal">Hủy</button>
                                                        <button type="submit" class="btn btn-primary">Tạo sinh
                                                            viên</button>
                                                    </div>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                </c:if>

                                <!-- Edit Classroom Modal -->
                                <div class="modal fade" id="editClassroomModal" tabindex="-1">
                                    <div class="modal-dialog">
                                        <div class="modal-content">
                                            <div class="modal-header">
                                                <h5 class="modal-title">Chỉnh sửa thông tin lớp học</h5>
                                                <button type="button" class="btn-close"
                                                    data-bs-dismiss="modal"></button>
                                            </div>
                                            <div class="modal-body">
                                                <form id="editClassroomForm"
                                                    action="${pageContext.request.contextPath}/admin/classrooms/update"
                                                    method="post">
                                                    <input type="hidden" id="editClassroomId" name="id">

                                                    <!-- Warning message for classes with students -->
                                                    <div id="editWarningMessage" class="alert alert-warning d-none">
                                                        <i class="fas fa-exclamation-triangle"></i>
                                                        Lớp học đã có sinh viên. Chỉ có thể thay đổi giáo viên chủ
                                                        nhiệm.
                                                    </div>

                                                    <div class="mb-3" id="editClassCodeGroup">
                                                        <label for="editClassCode" class="form-label">Mã lớp <span
                                                                class="text-danger">*</span></label>
                                                        <input type="text" class="form-control" id="editClassCode"
                                                            name="classCode" required>
                                                    </div>

                                                    <div class="mb-3" id="editCourseYearGroup">
                                                        <label for="editCourseYear" class="form-label">Khóa học <span
                                                                class="text-danger">*</span></label>
                                                        <input type="text" class="form-control" id="editCourseYear"
                                                            name="courseYear" pattern="[0-9]{4}-[0-9]{4}"
                                                            placeholder="VD: 2025-2029"
                                                            title="Định dạng: YYYY-YYYY (năm sau phải lớn hơn năm trước)"
                                                            required>
                                                        <div class="invalid-feedback" id="editCourseYearError">
                                                            Vui lòng nhập đúng định dạng YYYY-YYYY và năm sau phải lớn
                                                            hơn năm
                                                            trước
                                                        </div>
                                                    </div>

                                                    <div class="mb-3" id="editMajorGroup">
                                                        <label for="editMajorId" class="form-label">Ngành <span
                                                                class="text-danger">*</span></label>
                                                        <select class="form-select" id="editMajorId" name="majorId"
                                                            required>
                                                            <option value="">Chọn ngành...</option>
                                                            <c:forEach var="major" items="${majors}">
                                                                <option value="${major.id}">${major.majorCode} -
                                                                    ${major.majorName}
                                                                </option>
                                                            </c:forEach>
                                                        </select>
                                                    </div>

                                                    <div class="mb-3">
                                                        <label for="editTeacherId" class="form-label">Giáo viên chủ
                                                            nhiệm (tùy
                                                            chọn)</label>
                                                        <select class="form-select" id="editTeacherId" name="teacherId">
                                                            <option value="">Chọn giáo viên...</option>
                                                            <c:forEach var="teacher" items="${teachers}">
                                                                <option value="${teacher.id}">${teacher.user.username} -
                                                                    ${teacher.user.lname} ${teacher.user.fname}</option>
                                                            </c:forEach>
                                                        </select>
                                                    </div>

                                                    <div class="mb-3">
                                                        <label for="editTeacherChangeNotes" class="form-label">Ghi chú
                                                            thay đổi
                                                            chủ nhiệm (tùy chọn)</label>
                                                        <textarea class="form-control" id="editTeacherChangeNotes"
                                                            name="teacherChangeNotes" rows="3"
                                                            placeholder="Nhập lý do thay đổi giáo viên chủ nhiệm..."></textarea>
                                                        <small class="form-text text-muted">Ghi chú này sẽ được lưu vào
                                                            lịch sử
                                                            thay đổi chủ nhiệm</small>
                                                    </div>

                                                    <div class="modal-footer">
                                                        <button type="button" class="btn btn-secondary"
                                                            data-bs-dismiss="modal">Hủy</button>
                                                        <button type="submit" class="btn btn-primary">Cập nhật</button>
                                                    </div>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <script
                                    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
                                <script>
                                    function selectClassroom(classroomId) {
                                        const currentUrl = new URL(window.location.href);
                                        currentUrl.searchParams.set('selectedClassId', classroomId);
                                        window.location.href = currentUrl.toString();
                                    }

                                    function viewClassroomDetails(classroomId) {
                                        window.location.href = '${pageContext.request.contextPath}/admin/classrooms/' + classroomId + '/details';
                                    }

                                    function deleteClassroom(classroomId, classroomName) {
                                        console.log('deleteClassroom called with id:', classroomId, 'name:', classroomName);
                                        if (confirm('Bạn có chắc chắn muốn xóa lớp "' + classroomName + '"?\nLưu ý: Chỉ có thể xóa lớp không có sinh viên nào.')) {
                                            console.log('User confirmed deletion');
                                            console.log('Timestamp:', new Date().toISOString());

                                            // Using fetch instead of form submit for better debugging
                                            const formData = new FormData();
                                            formData.append('id', classroomId);

                                            console.log('About to send DELETE request...');
                                            fetch('${pageContext.request.contextPath}/admin/classrooms/delete', {
                                                method: 'POST',
                                                body: formData
                                            })
                                                .then(response => {
                                                    console.log('Response received:', response.status, response.statusText);
                                                    if (response.ok || response.redirected) {
                                                        console.log('Delete request successful, refreshing page...');
                                                        window.location.reload();
                                                    } else {
                                                        console.error('Delete request failed:', response.status);
                                                        alert('Lỗi khi xóa lớp học. Vui lòng thử lại.');
                                                    }
                                                })
                                                .catch(error => {
                                                    console.error('Network error:', error);
                                                    alert('Lỗi kết nối khi xóa lớp học.');
                                                });
                                        }
                                    }

                                    function editClassroomWithData(element) {
                                        const classroomId = element.getAttribute('data-classroom-id');
                                        const classCode = element.getAttribute('data-class-code');
                                        const courseYear = element.getAttribute('data-course-year');
                                        const majorId = element.getAttribute('data-major-id');
                                        const teacherId = element.getAttribute('data-teacher-id');

                                        editClassroom(classroomId, classCode, courseYear, majorId, teacherId);
                                    }

                                    function editClassroom(classroomId, currentClassCode, currentCourseYear, currentMajorId, currentTeacherId) {
                                        console.log('editClassroom called with:', {
                                            id: classroomId,
                                            classCode: currentClassCode,
                                            courseYear: currentCourseYear,
                                            majorId: currentMajorId,
                                            teacherId: currentTeacherId
                                        });

                                        // Check if modal element exists
                                        const modalElement = document.getElementById('editClassroomModal');
                                        if (!modalElement) {
                                            console.error('Modal element not found!');
                                            alert('Lỗi: Không tìm thấy modal chỉnh sửa');
                                            return;
                                        }

                                        console.log('Modal element found:', modalElement);

                                        // Find classroom data from the list-group-item using data attribute
                                        let classroomItem = document.querySelector(`div.list-group-item[data-classroom-id="${classroomId}"]`);
                                        if (!classroomItem) {
                                            console.error('Classroom item not found for id:', classroomId);
                                            // Try alternative method - find by class code in h6
                                            const alternativeItem = Array.from(document.querySelectorAll('div.list-group-item')).find(item => {
                                                const h6 = item.querySelector('h6');
                                                return h6 && h6.textContent.trim() === currentClassCode;
                                            });

                                            if (alternativeItem) {
                                                console.log('Found classroom by class code:', alternativeItem);
                                                classroomItem = alternativeItem;
                                            } else {
                                                alert('Không tìm thấy thông tin lớp học');
                                                return;
                                            }
                                        }

                                        console.log('Classroom item found:', classroomItem);

                                        // Extract student count for conditional logic
                                        const studentCountElement = classroomItem.querySelector('small');
                                        const studentCountText = studentCountElement ? studentCountElement.textContent : '0/50';
                                        const studentCount = parseInt(studentCountText.split('/')[0].replace('Sĩ số: ', '')) || 0;

                                        console.log('Student count:', studentCount);

                                        // Check if form elements exist
                                        const editClassroomId = document.getElementById('editClassroomId');
                                        const editClassCode = document.getElementById('editClassCode');
                                        const editCourseYear = document.getElementById('editCourseYear');
                                        const editMajorId = document.getElementById('editMajorId');
                                        const editTeacherId = document.getElementById('editTeacherId');

                                        if (!editClassroomId || !editClassCode || !editCourseYear || !editMajorId || !editTeacherId) {
                                            console.error('Form elements not found!');
                                            alert('Lỗi: Không tìm thấy form elements');
                                            return;
                                        }

                                        // Fill modal fields with current values
                                        editClassroomId.value = classroomId;
                                        editClassCode.value = currentClassCode || '';
                                        editCourseYear.value = currentCourseYear || '';

                                        // Select current major
                                        editMajorId.selectedIndex = 0; // Reset first
                                        if (currentMajorId && currentMajorId !== '') {
                                            for (let option of editMajorId.options) {
                                                if (option.value === currentMajorId.toString()) {
                                                    option.selected = true;
                                                    break;
                                                }
                                            }
                                        }

                                        // Select current teacher
                                        editTeacherId.selectedIndex = 0; // Reset first
                                        if (currentTeacherId && currentTeacherId !== '') {
                                            for (let option of editTeacherId.options) {
                                                if (option.value === currentTeacherId.toString()) {
                                                    option.selected = true;
                                                    break;
                                                }
                                            }
                                        }

                                        console.log('Form filled with values:', {
                                            classCode: editClassCode.value,
                                            courseYear: editCourseYear.value,
                                            majorId: editMajorId.value,
                                            teacherId: editTeacherId.value
                                        });

                                        // Show/hide fields based on student count
                                        const hasStudents = studentCount > 0;
                                        const warningMsg = document.getElementById('editWarningMessage');
                                        const classCodeGroup = document.getElementById('editClassCodeGroup');
                                        const courseYearGroup = document.getElementById('editCourseYearGroup');
                                        const majorGroup = document.getElementById('editMajorGroup');

                                        if (hasStudents) {
                                            if (warningMsg) warningMsg.classList.remove('d-none');
                                            if (classCodeGroup) classCodeGroup.style.display = 'none';
                                            if (courseYearGroup) courseYearGroup.style.display = 'none';
                                            if (majorGroup) majorGroup.style.display = 'none';

                                            // Remove required attributes
                                            if (editClassCode) editClassCode.removeAttribute('required');
                                            if (editCourseYear) editCourseYear.removeAttribute('required');
                                            if (editMajorId) editMajorId.removeAttribute('required');
                                        } else {
                                            if (warningMsg) warningMsg.classList.add('d-none');
                                            if (classCodeGroup) classCodeGroup.style.display = 'block';
                                            if (courseYearGroup) courseYearGroup.style.display = 'block';
                                            if (majorGroup) majorGroup.style.display = 'block';

                                            // Add required attributes back
                                            if (editClassCode) editClassCode.setAttribute('required', 'required');
                                            if (editCourseYear) editCourseYear.setAttribute('required', 'required');
                                            if (editMajorId) editMajorId.setAttribute('required', 'required');
                                        }

                                        console.log('About to show modal...');

                                        // Show modal using Bootstrap 5 method
                                        try {
                                            const modal = new bootstrap.Modal(modalElement);
                                            modal.show();
                                            console.log('Modal show() called successfully');
                                        } catch (error) {
                                            console.error('Error showing modal:', error);
                                            alert('Lỗi khi hiển thị modal: ' + error.message);
                                        }
                                    }

                                    function removeStudentFromClass(studentId, studentName, classroomId) {
                                        if (confirm('Bạn có chắc chắn muốn loại "' + studentName + '" khỏi lớp này?')) {
                                            const form = document.createElement('form');
                                            form.method = 'POST';
                                            form.action = '${pageContext.request.contextPath}/admin/classrooms/removeStudent';

                                            const studentIdInput = document.createElement('input');
                                            studentIdInput.type = 'hidden';
                                            studentIdInput.name = 'studentId';
                                            studentIdInput.value = studentId;

                                            const classroomIdInput = document.createElement('input');
                                            classroomIdInput.type = 'hidden';
                                            classroomIdInput.name = 'classroomId';
                                            classroomIdInput.value = classroomId;

                                            form.appendChild(studentIdInput);
                                            form.appendChild(classroomIdInput);
                                            document.body.appendChild(form);
                                            form.submit();
                                        }
                                    }

                                    // Auto-submit search form when major dropdown changes
                                    function autoSubmitSearch() {
                                        const form = document.getElementById('searchForm');
                                        if (form) {
                                            form.submit();
                                        }
                                    }

                                    // Sort classroom list
                                    function sortClassroomList() {
                                        const sortValue = document.getElementById('sortClassrooms').value;
                                        const currentUrl = new URL(window.location.href);

                                        // Parse sort value (format: field-direction)
                                        const [sortField, sortDir] = sortValue.split('-');

                                        // Set sort parameters
                                        currentUrl.searchParams.set('sort', sortField);
                                        currentUrl.searchParams.set('dir', sortDir);

                                        // Remove selectedClassId to avoid confusion
                                        currentUrl.searchParams.delete('selectedClassId');

                                        window.location.href = currentUrl.toString();
                                    }

                                    // Sort student list
                                    function sortStudentList() {
                                        const sortValue = document.getElementById('sortStudents').value;
                                        const selectedClassId = '${selectedClass != null ? selectedClass.id : ""}';

                                        if (selectedClassId) {
                                            const currentUrl = new URL(window.location.href);
                                            currentUrl.searchParams.set('selectedClassId', selectedClassId);
                                            currentUrl.searchParams.set('studentSort', sortValue);  // Sử dụng studentSort thay vì sort
                                            window.location.href = currentUrl.toString();
                                        }
                                    }

                                    // Course Year Validation Function
                                    function validateCourseYear(courseYear) {
                                        // Check format YYYY-YYYY
                                        const pattern = /^[0-9]{4}-[0-9]{4}$/;
                                        if (!pattern.test(courseYear)) {
                                            return { isValid: false, message: "Định dạng phải là YYYY-YYYY (ví dụ: 2025-2029)" };
                                        }

                                        // Extract years
                                        const years = courseYear.split('-');
                                        const startYear = parseInt(years[0]);
                                        const endYear = parseInt(years[1]);

                                        // Check if end year is greater than start year
                                        if (endYear <= startYear) {
                                            return { isValid: false, message: "Năm kết thúc phải lớn hơn năm bắt đầu" };
                                        }

                                        // Check reasonable year range (between 1900 and 2100)
                                        if (startYear < 1900 || startYear > 2100 || endYear < 1900 || endYear > 2100) {
                                            return { isValid: false, message: "Năm phải nằm trong khoảng từ 1900 đến 2100" };
                                        }

                                        return { isValid: true, message: "" };
                                    }

                                    // Add validation to Create Form
                                    document.addEventListener('DOMContentLoaded', function () {
                                        // Initialize tooltips
                                        var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
                                        var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
                                            return new bootstrap.Tooltip(tooltipTriggerEl);
                                        });

                                        const addCourseYearInput = document.getElementById('addCourseYear');
                                        const editCourseYearInput = document.getElementById('editCourseYear');

                                        // Validation for Add Form
                                        if (addCourseYearInput) {
                                            addCourseYearInput.addEventListener('blur', function () {
                                                const validation = validateCourseYear(this.value);
                                                const errorDiv = document.getElementById('addCourseYearError');

                                                if (!validation.isValid) {
                                                    this.classList.add('is-invalid');
                                                    errorDiv.textContent = validation.message;
                                                } else {
                                                    this.classList.remove('is-invalid');
                                                    this.classList.add('is-valid');
                                                }
                                            });
                                        }

                                        // Validation for Edit Form
                                        if (editCourseYearInput) {
                                            editCourseYearInput.addEventListener('blur', function () {
                                                const validation = validateCourseYear(this.value);
                                                const errorDiv = document.getElementById('editCourseYearError');

                                                if (!validation.isValid) {
                                                    this.classList.add('is-invalid');
                                                    errorDiv.textContent = validation.message;
                                                } else {
                                                    this.classList.remove('is-invalid');
                                                    this.classList.add('is-valid');
                                                }
                                            });
                                        }

                                        // Form submit validation for Add Form
                                        const addForm = document.querySelector('#addClassroomModal form');
                                        if (addForm) {
                                            addForm.addEventListener('submit', function (e) {
                                                const courseYear = addCourseYearInput.value;
                                                const validation = validateCourseYear(courseYear);

                                                if (!validation.isValid) {
                                                    e.preventDefault();
                                                    alert('Lỗi Khóa học: ' + validation.message);
                                                    addCourseYearInput.focus();
                                                    return false;
                                                }
                                            });
                                        }

                                        // Form submit validation for Edit Form
                                        const editForm = document.querySelector('#editClassroomModal form');
                                        if (editForm) {
                                            editForm.addEventListener('submit', function (e) {
                                                const courseYear = editCourseYearInput.value;
                                                const validation = validateCourseYear(courseYear);

                                                if (!validation.isValid) {
                                                    e.preventDefault();
                                                    alert('Lỗi Khóa học: ' + validation.message);
                                                    editCourseYearInput.focus();
                                                    return false;
                                                }
                                            });
                                        }
                                    });

                                    // Event listener for view student detail
                                    document.addEventListener('click', function (e) {
                                        if (e.target.closest('.view-student-detail')) {
                                            e.preventDefault();
                                            const link = e.target.closest('.view-student-detail');
                                            const studentId = link.getAttribute('data-student-id');
                                            const username = link.getAttribute('data-username');
                                            const fullName = link.getAttribute('data-fullname');
                                            const email = link.getAttribute('data-email');
                                            const phone = link.getAttribute('data-phone');
                                            const address = link.getAttribute('data-address');
                                            const birthDate = link.getAttribute('data-birthdate');
                                            const nationalId = link.getAttribute('data-nationalid');
                                            const major = link.getAttribute('data-major');

                                            viewStudentDetail(studentId, username, fullName, email, phone, address, birthDate, nationalId, major);
                                        }
                                    });

                                    // Function to view student detail
                                    function viewStudentDetail(id, username, fullName, email, phone, address, birthDate, nationalId, major) {
                                        document.getElementById('detailUsername').innerText = username || 'Chưa có thông tin';
                                        document.getElementById('detailFullName').innerText = fullName || 'Chưa có thông tin';
                                        document.getElementById('detailEmail').innerText = email || 'Chưa có thông tin';
                                        document.getElementById('detailPhone').innerText = phone || 'Chưa có thông tin';
                                        document.getElementById('detailAddress').innerText = address || 'Chưa có thông tin';
                                        document.getElementById('detailBirthDate').innerText = birthDate || 'Chưa có thông tin';
                                        document.getElementById('detailNationalId').innerText = nationalId || 'Chưa có thông tin';
                                        document.getElementById('detailMajor').innerText = major || 'Chưa có thông tin';

                                        // Show modal
                                        const modal = new bootstrap.Modal(document.getElementById('studentDetailModal'));
                                        modal.show();
                                    }
                                </script>

                                <!-- Student Detail Modal -->
                                <div class="modal fade" id="studentDetailModal" tabindex="-1"
                                    aria-labelledby="studentDetailModalLabel" aria-hidden="true">
                                    <div class="modal-dialog modal-lg">
                                        <div class="modal-content">
                                            <div class="modal-header bg-primary text-white">
                                                <h5 class="modal-title" id="studentDetailModalLabel">
                                                    <i class="bi bi-person-circle me-2"></i>Chi tiết sinh viên
                                                </h5>
                                                <button type="button" class="btn-close btn-close-white"
                                                    data-bs-dismiss="modal" aria-label="Close"></button>
                                            </div>
                                            <div class="modal-body">
                                                <div class="row g-4">
                                                    <div class="col-md-6">
                                                        <div class="card h-100 border-0 shadow-sm">
                                                            <div class="card-header bg-light">
                                                                <h6 class="mb-0"><i
                                                                        class="bi bi-person-badge me-2"></i>Thông
                                                                    tin cơ bản</h6>
                                                            </div>
                                                            <div class="card-body">
                                                                <div class="mb-3">
                                                                    <label class="form-label fw-bold text-muted">Mã sinh
                                                                        viên:</label>
                                                                    <div class="border-bottom pb-1 text-primary fw-semibold"
                                                                        id="detailUsername"></div>
                                                                </div>
                                                                <div class="mb-3">
                                                                    <label class="form-label fw-bold text-muted">Họ
                                                                        tên:</label>
                                                                    <div class="border-bottom pb-1 fs-5 fw-semibold"
                                                                        id="detailFullName"></div>
                                                                </div>
                                                                <div class="mb-3">
                                                                    <label class="form-label fw-bold text-muted">Ngày
                                                                        sinh:</label>
                                                                    <div class="border-bottom pb-1"
                                                                        id="detailBirthDate"></div>
                                                                </div>
                                                                <div class="mb-3">
                                                                    <label
                                                                        class="form-label fw-bold text-muted">CCCD:</label>
                                                                    <div class="border-bottom pb-1"
                                                                        id="detailNationalId"></div>
                                                                </div>
                                                                <div class="mb-0">
                                                                    <label class="form-label fw-bold text-muted">Ngành
                                                                        học:</label>
                                                                    <div class="border-bottom pb-1 text-success fw-semibold"
                                                                        id="detailMajor"></div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-6">
                                                        <div class="card h-100 border-0 shadow-sm">
                                                            <div class="card-header bg-light">
                                                                <h6 class="mb-0"><i class="bi bi-geo-alt me-2"></i>Thông
                                                                    tin
                                                                    liên hệ</h6>
                                                            </div>
                                                            <div class="card-body">
                                                                <div class="mb-3">
                                                                    <label
                                                                        class="form-label fw-bold text-muted">Email:</label>
                                                                    <div class="border-bottom pb-1" id="detailEmail">
                                                                    </div>
                                                                </div>
                                                                <div class="mb-3">
                                                                    <label class="form-label fw-bold text-muted">Số điện
                                                                        thoại:</label>
                                                                    <div class="border-bottom pb-1" id="detailPhone">
                                                                    </div>
                                                                </div>
                                                                <div class="mb-0">
                                                                    <label class="form-label fw-bold text-muted">Địa
                                                                        chỉ:</label>
                                                                    <div class="border-bottom pb-1" id="detailAddress"
                                                                        style="min-height: 40px;"></div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="modal-footer bg-light">
                                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                                                    <i class="bi bi-x-circle me-2"></i>Đóng
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Show success/error messages -->
                                <c:if test="${not empty success}">
                                    <script>alert('<c:out value="${success}" />');</script>
                                </c:if>

                                <c:if test="${not empty error}">
                                    <script>alert('Lỗi: <c:out value="${error}" />');</script>
                                </c:if>



                                <script>
                                    // Classroom Management Functions
                                </script>
                    </div>
                </body>

                </html>