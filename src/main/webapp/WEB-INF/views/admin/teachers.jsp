<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1">
                <title>Quản lý giáo viên</title>
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

                    .teacher-toolbar .search .form-control {
                        min-width: 260px
                    }

                    .table-teachers tbody tr:hover {
                        background: #fffaf7;
                    }

                    .sort-link {
                        text-decoration: none;
                        color: inherit
                    }

                    .sort-link .bi {
                        opacity: .5
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
                                    <div class="d-flex justify-content-between align-items-center mb-3 teacher-toolbar">
                                        <h5 class="mb-0"><i class="bi bi-people me-2"></i>Quản lý giáo viên</h5>
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

                                    <!-- Tìm kiếm -->
                                    <form method="get" class="d-flex gap-2 mb-3">
                                        <div class="search flex-grow-1">
                                            <div class="input-group">
                                                <span class="input-group-text"><i class="bi bi-search"></i></span>
                                                <input class="form-control" name="q" value="${fn:escapeXml(q)}"
                                                    placeholder="Tìm mã GV, họ tên, email, SĐT, bộ môn...">
                                            </div>
                                        </div>
                                        <button class="btn btn-outline-primary" type="submit">Tìm</button>
                                        <c:if test="${not empty q}">
                                            <a class="btn btn-outline-secondary" href="?">Xóa</a>
                                        </c:if>
                                    </form>

                                    <!-- Bảng danh sách giáo viên -->
                                    <div class="table-responsive">
                                        <table class="table table-hover align-middle table-teachers">
                                            <thead class="table-light">
                                                <tr>
                                                    <th>Mã GV
                                                        <a class="sort-link"
                                                            href="?q=${fn:escapeXml(q)}&size=${page.size}&sort=user.username&dir=${dir=='asc' && sort=='user.username' ? 'desc' : 'asc'}">
                                                            <i class="bi bi-arrow-down-up"></i>
                                                        </a>
                                                    </th>
                                                    <th>Họ
                                                        <a class="sort-link"
                                                            href="?q=${fn:escapeXml(q)}&size=${page.size}&sort=user.fname&dir=${dir=='asc' && sort=='user.fname' ? 'desc' : 'asc'}">
                                                            <i class="bi bi-arrow-down-up"></i>
                                                        </a>
                                                    </th>
                                                    <th>Tên
                                                        <a class="sort-link"
                                                            href="?q=${fn:escapeXml(q)}&size=${page.size}&sort=user.lname&dir=${dir=='asc' && sort=='user.lname' ? 'desc' : 'asc'}">
                                                            <i class="bi bi-arrow-down-up"></i>
                                                        </a>
                                                    </th>
                                                    <th>Email
                                                        <a class="sort-link"
                                                            href="?q=${fn:escapeXml(q)}&size=${page.size}&sort=user.email&dir=${dir=='asc' && sort=='user.email' ? 'desc' : 'asc'}">
                                                            <i class="bi bi-arrow-down-up"></i>
                                                        </a>
                                                    </th>
                                                    <th>SĐT
                                                        <a class="sort-link"
                                                            href="?q=${fn:escapeXml(q)}&size=${page.size}&sort=user.phone&dir=${dir=='asc' && sort=='user.phone' ? 'desc' : 'asc'}">
                                                            <i class="bi bi-arrow-down-up"></i>
                                                        </a>
                                                    </th>
                                                    <th>Bộ môn
                                                        <a class="sort-link"
                                                            href="?q=${fn:escapeXml(q)}&size=${page.size}&sort=department&dir=${dir=='asc' && sort=='department' ? 'desc' : 'asc'}">
                                                            <i class="bi bi-arrow-down-up"></i>
                                                        </a>
                                                    </th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:if test="${page.totalElements == 0}">
                                                    <tr>
                                                        <td colspan="6" class="text-center text-muted py-4">Chưa có giáo
                                                            viên nào.</td>
                                                    </tr>
                                                </c:if>

                                                <c:forEach var="t" items="${page.content}">
                                                    <tr>
                                                        <td>${t.user.username}</td>
                                                        <td>${t.user.fname}</td>
                                                        <td>
                                                            <span data-bs-toggle="tooltip" data-bs-placement="top"
                                                                data-bs-title="<c:if test='${not empty t.user.address}'>Địa chỉ: ${t.user.address}</c:if><c:if test='${not empty t.user.birthDate}'><c:if test='${not empty t.user.address}'> | </c:if>Ngày sinh: ${t.user.birthDate}</c:if>">
                                                                ${t.user.lname}
                                                                <c:if
                                                                    test="${not empty t.user.address or not empty t.user.birthDate}">
                                                                    <i class="bi bi-info-circle-fill text-muted ms-1"
                                                                        style="font-size: 0.8em;"></i>
                                                                </c:if>
                                                            </span>
                                                        </td>
                                                        <td>${t.user.email}</td>
                                                        <td>${t.user.phone}</td>
                                                        <td>${t.department}</td>
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

                    <!-- Modal: Thêm giáo viên -->
                    <div class="modal fade" id="modalCreate" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog modal-lg modal-dialog-centered">
                            <form class="modal-content" method="post"
                                action="${pageContext.request.contextPath}/admin/teachers">
                                <div class="modal-header">
                                    <h5 class="modal-title"><i class="bi bi-person-plus me-2"></i>Thêm giáo viên</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                </div>
                                <div class="modal-body">
                                    <div class="row g-3">
                                        <div class="col-sm-4">
                                            <label class="form-label">Mã GV (Username)</label>
                                            <input name="username" class="form-control" required
                                                placeholder="VD: GV001">
                                        </div>
                                        <div class="col-sm-4">
                                            <label class="form-label">Mật khẩu</label>
                                            <input name="password" type="password" class="form-control" required>
                                        </div>
                                        <div class="col-sm-4">
                                            <label class="form-label">SĐT</label>
                                            <input name="phone" class="form-control">
                                        </div>
                                        <div class="col-sm-4">
                                            <label class="form-label">Họ</label>
                                            <input name="fname" class="form-control" required>
                                        </div>
                                        <div class="col-sm-4">
                                            <label class="form-label">Tên</label>
                                            <input name="lname" class="form-control">
                                        </div>
                                        <div class="col-sm-4">
                                            <label class="form-label">Email</label>
                                            <input name="email" type="email" class="form-control" required>
                                        </div>
                                        <div class="col-12">
                                            <label class="form-label">Địa chỉ</label>
                                            <input name="address" class="form-control" placeholder="Nhập địa chỉ">
                                        </div>
                                        <div class="col-sm-6">
                                            <label class="form-label">Ngày sinh</label>
                                            <input name="birthDate" type="date" class="form-control">
                                        </div>
                                        <div class="col-sm-6">
                                            <label class="form-label">Bộ môn</label>
                                            <input name="department" class="form-control"
                                                placeholder="VD: Khoa học máy tính">
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
                    <script>
                        // Kích hoạt tooltip
                        var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
                        var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
                            return new bootstrap.Tooltip(tooltipTriggerEl, {
                                html: true
                            });
                        });
                    </script>
            </body>

            </html>