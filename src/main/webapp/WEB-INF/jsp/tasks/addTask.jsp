<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/css/bootstrap.min.css"
	integrity="sha384-TX8t27EcRE3e/ihU7zmQxVncDAy5uIKz4rEkgIXeMed4M0jlfIDPvg6uqKI2xXr2"
	crossorigin="anonymous">

<!-- Import jquery cdn -->
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"
	integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj"
	crossorigin="anonymous">
	
</script>

<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>

<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/js/bootstrap.bundle.min.js"
	integrity="sha384-ho+j7jyWK8fNQe+A12Hb8AhRq26LrZ/JpcUGGOn+Y7RsweNrtN/tE3MoK7ZeZDyx"
	crossorigin="anonymous">
	
</script>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<link href="${pageContext.request.contextPath}/css/style.css"
	rel="stylesheet">

<script src="${pageContext.request.contextPath}/js/validation.js"></script>

<jsp:include page="../common/header.jsp"></jsp:include>
<div class="container mt-2">

	<!-- Modal -->
	<div class="modal fade" id="addTaskModal" tabindex="-1"
		aria-labelledby="exampleModalLabel" aria-hidden="true">

		<div class="modal-dialog  modal-xl">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="exampleModalLabel">Add Task</h5>


					<button type="button" class="btn-close" data-bs-dismiss="modal"
						aria-label="Close"
						onclick="window.location.href='${pageContext.request.contextPath}/tasks?pageNo=0'"></button>
				</div>

				<div class="modal-body">
				<form action="${pageContext.request.contextPath}/tasks" method="post" class="" name="taskform"
					onsubmit="return addTaskValidation()" enctype="multipart/form-data" id="addTaskForm">
					<div class="col-md-12 ">
						<div class="row">

							<div class="col-md-12 ">
								<div class="mb-2 ">
									<label id="lable-title" for="title" class="col-form-label">Title
									</label><span class="mandatory-sign">*</span>
									<textarea class="form-control " placeholder="eg.Task Name" name="title" id="title"
										onblur="this.value=validateTask(this,'title-validation-id');"
										required></textarea>
									<span id="title-validation-id" class="validation-span-c"></span>
								</div>
							</div>

							<div class="col-md-12 ">
								<div class="row  my-3">
									<div class="col-md-3  ">
										<div class="mb-2 ">
											<label id="lable-status" for="status" class="col-form-label">Status</label>
											<select class="form-select  " aria-label="Default select example"
												name="status" id="status">
												<c:forEach items="${taskStatus}" var="taskStatus">
													<c:choose>
														<c:when test="${taskStatus.status == 'Open' }">
															<option selected="selected" value="${taskStatus.status}">
																${taskStatus.status}</option>
														</c:when>
														<c:when test="${taskStatus.status == 'TO-DO' }">
															<option selected="selected" value="${taskStatus.status}">
																${taskStatus.status}</option>
														</c:when>
													</c:choose>
												</c:forEach>
											</select>
										</div>
									</div>


									<div class="col-md-3 ">
										<div class="mb-2 ">
											<label for="sprint" class="col-form-label">Sprint</label><select
												class=" form-select " aria-label="Default select example" name="sprint"
												id="sprint">
												<option selected class="pluck-radio-option form-control-sm" value="0">
													Select Sprint</option>
												<c:forEach items="${sprints}" var="sprint">
													<option value="${sprint.id}">${sprint.name}</option>
												</c:forEach>
											</select>
										</div>
									</div>

									<div class="col-md-3 ">
										<div class="mb-2 ">
											<label for="sprint" class="col-form-label">Type</label><select
												class=" form-select" aria-label="Default select example" name="taskType"
												id="issueType">

												<c:forEach items="${taskType}" var="taskType">
													<c:choose>
														<c:when test="${taskType == 'Task'}">
															<option value="${taskType}" selected>${taskType}</option>
														</c:when>
														<c:when test="${taskType == 'Story' }">
															<option value="${taskType}" style="display: none;">
																${taskType}</option>
														</c:when>
														<c:otherwise>
															<option value="${taskType}">${taskType}</option>
														</c:otherwise>
													</c:choose>
												</c:forEach>

											</select>
										</div>
									</div>

									<div class="col-md-3 ">
										<div class="mb-2 " style="position:relative;">
											<label id="lable-assignedTo" for="assignedTo" class="col-form-label">Story
												Points</label><select name="story_point" id="StoryPoint"
												class=" form-select users " placeholder="Select storyPoint"
												data-bs-toggle="popover" onblur="hideStoryPointTable()"
												onclick="showStoryTable()">
												<option selected value="" class="pluck-radio-option form-control-sm">
													Select
													Story Points</option>
												<c:forEach items="${storyPoint}" var="storyPoint">
													<option class="pluck-radio-option form-control-sm"
														value="${storyPoint.storyPoint}">${storyPoint.storyPoint}
													</option>
												</c:forEach>
											</select>

											<div class="col-md-8" style="display: none; z-index: 1000; "
												id="story-point-table">
												<div class="popover fade show   shadow"
													style="position: absolute; top: -65px; left: -200px;"
													role="tooltip">
													<div class="popover-arrow"
														style="position: absolute; top: 0px; transform: translate(0px, 47px);">
													</div>
													<div class="popover-body story-point-table">
														<c:forEach items="${storyPoint}" var="point">
															<div
																class="d-flex justify-content-start align-items-center">
																<p>
																	<small class="me-1"> Story point</small> <b>${
																		point.storyPoint}</b>
																	<small class="mx-1">has Range</small> <b>${
																		point.range}</b>
																</p>
															</div>
														</c:forEach>

													</div>
												</div>
											</div>
										</div>
									</div>


								</div>

								<div class="row my-3">


									<div class="col-md-3 ">
										<div class="mb-2">
											<label id="lable-originalEstimate" for="originalEstimate"
												class="col-form-label">Original Estimate</label> <input type="text"
												class="form-control" name="originalEstimate" id="originalEstimate"
												placeholder="eg.5h 4m" onchange="getOriginalTime(this)">
											<span id="originalEstimate-validation-id" class="validation-span-c"
												style="color: red; font-size: 0.8rem;"></span>
										</div>
									</div>

									<div class="col-md-3 ">
										<div class="mb-2 ">
											<label id="lable-priority" for="priority"
												class="col-form-label">Priority</label> <select class="form-select"
												aria-label="Default select example" name="priority" id="priority">
												<c:forEach items="${priorities}" var="priority">
													<c:choose>
														<c:when test="${priority.priority == 'Medium'}">
															<option value="${priority.priority}" selected>
																${priority.priority}</option>
														</c:when>
														<c:otherwise>
															<option value="${priority.priority}">${priority.priority}
															</option>
														</c:otherwise>
													</c:choose>
												</c:forEach>
											</select>
										</div>
									</div>

									<div class="col-md-3 ">
										<div class="mb-2 ">
											<label id="lable-severity" for="severity"
												class="col-form-label">Severity</label> <select class="form-select"
												aria-label="Default select example" name="severity" id="severity">
												<c:forEach items="${severties}" var="severity">
													<c:choose>
														<c:when test="${severity.severity == 'Medium'}">
															<option value="${severity.severity}" selected>
																${severity.severity}</option>
														</c:when>
														<c:otherwise>
															<option value="${severity.severity}">${severity.severity}
															</option>
														</c:otherwise>
													</c:choose>
												</c:forEach>
											</select>
										</div>
									</div>


									<div class="col-md-3 ">
										<div class="mb-2 ">
											<label id="lable-assignedTo" for="assignedTo"
												class="col-form-label">Assigned To</label><select name="assignedTo"
												id="assignedTo" class=" form-select ">
												<option selected value="" class="pluck-radio-option form-control-sm">
													Unassigned</option>
												<optgroup label="Scrum Team Members">
													<c:forEach items="${scrumUsers}" var="list">
														<option
															class="pluck-radio-option form-control-sm text-capitalize"
															value="${list.id}">${list.firstName}&nbsp;${list.lastName}
														</option>
													</c:forEach>
												</optgroup>
												<optgroup label="Other Users">
													<c:forEach items="${otherUsers}" var="list">
														<option
															class="pluck-radio-option form-control-sm text-capitalize"
															value="${list.id}">${list.firstName}&nbsp;${list.lastName}
														</option>
													</c:forEach>
												</optgroup>

											</select>
										</div>
									</div>
								</div>
							</div>

						</div>



						<div class="row">
							<div class="col-12">
								<div class="mb-1 ">
									<label id="lable-description" for="description"
										class="col-form-label">Description</label>
									<textarea rows="4" class="form-control " id="description"
										placeholder="Enter Description" name="description"></textarea>

								</div>
								<span id="description-validation-id" class="error-message-text-color"></span>
							</div>
						</div>
						<div class="row">
							<div class="col-md-12">
								<div class="d-flex justify-content-start align-items-center attachments">

									<label> Attachments<i class='bx bx-paperclip'></i> <input class="show-for-sr"
											type="file" id="upload_imgs" name="files" multiple style="display: none;"
											accept="image/*" />
									</label>
								</div>
								<div class="img-thumbs-wrapper  d-flex justify-content-start align-items-center"
									id="img_preview"></div>
							</div>
						</div>
						<div class="row">
							<div class="col text-center my-2">
								<button id="cancel" type="reset" color="primary" class="btn btn-secondary btn-sm"
									onclick="window.location.href='${pageContext.request.contextPath}/tasks?pageNo=0'">Cancel</button>
								<button id="add" type="submit" color="primary" class="btn btn-primary Pluck-btn btn-sm"
									disabled="disabled" onClick="return validateTaskForm();">Add</button>
							</div>
						</div>
					</div>
				</form>

			</div>

				
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
	$(window).on('load', function() {
		$('#addTaskModal').modal('show');
	});
</script>

<script
	src="https://cdn.jsdelivr.net/gh/bbbootstrap/libraries@main/choices.min.js"></script>
<script>

function getOriginalTime(e){
	 const regex = /^(\d+w\s*)?(\d+d\s*)?(\d+h\s*)?(\d+m\s*)?$/;
	  const inputValue = e.value;

	  if (!regex.test(inputValue)) {
	    e.value = '';
	    document.getElementById( 'originalEstimate-validation-id' ).innerHTML="valid input format w d h m"
	  }else{
		let originalTimeInMinute = convertTimeStringToMinutes( inputValue );
		let originalTime  = convertMinutesToTimeString( originalTimeInMinute );
       document.getElementById( 'originalEstimate' ).value = originalTime;
	  }
	
}

function convertTimeStringToMinutes ( timeString ) {
    const timeUnits = {
        w: 7 * 8 * 60,
        d: 8 * 60,
        h: 60,
        m: 1
    };

    const timeSegments = timeString.split( ' ' );

    let totalMinutes = 0;

    timeSegments.forEach( segment => {
        const value = parseInt( segment.slice( 0, -1 ) );
        const unit = segment.slice( -1 );

        if ( !isNaN( value ) && unit in timeUnits ) {
            totalMinutes += value * timeUnits[ unit ];
        }
    } );

    return totalMinutes;
}

  function convertMinutesToTimeString ( totalMinutes ) {
      const timeUnits = {
          w: 7 * 8 * 60, // minutes in a week
          d: 8 * 60,     // minutes in a day
          h: 60,          // minutes in an hour
          m: 1            // minutes in a minute
      };

      const timeSegments = [];
      let num = totalMinutes;
      if(totalMinutes<0){
    	  totalMinutes =  Math.abs(totalMinutes);
      }

      for ( const unit in timeUnits ) {
          if ( totalMinutes >= timeUnits[ unit ] ) {
              const value = Math.floor( totalMinutes / timeUnits[ unit ] );
              totalMinutes %= timeUnits[ unit ];
              timeSegments.push( value+""+unit );
          }
      }
	if(num < 0){
		 return "-"+timeSegments.join( ' ' );
	}else{
		 return timeSegments.join( ' ' );
	}
     
  }
	$(document).ready(
			function() {

				var multipleCancelButton = new Choices(
						'.choices-multiple-remove-button', {
							removeItemButton : true,
						});

			});
</script>
<script src="${pageContext.request.contextPath}/js/addTask.js"></script>
<script src="${pageContext.request.contextPath}/js/common.js"></script>
<script src="${pageContext.request.contextPath}/js/validation.js"></script>