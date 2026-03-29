<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<jsp:include page="/includes/header.jsp" />
<div class="container">
    <h1>Dashboard</h1>
    <p>
        Welcome to Course Recovery System, <strong>${sessionScope.user.username}</strong>!
    </p>
    <div class="stats-container">
        <div class="stat-card">
            <div class="stat-value">${totalStudents}</div>
            <div class="stat-label">Total Students</div>
        </div>
        <div class="stat-card warning">
            <div class="stat-value">${ineligibleCount}</div>
            <div class="stat-label">Not Eligible</div>
        </div>
        <div class="stat-card">
            <div class="stat-value">${activePlans}</div>
            <div class="stat-label">Active Recovery Plans</div>
        </div>
        <div class="stat-card">
            <div class="stat-value">${completedPlans}</div>
            <div class="stat-label">Completed Plans</div>
        </div>
    </div>
    <h2>System Modules</h2>
    <div class="dashboard-grid">
        <a href="${pageContext.request.contextPath}/students" class="dashboard-card">
            <div class="card-icon">👥</div>
            <h3>All Students</h3>
            <p>View and manage student records</p>
            <div class="card-footer">
                <span class="badge badge-info">${totalStudents} students</span>
            </div>
        </a>
        <a href="${pageContext.request.contextPath}/check_eligibility" class="dashboard-card">
            <div class="card-icon">✅</div>
            <h3>Eligibility Check</h3>
            <p>Check student progression eligibility</p>
            <div class="card-footer">
                <c:choose>
                    <c:when test="${ineligibleCount > 0}">
                        <span class="badge badge-warning">${ineligibleCount} not
                        eligible</span>
                    </c:when>
                    <c:otherwise>
                        <span class="badge badge-success">All eligible</span>
                    </c:otherwise>
                </c:choose>
            </div>
        </a>
        <a href="${pageContext.request.contextPath}/recovery_plans" class="dashboard-card">
            <div class="card-icon">📋</div>
            <h3>Recovery Plans</h3>
            <p>Manage course recovery plans</p>
            <div class="card-footer">
                <span class="badge badge-warning">${activePlans} active</span> <span
                    class="badge badge-success">${completedPlans} completed</span>
            </div>
        </a>
        <a href="${pageContext.request.contextPath}/reports" class="dashboard-card">
            <div class="card-icon">📊</div>
            <h3>Academic Reports</h3>
            <p>Generate performance reports</p>
            <div class="card-footer">
                <span class="badge badge-info">By semester & program</span>
            </div>
        </a>
        <c:if test="${sessionScope.userRole == 'ADMIN'}">
            <a href="${pageContext.request.contextPath}/users" class="dashboard-card">
                <div class="card-icon">👤</div>
                <h3>User Management</h3>
                <p>Manage system users and roles</p>
                <div class="card-footer">
                    <span class="badge badge-info">Administrators & Officers</span>
                </div>
            </a>
        </c:if>
        <c:if test="${sessionScope.userRole == 'ADMIN'}">
            <a href="${pageContext.request.contextPath}/register" class="dashboard-card">
                <div class="card-icon">➕</div>
                <h3>Create New User</h3>
                <p>Add a new administrator or academic officer</p>
                <div class="card-footer">
                    <span class="badge badge-success">New user</span>
                </div>
            </a>
        </c:if>
        <a href="${pageContext.request.contextPath}/sendNotification" class="dashboard-card">
           <div class="card-icon">📧</div>
           <h3>Send Notifications</h3>
           <p>Send official alerts or academic updates to students</p>
           <div class="card-footer">
               <span class="badge badge-info">Fill form</span>
           </div>
       </a>
        <c:if test="${sessionScope.userRole == 'ADMIN'}">
	        <a href="${pageContext.request.contextPath}/notifications" class="dashboard-card">
	            <div class="card-icon">📧</div>
	            <h3>Notifications</h3>
	            <p>View and manage email notifications</p>
	            <div class="card-footer">
	                <span class="badge badge-info">${pendingNotifications}
	                pending</span>
	            </div>
	        </a>
        </c:if>
    </div>
</div>
<jsp:include page="/includes/footer.jsp" />