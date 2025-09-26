<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

        <!-- Navigation cho Teacher -->
        <nav class="navbar navbar-expand-lg navbar-light bg-white rounded shadow-sm">
            <div class="container-fluid px-3">
                <div class="navbar-nav nav-pills">
                    <a class="nav-link ${activeTab == 'dashboard' ? 'active' : ''}"
                        href="${pageContext.request.contextPath}/teacher">
                        <i class="bi bi-speedometer2 me-1"></i>Bảng điều khiển
                    </a>
                    <a class="nav-link ${activeTab == 'subjects' ? 'active' : ''}"
                        href="${pageContext.request.contextPath}/teacher/subjects">
                        <i class="bi bi-book me-1"></i>Môn học phụ trách
                    </a>
                </div>

                <div class="navbar-nav">
                    <span class="navbar-text small">
                        <i class="bi bi-person-circle me-1"></i>
                        Xin chào, <strong>${firstName}</strong>
                    </span>
                </div>
            </div>
        </nav>