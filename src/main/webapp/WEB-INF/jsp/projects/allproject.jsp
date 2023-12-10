<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html>
<head>
<meta content="initial-scale=1, maximum-scale=1, user-scalable=0"
	name="viewport" />
<meta name="viewport" content="width=device-width" />
<!-- Datatable plugin CSS file -->
<link rel="stylesheet"
	href="https://cdn.datatables.net/1.10.22/css/jquery.dataTables.min.css" />

<!-- jQuery library file -->
<script type="text/javascript"
	src="https://code.jquery.com/jquery-3.5.1.js">
	
</script>

<!-- Datatable plugin JS library file -->
<script defer type="text/javascript"
	src="https://cdn.datatables.net/1.10.22/js/jquery.dataTables.min.js">
	
</script>

<script src="${pageContext.request.contextPath}/js/common.js"></script>
<script src="${pageContext.request.contextPath}/js/allProjects.js"></script>

<link href="${pageContext.request.contextPath}/css/table.css"
	rel="stylesheet">

<style>
/* table.dataTable thead th, table.dataTable thead td {
	padding: 10px 5px;
	border-bottom: 1px solid #838282;
	font-size: 13px;
	font-weight: 600;
} */

a {
	cursor: pointer;
}

.name {
	text-transform: capitalize;
}

.capitalize-first-letter::first-letter {
	text-transform: uppercase;
}
</style>

</head>
<body>
	<jsp:include page="../common/header.jsp"></jsp:include>
	<div class="main-content">
		
		<div class="container-fluid">
			<div class="main-filter">
				<button class="btn btn-sm main-btn">All Project</button>
				
				 
				
				<select id="filter" class="btn btn-sm text-start">
				<option value="all" selected>All</option>
				<option value="active">Active</option>
				<option value="inactive">Inactive</option>
			</select>
			</div>
	 
		<div class="">
 

			<table class="table-new " id="tableID"
				style="max-width: 100% !important;">

				<thead>
					<tr>
						<th>Name</th>
						<th style="width: 40%;">Description</th>
						<th>Start Date</th>
						<th>Last Date</th>
						<th>Status</th>
						<th>Action</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${project.content}" var="project">
						<tr class="iterativeRow">
							<td>
								<div class="d-flex justify-content-start align-items-center">
									<div>
										<span class="avatar-title">${fn:substring(project.name, 0, 1)}</span>
									</div>
									<div class="capitalize-first-letter">
										<a
											onclick="window.location.href='${pageContext.request.contextPath}/projects/details/${project.id}'">
											${project.name} </a>
									</div>
								</div>
							</td>
							<td style="width: 37%;">
								<p class="ellipsis-description">${project.description}</p>
							</td>
							<td>${project.startDate}</td>
							<td>${project.lastDate}</td>
							<td class="status"><c:choose>
									<c:when test="${project.status eq 'Active'}">
										<a class="active-status">${project.status}</a>
									</c:when>
									<c:otherwise>
										<a class="in-active-status">${project.status}</a>
									</c:otherwise>
								</c:choose></td>
							<td>
							   <c:if test="${project.editAcces eq true}">
								   <a href="${pageContext.request.contextPath}/projects/update/form/${project.id}" class="text-success"> 
										<i class='bx bxs-edit'></i> 
									</a>
				               </c:if>
							 </td>
						</tr>
					</c:forEach>
				</tbody>

			</table>
		</div>
	</div>
	<script>
		$(document).ready(
				function() {
					loadTable(${project.number}, ${project.numberOfElements});
				});
	</script>

</body>
</html>
