<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<jsp:include page="/includes/header.jsp" />

<div class="container mt-4">
    <h1 style="color: #333; margin-bottom: 5px;">Academic Performance Reporting</h1>
    <p style="color: #888; margin-bottom: 30px;">Student eligibility tracking based on documentation standards.</p>

    <%-- FILTER SECTION --%>
    <div class="filters-container" style="background: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.05); margin-bottom: 25px;">
        <div class="filters-form" style="display: flex; gap: 20px; align-items: flex-end;">
            
            <div class="filter-group" style="flex: 1;">
                <label style="display: block; margin-bottom: 8px; font-weight: bold; color: #666; font-size: 0.9rem;">Program:</label>
                <select id="filterProgram" style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px;">
                    <option value="">All Programs</option>
                    <c:forEach items="${programs}" var="prog">
                        <option value="${prog}" ${prog == selectedProgram ? 'selected' : ''}>${prog}</option>
                    </c:forEach>
                </select>
            </div>

            <div class="filter-group" style="flex: 1;">
                <label style="display: block; margin-bottom: 8px; font-weight: bold; color: #666; font-size: 0.9rem;">Search:</label>
                <input type="text" id="tableSearch" value="${searchVal}" placeholder="Name or ID..." 
                       style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px;">
            </div>

            <div class="filter-actions" style="display: flex; gap: 10px;">
                <button type="button" class="btn btn-primary" onclick="runFilters()" 
                        style="background-color: #5cb85c; padding: 10px 20px; border: none; color: white; border-radius: 4px; font-weight: bold; cursor: pointer;">
                    Apply Filters
                </button>
                <button type="button" class="btn btn-secondary" onclick="clearFilters()" 
                        style="background-color: #6c757d; padding: 10px 20px; border: none; color: white; border-radius: 4px; font-weight: bold; cursor: pointer;">
                    Clear
                </button>
            </div>
        </div>
    </div>

    <%-- TABLE --%>
    <table class="table" style="width: 100%; background: white; border-radius: 8px; overflow: hidden; box-shadow: 0 2px 5px rgba(0,0,0,0.05); border-collapse: collapse;">
        <thead style="background-color: #5cb85c; color: white;">
            <tr>
                <th style="padding: 15px; text-align: left;">Student ID</th>
                <th>Name</th>
                <th>Program</th>
                <th style="text-align: center;">CGPA</th>
                <th style="text-align: center;">Failed Courses</th>
                <th style="text-align: center;">Status</th>
                <th style="text-align: center;">Action</th>
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <c:when test="${not empty studentList}">
                    <c:forEach items="${studentList}" var="s">
                        <tr style="border-bottom: 1px solid #eee;">
                            <td style="font-weight: bold; color: #007bff; padding: 15px;">${s.id}</td>
                            <td>${s.name}</td>
                            <td>${s.program}</td>
                            <td style="text-align: center; font-weight: bold;">
                                <span style="color: ${s.cgpa < 2.0 ? '#d9534f' : '#333'}">
                                    <fmt:formatNumber value="${s.cgpa}" minFractionDigits="2" maxFractionDigits="2" />
                                </span>
                            </td>
                            <td style="text-align: center;">
                                <span style="font-weight: bold; color: ${s.failCount > 3 ? '#d9534f' : '#333'}">${s.failCount}</span>
                            </td>
                            <td style="text-align: center;">
                                <c:choose>
                                    <c:when test="${s.is_eligible}">
                                        <span style="background-color: #dff0d8; color: #3c763d; padding: 5px 12px; border-radius: 4px; font-size: 0.85rem; font-weight: bold;">Eligible</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span style="background-color: #f2dede; color: #a94442; padding: 5px 12px; border-radius: 4px; font-size: 0.85rem; font-weight: bold;">Not Eligible</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td style="text-align: center;">
                                <a href="${pageContext.request.contextPath}/student_report?studentId=${s.id}" class="btn btn-sm" 
                                   style="background-color: #5cb85c; color: white; padding: 8px 16px; font-size: 0.85rem; text-decoration: none; border-radius: 4px; display: inline-block;">
                                    View Report
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr><td colspan="7" style="text-align: center; padding: 60px; color: #999; font-weight: bold;">No student records found.</td></tr>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>
</div>

<jsp:include page="/includes/footer.jsp" />

<script>
function runFilters() {
    const search = document.getElementById('tableSearch').value;
    const program = document.getElementById('filterProgram').value;
    window.location.href = '${pageContext.request.contextPath}/reports?search=' + encodeURIComponent(search) + '&program=' + encodeURIComponent(program);
}
function clearFilters() { window.location.href = '${pageContext.request.contextPath}/reports'; }
</script>