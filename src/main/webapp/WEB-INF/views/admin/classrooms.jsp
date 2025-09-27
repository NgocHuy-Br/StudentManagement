<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Quản lý lớp sinh viên</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
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
                </style>
            </head>

            <body>
                <%@include file="../common/header.jsp" %>

                    <!-- Navigation Tab Bar - Full Width -->
                    <jsp:include page="_nav.jsp">
                        <jsp:param name="activeTab" value="classrooms" />
                    </jsp:include>

                    <div class="container-fluid mt-4">
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
                                                    <h5 class="mb-0"><i class="bi bi-list-ul me-2"></i>Danh sách lớp học
                                                    </h5>
                                                    <button type="button" class="btn btn-primary btn-sm"
                                                        data-bs-toggle="modal" data-bs-target="#addClassroomModal">
                                                        <i class="bi bi-plus-circle me-1"></i>Thêm lớp
                                                    </button>
                                                </div>
                                                <div class="card-body left-panel">
                                                    <!-- Search Form -->
                                                    <form method="get"
                                                        action="${pageContext.request.contextPath}/admin/classrooms"
                                                        class="mb-3">
                                                        <div class="input-group">
                                                            <input type="text" class="form-control" name="search"
                                                                placeholder="Tìm kiếm theo tên lớp..."
                                                                value="${param.search}">
                                                            <select name="majorId" class="form-select">
                                                                <option value="">Tất cả ngành</option>
                                                                <c:forEach var="major" items="${majors}">
                                                                    <option value="${major.id}"
                                                                        ${param.majorId==major.id ? 'selected' : '' }>
                                                                        ${major.majorName}</option>
                                                                </c:forEach>
                                                            </select>
                                                            <button class="btn btn-outline-secondary" type="submit">
                                                                <i class="bi bi-search"></i>
                                                            </button>
                                                        </div>
                                                    </form>

                                                    <!-- Classroom List -->
                                                    <div class="list-group">
                                                        <c:forEach var="classroom" items="${classrooms}">
                                                            <div class="list-group-item classroom-item ${selectedClassId == classroom.id ? 'selected' : ''}"
                                                                onclick="selectClassroom('${classroom.id}')">
                                                                <div
                                                                    class="d-flex justify-content-between align-items-start">
                                                                    <div class="flex-grow-1">
                                                                        <h6 class="mb-1">${classroom.classCode}</h6>
                                                                        <p class="mb-1 text-muted small">Ngành:
                                                                            ${classroom.major.majorName}</p>
                                                                        <p class="mb-1 text-muted small">Giáo viên chủ
                                                                            nhiệm:
                                                                            <c:choose>
                                                                                <c:when
                                                                                    test="${classroom.homeRoomTeacher != null}">
                                                                                    <c:choose>
                                                                                        <c:when
                                                                                            test="${not empty classroom.homeRoomTeacher.user.fname and not empty classroom.homeRoomTeacher.user.lname}">
                                                                                            ${classroom.homeRoomTeacher.user.fname}
                                                                                            ${classroom.homeRoomTeacher.user.lname}
                                                                                        </c:when>
                                                                                        <c:otherwise>
                                                                                            ${classroom.homeRoomTeacher.user.username}
                                                                                        </c:otherwise>
                                                                                    </c:choose>
                                                                                </c:when>
                                                                                <c:otherwise>
                                                                                    <em class="text-muted">Chưa có</em>
                                                                                </c:otherwise>
                                                                            </c:choose>
                                                                        </p>
                                                                        <small class="text-primary">Sĩ số:
                                                                            ${classroom.studentCount}/50</small>
                                                                    </div>
                                                                    <div class="dropdown">
                                                                        <button
                                                                            class="btn btn-sm btn-outline-secondary dropdown-toggle"
                                                                            type="button" data-bs-toggle="dropdown">
                                                                            <i class="bi bi-three-dots-vertical"></i>
                                                                        </button>
                                                                        <ul class="dropdown-menu">
                                                                            <li><a class="dropdown-item" href="#"
                                                                                    onclick="deleteClassroom('${classroom.id}', '${classroom.classCode}')">
                                                                                    <i class="bi bi-trash me-2"></i>Xóa
                                                                                    lớp
                                                                                </a></li>
                                                                        </ul>
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
                                                            <button type="button" class="btn btn-success btn-sm"
                                                                data-bs-toggle="modal"
                                                                data-bs-target="#addStudentModal">
                                                                <i class="bi bi-person-plus me-1"></i>Thêm SV có sẵn
                                                            </button>
                                                            <button type="button" class="btn btn-primary btn-sm"
                                                                data-bs-toggle="modal"
                                                                data-bs-target="#createStudentModal">
                                                                <i class="bi bi-plus-circle me-1"></i>Tạo SV mới
                                                            </button>
                                                        </div>
                                                    </c:if>
                                                </div>
                                                <div class="card-body right-panel">
                                                    <c:choose>
                                                        <c:when test="${selectedClass == null}">
                                                            <div class="text-center text-muted py-5">
                                                                <i class="bi bi-arrow-left-circle display-4"></i>
                                                                <p class="mt-3">Vui lòng chọn một lớp từ danh sách bên
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
                                                                                <th>MSV</th>
                                                                                <th>Họ tên</th>
                                                                                <th>Email</th>
                                                                                <th>Thao tác</th>
                                                                            </tr>
                                                                        </thead>
                                                                        <tbody>
                                                                            <c:forEach var="student"
                                                                                items="${classStudents}">
                                                                                <tr>
                                                                                    <td><strong>${student.user.username}</strong>
                                                                                    </td>
                                                                                    <td>
                                                                                        <c:choose>
                                                                                            <c:when
                                                                                                test="${not empty student.user.fname and not empty student.user.lname}">
                                                                                                ${student.user.fname}
                                                                                                ${student.user.lname}
                                                                                            </c:when>
                                                                                            <c:otherwise>
                                                                                                ${student.user.username}
                                                                                            </c:otherwise>
                                                                                        </c:choose>
                                                                                    </td>
                                                                                    <td>${student.user.email}</td>
                                                                                    <td>
                                                                                        <button
                                                                                            class="btn btn-sm btn-outline-danger"
                                                                                            onclick="removeStudentFromClass('${student.id}', '${student.user.username}', '${selectedClass.id}')">
                                                                                            <i
                                                                                                class="bi bi-person-dash"></i>
                                                                                        </button>
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
                                                                    <p class="mt-2">Lớp này chưa có sinh viên nào</p>
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
                                <form method="post" action="${pageContext.request.contextPath}/admin/classrooms">
                                    <div class="modal-header">
                                        <h5 class="modal-title">Thêm lớp học mới</h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                    </div>
                                    <div class="modal-body">
                                        <div class="mb-3">
                                            <label class="form-label">Mã lớp</label>
                                            <input type="text" class="form-control" name="classCode" required
                                                placeholder="VD: CNTT01K66">
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label">Khóa học</label>
                                            <input type="text" class="form-control" name="courseYear" required
                                                placeholder="VD: 2022-2026">
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
                                                    <option value="${teacher.id}">${teacher.user.fullName}</option>
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
                                            <h5 class="modal-title">Thêm sinh viên vào lớp ${selectedClass.classCode}
                                            </h5>
                                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                        </div>
                                        <div class="modal-body">
                                            <div class="mb-3">
                                                <label class="form-label">Chọn sinh viên</label>
                                                <select class="form-select" name="studentId" required>
                                                    <option value="">Chọn sinh viên...</option>
                                                    <c:forEach var="student" items="${availableStudents}">
                                                        <option value="${student.id}">${student.user.username} -
                                                            <c:choose>
                                                                <c:when
                                                                    test="${not empty student.user.fname and not empty student.user.lname}">
                                                                    ${student.user.fname} ${student.user.lname}
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
                                            <button type="submit" class="btn btn-success">Thêm vào lớp</button>
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
                                            <h5 class="modal-title">Tạo sinh viên mới cho lớp ${selectedClass.classCode}
                                            </h5>
                                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                        </div>
                                        <div class="modal-body">
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <div class="mb-3">
                                                        <label class="form-label">Mã sinh viên</label>
                                                        <input type="text" class="form-control" name="username"
                                                            required>
                                                    </div>
                                                </div>
                                                <div class="col-md-6">
                                                    <div class="mb-3">
                                                        <label class="form-label">Họ và tên</label>
                                                        <input type="text" class="form-control" name="fullName"
                                                            required>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <div class="mb-3">
                                                        <label class="form-label">Email</label>
                                                        <input type="email" class="form-control" name="email" required>
                                                    </div>
                                                </div>
                                                <div class="col-md-6">
                                                    <div class="mb-3">
                                                        <label class="form-label">Số điện thoại</label>
                                                        <input type="text" class="form-control" name="phoneNumber">
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <div class="mb-3">
                                                        <label class="form-label">Ngày sinh</label>
                                                        <input type="date" class="form-control" name="birthDate">
                                                    </div>
                                                </div>
                                                <div class="col-md-6">
                                                    <div class="mb-3">
                                                        <label class="form-label">Địa chỉ</label>
                                                        <input type="text" class="form-control" name="address">
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-secondary"
                                                data-bs-dismiss="modal">Hủy</button>
                                            <button type="submit" class="btn btn-primary">Tạo sinh viên</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </c:if>

                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
                    <script>
                        function selectClassroom(classroomId) {
                            const currentUrl = new URL(window.location.href);
                            currentUrl.searchParams.set('selectedClassId', classroomId);
                            window.location.href = currentUrl.toString();
                        }

                        function deleteClassroom(classroomId, classroomName) {
                            if (confirm('Bạn có chắc chắn muốn xóa lớp "' + classroomName + '"?\nTất cả sinh viên trong lớp sẽ được chuyển về trạng thái không có lớp.')) {
                                const form = document.createElement('form');
                                form.method = 'POST';
                                form.action = '${pageContext.request.contextPath}/admin/classrooms/delete';

                                const input = document.createElement('input');
                                input.type = 'hidden';
                                input.name = 'classroomId';
                                input.value = classroomId;

                                form.appendChild(input);
                                document.body.appendChild(form);
                                form.submit();
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

        // Show success/error messages
        <c:if test="${not empty successMessage}">
            alert('<c:out value="${successMessage}" />');
        </c:if>
        
        <c:if test="${not empty errorMessage}">
            alert('Lỗi: <c:out value="${errorMessage}" />');
        </c:if>
                    </script>
            </body>

            </html>