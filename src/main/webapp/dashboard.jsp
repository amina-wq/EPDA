<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="model.User" %>

<%
    // SESSION BOUNCER
    if (session.getAttribute("user") == null) {
        response.sendRedirect("login.jsp?error=please_login");
        return; 
    }
%>

<jsp:include page="/includes/header.jsp" />

<div class="container" style="padding: 20px; text-align: center; min-height: 450px;">
    <% if ("sent".equals(request.getParameter("status"))) { %>
        <div style="background-color: #d4edda; color: #155724; padding: 10px; border-radius: 5px; margin-bottom: 20px; border: 1px solid #c3e6cb;">
            <strong>Success!</strong> Notification has been sent and logged.
        </div>
    <% } %>

    <h1>Staff Dashboard</h1>
    <p>Logged in as: <strong>${user.username}</strong> | Role: <strong style="color: #007bff;">${user.role}</strong></p>
    <hr style="width: 50%; margin: 20px auto;">

    <div class="menu-options" style="margin-top: 30px; display: flex; flex-direction: column; gap: 15px; align-items: center;">
        
        <c:if test="${user.role == 'ADMIN'}">
            <a href="${pageContext.request.contextPath}/users" style="display:block; width: 250px; padding: 12px; background: #007bff; color: white; text-decoration: none; border-radius: 5px; font-weight: bold;">View All Staff</a>
            <a href="register.jsp" style="display:block; width: 250px; padding: 12px; background: #17a2b8; color: white; text-decoration: none; border-radius: 5px; font-weight: bold;">Register New Staff</a>
        </c:if>

        <a href="${pageContext.request.contextPath}/user/sendNotification.jsp" style="display:block; width: 250px; padding: 12px; background: #28a745; color: white; text-decoration: none; border-radius: 5px; font-weight: bold;">Send Student Alert</a>
		
        <c:if test="${user.role == 'ADMIN'}">
            <a href="${pageContext.request.contextPath}/NotificationLogServlet" style="display: block; width: 250px; padding: 12px; background-color: #f39c12; color: white; text-decoration: none; border-radius: 5px; font-weight: bold;">View Notification Logs</a>
        </c:if>
    </div>
</div>

<%-- FIXED: Changed from header to footer --%>
<jsp:include page="/includes/footer.jsp" />