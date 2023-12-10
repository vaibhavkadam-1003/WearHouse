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
<input type = "hidden" id="projectId" value="${projectId}">
		<div class="modal-dialog  modal-lg">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="exampleModalLabel">Add Scrum to
						Sprint</h5>

					<button type="button" class="close" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true"
							onclick="window.location.href='${pageContext.request.contextPath}/sprints/stories2/'">
							× </span>
					</button>
				</div>

				<div class="modal-body">
					<c:if test="${scrumTeamMessage == null}">
						<form
							action="${pageContext.request.contextPath}/sprints/add-scrum-to-sprint-1"
							method="post" class="my-2 p-3" name="startSprint">
							<input type="hidden" name="sprintId" value="${sprintId }">
							<input type="hidden" name="projectId" value="${projectId }">
							<div class="mb-3 row">
								<div class="col-sm-12">
									<ul class="list-group">
										<c:forEach items="${scrumteams}" var="scrum">
											<li
												class="list-group-item d-flex justify-content-between align-items-center">
												<input class="form-check-input" type="checkbox"
												value="${scrum.id }" id="flexCheckDefault"
												style="margin-left: -14px" name="scrumTeams"> <span
												style="margin-left: 10px"><div
														style="color: cornflowerblue; font-weight: 600">${scrum.name }</div>
													<div class="text-muted">${scrum.members} Members</div></span> <%--  <span class="text-muted " data-toggle="tooltip" data-placement="top">${scrum.members} members</span> --%>
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
										id="user-cancel"
										onclick="window.location.href='${pageContext.request.contextPath}/sprints/stories2/${projectId }'">Cancel</button>
									<button type="submit" class="btn btn-primary Pluck-btn btn-sm"
										id="sprint-start">Add</button>
								</div>
							</div>

						</form>
					</c:if>
					<c:if test="${scrumTeamMessage != null}">
						<div class="scrume-add-msg">
							<i class="fa fa-users " aria-hidden="true"></i>
							<h3>${scrumTeamMessage }</h3>
							<div>
								<a href="${pageContext.request.contextPath}/scrums/addScrumForm">Add
									Scrum Team</a>
							</div>
						</div>
					</c:if>

				</div>
			</div>
		</div>
	</div>
</div>

<script src="${pageContext.request.contextPath}/js/common.js"></script>

<script type="text/javascript">
	$(window).on('load', function() {
		$('#startSprintModal').modal('show');
	});
</script>


<script
	src="https://cdn.jsdelivr.net/gh/bbbootstrap/libraries@main/choices.min.js"></script>
<script src="${pageContext.request.contextPath}/js/addSprint.js"></script>
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
