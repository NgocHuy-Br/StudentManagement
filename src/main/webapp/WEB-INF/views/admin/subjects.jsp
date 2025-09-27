<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1">
                <title>Quản lý môn học</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
                <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
                    rel="stylesheet">
                <style>
                    :root {
                        --page-x: clamp(12px, 4vw, 36px)
                    }

                    body {
                        background: #f7f7f9
                    }

                    .main-wrap {
                        padding-left: var(--page-x);
                        padding-right: var(--page-x)
                    }

                    .card {
                        border-radius: 12px;
                        box-shadow: 0 10px 25px rgba(0, 0, 0, .06)
                    }

                    .subject-toolbar .search .form-control {
                        min-width: 260px
                    }

                    .table-subjects tbody tr:hover {
                        background: #fffaf7;
                    }

                    .sort-link {
                        text-decoration: none;
                        color: inherit
                    }

                    .sort-link .bi {
                        opacity: .5
                    }

                    .badge {
                        font-size: 0.75em;
                    }
                </style>
            </head>

            <body>
                <%@ include file="../common/header.jsp" %>
                    <main class="container-fluid main-wrap py-3">
                        <%@ include file="_nav.jsp" %>

                            <div class="card mt-3">
                                <div class="card-body">
                                    <!-- Toolbar -->
                                    <div class="d-flex justify-content-between align-items-center mb-3 subject-toolbar">
                                        <h5 class="mb-0"><i class="bi bi-book me-2"></i>Quản lý môn học</h5>
                                        <button class="btn btn-primary" data-bs-toggle="modal"
                                            data-bs-target="#modalCreate">
                                            <i class="bi bi-plus-circle me-1"></i>Thêm mới
                                        </button>
                                    </div>

                                    <!-- Thông báo -->
                                    <c:if test="${not empty error}">
                                        <div class="alert alert-danger alert-dismissible">
                                            <i class="bi bi-exclamation-triangle me-2"></i>${error}
                                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                        </div>
                                    </c:if>
                                    <c:if test="${not empty success}">
                                        <div class="alert alert-success alert-dismissible">
                                            <i class="bi bi-check-circle me-2"></i>${success}
                                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                        </div>
                                    </c:if>

                                    <!-- Tìm kiếm và lọc -->
                                    <form method="get" class="d-flex gap-2 mb-3 flex-wrap">
                                        <div class="search flex-grow-1">
                                            <div class="input-group">
                                                <span class="input-group-text"><i class="bi bi-search"></i></span>
                                                <input class="form-control" name="q" value="${fn:escapeXml(q)}"
                                                    placeholder="Tìm mã môn, tên môn...">
                                            </div>
                                        </div>
                                        <button class="btn btn-outline-primary" type="submit">Tìm</button>
                                        <c:if test="${not empty q}">
                                            <a class="btn btn-outline-secondary" href="?">Xóa</a>
                                        </c:if>
                                    </form>

                                    <!-- Bảng danh sách môn học -->
                                    <div class="table-responsive">
                                        <table class="table table-hover align-middle table-subjects">
                                            <thead class="table-light">
                                                <tr>
                                                    <th>Mã môn
                                                        <a class="sort-link"
                                                            href="?q=${fn:escapeXml(q)}&majorId=${majorId}&size=${page.size}&sort=subjectCode&dir=${dir=='asc' && sort=='subjectCode' ? 'desc' : 'asc'}">
                                                            <i class="bi bi-arrow-down-up"></i>
                                                        </a>
                                                    </th>
                                                    <th>Tên môn học
                                                        <a class="sort-link"
                                                            href="?q=${fn:escapeXml(q)}&majorId=${majorId}&size=${page.size}&sort=subjectName&dir=${dir=='asc' && sort=='subjectName' ? 'desc' : 'asc'}">
                                                            <i class="bi bi-arrow-down-up"></i>
                                                        </a>
                                                    </th>
                                                    <th>Tín chỉ
                                                        <a class="sort-link"
                                                            href="?q=${fn:escapeXml(q)}&size=${page.size}&sort=credit&dir=${dir=='asc' && sort=='credit' ? 'desc' : 'asc'}">
                                                            <i class="bi bi-arrow-down-up"></i>
                                                        </a>
                                                    </th>
                                                    <th>Các ngành</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:if test="${page.totalElements == 0}">
                                                    <tr>
                                                        <td colspan="4" class="text-center text-muted py-4">Chưa có môn
                                                            học nào.</td>
                                                    </tr>
                                                </c:if>

                                                <c:forEach var="sub" items="${page.content}">
                                                    <tr>
                                                        <td><strong>${sub.subjectCode}</strong></td>
                                                        <td>${sub.subjectName}</td>
                                                        <td>
                                                            <span class="badge bg-info">${sub.credit} TC</span>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${empty sub.majors}">
                                                                    <span class="text-muted">Chưa thuộc ngành nào</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <c:forEach var="major" items="${sub.majors}"
                                                                        varStatus="status">
                                                                        <span
                                                                            class="badge bg-secondary me-1">${major.majorCode}</span>
                                                                        <c:if test="${!status.last}">
                                                                        </c:if>
                                                                    </c:forEach>
                                                                    <br>
                                                                    <c:forEach var="major" items="${sub.majors}"
                                                                        varStatus="status">
                                                                        <small
                                                                            class="text-muted">${major.majorName}</small>
                                                                        <c:if test="${!status.last}">, </c:if>
                                                                    </c:forEach>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>

                                    <!-- Phân trang -->
                                    <c:if test="${page.totalPages > 1}">
                                        <nav class="d-flex justify-content-end">
                                            <ul class="pagination pagination-sm mb-0">
                                                <li class="page-item ${page.first ? 'disabled' : ''}">
                                                    <a class="page-link"
                                                        href="?q=${fn:escapeXml(q)}&page=${page.number-1}&size=${page.size}&sort=${sort}&dir=${dir}">«</a>
                                                </li>
                                                <c:forEach var="i" begin="0" end="${page.totalPages-1}">
                                                    <li class="page-item ${i==page.number ? 'active' : ''}">
                                                        <a class="page-link"
                                                            href="?q=${fn:escapeXml(q)}&page=${i}&size=${page.size}&sort=${sort}&dir=${dir}">${i+1}</a>
                                                    </li>
                                                </c:forEach>
                                                <li class="page-item ${page.last ? 'disabled' : ''}">
                                                    <a class="page-link"
                                                        href="?q=${fn:escapeXml(q)}&page=${page.number+1}&size=${page.size}&sort=${sort}&dir=${dir}">»</a>
                                                </li>
                                            </ul>
                                        </nav>
                                    </c:if>
                                </div>
                            </div>
                    </main>

                    <!-- Modal: Thêm môn học -->
                    <div class="modal fade" id="modalCreate" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog modal-lg modal-dialog-centered">
                            <form class="modal-content" method="post"
                                action="${pageContext.request.contextPath}/admin/subjects">
                                <div class="modal-header">
                                    <h5 class="modal-title"><i class="bi bi-book-fill me-2"></i>Thêm môn học</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                </div>
                                <div class="modal-body">
                                    <div class="row g-3">
                                        <div class="col-sm-6">
                                            <label class="form-label">Mã môn học</label>
                                            <input name="subjectCode" class="form-control" required
                                                placeholder="VD: INT1154">
                                        </div>
                                        <div class="col-sm-6">
                                            <label class="form-label">Số tín chỉ</label>
                                            <input name="credit" type="number" min="1" max="10" class="form-control"
                                                required>
                                        </div>
                                        <div class="col-12">
                                            <label class="form-label">Tên môn học</label>
                                            <input name="subjectName" class="form-control" required
                                                placeholder="VD: Tin học cơ sở">
                                        </div>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <c:if test="${not empty _csrf}">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                                    </c:if>
                                    <button class="btn btn-primary" type="submit"><i
                                            class="bi bi-save2 me-1"></i>Lưu</button>
                                    <button class="btn btn-outline-secondary" type="button"
                                        data-bs-dismiss="modal">Hủy</button>
                                </div>
                            </form>
                        </div>
                    </div>

                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
            </body>

            </html>