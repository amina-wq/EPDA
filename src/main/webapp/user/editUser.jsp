<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<jsp:include page="/includes/header.jsp" />

<div style="max-width: 400px; margin: auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.1);">
    <h2 style="margin-top: 0;">Update Staff Account</h2>
    <form action="edit_user" method="post">
        <input type="hidden" name="userId" value="${targetUser.id}">
        
        <div style="margin-bottom: 15px;">
            <label>Username:</label><br>
            <input type="text" name="username" value="${targetUser.username}" required style="width: 100%; padding: 8px; box-sizing: border-box;">
        </div>
        
        <div style="margin-bottom: 15px;">
            <label>Email:</label><br>
            <input type="email" name="email" value="${targetUser.email}" required style="width: 100%; padding: 8px; box-sizing: border-box;">
        </div>
        
        <div style="margin-bottom: 15px;">
            <label>Role:</label><br>
            <select name="role" style="width: 100%; padding: 8px;">
                <option value="ADMIN" ${targetUser.role == 'ADMIN' ? 'selected' : ''}>Admin</option>
                <option value="OFFICER" ${targetUser.role == 'OFFICER' ? 'selected' : ''}>Officer</option>
            </select>
        </div>
        
        <button type="submit" style="background: #007bff; color: white; border: none; padding: 10px 20px; cursor: pointer; border-radius: 4px; width: 100%;">Save Changes</button>
    </form>
    <p style="text-align: center; margin-top: 20px;">
        <a href="users" style="color: #666; text-decoration: none;">Cancel and Return</a>
    </p>
</div>
    
<jsp:include page="/includes/footer.jsp" />
    