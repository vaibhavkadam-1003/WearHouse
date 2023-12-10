<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<link rel="stylesheet" href=
"https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/css/bootstrap.min.css"
        integrity=
"sha384-TX8t27EcRE3e/ihU7zmQxVncDAy5uIKz4rEkgIXeMed4M0jlfIDPvg6uqKI2xXr2"
        crossorigin="anonymous">
  
    <!-- Import jquery cdn -->
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"
        integrity=
"sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj"
        crossorigin="anonymous">
    </script>
      
    <script src=
"https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/js/bootstrap.bundle.min.js"
        integrity=
"sha384-ho+j7jyWK8fNQe+A12Hb8AhRq26LrZ/JpcUGGOn+Y7RsweNrtN/tE3MoK7ZeZDyx"
        crossorigin="anonymous">
    </script>
    
<script src="${pageContext.request.contextPath}/js/addQuickStory.js"></script>
<script src="${pageContext.request.contextPath}/js/common.js"></script>
<script src="${pageContext.request.contextPath}/js/validation.js"></script>
	
<link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
<jsp:include page="../common/header.jsp"></jsp:include>
	<div class="container mt-2">

		<!-- Modal -->
		<div class="modal fade" id="addQuickStoryModal"
			tabindex="-1"
			aria-labelledby="quickModalLabel"
			aria-hidden="true">
			
			<div class="modal-dialog modal-lg">
				<div class="modal-content">
					<div class="modal-header">
						<h5 class="modal-title"
							id="quickModalLabel">
							Add Quick Story
						</h5>
						
						<button   aria-label="Close"type="button" class="btn-close" data-bs-dismiss="modal" onclick="window.location.href='${pageContext.request.contextPath}/tasks?pageNo=0'">
							
						</button>
					</div>

					<div class="modal-body">
						<div class="">
			<form action="${pageContext.request.contextPath}/stories/quick" method="post" class="my-2 p-3"
				name="addQuickStory" onsubmit="return addQuickStoryValidation()" id="addQuickStoryForm">


				<div class="mb-3 row">
					<label for="title" class="col-sm-2 col-form-label ">Title <span
						class="mandatory-sign">*</span>
					</label>
					<div class="col-sm-10">
						<input type="text" class="form-control form-control-sm"
							placeholder="Enter Title Here" name="task.title" id="title" required
							onblur="this.value=titleValidate(this,'title-validation-id');">
							<span id="title-validation-id" class="validation-span-c error-message-text-color"></span>
					</div>
				</div>

							<div class="mb-3 row">
								<label id="lable-assignedTo" for="assignedTo"
									class="col-sm-2 col-form-label ">Story Points</label>
								<div class="col-sm-5">
									<select name="task.story_point" id="StoryPoint"
										class=" form-control form-control-sm form-select users "
										placeholder="Select StoryPoint" onblur="hideStoryPointTable()"
										onclick="showStoryTable()">
										<option selected value=""
											class="pluck-radio-option form-control-sm">Select
											Story Point</option>
										<c:forEach items="${storyPoint}" var="storyPoint">
											<option class="pluck-radio-option form-control-sm"
												value="${storyPoint.storyPoint}">${storyPoint.storyPoint}</option>
										</c:forEach>
									</select>
								</div>
								<div class="col-md-5">
									<div class="mb-3 rounded" style="display: none;"
										id="story-point-table">
										<div class="popover fade show bs-popover-end  shadow" role="tooltip">
										<div class="popover-arrow" style="position: absolute; top: 0px; transform: translate(0px, 47px);"></div>
										<div class="popover-body story-point-table">
											<c:forEach items="${storyPoint}" var="point">
												<div class="d-flex justify-content-start align-items-center">
													<p>
														<small class="me-1"> Story point</small> <b>${ point.storyPoint}</b>
														<small class="mx-1">has Range</small> <b>${ point.range}</b>
													</p>
												</div>
											</c:forEach>
										
										</div>
										</div>
									</div>
								</div>

							</div>

				<div class="mb-3 row">
					<label for="description"
						class="col-sm-2 col-form-label">Description</label>
					<div class="col-sm-10">
					<textarea id="description" name="task.description" 
					rows="4" cols="100" class=" form-control" id="description" placeholder="Enter Description Here"></textarea>
					<span id="description-validation-id" class="validation-span-c error-message-text-color"></span>	
					</div>
				</div>

				<div class="mb-3 row">
					<label for="type" class="col-sm-2 col-form-label ">Type </label>
					<div class="col-sm-10">
						<div class="form-check form-check-inline">
							<input class="form-check-input" type="radio" name="agile.storyType"
								value="functional" checked="checked"> <label
								class="form-check-label radio-label">Functional</label>
						</div>
						<div class="form-check form-check-inline">
							<input class="form-check-input" type="radio" name="agile.storyType"
								value="nonFunctional"> <label
								class="form-check-label radio-label">Non-Functional</label>
						</div>
					</div>
				</div>

				<div class="mb-3 row">
					<label for="assignedTo"
						class="col-sm-2 col-form-label ">Assigned To 
					</label>
					<div class="col-sm-10">

						<select class=" form-control form-control-sm form-select"
							aria-label="Default select example" name="task.assignedTo"
							id="assignedTo">

							<option selected value=""  class="pluck-radio-option form-control-sm">Unassigned</option>
							<optgroup label="Scrum Team Members">
											<c:forEach items="${scrumUsers}" var="list">
												<option class="pluck-radio-option form-control-sm text-capitalize"
													value="${list.id}">${list.firstName}&nbsp;${list.lastName}</option>
											</c:forEach>
										</optgroup>
										<optgroup label="Other Users">
											<c:forEach items="${otherUsers}" var="list">
												<option class="pluck-radio-option form-control-sm text-capitalize"
													value="${list.id}">${list.firstName}&nbsp;${list.lastName}</option>
											</c:forEach>
										</optgroup>

									</select>
					</div>
				</div>

				<div class="mb-3 row">
					<label for="priority"
						class="col-sm-2 col-form-label">Priority</label>
					<div class="col-sm-10">
					<!-- 	<input type="text" class="form-control form-control-sm"
							placeholder="Enter priority here" name="priority" id="priority"> -->
						<select class=" form-control form-control-sm form-select"
							aria-label="Default select example" name="task.priority"
							id="priority">

							<!-- <option selected class="pluck-radio-option form-control-sm">Select
								Priority</option> -->
							<c:forEach items="${priorities}" var="priority">
								<c:choose>
									<c:when test="${priority.priority == 'Medium'}">
										<option value="${priority.priority}" selected>${priority.priority}</option>
									</c:when>
									<c:otherwise>
										<option value="${priority.priority}">${priority.priority}</option>
									</c:otherwise>
								</c:choose>
							</c:forEach>
						</select>
					</div>
				</div>

				<div class="mb-3 row">
					<div class="mx-auto text-center mt-3">
						<button type="button" class="btn btn-secondary btn-sm"
							id="quickStory-cancel" onclick="window.location.href='${pageContext.request.contextPath}/tasks?pageNo=0'">Cancel</button>
						<button type="submit" class="btn btn-primary Pluck-btn btn-sm"
							id="quickStory-add" disabled="disabled">Add</button>
					</div>
				</div>

			</form>
		</div>
					
					</div>
				</div>
			</div>
		</div>
	</div>
<script type="text/javascript">
    $(window).on('load', function() {
        $('#addQuickStoryModal').modal('show');
    });
</script>