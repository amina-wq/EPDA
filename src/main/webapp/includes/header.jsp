<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="navbar">
    <a href="${pageContext.request.contextPath}/dashboard.jsp" class="${pageContext.request.servletPath == '/dashboard.jsp' ? 'active' : ''}">Dashboard</a>
    <a href="${pageContext.request.contextPath}/check_eligibility" class="${pageContext.request.servletPath == '/check_eligibility' ? 'active' : ''}">Eligibility Check</a>
    <a href="${pageContext.request.contextPath}/reports" class="${pageContext.request.servletPath == '/reports' ? 'active' : ''}">Reports</a>
    <a href="${pageContext.request.contextPath}/users" class="${pageContext.request.servletPath == '/users' ? 'active' : ''}">User Management</a>
    
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
                <a href="${pageContext.request.contextPath}/user/login.jsp">Login</a>
            </c:otherwise>
        </c:choose>
    </div>
</div>
<div class="container">