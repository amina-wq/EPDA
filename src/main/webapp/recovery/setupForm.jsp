<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<jsp:include page="/includes/header.jsp" />

<div class="container" style="max-width: 1000px; margin-top: 30px; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;">
    
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px; border-bottom: 2px solid #eee; padding-bottom: 15px;">
        <h2 style="margin:0; color: #333;">
            <c:choose>
                <c:when test="${mode == 'CREATE'}">Initialize New Recovery Plan</c:when>
                <c:when test="${mode == 'EDIT'}">Update Active Recovery Plan</c:when>
                <c:otherwise>View Recovery Plan [${plan.status}]</c:otherwise>
            </c:choose>
        </h2>
        <a href="recovery_plans" class="btn btn-secondary" style="background: #6c757d; color: white; text-decoration: none; padding: 8px 15px; border-radius: 4px; font-size: 14px;">
            &larr; Back to Recovery Plans
        </a>
    </div>

    <div style="background: #fdfdfd; padding: 20px; border-radius: 8px; border: 1px solid #ddd; margin-bottom: 30px; box-shadow: inset 0 2px 4px rgba(0,0,0,0.02);">
        <h4 style="margin-top:0; color: #555; border-bottom: 1px solid #eee; padding-bottom: 10px;">Student Performance Context</h4>
        <div style="display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 20px; font-size: 14px;">
            <div><strong>Enrollment ID:</strong> <c:out value="${plan.enrollmentId}" default="${details.enrollId}" /></div>
            <div><strong>Student:</strong> <c:out value="${plan.student.studentId}" default="${studentId}" /> - <c:out value="${plan.student.name}" default="${details.name}" /></div>
            <div><strong>Program:</strong> <c:out value="${plan.student.program}" default="${details.program}" /></div>
            
            <div><strong>Course:</strong> <c:out value="${plan.course.courseId}" default="${courseId}" /> - <c:out value="${plan.course.title}" default="${details.courseTitle}" /></div>
            
            <%-- IMPROVED COMPONENT DISPLAY --%>
            <div>
                <strong>Component:</strong> 
                <c:choose>
                    <c:when test="${not empty plan.componentType || not empty details.compType}">
                        <c:out value="${plan.componentType}" default="${details.compType}" /> 
                        (<c:out value="${plan.componentName}" default="${details.compName}" />)
                    </c:when>
                    <c:otherwise><span style="color:#999;">None Specified</span></c:otherwise>
                </c:choose>
            </div>

            <div>
                <strong>Comp. Score:</strong> 
                <c:choose>
                    <c:when test="${(plan.passingScore > 0) || (details.passScore > 0)}">
                        <span style="color: #d9534f; font-weight: bold;">
                            <c:out value="${plan.score}" default="${details.compScore}" /> / 
                            <c:out value="${plan.passingScore}" default="${details.passScore}" />
                        </span>
                    </c:when>
                    <c:otherwise><span style="color:#999;">N/A</span></c:otherwise>
                </c:choose>
            </div>
            
            <div><strong>Semester:</strong> <c:out value="${plan.semester}" default="${details.semester}" /></div>
            <div><strong>Attempt:</strong> <c:out value="${plan.attemptNumber}" default="${details.attempt}" /></div>
            <div><strong>Final Grade:</strong> <span style="color: #d9534f;">${plan.failedGrade}${details.grade}</span></div>
        </div>
    </div>

    <form action="setup_plan" method="post" id="mainForm">
        <input type="hidden" name="studentId" value="${studentId}${plan.student.studentId}">
        <input type="hidden" name="courseId" value="${courseId}${plan.course.courseId}">
        <input type="hidden" name="planId" value="${plan.id}">

        <div style="background: #fff; padding: 20px; border-radius: 8px; border: 1px solid #ddd; margin-bottom: 30px;">
            <h4 style="margin-top:0;">Plan Configuration</h4>
            <div style="display: flex; gap: 30px; align-items: flex-end;">
                <div style="flex: 1;">
                    <label style="display: block; margin-bottom: 8px; font-weight: bold;">Overall Plan Status:</label>
                    <c:choose>
                        <c:when test="${mode == 'CREATE'}">
                            <input type="text" class="form-control" value="ACTIVE" disabled style="width: 100%; padding: 10px; background: #e9ecef;">
                            <input type="hidden" name="planStatus" value="ACTIVE">
                        </c:when>
                        <c:otherwise>
                            <select name="planStatus" ${isLocked ? 'disabled' : ''} class="form-control" style="width: 100%; padding: 10px;">
                                <option value="ACTIVE" ${plan.status == 'ACTIVE' ? 'selected' : ''}>ACTIVE</option>
                                <option value="COMPLETED" ${plan.status == 'COMPLETED' ? 'selected' : ''}>COMPLETED</option>
                                <option value="CANCELLED" ${plan.status == 'CANCELLED' ? 'selected' : ''}>CANCELLED</option>
                            </select>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div style="flex: 1;">
                    <label style="display: block; margin-bottom: 8px; font-weight: bold;">Start Date:</label>
                    <input type="date" name="startDate" value="${plan.startDate}" ${isLocked ? 'disabled' : ''} 
                           class="form-control" required style="width: 100%; padding: 10px;">
                </div>
                <div style="flex: 1;">
                    <label style="display: block; margin-bottom: 8px; font-weight: bold;">Completion Deadline:</label>
                    <input type="date" name="endDate" value="${plan.endDate}" ${isLocked ? 'disabled' : ''} 
                           class="form-control" required style="width: 100%; padding: 10px;">
                </div>
            </div>
        </div>

        <div style="background: #fff; padding: 20px; border-radius: 8px; border: 1px solid #ddd;">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px;">
                <h4 style="margin:0;">Planned Milestones</h4>
                <c:if test="${!isLocked}">
                    <button type="button" class="btn btn-success" onclick="addNewMilestone()" style="background: #28a745; color: white; border:none; padding: 8px 15px; border-radius: 4px; cursor: pointer;">
                        + Add Milestone
                    </button>
                </c:if>
            </div>

            <table style="width: 100%; border-collapse: collapse;" id="milestoneTable">
                <thead>
                    <tr style="background: #f4f4f4; text-align: left; font-size: 13px;">
                        <th style="padding: 12px; border: 1px solid #ddd; width: 15%;">Week Range</th>
                        <th style="padding: 12px; border: 1px solid #ddd;">Task / Description</th>
                        <th style="padding: 12px; border: 1px solid #ddd; width: 12%;">Deadline</th>
                        <th style="padding: 12px; border: 1px solid #ddd; width: 12%;">Status</th>
                        <th style="padding: 12px; border: 1px solid #ddd; width: 10%;">Grade</th>
                        <th style="padding: 12px; border: 1px solid #ddd; width: 15%;">Comments</th>
                        <c:if test="${!isLocked}"><th style="width: 40px;"></th></c:if>
                    </tr>
                </thead>
                <tbody id="milestoneBody">
                    <c:choose>
                        <c:when test="${not empty plan.milestones}">
                            <c:forEach items="${plan.milestones}" var="m">
                                <tr>
                                    <td style="padding: 5px; border: 1px solid #ddd;"><input type="text" name="mWeek[]" value="${m.weekRange}" ${isLocked ? 'disabled' : ''} class="form-control" style="width: 90%;"></td>
                                    <td style="padding: 5px; border: 1px solid #ddd;"><input type="text" name="mTask[]" value="${m.task}" ${isLocked ? 'disabled' : ''} class="form-control" style="width: 95%;"></td>
                                    <td style="padding: 5px; border: 1px solid #ddd;"><input type="date" name="mDeadline[]" value="${m.deadline}" ${isLocked ? 'disabled' : ''} class="form-control" style="width: 90%;"></td>
                                    <td style="padding: 5px; border: 1px solid #ddd;">
                                        <select name="mStatus[]" ${isLocked ? 'disabled' : ''} class="form-control">
                                            <option value="PENDING" ${m.status == 'PENDING' ? 'selected' : ''}>PENDING</option>
                                            <option value="IN_PROGRESS" ${m.status == 'IN_PROGRESS' ? 'selected' : ''}>IN_PROGRESS</option>
                                            <option value="COMPLETED" ${m.status == 'COMPLETED' ? 'selected' : ''}>COMPLETED</option>
                                        </select>
                                    </td>
                                    <td style="padding: 5px; border: 1px solid #ddd;">
                                        <input type="number" name="mGrade[]" step="0.1" min="2.0" max="4.0" 
                                               value="${m.grade > 0 ? m.grade : ''}" ${isLocked ? 'disabled' : ''} 
                                               class="form-control" style="width: 90%;" placeholder="2.0-4.0">
                                    </td>
                                    <td style="padding: 5px; border: 1px solid #ddd;"><input type="text" name="mComments[]" value="${m.comments}" ${isLocked ? 'disabled' : ''} class="form-control" style="width: 90%;"></td>
                                    <c:if test="${!isLocked}">
                                        <td style="text-align: center; border: 1px solid #ddd;">
                                            <button type="button" class="btn btn-danger" onclick="this.parentElement.parentElement.remove()" style="background: #dc3545; color: white; border: none; border-radius: 4px; padding: 5px 10px;">X</button>
                                        </td>
                                    </c:if>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td style="padding: 5px; border: 1px solid #ddd;"><input type="text" name="mWeek[]" placeholder="Week 1" class="form-control" required style="width: 90%;"></td>
                                <td style="padding: 5px; border: 1px solid #ddd;"><input type="text" name="mTask[]" placeholder="Task..." class="form-control" required style="width: 95%;"></td>
                                <td style="padding: 5px; border: 1px solid #ddd;"><input type="date" name="mDeadline[]" class="form-control" required style="width: 90%;"></td>
                                <td style="padding: 5px; border: 1px solid #ddd;"><select name="mStatus[]" class="form-control"><option value="PENDING">PENDING</option></select></td>
                                <td style="padding: 5px; border: 1px solid #ddd;"><input type="number" name="mGrade[]" step="0.1" min="2.0" max="4.0" class="form-control" style="width: 90%;"></td>
                                <td style="padding: 5px; border: 1px solid #ddd;"><input type="text" name="mComments[]" class="form-control" style="width: 90%;"></td>
                                <td></td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>

        <div style="margin-top: 30px; text-align: right; border-top: 1px solid #eee; padding-top: 20px;">
            <c:if test="${!isLocked}">
                <button type="submit" class="btn btn-primary" style="background: #007bff; color: white; padding: 15px 40px; border: none; border-radius: 4px; cursor: pointer;">
                    Save Recovery Changes
                </button>
            </c:if>
            <c:if test="${isLocked}">
                <div style="background: #f8d7da; color: #721c24; padding: 15px; border-radius: 4px; border: 1px solid #f5c6cb; display: inline-block;">
                    <strong>Archive Mode:</strong> This plan is finalized (<b>${plan.status}</b>). Editing is disabled.
                </div>
            </c:if>
        </div>
    </form>
</div>

<script>
function addNewMilestone() {
    const tbody = document.getElementById('milestoneBody');
    const tr = document.createElement('tr');
    tr.innerHTML = `
        <td style="padding: 5px; border: 1px solid #ddd;"><input type="text" name="mWeek[]" class="form-control" required style="width: 90%;"></td>
        <td style="padding: 5px; border: 1px solid #ddd;"><input type="text" name="mTask[]" class="form-control" required style="width: 95%;"></td>
        <td style="padding: 5px; border: 1px solid #ddd;"><input type="date" name="mDeadline[]" class="form-control" required style="width: 90%;"></td>
        <td style="padding: 5px; border: 1px solid #ddd;">
            <select name="mStatus[]" class="form-control">
                <option value="PENDING">PENDING</option>
                <option value="IN_PROGRESS">IN_PROGRESS</option>
                <option value="COMPLETED">COMPLETED</option>
            </select>
        </td>
        <td style="padding: 5px; border: 1px solid #ddd;"><input type="number" name="mGrade[]" step="0.1" min="2.0" max="4.0" class="form-control" style="width: 90%;"></td>
        <td style="padding: 5px; border: 1px solid #ddd;"><input type="text" name="mComments[]" class="form-control" style="width: 90%;"></td>
        <td style="text-align: center; border: 1px solid #ddd;">
            <button type="button" class="btn btn-danger" onclick="this.parentElement.parentElement.remove()" style="background: #dc3545; color: white; border: none; border-radius: 4px; padding: 5px 10px;">X</button>
        </td>
    `;
    tbody.appendChild(tr);
}
</script>

<jsp:include page="/includes/footer.jsp" />