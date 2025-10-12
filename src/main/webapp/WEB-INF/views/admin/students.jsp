<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1">
                <title>Quản lý sinh viên</title>
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

                    .card {
                        border-radius: 12px;
                        box-shadow: 0 10px 25px rgba(0, 0, 0, .06)
                    }

                    .student-toolbar .search .form-control {
                        min-width: 260px
                    }

                    .table-students tbody tr:hover {
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
                <div class="container-fluid" style="padding: 0 clamp(12px, 4vw, 36px);">
                    <%@ include file="../common/header.jsp" %>

                        <c:set var="activeTab" value="students" scope="request" />
                        <%@ include file="_nav.jsp" %>

                            <div class="card mt-3">
                                <div class="card-body">
                                    <!-- Flash messages -->
                                    <c:if test="${not empty success}">
                                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                                            ${success}
                                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                        </div>
                                    </c:if>
                                    <c:if test="${not empty error}">
                                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                            ${error}
                                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                        </div>
                                    </c:if>

                                    <!-- Toolbar: tìm kiếm + page-size + Thêm mới -->
                                    <form class="student-toolbar d-flex flex-wrap align-items-center gap-2 mb-3"
                                        method="get" action="">
                                        <div class="input-group search">
                                            <span class="input-group-text"><i class="bi bi-search"></i></span>
                                            <input name="q" class="form-control"
                                                placeholder="Tìm MSSV, họ tên, email, SĐT, lớp, khoa..." value="${q}" />
                                        </div>

                                        <div class="ms-auto"></div>

                                        <label class="me-1 text-muted small">Hiển thị</label>
                                        <select class="form-select" name="size" style="width:100px"
                                            onchange="this.form.submit()">
                                            <option value="10" ${param.size=='10' ?'selected':''}>10</option>
                                            <option value="20" ${param.size=='20' ?'selected':''}>20</option>
                                            <option value="50" ${param.size=='50' ?'selected':''}>50</option>
                                            <option value="100" ${param.size=='100' ?'selected':''}>100</option>
                                        </select>
                                        <input type="hidden" name="sort" value="${sort}">
                                        <input type="hidden" name="dir" value="${dir}">

                                        <button type="button" class="btn btn-primary ms-auto" data-bs-toggle="modal"
                                            data-bs-target="#modalCreate">
                                            <i class="bi bi-plus-lg me-1"></i> Thêm mới
                                        </button>
                                    </form>

                                    <!-- Bảng danh sách: Page<Student>, truy cập field user qua s.user -->
                                    <div class="table-responsive">
                                        <table class="table table-hover align-middle table-students">
                                            <thead class="table-light">
                                                <tr>
                                                    <th>MSSV
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
                                                    <th>CCCD
                                                        <a class="sort-link"
                                                            href="?q=${fn:escapeXml(q)}&size=${page.size}&sort=user.nationalId&dir=${dir=='asc' && sort=='user.nationalId' ? 'desc' : 'asc'}">
                                                            <i class="bi bi-arrow-down-up"></i>
                                                        </a>
                                                    </th>
                                                    <th>Ngày sinh
                                                        <a class="sort-link"
                                                            href="?q=${fn:escapeXml(q)}&size=${page.size}&sort=user.birthDate&dir=${dir=='asc' && sort=='user.birthDate' ? 'desc' : 'asc'}">
                                                            <i class="bi bi-arrow-down-up"></i>
                                                        </a>
                                                    </th>
                                                    <th>Lớp
                                                        <a class="sort-link"
                                                            href="?q=${fn:escapeXml(q)}&size=${page.size}&sort=className&dir=${dir=='asc' && sort=='className' ? 'desc' : 'asc'}">
                                                            <i class="bi bi-arrow-down-up"></i>
                                                        </a>
                                                    </th>
                                                    <th>Ngành
                                                        <a class="sort-link"
                                                            href="?q=${fn:escapeXml(q)}&size=${page.size}&sort=major.majorName&dir=${dir=='asc' && sort=='major.majorName' ? 'desc' : 'asc'}">
                                                            <i class="bi bi-arrow-down-up"></i>
                                                        </a>
                                                    </th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:if test="${page.totalElements == 0}">
                                                    <tr>
                                                        <td colspan="8" class="text-center text-muted py-4">Chưa có sinh
                                                            viên nào.</td>
                                                    </tr>
                                                </c:if>

                                                <c:forEach var="s" items="${page.content}">
                                                    <tr>
                                                        <td>${s.user.username}</td>
                                                        <td>${s.user.fname}</td>
                                                        <td>
                                                            <span data-bs-toggle="tooltip" data-bs-placement="top"
                                                                data-bs-title="<c:if test='${not empty s.user.address}'>Địa chỉ: ${s.user.address}</c:if><c:if test='${not empty s.user.birthDate}'><c:if test='${not empty s.user.address}'> | </c:if>Ngày sinh: ${s.user.birthDate}</c:if>">
                                                                ${s.user.lname}
                                                                <c:if
                                                                    test="${not empty s.user.address or not empty s.user.birthDate}">
                                                                    <i class="bi bi-info-circle-fill text-muted ms-1"
                                                                        style="font-size: 0.8em;"></i>
                                                                </c:if>
                                                            </span>
                                                        </td>
                                                        <td>${s.user.email}</td>
                                                        <td>${s.user.phone}</td>
                                                        <td>
                                                            <c:if test="${not empty s.user.nationalId}">
                                                                ${s.user.nationalId}
                                                            </c:if>
                                                            <c:if test="${empty s.user.nationalId}">
                                                                <span class="text-muted">-</span>
                                                            </c:if>
                                                        </td>
                                                        <td>
                                                            <c:if test="${not empty s.user.birthDate}">
                                                                ${s.user.birthDate}
                                                            </c:if>
                                                            <c:if test="${empty s.user.birthDate}">
                                                                <span class="text-muted">-</span>
                                                            </c:if>
                                                        </td>
                                                        <td>${s.className}</td>
                                                        <td>${s.major.majorName}</td>
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
                </div>
                </div>

                <!-- Modal: Thêm sinh viên (có Lớp, Khoa) -->
                <div class="modal fade" id="modalCreate" tabindex="-1" aria-hidden="true">
                    <div class="modal-dialog modal-lg modal-dialog-centered">
                        <form class="modal-content" method="post"
                            action="${pageContext.request.contextPath}/admin/students">
                            <div class="modal-header">
                                <h5 class="modal-title"><i class="bi bi-person-plus me-2"></i>Thêm sinh viên</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                            </div>
                            <div class="modal-body">
                                <div class="row g-3">
                                    <div class="col-sm-4">
                                        <label class="form-label">MSSV (Username)</label>
                                        <input name="username" class="form-control" required>
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
                                    <div class="col-sm-4">
                                        <label class="form-label">CCCD</label>
                                        <input name="nationalId" type="text" class="form-control"
                                            placeholder="12 chữ số" maxlength="12" pattern="[0-9]{12}">
                                    </div>
                                    <div class="col-12">
                                        <label class="form-label">Địa chỉ</label>
                                        <input name="address" class="form-control" placeholder="Nhập địa chỉ">
                                    </div>
                                    <div class="col-sm-4">
                                        <label class="form-label">Ngày sinh</label>
                                        <input name="birthDate" type="date" class="form-control">
                                    </div>
                                    <div class="col-sm-4">
                                        <label class="form-label">Lớp</label>
                                        <input name="className" class="form-control" placeholder="VD: D20CQCN01-N">
                                    </div>
                                    <div class="col-sm-4">
                                        <label class="form-label">Ngành học</label>
                                        <select name="majorId" class="form-select" required>
                                            <option value="">-- Chọn ngành --</option>
                                            <c:forEach var="major" items="${majors}">
                                                <option value="${major.id}">${major.majorCode} - ${major.majorName}
                                                </option>
                                            </c:forEach>
                                        </select>
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