<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/css/bootstrap.min.css"
	integrity="sha384-TX8t27EcRE3e/ihU7zmQxVncDAy5uIKz4rEkgIXeMed4M0jlfIDPvg6uqKI2xXr2"
	crossorigin="anonymous">

<!-- Import jquery cdn -->
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"
	integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj"
	crossorigin="anonymous">
	
</script>

<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/js/bootstrap.bundle.min.js"
	integrity="sha384-ho+j7jyWK8fNQe+A12Hb8AhRq26LrZ/JpcUGGOn+Y7RsweNrtN/tE3MoK7ZeZDyx"
	crossorigin="anonymous">
	
</script>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<link href="${pageContext.request.contextPath}/css/style.css"
	rel="stylesheet">

<jsp:include page="../common/header.jsp"></jsp:include>
<div class="container mt-2">

	<!-- Modal -->
	<div class="modal fade" id="startSprintModal" tabindex="-1"
		aria-labelledby="exampleModalLabel" aria-hidden="true">

		<div class="modal-dialog  modal-lg">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="exampleModalLabel">Start Sprint</h5>
								<button type="button" class="close" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true"
							onclick="window.location.href='${pageContext.request.contextPath}/sprints/activeSprints'">
							× </span>
					</button>	
				</div>
				<div class="modal-body">
					<form action="${pageContext.request.contextPath}/sprints/start"
						method="post" class="my-2 p-3" name="startSprint">
						<div class="mb-3 row">
							<label for="title" class="col-sm-2 col-form-label">Sprint:
								<span class="mandatory-sign">*</span>
							</label>
							<div class="col-sm-10">
								<select
									class="form-select form-select-sm form-control form-control-sm"
									aria-label="Default select example" name="sprintId"
									id="sprintSelect" onchange="checkIdMatch()">
									<option value="" selected disabled>Select Sprint</option>
									<c:forEach items="${sprints}" var="sprint">
										<c:choose>
											<c:when test="${sprint.status != 'Active'}">
												<option value="${sprint.id}"
													data-start="${sprint.startDate}"
													data-end="${sprint.lastDate}"
													data-scrum-id="${sprint.scrumId.id}">${sprint.name}</option>
											</c:when>
											<c:otherwise>
												<!-- Sprint is not active, do not include it in the dropdown -->
											</c:otherwise>
										</c:choose>
									</c:forEach>
								</select>
							</div>
						</div>

						<div class="mb-3 row">
							<label for="startDate" class="col-sm-2 col-form-label">Start
								Date:</label>
							<div class="col-sm-10">
								<input type="date" onkeydown="return false"
									class="form-control form-control-sm" id="startDate"
									min="2023-01-01" max="" placeholder="Enter startDate"
									name="startDate">
							</div>
						</div>
						<div class="mb-3 row">
							<label for="endDate" class="col-sm-2 col-form-label">End
								Date:</label>
							<div class="col-sm-10">
								<input type="date" onkeydown="return false"
									class="form-control form-control-sm" id="endDate"
									min="2023-01-01" max="" placeholder="Enter endDate"
									name="lastDate">
							</div>
						</div>

						<div class="mb-3 row">
							<label for="title" class="col-sm-2 col-form-label ">Scrum
								Teams : </label>
							<div class="col-sm-10">
								<ul class="list-group" style="max-height: 200px; overflow-y: auto;">
									<c:forEach items="${scrumteams}" var="scrum">
										<li
											class="list-group-item d-flex justify-content-between align-items-center">
											<input class="form-check-input" type="radio"
											value="${scrum.id }" id="flexCheckDefault"
											style="margin-left: -14px" name="scrumTeams" id="flexCheck${scrum.id}"> <span
											style="margin-left: 10px"><div
													style="color: cornflowerblue; font-weight: 600">${scrum.name }</div>
												<div class="text-muted">${scrum.members}Members</div></span> <%--  <span class="text-muted " data-toggle="tooltip" data-placement="top">${scrum.members} members</span> --%>
											<div
												class="mx-4 d-flex justify-content-start align-items-center "
												style="position: relative;">
												<c:forEach items="${scrum.users }" var="user">
													<div class="acitve-user" style="background: #42659a"
														data-toggle="tooltip" data-placement="top"
														title="${user.firstName} ${user.lastName}">${user.firstName.charAt(0)}</div>
												</c:forEach>
											</div>
										</li>
									</c:forEach>
								</ul>
							</div>
						</div>
						
						<div class="mb-3 row">
							<div class="mx-auto text-center mt-3">
								<button type="button" class="btn btn-secondary btn-sm"
									data-bs-dismiss="modal">Close</button>
								<button type="submit" class="btn btn-primary Pluck-btn btn-sm"
									disabled="disabled" id="sprint-start">Start</button>
							</div>
						</div>

					</form>
				</div>
			</div>
		</div>
	</div>
</div>

<script src="${pageContext.request.contextPath}/js/common.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<script type="text/javascript">
	$(window).on('load', function() {
		$('#startSprintModal').modal('show');
	});
</script>


<script
	src="https://cdn.jsdelivr.net/gh/bbbootstrap/libraries@main/choices.min.js"></script>
<script src="${pageContext.request.contextPath}/js/startSprint.js"></script>
<script src="${pageContext.request.contextPath}/js/validation.js"></script>
<script>
	$(document).ready(
			function() {

				var multipleCancelButton = new Choices(
						'.choices-multiple-remove-button', {
							removeItemButton : true,
						});

			});
</script>
