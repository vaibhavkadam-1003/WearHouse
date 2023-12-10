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
	
<link href="${pageContext.request.contextPath}/css/task.css" rel="stylesheet">

<jsp:include page="../common/header.jsp"></jsp:include>
<div class="container mt-2">

	<!-- Modal -->
	<div class="modal fade" id="addSprintModal" tabindex="-1"
		aria-labelledby="exampleModalLabel" aria-hidden="true">

		<div class="modal-dialog  modal-lg">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="exampleModalLabel">Add Sprint</h5>

					<button type="button" class="close" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true"
							onclick="window.location.href='${pageContext.request.contextPath}/tasks?pageNo=0'">
							× </span>
					</button>
				</div>

				<div class="modal-body">
					<c:if test="${NosprintMessage != null}">
						<div class="scrume-add-msg">
							<i class="fa fa-users " aria-hidden="true"></i>
							<h3>${NosprintMessage }</h3>
							<div>
								<%
									if (session.getAttribute("role").equals("Scrum Master") || session.getAttribute("role").equals("Project Manager")) {
								%>
									<a href="${pageContext.request.contextPath}/sprints/addSprintForm">
									Add Sprint</a>
								<%} %>
							</div>
						</div>
					</c:if>

					<c:if test="${NosprintMessage == null}">
						<form id="myForm" action="${pageContext.request.contextPath}/sprints"
							method="post" class="my-2 p-3" name="addSprint"
							onsubmit="return addSprintValidation()">


							<div class="mb-3 row">
								<label for="title" class="col-sm-2 col-form-label ">Name
									<span class="mandatory-sign">*</span>
								</label>
								<div class="col-sm-10">
									<input type="text" class="form-control form-control-sm"
										placeholder="eg. sprint 1" name="name" id="title"
										onblur="this.value=validateSprint(this,'name-validation-id');"
										required> <span id="name-validation-id"
										class="validation-span-c"></span>
								</div>
							</div>

							<div class="mb-3 row">
								<label for="duration" class="col-sm-2 col-form-label">Duration
									<span class="mandatory-sign">*</span>
								</label>
								<div class="col-sm-10">

									<select
										class="form-select form-select-sm form-control form-control-sm"
										aria-label="Default select example" name="duration"
										id="duration">
										<option value="" selected disabled>Select Duration</option>
										<option value="1 week">1 Week</option>
										<option value="2 weeks">2 Weeks</option>
										<option value="3 weeks">3 Weeks</option>
										<option value="4 weeks">4 Weeks</option>
                                        <option value="custom">Custom</option>
										
									</select> <span class="error-message-text-color"
										id="duration_error_message"></span>
								</div>
							</div>


							<div class="mb-3 row">
								<label for="start_date" class="col-sm-2 col-form-label">Start
									Date 
								</label>
								<div class="col-sm-10">
									<input type="date" class="form-control form-control-sm"
										name="startDate" id="start_date" >
								</div>
							</div>

							<div class="mb-3 row">
								<label for="end_date" class="col-sm-2 col-form-label">End
									Date 
								</label>
								<div class="col-sm-10">
									<input type="date" class="form-control form-control-sm"
										name="lastDate" id="end_date" onblur="this.value=endDateValidate(this,'end_date-validation-id');"
										required> <span id="end_date-validation-id"
										class="validation-span-c"></span>
								</div>
                           </div>

								<div class="mb-3 row">
									<label for="description" class="col-sm-2 col-form-label">Sprint goal</label>
									<div class="col-sm-10">
										<textarea id="description" name="description" rows="4"
											cols="100" class=" form-control" id="description"
											placeholder="Enter description"></textarea>

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
											style="margin-left: -14px" name="scrumId.id"> <span
											style="margin-left: 10px"><div
													style="color: cornflowerblue; font-weight: 600">${scrum.name }</div>
												<div class="text-muted">${scrum.members}Members</div></span> 
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
									<label for="tasks" class="col-sm-2 col-form-label">Tasks</label>
									<div class="col-sm-10">
										<select name="taskIds" id="tasks"
											class=" form-control form-control-sm form-select owners choices-multiple-remove-button"
											multiple>
											<c:forEach items="${tasks}" var="task">
												<c:if test="${task.status != 'Inactive'}">
													<option class="pluck-radio-option form-control-sm"
														value="${task.id }">${task.title }</option>
												</c:if>
											</c:forEach>
										</select>
									</div>
								</div>

								<div class="mb-3 row">
									<div class="mx-auto text-center mt-3">
										<button type="button" class="btn btn-secondary btn-sm"
											id="user-cancel"
											onclick="window.location.href='${pageContext.request.contextPath}/tasks?pageNo=0'">Cancel</button>
										<button type="submit" class="btn btn-primary Pluck-btn btn-sm"
											id="sprint-add" disabled="disabled">Add</button>
									</div>
								</div>
						</form>
					</c:if>
				</div>
			</div>
		</div>
	</div>
</div>

<script src="${pageContext.request.contextPath}/js/common.js"></script>

<script type="text/javascript">
	$(window).on('load', function() {
		$('#addSprintModal').modal('show');
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
