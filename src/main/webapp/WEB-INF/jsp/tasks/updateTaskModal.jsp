<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<html>
<head>
<script src="${pageContext.request.contextPath}/js/updateTaskModal.js"></script>
<script src="${pageContext.request.contextPath}/js/addComment.js"></script>
<script src="${pageContext.request.contextPath}/js/validation.js"></script>
<link href="/${pageContext.request.contextPath}/css/style.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/magnific-popup.js/1.1.0/magnific-popup.min.css">
<style>
.activity .nav {
	height: auto;
	display: flex;
	flex-direction: row;
	justify-content: left;
	overflow: hidden;
}

.description {
	background-color: #fff;
}

.description textarea {
	display: block;
	width: 100%;
	padding: 0.375rem 0.75rem;
	font-size: 0.9rem;
	font-weight: 500;
	line-height: 1.5;
	color: #212529;
	background-color: #fff0;
	background-clip: padding-box;
	border: 1px solid #ced4da00;
	-webkit-appearance: none;
	-moz-appearance: none;
	appearance: none;
	border-radius: 0.25rem;
	transition: border-color .15s ease-in-out, box-shadow .15s ease-in-out;
	font-style: italic;
	resize: none;
	outline: none;
	color: #6a6a6a;
}

.description textarea:hover {
	background-color: #eee;
	border: 1px solid #ced4da;
}

.form-control-plaintext {
	font-weight: 500;
	font-size: 14px;
}

.comment-btn {
	font-size: 12px !important;
	padding: 0px 8px !important;
	border: none !important;
	outline: none !important;
}

.comment-btn i {
	font-size: 10px !important;
}

.comment-box {
	position: relative;
}

.comment-close-btn {
	position: absolute;
	top: 2px;
	right: 1px;
	border: 1px solid #c6bfbf !important;
	padding: 5px 7px !important;
	border-radius: 3px !important;
}

.edit-comment {
	height: 60px !important;
	border-radius: 3px;
	resize: none;
	outline: none;
	margin: 5px 0px;
}

.comment-xmark {
	position: absolute;
	top: 0px;
	right: 0px;
	padding: 3px 7px;
	border: 1px solid #c6bfbf;
	border-radius: 3px;
	right: 0px;
	padding: 3px 7px;
}

#originalEstimate-validation-id {
	font-size: 10px;
	color: red;
	display: block;
}

#timeTracking-validation-id {
	font-size: 10px;
	color: red;
	display: block;
}
</style>
</head>
<body>
<input type="hidden" id="contextPathInput"  value="${pageContext.request.contextPath}">
	<div id="taskModalParentDiv">
		<div class="modal fade" id="addTaskModal" tabindex="-1"
			aria-labelledby="exampleModalLabel" aria-hidden="true">

			<div class="modal-dialog modal-xl">
				<div class="modal-content">
					<div class="modal-header">
						<h5 class="modal-title" id="exampleModalLabel">Task Details</h5>
						<button type="button" class="btn-close" data-bs-dismiss="modal"
							aria-label="Close"></button>
					</div>

					<div class="modal-body">
						<input type="hidden" name="id" value="" id="task-id"> <input
							type="hidden" name="defaultProject" value=""
							id="default-project-id">
						<div class="bg-white p-2">
							<div class="row">
							<h5 id="task-type-id" style="color: #0d6efd;"></h5>
								<div class="col-md-12">

									<div class="input-group">
										<i class='bx bxs-bug task-type-icon'></i> 
										<select
											class="task-type" aria-label="Default select example"
											name="taskType" id="taskType" onchange="updateTaskModal()">
										</select>

										<textarea type="text" class="edit-task form-control"
											placeholder="Enter Title" name="title" id="title"
											rows="2"
											onchange="this.value=validateTask(this,'title-validation-id');"
											onblur="updateTaskModal()" required></textarea>
									</div>
								<p id="title-validation-id" class="validation-span-c text-center"></p>
								</div>
							</div>
							
							<div class="row task-basic-info my-2" >

								<div class="title-div">
									<div>
										<label id="lable-assignedTo" class="form-label">Status
										</label> <select class="form-select"
											aria-label="Default select example" name="status"
											id="statusModalId" onchange="updateTaskModal()">

										</select>
									</div>
								</div>
								
								
								
								<div class="title-div">
									<div>
										<label id="lable-assignedTo" for="assignedTo"
											class="form-label ">Assigned To </label> <select
											class="form-select" aria-label="Default select example"
											name="assignedTo" id="assignedTo"
											onchange="updateTaskModal()">

										</select>
									</div>
								</div>


								<div class="title-div">
									<div>
										<label id="lable-priority" for="priority" class="form-label ">Priority</label>
										<select class="form-select"
											aria-label="Default select example" name="priority"
											id="priority" onchange="updateTaskModal()"> 
										</select> 
									</div>
								</div>


								<div class="title-div">
									<div> 
										<label id="lable-severity" for="severity" class="form-label ">Severity</label> 
										<select class="form-select"
											aria-label="Default select example" name="severity"
											id="severity" onchange="updateTaskModal()"> 
										</select>
									</div>
								</div>

								<div class="title-div">
									<label for="sprint" class="form-label ">Sprint</label> <select
										class="form-select" aria-label="Default select example"
										name="sprint" id="sprint" onchange="updateTaskModal()">
										<option value="0">Select Sprint</option> 
									</select> 
								</div>

								<div class="title-div"> 
									<label id="lable-status" for="start_date" class="form-label ">Created
										Date</label> <p id="creation-date" class="task-created-date"></p>
								</div>

								<div class="title-div"> 
									<label id="lable-story_point" for="story_point"
										class="form-label ">Story-Point</label> <select
										class="form-select" aria-label="Default select example"
										name="story_point" id="story_point"
										onchange="updateTaskModal()"> 
									</select> 
									<div class=" " style="background: #DEDEDE; margin-top: 32px; padding-top: 8px; display: none;"
										id="story-point-table"></div> 
								</div>

								<div class="title-div"> 
									<label id="lable-originalEstimate" for="originalEstimate"
										class="form-label "> Original Estimate</label> <input
										type="text" class="form-control" placeholder="5h 4m"
										name="originalEstimate" id="originalEstimate"
										value="${task.originalEstimate}"
										onchange="getOriginalTime(this)"> <span
										id="originalEstimate-validation-id" class="validation-span-c"></span> 
								</div>

								<div class="title-div">
									<label id="lable-timeTracking" for="timeTracking"
										class="form-label "> Time Tracking</label> <input type="text"
										class="form-control " placeholder="5h 4m" name="timeTracking"
										id="timeTracking" value="${task.timeTracking}"
										onchange="getTrackedTime(this,`${task.timeTracking}`)">
									<span id="timeTracking-validation-id" class="validation-span-c"></span>
								</div>

								<div class="title-div"> 
									<label id="lable-timeTracking" for="timeTracking"
										class="form-label "> Remaining Time</label> <input type="text"
										class="form-control" id="remainingTime"> 
								</div>
								<input type="hidden" name="isUpdated" id="isUpdatedFlag"
									value="false"> 
							</div>


							<div class="row ">
								<div class="col-md-12 mt-3">
									<div class="description">
										<label for="description" class="col-form-label mt-1 py-0">Description</label>
										<textarea class="form-control border" id="description"
											name="description" rows="7" onchange="updateTaskModal()"><c:out
												value="" /></textarea>
									</div>
									<span id="description-validation-id"
										class="error-message-text-color"></span>
								</div>
							</div>
							
							
							<div class="row ">
										<div class="col-md-12 mt-1">
											<div class="">
												<label for="Activity" class="col-form-label mt-1 py-0">Activity</label>
												<div class="activity">
													<nav class="mx-2 my-1">
														<div class="nav nav-tabs" id="nav-tab" role="tablist">
															<button class="nav-link active  " id="nav-comment-tab"
																data-bs-toggle="tab" data-bs-target="#nav-comment"
																type="button" role="tab" aria-controls="nav-comment"
																aria-selected="true">Comment</button>
															<button class="nav-link " id="nav-history-tab"
																onclick="getTaskHistoryModal('${pageContext.request.contextPath}')" data-bs-toggle="tab"
																data-bs-target="#nav-history" type="button" role="tab"
																aria-controls="nav-history" aria-selected="false">History</button>

															<button class="nav-link " id="nav-attachments-tab"
																data-bs-toggle="tab" data-bs-target="#nav-attachments"
																type="button" role="tab" aria-controls="nav-attachments"
																aria-selected="false"
																onclick="getTaskAttachmentsModal()">Attachments</button>

														</div>
													</nav>


													<div class="tab-content mx-2">

														<!-- -----------------------------comment code end --------------------  -->
														<div class="tab-pane fade show active" id="nav-comment"
															role="tabpanel" aria-labelledby="nav-comment-tab">



															<div class="add-comment shadow-lg">
																<i class="fa fa-pencil" aria-hidden="true"></i>
															</div>

															<div style="height: 40vh; overflow-y: auto;"
																id="nav-tabContent"></div>
														</div>

														<!-- -----------------------------comment code end --------------------  -->

														<!-- -----------------------------history code start --------------------  -->

														<div class="tab-pane fade" id="nav-history"
															role="tabpanel" aria-labelledby="nav-history-tab">
															<div class="col-md-12 mx-auto mt-3" id="historyParentDiv">											

															</div>
														</div>
														<!-- -----------------------------history code end --------------------  -->

														<!-- -----------------------------Attachment code start --------------------  -->
														<div class="tab-pane fade" id="nav-attachments"
															role="tabpanel" aria-labelledby="nav-attachments-tab">

															<div class="row mt-3">
																<div class="col-md-12">
																	<div
																		class="d-flex justify-content-start align-items-center  attachments">
																		<h5 class="col-form-label">
																			<button style="outline: none"
																				class="text-dark border-0"
																				onclick="getTaskAttachments(${task.id})">Attachments
																				:</button>
																		</h5>
																		<label class="add-attachment-ui"> Add
																			Attachment<i class="fa-solid fa-paperclip "></i> <input
																			class="show-for-sr" type="file" id="upload_imgs"
																			name="files" multiple onchange=""
																			style="display: none;" />
																		</label>
																	</div>
																	<div
																		class="img-thumbs-wrapper  d-flex justify-content-start align-items-center"
																		id="img_preview"></div>
																</div>
															</div>

														</div>


														<!-- -----------------------------Attachment code start --------------------  -->
													</div>
												</div>
											</div>
										</div>
									</div>
							
							
							




							<%-- <div class="row">
								<div class="col-md-8">
									<div class="row ">
										<div class="col-md-12 mt-3">
											<div class="description">
												<label for="description" class="col-form-label mt-1 py-0">Description</label>
												<textarea class="form-control" id="description"
													name="description" rows="7" onchange="updateTaskModal()"><c:out
														value="" /></textarea>
											</div>
											<span id="description-validation-id"
												class="error-message-text-color"></span>
										</div>
									</div>

									<div class="row ">
										<div class="col-md-12 mt-1">
											<div class="">
												<label for="Activity" class="col-form-label mt-1 py-0">Activity</label>
												<div class="activity">
													<nav class="mx-2 my-1">
														<div class="nav nav-tabs" id="nav-tab" role="tablist">
															<button class="nav-link active  " id="nav-comment-tab"
																data-bs-toggle="tab" data-bs-target="#nav-comment"
																type="button" role="tab" aria-controls="nav-comment"
																aria-selected="true">Comment</button>
															<button class="nav-link " id="nav-history-tab"
																onclick="getTaskHistoryModal('${pageContext.request.contextPath}')" data-bs-toggle="tab"
																data-bs-target="#nav-history" type="button" role="tab"
																aria-controls="nav-history" aria-selected="false">History</button>

															<button class="nav-link " id="nav-attachments-tab"
																data-bs-toggle="tab" data-bs-target="#nav-attachments"
																type="button" role="tab" aria-controls="nav-attachments"
																aria-selected="false"
																onclick="getTaskAttachmentsModal()">Attachments</button>

														</div>
													</nav>


													<div class="tab-content mx-2">

														<!-- -----------------------------comment code end --------------------  -->
														<div class="tab-pane fade show active" id="nav-comment"
															role="tabpanel" aria-labelledby="nav-comment-tab">



															<div class="add-comment shadow-lg">
																<i class="fa fa-pencil" aria-hidden="true"></i>
															</div>

															<div style="height: 40vh; overflow-y: auto;"
																id="nav-tabContent"></div>
														</div>

														<!-- -----------------------------comment code end --------------------  -->

														<!-- -----------------------------history code start --------------------  -->

														<div class="tab-pane fade" id="nav-history"
															role="tabpanel" aria-labelledby="nav-history-tab">
															<div class="col-md-12 mx-auto mt-3" id="historyParentDiv">											

															</div>
														</div>
														<!-- -----------------------------history code end --------------------  -->

														<!-- -----------------------------Attachment code start --------------------  -->
														<div class="tab-pane fade" id="nav-attachments"
															role="tabpanel" aria-labelledby="nav-attachments-tab">

															<div class="row mt-3">
																<div class="col-md-12">
																	<div
																		class="d-flex justify-content-start align-items-center  attachments">
																		<h5 class="col-form-label">
																			<button style="outline: none"
																				class="text-dark border-0"
																				onclick="getTaskAttachments(${task.id})">Attachments
																				:</button>
																		</h5>
																		<label class="add-attachment-ui"> Add
																			Attachment<i class="fa-solid fa-paperclip "></i> <input
																			class="show-for-sr" type="file" id="upload_imgs"
																			name="files" multiple onchange=""
																			style="display: none;" />
																		</label>
																	</div>
																	<div
																		class="img-thumbs-wrapper  d-flex justify-content-start align-items-center"
																		id="img_preview"></div>
																</div>
															</div>

														</div>


														<!-- -----------------------------Attachment code start --------------------  -->
													</div>
												</div>
											</div>
										</div>
									</div>

								</div>
								<div class="col-md-4">
									<div class="mt-2">
										<div class="col-md-12 bg-light border p-2 rounded">

											<div class="mb-3 row">
												<label id="lable-assignedTo" for="assignedTo"
													class="col-sm-4 col-form-label ">Type<span
													class="mandatory-sign">*</span>
													
												</label>
												<div class="col-sm-8">
													<select class="form-control-plaintext"
														aria-label="Default select example" name="taskType"
														id="taskType" onchange="updateTaskModal()">

													</select>
												</div>
											</div>

											<div class="mb-3 row">
												<label id="lable-assignedTo"
													class="col-sm-4 col-form-label ">Status
												</label>
												<div class="col-sm-8">
													<select class="form-control-plaintext"
														aria-label="Default select example" name="status"
														id="statusModalId" onchange="updateTaskModal()">

													</select>
												</div>
											</div>

											<div class="mb-3 row">
												<label id="lable-assignedTo" for="assignedTo"
													class="col-sm-4 col-form-label ">Assigned To
												</label>
												<div class="col-sm-8">
													<select class="form-control-plaintext"
														aria-label="Default select example" name="assignedTo"
														id="assignedTo" onchange="updateTaskModal()">

													</select>
												</div>
											</div>


											<div class="mb-3 row">
												<label id="lable-priority" for="priority"
													class="col-sm-4 col-form-label ">Priority</label>
												
													
												<div class="col-sm-8">
													<select class="form-control-plaintext"
														aria-label="Default select example" name="priority"
														id="priority" onchange="updateTaskModal()">

													</select>
												</div>
											</div>

											<div class="mb-3 row">
												<label id="lable-severity" for="severity"
													class="col-sm-4 col-form-label ">Severity</label>
												<div class="col-sm-8">
													<select class="form-control-plaintext"
														aria-label="Default select example" name="severity"
														id="severity" onchange="updateTaskModal()">

													</select>
												</div>
											</div>

											<div class="mb-3 row">
												<label for="sprint" class="col-sm-4 col-form-label ">Sprint</label> 
												<div class="col-sm-8">
													<select class="form-control-plaintext"
														aria-label="Default select example" name="sprint"
														id="sprint" onchange="updateTaskModal()">
														<option value="0">Select Sprint</option>

													</select>
												</div>
											</div>

											<div class="mb-3 row">
												<label id="lable-status" for="start_date"
													class="col-sm-4 col-form-label ">Created Date</label>
												<div class="col-sm-8" style="padding-top:3px;">
													<span id="creation-date" style="font-size: 13px"></span>
												</div>
											</div>

											<div class="mb-3 row">
												<label id="lable-story_point" for="story_point"
													class="col-sm-4 col-form-label ">Story Point</label>
												<div class="col-sm-8">
													<select class="form-control-plaintext"
														aria-label="Default select example" name="story_point"
														id="story_point" onchange="updateTaskModal()">

													</select>

													<div class=" "
														style="background: #DEDEDE; margin-top: 32px; padding-top: 8px; display: none;"
														id="story-point-table"></div>

												</div>
											</div>

											<div class="mb-3 row">
												<label id="lable-originalEstimate" for="originalEstimate"
													class="col-sm-4 col-form-label "> Original Estimate</label>
												<div class="col-sm-8">
													<input type="text" class="edit-task form-control-sm border"
														placeholder="5h 4m" name="originalEstimate"
														id="originalEstimate" value="${task.originalEstimate}"
														onchange="getOriginalTime(this)"> <span
														id="originalEstimate-validation-id"
														class="validation-span-c"></span>
												</div>
											</div>

											<div class="mb-3 row">
												<label id="lable-timeTracking" for="timeTracking"
													class="col-sm-4 col-form-label "> Time Tracking</label>
												<div class="col-sm-8">
													<input type="text" class="edit-task form-control-sm border"
														placeholder="5h 4m" name="timeTracking" id="timeTracking"
														value="${task.timeTracking}"
														onchange="getTrackedTime(this,`${task.timeTracking}`)">
													<span id="timeTracking-validation-id"
														class="validation-span-c"></span>
												</div>
											</div>

											<div class="mb-3 row">
												<label id="lable-timeTracking" for="timeTracking"
													class="col-sm-4 col-form-label "> Remaining Time</label>
												<div class="col-sm-8">
													<input type="text" class="edit-task form-control-sm border"
														id="remainingTime">
												</div>
											</div>
											<input type="hidden" name="isUpdated" id="isUpdatedFlag"
												value="false">


										</div>
									</div>
								</div>

							</div> --%>
						</div>

					</div>
				</div>
			</div>
		</div>
	</div>
	<script
		src="https://cdnjs.cloudflare.com/ajax/libs/magnific-popup.js/1.1.0/jquery.magnific-popup.min.js"></script>
	<script type="text/javascript">
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
		  function getOriginalTime(e){
				 if(e.value!=""){
					 const regex = /^(\d+w\s*)?(\d+d\s*)?(\d+h\s*)?(\d+m\s*)?$/;
					  const inputValue = e.value;

					  if (!regex.test(inputValue)) {
					    e.value = '';
					    document.getElementById( 'originalEstimate-validation-id' ).innerHTML="valid input format w d h m"
					  }else{
						let originalTimeInMinute = convertTimeStringToMinutes( inputValue );
						let originalTime  = convertMinutesToTimeString( originalTimeInMinute );
				        document.getElementById( 'originalEstimate' ).value = originalTime;
				        updateTaskModal();
					  }
				 }
				
			}
			
			function getTrackedTime(e,oldTimeTracking) {
				 if(e.value!=""){
					 const regex = /^(\d+w\s*)?(\d+d\s*)?(\d+h\s*)?(\d+m\s*)?$/;
					  const inputValue = e.value;

					  if (!regex.test(inputValue)) {
					    e.value = '';
					    document.getElementById( 'timeTracking-validation-id' ).innerHTML="valid input format w d h m"
					  }else{
						let originalTimeInMinute = convertTimeStringToMinutes(  document.getElementById( 'originalEstimate' ).value );
						
						let trackedTimeInMinute = convertTimeStringToMinutes( inputValue );
						let oldTimeTrackingInMinute = convertTimeStringToMinutes( oldTimeTracking);
						
						let totalTimeTrackedInMinute = trackedTimeInMinute + oldTimeTrackingInMinute;
						let totalTrackedTime = convertMinutesToTimeString( totalTimeTrackedInMinute );
						
						document.getElementById( 'timeTracking' ).value = totalTrackedTime;
						let remainingtimeInMinute = originalTimeInMinute - totalTimeTrackedInMinute;
						let remainingtime = convertMinutesToTimeString( remainingtimeInMinute );
						document.getElementById( 'remainingTime' ).value = remainingtime;
						 updateTaskModal();
					  }
				 }
			}
			
		</script>
</body>
</html>