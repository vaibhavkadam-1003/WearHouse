<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<script src="https://code.jquery.com/jquery-3.6.1.js"
	integrity="sha256-3zlB5s2uwoUzrXK3BT7AX3FyvojsraNFxCc2vC/7pNI="
	crossorigin="anonymous"></script>
<script src="${pageContext.request.contextPath}/js/validation.js"></script>

<style type="text/css">
.swal-title {
	font-size: 20px;
	word-break: break-all;
}

</style>
</head>
<body>
	<jsp:include page="../common/header.jsp"></jsp:include>
	<div class="main-content ">
		<div class="col-md-12">
			<div class="row">
				<div class="col-md-12 title">
					<h4>Invite User</h4>
					<select id="userFilter" class="">
						<option value="allUsers" selected>All Users</option>
						<option value="projectUsers">Project Users</option>
						<option value="invetedUsers" selected>Invited Users</option>
					</select>
				</div>
			</div>
			<div>
				<div class="container">
					<div class="row">
							<div class="col-6">
							<form action="${pageContext.request.contextPath}/invite"
							method="post">
								
								</form>
							</div>

						
						
						<div class="col-6 ">
				<div class=" p-2 ">
					<label class="col-form-label card-title" style="font-size: 1rem !important">Invited User</label>
					<div class="invitedUserTable">
						<table id="tableID"
							class="display table align-middle table-nowrap table-hover "
							style="width: 100%">
							<thead>
								<tr>
									<th scope="col">Invited Email ID</th>
									<th scope="col">Status</th>

								</tr>
							</thead>
							<tbody>
								<c:forEach items="${list}" var="invitation_link">

									<tr>
										<td>${invitation_link.username}</td>
										<td><a class="badge badge-soft-primary font-size-11 m-1">${invitation_link.status}</a></td>
									</tr>
								</c:forEach>

							</tbody>
						</table>
					</div>
				</div>
			</div>
					</div>
				</div>


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