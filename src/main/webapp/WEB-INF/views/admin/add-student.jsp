<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <title>Thêm sinh viên mới</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        </head>

        <body>
            <div class="container mt-4">
                <h3>Thêm sinh viên mới</h3>
                <form method="post" action="/admin/students/add">
                    <div class="mb-3">
                        <label for="studentName" class="form-label">Họ tên sinh viên</label>
                        <input type="text" class="form-control" id="studentName" name="name" required>
                    </div>
                    <div class="mb-3">
                        <label for="studentClass" class="form-label">Lớp</label>
                        <select class="form-select" id="studentClass" name="classId">
                            <option value="">-- Chọn lớp --</option>
                            <c:forEach var="classroom" items="${classrooms}">
                                <option value="${classroom.id}" ${selectedClassroom !=null &&
                                    selectedClassroom.id==classroom.id ? 'selected' : '' }>
                                    ${classroom.name}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="studentMajor" class="form-label">Ngành</label>
                        <select class="form-select" id="studentMajor" name="majorId" ${disableMajorSelect ? 'disabled'
                            : '' }>
                            <option value="">-- Chọn ngành --</option>
                            <c:forEach var="major" items="${majors}">
                                <option value="${major.id}" ${selectedMajor !=null && selectedMajor.id==major.id
                                    ? 'selected' : '' }>
                                    ${major.name}
                                </option>
                            </c:forEach>
                        </select>
                        <c:if test="${disableMajorSelect}">
                            <div class="form-text text-muted">Ngành đã được gán theo lớp đã chọn.</div>
                        </c:if>
                    </div>
                    <!-- Thêm các trường khác nếu cần -->
                    <button type="submit" class="btn btn-success">Thêm sinh viên</button>
                </form>
            </div>
        </body>

        </html>