<%@ page contentType="text/html;charset=UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <title>Chào mừng</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                padding: 40px;
            }

            .box {
                max-width: 520px;
                margin: auto;
                border: 1px solid #eee;
                padding: 24px;
                border-radius: 8px;
            }

            .role {
                color: #b30017;
                font-weight: bold;
            }

            a {
                color: #b30017;
                text-decoration: none;
            }
        </style>
    </head>

    <body>
        <div class="box">
            <h2>Chào mừng <span class="role">${roleDisplay}</span>!</h2>
            <p>Tài khoản: ${username}</p>
            <p><a href="/logout">Đăng xuất</a></p>
        </div>
    </body>

    </html>