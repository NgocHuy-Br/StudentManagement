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
                            /* Ensure consistent scrollbar with other pages */
                            overflow-x: hidden !important;
                            overflow-y: scroll !important;
                            min-height: 100vh !important;
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
                    <div class="container-fluid" style="padding: 0 clamp(12px, 4vw, 36px);">
                        <%@ include file="../common/header.jsp" %>

                            <c:set var="activeTab" value="classes" scope="request" />
                            <%@ include file="_nav.jsp" %>

                                <div class="mt-4">

                                    <!-- Include notification modal -->
                                    <%@ include file="../common/notification-modal.jsp" %>

                                        <!-- Class Selection -->
                                        <div class="class-selector">
                                            <div class="row align-items-center">
                                                <div class="col-md-3">
                                                    <div class="input-group">
                                                        <span class="input-group-text bg-light">
                                                            <i class="bi bi-funnel"></i>
                                                        </span>
                                                        <select class="form-select" id="classSelect"
                                                            onchange="filterByClass()">
                                                            <option value="">Tất cả lớp</option>
                                                            <c:forEach items="${assignedClasses}" var="classroom">
                                                                <option value="${classroom.id}">${classroom.classCode}
                                                                </option>
                                                            </c:forEach>
                                                        </select>
                                                    </div>
                                                </div>
                                                <div class="col-md-3">
                                                    <div class="input-group">
                                                        <button class="btn btn-outline-secondary" type="button"
                                                            id="searchBtn" onclick="performSearch()">
                                                            <i class="bi bi-search"></i>
                                                        </button>
                                                        <input type="text" class="form-control" id="searchInput"
                                                            placeholder="Tìm theo MSSV hoặc tên..."
                                                            onkeyup="handleSearchInput(event)">
                                                        <button class="btn btn-outline-secondary" type="button"
                                                            id="clearBtn" onclick="clearSearch()"
                                                            style="display: none;">
                                                            <i class="bi bi-x"></i>
                                                        </button>
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
                                                            <c:forEach items="${allStudents}" var="student"
                                                                varStatus="status">
                                                                <tr class="student-row"
                                                                    data-class-id="${student.classroom.id}"
                                                                    data-mssv="${student.user.username}"
                                                                    data-name="${student.user.lname} ${student.user.fname}"
                                                                    data-email="${student.user.email}"
                                                                    data-phone="${student.user.phone}">
                                                                    <td>
                                                                        <div
                                                                            class="d-flex align-items-center justify-content-center">
                                                                            <strong class="text-primary">${status.index
                                                                                +
                                                                                1}</strong>
                                                                        </div>
                                                                    </td>
                                                                    <td>
                                                                        <strong
                                                                            class="text-primary">${student.user.username}</strong>
                                                                    </td>
                                                                    <td>
                                                                        <strong>${student.user.lname}
                                                                            ${student.user.fname}</strong>
                                                                    </td>
                                                                    <td>
                                                                        <c:choose>
                                                                            <c:when
                                                                                test="${not empty student.user.email}">
                                                                                ${student.user.email}
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <span class="text-muted">Chưa cập
                                                                                    nhật</span>
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </td>
                                                                    <td>
                                                                        <c:choose>
                                                                            <c:when
                                                                                test="${not empty student.user.phone}">
                                                                                ${student.user.phone}
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <span class="text-muted">Chưa cập
                                                                                    nhật</span>
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
                                                <p class="text-muted">Hiện tại chưa có sinh viên trong các lớp được phân
                                                    công.
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

                                        rows.forEach(row => {
                                            if (classId === '' || row.dataset.classId === classId) {
                                                row.style.display = '';
                                            } else {
                                                row.style.display = 'none';
                                            }
                                        });
                                    }

                                    // Search students (only by MSSV and name)
                                    function searchStudents() {
                                        const searchTerm = document.getElementById('searchInput').value.toLowerCase();
                                        const rows = document.querySelectorAll('.student-row');

                                        rows.forEach(row => {
                                            const mssv = row.dataset.mssv.toLowerCase();
                                            const name = row.dataset.name.toLowerCase();
                                            // CHỈ tìm theo MSSV và tên đầy đủ, KHÔNG tìm theo email

                                            if (mssv.includes(searchTerm) || name.includes(searchTerm)) {
                                                // Also check class filter
                                                const classId = document.getElementById('classSelect').value;
                                                if (classId === '' || row.dataset.classId === classId) {
                                                    row.style.display = '';
                                                } else {
                                                    row.style.display = 'none';
                                                }
                                            } else {
                                                row.style.display = 'none';
                                            }
                                        });
                                    }

                                    // Handle search input with Enter key and show/hide clear button
                                    function handleSearchInput(event) {
                                        const searchInput = document.getElementById('searchInput');
                                        const clearBtn = document.getElementById('clearBtn');

                                        // Show/hide clear button based on input content
                                        if (searchInput.value.trim() !== '') {
                                            clearBtn.style.display = 'block';
                                        } else {
                                            clearBtn.style.display = 'none';
                                        }

                                        // Search on Enter key press
                                        if (event.key === 'Enter') {
                                            performSearch();
                                        }
                                    }

                                    // Perform search when button clicked
                                    function performSearch() {
                                        searchStudents();
                                        const clearBtn = document.getElementById('clearBtn');
                                        const searchInput = document.getElementById('searchInput');
                                        if (searchInput.value.trim() !== '') {
                                            clearBtn.style.display = 'block';
                                        }
                                    }

                                    // Clear search
                                    function clearSearch() {
                                        const searchInput = document.getElementById('searchInput');
                                        const clearBtn = document.getElementById('clearBtn');
                                        searchInput.value = '';
                                        clearBtn.style.display = 'none';
                                        searchStudents(); // Reset to show all students
                                    }

                                    // Check for flash messages on page load
                                    const successMessage = '${success}';
                                    if (successMessage && successMessage.trim() !== '') {
                                        showNotification('success', successMessage, 'Thành công');
                                    }

                                    const errorMessage = '${error}';
                                    if (errorMessage && errorMessage.trim() !== '') {
                                        showNotification('error', errorMessage, 'Lỗi');
                                    }

                                    // Auto-select class from URL parameter
                                    const urlParams = new URLSearchParams(window.location.search);
                                    const classIdFromUrl = urlParams.get('classId');
                                    if (classIdFromUrl) {
                                        const classSelect = document.getElementById('classSelect');
                                        if (classSelect) {
                                            classSelect.value = classIdFromUrl;
                                            // Trigger the filter function to show only selected class
                                            filterByClass();
                                        }
                                    }
                                </script>
                    </div>
                </body>

                </html>