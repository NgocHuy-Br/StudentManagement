<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <style>
            :root {
                --brand: #b91c1c;
                --page-x: clamp(12px, 4vw, 36px);
                --tabs-inset: clamp(10px, 2vw, 24px);
            }

            /* Ensure no horizontal overflow and consistent scrollbar */
            body {
                overflow-x: hidden !important;
                overflow-y: scroll !important;
                /* Force vertical scrollbar on all pages */
                min-height: 100vh !important;
                /* Ensure minimum height */
                background: #f7f7f9 !important;
            }

            .tabs-bar {
                background: var(--brand);
                border: none;
                border-radius: 0;
                padding: .35rem 0;
                margin-left: calc(-1*var(--page-x));
                margin-right: calc(-1*var(--page-x));
                /* Ensure consistent positioning */
                position: relative;
                overflow-x: hidden;
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
                        href="${pageContext.request.contextPath}/student">
                        <i class="bi bi-speedometer2 me-1"></i> Tổng quan
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${activeTab == 'scores' ? 'active' : ''}"
                        href="${pageContext.request.contextPath}/student/scores">
                        <i class="bi bi-bar-chart me-1"></i> Kết quả học tập
                    </a>
                </li>
            </ul>
        </div>