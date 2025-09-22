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
                body {
                    background: #f5f6f8;
                }

                .login-card {
                    max-width: 380px;
                    width: 100%;
                    border: 1px solid #e5e7eb;
                    border-radius: 12px;
                    box-shadow: 0 10px 25px rgba(0, 0, 0, .08);
                    overflow: hidden;
                }

                .login-header {
                    background: #b91c1c;
                    color: #fff;
                    padding: 14px 18px;
                    display: flex;
                    align-items: center;
                    gap: 10px;
                }

                .login-header .bi {
                    font-size: 1.25rem;
                }

                .login-body {
                    padding: 20px;
                }

                .input-group-text {
                    background: #fff;
                }

                .form-control:focus {
                    box-shadow: 0 0 0 .2rem rgba(185, 28, 28, .15);
                    border-color: #b91c1c;
                }

                .link-forgot {
                    color: #b91c1c;
                    font-style: italic;
                    text-decoration: none;
                }

                .link-forgot:hover {
                    text-decoration: underline;
                }

                .btn-login {
                    background: #b91c1c;
                    border-color: #b91c1c;
                }

                .btn-login:hover {
                    background: #9f1414;
                    border-color: #9f1414;
                }
            </style>
        </head>

        <body>
            <div class="container min-vh-100 d-flex align-items-center justify-content-center">
                <div class="login-card bg-white">
                    <div class="login-header">
                        <i class="bi bi-person-fill"></i>
                        <strong>ĐĂNG NHẬP</strong>
                    </div>

                    <div class="login-body">
                        <c:if test="${param.error == 'true'}">
                            <div class="alert alert-danger py-2 mb-3">Sai tài khoản hoặc mật khẩu.</div>
                        </c:if>
                        <c:if test="${param.logout == 'true'}">
                            <div class="alert alert-success py-2 mb-3">Đã đăng xuất.</div>
                        </c:if>

                        <form method="post" action="/auth/perform-login" autocomplete="on">
                            <div class="mb-3">
                                <div class="input-group">
                                    <span class="input-group-text"><i class="bi bi-person"></i></span>
                                    <input type="text" class="form-control" name="username" placeholder="Tài khoản"
                                        required />
                                </div>
                            </div>

                            <div class="mb-1">
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
                                <a class="link-forgot" href="#">Quên mật khẩu</a>
                            </div>

                            <button class="btn btn-login w-100 text-white" type="submit">
                                <i class="bi bi-box-arrow-in-right me-1"></i> Đăng nhập
                            </button>
                        </form>
                    </div>
                </div>
            </div>

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
        </body>

        </html>