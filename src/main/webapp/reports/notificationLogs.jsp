<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Notification Logs</title>
</head>
<body style="background-color: #f4f7f6; font-family: Arial, sans-serif; padding: 20px;">
    <%-- Note: ../ because this file is inside the 'reports' folder --%>
    <jsp:include page="../includes/header.jsp" />
    
    <div style="max-width: 900px; margin: 30px auto; background: white; padding: 20px; border-radius: 8px;">
        <h2>System Notification Logs</h2>
        <table border="1" style="width: 100%; border-collapse: collapse; margin-top: 20px;">
            <tr style="background-color: #eee;">
                <th style="padding: 10px;">Recipient</th>
                <th>Type</th>
                <th>Subject</th>
                <th>Content</th>
            </tr>
            <c:forEach var="log" items="${notificationLogs}">
                <tr>
                    <td style="padding: 10px;">${log.recipientId}</td>
                    <td style="padding: 10px;">${log.type}</td>
                    <td style="padding: 10px;">${log.subject}</td>
                    <td style="padding: 10px;">${log.content}</td>
                </tr>
            </c:forEach>
        </table>
        <br>
        <a href="${pageContext.request.contextPath}/dashboard.jsp">Back to Dashboard</a>
    </div>
    
    <jsp:include page="../includes/footer.jsp" />
</body>
</html>