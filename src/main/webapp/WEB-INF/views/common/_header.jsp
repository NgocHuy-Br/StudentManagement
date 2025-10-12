<%@ page contentType="text/html;charset=UTF-8" %>
    <style>
        :root {
            --brand: #b91c1c;
            --brand-hover: #9f1414;
            /* khoảng thụt lề bên phải cho cụm tài khoản */
            --header-x: clamp(16px, 4vw, 48px);
        }

        /* Header trong suốt, không nền, không viền */
        .global-header {
            background: transparent;
            color: #111;
            border: 0;
            box-shadow: none;
        }

        .header-grid {
            display: grid;
            grid-template-columns: 1fr auto 1fr;
            /* trái | giữa | phải */
            align-items: center;
            gap: 12px;
            padding: .6rem 0;
            /* giữ full-bleed */
        }

        .app-title {
            font-weight: 800;
            letter-spacing: .3px;
            text-align: center;
            font-size: clamp(1rem, 1vw + .6rem, 1.4rem);
            color: #111;
        }

        .user-box {
            text-align: right;
            padding-right: var(--header-x);
            /* thụt vào bên phải */
        }

        .user-box .hello {
            font-weight: 600;
        }

        .btn-logout {
            padding: .25rem .6rem;
            background: var(--brand);
            color: #fff;
            border-color: var(--brand);
        }

        .btn-logout:hover {
            background: var(--brand-hover);
            border-color: var(--brand-hover);
            color: #fff;
        }
    </style>

    <header class="global-header">
        <div class="container-fluid header-grid px-0">
            <!-- Trống để tiêu đề luôn ở giữa -->
            <div></div>

            <!-- Tiêu đề giữa -->
            <div class="app-title">HỆ THỐNG QUẢN LÝ HỌC TẬP</div>

            <!-- Thông tin tài khoản bên phải (đã thụt vào) -->
            <div class="user-box">
                <div class="hello">Xin chào, <strong>${firstName}</strong></div>
                <div class="small">Tài khoản ${roleDisplay}</div>
                <a class="btn btn-sm btn-logout mt-1" href="/logout">
                    <i class="bi bi-box-arrow-right me-1"></i> Đăng xuất
                </a>
            </div>
        </div>
    </header>