<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <style>
            :root {
                --brand: #b91c1c;
                --page-x: clamp(12px, 4vw, 36px);
                --tabs-inset: clamp(10px, 2vw, 24px);
            }

            .tabs-bar {
                background: var(--brand);
                border: none;
                border-radius: 0;
                padding: .35rem 0;
                margin-left: calc(-1*var(--page-x));
                margin-right: calc(-1*var(--page-x));
            }

            .tabs-bar .nav-tabs {
                border-bottom: none;
                padding-left: var(--tabs-inset);
                padding-right: var(--tabs-inset);
            }

            .tabs-bar .nav-link {
                color: #fff;
                font-weight: 600;
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
                color: #b91c1c;
            }
        </style>

        <div class="tabs-bar">
            <ul class="nav nav-tabs">
                <li class="nav-item">
                    <a class="nav-link ${activeTab == 'dashboard' ? 'active' : ''}"
                        href="${pageContext.request.contextPath}/teacher">
                        <i class="bi bi-speedometer2 me-1"></i> Tổng quan
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${activeTab == 'notifications' ? 'active' : ''}"
                        href="${pageContext.request.contextPath}/teacher/notifications">
                        <i class="bi bi-bell-fill me-1"></i> Thông báo
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${activeTab == 'classes' ? 'active' : ''}"
                        href="${pageContext.request.contextPath}/teacher/classes">
                        <i class="bi bi-people-fill me-1"></i> Lớp sinh viên
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${activeTab == 'scores' ? 'active' : ''}"
                        href="${pageContext.request.contextPath}/teacher/scores">
                        <i class="bi bi-journal-text me-1"></i> Điểm sinh viên
                    </a>
                </li>
            </ul>
        </div>