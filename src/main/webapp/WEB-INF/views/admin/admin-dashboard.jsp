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
        </style>
    </head>

    <body>
        <%@ include file="../common/header.jsp" %>

            <main class="container-fluid main-wrap py-3">
                <%@ include file="_nav.jsp" %>

                    <div class="card mt-3">
                        <div class="card-body">
                            <h5 class="mb-3">Thông báo</h5>
                            <p>Đây là khu vực Thông báo. Sẽ thiết kế chi tiết sau.</p>
                        </div>
                    </div>
            </main>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>

    </html>