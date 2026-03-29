<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>


<jsp:include page="/includes/header.jsp" />

<div class="login-container" style="max-width: 450px; margin: 80px auto; padding: 30px; background: white; border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.1); border: 1px solid #ddd;">
    <h2 style="color: #333; margin-top: 0;">System Login</h2>
    
    <c:if test="${not empty error}">
        <p style="color: #d9534f; background: #f2dede; padding: 10px; border-radius: 4px; border: 1px solid #ebccd1;">
            ${error}
        </p>
    </c:if>
    
    <c:if test="${not empty param.message}">
       <c:choose>
           <c:when test="${param.message == 'logged_out'}">
               <p style="color: #3c763d; background: #dff0d8; padding: 10px; border-radius: 4px; border: 1px solid #d6e9c6;">You have successfully logged out.</p>
           </c:when>
           <c:when test="${param.message == 'reset_success'}">
               <p style="color: #3c763d; background: #dff0d8; padding: 10px; border-radius: 4px; border: 1px solid #d6e9c6;">Password updated! Please login with your new password.</p>
           </c:when>
       </c:choose>
   </c:if>

    <form action="${pageContext.request.contextPath}/login" method="POST">
        <div style="margin-bottom: 20px;">
            <label for="username" style="display: block; margin-bottom: 8px; font-weight: bold;">Username:</label>
            <input type="text" id="username" name="username" required style="width: 100%; padding: 12px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box;">
        </div>
        
        <div style="margin-bottom: 20px;">
            <label for="password" style="display: block; margin-bottom: 8px; font-weight: bold;">Password:</label>
            <input type="password" id="password" name="password" required style="width: 100%; padding: 12px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box;">
        </div>
        
        <button type="submit" style="width: 100%; padding: 12px; background-color: #0056b3; color: white; border: none; border-radius: 4px; cursor: pointer; font-size: 16px; font-weight: bold;">Login</button>
        
        <hr style="margin: 25px 0; border: 0; border-top: 1px solid #eee;">
        
        <div style="text-align: center;">
            <a href="${pageContext.request.contextPath}/reset_password" style="color: #0056b3; text-decoration: none; font-size: 14px;">Forgot your password? Reset it here</a>
        </div>
    </form>
</div>

<jsp:include page="/includes/footer.jsp" />
