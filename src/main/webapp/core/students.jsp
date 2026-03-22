<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<jsp:include page="/includes/header.jsp" />
<div class="container">
    <h1>All Students</h1>
    <c:if test="${not empty sessionScope.message}">
        <div class="message ${sessionScope.messageType}">
            ${sessionScope.message}
        </div>
        <% session.removeAttribute("message"); session.removeAttribute("messageType"); %>
    </c:if>
    <div class="stats-container">
        <div class="stat-card">
            <div class="stat-value">${totalCount}</div>
            <div class="stat-label">Total Students</div>
        </div>
        <div class="stat-card success">
            <div class="stat-value">${eligibleCount}</div>
            <div class="stat-label">Eligible</div>
        </div>
        <div class="stat-card warning">
            <div class="stat-value">${ineligibleCount}</div>
            <div class="stat-label">Not Eligible</div>
        </div>
        <div class="stat-card">
            <div class="stat-value">${programStats.size()}</div>
            <div class="stat-label">Programs</div>
        </div>
    </div>
    <div class="filters-container">
        <form action="${pageContext.request.contextPath}/students"
            method="get" class="filters-form">
            <div class="filter-group">
                <label for="program">Program:</label> 
                <select name="program"
                    id="program">
                    <option value="all">All Programs</option>
                    <c:forEach items="${allPrograms}" var="prog">
                        <option value="${prog}"
                        ${selectedProgram == prog ? 'selected' : ''}>${prog}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="filter-group">
                <label for="eligible">Status:</label> 
                <select name="eligible"
                    id="eligible">
                    <option value="all">All Students</option>
                    <option value="yes" ${selectedEligible == 'yes' ? 'selected' : ''}>Eligible
                    Only</option>
                    <option value="no" ${selectedEligible == 'no' ? 'selected' : ''}>Not
                    Eligible Only</option>
                </select>
            </div>
            <div class="filter-group">
                <label for="search">Search:</label> <input type="text" name="search"
                    id="search" placeholder="Name or ID..." value="${searchQuery}">
            </div>
            <div class="filter-group">
                <div></div>
                <div>
                    <button type="submit" class="btn btn-primary">Apply
                    Filters</button>
                    <a href="${pageContext.request.contextPath}/students"
                        class="btn btn-secondary">Clear</a>
                </div>
            </div>
        </form>
    </div>
    <c:choose>
        <c:when test="${empty students}">
            <div class="empty-state">
                <h3>No students found</h3>
                <p>Try changing your filters or search criteria.</p>
            </div>
        </c:when>
        <c:otherwise>
            <table>
                <thead>
                    <tr>
                        <th>Student ID</th>
                        <th>Name</th>
                        <th>Program</th>
                        <th>Email</th>
                        <th>CGPA</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${students}" var="student">
                        <tr>
                            <td><strong> <a
                                href="${pageContext.request.contextPath}/student_recovery?studentId=${student.studentId}"
                                class="student-link"> ${student.studentId} </a>
                                </strong>
                            </td>
                            <td>${student.name}</td>
                            <td>${student.program}</td>
                            <td>${student.email}</td>
                            <td>
                                <span
                                    class="badge ${student.cgpa < 2.0 ? 'badge-danger' : 'badge-success'}">
                                    <fmt:formatNumber value="${student.cgpa}" pattern="0.00" />
                                </span>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${student.isEligible}">
                                        <span class="badge badge-success">Eligible</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-danger">Not Eligible</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="action-buttons"><a
                                href="${pageContext.request.contextPath}/student_recovery?studentId=${student.studentId}"
                                class="btn btn-info btn-small">Recovery Plan</a></td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:otherwise>
    </c:choose>
</div>