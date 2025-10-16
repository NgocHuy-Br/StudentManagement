<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1" />
            <title>Đăng nhập</title>

            <!-- Bootstrap 5 + Bootstrap Icons (CDN) -->
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
            <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

            <style>
                :root {
                    --brand-red: #b91c1c;
                    --brand-red-hover: #9f1414;
                    --page-bg: #f5f6f8;
                    --card-radius: 12px;
                }

                body {
                    background: var(--page-bg);
                }

                /* Header + logo responsive */
                .brand-header {
                    padding: clamp(12px, 2vw, 24px) 0;
                }

                .title-top {
                    color: var(--brand-red);
                    font-weight: 600;
                    letter-spacing: .3px;
                    font-size: clamp(1rem, 2.2vw + .4rem, 1.6rem);
                    line-height: 1.2;
                }

                .title-bottom {
                    color: #111827;
                    font-weight: 600;
                    font-size: clamp(0.9rem, 1.8vw + .3rem, 1.4rem);
                    line-height: 1.25;
                }

                .logo-img {
                    height: clamp(120px, 9vw, 180px);
                    width: auto;
                }

                /* Card login responsive */
                .login-card {
                    width: min(92vw, 440px);
                    border: 1px solid #e5e7eb;
                    border-radius: var(--card-radius);
                    box-shadow: 0 10px 25px rgba(0, 0, 0, .08);
                    overflow: hidden;
                    background: #fff;
                }

                .login-header {
                    background: var(--brand-red);
                    color: #fff;
                    padding: clamp(10px, 1.8vw, 16px) clamp(12px, 2vw, 18px);
                    display: flex;
                    align-items: center;
                    gap: 10px;
                }

                .login-header .bi {
                    font-size: clamp(1rem, 1.2vw + .6rem, 1.35rem);
                }

                .login-body {
                    padding: clamp(16px, 3vw, 24px);
                }

                .input-group-text {
                    background: #fff;
                }

                .form-control:focus {
                    box-shadow: 0 0 0 .2rem rgba(185, 28, 28, .15);
                    border-color: var(--brand-red);
                }

                .btn-login {
                    background: var(--brand-red);
                    border-color: var(--brand-red);
                }

                .btn-login:hover {
                    background: var(--brand-red-hover);
                    border-color: var(--brand-red-hover);
                }

                /* Spacing between header and card on small vs large screens */
                .main-wrap {
                    margin-top: clamp(8px, 4vh, 24px);
                    margin-bottom: clamp(8px, 4vh, 24px);
                }
            </style>
        </head>

        <body class="d-flex flex-column min-vh-100">

            <!-- Header: 2 dòng tiêu đề + logo ở giữa phía dưới -->
            <header class="container brand-header">
                <div class="text-center">
                    <div class="title-top">HỌC VIỆN CÔNG NGHỆ BƯU CHÍNH VIỄN THÔNG</div>
                    <div class="title-bottom">HỆ THỐNG QUẢN LÝ HỌC TẬP</div>
                    <div class="mt-2">
                        <img src="<c:url value='/img/ptit-logo.png'/>" class="logo-img" alt="PTIT logo">
                    </div>
                </div>
            </header>

            <!-- Card đăng nhập căn giữa, responsive -->
            <main
                class="container main-wrap flex-grow-1 d-flex align-items-start align-items-md-center justify-content-center">
                <div class="login-card">
                    <div class="login-header">
                        <i class="bi bi-person-fill"></i>
                        <strong>ĐĂNG NHẬP</strong>
                    </div>

                    <div class="login-body">
                        <!-- Include notification modal -->
                        <%@ include file="notification-modal.jsp" %>

                            <form method="post" action="<c:url value='/perform-login'/>" autocomplete="on">
                                <div class="mb-3">
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="bi bi-person"></i></span>
                                        <input type="text" class="form-control" name="username" placeholder="Tài khoản"
                                            required />
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="bi bi-lock"></i></span>
                                        <input type="password" class="form-control" id="password" name="password"
                                            placeholder="Mật khẩu" required />
                                        <button class="btn btn-outline-secondary" type="button" id="togglePassword"
                                            aria-label="Hiện/ẩn mật khẩu">
                                            <i class="bi bi-eye-slash" id="toggleIcon"></i>
                                        </button>
                                    </div>
                                </div>

                                <div class="d-flex justify-content-end mb-3">
                                    <a class="link-secondary fst-italic" style="color:#b91c1c" href="#">Quên mật
                                        khẩu</a>
                                </div>

                                <button class="btn btn-login w-100 text-white" type="submit">
                                    <i class="bi bi-box-arrow-in-right me-1"></i> Đăng nhập
                                </button>
                            </form>
                    </div>
                </div>
            </main>

            <script>
                const toggleBtn = document.getElementById('togglePassword');
                const pwd = document.getElementById('password');
                const icon = document.getElementById('toggleIcon');
                toggleBtn?.addEventListener('click', () => {
                    const show = pwd.type === 'password';
                    pwd.type = show ? 'text' : 'password';
                    icon.classList.toggle('bi-eye', show);
                    icon.classList.toggle('bi-eye-slash', !show);
                });
            </script>
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

            <script>
                // Check for login error
                document.addEventListener('DOMContentLoaded', function () {
                    const urlParams = new URLSearchParams(window.location.search);
                    if (urlParams.get('error') === 'true') {
                        showNotification('error', 'Sai tài khoản hoặc mật khẩu.', 'Đăng nhập thất bại');
                    }
                });
            </script>
        </body>

        </html>