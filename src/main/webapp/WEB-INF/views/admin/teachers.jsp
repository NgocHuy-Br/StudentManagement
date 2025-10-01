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

                    /* Đảm bảo dropdown không bị che */
                    .table-responsive {
                        overflow: visible;
                    }

                    .dropdown-menu {
                        z-index: 1050;
                    }

                    .faculty-badge {
                        font-size: 0.85em;
                        padding: 0.3em 0.6em;
                    }
                </style>
            </head>

            <body>
                <%@ include file="../common/header.jsp" %>
                    <main class="container-fluid main-wrap py-3">
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

                                    <!-- Toolbar: tìm kiếm + lọc khoa + Thêm mới -->
                                    <form class="teacher-toolbar d-flex flex-wrap align-items-center gap-2 mb-3"
                                        method="get" action="">
                                        <div class="input-group search">
                                            <span class="input-group-text"><i class="bi bi-search"></i></span>
                                            <input name="q" class="form-control"
                                                placeholder="Tìm mã GV, họ tên, email, SĐT, khoa..." value="${q}" />
                                        </div>

                                        <!-- Dropdown lọc khoa -->
                                        <select name="faculty" class="form-select" style="width: 200px;"
                                            onchange="this.form.submit()">
                                            <option value="">Tất cả khoa</option>
                                            <c:forEach var="f" items="${faculties}">
                                                <option value="${f.id}" ${param.faculty==f.id ? 'selected' : '' }>
                                                    ${f.name}</option>
                                            </c:forEach>
                                        </select>

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



                                    <!-- Bảng danh sách giáo viên -->
                                    <div class="table-responsive">
                                        <table class="table table-hover align-middle table-teachers">
                                            <thead class="table-light">
                                                <tr>
                                                    <th width="60px">STT</th>
                                                    <th>Mã GV
                                                        <a class="sort-link"
                                                            href="?q=${fn:escapeXml(q)}&faculty=${fn:escapeXml(param.faculty)}&size=${page.size}&sort=user.username&dir=${dir=='asc' && sort=='user.username' ? 'desc' : 'asc'}">
                                                            <i class="bi bi-arrow-down-up"></i>
                                                        </a>
                                                    </th>
                                                    <th>Họ tên
                                                        <a class="sort-link"
                                                            href="?q=${fn:escapeXml(q)}&faculty=${fn:escapeXml(param.faculty)}&size=${page.size}&sort=user.lname&dir=${dir=='asc' && sort=='user.lname' ? 'desc' : 'asc'}">
                                                            <i class="bi bi-arrow-down-up"></i>
                                                        </a>
                                                    </th>
                                                    <th>Email
                                                        <a class="sort-link"
                                                            href="?q=${fn:escapeXml(q)}&faculty=${fn:escapeXml(param.faculty)}&size=${page.size}&sort=user.email&dir=${dir=='asc' && sort=='user.email' ? 'desc' : 'asc'}">
                                                            <i class="bi bi-arrow-down-up"></i>
                                                        </a>
                                                    </th>
                                                    <th>SĐT
                                                        <a class="sort-link"
                                                            href="?q=${fn:escapeXml(q)}&faculty=${fn:escapeXml(param.faculty)}&size=${page.size}&sort=user.phone&dir=${dir=='asc' && sort=='user.phone' ? 'desc' : 'asc'}">
                                                            <i class="bi bi-arrow-down-up"></i>
                                                        </a>
                                                    </th>
                                                    <th>Khoa
                                                        <a class="sort-link"
                                                            href="?q=${fn:escapeXml(q)}&faculty=${fn:escapeXml(param.faculty)}&size=${page.size}&sort=department&dir=${dir=='asc' && sort=='department' ? 'desc' : 'asc'}">
                                                            <i class="bi bi-arrow-down-up"></i>
                                                        </a>
                                                    </th>
                                                    <th width="180px" class="text-center">Thao tác</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:if test="${page.totalElements == 0}">
                                                    <tr>
                                                        <td colspan="6" class="text-center text-muted py-4">Chưa có giáo
                                                            viên nào.</td>
                                                    </tr>
                                                </c:if>

                                                <c:forEach var="t" items="${page.content}" varStatus="status">
                                                    <tr>
                                                        <td class="text-center fw-semibold text-muted">${status.index +
                                                            1 + (page.number * page.size)}</td>
                                                        <td>${t.user.username}</td>
                                                        <td>
                                                            <span data-bs-toggle="tooltip" data-bs-placement="top"
                                                                data-bs-title="<c:if test='${not empty t.user.address}'>Địa chỉ: ${t.user.address}</c:if><c:if test='${not empty t.user.birthDate}'><c:if test='${not empty t.user.address}'> | </c:if>Ngày sinh: ${t.user.birthDate}</c:if>">
                                                                ${t.user.fname} ${t.user.lname}
                                                                <c:if
                                                                    test="${not empty t.user.address or not empty t.user.birthDate}">
                                                                    <i class="bi bi-info-circle-fill text-muted ms-1"
                                                                        style="font-size: 0.8em;"></i>
                                                                </c:if>
                                                            </span>
                                                        </td>
                                                        <td>${t.user.email}</td>
                                                        <td>${t.user.phone}</td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${not empty t.faculty}">
                                                                    <span
                                                                        class="badge faculty-badge bg-primary">${t.faculty.name}</span>
                                                                </c:when>
                                                                <c:when test="${not empty t.department}">
                                                                    <span
                                                                        class="badge faculty-badge bg-secondary">${t.department}</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span
                                                                        class="badge faculty-badge bg-light text-muted">Chưa
                                                                        phân khoa</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <!-- Direct Action Buttons -->
                                                            <div class="d-flex gap-1 justify-content-center">
                                                                <button type="button"
                                                                    class="btn btn-sm btn-outline-info view-teacher-detail"
                                                                    data-teacher-id="${t.id}"
                                                                    data-username="${fn:escapeXml(t.user.username)}"
                                                                    data-fullname="${fn:escapeXml(t.user.fname)} ${fn:escapeXml(t.user.lname)}"
                                                                    data-email="${fn:escapeXml(t.user.email)}"
                                                                    data-phone="${fn:escapeXml(t.user.phone)}"
                                                                    data-address="${fn:escapeXml(t.user.address)}"
                                                                    data-birthdate="${fn:escapeXml(t.user.birthDate)}"
                                                                    data-nationalid="${fn:escapeXml(t.user.nationalId)}"
                                                                    data-facultyid="${t.faculty != null ? t.faculty.id : ''}"
                                                                    data-facultyname="${t.faculty != null ? fn:escapeXml(t.faculty.name) : ''}"
                                                                    data-bs-toggle="tooltip" data-bs-placement="top"
                                                                    title="Xem chi tiết">
                                                                    <i class="bi bi-eye"></i>
                                                                </button>
                                                                <button type="button"
                                                                    class="btn btn-sm btn-outline-primary edit-teacher"
                                                                    data-teacher-id="${t.id}"
                                                                    data-username="${fn:escapeXml(t.user.username)}"
                                                                    data-fullname="${fn:escapeXml(t.user.fname)} ${fn:escapeXml(t.user.lname)}"
                                                                    data-email="${fn:escapeXml(t.user.email)}"
                                                                    data-phone="${fn:escapeXml(t.user.phone)}"
                                                                    data-address="${fn:escapeXml(t.user.address)}"
                                                                    data-birthdate="${fn:escapeXml(t.user.birthDate)}"
                                                                    data-nationalid="${fn:escapeXml(t.user.nationalId)}"
                                                                    data-facultyid="${t.faculty != null ? t.faculty.id : ''}"
                                                                    data-bs-toggle="tooltip" data-bs-placement="top"
                                                                    title="Chỉnh sửa">
                                                                    <i class="bi bi-pencil-square"></i>
                                                                </button>
                                                                <button type="button"
                                                                    class="btn btn-sm btn-outline-danger delete-teacher"
                                                                    data-teacher-id="${t.id}"
                                                                    data-username="${fn:escapeXml(t.user.username)}"
                                                                    data-fullname="${fn:escapeXml(t.user.fname)} ${fn:escapeXml(t.user.lname)}"
                                                                    data-bs-toggle="tooltip" data-bs-placement="top"
                                                                    title="Xóa">
                                                                    <i class="bi bi-trash"></i>
                                                                </button>
                                                            </div>
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
                                                        href="?q=${fn:escapeXml(q)}&faculty=${fn:escapeXml(param.faculty)}&page=${page.number-1}&size=${page.size}&sort=${sort}&dir=${dir}">«</a>
                                                </li>
                                                <c:forEach var="i" begin="0" end="${page.totalPages-1}">
                                                    <li class="page-item ${i==page.number ? 'active' : ''}">
                                                        <a class="page-link"
                                                            href="?q=${fn:escapeXml(q)}&faculty=${fn:escapeXml(param.faculty)}&page=${i}&size=${page.size}&sort=${sort}&dir=${dir}">${i+1}</a>
                                                    </li>
                                                </c:forEach>
                                                <li class="page-item ${page.last ? 'disabled' : ''}">
                                                    <a class="page-link"
                                                        href="?q=${fn:escapeXml(q)}&faculty=${fn:escapeXml(param.faculty)}&page=${page.number+1}&size=${page.size}&sort=${sort}&dir=${dir}">»</a>
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
                                <div class="modal-header bg-primary text-white">
                                    <h5 class="modal-title"><i class="bi bi-person-plus me-2"></i>Thêm giáo viên</h5>
                                    <button type="button" class="btn-close btn-close-white"
                                        data-bs-dismiss="modal"></button>
                                </div>
                                <div class="modal-body">
                                    <div class="row g-3">
                                        <div class="col-sm-6">
                                            <label class="form-label">Mã GV (Username) <span
                                                    class="text-danger">*</span></label>
                                            <input name="username" class="form-control" required
                                                placeholder="VD: GV001">
                                            <div class="form-text text-muted">
                                                <i class="bi bi-info-circle me-1"></i>Mật khẩu mặc định sẽ giống với mã
                                                giáo viên
                                            </div>
                                        </div>
                                        <div class="col-sm-6">
                                            <label class="form-label">Họ Tên <span class="text-danger">*</span></label>
                                            <input name="fullName" class="form-control" required
                                                placeholder="VD: Nguyễn Văn An">
                                        </div>
                                        <div class="col-sm-6">
                                            <label class="form-label">Email <span class="text-danger">*</span></label>
                                            <input name="email" type="email" class="form-control" required>
                                        </div>
                                        <div class="col-sm-6">
                                            <label class="form-label">SĐT</label>
                                            <input name="phone" class="form-control">
                                        </div>
                                        <div class="col-sm-6">
                                            <label class="form-label">CCCD</label>
                                            <input name="nationalId" type="text" class="form-control"
                                                placeholder="Nhập 12 số" maxlength="12" pattern="[0-9]{12}">
                                        </div>
                                        <div class="col-sm-6">
                                            <label class="form-label">Ngày sinh</label>
                                            <input name="birthDate" type="date" class="form-control">
                                        </div>
                                        <div class="col-sm-6">
                                            <label class="form-label">Khoa</label>
                                            <select name="facultyId" class="form-select">
                                                <option value="">Chọn khoa...</option>
                                                <c:forEach var="f" items="${faculties}">
                                                    <option value="${f.id}">${f.name}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-12">
                                            <label class="form-label">Địa chỉ</label>
                                            <input name="address" class="form-control" placeholder="Nhập địa chỉ">
                                        </div>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <c:if test="${not empty _csrf}">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                                    </c:if>
                                    <button class="btn btn-primary" type="submit">
                                        <i class="bi bi-save2 me-1"></i>Lưu
                                    </button>
                                    <button class="btn btn-outline-secondary" type="button"
                                        data-bs-dismiss="modal">Hủy</button>
                                </div>
                            </form>
                        </div>
                    </div>

                    <!-- Teacher Detail Modal -->
                    <div class="modal fade" id="teacherDetailModal" tabindex="-1"
                        aria-labelledby="teacherDetailModalLabel" aria-hidden="true">
                        <div class="modal-dialog modal-lg">
                            <div class="modal-content">
                                <div class="modal-header bg-primary text-white">
                                    <h5 class="modal-title" id="teacherDetailModalLabel">
                                        <i class="bi bi-person-circle me-2"></i>Chi tiết giáo viên
                                    </h5>
                                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"
                                        aria-label="Close"></button>
                                </div>
                                <div class="modal-body">
                                    <div class="row g-4">
                                        <div class="col-md-6">
                                            <div class="card h-100 border-0 shadow-sm">
                                                <div class="card-header bg-light">
                                                    <h6 class="mb-0"><i class="bi bi-person-badge me-2"></i>Thông tin cơ
                                                        bản</h6>
                                                </div>
                                                <div class="card-body">
                                                    <div class="mb-3">
                                                        <label class="form-label fw-bold text-muted">Mã giáo
                                                            viên:</label>
                                                        <div class="border-bottom pb-1 text-primary fw-semibold"
                                                            id="detailTeacherUsername"></div>
                                                    </div>
                                                    <div class="mb-3">
                                                        <label class="form-label fw-bold text-muted">Họ tên:</label>
                                                        <div class="border-bottom pb-1 fs-5 fw-semibold"
                                                            id="detailTeacherFullName"></div>
                                                    </div>
                                                    <div class="mb-3">
                                                        <label class="form-label fw-bold text-muted">Ngày sinh:</label>
                                                        <div class="border-bottom pb-1" id="detailTeacherBirthDate">
                                                        </div>
                                                    </div>
                                                    <div class="mb-3">
                                                        <label class="form-label fw-bold text-muted">CCCD:</label>
                                                        <div class="border-bottom pb-1" id="detailTeacherNationalId">
                                                        </div>
                                                    </div>
                                                    <div class="mb-0">
                                                        <label class="form-label fw-bold text-muted">Khoa:</label>
                                                        <div class="border-bottom pb-1 text-success fw-semibold"
                                                            id="detailTeacherDepartment"></div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="card h-100 border-0 shadow-sm">
                                                <div class="card-header bg-light">
                                                    <h6 class="mb-0"><i class="bi bi-geo-alt me-2"></i>Thông tin liên hệ
                                                    </h6>
                                                </div>
                                                <div class="card-body">
                                                    <div class="mb-3">
                                                        <label class="form-label fw-bold text-muted">Email:</label>
                                                        <div class="border-bottom pb-1" id="detailTeacherEmail"></div>
                                                    </div>
                                                    <div class="mb-3">
                                                        <label class="form-label fw-bold text-muted">Số điện
                                                            thoại:</label>
                                                        <div class="border-bottom pb-1" id="detailTeacherPhone"></div>
                                                    </div>
                                                    <div class="mb-0">
                                                        <label class="form-label fw-bold text-muted">Địa chỉ:</label>
                                                        <div class="border-bottom pb-1" id="detailTeacherAddress"
                                                            style="min-height: 40px;"></div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary"
                                        data-bs-dismiss="modal">Đóng</button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Edit Teacher Modal -->
                    <div class="modal fade" id="editTeacherModal" tabindex="-1" aria-labelledby="editTeacherModalLabel"
                        aria-hidden="true">
                        <div class="modal-dialog modal-lg">
                            <div class="modal-content">
                                <form id="editTeacherForm" method="post">
                                    <div class="modal-header bg-warning text-dark">
                                        <h5 class="modal-title" id="editTeacherModalLabel">
                                            <i class="bi bi-pencil-square me-2"></i>Chỉnh sửa giáo viên
                                        </h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal"
                                            aria-label="Close"></button>
                                    </div>
                                    <div class="modal-body">
                                        <div class="row g-3">
                                            <div class="col-sm-6">
                                                <label class="form-label">Mã GV (Username) <span
                                                        class="text-danger">*</span></label>
                                                <input name="username" id="editUsername" class="form-control" readonly>
                                            </div>
                                            <div class="col-sm-6">
                                                <label class="form-label">Email <span
                                                        class="text-danger">*</span></label>
                                                <input name="email" id="editEmail" type="email" class="form-control"
                                                    required>
                                            </div>
                                            <div class="col-sm-6">
                                                <label class="form-label">Họ Tên <span
                                                        class="text-danger">*</span></label>
                                                <input name="fullName" id="editFullName" class="form-control" required
                                                    placeholder="VD: Nguyễn Văn An">
                                            </div>
                                            <div class="col-sm-6">
                                                <label class="form-label">SĐT</label>
                                                <input name="phone" id="editPhone" class="form-control">
                                            </div>
                                            <div class="col-sm-6">
                                                <label class="form-label">CCCD</label>
                                                <input name="nationalId" id="editNationalId" type="text"
                                                    class="form-control" maxlength="12" pattern="[0-9]{12}"
                                                    placeholder="Nhập 12 số">
                                            </div>
                                            <div class="col-sm-6">
                                                <label class="form-label">Ngày sinh</label>
                                                <input name="birthDate" id="editBirthDate" type="date"
                                                    class="form-control">
                                            </div>
                                            <div class="col-sm-6">
                                                <label class="form-label">Khoa</label>
                                                <select name="facultyId" id="editFacultyId" class="form-select">
                                                    <option value="">Chọn khoa...</option>
                                                    <c:forEach var="f" items="${faculties}">
                                                        <option value="${f.id}">${f.name}</option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                            <div class="col-12">
                                                <label class="form-label">Địa chỉ</label>
                                                <input name="address" id="editAddress" class="form-control">
                                            </div>
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <c:if test="${not empty _csrf}">
                                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                                        </c:if>
                                        <button type="button" class="btn btn-secondary"
                                            data-bs-dismiss="modal">Hủy</button>
                                        <button type="submit" class="btn btn-warning">
                                            <i class="bi bi-save me-2"></i>Cập nhật
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>

                    <!-- Delete Confirmation Modal -->
                    <div class="modal fade" id="deleteTeacherModal" tabindex="-1"
                        aria-labelledby="deleteTeacherModalLabel" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header bg-danger text-white">
                                    <h5 class="modal-title" id="deleteTeacherModalLabel">
                                        <i class="bi bi-exclamation-triangle me-2"></i>Xác nhận xóa
                                    </h5>
                                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"
                                        aria-label="Close"></button>
                                </div>
                                <div class="modal-body">
                                    <p>Bạn có chắc chắn muốn xóa giáo viên <strong id="deleteTeacherName"></strong>
                                        không?</p>
                                    <div class="alert alert-warning">
                                        <i class="bi bi-exclamation-triangle me-2"></i>
                                        Hành động này không thể hoàn tác!
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                                    <button type="button" class="btn btn-danger" id="confirmDeleteTeacher">
                                        <i class="bi bi-trash me-2"></i>Xóa
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
                    <script>
                        // Kích hoạt tooltip
                        document.addEventListener('DOMContentLoaded', function () {
                            // Initialize tooltips
                            var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
                            var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
                                return new bootstrap.Tooltip(tooltipTriggerEl);
                            });

                            console.log('DOM Content Loaded - Starting teacher page initialization...');

                            // IMMEDIATE BASIC TEST - Enable this by removing comments
                            setTimeout(function () {
                                // alert('JavaScript is working! Check console for more details.'); 
                                console.log('=== BASIC TEST ===');
                                console.log('Current URL:', window.location.href);
                                console.log('Document ready state:', document.readyState);
                                console.log('Total dropdown buttons:', document.querySelectorAll('.dropdown-toggle').length);
                                console.log('Total view elements:', document.querySelectorAll('.view-teacher-detail').length);

                                // TEST: Add simple onclick directly to ALL elements
                                const viewElements = document.querySelectorAll('.view-teacher-detail');
                                const editElements = document.querySelectorAll('.edit-teacher');
                                const deleteElements = document.querySelectorAll('.delete-teacher');

                                console.log('Adding direct onclick to all elements...');
                                console.log('Elements found:', {
                                    view: viewElements.length,
                                    edit: editElements.length,
                                    delete: deleteElements.length
                                });

                                // Add onclick to view elements
                                viewElements.forEach(function (element, index) {
                                    element.onclick = function (e) {
                                        e.preventDefault();
                                        const teacherId = this.getAttribute('data-teacher-id');
                                        const username = this.getAttribute('data-username');
                                        const fullName = this.getAttribute('data-fullname');


                                        console.log('View onclick triggered!', { teacherId, username, fullName });

                                        // Call the actual function
                                        viewTeacherDetail(teacherId, username, fullName,
                                            this.getAttribute('data-email'),
                                            this.getAttribute('data-phone'),
                                            this.getAttribute('data-address'),
                                            this.getAttribute('data-birthdate'),
                                            this.getAttribute('data-nationalid'),
                                            this.getAttribute('data-facultyname'));
                                        return false;
                                    };
                                });

                                // Add onclick to edit elements
                                editElements.forEach(function (element, index) {
                                    element.onclick = function (e) {
                                        e.preventDefault();
                                        const teacherId = this.getAttribute('data-teacher-id');
                                        const username = this.getAttribute('data-username');
                                        const fullName = this.getAttribute('data-fullname');


                                        console.log('Edit onclick triggered!', { teacherId, username, fullName });

                                        // Call the actual function
                                        editTeacher(teacherId, username, fullName,
                                            this.getAttribute('data-email'),
                                            this.getAttribute('data-phone'),
                                            this.getAttribute('data-address'),
                                            this.getAttribute('data-birthdate'),
                                            this.getAttribute('data-nationalid'),
                                            this.getAttribute('data-facultyid'));
                                        return false;
                                    };
                                });

                                // Add onclick to delete elements
                                deleteElements.forEach(function (element, index) {
                                    element.onclick = function (e) {
                                        e.preventDefault();
                                        const teacherId = this.getAttribute('data-teacher-id');
                                        const fullName = this.getAttribute('data-fullname');


                                        console.log('Delete onclick triggered!', { teacherId, fullName });

                                        // Call the actual function
                                        deleteTeacher(teacherId, fullName);
                                        return false;
                                    };
                                });

                                console.log('All onclick handlers added successfully!');
                                console.log('=== END BASIC TEST ===');
                            }, 500);

                            var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
                            var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
                                return new bootstrap.Tooltip(tooltipTriggerEl, {
                                    html: true
                                });
                            });

                            // Initialize teacher action handlers
                            console.log('About to initialize teacher actions...');
                            initTeacherActions();

                            console.log('Teacher page initialization completed.');

                            // Test if elements exist
                            setTimeout(function () {
                                const viewElements = document.querySelectorAll('.view-teacher-detail');
                                const editElements = document.querySelectorAll('.edit-teacher');
                                const deleteElements = document.querySelectorAll('.delete-teacher');

                                console.log('Elements found after initialization:', {
                                    'view elements': viewElements.length,
                                    'edit elements': editElements.length,
                                    'delete elements': deleteElements.length
                                });

                                if (viewElements.length > 0) {
                                    console.log('First view element:', viewElements[0]);
                                    console.log('First view element data:', {
                                        id: viewElements[0].getAttribute('data-teacher-id'),
                                        username: viewElements[0].getAttribute('data-username'),
                                        fullname: viewElements[0].getAttribute('data-fullname')
                                    });
                                }
                            }, 100);
                        });

                        function initTeacherActions() {
                            console.log('Initializing teacher actions...');

                            // Try direct approach without event delegation
                            setTimeout(function () {
                                console.log('Adding direct event listeners...');

                                // Direct listeners for view buttons
                                document.querySelectorAll('.view-teacher-detail').forEach(function (element, index) {
                                    console.log('Adding listener to view element', index, element);

                                    // Remove existing listeners if any
                                    element.onclick = null;

                                    element.addEventListener('click', function (e) {
                                        e.preventDefault();
                                        console.log('DIRECT: View clicked for element:', this);

                                        const teacherId = this.getAttribute('data-teacher-id');
                                        const username = this.getAttribute('data-username') || '';
                                        const fullName = this.getAttribute('data-fullname') || '';
                                        const email = this.getAttribute('data-email') || '';
                                        const phone = this.getAttribute('data-phone') || '';
                                        const address = this.getAttribute('data-address') || '';
                                        const birthDate = this.getAttribute('data-birthdate') || '';
                                        const nationalId = this.getAttribute('data-nationalid') || '';
                                        const facultyName = this.getAttribute('data-facultyname') || '';

                                        console.log('DIRECT: View teacher data:', { teacherId, username, fullName, email });
                                        viewTeacherDetail(teacherId, username, fullName, email, phone, address, birthDate, nationalId, facultyName);
                                    });
                                });

                                // Direct listeners for edit buttons
                                document.querySelectorAll('.edit-teacher').forEach(function (element, index) {
                                    console.log('Adding listener to edit element', index, element);

                                    element.onclick = null;

                                    element.addEventListener('click', function (e) {
                                        e.preventDefault();
                                        console.log('DIRECT: Edit clicked for element:', this);

                                        const teacherId = this.getAttribute('data-teacher-id');
                                        const username = this.getAttribute('data-username') || '';
                                        const fullName = this.getAttribute('data-fullname') || '';
                                        const email = this.getAttribute('data-email') || '';
                                        const phone = this.getAttribute('data-phone') || '';
                                        const address = this.getAttribute('data-address') || '';
                                        const birthDate = this.getAttribute('data-birthdate') || '';
                                        const nationalId = this.getAttribute('data-nationalid') || '';
                                        const facultyId = this.getAttribute('data-facultyid') || '';

                                        console.log('DIRECT: Edit teacher data:', { teacherId, username, fullName, email });
                                        editTeacher(teacherId, username, fullName, email, phone, address, birthDate, nationalId, facultyId);
                                    });
                                });

                                // Direct listeners for delete buttons
                                document.querySelectorAll('.delete-teacher').forEach(function (element, index) {
                                    console.log('Adding listener to delete element', index, element);

                                    element.onclick = null;

                                    element.addEventListener('click', function (e) {
                                        e.preventDefault();
                                        console.log('DIRECT: Delete clicked for element:', this);

                                        const teacherId = this.getAttribute('data-teacher-id');
                                        const fullName = this.getAttribute('data-fullname') || '';

                                        console.log('DIRECT: Delete teacher data:', { teacherId, fullName });
                                        deleteTeacher(teacherId, fullName);
                                    });
                                });
                            }, 200);

                            console.log('Teacher actions initialized successfully!');
                            console.log('Found elements:', {
                                view: document.querySelectorAll('.view-teacher-detail').length,
                                edit: document.querySelectorAll('.edit-teacher').length,
                                delete: document.querySelectorAll('.delete-teacher').length
                            });
                        }

                        // Function to view teacher detail
                        function viewTeacherDetail(id, username, fullName, email, phone, address, birthDate, nationalId, facultyName) {
                            try {
                                console.log('viewTeacherDetail called', { id, username, fullName });

                                document.getElementById('detailTeacherUsername').innerText = username || 'Chưa có thông tin';
                                document.getElementById('detailTeacherFullName').innerText = fullName || 'Chưa có thông tin';
                                document.getElementById('detailTeacherEmail').innerText = email || 'Chưa có thông tin';
                                document.getElementById('detailTeacherPhone').innerText = phone || 'Chưa có thông tin';
                                document.getElementById('detailTeacherAddress').innerText = address || 'Chưa có thông tin';
                                document.getElementById('detailTeacherBirthDate').innerText = birthDate || 'Chưa có thông tin';
                                document.getElementById('detailTeacherNationalId').innerText = nationalId || 'Chưa có thông tin';

                                const facultyText = facultyName || 'Chưa phân khoa';
                                document.getElementById('detailTeacherDepartment').innerText = facultyText;

                                // Show modal
                                const modalElement = document.getElementById('teacherDetailModal');
                                if (modalElement) {
                                    const modal = new bootstrap.Modal(modalElement);
                                    modal.show();
                                } else {
                                    alert('Không tìm thấy modal xem chi tiết');
                                }
                            } catch (error) {
                                console.error('Error in viewTeacherDetail:', error);
                                alert('Có lỗi xảy ra khi hiển thị thông tin giáo viên: ' + error.message);
                            }
                        }

                        // Function to edit teacher
                        function editTeacher(id, username, fullName, email, phone, address, birthDate, nationalId, facultyId) {
                            try {
                                console.log('editTeacher called', { id, username, fullName });

                                document.getElementById('editUsername').value = username || '';
                                document.getElementById('editEmail').value = email || '';
                                document.getElementById('editFullName').value = fullName || '';
                                document.getElementById('editPhone').value = phone || '';
                                document.getElementById('editAddress').value = address || '';
                                document.getElementById('editBirthDate').value = birthDate || '';
                                document.getElementById('editNationalId').value = nationalId || '';

                                // Set faculty dropdown
                                const facultySelect = document.getElementById('editFacultyId');
                                if (facultySelect) {
                                    facultySelect.value = facultyId || '';
                                }

                                // Set form action
                                const form = document.getElementById('editTeacherForm');
                                form.action = '${pageContext.request.contextPath}/admin/teachers/' + id + '/edit';

                                // Show modal
                                const modalElement = document.getElementById('editTeacherModal');
                                if (modalElement) {
                                    const modal = new bootstrap.Modal(modalElement);
                                    modal.show();
                                } else {
                                    alert('Không tìm thấy modal chỉnh sửa');
                                }
                            } catch (error) {
                                console.error('Error in editTeacher:', error);
                                alert('Có lỗi xảy ra khi mở form chỉnh sửa: ' + error.message);
                            }
                        }

                        // Function to delete teacher
                        function deleteTeacher(id, fullName) {
                            try {
                                console.log('deleteTeacher called', { id, fullName });

                                document.getElementById('deleteTeacherName').innerText = fullName;

                                // Set up confirm button
                                const confirmBtn = document.getElementById('confirmDeleteTeacher');
                                confirmBtn.onclick = function () {
                                    // Check if teacher is homeroom teacher first
                                    fetch('${pageContext.request.contextPath}/admin/teachers/' + id + '/can-delete', {
                                        method: 'GET',
                                        headers: {
                                            'X-Requested-With': 'XMLHttpRequest'
                                        }
                                    })
                                        .then(response => response.json())
                                        .then(data => {
                                            if (data.canDelete) {
                                                // Actually delete the teacher
                                                const form = document.createElement('form');
                                                form.method = 'POST';
                                                form.action = '${pageContext.request.contextPath}/admin/teachers/' + id + '/delete';

                                                const csrfToken = document.querySelector('input[name="${_csrf.parameterName}"]');
                                                if (csrfToken) {
                                                    const csrfInput = document.createElement('input');
                                                    csrfInput.type = 'hidden';
                                                    csrfInput.name = csrfToken.name;
                                                    csrfInput.value = csrfToken.value;
                                                    form.appendChild(csrfInput);
                                                }

                                                document.body.appendChild(form);
                                                form.submit();
                                            } else {
                                                alert('Không thể xóa giáo viên này vì đang là chủ nhiệm của một lớp học!');
                                                const modalInstance = bootstrap.Modal.getInstance(document.getElementById('deleteTeacherModal'));
                                                if (modalInstance) {
                                                    modalInstance.hide();
                                                }
                                            }
                                        })
                                        .catch(error => {
                                            console.error('Error:', error);
                                            alert('Có lỗi xảy ra khi kiểm tra giáo viên!');
                                        });
                                };

                                // Show modal
                                const modalElement = document.getElementById('deleteTeacherModal');
                                if (modalElement) {
                                    const modal = new bootstrap.Modal(modalElement);
                                    modal.show();
                                } else {
                                    alert('Không tìm thấy modal xóa');
                                }
                            } catch (error) {
                                console.error('Error in deleteTeacher:', error);
                                alert('Có lỗi xảy ra khi mở dialog xác nhận xóa: ' + error.message);
                            }
                        }

                        // Auto-format CCCD input (only allow numbers)
                        function setupCCCDFormatting() {
                            const cccdInputs = document.querySelectorAll('input[name="nationalId"]');

                            cccdInputs.forEach(input => {
                                input.addEventListener('input', function (e) {
                                    // Remove all non-numeric characters
                                    let value = e.target.value.replace(/[^0-9]/g, '');

                                    // Limit to 12 digits
                                    if (value.length > 12) {
                                        value = value.substring(0, 12);
                                    }

                                    // Update the input value
                                    e.target.value = value;
                                });

                                input.addEventListener('paste', function (e) {
                                    // Handle paste event
                                    setTimeout(() => {
                                        let value = e.target.value.replace(/[^0-9]/g, '');
                                        if (value.length > 12) {
                                            value = value.substring(0, 12);
                                        }
                                        e.target.value = value;
                                    }, 10);
                                });
                            });
                        }

                        // Setup CCCD formatting when page loads
                        setupCCCDFormatting();


                    </script>
            </body>

            </html>