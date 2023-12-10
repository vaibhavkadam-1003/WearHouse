<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
  <link href="/${pageContext.request.contextPath}/css/style.css"
	rel="stylesheet">  

<link href="${pageContext.request.contextPath}/css/task.css"
	rel="stylesheet">
	
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>

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
#originalEstimate-validation-id{
    font-size: 10px;
    color: red;
    display: block;
}

#timeTracking-validation-id{
	font-size: 10px;
    color: red;
    display: block;
}
</style>
<%
if (session.getAttribute("username") == null) {
	response.sendRedirect("/loginForm");
}
%>
<!-- Magnific Popup -->
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/magnific-popup.js/1.1.0/magnific-popup.min.css">
	<script src="https://unpkg.com/boxicons@2.1.4/dist/boxicons.js"></script>
<html>
<body>
	<jsp:include page="../common/header.jsp"></jsp:include>
	<div class="main-content main-content border" style="background-color: #ffffff !important;"> 
		<!-- <div class="row">
			<div class="col-md-12 title">
				<h5>Task Update Details</h5>
			</div>
		</div> -->
		<div class="contianerv">
			<form action="${pageContext.request.contextPath}/tasks/update/task"
				method="post" class=" " id="update" name="updateTaskForm"
				onsubmit="return addTaskValidation()" enctype="multipart/form-data">

				<input type="hidden" name="id" value="${task.id}"> <input
					type="hidden" name="project" value="${projectId}">
					<input type="hidden" id="contextPathInput"  value="${pageContext.request.contextPath}">

				<div class="row">
				<h5 style="color: #0d6efd;">${task.ticket}</h5>
					<div class="col-md-12">
						<div class="input-group"> 
							<c:choose>
								<c:when test="${task.taskType eq 'Task'}">
									<i class='bx bxs-badge-check task-type-icon'></i>
								</c:when>
								<c:when test="${task.taskType eq 'Bug'}">
									<i class='bx bxs-bug task-type-icon'></i>
								</c:when>
								<c:otherwise>
									<i class='bx bxs-zap task-type-icon' ></i>
								</c:otherwise>
								
							</c:choose>
							<select class="task-type"
                                                aria-label="Default select example" name="taskType"
                                                id="taskType" onchange="task()"> 
                                                <c:forEach items="${taskType}" var="taskType">
                                                    <c:choose>
                                                        <c:when test="${ taskType ==task.taskType}">
                                                            <option selected
                                                                class="pluck-radio-option form-control-sm"
                                                                value="${taskType}">${taskType} </option>
                                                        </c:when>
                                                        <c:when
                                                            test="${taskType == 'Story' }">
                                                            <option value="${taskType}" style="display: none;">${taskType}</option>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <option value="${taskType}">${taskType}</option>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:forEach>
                                            </select>
                                            
							<textarea type="text" class="edit-task form-control "
								aria-label="Text input with dropdown button"
								placeholder="Enter title here" name="title" id="title" rows="2"
								onchange="this.value=validateTask(this,'title-validation-id');"
								required><c:out value="${task.title}" /></textarea> 
						</div>
						<p id="title-validation-id" class="validation-span-c text-center"></p>
					</div>
				</div>

				<div class="row task-basic-info my-2 " > 
				
				<div class="title-div" 	onclick="statusDropdown(this,${task.id},`${task.status}`)">
						<div>
							<label for="exampleFormControlInput1" class="form-label" >Status</label>
							<div class="btn-group d-block" id="nav-list-menu-div1">
								<button type="button"
									class="btn btn-sm add-btn dropdown-toggle dropdown-toggle-split task-status-btn"
									data-bs-toggle="dropdown" aria-expanded="false" id="myButton">
									<span class=" mx-1 " id="create-button-span" onchange="task()">
										${task.status}</span> 
								</button>

								<ul class="dropdown-menu dropdown-menu-create-option"
									id="main-UI">
								</ul>
							</div>
						</div>
					</div>  
				
					<div class="title-div">
			<div class="mb-3 row">
										<label id="lable-assignedTo" for="assignedTo" class="form-label">Assigned To
										</label>
										<select class="form-select"
												aria-label="Default select example" name="assignedTo"
												id="assignedTo" onchange="task()">
												<c:choose>
													<c:when test="${not empty task.assignedTo}">
														<option 
															class="pluck-radio-option form-control-sm" value="">Unassigned</option>
													</c:when>
												</c:choose>
												<c:choose>
													<c:when test="${empty task.assignedTo}">
														<option selected
															class="pluck-radio-option form-control-sm" value="">Unassigned</option>
													</c:when>
													<c:otherwise>
														<c:forEach var="user" items="${users}">
															<c:if test="${user.id == task.assignedTo}">
																<option selected
																	class="pluck-radio-option form-control-sm text-capitalize"
																	value="${user.id}">${user.firstName}
																	${user.lastName}</option>
															</c:if>
														</c:forEach>
													</c:otherwise>
												</c:choose>
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

					<div class="title-div">
						<div class="mb-3">
							<label id="lable-priority" for="priority">Priority</label>
								 <select class="form-select" aria-label="Default select example" name="priority" id="priority" onchange="task()">
										    <c:choose>
										        <c:when test="${priority.priority == task.priority}">
										            <option selected value="${priority.priority}">${priority.priority}</option>
										        </c:when>
										        <c:otherwise>
										            <option value="">Select Priority</option>
										            <c:forEach items="${priorities}" var="priorityItem">
										                <c:choose>
										                    <c:when test="${priorityItem.priority == task.priority}">
										                        <option selected value="${priorityItem.priority}">${priorityItem.priority}</option>
										                    </c:when>
										                    <c:otherwise>
										                        <option value="${priorityItem.priority}">${priorityItem.priority}</option>
										                    </c:otherwise>
										                </c:choose>
										            </c:forEach>
										        </c:otherwise>
										    </c:choose>
									</select>
						</div>
					</div>


					<div class="title-div">
						<div class="mb-3">
							<label id="lable-severity" for="severity">Severity</label> <select
								class="form-select" name="severity" id="severity"
								onchange="task()">
								<c:forEach items="${severties}" var="severity">
									<c:choose>
										<c:when test="${ severity.severity ==task.severity}">
											<option selected class="pluck-radio-option form-control-sm"
												value="${severity.severity}">${severity.severity}</option>
										</c:when>
										<c:otherwise>
											<option value="${severity.severity}">${severity.severity}</option>
										</c:otherwise>
									</c:choose>
								</c:forEach>
							</select>
						</div>
					</div>

					<div class="title-div">
						<div class="mb-3">
							<label for="sprint">Sprint</label>
							<select class="form-select" name="sprint" id="sprint"
								onchange="task()">
								<option value="0">Select Sprint</option>
								<c:forEach items="${sprints}" var="sprint">
									<c:choose>
										<c:when test="${ task.sprint == sprint.id}">
											<option selected class="pluck-radio-option form-control-sm"
												value="${sprint.id}">${sprint.name}</option>
										</c:when>
										<c:otherwise>
											<option value="${sprint.id}">${sprint.name}</option>
										</c:otherwise>
									</c:choose>
								</c:forEach>
							</select>
						</div>
					</div>

					<div class="title-div">
                        <div class="mb-3">
                            <label id="lable-status" for="start_date" >Created Date</label>
                            <p class="task-created-date">${task.addedOn}</p>
                        </div>
                    </div>

					<div class="title-div">
				<div class="mb-3 row">
										<label id="lable-story_point" for="story_point" class="form-label">Story Point </label>
										
											<select class="form-select"
												aria-label="Default select example" name="story_point"
												id="story_point" onchange="task()">
												<c:choose>
													<c:when test="${empty task.story_point}">
														<option value="" selected>Select Story Point</option>
													</c:when>
													<c:otherwise>
														<option value="">Select Story Point</option>
														<option value="${task.story_point}" selected>${task.story_point}</option>
													</c:otherwise>
												</c:choose>

												<c:forEach items="${taskStoryPoint}" var="story_point">
													<c:choose>
														<c:when
															test="${story_point.storyPoint == task.story_point}">
															<option value="${story_point.storyPoint}" selected>${story_point.storyPoint}</option>
														</c:when>
														<c:otherwise>
															<option value="${story_point.storyPoint}">${story_point.storyPoint}</option>
														</c:otherwise>
													</c:choose>
												</c:forEach>
											</select>

											<div class=" "
												style="background: #DEDEDE; margin-top: 32px; padding-top: 8px; display: none;"
												id="story-point-table">
												<c:forEach items="${storyPoints}" var="point">
													<span>${ point.storyPoint} - ${ point.range}</span> |
										</c:forEach>
											</div>
 
									</div>
					</div>
					
					
					<div class="title-div">
						<div class="mb-3">
							<label id="lable-originalEstimate" for="originalEstimate" > Original Estimate</label>	
						 	<input type="text" class="form-control"
												placeholder="eg.5h 4m" name="originalEstimate"
												id="originalEstimate" value="${task.originalEstimate}"
												onchange="getOriginalTime(this)"> <span
												id="originalEstimate-validation-id"
												class="validation-span-c"></span>
						</div>
					</div>
					
					<div class="title-div">
						<div class="mb-3">
							<label id="lable-timeTracking" for="timeTracking" >	Time Tracking</label>
						 	<input type="text" class="form-control"
												placeholder="eg.5h 4m" name="timeTracking" id="timeTracking"
												value="${task.timeTracking}"
												onchange="getTrackedTime(this,`${task.timeTracking}`)">
											<span id="timeTracking-validation-id"
												class="validation-span-c"></span>
						</div>
					</div>
					
					<div class="title-div">
						<div class="mb-3">
							<label id="lable-timeTracking" for="timeTracking" > Remaining Time</label>
						 	<input type="text" class="form-control" id="remainingTime">
						</div>
					</div>
					 

				</div>
				
			

				<div class="row ">
					<div class="col-md-12 mt-3">
						<div class="description">
							<label for="description" class="col-form-label mt-1 py-0">Description</label>
							<textarea class="form-control border" id="description"
								name="description" rows="7" onchange="task()"><c:out
									value="${task.description}" /></textarea>
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
											aria-selected="true">Comments</button>
										<button class="nav-link " id="nav-history-tab"
											onclick="getTaskHistory(${task.id})" data-bs-toggle="tab"
											data-bs-target="#nav-history" type="button" role="tab"
											aria-controls="nav-history" aria-selected="false">History</button>

										<button class="nav-link " id="nav-attachments-tab"
											data-bs-toggle="tab" data-bs-target="#nav-attachments"
											type="button" role="tab" aria-controls="nav-attachments"
											aria-selected="false"
											onclick="getTaskAttachments(${task.id},'${pageContext.request.contextPath}')">Attachments</button>

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
											id="nav-tabContent">

										<div class=" send-comment  " style="display: none;">
												<div class="row">
													<div class="col-md-10 mx-auto comment-box"
														style="background-color: #e0e0e0; padding: 15px 30px 5px; margin-top: 5px; border-radius: 5px;"
														style="background-color: #e4e4e4;">
														<h6>Add Comment</h6>
														<div class=" ">
															<input type="hidden" name="taskId" value="${task.id}">
															<input type="hidden" name="addedBy"
																value="${task.addedBy}"> <input type="text"
																class="form-control" placeholder="Add a comment..."
																required="required" aria-label="Recipient's username"
																name="comment" id="commentInput"
																aria-describedby="button-addon2">
														</div>

														<label
															class="btn btn-success btn-sm text-white comment-btn"
															style="background-color: #198754;"> <i
															class="fa-solid fa-paperclip  "></i> Attachment <input
															class="show-for-sr" type="file" id="commentAtt"
															name="commentFiles" multiple style="display: none;"
															accept="image/*" onchange="cmdAttachmentChange()" />
														</label>

														<button class="btn btn-primary btn-sm my-3 comment-btn"
															style="background-color: #3d8bfd;" type="button"
															id="addCommentBtn">
															<i class="fa fa-paper-plane" aria-hidden="true"></i>
															Submit
															<!-- <i class="fa fa-paper-plane" aria-hidden="true"> <span>Submit</span> </i> -->
														</button>

														<button type="button"
															class="comment-close-btn btn-close comment-btn"
															data-bs-dismiss="modal" aria-label="Close"></button>

													</div>
												</div>
												<!-- <div
																class="img-thumbs-wrapper  d-flex justify-content-start align-items-center"
																id="img_preview"></div> -->
											</div>

											<c:forEach items="${allComment}" var="commentList">

												<c:forEach items="${users}" var="user">
													<c:if test="${user.id == commentList.addedBy }">
														<a id="comId${commentList.id}">
															<div class="tab-pane fade show active" id="nav-comment"
																role="tabpanel" aria-labelledby="nav-comment-tab">
																<div
																	class="d-flex justify-content-start align-items-start comment"
																	i>
																	<div class="comment-user">${fn:substring(user.firstName, 0, 1)}${fn:substring(user.lastName, 0, 1)}</div>
																	<div class="comment-text w-100">

																		<div
																			class="d-flex justify-content-between align-items-start w-100">
																			<h6>${user.firstName }${user.lastName }</h6>
																			<c:if test="${commentList.updatedOn == null }">
																				<span> ${commentList.thisTimeAgo }</span>
																			</c:if>
																			<c:if test="${commentList.updatedOn != null }">
																				<span> ${commentList.thisTimeAgo } Edited</span>
																			</c:if>
																		</div>

																		<div id="commentDiv${commentList.id }">
																			<p id="commentId${commentList.id }">${commentList.comment }</p>

																			<div class="mt-2 d-flex justify-content-between">
																				<div>
																					<i
																						class="fa-solid fa-pen-to-square text-primary me-2"
																						onclick="editClick(${commentList.id})" title="Edit Comment"></i> <i
																						class="fa fa-file text-primary me-2"
																						aria-hidden="true"
																						onclick="getAllFiles(${commentList.id},${task.id})" title="Display Files"></i>

																					<i class="fa-solid fa-trash text-danger me-2"
																						onclick="deleteClick(${commentList.id})" title="Delete Comment"></i>

																					<div
																						class="img-thumbs-wrapper  d-flex justify-content-start align-items-center"
																						id="img_preview1${commentList.id }"></div>
																				</div>

																			</div>


																		</div>


																		<div
																			style="display: none; background-color: #e0e0e0; padding: 15px 30px 5px; margin-top: 10px; border-radius: 5px; position: relative;"
																			id="editDivId${commentList.id }">
																			<div class=" my-2">
																				<input type="hidden" value="${commentList.addedOn}"
																					id="addedOnId${commentList.id}">

																				<textarea type="text"
																					class="form-control edit-comment"
																					id="updateCommentInput${commentList.id}"
																					onchange="updateCommentFunction(this)"></textarea>

																				<label
																					class="btn btn-success btn-sm text-white comment-btn"
																					style="background-color: #198754;"> <i
																					class="fa-solid fa-paperclip  "></i> Attachment <input
																					class="show-for-sr" type="file"
																					id="commentAtt1${commentList.id }"
																					name="commentFiles1" multiple
																					style="display: none;"
																					onclick="uploadAttachmentFunction('${commentList.id}', '${commentList.comment}')"
																					onchange="cmdUpdateAttachmentChange(${commentList.id })"
																					accept="image/*" />
																				</label> <i
																					class="fa-sharp fa-solid fa-xmark   text-dark comment-xmark"
																					onclick="editClick(${commentList.id})"> </i>

																				<button class="btn btn-primary btn-sm  comment-btn"
																					onclick="update(${commentList.id})"
																					style="background-color: #3d8bfd;" type="button" id="updateCommentButton${commentList.id}">
																					<i class="fa-solid fa-circle-check  me-2"></i>Update
																				</button>
																			</div>
																		</div>



																	</div>
																</div>
															</div>
														</a>
													</c:if>
												</c:forEach>

											</c:forEach>
										</div>



									</div>

									<!-- -----------------------------comment code end --------------------  -->

									<!-- -----------------------------history code start --------------------  -->

									<div class="tab-pane fade" id="nav-history" role="tabpanel"
										aria-labelledby="nav-history-tab">
										<div class="col-md-12 mx-auto mt-3" id="historyParentDiv">

										</div>
									</div>
									<!-- -----------------------------history code end --------------------  -->

									<!-- -----------------------------Attachment code start --------------------  -->
									<div class="tab-pane fade" id="nav-attachments" role="tabpanel"
										aria-labelledby="nav-attachments-tab">

										<div class="row mt-3">
											<div class="col-md-12">
												<div
													class="d-flex justify-content-start align-items-center  attachments">
													<%-- <h5 class="col-form-label">
											<button style="outline: none" class="text-dark border-0"
												onclick="getTaskAttachments(${task.id})">Attachments
												:</button>
										</h5> --%>
													<label class="add-attachment-ui"> Add Attachment<i
														class="fa-solid fa-paperclip "></i> <input
														class="show-for-sr" type="file" id="upload_imgs"
														name="files" multiple style="display: none;" />
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

			</form>
		</div>

	</div>
	<script src="${pageContext.request.contextPath}/js/updateTask.js"></script>
	<script src="${pageContext.request.contextPath}/js/common.js"></script>
	<script src="${pageContext.request.contextPath}/js/validation.js"></script>
	<script src="${pageContext.request.contextPath}/js/addComment.js"></script>
	<script
		src="https://cdnjs.cloudflare.com/ajax/libs/magnific-popup.js/1.1.0/jquery.magnific-popup.min.js"></script>

	<script type="text/javascript">
	$(".edit-task").click(function(){
		$(".update-task-btn").css("display", "block");
		});
	
	
	$(".add-comment").click(function(){		
		const attachmentItems = document.getElementsByClassName('attachment-item');
	    while (attachmentItems.length > 0) {
	        attachmentItems[0].parentNode.removeChild(attachmentItems[0]);
	    }
		$(".send-comment").css("display", "block");
		});
	
	$(".comment-close-btn").click(function(){
		$(".send-comment").css("display", "none");
		});
	
	$("#addCommentBtn").click(function(){ 
		$(".send-comment").css("display", "none");
		});
	
	function setRemainingTime(){
		let originalTime = document.getElementById( 'originalEstimate' ).value;
		let timeTracked = document.getElementById( 'timeTracking' ).value;
		let originalTimeInMinute = convertTimeStringToMinutes( originalTime );
		let trackedTimeInMinute = convertTimeStringToMinutes(timeTracked );
		let remainingTimeInMinute = originalTimeInMinute - trackedTimeInMinute;
		let remainingTime  = convertMinutesToTimeString( remainingTimeInMinute );
		document.getElementById( 'remainingTime' ).value = remainingTime;
		
	}
	
	setRemainingTime();
	
	
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
		        console.log(originalTime);
		        $( "#update" ).submit();
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
				 $( "#update" ).submit();
			  }
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

	
	</script>
</body>
</html>