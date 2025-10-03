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
                        body {
                            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                        }

                        .major-row:hover {
                            background-color: #f8f9fa;
                        }

                        .major-row.table-primary {
                            background-color: #cce7ff !important;
                        }
                    </style>
                </head>

                <body>
                    <%@include file="../common/header.jsp" %>

                        <div class="container-fluid my-4">
                            <%@include file="_nav.jsp" %>

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

                                <div class="row g-4">
                                    <!-- Left Panel - Majors List -->
                                    <div class="col-lg-5">
                                        <div class="card shadow-sm h-100">
                                            <div class="card-header d-flex justify-content-between align-items-center">
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
                                                <!-- Search for Majors -->
                                                <div class="mb-3">
                                                    <form method="get" class="d-flex">
                                                        <div class="input-group input-group-sm">
                                                            <span class="input-group-text">
                                                                <i class="bi bi-search"></i>
                                                            </span>
                                                            <input type="text" name="q" value="${q}"
                                                                class="form-control form-control-sm"
                                                                placeholder="Tìm ngành...">
                                                            <button class="btn btn-outline-primary btn-sm"
                                                                type="submit">Tìm</button>
                                                            <c:if test="${not empty q}">
                                                                <a href="${pageContext.request.contextPath}/admin/majors"
                                                                    class="btn btn-outline-secondary btn-sm">
                                                                    <i class="bi bi-x-circle"></i>
                                                                </a>
                                                            </c:if>
                                                        </div>
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
                                                                <th>Mã ngành</th>
                                                                <th>Tên ngành</th>
                                                                <th>Khóa học</th>
                                                                <th>Môn học</th>
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
                                                                    <c:forEach items="${majors}" var="major">
                                                                        <tr class="major-row ${major.id == selectedMajorId ? 'table-primary' : ''}"
                                                                            style="cursor: pointer;"
                                                                            onclick="selectMajor(${major.id})">
                                                                            <td class="fw-semibold text-primary">
                                                                                ${major.majorCode}</td>
                                                                            <td class="fw-medium">${major.majorName}
                                                                            </td>
                                                                            <td class="text-center">
                                                                                <span
                                                                                    class="badge bg-warning text-dark">${major.courseYear}</span>
                                                                            </td>
                                                                            <td class="text-center">
                                                                                <span
                                                                                    class="badge bg-info">${fn:length(major.subjects)}</span>
                                                                            </td>
                                                                            <td class="text-center">
                                                                                <button
                                                                                    class="btn btn-sm btn-outline-warning me-1 edit-major-btn"
                                                                                    data-id="${major.id}"
                                                                                    data-code="${major.majorCode}"
                                                                                    data-name="${major.majorName}"
                                                                                    data-course-year="${major.courseYear}"
                                                                                    data-description="${major.description}"
                                                                                    type="button">
                                                                                    <i class="bi bi-pencil"></i>
                                                                                </button>
                                                                                <button
                                                                                    class="btn btn-sm btn-outline-danger delete-major-btn"
                                                                                    data-id="${major.id}"
                                                                                    data-code="${major.majorCode}"
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
                                    <div class="col-lg-7">
                                        <div class="card shadow-sm h-100">
                                            <c:choose>
                                                <c:when test="${not empty selectedMajor or param.viewAll eq 'true'}">
                                                    <div
                                                        class="card-header d-flex justify-content-between align-items-center">
                                                        <h6 class="mb-0">
                                                            <i class="bi bi-book me-2"></i>
                                                            <span id="subjectsTitle">Môn học</span>
                                                        </h6>
                                                        <button type="button" class="btn btn-primary btn-sm"
                                                            data-bs-toggle="modal" data-bs-target="#addSubjectModal">
                                                            <i class="bi bi-plus-lg me-1"></i>Thêm môn học
                                                        </button>
                                                    </div>
                                                    <div class="card-body">
                                                        <!-- Major Selection Dropdown -->
                                                        <div
                                                            class="mb-3 d-flex justify-content-between align-items-center">
                                                            <div class="d-flex align-items-center">
                                                                <label for="majorSelect"
                                                                    class="form-label me-2 mb-0 fw-medium">
                                                                    <i class="bi bi-filter me-1"></i>Xem môn học của:
                                                                </label>
                                                                <select class="form-select form-select-sm"
                                                                    id="majorSelect" style="min-width: 200px;">
                                                                    <option value="all" ${param.viewAll eq 'true' or
                                                                        empty selectedMajorId ? 'selected' : '' }>
                                                                        📚 Tất cả ngành
                                                                    </option>
                                                                    <c:forEach items="${majors}" var="major">
                                                                        <option value="${major.id}" ${selectedMajorId eq
                                                                            major.id and param.viewAll ne 'true'
                                                                            ? 'selected' : '' }>
                                                                            🎓 ${major.majorCode} - ${major.majorName}
                                                                        </option>
                                                                    </c:forEach>
                                                                </select>
                                                            </div>
                                                            <small class="text-muted" id="subjectCount">
                                                                <c:choose>
                                                                    <c:when
                                                                        test="${param.viewAll eq 'true' or empty selectedMajorId}">
                                                                        Tổng: ${fn:length(subjects)} môn học (tất cả
                                                                        ngành)
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        Tổng: ${fn:length(subjects)} môn học
                                                                        (${selectedMajor.majorName})
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </small>
                                                        </div>

                                                        <!-- Search for Subjects -->
                                                        <div class="mb-3">
                                                            <form method="get" class="d-flex">
                                                                <div class="input-group input-group-sm">
                                                                    <span class="input-group-text">
                                                                        <i class="bi bi-search"></i>
                                                                    </span>
                                                                    <input type="text" name="subjectSearch"
                                                                        value="${param.subjectSearch}"
                                                                        class="form-control form-control-sm"
                                                                        placeholder="Tìm môn học...">
                                                                    <button class="btn btn-outline-primary btn-sm"
                                                                        type="submit">Tìm</button>
                                                                </div>
                                                                <input type="hidden" name="selectedMajorId"
                                                                    id="selectedMajorIdInput"
                                                                    value="${selectedMajorId}">
                                                                <input type="hidden" name="viewAll" id="viewAllInput"
                                                                    value="${param.viewAll eq 'true' ? 'true' : 'false'}">
                                                                <c:if test="${not empty q}">
                                                                    <input type="hidden" name="q" value="${q}">
                                                                </c:if>
                                                            </form>
                                                        </div>

                                                        <!-- Subjects Table -->
                                                        <div class="table-responsive"
                                                            style="max-height: 450px; overflow-y: auto;">
                                                            <table class="table table-hover table-sm mb-0">
                                                                <thead class="table-light sticky-top">
                                                                    <tr>
                                                                        <th>Mã môn</th>
                                                                        <th>Tên môn học</th>
                                                                        <c:if test="${param.viewAll eq 'true'}">
                                                                            <th>Các ngành</th>
                                                                        </c:if>
                                                                        <th>Tín chỉ</th>
                                                                        <th>Thao tác</th>
                                                                    </tr>
                                                                </thead>
                                                                <tbody>
                                                                    <c:choose>
                                                                        <c:when test="${empty subjects}">
                                                                            <tr>
                                                                                <td colspan="${param.viewAll eq 'true' ? '5' : '4'}"
                                                                                    class="text-center py-4 text-muted">
                                                                                    <i
                                                                                        class="bi bi-journals display-6 d-block mb-2"></i>
                                                                                    Chưa có môn học nào
                                                                                </td>
                                                                            </tr>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <c:forEach items="${subjects}"
                                                                                var="subject">
                                                                                <tr>
                                                                                    <td
                                                                                        class="fw-semibold text-success">
                                                                                        ${subject.subjectCode}</td>
                                                                                    <td class="fw-medium">
                                                                                        ${subject.subjectName}</td>
                                                                                    <c:if
                                                                                        test="${param.viewAll eq 'true'}">
                                                                                        <td>
                                                                                            <c:forEach
                                                                                                items="${subject.majors}"
                                                                                                var="major"
                                                                                                varStatus="status">
                                                                                                <span
                                                                                                    class="badge bg-info me-1 mb-1">${major.majorCode}</span>
                                                                                            </c:forEach>
                                                                                            <c:if
                                                                                                test="${empty subject.majors}">
                                                                                                <small
                                                                                                    class="text-muted">Chưa
                                                                                                    gán ngành</small>
                                                                                            </c:if>
                                                                                        </td>
                                                                                    </c:if>
                                                                                    <td class="text-center">
                                                                                        <span
                                                                                            class="badge bg-secondary">${subject.credit}</span>
                                                                                    </td>
                                                                                    <td class="text-center">
                                                                                        <button
                                                                                            class="btn btn-sm btn-outline-warning me-1 edit-subject-btn"
                                                                                            data-id="${subject.id}"
                                                                                            data-code="${subject.subjectCode}"
                                                                                            data-name="${subject.subjectName}"
                                                                                            data-credit="${subject.credit}">
                                                                                            <i class="bi bi-pencil"></i>
                                                                                        </button>
                                                                                        <button
                                                                                            class="btn btn-sm btn-outline-danger delete-subject-btn"
                                                                                            data-id="${subject.id}"
                                                                                            data-code="${subject.subjectCode}">
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
                                                            <small class="text-muted">Tổng: ${fn:length(subjects)} môn
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
                                                            <p>Chọn ngành từ danh sách bên trái hoặc dropdown phía trên
                                                                để xem các môn học</p>
                                                        </div>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
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
                                                        <label class="form-label">Khóa học</label>
                                                        <input type="text" class="form-control" name="courseYear"
                                                            required pattern="\d{4}-\d{4}"
                                                            placeholder="VD: 2023-2027, 2024-2028"
                                                            title="Nhập theo định dạng YYYY-YYYY (ví dụ: 2023-2027)">
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
                                                        <label class="form-label">Khóa học</label>
                                                        <input type="text" class="form-control" id="editMajorCourseYear"
                                                            name="courseYear" required pattern="\d{4}-\d{4}"
                                                            title="Nhập theo định dạng YYYY-YYYY (ví dụ: 2023-2027)">
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
                                    <div class="modal-dialog">
                                        <div class="modal-content">
                                            <div class="modal-header bg-danger text-white">
                                                <h5 class="modal-title">Xác nhận xóa</h5>
                                                <button type="button" class="btn-close btn-close-white"
                                                    data-bs-dismiss="modal"></button>
                                            </div>
                                            <div class="modal-body">
                                                <p>Bạn có chắc chắn muốn xóa ngành học <strong
                                                        id="deleteMajorName"></strong>?</p>
                                            </div>
                                            <div class="modal-footer">
                                                <button type="button" class="btn btn-secondary"
                                                    data-bs-dismiss="modal">Hủy</button>
                                                <form method="post"
                                                    action="${pageContext.request.contextPath}/admin/majors/delete"
                                                    style="display: inline;">
                                                    <input type="hidden" id="deleteMajorId" name="id">
                                                    <button type="submit" class="btn btn-danger">Xóa</button>
                                                </form>
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
                                                    <button type="submit" class="btn btn-primary">Thêm môn học</button>
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
                                                action="${pageContext.request.contextPath}/admin/subjects/edit">
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

                                <!-- Delete Subject Modal -->
                                <div class="modal fade" id="deleteSubjectModal" tabindex="-1">
                                    <div class="modal-dialog">
                                        <div class="modal-content">
                                            <div class="modal-header bg-danger text-white">
                                                <h5 class="modal-title">Xác nhận xóa</h5>
                                                <button type="button" class="btn-close btn-close-white"
                                                    data-bs-dismiss="modal"></button>
                                            </div>
                                            <div class="modal-body">
                                                <p>Bạn có chắc chắn muốn xóa môn học <strong
                                                        id="deleteSubjectName"></strong>?</p>
                                            </div>
                                            <div class="modal-footer">
                                                <button type="button" class="btn btn-secondary"
                                                    data-bs-dismiss="modal">Hủy</button>
                                                <form method="post"
                                                    action="${pageContext.request.contextPath}/admin/subjects/delete"
                                                    style="display: inline;">
                                                    <input type="hidden" id="deleteSubjectId" name="id">
                                                    <input type="hidden" name="majorId" value="${selectedMajorId}">
                                                    <button type="submit" class="btn btn-danger">Xóa</button>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <script
                                    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
                                <script>
                                    document.addEventListener('DOMContentLoaded', function () {
                                        // Check if buttons exist
                                        const editBtns = document.querySelectorAll('.edit-major-btn');
                                        const deleteBtns = document.querySelectorAll('.delete-major-btn');

                                        // Add direct event listeners to each button
                                        editBtns.forEach(btn => {
                                            btn.addEventListener('click', function (e) {
                                                e.preventDefault();
                                                e.stopPropagation();

                                                // Show modal logic here
                                                const id = this.dataset.id;
                                                const code = this.dataset.code;
                                                const name = this.dataset.name;
                                                const courseYear = this.dataset.courseYear || this.getAttribute('data-course-year');
                                                const description = this.dataset.description || '';

                                                document.getElementById('editMajorId').value = id;
                                                document.getElementById('editMajorCode').value = code;
                                                document.getElementById('editMajorName').value = name;
                                                document.getElementById('editMajorCourseYear').value = courseYear;
                                                document.getElementById('editMajorDescription').value = description;

                                                const editModal = new bootstrap.Modal(document.getElementById('editMajorModal'));
                                                editModal.show();
                                            });
                                        });

                                        deleteBtns.forEach(btn => {
                                            btn.addEventListener('click', function (e) {
                                                e.preventDefault();
                                                e.stopPropagation();

                                                // Show modal logic here
                                                const id = this.dataset.id;
                                                const code = this.dataset.code;

                                                document.getElementById('deleteMajorId').value = id;
                                                document.getElementById('deleteMajorName').textContent = code;

                                                const deleteModal = new bootstrap.Modal(document.getElementById('deleteMajorModal'));
                                                deleteModal.show();
                                            });
                                        });

                                        // Select Major Function (global scope needed for onclick)
                                        window.selectMajor = function (majorId) {
                                            // Cập nhật dropdown khi click ngành từ danh sách bên trái
                                            const majorSelect = document.getElementById('majorSelect');
                                            if (majorSelect) {
                                                majorSelect.value = majorId;
                                            }

                                            const url = new URL(window.location);
                                            url.searchParams.set('selectedMajorId', majorId);
                                            url.searchParams.delete('viewAll'); // Xóa viewAll khi chọn ngành cụ thể
                                            window.location.href = url.toString();
                                        }

                                        // Major Selection Dropdown Handler
                                        const majorSelect = document.getElementById('majorSelect');
                                        if (majorSelect) {
                                            majorSelect.addEventListener('change', function () {
                                                const url = new URL(window.location);
                                                const selectedValue = this.value;

                                                if (selectedValue === 'all') {
                                                    // Chuyển sang chế độ xem tất cả môn học
                                                    url.searchParams.set('viewAll', 'true');
                                                    url.searchParams.delete('selectedMajorId');
                                                } else {
                                                    // Chuyển về chế độ xem theo ngành cụ thể
                                                    url.searchParams.set('selectedMajorId', selectedValue);
                                                    url.searchParams.delete('viewAll');
                                                }

                                                // Xóa search để tránh conflict
                                                url.searchParams.delete('subjectSearch');

                                                window.location.href = url.toString();
                                            });
                                        }


                                        // Subject handlers and other functionality
                                        document.addEventListener('click', function (e) {
                                            // Edit Subject
                                            if (e.target.closest('.edit-subject-btn')) {
                                                e.stopPropagation();
                                                const btn = e.target.closest('.edit-subject-btn');
                                                const id = btn.dataset.id;
                                                const code = btn.dataset.code;
                                                const name = btn.dataset.name;
                                                const credit = btn.dataset.credit;

                                                document.getElementById('editSubjectId').value = id;
                                                document.getElementById('editSubjectCode').value = code;
                                                document.getElementById('editSubjectName').value = name;
                                                document.getElementById('editSubjectCredit').value = credit;

                                                const editModal = new bootstrap.Modal(document.getElementById('editSubjectModal'));
                                                editModal.show();
                                            }

                                            // Delete Subject
                                            if (e.target.closest('.delete-subject-btn')) {
                                                e.stopPropagation();
                                                const btn = e.target.closest('.delete-subject-btn');
                                                const id = btn.dataset.id;
                                                const code = btn.dataset.code;

                                                document.getElementById('deleteSubjectId').value = id;
                                                document.getElementById('deleteSubjectName').textContent = code;

                                                const deleteModal = new bootstrap.Modal(document.getElementById('deleteSubjectModal'));
                                                deleteModal.show();
                                            }
                                        });

                                        // Enter key search
                                        document.querySelectorAll('input[name="q"], input[name="subjectSearch"]').forEach(input => {
                                            input.addEventListener('keypress', function (e) {
                                                if (e.key === 'Enter') {
                                                    e.preventDefault();
                                                    this.form.submit();
                                                }
                                            });
                                        });

                                        // Course Year Validation
                                        function validateCourseYear(courseYear) {
                                            const pattern = /^\d{4}-\d{4}$/;
                                            if (!pattern.test(courseYear)) {
                                                return "Khóa học phải có định dạng YYYY-YYYY (ví dụ: 2023-2027)";
                                            }

                                            const years = courseYear.split('-');
                                            const startYear = parseInt(years[0]);
                                            const endYear = parseInt(years[1]);

                                            if (endYear <= startYear) {
                                                return "Năm kết thúc phải lớn hơn năm bắt đầu";
                                            }

                                            const currentYear = new Date().getFullYear();
                                            if (startYear < currentYear - 20 || startYear > currentYear + 20) {
                                                return "Năm bắt đầu phải trong khoảng " + (currentYear - 20) + " - " + (currentYear + 20);
                                            }

                                            return null;
                                        }

                                        // Add validation to course year inputs
                                        document.querySelectorAll('input[name="courseYear"]').forEach(input => {
                                            input.addEventListener('blur', function () {
                                                const error = validateCourseYear(this.value);
                                                const feedback = this.parentNode.querySelector('.invalid-feedback');

                                                if (error) {
                                                    this.classList.add('is-invalid');
                                                    if (!feedback) {
                                                        const div = document.createElement('div');
                                                        div.className = 'invalid-feedback';
                                                        div.textContent = error;
                                                        this.parentNode.appendChild(div);
                                                    } else {
                                                        feedback.textContent = error;
                                                    }
                                                } else {
                                                    this.classList.remove('is-invalid');
                                                    if (feedback) {
                                                        feedback.remove();
                                                    }
                                                }
                                            });
                                        });

                                        // Form submission validation
                                        document.querySelectorAll('form').forEach(form => {
                                            form.addEventListener('submit', function (e) {
                                                const courseYearInput = this.querySelector('input[name="courseYear"]');
                                                if (courseYearInput) {
                                                    const error = validateCourseYear(courseYearInput.value);
                                                    if (error) {
                                                        e.preventDefault();
                                                        alert(error);
                                                        courseYearInput.focus();
                                                    }
                                                }
                                            });
                                        });

                                        // Handle add subject modal
                                        const addSubjectModal = document.getElementById('addSubjectModal');
                                        if (addSubjectModal) {
                                            addSubjectModal.addEventListener('show.bs.modal', function () {
                                                const form = document.getElementById('addSubjectForm');
                                                const urlParams = new URLSearchParams(window.location.search);
                                                const viewAll = urlParams.get('viewAll');
                                                const selectedMajorId = urlParams.get('selectedMajorId');

                                                // Update form action based on current state
                                                if (viewAll === 'true' || !selectedMajorId) {
                                                    // Create independent subject
                                                    form.action = '${pageContext.request.contextPath}/admin/subjects';
                                                } else {
                                                    // Create subject and assign to major
                                                    form.action = '${pageContext.request.contextPath}/admin/majors/' + selectedMajorId + '/subjects';
                                                }
                                            });
                                        }
                                    });
                                </script>
                </body>

                </html>