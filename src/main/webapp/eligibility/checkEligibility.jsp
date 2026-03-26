<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<jsp:include page="/includes/header.jsp" />
<div class="container">
    <h1>Eligibility Check</h1>
    <c:if test="${not empty sessionScope.message}">
        <div class="message ${sessionScope.messageType}">
            ${sessionScope.message}
        </div>
        <% session.removeAttribute("message"); session.removeAttribute("messageType"); %>
    </c:if>
    <div class="stats-container">
        <div class="stat-card">
            <div class="stat-value">${dashboardStats.totalStudents}</div>
            <div class="stat-label">Total Students</div>
        </div>
        <div class="stat-card warning">
            <div class="stat-value">${dashboardStats.ineligibleCount}</div>
            <div class="stat-label">Not Eligible</div>
        </div>
        <div class="stat-card">
            <div class="stat-value">${dashboardStats.confirmedCount}</div>
            <div class="stat-label">Confirmed Registrations</div>
        </div>
        <div class="stat-card">
            <div class="stat-value">
                <c:choose>
                    <c:when test="${dashboardStats.totalStudents > 0}">
                        <fmt:formatNumber
                            value="${(dashboardStats.totalStudents - dashboardStats.ineligibleCount) / dashboardStats.totalStudents * 100}"
                            maxFractionDigits="1" />
                        %
                    </c:when>
                    <c:otherwise>100%</c:otherwise>
                </c:choose>
            </div>
            <div class="stat-label">Eligibility Rate</div>
        </div>
    </div>
    <h2>Students Not Eligible for Progression</h2>
    <c:choose>
        <c:when test="${empty dashboardStats.ineligibleStudents}">
            <div class="empty-state">
                <h3>🎉 All students are eligible for progression!</h3>
                <p>No students need attention at this time.</p>
            </div>
        </c:when>
        <c:otherwise>
            <table>
                <thead>
                    <tr>
                        <th>Student ID</th>
                        <th>Name</th>
                        <th>Program</th>
                        <th>CGPA</th>
                        <th>Failed Courses</th>
                        <th>Reason</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${dashboardStats.ineligibleStudents}" var="item">
                        <tr>
                            <td><strong> <a
                                href="${pageContext.request.contextPath}/student_recovery?studentId=${item.student.studentId}"
                                class="student-link"
                                title="View recovery plans for ${item.student.name}">
                                ${item.student.studentId} </a>
                                </strong>
                            </td>
                            <td>${item.student.name}</td>
                            <td>${item.student.program}</td>
                            <td>
                                <span
                                    class="badge ${item.student.cgpa < 2.0 ? 'badge-danger' : 'badge-warning'}">
                                    <fmt:formatNumber value="${item.student.cgpa}" pattern="0.00" />
                                </span>
                            </td>
                            <td><span
                                class="badge ${item.failedCount > 3 ? 'badge-danger' : 'badge-warning'}">
                                ${item.failedCount} </span>
                            </td>
                            <td>
                                <div class="reason-text">
                                    <c:out value="${item.reason}" default="Failed criteria" />
                                </div>
                            </td>
                            <td>
                                <form
                                    action="${pageContext.request.contextPath}/confirm_registration"
                                    method="post" style="margin: 0;">
                                    <input type="hidden" name="studentId"
                                        value="${item.student.studentId}">
                                    <button type="submit" class="btn btn-primary btn-small"
                                        onclick="return confirm('Confirm registration for ${item.student.name}?')">
                                    Confirm Registration</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:otherwise>
    </c:choose>
    <div
        style="margin-top: 30px; padding: 20px; background: #e8f5e9; border-radius: 8px;">
        <h3 style="color: #2e7d32; margin-top: 0;">Eligibility Criteria</h3>
        <p>Students must meet BOTH of the following criteria to be
            eligible for progression:
        </p>
        <ul>
            <li><strong>CGPA ≥ 2.0</strong> - Calculated as (Total Grade
                Points) / (Total Credit Hours)
            </li>
            <li><strong>Failed courses ≤ 3</strong> - Students with more
                than 3 failed courses are not eligible
            </li>
        </ul>
        <p style="margin-bottom: 0; color: #666; font-style: italic;">
            Note: Administrators can override eligibility by confirming
            registration for individual students.
        </p>
    </div>
</div>
<jsp:include page="/includes/footer.jsp" />