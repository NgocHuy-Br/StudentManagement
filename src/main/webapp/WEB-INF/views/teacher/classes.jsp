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
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
                        rel="stylesheet">
                    <style>
                        :root {
                            --primary-color: #dc3545;
                            --primary-light: #f8d7da;
                        }

                        body {
                            background: #f7f7f9;
                            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                        }

                        .card {
                            border-radius: 12px;
                            box-shadow: 0 10px 25px rgba(0, 0, 0, .06);
                            border: none;
                        }

                        .student-avatar {
                            width: 40px;
                            height: 40px;
                            border-radius: 50%;
                            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            color: white;
                            font-weight: 600;
                            font-size: 14px;
                        }

                        .btn-action {
                            width: 32px;
                            height: 32px;
                            padding: 0;
                            display: inline-flex;
                            align-items: center;
                            justify-content: center;
                            border-radius: 6px;
                        }

                        .table-students tbody tr:hover {
                            background: #fffaf7;
                        }

                        .class-selector {
                            background: white;
                            border-radius: 12px;
                            padding: 1.5rem;
                            margin-bottom: 1.5rem;
                            box-shadow: 0 10px 25px rgba(0, 0, 0, .06);
                        }

                        .class-info-badge {
                            background: var(--primary-light);
                            color: var(--primary-color);
                            padding: 0.5rem 1rem;
                            border-radius: 8px;
                            font-weight: 600;
                            display: inline-flex;
                            align-items: center;
                            gap: 0.5rem;
                        }
                    </style>
                </head>

                <body>
                    <%@include file="../common/header.jsp" %>

                        <div class="container-fluid my-4">
                            <c:set var="activeTab" value="classes" />
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

                                <!-- Class Selection -->
                                <div class="class-selector">
                                    <div class="row align-items-center">
                                        <div class="col-md-4">
                                            <label for="classSelect" class="form-label fw-semibold">
                                                <i class="bi bi-building"></i> Chọn lớp học
                                            </label>
                                            <select class="form-select" id="classSelect" onchange="filterByClass()">
                                                <option value="">Tất cả lớp</option>
                                                <c:forEach items="${assignedClasses}" var="classroom">
                                                    <option value="${classroom.id}">${classroom.classCode}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-md-4">
                                            <label for="searchInput" class="form-label fw-semibold">
                                                <i class="bi bi-search"></i> Tìm kiếm sinh viên
                                            </label>
                                            <input type="text" class="form-control" id="searchInput"
                                                placeholder="Tìm theo MSSV hoặc tên..." onkeyup="searchStudents()">
                                        </div>
                                        <div class="col-md-4">
                                            <div class="class-info-badge mt-4">
                                                <i class="bi bi-people"></i>
                                                <span id="studentCount">${fn:length(allStudents)}</span> sinh viên
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Students Table -->
                                <div class="card">
                                    <div class="card-header">
                                        <h5 class="card-title mb-0">
                                            <i class="bi bi-people"></i> Danh sách sinh viên
                                        </h5>
                                    </div>
                                    <div class="card-body p-0">
                                        <div class="table-responsive">
                                            <table class="table table-students mb-0">
                                                <thead class="bg-light">
                                                    <tr>
                                                        <th style="width: 60px;">TT</th>
                                                        <th>MSSV</th>
                                                        <th>Họ và tên</th>
                                                        <th>Email</th>
                                                        <th>Số điện thoại</th>
                                                        <th>Lớp</th>
                                                        <th style="width: 80px;">Thao tác</th>
                                                    </tr>
                                                </thead>
                                                <tbody id="studentsTable">
                                                    <c:forEach items="${allStudents}" var="student" varStatus="status">
                                                        <tr class="student-row" data-class-id="${student.classroom.id}"
                                                            data-mssv="${student.user.username}"
                                                            data-name="${student.user.fname} ${student.user.lname}"
                                                            data-email="${student.user.email}"
                                                            data-phone="${student.user.phone}">
                                                            <td>
                                                                <div
                                                                    class="d-flex align-items-center justify-content-center">
                                                                    <strong class="text-primary">${status.index +
                                                                        1}</strong>
                                                                </div>
                                                            </td>
                                                            <td>
                                                                <strong
                                                                    class="text-primary">${student.user.username}</strong>
                                                            </td>
                                                            <td>
                                                                <strong>${student.user.fname}
                                                                    ${student.user.lname}</strong>
                                                            </td>
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${not empty student.user.email}">
                                                                        ${student.user.email}
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="text-muted">Chưa cập nhật</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${not empty student.user.phone}">
                                                                        ${student.user.phone}
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="text-muted">Chưa cập nhật</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td>
                                                                <span
                                                                    class="badge bg-primary">${student.classroom.classCode}</span>
                                                            </td>
                                                            <td>
                                                                <a href="/teacher/student/${student.id}/detail"
                                                                    class="btn btn-outline-primary btn-action"
                                                                    title="Xem chi tiết">
                                                                    <i class="bi bi-eye"></i>
                                                                </a>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </div>

                                <!-- Empty State -->
                                <c:if test="${empty allStudents}">
                                    <div class="text-center py-5">
                                        <i class="bi bi-people text-muted" style="font-size: 4rem;"></i>
                                        <h4 class="text-muted mt-3">Chưa có sinh viên nào</h4>
                                        <p class="text-muted">Hiện tại chưa có sinh viên trong các lớp được phân công.
                                        </p>
                                    </div>
                                </c:if>
                        </div>

                        <script
                            src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
                        <script>
                            // Cache buster v2.0 - Search only by MSSV and Name, NOT email
                            console.log('JavaScript loaded - Search function updated');

                            // Filter by class
                            function filterByClass() {
                                const classId = document.getElementById('classSelect').value;
                                const rows = document.querySelectorAll('.student-row');
                                let visibleCount = 0;

                                rows.forEach(row => {
                                    if (classId === '' || row.dataset.classId === classId) {
                                        row.style.display = '';
                                        visibleCount++;
                                    } else {
                                        row.style.display = 'none';
                                    }
                                });

                                document.getElementById('studentCount').textContent = visibleCount;
                            }

                            // Search students (only by MSSV and name)
                            function searchStudents() {
                                const searchTerm = document.getElementById('searchInput').value.toLowerCase();
                                const rows = document.querySelectorAll('.student-row');
                                let visibleCount = 0;

                                rows.forEach(row => {
                                    const mssv = row.dataset.mssv.toLowerCase();
                                    const name = row.dataset.name.toLowerCase();
                                    // CHỈ tìm theo MSSV và tên đầy đủ, KHÔNG tìm theo email

                                    if (mssv.includes(searchTerm) || name.includes(searchTerm)) {
                                        // Also check class filter
                                        const classId = document.getElementById('classSelect').value;
                                        if (classId === '' || row.dataset.classId === classId) {
                                            row.style.display = '';
                                            visibleCount++;
                                        } else {
                                            row.style.display = 'none';
                                        }
                                    } else {
                                        row.style.display = 'none';
                                    }
                                });

                                document.getElementById('studentCount').textContent = visibleCount;
                            }
                        </script>
                </body>

                </html>