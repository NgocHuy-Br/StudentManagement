<%@ page contentType="text/html;charset=UTF-8" %>
    <!DOCTYPE html>
    <html lang="vi">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Quản trị hệ thống</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
        <style>
            :root {
                --brand: #b91c1c;
                --brand-hover: #9f1414;
                /* Lề trái/phải cho toàn trang */
                --page-x: clamp(12px, 4vw, 36px);
                /* Độ thụt chữ trong thanh tabs */
                --tabs-inset: clamp(10px, 2vw, 24px);
            }

            body {
                background: #f7f7f9;
            }

            .card {
                border-radius: 12px;
                box-shadow: 0 10px 25px rgba(0, 0, 0, .06);
            }

            .tab-pane {
                padding: 16px;
            }

            /* Phần main có lề trái/phải */
            .main-wrap {
                padding-left: var(--page-x);
                padding-right: var(--page-x);
            }

            /* Thanh tabs: nền đỏ full-bleed (kéo sát 2 lề), không bo góc */
            .tabs-bar {
                background: var(--brand);
                border: none;
                border-radius: 0;
                padding: .35rem 0;
                /* padding ngang chuyển vào nav-tabs bên trong */
                margin-left: calc(-1 * var(--page-x));
                margin-right: calc(-1 * var(--page-x));
                box-shadow: none;
            }

            /* Chỉ chữ/thẻ tab thụt vào */
            .tabs-bar .nav-tabs {
                border-bottom: none;
                padding-left: var(--tabs-inset);
                padding-right: var(--tabs-inset);
            }

            .tabs-bar .nav-link {
                font-weight: 600;
                color: #fff;
                border: none;
                border-radius: .55rem;
                margin-right: .25rem;
            }

            .tabs-bar .nav-link:hover {
                background: rgba(255, 255, 255, .12);
                color: #fff;
            }

            .tabs-bar .nav-link.active {
                background: #fff;
                color: var(--brand);
            }
        </style>
    </head>

    <body>

        <%@ include file="../common/header.jsp" %>

            <main class="container-fluid main-wrap py-3">
                <div class="tabs-bar">
                    <ul class="nav nav-tabs" id="adminTabs" role="tablist">
                        <li class="nav-item" role="presentation">
                            <a class="nav-link active" id="tab-notice-tab" data-bs-toggle="tab" href="#tab-notice"
                                role="tab">
                                <i class="bi bi-megaphone-fill me-1"></i> Thông báo
                            </a>
                        </li>
                        <li class="nav-item" role="presentation">
                            <a class="nav-link" id="tab-students-tab" data-bs-toggle="tab" href="#tab-students"
                                role="tab">
                                <i class="bi bi-mortarboard-fill me-1"></i> Sinh viên
                            </a>
                        </li>
                        <li class="nav-item" role="presentation">
                            <a class="nav-link" id="tab-teachers-tab" data-bs-toggle="tab" href="#tab-teachers"
                                role="tab">
                                <i class="bi bi-people-fill me-1"></i> Giáo viên
                            </a>
                        </li>
                    </ul>
                </div>

                <div class="card mt-3">
                    <div class="card-body">
                        <div class="tab-content" id="adminTabsContent">
                            <div class="tab-pane fade show active" id="tab-notice" role="tabpanel">
                                <h5 class="mb-3">Thông báo</h5>
                                <p>Đây là khu vực Thông báo. Sẽ thiết kế chi tiết sau.</p>
                            </div>

                            <div class="tab-pane fade" id="tab-students" role="tabpanel">
                                <h5 class="mb-3">Quản lý học sinh</h5>
                                <p>Placeholder cho chức năng quản lý học sinh.</p>
                            </div>

                            <div class="tab-pane fade" id="tab-teachers" role="tabpanel">
                                <h5 class="mb-3">Quản lý giáo viên</h5>
                                <p>Placeholder cho chức năng quản lý giáo viên.</p>
                            </div>
                        </div>
                    </div>
                </div>
            </main>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
            <script>
                (function () {
                    const selector = 'a[data-bs-toggle="tab"]';
                    const activateFromHash = () => {
                        const hash = location.hash || '#tab-notice';
                        const trigger = document.querySelector(`${selector}[href="${hash}"]`);
                        if (trigger) new bootstrap.Tab(trigger).show();
                    };
                    activateFromHash();
                    document.querySelectorAll(selector).forEach(a => {
                        a.addEventListener('shown.bs.tab', (e) => {
                            const href = e.target.getAttribute('href');
                            history.replaceState(null, '', href);
                        });
                    });
                    window.addEventListener('hashchange', activateFromHash);
                })();
            </script>
    </body>

    </html>