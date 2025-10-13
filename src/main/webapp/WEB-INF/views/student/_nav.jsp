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
                border: none;
                padding: 0 var(--tabs-inset);
                margin: 0;
            }

            .tabs-bar .nav-link {
                border: none;
                color: rgba(255, 255, 255, .75);
                font-weight: 500;
                padding: .75rem 1.2rem;
                margin-right: .5rem;
                border-radius: 6px 6px 0 0;
                transition: all .2s;
                background: transparent;
            }

            .tabs-bar .nav-link:hover {
                color: white;
                background: rgba(255, 255, 255, .1);
            }

            .tabs-bar .nav-link.active {
                color: var(--brand);
                background: #f7f7f9;
                border-color: transparent;
            }

            .tabs-bar .nav-link i {
                font-size: .9rem;
                margin-right: .4rem;
            }
        </style>

        <div class="tabs-bar">
            <ul class="nav nav-tabs">
                <li class="nav-item">
                    <a class="nav-link ${activeTab == 'dashboard' ? 'active' : ''}"
                        href="${pageContext.request.contextPath}/student">
                        <i class="bi bi-speedometer2"></i>Tổng quan
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${activeTab == 'scores' ? 'active' : ''}"
                        href="${pageContext.request.contextPath}/student/scores">
                        <i class="bi bi-bar-chart"></i>Kết quả học tập
                    </a>
                </li>
            </ul>
        </div>