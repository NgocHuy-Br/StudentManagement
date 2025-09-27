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
                    <a class="nav-link ${activeTab == 'notice' ? 'active' : ''}"
                        href="${pageContext.request.contextPath}/admin">
                        <i class="bi bi-megaphone-fill me-1"></i> Thông báo
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${activeTab == 'students' ? 'active' : ''}"
                        href="${pageContext.request.contextPath}/admin/students">
                        <i class="bi bi-mortarboard-fill me-1"></i> Sinh viên
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${activeTab == 'teachers' ? 'active' : ''}"
                        href="${pageContext.request.contextPath}/admin/teachers">
                        <i class="bi bi-people-fill me-1"></i> Giáo viên
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${activeTab == 'subjects' ? 'active' : ''}"
                        href="${pageContext.request.contextPath}/admin/subjects">
                        <i class="bi bi-book me-1"></i> Môn học
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${activeTab == 'majors' ? 'active' : ''}"
                        href="${pageContext.request.contextPath}/admin/majors">
                        <i class="bi bi-mortarboard-fill me-1"></i> Ngành học
                    </a>
                </li>
            </ul>
        </div>