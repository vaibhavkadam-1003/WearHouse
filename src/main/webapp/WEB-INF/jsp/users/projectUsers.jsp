<%@page import="com.pluck.dto.LoginUserDto"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html>
<head>
<meta content="initial-scale=1, maximum-scale=1, user-scalable=0"
	name="viewport" />
<meta name="viewport" content="width=device-width" />
<!-- <link
	href="https://maxcdn.bootstrapcdn.com/font-awesome/4.2.0/css/font-awesome.min.css"
	rel="stylesheet">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC"
	crossorigin="anonymous" /> -->

<!-- Datatable plugin CSS file -->
<link rel="stylesheet" href="https://cdn.datatables.net/1.10.22/css/jquery.dataTables.min.css" />

<!-- jQuery library file -->
<script type="text/javascript" src="https://code.jquery.com/jquery-3.5.1.js"></script> 
<script src="${pageContext.request.contextPath}/js/projectUsers.js"></script>

<style type="text/css">
        table {
            width: 100%;
        }

        thead, tbody, tr, td, th { display: block; }

        tr:after {
            content: ' ';
            display: block;
            visibility: hidden;
            clear: both;
        }

        tbody {
            height: 77vh;
            overflow-y: auto;
        }
	
		 thead th { 
            float: left;
            height: 25px;
        }
        
        tbody td { 
            float: left;
            height: 45px;
            margin:0px;
        }
           
</style>
</head>
<body>
	<jsp:include page="../../jsp/home.jsp"></jsp:include>
	
	<div class="main-content ">
		<div class="container-fluid">
			<div class="main-filter">
				<!-- <button class="btn btn-sm  main-btn-secondary">All User</button>
				<button class="btn btn-sm main-btn" >Project User</button>
				<button class="btn btn-sm main-btn-secondary">Invited User</button> -->
				
				<select id="userFilter" class="all-user-filter main-btn-secondary">
				<option value="allUsers">All Users</option>
				<option value="projectUsers" selected>Project Users</option>
				<option value="invetedUsers">Invited Users</option>
			</select>
			
			 <select id="filter"
					class="all-user-filter btn btn-sm text-start">
					<option value="all" selected="">All</option>
					<option value="active">Active</option>
					<option value="inactive">Inactive</option>
				</select>
			</div>
			<div >
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
	
						<c:forEach items="${userListByProject}" var="user">

						<tr class="iterativeRow">

							<td style="width: 30%">
								<div class=" d-flex justify-content-start align-items-center">
									<div class="avatar-circle">
										<span class="avatar-title pluck-capitalize">${fn:substring(user.firstName, 0, 1)}</span>
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
							<td style="width: 20%" class="font-size-12 ">${user.username}</td>
							
							<td style="width: 20%" class="font-size-12 ">${user.contactNumber}</td>
							<td style="width: 20%" class=" status"><c:choose>
									<c:when test="${user.status eq 'Active'}">
										<a class="active-status">${user.status}</a>
									</c:when>
									<c:otherwise>
										<a class=" in-active-status ">${user.status}</a>
									</c:otherwise>
								</c:choose></td>
							<c:choose>
								<c:when test="${user.isEditable == 'true'}">
									<td style="width: 10%; text-align: center;"><a
										href="${pageContext.request.contextPath}/users/update/form/${user.id}"
										class="text-success "> <i class='bx bxs-edit'></i> 
									</a></td>
								</c:when>
								<c:otherwise>
									<td style="width: 10%"></td>
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
		/* Initialization of datatable */
		$(document).ready(function() {
			$('#tableID').DataTable({
				"ordering": false,
				"columnDefs": [
					  { "searchable":true}
					]
			});
		});
	</script>
	<!-- jQuery library file -->.
	<script src="https://code.jquery.com/jquery-3.6.1.js"
		integrity="sha256-3zlB5s2uwoUzrXK3BT7AX3FyvojsraNFxCc2vC/7pNI="
		crossorigin="anonymous"></script>

	<!-- Datatable plugin JS library file -->
	<script type="text/javascript"
		src="https://cdn.datatables.net/1.10.22/js/jquery.dataTables.min.js"></script>
</body>
</html>