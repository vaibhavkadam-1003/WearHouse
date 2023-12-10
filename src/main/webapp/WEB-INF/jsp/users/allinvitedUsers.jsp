<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<script src="https://code.jquery.com/jquery-3.6.1.js"
	integrity="sha256-3zlB5s2uwoUzrXK3BT7AX3FyvojsraNFxCc2vC/7pNI="
	crossorigin="anonymous"></script>
<script src="${pageContext.request.contextPath}/js/allinvitedUsers.js"></script>
 
</head>
<body>
	<jsp:include page="../common/header.jsp"></jsp:include>

	<div class="main-content ">
		<div class="container-fluid">
			<div class="main-filter">
				<!-- <button class="btn btn-sm main-btn-secondary">All User</button>
				<button class="btn btn-sm main-btn-secondary">Project User</button>
				<button class="btn btn-sm main-btn">Invited User</button> -->
				
				<select id="userFilter" class="main-btn-secondary">
						<option value="allUsers" selected>All Users</option>
						<option value="projectUsers">Project Users</option>
						<option value="invetedUsers" selected>Invited Users</option>
					</select>

				
				
				<select id="filter" class="all-user-filter btn btn-sm text-start">
						<option value="all" selected="">All</option>
						<option value="Active">Active</option>
						<option value="Inactive">Inactive</option>
						<option value="Pending">Pending</option>
						<option value="Pending Approval">Pending Approval</option>
					</select>
				
			</div>
			<div>
				<table class="table-new table" id="tableID"
					style="max-width: 100% !important;">
					<thead>
						<tr>
							<th style="width: 70%;">Invited Email ID</th>
							<th>Status</th>
						</tr>
					</thead>
					<tbody>

						<c:forEach items="${list}" var="invitation_link">
							
							<tr class="iterativeRow">
										<td style="width: 70%;">
									<div class=" d-flex justify-content-start align-items-center">
										<div class=" ">
											<span class="avatar-title"><i class='bx bxs-user' style="color:#353e4d !important;"></i></span>
										</div>
										<div  >
											<a class="text-capitalize">
												<h5 class="m-0" >${invitation_link.username}</h5>
											</a>
										</div>
									</div>
								</td>
										<td  class="text-center status">
											<c:choose>
												<c:when test="${invitation_link.status eq 'Active'}">
													<a class="badge badge-soft-primary active-status">${invitation_link.status}</a>
												</c:when>
												<c:when test="${invitation_link.status eq 'Inactive'}">
													<a class="badge in-active in-active-status">${invitation_link.status}</a>
												</c:when>
												<c:when test="${invitation_link.status eq 'Pending'}">
													<a class="badge in-active in-active-status">${invitation_link.status}</a>
												</c:when>
												<c:when test="${invitation_link.status eq 'Pending Approval'}">
													<a class="badge status-pending in-pendingApproval-status">${invitation_link.status}</a>
												</c:when>
											</c:choose>									
										</td>
									</tr>
							
							
						</c:forEach>



					</tbody>

				</table>
			</div>
		</div>
	</div>


	

	<script src="${pageContext.request.contextPath}/js/inviteUser.js"></script>

	<script>
		/* 		$(document).ready( function() {
		 loadTable(${userList.number});
		 }); */

		$(document).ready(function() {
			$('#tableID').DataTable({
				scrollY : '48vh',
				scrollCollapse : true,
			});
		});
	</script>
</body>
</html>