<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<jsp:include page="/includes/header.jsp" />

<div class="container" style="padding: 20px;">
    <h2>System Audit & Notification Logs</h2>
    <p>A record of all automated security alerts and sent notifications.</p>

    <table border="1" style="width: 100%; border-collapse: collapse; margin-top: 20px;">
        <tr style="background-color: #f8f9fa;">
            <th>ID</th>
            <th>Recipient</th>
            <th>Type</th>
            <th>Subject</th>
            <th>Content</th>
            <th>Date/Time</th>
        </tr>
        <c:forEach items="${notificationLogs}" var="log">
            <tr>
                <td>${log.id}</td>
                <td>${log.recipientId}</td>
                <td><strong>${log.type}</strong></td>
                <td>${log.subject}</td>
                <td>${log.content}</td>
                <td>${log.sentAt}</td>
            </tr>
        </c:forEach>
    </table>
    <br>
    <a href="${pageContext.request.contextPath}/">&larr; Back to Dashboard</a>
</div>
