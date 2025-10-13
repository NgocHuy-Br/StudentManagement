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

                        .student-avatar {
                            width: 32px;
                            height: 32px;
                            border-radius: 50%;
                            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            color: white;
                            font-weight: 600;
                            font-size: 12px;
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

                                    <!-- Filter Section -->
                                    <div class="filter-section">
                                        <form method="GET" action="/teacher/scores" class="row g-3">
                                            <div class="col-md-3">
                                                <label for="classroomSelect" class="form-label fw-semibold">
                                                    <i class="bi bi-building"></i> Chọn lớp học
                                                </label>
                                                <select class="form-select" id="classroomSelect" name="classroomId"
                                                    onchange="this.form.submit()">
                                                    <option value="">-- Tất cả lớp --</option>
                                                    <c:forEach items="${assignedClasses}" var="classroom">
                                                        <option value="${classroom.id}"
                                                            ${selectedClassroomId==classroom.id ? 'selected' : '' }>
                                                            ${classroom.classCode}
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                            </div>

                                            <div class="col-md-3">
                                                <label for="subjectSelect" class="form-label fw-semibold">
                                                    <i class="bi bi-book"></i> Chọn môn học
                                                </label>
                                                <select class="form-select" id="subjectSelect" name="subjectId"
                                                    onchange="this.form.submit()">
                                                    <option value="">-- Tất cả môn học --</option>
                                                    <c:forEach items="${subjects}" var="subject">
                                                        <option value="${subject.id}" ${selectedSubjectId==subject.id
                                                            ? 'selected' : '' }>
                                                            ${subject.subjectCode} - ${subject.subjectName}
                                                        </option>
                                                    </c:forEach>
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
                                                        name="search" placeholder="Nhập MSSV hoặc họ tên..."
                                                        value="${param.search}"
                                                        onkeypress="if(event.key==='Enter') this.form.submit()">
                                                    <button type="button" class="btn btn-outline-secondary"
                                                        onclick="clearSearch()" title="Xóa bộ lọc">
                                                        <i class="bi bi-x-lg"></i>
                                                    </button>
                                                </div>
                                            </div>
                                        </form>
                                    </div>

                                    <c:if test="${not empty students or not empty scores}">
                                        <!-- Quick Stats -->
                                        <div class="quick-stats">
                                            <div class="row">
                                                <div class="col-md-3">
                                                    <div class="stat-item">
                                                        <span class="stat-label">Tổng sinh viên:</span>
                                                        <span class="stat-number">${fn:length(students)}</span>
                                                    </div>
                                                </div>
                                                <div class="col-md-3">
                                                    <div class="stat-item">
                                                        <span class="stat-label">Đã có điểm:</span>
                                                        <span class="stat-number">${fn:length(scores)}</span>
                                                    </div>
                                                </div>
                                                <div class="col-md-3">
                                                    <div class="stat-item">
                                                        <span class="stat-label">Chưa có điểm:</span>
                                                        <span class="stat-number">${fn:length(students) -
                                                            fn:length(scores)}</span>
                                                    </div>
                                                </div>
                                                <div class="col-md-3">
                                                    <div class="stat-item">
                                                        <span class="stat-label">Tiến độ:</span>
                                                        <span class="stat-number">
                                                            <c:if test="${fn:length(students) > 0}">
                                                                <fmt:formatNumber
                                                                    value="${(fn:length(scores) * 100) / fn:length(students)}"
                                                                    maxFractionDigits="1" />%
                                                            </c:if>
                                                            <c:if test="${fn:length(students) == 0}">0%</c:if>
                                                        </span>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Scores Management Table -->
                                        <div class="card">
                                            <div class="card-body p-0">
                                                <div class="table-responsive">
                                                    <table class="table table-hover mb-0">
                                                        <thead class="bg-light">
                                                            <tr>
                                                                <th style="width: 50px;">TT</th>
                                                                <th style="width: 100px;">MSSV</th>
                                                                <th>Sinh viên</th>
                                                                <th style="width: 150px;">Tên môn học</th>
                                                                <th style="width: 100px;">Điểm chuyên cần</th>
                                                                <th style="width: 100px;">Điểm giữa kỳ</th>
                                                                <th style="width: 100px;">Điểm cuối kỳ</th>
                                                                <th style="width: 100px;">Điểm TB</th>
                                                                <th style="width: 120px;">Kết quả</th>
                                                                <th>Ghi chú</th>
                                                                <th style="width: 120px;">Thao tác</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <c:choose>
                                                                <c:when test="${selectedSubjectId != null}">
                                                                    <!-- Hiển thị theo sinh viên khi chọn môn học cụ thể -->
                                                                    <c:forEach items="${students}" var="student"
                                                                        varStatus="status">
                                                                        <c:set var="studentScore" value="${null}" />
                                                                        <c:forEach items="${scores}" var="score">
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
                                                                                <div class="d-flex align-items-center">
                                                                                    <div class="student-avatar me-2">
                                                                                        ${fn:substring(student.user.fname,
                                                                                        0,
                                                                                        1)}${fn:substring(student.user.lname,
                                                                                        0, 1)}
                                                                                    </div>
                                                                                    <div>
                                                                                        <div class="fw-semibold">
                                                                                            ${student.user.fname}
                                                                                            ${student.user.lname}
                                                                                        </div>
                                                                                        <small
                                                                                            class="text-muted">${student.user.email}</small>
                                                                                    </div>
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
                                                                                            ${subject.subjectCode}</div>
                                                                                        <small
                                                                                            class="text-muted">${subject.subjectName}</small>
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
                                                                                                        maxFractionDigits="1" />
                                                                                                </span>
                                                                                            </c:when>
                                                                                            <c:when
                                                                                                test="${studentScore.avgScore >= 7.0}">
                                                                                                <span
                                                                                                    class="avg-score score-good">
                                                                                                    <fmt:formatNumber
                                                                                                        value="${studentScore.avgScore}"
                                                                                                        maxFractionDigits="1" />
                                                                                                </span>
                                                                                            </c:when>
                                                                                            <c:when
                                                                                                test="${studentScore.avgScore >= 5.5}">
                                                                                                <span
                                                                                                    class="avg-score score-average">
                                                                                                    <fmt:formatNumber
                                                                                                        value="${studentScore.avgScore}"
                                                                                                        maxFractionDigits="1" />
                                                                                                </span>
                                                                                            </c:when>
                                                                                            <c:otherwise>
                                                                                                <span
                                                                                                    class="avg-score score-poor">
                                                                                                    <fmt:formatNumber
                                                                                                        value="${studentScore.avgScore}"
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
                                                                                            data-student-name="${student.user.fname} ${student.user.lname}"
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
                                                                                            data-student-name="${student.user.fname} ${student.user.lname}"
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
                                                                    <!-- Hiển thị theo điểm khi chọn "Tất cả môn học" -->
                                                                    <c:forEach items="${scores}" var="score"
                                                                        varStatus="status">
                                                                        <tr>
                                                                            <td>${status.index + 1}</td>
                                                                            <td>
                                                                                <span
                                                                                    class="fw-semibold text-primary">${score.student.user.username}</span>
                                                                            </td>
                                                                            <td>
                                                                                <div class="d-flex align-items-center">
                                                                                    <div class="student-avatar me-2">
                                                                                        ${fn:substring(score.student.user.fname,
                                                                                        0,
                                                                                        1)}${fn:substring(score.student.user.lname,
                                                                                        0, 1)}
                                                                                    </div>
                                                                                    <div>
                                                                                        <div class="fw-semibold">
                                                                                            ${score.student.user.fname}
                                                                                            ${score.student.user.lname}
                                                                                        </div>
                                                                                        <small
                                                                                            class="text-muted">${score.student.user.email}</small>
                                                                                    </div>
                                                                                </div>
                                                                            </td>
                                                                            <td>
                                                                                <div class="fw-semibold text-info">
                                                                                    ${score.subject.subjectCode}</div>
                                                                                <small
                                                                                    class="text-muted">${score.subject.subjectName}</small>
                                                                            </td>
                                                                            <td>
                                                                                <c:choose>
                                                                                    <c:when
                                                                                        test="${score.attendanceScore != null}">
                                                                                        <span
                                                                                            class="fw-semibold">${score.attendanceScore}</span>
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
                                                                                        test="${score.midtermScore != null}">
                                                                                        <span
                                                                                            class="fw-semibold">${score.midtermScore}</span>
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
                                                                                        test="${score.finalScore != null}">
                                                                                        <span
                                                                                            class="fw-semibold">${score.finalScore}</span>
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
                                                                                        test="${score.avgScore != null}">
                                                                                        <c:choose>
                                                                                            <c:when
                                                                                                test="${score.avgScore >= 8.5}">
                                                                                                <span
                                                                                                    class="avg-score score-excellent">
                                                                                                    <fmt:formatNumber
                                                                                                        value="${score.avgScore}"
                                                                                                        maxFractionDigits="1" />
                                                                                                </span>
                                                                                            </c:when>
                                                                                            <c:when
                                                                                                test="${score.avgScore >= 7.0}">
                                                                                                <span
                                                                                                    class="avg-score score-good">
                                                                                                    <fmt:formatNumber
                                                                                                        value="${score.avgScore}"
                                                                                                        maxFractionDigits="1" />
                                                                                                </span>
                                                                                            </c:when>
                                                                                            <c:when
                                                                                                test="${score.avgScore >= 5.5}">
                                                                                                <span
                                                                                                    class="avg-score score-average">
                                                                                                    <fmt:formatNumber
                                                                                                        value="${score.avgScore}"
                                                                                                        maxFractionDigits="1" />
                                                                                                </span>
                                                                                            </c:when>
                                                                                            <c:otherwise>
                                                                                                <span
                                                                                                    class="avg-score score-poor">
                                                                                                    <fmt:formatNumber
                                                                                                        value="${score.avgScore}"
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
                                                                                        test="${score.avgScore != null}">
                                                                                        <c:choose>
                                                                                            <c:when
                                                                                                test="${score.avgScore >= 5.0}">
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
                                                                                            đánh giá</span>
                                                                                    </c:otherwise>
                                                                                </c:choose>
                                                                            </td>
                                                                            <td>
                                                                                <c:choose>
                                                                                    <c:when
                                                                                        test="${not empty score.notes}">
                                                                                        <small>${score.notes}</small>
                                                                                    </c:when>
                                                                                    <c:otherwise>
                                                                                        <span
                                                                                            class="text-muted">--</span>
                                                                                    </c:otherwise>
                                                                                </c:choose>
                                                                            </td>
                                                                            <td>
                                                                                <button type="button"
                                                                                    class="btn btn-outline-primary btn-sm edit-score-btn"
                                                                                    data-score-id="${score.id}"
                                                                                    data-student-id="${score.student.id}"
                                                                                    data-student-name="${score.student.user.fname} ${score.student.user.lname}"
                                                                                    data-attendance-score="${score.attendanceScore}"
                                                                                    data-midterm-score="${score.midtermScore}"
                                                                                    data-final-score="${score.finalScore}"
                                                                                    data-notes="${score.notes}"
                                                                                    title="Chỉnh sửa điểm">
                                                                                    <i class="bi bi-pencil-square"></i>
                                                                                </button>
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
                                    </c:if>

                                    <c:if test="${empty students and empty scores}">
                                        <div class="text-center py-5">
                                            <i class="bi bi-journal-text text-muted" style="font-size: 4rem;"></i>
                                            <h4 class="text-muted mt-3">Chọn lớp học để quản lý điểm</h4>
                                            <p class="text-muted">Vui lòng chọn lớp học hoặc "Tất cả lớp" để bắt đầu
                                                quản lý
                                                điểm sinh viên.
                                            </p>
                                        </div>
                                    </c:if>
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
                                                    <input type="hidden" name="subjectId" value="${selectedSubjectId}">

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
                                                                    chuyên cần
                                                                    (10%)</label>
                                                                <input type="number" class="form-control"
                                                                    id="attendanceScore" name="attendanceScore" min="0"
                                                                    max="10" step="0.1" placeholder="0.0">
                                                            </div>
                                                        </div>
                                                        <div class="col-md-4">
                                                            <div class="mb-3">
                                                                <label for="midtermScore" class="form-label">Điểm giữa
                                                                    kỳ
                                                                    (30%)</label>
                                                                <input type="number" class="form-control"
                                                                    id="midtermScore" name="midtermScore" min="0"
                                                                    max="10" step="0.1" placeholder="0.0">
                                                            </div>
                                                        </div>
                                                        <div class="col-md-4">
                                                            <div class="mb-3">
                                                                <label for="finalScore" class="form-label">Điểm cuối kỳ
                                                                    (60%)</label>
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
                                    // Event listeners for buttons
                                    document.addEventListener('DOMContentLoaded', function () {
                                        // Add score button handler
                                        document.addEventListener('click', function (e) {
                                            if (e.target.closest('.add-score-btn')) {
                                                const btn = e.target.closest('.add-score-btn');
                                                const studentId = btn.dataset.studentId;
                                                const studentName = btn.dataset.studentName;
                                                addScore(studentId, studentName);
                                            }
                                        });

                                        // Edit score button handler
                                        document.addEventListener('click', function (e) {
                                            if (e.target.closest('.edit-score-btn')) {
                                                const btn = e.target.closest('.edit-score-btn');
                                                const scoreId = btn.dataset.scoreId;
                                                const studentId = btn.dataset.studentId;
                                                const studentName = btn.dataset.studentName;
                                                const attendanceScore = btn.dataset.attendanceScore === 'null' || btn.dataset.attendanceScore === '' ? null : parseFloat(btn.dataset.attendanceScore);
                                                const midtermScore = btn.dataset.midtermScore === 'null' || btn.dataset.midtermScore === '' ? null : parseFloat(btn.dataset.midtermScore);
                                                const finalScore = btn.dataset.finalScore === 'null' || btn.dataset.finalScore === '' ? null : parseFloat(btn.dataset.finalScore);
                                                const notes = btn.dataset.notes === 'null' ? '' : btn.dataset.notes;
                                                editScore(scoreId, studentId, studentName, attendanceScore, midtermScore, finalScore, notes);
                                            }
                                        });
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

                                    function addScore(studentId, studentName) {
                                        document.getElementById('scoreModalTitle').textContent = 'Thêm điểm mới';
                                        document.getElementById('studentId').value = studentId;
                                        document.getElementById('studentInfo').textContent = studentName;
                                        document.getElementById('attendanceScore').value = '';
                                        document.getElementById('midtermScore').value = '';
                                        document.getElementById('finalScore').value = '';
                                        document.getElementById('notes').value = '';

                                        new bootstrap.Modal(document.getElementById('scoreModal')).show();
                                    }

                                    function editScore(scoreId, studentId, studentName, attendance, midterm, final, notes) {
                                        document.getElementById('scoreModalTitle').textContent = 'Chỉnh sửa điểm';
                                        document.getElementById('studentId').value = studentId;
                                        document.getElementById('studentInfo').textContent = studentName;
                                        document.getElementById('attendanceScore').value = attendance || '';
                                        document.getElementById('midtermScore').value = midterm || '';
                                        document.getElementById('finalScore').value = final || '';
                                        document.getElementById('notes').value = notes || '';

                                        new bootstrap.Modal(document.getElementById('scoreModal')).show();
                                    }
                                </script>
                    </div>
                </body>

                </html>