<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="model.User" %>


<jsp:include page="/includes/header.jsp" />

<div style="max-width: 500px; margin: 40px auto; padding: 20px; border: 1px solid #ccc; border-radius: 8px;">
    <h2>Register New Staff Account</h2>
    <p>Use this form to grant system access to a new Administrator or Academic Officer.</p>
    
    <c:if test="${param.error == 'exists'}">
        <div style="color: white; background-color: #dc3545; padding: 10px; margin-bottom: 15px; border-radius: 4px;">
            <strong>Error:</strong> That username or email is already registered in the system.
        </div>
    </c:if>

    <form action="${pageContext.request.contextPath}/register" method="POST">
        
        <div style="margin-bottom: 15px;">
            <label style="display: block; margin-bottom: 5px;">Full Name / Username:</label>
            <input type="text" name="username" required style="width: 100%; padding: 8px; box-sizing: border-box;">
        </div>

        <div style="margin-bottom: 15px;">
            <label style="display: block; margin-bottom: 5px;">Staff Email Address:</label>
            <input type="email" name="email" required style="width: 100%; padding: 8px; box-sizing: border-box;">
        </div>

        <div style="margin-bottom: 15px;">
            <label style="display: block; margin-bottom: 5px;">Initial Password:</label>
            <input type="password" name="password" required style="width: 100%; padding: 8px; box-sizing: border-box;">
        </div>

        <div style="margin-bottom: 15px;">
            <label style="display: block; margin-bottom: 5px;">Assign System Role:</label>
            <select name="role" style="width: 100%; padding: 8px; box-sizing: border-box;">
                <option value="OFFICER">Academic Officer</option>
                <option value="ADMIN">System Administrator</option>
            </select>
        
        </div>

        <button type="submit" style="padding: 10px 20px; background-color: #17a2b8; color: white; border: none; border-radius: 4px; cursor: pointer; width: 100%;">
            Create Staff Account
        </button>
    </form>

    <div style="margin-top: 20px; text-align: center;">
        <a href="${pageContext.request.contextPath}/" style="color: #007bff; text-decoration: none;">&larr; Cancel and Return to Dashboard</a>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />
