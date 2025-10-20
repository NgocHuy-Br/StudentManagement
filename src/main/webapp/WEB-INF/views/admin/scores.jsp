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

                        /* Prevent horizontal overflow */
                        .mt-4 {
                            max-width: 100%;
                            overflow-x: hidden;
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
                                            <form method="GET" action="/admin/scores" class="row g-3">
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
                                                        <button type="submit" class="btn btn-outline-primary" ${empty
                                                            selectedClassroomId ? 'disabled' : '' }>
                                                            <i class="bi bi-search"></i>
                                                        </button>
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
                                                    onclick="exportToPdf()">
                                                    <i class="bi bi-file-earmark-pdf"></i> Xuất PDF
                                                </button>
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
                                                        <p class="text-muted">Bạn cần chọn một lớp học cụ thể để xem
                                                            điểm sinh viên</p>
                                                        <c:if test="${empty assignedClasses}">
                                                            <div class="alert alert-warning mt-3">
                                                                <i class="bi bi-exclamation-triangle"></i>
                                                                Hệ thống chưa có lớp học nào
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

                                <script
                                    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
                                <script>
                                    // Reset subject selection and search when classroom changes
                                    function resetSubjectAndSubmit() {
                                        const subjectSelect = document.getElementById('subjectSelect');
                                        const searchInput = document.getElementById('searchInput');

                                        subjectSelect.value = ''; // Reset to "-- Tất cả môn học --"
                                        searchInput.value = ''; // Clear search input

                                        const form = subjectSelect.closest('form');
                                        form.submit();
                                    }

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

                                    function exportToPdf() {
                                        // Lấy các giá trị filter hiện tại
                                        const classroomId = document.getElementById('classroomSelect').value;
                                        const subjectId = document.getElementById('subjectSelect').value;
                                        const search = document.getElementById('searchInput').value;

                                        // Tạo URL với các tham số
                                        let url = '/admin/scores/export-pdf?';
                                        const params = new URLSearchParams();

                                        if (classroomId) {
                                            params.append('classroomId', classroomId);
                                        }
                                        if (subjectId) {
                                            params.append('subjectId', subjectId);
                                        }
                                        if (search && search.trim() !== '') {
                                            params.append('search', search.trim());
                                        }

                                        url += params.toString();

                                        // Tải file PDF
                                        window.open(url, '_blank');
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
                                </script>
                    </div>
                </body>

                </html>