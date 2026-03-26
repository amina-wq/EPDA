<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="model.User" %>

<%
    /* AUTHENTICATION CHECK:
       This page is restricted to authenticated staff members. If no user session 
       is found, the visitor is redirected to the login page.
    */
    if (session.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=please_login");
        return; 
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Send Email Notification</title>
</head>
<body>

    <%-- Include shared layout components --%>
    <jsp:include page="../includes/header.jsp" />

    <div class="notification-container" style="max-width: 600px; margin: 40px auto; padding: 20px; border: 1px solid #ccc; border-radius: 8px;">
        <h2>Send Email Notification</h2>
        <p>Use this form to send official alerts or academic updates to students.</p>
        
        <%-- SUCCESS FEEDBACK: Displays when the notification is successfully logged --%>
        <c:if test="${param.status == 'success'}">
            <div style="color: white; background-color: #28a745; padding: 10px; margin-bottom: 15px; border-radius: 4px;">
                <strong>Success!</strong> The academic notification has been logged and sent.
            </div>
        </c:if>

        <%-- ERROR FEEDBACK: Displays different messages based on the failure type --%>
        <c:if test="${param.status == 'error'}">
            <div style="color: white; background-color: #dc3545; padding: 10px; margin-bottom: 15px; border-radius: 4px;">
                <strong>Error:</strong> 
                <c:choose>
                    <c:when test="${param.message == 'InvalidStudent'}">
                        The recipient is not a registered student in our records.
                    </c:when>
                    <c:otherwise>
                        A system error occurred. Please check the server logs.
                    </c:otherwise>
                </c:choose>
            </div>
        </c:if>

        <%-- 
             NOTIFICATION FORM:
             Submits data to the SendNotificationServlet, which coordinates 
             between the UserBean (validation) and NotificationBean (persistence).
        --%>
        <form action="${pageContext.request.contextPath}/sendNotification" method="POST">
    
    <div style="margin-bottom: 15px;">
        <label>Recipient Email or Student ID:</label>
        <%-- Make sure the name is "recipientId" to match your Servlet --%>
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
            <a href="${pageContext.request.contextPath}/dashboard.jsp" style="color: #007bff; text-decoration: none;">&larr; Back to Dashboard</a>
        </div>
    </div>

    <jsp:include page="../includes/footer.jsp" />

</body>
</html>