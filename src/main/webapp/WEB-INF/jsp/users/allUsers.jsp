<%@page import="com.pluck.dto.LoginUserDto"%>
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
<script src="${pageContext.request.contextPath}/js/allUsers.js"></script>
  

</head>
<body>
	<jsp:include page="../common/header.jsp"></jsp:include>
	
	<div class="main-content ">
		<div class="container-fluid">
			<div class="main-filter">
				<!-- <button class="btn btn-sm main-btn">All User</button>
				 <button class="btn btn-sm main-btn-secondary" >Project User</button>
				<button class="btn btn-sm main-btn-secondary">Invited User</button> -->
				
				<select id="userFilter" class="all-user-filter main-btn-secondary">
				<option value="allUsers" selected>All Users</option>
				<option value="projectUsers">Project Users</option>
				<option value="invetedUsers">Invited Users</option>
			</select>
				
				
				<select id="filter" class="all-user-filter btn btn-sm text-start">
				<option value="all" selected>All</option>
				<option value="Active">Active</option>
				<option value="Inactive">Inactive</option>
				<option value="Pending">Pending</option>
				<option value="Pending Approval">Pending Approval</option>
			</select>
			
			
			</div>
			<div  id="tableContainer">
				<table class="table-new " id="tableID" style="max-width: 100% !important;">
					<thead>
						<tr>
							<th class="ps-3">Name</th>
							<th>Username</th>
							<th>Contact Number</th>
							<th>Status</th>
							<th>Action</th>
						</tr>
	
					</thead>
					<tbody>
					
					
	
						<c:forEach items="${userList.content}" var="user">
	
							<tr class="">
								<td style="width: 25%;">
									<div class=" d-flex justify-content-start align-items-center">
										<div class=" ">
											<span class="avatar-title">${fn:substring(user.firstName, 0, 1)}</span>
										</div>
										<div>
										 <a class="text-capitalize">
											 <h5 class="m-0">${user.firstName}&nbsp;${user.lastName} 
											 	<c:choose>
													<c:when test="${user.sharedResource == true }">
														<span class="bx bx-command " data-bs-toggle="tooltip" 
															data-bs-placement="top" title="User shared in multiple projects">
														</span>
													</c:when>
												</c:choose>
											</h5>
										 </a>
											
											<p class=" mb-0">${user.highestRole}</p>

										</div>
									</div>
								</td>
								<td style="width: 25%;">${user.username}</td>
	
								<td style="width: 25%;">${user.contactNumber}</td>
								<td class=" status" style="width: 20%;"><c:choose>
										<c:when test="${user.status eq 'Active'}">
											<a class="  active-status">${user.status}</a>
										</c:when>
										<c:otherwise>
											<a class=" in-active-status  ">${user.status}</a>
										</c:otherwise>
									</c:choose></td>
								<c:choose>
									<c:when test="${user.isEditable == 'true'}">
										<td><a
											href="${pageContext.request.contextPath}/users/update/form/${user.id}"
											 > <i class='bx bxs-edit'></i>  
										</a></td>
									</c:when>
									<c:otherwise>
										<td></td>
									</c:otherwise>
								</c:choose>
							</tr>
						</c:forEach>
	
					</tbody>
	
				</table>
			</div>
		</div>
	</div>
	
	    

	<script> 		
		$(document).ready( function() {
			loadTable(${userList.number}, ${userList.numberOfElements});
		}); 
	</script>
</body>
</html>