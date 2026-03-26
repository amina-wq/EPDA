<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="navbar">
    <c:set var="currentUri" value="${pageContext.request.requestURI}" />
    
    <a href="${pageContext.request.contextPath}/" 
       class="${currentUri == pageContext.request.contextPath || currentUri == pageContext.request.contextPath.concat('/') ? 'active' : ''}">
       Dashboard
    </a>
    
    <a href="${pageContext.request.contextPath}/students"
       class="${currentUri == pageContext.request.contextPath || currentUri == pageContext.request.contextPath.concat('/students') ? 'active' : ''}">
       All Students
    </a>
    
    <a href="${pageContext.request.contextPath}/check_eligibility" 
       class="${currentUri.contains('/check_eligibility') ? 'active' : ''}">
       Eligibility Check
    </a>
    
     <a href="${pageContext.request.contextPath}/recovery_plans" 
       class="${currentUri.contains('/recovery_plans') ? 'active' : ''}">
       Recovery Plans
    </a>
    
    <a href="${pageContext.request.contextPath}/reports" 
       class="${currentUri.contains('/reports') ? 'active' : ''}">
       Reports
    </a>
    
    <c:if test="${sessionScope.userRole == 'ADMIN'}">
	   <a href="${pageContext.request.contextPath}/users" 
	      class="${currentUri.contains('/users') ? 'active' : ''}">
	      User Management
	   </a>
    </c:if>
    
    <c:if test="${sessionScope.userRole == 'ADMIN'}">
	    <a href="${pageContext.request.contextPath}/notifications" 
	       class="${currentUri.contains('/notifications') ? 'active' : ''}">
	       Notifications
	    </a>
    </c:if>
    
    <div class="navbar-right">
        <c:choose>
            <c:when test="${not empty sessionScope.user}">
                <span class="user-info">
                    Welcome, ${sessionScope.user.username} (${sessionScope.user.role})
                    <form action="${pageContext.request.contextPath}/logout" method="post" style="display: inline;">
                        <button type="submit" class="logout-btn">Logout</button>
                    </form>
                </span>
            </c:when>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/login">Login</a>
            </c:otherwise>
        </c:choose>
    </div>
</div>
<div class="container">