<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="model.User" %>

<jsp:include page="/includes/header.jsp" />

<div class="notification-container" style="max-width: 600px; margin: 40px auto; padding: 20px; border: 1px solid #ccc; border-radius: 8px;">
    <h2>Send Email Notification</h2>
    <p>Use this form to send official alerts or academic updates to students.</p>
    
    <c:if test="${param.status == 'success'}">
        <div style="color: white; background-color: #28a745; padding: 10px; margin-bottom: 15px; border-radius: 4px;">
            <strong>Success!</strong> The academic notification has been logged and sent.
        </div>
    </c:if>

    <c:if test="${param.status == 'error'}">
        <div style="color: white; background-color: #dc3545; padding: 10px; margin-bottom: 15px; border-radius: 4px;">
            <strong>Error:</strong> 
			The recipient is not a registered student in our records.
        </div>
    </c:if>

    <form action="${pageContext.request.contextPath}/sendNotification" method="POST">

<div style="margin-bottom: 15px;">
    <label>Recipient Email or Student ID:</label>
    <input type="text" name="recipientId" required style="width: 100%; padding: 8px;">
</div>

<div style="margin-bottom: 15px;">
    <label>Notification Type:</label>
    <select name="type" style="width: 100%; padding: 8px;">
        <option value="ACCOUNT_ALERT">Account Alert</option>
        <option value="RECOVERY_PLAN">Recovery Plan Update</option>
    </select>
</div>

<div style="margin-bottom: 15px;">
    <label>Subject:</label>
    <input type="text" name="subject" required style="width: 100%; padding: 8px;">
</div>

<div style="margin-bottom: 15px;">
    <label>Message Content:</label>
    <textarea name="content" required style="width: 100%; padding: 8px; height: 100px;"></textarea>
</div>

<button type="submit" style="width: 100%; padding: 12px; background-color: #28a745; color: white; border: none; border-radius: 4px; cursor: pointer; font-weight: bold;">
        Send Message
    </button>
</form>
        
        <div style="margin-top: 20px; text-align: center;">
        <a href="${pageContext.request.contextPath}/" style="color: #007bff; text-decoration: none;">&larr; Back to Dashboard</a>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />
