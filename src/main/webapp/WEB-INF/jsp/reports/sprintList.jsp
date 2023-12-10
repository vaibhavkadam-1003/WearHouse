<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
</head>
<body>
	<jsp:include page="../common/header.jsp"></jsp:include>

	<%
	if (session.getAttribute("username") == null) {
		response.sendRedirect("/login");
	}
	%>

	<div class="main-content ">
		<div class="col-md-12 title">
			<h4>Sprint Report</h4>
			<div class="row">
				<div class="col-md-3 mt-4">
				<form id="sprintReportForm" action="${pageContext.request.contextPath}/reports/sprintReportById">
					<select class="form-select" aria-label="Default select example" onchange="selectedSprintValue()" id="sprintsReport">
					<option selected="selected" disabled="disabled">Select Sprint</option>
					<c:forEach items="${sprints}" var="sprint">
						<option value="${sprint.id}">${sprint.name}</option>
					</c:forEach>
					</select>
					</form>
				</div>
			</div>
		</div>
	</div>
</body>
<script src="${pageContext.request.contextPath}/js/sprintReport.js"></script>
</html>