<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="/includes/header.jsp" />

<div class="container">
    <div style="display: flex; align-items: center; gap: 20px; margin-bottom: 20px;">
        <a href="recovery_plans" class="btn btn-secondary" style="background-color: #6c757d; text-decoration: none; padding: 10px 20px; border-radius: 4px; color: white;">
            &larr; Back
        </a>
        <h1 style="margin: 0;">Select Student for Recovery</h1>
    </div>

    <p style="color: #666; margin-bottom: 25px;">
        Below are students who have failed a course but do not yet have an assigned recovery plan.
    </p>

    <div class="filters-container" style="background: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.05); margin-bottom: 25px;">
        <div class="filters-form" style="display: flex; gap: 20px; align-items: flex-end;">
            
            <div class="filter-group" style="flex: 1;">
                <label style="display: block; margin-bottom: 8px; font-weight: bold; color: #666; font-size: 0.9rem;">Program:</label>
                <select id="filterProgram" style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px;">
                    <option value="">All Programs</option>
                    <c:forEach items="${programs}" var="prog">
                        <option value="${prog}">${prog}</option>
                    </c:forEach>
                </select>
            </div>

            <div class="filter-group" style="flex: 1;">
                <label style="display: block; margin-bottom: 8px; font-weight: bold; color: #666; font-size: 0.9rem;">Search:</label>
                <input type="text" id="tableSearch" placeholder="Name or ID..." 
                       style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px;">
            </div>

            <div class="filter-actions" style="display: flex; gap: 10px;">
                <button type="button" class="btn btn-primary" onclick="runFilters()" style="background-color: #5cb85c; padding: 10px 20px; border: none; color: white; cursor: pointer; border-radius: 4px;">Apply Filters</button>
                <button type="button" class="btn btn-secondary" onclick="clearFilters()" style="background-color: #6c757d; padding: 10px 20px; border: none; color: white; cursor: pointer; border-radius: 4px;">Clear</button>
            </div>
        </div>
    </div>

    <table id="candidateTable">
        <thead>
            <tr>
                <th>Student ID</th>
                <th>Name</th>
                <th>Program</th>
                <th>Course ID</th>
                <th>Course Name</th>
                <th style="text-align: center;">Action</th>
            </tr>
        </thead>
        <tbody id="plan-tbody">
            <c:choose>
                <c:when test="${not empty candidates}">
                   <c:forEach items="${candidates}" var="c">
					    <tr class="plan-row">
					        <td><strong>${c.student.getStudentId()}</strong></td>
					        <td>${c.student.name}</td>
					        <td class="row-program">${c.student.program}</td>
					        
					        <td>${c.course.getCourseId()}</td>
					        <td>${c.course.title}</td>
					        
					        <td style="text-align: center;">
					            <a href="setup_plan?studentId=${c.student.getStudentId()}&courseId=${c.course.getCourseId()}" 
					               class="btn btn-primary btn-small" style="background-color: #5cb85c; border: none; text-decoration: none; color: white; padding: 5px 10px; border-radius: 4px;">
					               + New Plan
					            </a>
					        </td>
					    </tr>
					</c:forEach>
                </c:when>
                <c:otherwise>
                    <tr>
                        <td colspan="6" style="text-align: center; padding: 60px; color: #888;">
                            No candidates found.
                        </td>
                    </tr>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>

    <div id="no-records-box" style="display: none; padding: 60px; text-align: center; background: #fff; border-radius: 8px; margin-top: 20px; border: 1px solid #eee;">
        <h3 style="color: #555; margin-bottom: 10px;">No students found</h3>
        <p style="color: #888;">Try changing your filters or search criteria.</p>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />

<script>
function runFilters() {
    const searchText = document.getElementById('tableSearch').value.toLowerCase();
    const selectedProg = document.getElementById('filterProgram').value.toLowerCase();
    const rows = document.querySelectorAll('.plan-row');
    const table = document.getElementById('candidateTable');
    const noRecordsBox = document.getElementById('no-records-box');
    
    let visibleCount = 0;

    rows.forEach(row => {
        const rowText = row.innerText.toLowerCase();
        const rowProg = row.querySelector('.row-program').innerText.toLowerCase();

        const searchMatch = rowText.includes(searchText);
        const progMatch = (selectedProg === "" || rowProg === selectedProg);

        if (searchMatch && progMatch) {
            row.style.display = '';
            visibleCount++;
        } else {
            row.style.display = 'none';
        }
    });

    if (visibleCount === 0 && rows.length > 0) {
        table.style.display = 'none';
        noRecordsBox.style.display = 'block';
    } else {
        table.style.display = 'table';
        noRecordsBox.style.display = 'none';
    }
}

function clearFilters() {
    document.getElementById('tableSearch').value = "";
    document.getElementById('filterProgram').value = "";
    runFilters();
}
</script>