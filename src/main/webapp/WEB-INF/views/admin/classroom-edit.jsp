<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Chỉnh sửa lớp học</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
                <link rel="stylesheet"
                    href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
            </head>

            <body>
                <div class="container-fluid" style="padding: 0 clamp(12px, 4vw, 36px);">
                    <%@ include file="../common/header.jsp" %>

                        <c:set var="activeTab" value="classrooms" scope="request" />
                        <%@ include file="_nav.jsp" %>

                            <div class="mt-4">
                                <div class="row justify-content-center">
                                    <div class="col-md-8">
                                        <div class="card shadow-sm">
                                            <div class="card-header bg-primary text-white">
                                                <h5 class="mb-0">
                                                    <i class="bi bi-pencil-square me-2"></i>
                                                    Chỉnh sửa lớp học: ${classroom.classCode}
                                                </h5>
                                            </div>

                                            <div class="card-body">
                                                <!-- Warning for classes with students -->
                                                <c:if test="${hasStudents}">
                                                    <div class="alert alert-warning">
                                                        <i class="bi bi-exclamation-triangle me-2"></i>
                                                        <strong>Lưu ý:</strong> Lớp học đã có sinh viên. Chỉ có thể thay
                                                        đổi giáo viên chủ nhiệm.
                                                    </div>
                                                </c:if>

                                                <form
                                                    action="${pageContext.request.contextPath}/admin/classrooms/update"
                                                    method="post">
                                                    <input type="hidden" name="${_csrf.parameterName}"
                                                        value="${_csrf.token}" />
                                                    <input type="hidden" name="id" value="${classroom.id}">

                                                    <div class="row">
                                                        <div class="col-md-6">
                                                            <div class="mb-3">
                                                                <label for="classCode" class="form-label">
                                                                    Mã lớp <span class="text-danger">*</span>
                                                                </label>
                                                                <input type="text" class="form-control" id="classCode"
                                                                    name="classCode" value="${classroom.classCode}"
                                                                    ${hasStudents ? 'readonly' : 'required' }>
                                                            </div>
                                                        </div>

                                                        <div class="col-md-6">
                                                            <div class="mb-3">
                                                                <label for="courseYear" class="form-label">
                                                                    Khóa học <span class="text-danger">*</span>
                                                                </label>
                                                                <input type="text" class="form-control" id="courseYear"
                                                                    name="courseYear" value="${classroom.courseYear}"
                                                                    pattern="[0-9]{4}-[0-9]{4}"
                                                                    placeholder="VD: 2025-2029" ${hasStudents
                                                                    ? 'readonly' : 'required' }>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <div class="row">
                                                        <div class="col-md-6">
                                                            <div class="mb-3">
                                                                <label for="majorId" class="form-label">
                                                                    Ngành <span class="text-danger">*</span>
                                                                </label>
                                                                <select class="form-select" id="majorId" name="majorId"
                                                                    ${hasStudents ? 'disabled' : 'required' }>
                                                                    <option value="">Chọn ngành...</option>
                                                                    <c:forEach var="major" items="${majors}">
                                                                        <option value="${major.id}"
                                                                            ${major.id==classroom.major.id ? 'selected'
                                                                            : '' }>
                                                                            ${major.majorCode} - ${major.majorName}
                                                                        </option>
                                                                    </c:forEach>
                                                                </select>
                                                                <c:if test="${hasStudents}">
                                                                    <input type="hidden" name="majorId"
                                                                        value="${classroom.major.id}">
                                                                </c:if>
                                                            </div>
                                                        </div>

                                                        <div class="col-md-6">
                                                            <div class="mb-3">
                                                                <label for="teacherId" class="form-label">
                                                                    Giáo viên chủ nhiệm
                                                                </label>
                                                                <select class="form-select" id="teacherId"
                                                                    name="teacherId">
                                                                    <option value="">Chọn giáo viên...</option>
                                                                    <c:forEach var="teacher" items="${teachers}">
                                                                        <option value="${teacher.id}"
                                                                            ${teacher.id==classroom.homeRoomTeacher.id
                                                                            ? 'selected' : '' }>
                                                                            ${teacher.user.username} -
                                                                            ${teacher.user.lname} ${teacher.user.fname}
                                                                        </option>
                                                                    </c:forEach>
                                                                </select>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <c:if test="${hasStudents}">
                                                        <div class="mb-3">
                                                            <label for="teacherChangeNotes" class="form-label">
                                                                Ghi chú thay đổi chủ nhiệm
                                                            </label>
                                                            <textarea class="form-control" id="teacherChangeNotes"
                                                                name="teacherChangeNotes" rows="3"
                                                                placeholder="Nhập lý do thay đổi giáo viên chủ nhiệm..."></textarea>
                                                            <small class="form-text text-muted">
                                                                Ghi chú này sẽ được lưu vào lịch sử thay đổi chủ nhiệm
                                                            </small>
                                                        </div>
                                                    </c:if>

                                                    <div class="d-flex justify-content-between">
                                                        <a href="${pageContext.request.contextPath}/admin/classrooms"
                                                            class="btn btn-secondary">
                                                            <i class="bi bi-arrow-left me-2"></i>Quay lại
                                                        </a>
                                                        <button type="submit" class="btn btn-primary">
                                                            <i class="bi bi-check-lg me-2"></i>Cập nhật
                                                        </button>
                                                    </div>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                </div>

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

                <!-- Show success/error messages -->
                <c:if test="${not empty success}">
                    <script>
                        alert('<c:out value="${success}" />');
                    </script>
                </c:if>

                <c:if test="${not empty error}">
                    <script>
                        alert('Lỗi: <c:out value="${error}" />');
                    </script>
                </c:if>

                <script>
                    // Course Year Validation
                    function validateCourseYear(courseYear) {
                        const pattern = /^[0-9]{4}-[0-9]{4}$/;
                        if (!pattern.test(courseYear)) {
                            return { isValid: false, message: "Định dạng phải là YYYY-YYYY (ví dụ: 2025-2029)" };
                        }

                        const years = courseYear.split('-');
                        const startYear = parseInt(years[0]);
                        const endYear = parseInt(years[1]);

                        if (endYear <= startYear) {
                            return { isValid: false, message: "Năm kết thúc phải lớn hơn năm bắt đầu" };
                        }

                        if (startYear < 1900 || startYear > 2100 || endYear < 1900 || endYear > 2100) {
                            return { isValid: false, message: "Năm phải nằm trong khoảng từ 1900 đến 2100" };
                        }

                        return { isValid: true, message: "" };
                    }

                    // Add validation
                    document.addEventListener('DOMContentLoaded', function () {
                        const courseYearInput = document.getElementById('courseYear');
                        const form = document.querySelector('form');

                        if (courseYearInput && !courseYearInput.readOnly) {
                            courseYearInput.addEventListener('blur', function () {
                                const validation = validateCourseYear(this.value);
                                if (!validation.isValid) {
                                    this.classList.add('is-invalid');
                                    this.setCustomValidity(validation.message);
                                } else {
                                    this.classList.remove('is-invalid');
                                    this.classList.add('is-valid');
                                    this.setCustomValidity('');
                                }
                            });
                        }

                        if (form) {
                            form.addEventListener('submit', function (e) {
                                if (courseYearInput && !courseYearInput.readOnly) {
                                    const validation = validateCourseYear(courseYearInput.value);
                                    if (!validation.isValid) {
                                        e.preventDefault();
                                        alert('Lỗi Khóa học: ' + validation.message);
                                        courseYearInput.focus();
                                        return false;
                                    }
                                }
                            });
                        }
                    });
                </script>
            </body>

            </html>