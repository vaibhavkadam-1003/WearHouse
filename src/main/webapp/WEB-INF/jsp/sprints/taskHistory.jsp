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
	<div class="modal fade" id="taskHistory" tabindex="-1"
		aria-labelledby="exampleModalLabel" aria-hidden="true">

		<div class="modal-dialog  modal-dialog-centered  modal-xl">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="exampleModalLabel">Add Sprint</h5>

					<button type="button" class="close" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true"
							onclick="window.location.href='${pageContext.request.contextPath}/sprints/sprint-history/${sprintId}'">
							× </span>
					</button>
				</div>

				<div class="modal-body">
					<c:if test="${NosprintMessage != null}">
						<div class="scrume-add-msg">
							<i class="fa fa-users " aria-hidden="true"></i>
							<h3>${NosprintMessage }</h3>
							<div>
								<a
									href="${pageContext.request.contextPath}/sprints/addSprintForm">Add
									Sprint</a>
							</div>
						</div>
					</c:if>


					<div class="mb-3 row">
						<ul class="list-group" id="sprint-task-top">
							<c:forEach items="${tasks}" var="task">
								<li class="draggable  py-1  list-group-item " id="draggable"
									class="ui-widget-content">

									<div class="row">
										<div class="col-md-10">
											<span class=" sprintBox-title "> ${task.title}</span>
										</div>
										<div class="col-md-2 ">
											<div
												class="d-flex justify-content-between align-items-center">
												<div class="col-md-3">
													<span class="badge severity-high ">${task.story_point }/10</span>
												</div>
												<div class="col-md-4">
													<span class="badge sprintBox-priority">${task.priority }</span>
												</div>
												<div class="col-md-5">
													<span class="badge rounded-pill bg-success ">${task.status }</span>
												</div>
											</div>
										</div>
									</div>
								</li>
							</c:forEach>
						</ul>
					</div>


					<div class="mb-3 row">
						<div class="mx-auto text-center mt-3">
							<button type="button" class="btn btn-secondary btn-sm"
								id="user-cancel"
								onclick="window.location.href='${pageContext.request.contextPath}/sprints/sprint-history/${sprintId}'">Close</button>
						</div>
					</div>

				</div>
			</div>
		</div>
	</div>
</div>

<script src="${pageContext.request.contextPath}/js/common.js"></script>

<script type="text/javascript">
	$(window).on('load', function() {
		$('#taskHistory').modal('show');
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
