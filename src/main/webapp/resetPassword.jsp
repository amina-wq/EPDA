<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Change Password - CRS</title>
</head>
<body style="background-color: #f4f7f6; font-family: Arial, sans-serif;">
    <jsp:include page="/includes/header.jsp" />

    <div style="max-width: 450px; margin: 60px auto; padding: 30px; background: white; border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.1); border: 1px solid #ddd;">
        <h2 style="text-align: center;">Change Your Password</h2>
        <p style="text-align: center; color: #666; font-size: 14px;">Verify your identity to update your password.</p>

        <%-- Error Handling --%>
        <c:if test="${param.error == 'invalid_current'}">
            <p style="color: #721c24; background: #f8d7da; padding: 10px; border-radius: 4px; font-size: 14px;">Invalid Email or Current Password.</p>
        </c:if>
        <c:if test="${param.error == 'mismatch'}">
            <p style="color: #856404; background: #fff3cd; padding: 10px; border-radius: 4px; font-size: 14px;">New passwords do not match.</p>
        </c:if>

        <form action="${pageContext.request.contextPath}/reset_password" method="POST">
            <div style="margin-bottom: 15px;">
                <label>Registered Email:</label>
                <input type="email" name="email" required placeholder="Enter your email" style="width: 100%; padding: 10px; box-sizing: border-box; border: 1px solid #ccc; border-radius: 4px;">
            </div>
            
            <div style="margin-bottom: 15px;">
                <label>Current Password:</label>
                <input type="password" name="currentPassword" required style="width: 100%; padding: 10px; box-sizing: border-box; border: 1px solid #ccc; border-radius: 4px;">
            </div>

            <hr style="border: 0; border-top: 1px solid #eee; margin: 20px 0;">

            <div style="margin-bottom: 15px;">
                <label>New Password:</label>
                <input type="password" name="newPassword" required style="width: 100%; padding: 10px; box-sizing: border-box; border: 1px solid #ccc; border-radius: 4px;">
            </div>
            
            <div style="margin-bottom: 15px;">
                <label>Confirm New Password:</label>
                <input type="password" name="confirmPassword" required style="width: 100%; padding: 10px; box-sizing: border-box; border: 1px solid #ccc; border-radius: 4px;">
            </div>

            <button type="submit" style="width: 100%; padding: 12px; background-color: #0056b3; color: white; border: none; border-radius: 4px; font-weight: bold; cursor: pointer;">Update Password</button>
            
            <div style="text-align: center; margin-top: 20px;">
                <a href="login.jsp" style="color: #666; text-decoration: none; font-size: 14px;">&larr; Back to Login</a>
            </div>
        </form>
    </div>

    <jsp:include page="/includes/footer.jsp" />
</body>
</html>