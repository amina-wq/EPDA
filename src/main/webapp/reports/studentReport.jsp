<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<jsp:include page="/includes/header.jsp" />

<style>
    .report-card { background: white; padding: 40px; border-radius: 8px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); margin-bottom: 40px; }
    .header-info { border-left: 5px solid #5cb85c; padding-left: 20px; margin-bottom: 30px; }
    .header-info p { margin-bottom: 8px; font-size: 1.1rem; color: #333; }
    
    .sem-heading { color: #2c3e50; margin-top: 45px; font-weight: bold; border-bottom: 3px solid #5cb85c; display: inline-block; padding-bottom: 5px; }
    .failed-heading { color: #d9534f; margin-top: 25px; font-size: 1rem; font-weight: bold; text-transform: uppercase; letter-spacing: 0.5px; }
    
    .report-table { width: 100%; border-collapse: collapse; margin-top: 15px; border: 1px solid #ddd; }
    .report-table th { 
        background-color: #5cb85c; 
        color: white; 
        padding: 15px 12px; 
        text-align: left; 
        font-size: 0.95rem; 
        font-weight: 600;
        border: 1px solid #4cae4c;
    }
    .report-table td { border: 1px solid #eee; padding: 12px; color: #444; font-size: 1rem; }
    .report-table tbody tr:nth-child(even) { background-color: #fcfcfc; }
    
    .table-failed th { background-color: #d9534f; border-color: #d43f3a; }
    .table-failed td { background-color: #fff8f8; color: #a94442; }

    .gpa-summary { 
        background: #f1f8f1; 
        padding: 15px 25px; 
        border: 1px solid #ddd; 
        border-top: none; 
        text-align: right; 
        font-weight: bold; 
        font-size: 1.15rem; 
        color: #2c3e50;
    }

    @media print {
        .no-print, nav, footer { display: none !important; }
        .report-card { box-shadow: none; border: none; padding: 0; }
        .report-table th { background-color: #5cb85c !important; color: white !important; -webkit-print-color-adjust: exact; }
    }
</style>

<div class="container mt-4">
    <div class="no-print d-flex justify-content-between mb-4">
        <a href="reports" class="btn btn-secondary" style="padding: 10px 20px;">← Back</a>
        <button onclick="window.print()" class="btn btn-success" style="background-color: #5cb85c; border: none; padding: 10px 20px; font-weight: bold;">Print Report</button>
    </div>

    <div class="report-card">
        <h2 class="text-center mb-5" style="color: #333; font-weight: bold;">Academic Performance Report</h2>
        
        <div class="header-info">
            <p><strong>Student Name:</strong> ${report.name}</p>
            <p><strong>Student ID:</strong> ${report.studentId}</p>
            <p><strong>Program:</strong> ${report.program}</p>
        </div>

        <c:forEach items="${report.semesterGroups}" var="sem">
            <h3 class="sem-heading">${sem.key}</h3>
            
            <table class="report-table">
                <thead>
                    <tr>
                        <th style="width: 20%;">Course Code</th>
                        <th style="width: 50%;">Course Title</th>
                        <th style="width: 15%; text-align: center;">Credits</th>
                        <th style="width: 15%; text-align: center;">Grade Point</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${sem.value['passed']}" var="c">
                        <tr>
                            <td>${c.code}</td>
                            <td>${c.title}</td>
                            <td style="text-align: center;">${c.credits}</td>
                            <td style="text-align: center; font-weight: bold;">
                                <fmt:formatNumber value="${c.grade}" minFractionDigits="1" maxFractionDigits="2" />
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
            <div class="gpa-summary">
                Semester GPA: <fmt:formatNumber value="${report.semesterGPAs[sem.key]}" minFractionDigits="2" maxFractionDigits="2" />
            </div>

            <c:if test="${not empty sem.value['failed']}">
                <div class="failed-heading">● Unresolved Failed Courses</div>
                <table class="report-table table-failed">
                    <thead>
                        <tr>
                            <th style="width: 20%;">Course Code</th>
                            <th style="width: 50%;">Course Title</th>
                            <th style="width: 15%; text-align: center;">Credits</th>
                            <th style="width: 15%; text-align: center;">Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${sem.value['failed']}" var="f">
                            <tr>
                                <td>${f.code}</td>
                                <td>${f.title}</td>
                                <td style="text-align: center;">${f.credits}</td>
                                <td style="text-align: center; font-weight: bold;">FAIL</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:if>
        </c:forEach>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />