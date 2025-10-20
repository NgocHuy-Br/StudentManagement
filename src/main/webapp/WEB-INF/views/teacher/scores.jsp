<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Quản lý điểm sinh viên</title>
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

                        .filter-section {
                            background: white;
                            border-radius: 12px;
                            padding: 1.5rem;
                            margin-bottom: 1.5rem;
                            box-shadow: 0 10px 25px rgba(0, 0, 0, .06);
                        }

                        .score-input {
                            width: 80px;
                        }

                        .avg-score {
                            font-weight: 700;
                            font-size: 1.1rem;
                        }

                        .score-excellent {
                            color: #28a745;
                        }

                        .score-good {
                            color: #17a2b8;
                        }

                        .score-average {
                            color: #ffc107;
                        }

                        .score-poor {
                            color: #dc3545;
                        }

                        .quick-stats {
                            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                            color: white;
                            border-radius: 10px;
                            padding: 0.8rem 1.2rem;
                            margin-bottom: 1.5rem;
                        }

                        .stat-item {
                            text-align: center;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            gap: 0.4rem;
                        }

                        .stat-label {
                            font-size: 1.1rem;
                            opacity: 0.95;
                            display: inline;
                            font-weight: 600;
                        }

                        .stat-number {
                            font-size: 1.1rem;
                            font-weight: 700;
                            display: inline;
                        }
                    </style>
                </head>

                <body>
                    <div class="container-fluid" style="padding: 0 clamp(12px, 4vw, 36px);">
                        <%@ include file="../common/header.jsp" %>

                            <c:set var="activeTab" value="scores" scope="request" />
                            <%@ include file="_nav.jsp" %>

                                <div class="mt-4">

                                    <!-- Include notification modal -->
                                    <%@ include file="../common/notification-modal.jsp" %>

                                        <!-- Filter Section -->
                                        <div class="filter-section">
                                            <form method="GET" action="/teacher/scores" class="row g-3">
                                                <div class="col-md-3">
                                                    <label for="classroomSelect" class="form-label fw-semibold">
                                                        <i class="bi bi-building"></i> Chọn lớp học <span
                                                            class="text-danger">*</span>
                                                    </label>
                                                    <select class="form-select" id="classroomSelect" name="classroomId"
                                                        onchange="resetSubjectAndSubmit()" required>
                                                        <c:choose>
                                                            <c:when test="${empty assignedClasses}">
                                                                <option value="">-- Chưa có lớp --</option>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <option value="">-- Chọn lớp học --</option>
                                                                <c:forEach items="${assignedClasses}" var="classroom">
                                                                    <option value="${classroom.id}"
                                                                        ${selectedClassroomId==classroom.id ? 'selected'
                                                                        : '' }>
                                                                        ${classroom.classCode}
                                                                    </option>
                                                                </c:forEach>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </select>
                                                </div>

                                                <div class="col-md-3">
                                                    <label for="subjectSelect" class="form-label fw-semibold">
                                                        <i class="bi bi-book"></i> Chọn môn học
                                                    </label>
                                                    <select class="form-select" id="subjectSelect" name="subjectId"
                                                        onchange="this.form.submit()" ${empty selectedClassroomId
                                                        ? 'disabled' : '' }>
                                                        <c:choose>
                                                            <c:when test="${empty selectedClassroomId}">
                                                                <option value="">-- Vui lòng chọn lớp trước --</option>
                                                            </c:when>
                                                            <c:when test="${empty subjects}">
                                                                <option value="">-- Lớp chưa có môn học --</option>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <option value="">-- Tất cả môn học --</option>
                                                                <c:forEach items="${subjects}" var="subject">
                                                                    <option value="${subject.id}"
                                                                        ${selectedSubjectId==subject.id ? 'selected'
                                                                        : '' }>
                                                                        ${subject.subjectName}
                                                                    </option>
                                                                </c:forEach>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </select>
                                                </div>

                                                <!-- Khoảng trống giữa các phần -->
                                                <div class="col-md-1"></div>

                                                <div class="col-md-5">
                                                    <label for="searchInput" class="form-label fw-semibold">
                                                        <i class="bi bi-funnel"></i> Lọc sinh viên
                                                    </label>
                                                    <div class="input-group">
                                                        <input type="text" class="form-control" id="searchInput"
                                                            name="search"
                                                            placeholder="${empty selectedClassroomId ? 'Vui lòng chọn lớp trước' : 'Nhập MSSV hoặc họ tên...'}"
                                                            value="${param.search}" ${empty selectedClassroomId
                                                            ? 'disabled' : '' }
                                                            onkeypress="if(event.key==='Enter') this.form.submit()">
                                                        <button type="button" class="btn btn-outline-secondary"
                                                            onclick="clearSearch()" title="Xóa bộ lọc" ${empty
                                                            selectedClassroomId ? 'disabled' : '' }>
                                                            <i class="bi bi-x-lg"></i>
                                                        </button>
                                                    </div>
                                                </div>
                                            </form>

                                            <!-- Export PDF Button -->
                                            <div class="mt-3">
                                                <button type="button" class="btn btn-outline-danger"
                                                    onclick="exportToPdf()" ${empty selectedClassroomId ? 'disabled'
                                                    : '' }
                                                    title="${empty selectedClassroomId ? 'Vui lòng chọn lớp học trước' : 'Xuất danh sách điểm ra file PDF'}">
                                                    <i class="bi bi-file-earmark-pdf"></i> Xuất PDF
                                                </button>
                                                <small class="text-muted ms-2">
                                                    <i class="bi bi-info-circle"></i>
                                                    ${empty selectedClassroomId ? 'Chọn lớp để xuất PDF' : 'Xuất danh
                                                    sách đang hiển thị'}
                                                </small>
                                            </div>
                                        </div>

                                        <c:choose>
                                            <c:when test="${empty selectedClassroomId}">
                                                <!-- Thông báo khi chưa chọn lớp -->
                                                <div class="card">
                                                    <div class="card-body text-center py-5">
                                                        <div class="mb-3">
                                                            <i class="bi bi-building text-muted"
                                                                style="font-size: 3rem;"></i>
                                                        </div>
                                                        <h5 class="text-muted mb-3">Vui lòng chọn lớp học</h5>
                                                        <p class="text-muted">Bạn cần chọn một lớp học cụ thể để quản lý
                                                            điểm sinh viên</p>
                                                        <c:if test="${empty assignedClasses}">
                                                            <div class="alert alert-warning mt-3">
                                                                <i class="bi bi-exclamation-triangle"></i>
                                                                Bạn chưa được phân công làm chủ nhiệm lớp nào
                                                            </div>
                                                        </c:if>
                                                    </div>
                                                </div>
                                            </c:when>
                                            <c:when
                                                test="${not empty selectedClassroomId and (not empty students or not empty scores)}">
                                                <!-- Scores Management Table -->
                                                <div class="card">
                                                    <div class="card-body p-0">
                                                        <div class="table-responsive">
                                                            <table class="table table-hover mb-0">
                                                                <thead class="bg-light">
                                                                    <tr>
                                                                        <th style="width: 40px;">TT</th>
                                                                        <th style="width: 130px;">MSSV</th>
                                                                        <th style="width: 150px;">Sinh viên</th>
                                                                        <th style="width: 180px;">Tên môn học</th>
                                                                        <th style="width: 80px;">Điểm chuyên cần</th>
                                                                        <th style="width: 80px;">Điểm giữa kỳ</th>
                                                                        <th style="width: 80px;">Điểm cuối kỳ</th>
                                                                        <th style="width: 70px;">Điểm TB</th>
                                                                        <th style="width: 90px;">Kết quả</th>
                                                                        <th style="width: 150px;">Ghi chú</th>
                                                                        <th style="width: 90px;">Nhập điểm</th>
                                                                    </tr>
                                                                </thead>
                                                                <tbody>
                                                                    <c:choose>
                                                                        <c:when test="${selectedSubjectId != null}">
                                                                            <!-- Hiển thị theo sinh viên khi chọn môn học cụ thể -->
                                                                            <c:forEach items="${students}" var="student"
                                                                                varStatus="status">
                                                                                <c:set var="studentScore"
                                                                                    value="${null}" />
                                                                                <c:forEach items="${scores}"
                                                                                    var="score">
                                                                                    <c:if
                                                                                        test="${score.student.id == student.id}">
                                                                                        <c:set var="studentScore"
                                                                                            value="${score}" />
                                                                                    </c:if>
                                                                                </c:forEach>

                                                                                <tr>
                                                                                    <td>${status.index + 1}</td>
                                                                                    <td>
                                                                                        <span
                                                                                            class="fw-semibold text-primary">${student.user.username}</span>
                                                                                    </td>
                                                                                    <td>
                                                                                        <div class="fw-semibold">
                                                                                            ${student.user.lname}
                                                                                            ${student.user.fname}
                                                                                        </div>
                                                                                    </td>
                                                                                    <td>
                                                                                        <!-- Hiển thị môn học đã chọn -->
                                                                                        <c:forEach items="${subjects}"
                                                                                            var="subject">
                                                                                            <c:if
                                                                                                test="${subject.id == selectedSubjectId}">
                                                                                                <div
                                                                                                    class="fw-semibold text-info">
                                                                                                    ${subject.subjectName}
                                                                                                </div>
                                                                                            </c:if>
                                                                                        </c:forEach>
                                                                                    </td>
                                                                                    <td>
                                                                                        <c:choose>
                                                                                            <c:when
                                                                                                test="${studentScore != null and studentScore.attendanceScore != null}">
                                                                                                <span
                                                                                                    class="fw-semibold">${studentScore.attendanceScore}</span>
                                                                                            </c:when>
                                                                                            <c:otherwise>
                                                                                                <span
                                                                                                    class="text-muted">--</span>
                                                                                            </c:otherwise>
                                                                                        </c:choose>
                                                                                    </td>
                                                                                    <td>
                                                                                        <c:choose>
                                                                                            <c:when
                                                                                                test="${studentScore != null and studentScore.midtermScore != null}">
                                                                                                <span
                                                                                                    class="fw-semibold">${studentScore.midtermScore}</span>
                                                                                            </c:when>
                                                                                            <c:otherwise>
                                                                                                <span
                                                                                                    class="text-muted">--</span>
                                                                                            </c:otherwise>
                                                                                        </c:choose>
                                                                                    </td>
                                                                                    <td>
                                                                                        <c:choose>
                                                                                            <c:when
                                                                                                test="${studentScore != null and studentScore.finalScore != null}">
                                                                                                <span
                                                                                                    class="fw-semibold">${studentScore.finalScore}</span>
                                                                                            </c:when>
                                                                                            <c:otherwise>
                                                                                                <span
                                                                                                    class="text-muted">--</span>
                                                                                            </c:otherwise>
                                                                                        </c:choose>
                                                                                    </td>
                                                                                    <td>
                                                                                        <c:choose>
                                                                                            <c:when
                                                                                                test="${studentScore != null and studentScore.avgScore != null}">
                                                                                                <c:choose>
                                                                                                    <c:when
                                                                                                        test="${studentScore.avgScore >= 8.5}">
                                                                                                        <span
                                                                                                            class="avg-score score-excellent">
                                                                                                            <fmt:formatNumber
                                                                                                                value="${studentScore.avgScore}"
                                                                                                                minFractionDigits="1"
                                                                                                                maxFractionDigits="1" />
                                                                                                        </span>
                                                                                                    </c:when>
                                                                                                    <c:when
                                                                                                        test="${studentScore.avgScore >= 7.0}">
                                                                                                        <span
                                                                                                            class="avg-score score-good">
                                                                                                            <fmt:formatNumber
                                                                                                                value="${studentScore.avgScore}"
                                                                                                                minFractionDigits="1"
                                                                                                                maxFractionDigits="1" />
                                                                                                        </span>
                                                                                                    </c:when>
                                                                                                    <c:when
                                                                                                        test="${studentScore.avgScore >= 5.5}">
                                                                                                        <span
                                                                                                            class="avg-score score-average">
                                                                                                            <fmt:formatNumber
                                                                                                                value="${studentScore.avgScore}"
                                                                                                                minFractionDigits="1"
                                                                                                                maxFractionDigits="1" />
                                                                                                        </span>
                                                                                                    </c:when>
                                                                                                    <c:otherwise>
                                                                                                        <span
                                                                                                            class="avg-score score-poor">
                                                                                                            <fmt:formatNumber
                                                                                                                value="${studentScore.avgScore}"
                                                                                                                minFractionDigits="1"
                                                                                                                maxFractionDigits="1" />
                                                                                                        </span>
                                                                                                    </c:otherwise>
                                                                                                </c:choose>
                                                                                            </c:when>
                                                                                            <c:otherwise>
                                                                                                <span
                                                                                                    class="text-muted">--</span>
                                                                                            </c:otherwise>
                                                                                        </c:choose>
                                                                                    </td>
                                                                                    <td>
                                                                                        <c:choose>
                                                                                            <c:when
                                                                                                test="${studentScore != null and studentScore.avgScore != null}">
                                                                                                <c:choose>
                                                                                                    <c:when
                                                                                                        test="${studentScore.avgScore >= 5.0}">
                                                                                                        <span
                                                                                                            class="badge bg-success fs-6">
                                                                                                            <i
                                                                                                                class="bi bi-check-circle"></i>
                                                                                                            Đạt
                                                                                                        </span>
                                                                                                    </c:when>
                                                                                                    <c:otherwise>
                                                                                                        <span
                                                                                                            class="badge bg-danger fs-6">
                                                                                                            <i
                                                                                                                class="bi bi-x-circle"></i>
                                                                                                            Không đạt
                                                                                                        </span>
                                                                                                    </c:otherwise>
                                                                                                </c:choose>
                                                                                            </c:when>
                                                                                            <c:otherwise>
                                                                                                <span
                                                                                                    class="badge bg-secondary">Chưa
                                                                                                    đánh
                                                                                                    giá</span>
                                                                                            </c:otherwise>
                                                                                        </c:choose>
                                                                                    </td>
                                                                                    <td>
                                                                                        <c:choose>
                                                                                            <c:when
                                                                                                test="${studentScore != null and not empty studentScore.notes}">
                                                                                                <small>${studentScore.notes}</small>
                                                                                            </c:when>
                                                                                            <c:otherwise>
                                                                                                <span
                                                                                                    class="text-muted">--</span>
                                                                                            </c:otherwise>
                                                                                        </c:choose>
                                                                                    </td>
                                                                                    <td>
                                                                                        <c:choose>
                                                                                            <c:when
                                                                                                test="${studentScore != null}">
                                                                                                <button type="button"
                                                                                                    class="btn btn-outline-primary btn-sm me-1 edit-score-btn"
                                                                                                    data-score-id="${studentScore.id}"
                                                                                                    data-student-id="${student.id}"
                                                                                                    data-student-name="${student.user.lname} ${student.user.fname}"
                                                                                                    data-subject-id="${selectedSubjectId}"
                                                                                                    data-attendance-score="${studentScore.attendanceScore}"
                                                                                                    data-midterm-score="${studentScore.midtermScore}"
                                                                                                    data-final-score="${studentScore.finalScore}"
                                                                                                    data-notes="${studentScore.notes}"
                                                                                                    title="Chỉnh sửa điểm">
                                                                                                    <i
                                                                                                        class="bi bi-pencil-square"></i>
                                                                                                </button>
                                                                                            </c:when>
                                                                                            <c:otherwise>
                                                                                                <button type="button"
                                                                                                    class="btn btn-outline-success btn-sm add-score-btn"
                                                                                                    data-student-id="${student.id}"
                                                                                                    data-student-name="${student.user.lname} ${student.user.fname}"
                                                                                                    data-subject-id="${selectedSubjectId}"
                                                                                                    title="Nhập điểm mới">
                                                                                                    <i
                                                                                                        class="bi bi-plus-square"></i>
                                                                                                </button>
                                                                                            </c:otherwise>
                                                                                        </c:choose>
                                                                                    </td>
                                                                                </tr>
                                                                            </c:forEach>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <!-- Hiển thị tất cả combination sinh viên x môn học khi chọn "Tất cả môn học" -->
                                                                            <c:set var="rowIndex" value="0" />
                                                                            <c:forEach items="${students}"
                                                                                var="student">
                                                                                <c:forEach items="${subjects}"
                                                                                    var="subject">
                                                                                    <c:set var="rowIndex"
                                                                                        value="${rowIndex + 1}" />
                                                                                    <!-- Tìm điểm của sinh viên này cho môn học này -->
                                                                                    <c:set var="currentScore"
                                                                                        value="${null}" />
                                                                                    <c:forEach items="${scores}"
                                                                                        var="score">
                                                                                        <c:if
                                                                                            test="${score.student.id == student.id && score.subject.id == subject.id}">
                                                                                            <c:set var="currentScore"
                                                                                                value="${score}" />
                                                                                        </c:if>
                                                                                    </c:forEach>

                                                                                    <tr>
                                                                                        <td>${rowIndex}</td>
                                                                                        <td>
                                                                                            <span
                                                                                                class="fw-semibold text-primary">${student.user.username}</span>
                                                                                        </td>
                                                                                        <td>
                                                                                            <div class="fw-semibold">
                                                                                                ${student.user.lname}
                                                                                                ${student.user.fname}
                                                                                            </div>
                                                                                        </td>
                                                                                        <td>
                                                                                            <div
                                                                                                class="fw-semibold text-info">
                                                                                                ${subject.subjectName}
                                                                                            </div>
                                                                                        </td>
                                                                                        <td>
                                                                                            <c:choose>
                                                                                                <c:when
                                                                                                    test="${currentScore != null and currentScore.attendanceScore != null}">
                                                                                                    <span
                                                                                                        class="fw-semibold">${currentScore.attendanceScore}</span>
                                                                                                </c:when>
                                                                                                <c:otherwise>
                                                                                                    <span
                                                                                                        class="text-muted">--</span>
                                                                                                </c:otherwise>
                                                                                            </c:choose>
                                                                                        </td>
                                                                                        <td>
                                                                                            <c:choose>
                                                                                                <c:when
                                                                                                    test="${currentScore != null and currentScore.midtermScore != null}">
                                                                                                    <span
                                                                                                        class="fw-semibold">${currentScore.midtermScore}</span>
                                                                                                </c:when>
                                                                                                <c:otherwise>
                                                                                                    <span
                                                                                                        class="text-muted">--</span>
                                                                                                </c:otherwise>
                                                                                            </c:choose>
                                                                                        </td>
                                                                                        <td>
                                                                                            <c:choose>
                                                                                                <c:when
                                                                                                    test="${currentScore != null and currentScore.finalScore != null}">
                                                                                                    <span
                                                                                                        class="fw-semibold">${currentScore.finalScore}</span>
                                                                                                </c:when>
                                                                                                <c:otherwise>
                                                                                                    <span
                                                                                                        class="text-muted">--</span>
                                                                                                </c:otherwise>
                                                                                            </c:choose>
                                                                                        </td>
                                                                                        <td>
                                                                                            <c:choose>
                                                                                                <c:when
                                                                                                    test="${currentScore != null and currentScore.avgScore != null}">
                                                                                                    <c:choose>
                                                                                                        <c:when
                                                                                                            test="${currentScore.avgScore >= 8.5}">
                                                                                                            <span
                                                                                                                class="avg-score score-excellent">
                                                                                                                <fmt:formatNumber
                                                                                                                    value="${currentScore.avgScore}"
                                                                                                                    minFractionDigits="1"
                                                                                                                    maxFractionDigits="1" />
                                                                                                            </span>
                                                                                                        </c:when>
                                                                                                        <c:when
                                                                                                            test="${currentScore.avgScore >= 7.0}">
                                                                                                            <span
                                                                                                                class="avg-score score-good">
                                                                                                                <fmt:formatNumber
                                                                                                                    value="${currentScore.avgScore}"
                                                                                                                    minFractionDigits="1"
                                                                                                                    maxFractionDigits="1" />
                                                                                                            </span>
                                                                                                        </c:when>
                                                                                                        <c:when
                                                                                                            test="${currentScore.avgScore >= 5.5}">
                                                                                                            <span
                                                                                                                class="avg-score score-average">
                                                                                                                <fmt:formatNumber
                                                                                                                    value="${currentScore.avgScore}"
                                                                                                                    minFractionDigits="1"
                                                                                                                    maxFractionDigits="1" />
                                                                                                            </span>
                                                                                                        </c:when>
                                                                                                        <c:otherwise>
                                                                                                            <span
                                                                                                                class="avg-score score-poor">
                                                                                                                <fmt:formatNumber
                                                                                                                    value="${currentScore.avgScore}"
                                                                                                                    minFractionDigits="1"
                                                                                                                    maxFractionDigits="1" />
                                                                                                            </span>
                                                                                                        </c:otherwise>
                                                                                                    </c:choose>
                                                                                                </c:when>
                                                                                                <c:otherwise>
                                                                                                    <span
                                                                                                        class="text-muted">--</span>
                                                                                                </c:otherwise>
                                                                                            </c:choose>
                                                                                        </td>
                                                                                        <td>
                                                                                            <c:choose>
                                                                                                <c:when
                                                                                                    test="${currentScore != null and currentScore.avgScore != null}">
                                                                                                    <c:choose>
                                                                                                        <c:when
                                                                                                            test="${currentScore.avgScore >= 5.0}">
                                                                                                            <span
                                                                                                                class="badge bg-success fs-6">
                                                                                                                <i
                                                                                                                    class="bi bi-check-circle"></i>
                                                                                                                Đạt
                                                                                                            </span>
                                                                                                        </c:when>
                                                                                                        <c:otherwise>
                                                                                                            <span
                                                                                                                class="badge bg-danger fs-6">
                                                                                                                <i
                                                                                                                    class="bi bi-x-circle"></i>
                                                                                                                Không
                                                                                                                đạt
                                                                                                            </span>
                                                                                                        </c:otherwise>
                                                                                                    </c:choose>
                                                                                                </c:when>
                                                                                                <c:otherwise>
                                                                                                    <span
                                                                                                        class="badge bg-secondary">Chưa
                                                                                                        đánh giá</span>
                                                                                                </c:otherwise>
                                                                                            </c:choose>
                                                                                        </td>
                                                                                        <td>
                                                                                            <c:choose>
                                                                                                <c:when
                                                                                                    test="${currentScore != null and not empty currentScore.notes}">
                                                                                                    <small>${currentScore.notes}</small>
                                                                                                </c:when>
                                                                                                <c:otherwise>
                                                                                                    <span
                                                                                                        class="text-muted">--</span>
                                                                                                </c:otherwise>
                                                                                            </c:choose>
                                                                                        </td>
                                                                                        <td>
                                                                                            <c:choose>
                                                                                                <c:when
                                                                                                    test="${currentScore != null}">
                                                                                                    <button
                                                                                                        type="button"
                                                                                                        class="btn btn-outline-primary btn-sm me-1 edit-score-btn"
                                                                                                        data-score-id="${currentScore.id}"
                                                                                                        data-student-id="${student.id}"
                                                                                                        data-student-name="${student.user.lname} ${student.user.fname}"
                                                                                                        data-subject-id="${subject.id}"
                                                                                                        data-attendance-score="${currentScore.attendanceScore}"
                                                                                                        data-midterm-score="${currentScore.midtermScore}"
                                                                                                        data-final-score="${currentScore.finalScore}"
                                                                                                        data-notes="${currentScore.notes}"
                                                                                                        title="Chỉnh sửa điểm">
                                                                                                        <i
                                                                                                            class="bi bi-pencil-square"></i>
                                                                                                    </button>
                                                                                                </c:when>
                                                                                                <c:otherwise>
                                                                                                    <button
                                                                                                        type="button"
                                                                                                        class="btn btn-outline-success btn-sm add-score-btn"
                                                                                                        data-student-id="${student.id}"
                                                                                                        data-student-name="${student.user.lname} ${student.user.fname}"
                                                                                                        data-subject-id="${subject.id}"
                                                                                                        title="Nhập điểm mới">
                                                                                                        <i
                                                                                                            class="bi bi-plus-square"></i>
                                                                                                    </button>
                                                                                                </c:otherwise>
                                                                                            </c:choose>
                                                                                        </td>
                                                                                    </tr>
                                                                                </c:forEach>
                                                                            </c:forEach>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </tbody>
                                                            </table>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:when>
                                            <c:when
                                                test="${not empty selectedClassroomId and empty students and empty scores}">
                                                <!-- Thông báo khi lớp không có sinh viên hoặc chưa có điểm -->
                                                <div class="card">
                                                    <div class="card-body text-center py-5">
                                                        <div class="mb-3">
                                                            <i class="bi bi-journal-text text-muted"
                                                                style="font-size: 3rem;"></i>
                                                        </div>
                                                        <h5 class="text-muted mb-3">Chưa có dữ liệu</h5>
                                                        <p class="text-muted">Lớp học này chưa có sinh viên hoặc chưa có
                                                            điểm nào được nhập</p>
                                                    </div>
                                                </div>
                                            </c:when>
                                        </c:choose>
                                </div>

                                <!-- Add/Edit Score Modal -->
                                <div class="modal fade" id="scoreModal" tabindex="-1">
                                    <div class="modal-dialog">
                                        <div class="modal-content">
                                            <div class="modal-header">
                                                <h5 class="modal-title" id="scoreModalTitle">Nhập điểm sinh viên</h5>
                                                <button type="button" class="btn-close"
                                                    data-bs-dismiss="modal"></button>
                                            </div>
                                            <form id="scoreForm" method="POST" action="/teacher/scores/update">
                                                <div class="modal-body">
                                                    <input type="hidden" name="studentId" id="studentId">
                                                    <input type="hidden" name="subjectId" id="subjectId">

                                                    <div class="mb-3">
                                                        <label class="form-label fw-semibold">Sinh viên</label>
                                                        <div id="studentInfo"
                                                            class="form-control-plaintext fw-semibold text-primary">
                                                        </div>
                                                    </div>

                                                    <div class="row">
                                                        <div class="col-md-4">
                                                            <div class="mb-3">
                                                                <label for="attendanceScore" class="form-label">Điểm
                                                                    chuyên cần<br>(<span
                                                                        id="attendanceWeightLabel">10%</span>)</label>
                                                                <input type="number" class="form-control"
                                                                    id="attendanceScore" name="attendanceScore" min="0"
                                                                    max="10" step="0.1" placeholder="0.0">
                                                            </div>
                                                        </div>
                                                        <div class="col-md-4">
                                                            <div class="mb-3">
                                                                <label for="midtermScore" class="form-label">Điểm giữa
                                                                    kỳ<br>(<span
                                                                        id="midtermWeightLabel">30%</span>)</label>
                                                                <input type="number" class="form-control"
                                                                    id="midtermScore" name="midtermScore" min="0"
                                                                    max="10" step="0.1" placeholder="0.0">
                                                            </div>
                                                        </div>
                                                        <div class="col-md-4">
                                                            <div class="mb-3">
                                                                <label for="finalScore" class="form-label">Điểm cuối
                                                                    kỳ<br>(<span
                                                                        id="finalWeightLabel">60%</span>)</label>
                                                                <input type="number" class="form-control"
                                                                    id="finalScore" name="finalScore" min="0" max="10"
                                                                    step="0.1" placeholder="0.0">
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <div class="mb-3">
                                                        <label for="notes" class="form-label">Ghi chú</label>
                                                        <textarea class="form-control" id="notes" name="notes" rows="3"
                                                            placeholder="Ghi chú về quá trình học tập..."></textarea>
                                                    </div>
                                                </div>
                                                <div class="modal-footer">
                                                    <button type="button" class="btn btn-secondary"
                                                        data-bs-dismiss="modal">Hủy</button>
                                                    <button type="submit" class="btn btn-primary">Lưu điểm</button>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </div>

                                <script
                                    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
                                <script>
                                    // Create subjects mapping for weights
                                    var subjectsData = {};
                                    <c:forEach items="${subjects}" var="subject">
                                        subjectsData['${subject.id}'] = { };
                                        subjectsData['${subject.id}'].attendanceWeight = Math.round(${subject.attendanceWeight} * 100);
                                        subjectsData['${subject.id}'].midtermWeight = Math.round(${subject.midtermWeight} * 100);
                                        subjectsData['${subject.id}'].finalWeight = Math.round(${subject.finalWeight} * 100);
                                    </c:forEach>

                                    // Function to update weight labels
                                    function updateWeightLabels(subjectId) {
                                        if (subjectId && subjectsData[subjectId]) {
                                            var weights = subjectsData[subjectId];
                                            document.getElementById('attendanceWeightLabel').textContent = weights.attendanceWeight + '%';
                                            document.getElementById('midtermWeightLabel').textContent = weights.midtermWeight + '%';
                                            document.getElementById('finalWeightLabel').textContent = weights.finalWeight + '%';
                                        } else {
                                            // Default values when no subject selected
                                            document.getElementById('attendanceWeightLabel').textContent = '10%';
                                            document.getElementById('midtermWeightLabel').textContent = '30%';
                                            document.getElementById('finalWeightLabel').textContent = '60%';
                                        }
                                    }

                                    // Reset subject selection and search when classroom changes
                                    function resetSubjectAndSubmit() {
                                        const subjectSelect = document.getElementById('subjectSelect');
                                        const searchInput = document.getElementById('searchInput');

                                        subjectSelect.value = ''; // Reset to "-- Tất cả môn học --"
                                        searchInput.value = ''; // Clear search input

                                        const form = subjectSelect.closest('form');
                                        form.submit();
                                    }

                                    // Event listeners for buttons
                                    document.addEventListener('DOMContentLoaded', function () {
                                        // Clean up any existing modal state on page load
                                        const existingBackdrops = document.querySelectorAll('.modal-backdrop');
                                        existingBackdrops.forEach(backdrop => backdrop.remove());
                                        document.body.classList.remove('modal-open');
                                        document.body.style.removeProperty('overflow');
                                        document.body.style.removeProperty('padding-right');

                                        // Add score button handler
                                        document.addEventListener('click', function (e) {
                                            if (e.target.closest('.add-score-btn')) {
                                                const btn = e.target.closest('.add-score-btn');
                                                const studentId = btn.dataset.studentId;
                                                const studentName = btn.dataset.studentName;
                                                const subjectId = btn.dataset.subjectId;
                                                addScore(studentId, studentName, subjectId);
                                            }
                                        });

                                        // Edit score button handler
                                        document.addEventListener('click', function (e) {
                                            if (e.target.closest('.edit-score-btn')) {
                                                const btn = e.target.closest('.edit-score-btn');
                                                const scoreId = btn.dataset.scoreId;
                                                const studentId = btn.dataset.studentId;
                                                const studentName = btn.dataset.studentName;
                                                const subjectId = btn.dataset.subjectId;
                                                const attendanceScore = btn.dataset.attendanceScore === 'null' || btn.dataset.attendanceScore === '' ? null : parseFloat(btn.dataset.attendanceScore);
                                                const midtermScore = btn.dataset.midtermScore === 'null' || btn.dataset.midtermScore === '' ? null : parseFloat(btn.dataset.midtermScore);
                                                const finalScore = btn.dataset.finalScore === 'null' || btn.dataset.finalScore === '' ? null : parseFloat(btn.dataset.finalScore);
                                                const notes = btn.dataset.notes === 'null' ? '' : btn.dataset.notes;
                                                editScore(scoreId, studentId, studentName, subjectId, attendanceScore, midtermScore, finalScore, notes);
                                            }
                                        });

                                        // Form submit handler to close modal before submit
                                        const scoreForm = document.getElementById('scoreForm');
                                        if (scoreForm) {
                                            scoreForm.addEventListener('submit', function (e) {
                                                // Close modal immediately when form is submitted
                                                const modal = bootstrap.Modal.getInstance(document.getElementById('scoreModal'));
                                                if (modal) {
                                                    modal.hide();
                                                }
                                                // Remove backdrop if it exists
                                                setTimeout(function () {
                                                    const backdrop = document.querySelector('.modal-backdrop');
                                                    if (backdrop) {
                                                        backdrop.remove();
                                                    }
                                                    document.body.classList.remove('modal-open');
                                                    document.body.style.removeProperty('overflow');
                                                    document.body.style.removeProperty('padding-right');
                                                }, 100);
                                            });
                                        }
                                    });

                                    function clearSearch() {
                                        document.getElementById('searchInput').value = '';
                                        // Giữ nguyên các filter khác và chỉ xóa search
                                        const form = document.querySelector('form');
                                        const searchInput = document.querySelector('input[name="search"]');
                                        if (searchInput) {
                                            searchInput.remove();
                                        }
                                        form.submit();
                                    }

                                    function addScore(studentId, studentName, subjectId) {
                                        document.getElementById('scoreModalTitle').textContent = 'Thêm điểm mới';
                                        document.getElementById('studentId').value = studentId;
                                        document.getElementById('subjectId').value = subjectId;
                                        document.getElementById('studentInfo').textContent = studentName;
                                        document.getElementById('attendanceScore').value = '';
                                        document.getElementById('midtermScore').value = '';
                                        document.getElementById('finalScore').value = '';
                                        document.getElementById('notes').value = '';

                                        // Update weight labels based on selected subject
                                        updateWeightLabels(subjectId);

                                        new bootstrap.Modal(document.getElementById('scoreModal')).show();
                                    }

                                    function editScore(scoreId, studentId, studentName, subjectId, attendance, midterm, final, notes) {
                                        document.getElementById('scoreModalTitle').textContent = 'Chỉnh sửa điểm';
                                        document.getElementById('studentId').value = studentId;
                                        document.getElementById('subjectId').value = subjectId;
                                        document.getElementById('studentInfo').textContent = studentName;
                                        document.getElementById('attendanceScore').value = attendance || '';
                                        document.getElementById('midtermScore').value = midterm || '';
                                        document.getElementById('finalScore').value = final || '';
                                        document.getElementById('notes').value = notes || '';

                                        // Update weight labels based on selected subject
                                        updateWeightLabels(subjectId);

                                        new bootstrap.Modal(document.getElementById('scoreModal')).show();
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

                                    function exportToPdf() {
                                        // Lấy các giá trị filter hiện tại
                                        const classroomId = document.getElementById('classroomSelect').value;
                                        const subjectId = document.getElementById('subjectSelect').value;

                                        if (!classroomId) {
                                            showNotification('error', 'Vui lòng chọn lớp học trước khi xuất PDF', 'Lỗi');
                                            return;
                                        }

                                        // Hiển thị thông báo đang tải
                                        const exportBtn = document.querySelector('button[onclick="exportToPdf()"]');
                                        const originalText = exportBtn.innerHTML;
                                        exportBtn.innerHTML = '<i class="bi bi-hourglass-split"></i> Đang tạo PDF...';
                                        exportBtn.disabled = true;

                                        // Tạo URL với các tham số
                                        let url = `/teacher/classroom/${classroomId}/scores/export-pdf`;
                                        if (subjectId) {
                                            url += `?subjectId=${subjectId}`;
                                        }

                                        // Mở URL để tải PDF
                                        const downloadWindow = window.open(url, '_blank');

                                        // Phục hồi nút sau 2 giây
                                        setTimeout(() => {
                                            exportBtn.innerHTML = originalText;
                                            exportBtn.disabled = false;
                                        }, 2000);

                                        // Kiểm tra nếu popup bị chặn
                                        if (!downloadWindow || downloadWindow.closed || typeof downloadWindow.closed == 'undefined') {
                                            showNotification('warning', 'Vui lòng cho phép popup để tải file PDF', 'Cảnh báo');
                                            exportBtn.innerHTML = originalText;
                                            exportBtn.disabled = false;
                                        }
                                    }
                                </script>
                    </div>
                </body>

                </html>