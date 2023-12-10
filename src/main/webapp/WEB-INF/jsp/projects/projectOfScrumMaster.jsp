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
<link href="${pageContext.request.contextPath}/css/table.css" rel="stylesheet">

</head>
<body>
	<jsp:include page="../common/header.jsp"></jsp:include>
	<div class="main-content">
	<div class="col-md-12 title">
			<h4>All Projects</h4>
		</div>
		<div class="row">
  
			<select id="filter" class="filter form-select">
				<option value="all" selected>All</option>
				<option value="active">Active</option>
				<option value="inactive">Inactive</option>
			</select>

			<table
				class="table table align-middle table-nowrap table-hover table-borderless mt-4"
				id="tableID">

				<thead>
					<tr>
						<th tabindex="0" aria-label="Name sortable" class="sortable"
							style="width: 17%;">Name</th>
						<th tabindex="0" aria-label="Name sortable" class="sortable"
							style="width: 50%;">Description</th>
						<th tabindex="0" aria-label="Tags sortable" class="sortable"
							style="width: 10%;">Start Date</th>
						<th tabindex="0" aria-label="Tags sortable" class="sortable"
							style="width: 10%;">Last Date</th>
						<th tabindex="0" aria-label="Tags sortable" class="sortable"
							style="width: 8%;">Status</th>
						<th tabindex="0" class="text-center" style="width: 5%;">Action</th>
					</tr>
				</thead>
				<tbody>
					
					<c:forEach items="${project}" var="project">
						<tr class="iterativeRow">
							<td style="width: 17%;">
								<div class=" d-flex justify-content-start align-items-center">
									<div class="avatar-circle">
										<span class="avatar-title pluck-capitalize">${fn:substring(project.name, 0, 1)}</span>
									</div>
									<div>
										<h5 class="font-size-14 mb-1 mx-2 text-dark pluck-capitalize"
											onclick="window.location.href='${pageContext.request.contextPath}/projects/details/${project.id }'">
											${project.name}</h5>
									</div>
								</div>
							</td>
							<td class="font-size-12 mb-1 " style="width: 50%;"><p
									class=" ellipsis-description ">${project.description}</p></td>
							<td class="font-size-12 mb-1" style="width: 10%;">${project.startDate}</td>
							<td class="font-size-12 mb-1" style="width: 10%;">${project.lastDate}</td>
							<td class="font-size-12 mb-1  status"
								style="width: 8%;"><c:choose>
									<c:when test="${project.status eq 'Active'}">
										<a class="badge badge-soft-primary font-size-11 m-1">${project.status}</a>
									</c:when>
									<c:otherwise>
										<a class="badge in-active font-size-11 m-1">${project.status}</a>
									</c:otherwise>
								</c:choose></td>
							<% 
 						boolean isEditable= false;
 						%>

							<c:forEach items="${project.owners}" var="entry">
								<c:choose>
									<c:when test="${ loggedInUser.id == entry.id}">
										<% isEditable = true;
 									%>
									</c:when>
									<c:otherwise>
										<c:if test="${ role == 'Company Admin'  }">
											<% isEditable = true;
 									%>
										</c:if>
									</c:otherwise>
								</c:choose>
							</c:forEach>
							<%
 							if(isEditable){
 								%>
							<td class="font-size-12 mb-1 text-center" style="width: 5%;"><a
								href="${pageContext.request.contextPath}/projects/update/form/${project.id}"
								class="text-success"> <i
									class="fa fa-pencil-square text-primary" aria-hidden="true"></i>
							</a></td>
							<%} else{%>
							<td></td>
							<%} %>

						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
	</div>

</body>
</html>