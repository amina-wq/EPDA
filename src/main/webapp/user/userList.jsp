<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<jsp:include page="/includes/header.jsp" />

<div class="container" style="max-width: 1100px; margin: 40px auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.1);">
    <h2 style="color: #333; margin-top: 0; border-bottom: 2px solid #28a745; padding-bottom: 10px;">Staff Management</h2>

    <c:choose>
        <c:when test="${param.status == 'reset_success'}">
            <div style="background-color: #fff3cd; color: #856404; padding: 12px; border-radius: 4px; border: 1px solid #ffeeba; margin-bottom: 20px;">
                <strong>Notice:</strong> Password has been successfully reset to: <code style="background: #eee; padding: 2px 5px;">Temp123!</code>
            </div>
        </c:when>
        <c:when test="${param.status == 'updated'}">
            <div style="background-color: #d4edda; color: #155724; padding: 12px; border-radius: 4px; border: 1px solid #c3e6cb; margin-bottom: 20px;">
                <strong>Success!</strong> Staff account details have been updated.
            </div>
        </c:when>
        <c:when test="${param.status == 'deactivated'}">
            <div style="background-color: #f8d7da; color: #721c24; padding: 12px; border-radius: 4px; border: 1px solid #f5c6cb; margin-bottom: 20px;">
                <strong>System Update:</strong> The user account is now <strong>Inactive</strong>.
            </div>
        </c:when>
        <c:when test="${param.status == 'reactivated'}">
            <div style="background-color: #d1ecf1; color: #0c5460; padding: 12px; border-radius: 4px; border: 1px solid #bee5eb; margin-bottom: 20px;">
                <strong>System Update:</strong> The user account has been <strong>Reactivated</strong>.
            </div>
        </c:when>
    </c:choose>

    <table style="width: 100%; border-collapse: collapse; margin-top: 10px; font-size: 15px;">
        <thead>
            <tr style="background-color: #5cb85c; color: white; text-align: left;">
                <th style="padding: 15px; border: 1px solid #ddd;">Username</th>
                <th style="padding: 15px; border: 1px solid #ddd;">Email</th>
                <th style="padding: 15px; border: 1px solid #ddd;">Role</th>
                <th style="padding: 15px; border: 1px solid #ddd;">Status</th>
                <th style="padding: 15px; border: 1px solid #ddd; text-align: center;">Actions</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach items="${userList}" var="u">
                <tr style="border-bottom: 1px solid #eee;">
                    <td style="padding: 12px; border: 1px solid #ddd;">${u.username}</td>
                    <td style="padding: 12px; border: 1px solid #ddd;">${u.email}</td>
                    <td style="padding: 12px; border: 1px solid #ddd;"><strong>${u.role}</strong></td>
                    <td style="padding: 12px; border: 1px solid #ddd;">
                        <span style="padding: 4px 8px; border-radius: 3px; font-size: 12px; font-weight: bold; 
                                   background-color: ${u.active ? '#d4edda' : '#f8d7da'}; 
                                   color: ${u.active ? '#155724' : '#721c24'};">
                            ${u.active ? "Active" : "Inactive"}
                        </span>
                    </td>
                    <td style="padding: 12px; border: 1px solid #ddd; text-align: center;">
                        
                        <a href="edit_user?id=${u.id}" style="text-decoration: none;">
                            <button style="background-color: #007bff; color: white; border: none; padding: 6px 12px; border-radius: 4px; cursor: pointer; font-weight: bold;">Edit</button>
                        </a>

                        <form action="${pageContext.request.contextPath}/users" method="post" style="display:inline;">
                            <input type="hidden" name="userId" value="${u.id}">
                            <input type="hidden" name="action" value="reset">
                            <button type="submit" style="background-color: #ffc107; color: #333; border: none; padding: 6px 12px; border-radius: 4px; cursor: pointer; font-weight: bold; margin: 0 5px;"
                                    onclick="return confirm('Force reset password for ${u.username} to Temp123!?')">Reset Pass</button>
                        </form>

                        <form action="${pageContext.request.contextPath}/users" method="post" style="display:inline;">
                            <input type="hidden" name="userId" value="${u.id}">
                            <input type="hidden" name="action" value="${u.active ? 'deactivate' : 'reactivate'}">
                            <button type="submit" style="background-color: ${u.active ? '#dc3545' : '#28a745'}; color: white; border: none; padding: 6px 12px; border-radius: 4px; cursor: pointer; font-weight: bold;">
                                ${u.active ? "Deactivate" : "Activate"}
                            </button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
    
    <div style="margin-top: 25px;">
        <a href="${pageContext.request.contextPath}/" style="color: #666; text-decoration: none;">&larr; Back to Dashboard</a>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />
