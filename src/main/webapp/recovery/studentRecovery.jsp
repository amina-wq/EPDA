<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<jsp:include page="/includes/header.jsp" />

<div class="container">
    <h1>Course Recovery Plans</h1>
    
    <div style="display: flex; justify-content: flex-end; margin-top: -55px; margin-bottom: 20px;">
        <a href="plan_milestone" class="btn btn-primary">+ Create New Plan</a>
    </div>

    <div class="stats-container">
        <div class="stat-card" id="card-active" onclick="filterByStatus('ACTIVE', this)" style="cursor: pointer;">
            <div class="stat-value">${counts['ACTIVE']}</div>
            <div class="stat-label">Active Plans</div>
        </div>
        
        <div class="stat-card" id="card-completed" onclick="filterByStatus('COMPLETED', this)" style="cursor: pointer; opacity: 0.5;">
            <div class="stat-value">${counts['COMPLETED']}</div>
            <div class="stat-label">Completed</div>
        </div>
        
        <div class="stat-card warning" id="card-cancelled" onclick="filterByStatus('CANCELLED', this)" style="cursor: pointer; opacity: 0.5;">
            <div class="stat-value">${counts['CANCELLED']}</div>
            <div class="stat-label">Cancelled</div>
        </div>
    </div>

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
                <input type="text" id="tableSearch" value="${searchVal}" placeholder="Name or ID..." 
                       style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px;">
            </div>

            <div class="filter-actions" style="display: flex; gap: 10px;">
                <button type="button" class="btn btn-primary" onclick="runFilters()" style="background-color: #5cb85c; padding: 10px 20px;">Apply Filters</button>
                <button type="button" class="btn btn-secondary" onclick="clearFilters()" style="background-color: #6c757d; padding: 10px 20px;">Clear</button>
            </div>
        </div>
    </div>
    
    <table id="recoveryTable">
        <thead>
            <tr>
                <th style="cursor: pointer; min-width: 130px;" onclick="toggleDateSort()">
                    Start Date <span id="sort-icon">▼</span>
                </th>
                <th>Student ID</th>
                <th>Name</th>
                <th>Program</th>
                <th>Course</th>
                <th>Status</th>
                <th style="text-align: center;">Action</th>
            </tr>
        </thead>
        
		<tbody id="plan-tbody">
		    <c:choose>
		        <c:when test="${not empty plans}">
		            <c:forEach items="${plans}" var="p">
		                <tr class="plan-row" data-status="${p.status}" data-date="${p.startDate}">
		                    <td><fmt:formatDate value="${p.startDate}" pattern="dd MMM yyyy" /></td>
		                    <td>
		                        <a href="setup_plan?planId=${p.id}" class="student-link" style="font-weight:bold;">
		                            ${p.studentId}
		                        </a>
		                    </td>
		                    <td>${p.student.name}</td>
		                    <td class="row-program">${p.student.program}</td>
		                    <td>${p.course.title}</td>
		                    <td>
		                        <span class="badge ${p.status == 'ACTIVE' ? 'badge-warning' : (p.status == 'COMPLETED' ? 'badge-success' : 'badge-danger')}">
		                            ${p.status}
		                        </span>
		                    </td>
		                    <td style="text-align: center;">
		                        <a href="setup_plan?planId=${p.id}" class="btn btn-primary btn-small">
		                            View Plan
		                        </a>
		                    </td>
		                </tr>
		            </c:forEach>
		        </c:when>
		        <c:otherwise>
		            <tr>
		                <td colspan="7" style="text-align: center; padding: 50px; color: #666; font-weight: bold;">
		                    No Records available
		                </td>
		            </tr>
		        </c:otherwise>
		    </c:choose>
		</tbody>
    </table>

    <div id="no-records-box" style="display: none; padding: 60px; text-align: center; background: #fff; border-radius: 8px; margin-top: 20px; border: 1px solid #eee;">
        <h3 style="color: #555; margin-bottom: 10px; font-size: 1.4rem;">No students found</h3>
        <p style="color: #888; font-size: 1rem;">Try changing your filters or search criteria.</p>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />

<script>
let currentStatus = 'ACTIVE';
let sortAsc = false;

function runFilters() {
    const searchText = document.getElementById('tableSearch').value.toLowerCase();
    const selectedProg = document.getElementById('filterProgram').value.toLowerCase();
    const rows = document.querySelectorAll('.plan-row');
    const table = document.getElementById('recoveryTable');
    const noRecordsBox = document.getElementById('no-records-box');
    
    let visibleCount = 0;

    rows.forEach(row => {
        const rowStatus = row.getAttribute('data-status');
        const rowText = row.innerText.toLowerCase();
        const rowProg = row.querySelector('.row-program').innerText.toLowerCase();

        const statusMatch = (rowStatus === currentStatus);
        const searchMatch = rowText.includes(searchText);
        const progMatch = (selectedProg === "" || rowProg === selectedProg);

        if (statusMatch && searchMatch && progMatch) {
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

function filterByStatus(status, element) {
    currentStatus = status;
    document.querySelectorAll('.stat-card').forEach(card => card.style.opacity = "0.5");
    element.style.opacity = "1";
    runFilters();
}

function toggleDateSort() {
    const tbody = document.getElementById('plan-tbody');
    const rows = Array.from(tbody.querySelectorAll('.plan-row'));
    sortAsc = !sortAsc;
    document.getElementById('sort-icon').innerHTML = sortAsc ? "▲" : "▼";
    rows.sort((a, b) => {
        const dateA = new Date(a.getAttribute('data-date'));
        const dateB = new Date(b.getAttribute('data-date'));
        return sortAsc ? dateA - dateB : dateB - dateA;
    });
    rows.forEach(row => tbody.appendChild(row));
}

window.onload = () => filterByStatus('ACTIVE', document.getElementById('card-active'));
</script>