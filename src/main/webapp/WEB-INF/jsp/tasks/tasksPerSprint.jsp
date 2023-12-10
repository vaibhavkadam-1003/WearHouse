<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html>
	<head>
		<meta content="initial-scale=1, maximum-scale=1, user-scalable=0" name="viewport" />
		<meta name="viewport" content="width=device-width" />
		<link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
		<!-- Magnific Popup -->
		<link rel="stylesheet"
			href="https://cdnjs.cloudflare.com/ajax/libs/magnific-popup.js/1.1.0/magnific-popup.min.css">

		<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
		<%-- <link href="/${pageContext.request.contextPath}/css/style.css" rel="stylesheet"> --%>
		<script src="${pageContext.request.contextPath}/js/charts.js"></script>
		<script src="${pageContext.request.contextPath}/js/tasksPerSprint.js"></script>
		
		<jsp:include page="../common/header.jsp"></jsp:include>
		<jsp:include page="../tasks/updateTaskModal.jsp"></jsp:include>
		<link href="${pageContext.request.contextPath}/css/task.css" rel="stylesheet">

	</head>

	<body>
		<div class="main-content p-2">
			<div class="row sprint-title border-bottom ">
				<div class="col-6 mb-1">
					<span class="subnavigator-title" title="Scrum Sprint 13"> ${sprint.name }
					[${(sprint.startDate)} TO ${(sprint.lastDate)}]
						</span>
				</div>
				<%
			if (session.getAttribute("role").equals("Scrum Master") || session.getAttribute("role").equals("Project Manager")) {
			%>
				<div class="col-6 text-end mb-1">
					<a class="sprint-scrum-team"
						href="${pageContext.request.contextPath}/sprints/add-scrum-to-sprint-form">
									
						<i class="fa fa-users" aria-hidden="true"></i></a>

					<button id="ghx-complete-sprint" class="aui-button js-complete-sprint"
                           onclick="completeSprint('${pageContext.request.contextPath}',${sprint.id})">Complete                           
						Sprint</button>
						<button id="ghx-complete-sprint" class="aui-button js-complete-sprint"
                           onclick="sprintStatus('${pageContext.request.contextPath}',${sprint.id})">Sprint
						Status</button>
					
					<c:if test="${remianingSprintDays <3}">
						<span class="reamining-days-block" style="background: red;"><i
								class="fa-solid fa-clock mx-1"></i> ${remianingSprintDays } Days
							Remaining</span>
					</c:if>
					<c:if test="${remianingSprintDays >=3}">
						<span class="reamining-days-block"><i class="fa-solid fa-clock mx-1"></i> ${remianingSprintDays
							}
							Days Remaining</span>
					</c:if>
				</div>
				<%
			} else {
			%>
				<div class="col-6 text-end">
					<c:if test="${remianingSprintDays <3}">
						<span class="reamining-days-block" style="background: red;"><i
								class="fa-solid fa-clock mx-1"></i> ${remianingSprintDays } Days
							Remaining</span>
					</c:if>
					<c:if test="${remianingSprintDays >=3}">
						<span class="reamining-days-block"><i class="fa-solid fa-clock mx-1"></i> ${remianingSprintDays
							}
							Days Remaining</span>
					</c:if>
					<button id="ghx-sprint-status" class="aui-button js-sprint-status"
						 onclick="sprintStatus('${pageContext.request.contextPath}',${sprint.id})">Sprint Status</button>
				</div>
				<%
			}
			%>

			</div>
			<div class="d-flex justify-content-between align-items-center my-3 mx-3">
				<div class="d-flex justify-content-start align-items-center">
					<div style="position: relative;">
						<input type="search" class="user-search" placeholder="Search this board" /> <i
							class="fa-solid fa-magnifying-glass"></i>
					</div>
				
				</div>
				<div>
					<span class=" my-3 mx-3 total-story-points">Total Story Points : <span
							style="color: blue;">${completedStoryPointsPerSprint}/<span
								style="color: #a51515">${totalStoryPoints }</span></span></span>
				</div>

			</div>
			<div class="d-flex justify-content-center">
				<div class="col-12 col-offset-2 task-content border row">
					<div class="col-md-4 " style="background-color: #e7f1ff;">
						<div class="text-center  my-2">
							<h6>TO-DO</h6>
						</div>
					</div>
					<div class="col-md-4 "
						style="background-color: #e7f1ff; border-right: 3px solid #fff; border-left: 3px solid #fff;">
						<div class="text-center  my-2 ">
							<h6>In-Progress</h6>
						</div>
					</div>
					<div class="col-md-4 " style="background-color: #e7f1ff;">
						<div class="text-center  my-2">
							<h6>Fixed</h6>
						</div>
					</div>
					<c:forEach items="${data}" var="entry">
						<button class="collapsible-block  accordion-button  w-100  text-dark">${entry.key}
						
						
						 <c:set var="totalStoryPoints" value="0" />
						<c:set var="totalStoryPointsCompleted" value="0" />
						<c:set var="totalStoryPointsIncomplete" value="0" />
						<c:forEach items="${entry.value}" var="task">
						 <c:set var="totalStoryPoints" value="${totalStoryPoints + task.story_point}" />
							<c:choose>
								<c:when test="${task.status == 'Resolved'}">
									<c:set var="totalStoryPointsCompleted"
										value="${totalStoryPointsCompleted + task.story_point}" />
								</c:when>
								<c:otherwise>
									<c:set var="totalStoryPointsIncomplete"
										value="${totalStoryPointsIncomplete + task.story_point}" />
								</c:otherwise>
							</c:choose>
						</c:forEach>
                        <span style="margin-left: 10px;margin-right: 10px">Total Story Points: ${totalStoryPoints}</span>
						<span style="margin-right: 10px;">Completed Story Points: ${totalStoryPointsCompleted}</span>
						<span style="margin-right: 10px;">Incomplete Story Points:${totalStoryPointsIncomplete}</span>
    
				
						</button>
						<div class="content-block">
							<div class="row">
								<div class="col-md-4   bg-light px-2 ">
									<ul class="list-group bg-light" id="backlog-ul"
										style="border: dashed 1px #ddd; height: 150px;">
										<c:forEach items="${entry.value}" var="value">
											<c:if
												test="${(value.status != 'In-Progress') && (value.status != 'Resolved') && (value.status != 'Fixed')}">
												
														<li class="draggable context-menu-one p-1  list-group-item d-flex justify-content-between align-items-center"
														id="draggable" class="ui-widget-content" onclick="updateTask(${value.id},${value.project})"><a><span 
																class=" sprintBox-title "> ${value.title}</span></a>
														<div>
															<span
																class="badge d-none severity-high p-1 mx-3">${value.story_point
																}</span>
															<span class="badge  sprintBox-priority">${value.priority
																}</span>
															<span
																class="badge d-none rounded-pill bg-success p-1 mx-3 inP">${value.status
																}</span>
															<span
																class="badge d-none rounded-pill bg-success p-1 mx-3 d-none inP1">${value.id
																}</span>
														</div>
													</li>
												
											</c:if>

										</c:forEach>
									</ul>
								</div>

								<!-- -----------------------------------------------------------------------------------------------In Progress---------------------------------------------- -->
								<div class="col-md-4 border-right bg-light px-2 droppable">
									<%-- <c:forEach items="${data}" var="entry1"> --%>
									<div class="task-content ">

										<ul class="list-group in-progress-ul "
											style="border: dashed 1px #ddd; height: 150px;">
											<c:forEach items="${entry.value}" var="value1">

												<c:if test="${value1.status eq 'In-Progress'}">
													<li onclick="updateTask(${value1.id},${value1.project})"
														class="draggable context-menu-one p-1 ui-widget-content li-class  list-group-item d-flex justify-content-between align-items-center">
														<a><span class=" sprintBox-title ">
																${value1.title}</span></a>
														<div>
															<span
																class="badge severity-high p-1 d-none mx-3">${value1.story_point
																}</span>
															<span class="badge sprintBox-priority">${value1.priority
																}</span>
															<span
																class="badge rounded-pill d-none bg-success p-1 mx-3  inP">${value1.status
																}</span>
															<span
																class="badge rounded-pill d-none bg-success p-1 mx-3 d-none inP1">${value1.id
																}</span>
														</div>
													</li>
												</c:if>
											</c:forEach>
										</ul>
									</div>
									<%-- </c:forEach> --%>
								</div>
								<!-- ---------------------------------------------------------------------------Resolved & Fixed--------------------------------------------------------------------------- -->
								<div class="col-md-4 border-right bg-light resolved">
									<%-- <c:forEach items="${data}" var="entry1"> --%>
									<div class="task-content">

										<ul class="list-group in-progress-ul "
											style="border: dashed 1px #ddd; height: 150px;">
											<c:forEach items="${entry.value}" var="value1">

												<c:if test="${value1.status eq 'Resolved' || value1.status eq 'Fixed'}">
													<li onclick="updateTask(${value1.id},${value1.project})"
														class="draggable context-menu-one p-1 ui-widget-content li-class  list-group-item d-flex justify-content-between align-items-center">
														<a><span class=" sprintBox-title ">
																${value1.title}</span></a>
														<div>
															<span
																class="badge severity-high p-1 d-none mx-3">${value1.story_point
																}</span>
															<span class="badge sprintBox-priority">${value1.priority
																}</span>
															<span
																class="badge rounded-pill bg-success p-1 mx-3 d-none inP">${value1.status
																}</span>
															<span
																class="badge rounded-pill bg-success p-1 mx-3 d-none inP1">${value1.id
																}</span>
														</div>
													</li>
												</c:if>
											</c:forEach>
										</ul>
									</div>
									<%-- </c:forEach> --%>
								</div>
							</div>

						</div>
					</c:forEach>
					<div class="d-none">
						<form action="${pageContext.request.contextPath}/tasks/update/task1" method="POST"
							class="my-2 px-2 dragDropForm" enctype="multipart/form-data" name="dragDropForm">
							<input type="text" name="id" id="valueId"> <select class="  task-status"
								aria-label="Default select example" name="status" id="status">
								<option value="In-Progress">In-Progress</option>
								<option value="Fixed">Fixed</option>
							</select>
						</form>
					</div>
				</div>
			</div>
		</div>

		<div class="modal fade" id="sprintInfoModal" tabindex="-1" aria-labelledby="sprintInfoModalLabel"
			aria-hidden="true">

			<div class="modal-dialog  modals modal-xl">
				<div class="modal-content">
					<div class="modal-header">
						<h5 class="modal-title" id="sprintInfoModalLabel">Complete
							Sprint</h5>
						<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close">
							
						</button>
					</div>

					<div class="modal-body">
						<form action="${pageContext.request.contextPath}/sprints/close-sprint" method="post" class=""
							name="addSprint">
							<input type="hidden" name="sprintId" id="sprintId" value="${sprint.id }" />	
							<div id="id-backlog-task-ids">
							
							</div>						

							<div class="row">
								<div class="col-md-5 ">
									<div class="row m-2 bg-light rounded p-2  border" style="height: 250px;">
										<div class=" d-flex justify-content-evenly align-item-center flex-wrap">
											<a href="#" class="text-decoration-none">
												<div class="Project-card" style="background-color: #cfe2ff;">
													<p>All Task</p>
													<h6 id="sprint-total-task-count"></h6>
												</div>
											</a> <a href="#" class="text-decoration-none">
												<div class="Project-card" style="background-color: #d1e7dd;">
													<p>Completed</p>
													<h6 id="sprint-completed-task-count"></h6>
												</div>
											</a> <a href="#" class="text-decoration-none">
												<div class="Project-card" style="background-color: #f8d7da;">
													<p>Incompleted</p>
													<h6 id="sprint-incomplete-task-count"></h6>
												</div>
											</a> <a href="#" class="text-decoration-none">
												<div class="Project-card" style="background-color: #e2d9f3;">
													<p>Total Story Points</p>
													<h6 id="sprint-task-total-story-points"></h6>
												</div>
											</a> <a href="#" class="text-decoration-none">
												<div class="Project-card" style="background-color: #cff4fc;">
													<p>Completed Story Points</p>
													<h6 id="sprint-task-completed-story-points"></h6>
												</div>
											</a> <a href="#" class="text-decoration-none">
												<div class="Project-card" style="background-color: #fff3cd;">
													<p>Incompleted Story Points</p>
													<h6 id="sprint-task-incomplete-story-points"></h6>
												</div>
											</a> <a href="#" class="text-decoration-none">
												<div class="Project-card scrum-team-card"
													style="background-color: #ffe5d0;">
													<p>Scrum Development Team</p>
													<h6 id="sprint-task-scrum-team">6</h6>
												</div>
											</a>
										</div>
									</div>
								</div>

								<div class="col-md-7 ">
									<div class="row m-2 bg-light rounded p-2� border" style="height: 250px;">
										<div id="complete-sprint-bar-chart" class="mx-auto my-2"></div>

									</div>
								</div>
							</div>

							<div class="row">
							<div class="col-md-12">
								<div class="row m-2 bg-light rounded p-2 border" id="taskContainer">					
									<label for="duration" class="col-sm-12 fw-bold ms-2">
										Carry forward task to next sprint </label>
									<!-- <div>
										<input type="checkbox" name="allTaskToDelete" class="mx-2"
											value="true" id="all-tasks-complete-sprint" /> All Tasks
									</div> -->
									<ul class="list-group" id="complete-sprint-tasks">
									</ul>
									<input type="hidden" name="taskIdsToDelete" id="taskIdListTodelete">
									<div id="newSprintasks">
									</div>
								</div>
							</div>
							
							<div class="mx-auto text-center mt-3">
									<button type="button" class="btn btn-secondary btn-sm"
									data-bs-dismiss="modal">Close</button>
									<button type="submit" class="btn btn-primary Pluck-btn btn-sm"
										id="user-add">Complete</button>
								</div>
							</div>

						</form>

					</div>
				</div>
			</div>
		</div>



		<div class="modal fade" id="sprintStatusModal" tabindex="-1" aria-labelledby="sprintStatusModalLabel"
			aria-hidden="true">

			<div class="modal-dialog  modals modal-xl">
				<div class="modal-content">
					<div class="modal-header px-4 py-2">
						<div>
							<h5 class="modal-title" id="sprintStatusModalLabel">Sprint
								Status</h5>
							<div style="font-size: 12px;" class="my-1">
								<i class="fa fa-hourglass-half mx-1"></i> <span id="sprint-remaining-days"
									style="font-size: 12px; color: #6061b8;"></span>
							</div>

						</div>

					<button type="button" class="btn-close" data-bs-dismiss="modal"
						aria-label="Close">
					</button>
				</div>


					<div class="modal-body">

						<form action="${pageContext.request.contextPath}/sprints/close-sprint" method="get" class=""
							name="addSprint">
							<input type="hidden" name="sprintId" id="sprintId" value="${sprint.id }" />							
							
							<div class="row">
								<div class="col-md-3">
									<ul class="list-group" id="sprint-scrum-team-list"></ul>
								</div>
							</div>
							<div class="row">
								<div class="col-md-4  p-0">
									<div class="row m-2 bg-light rounded p-2  border" style="height: 250px;">
										<div class=" d-flex justify-content-evenly align-item-center flex-wrap">
											<a href="#" class="text-decoration-none">
												<div class="Project-card" style="background-color: #cfe2ff;">
													<p>All Task</p>
													<h6 id="sprint-total-issue-count"></h6>
												</div>
											</a> <a href="#" class="text-decoration-none">
												<div class="Project-card" style="background-color: #d1e7dd;">
													<p>Completed</p>
													<h6 id="sprint-completed-issue-count"></h6>
												</div>
											</a> <a href="#" class="text-decoration-none">
												<div class="Project-card" style="background-color: #f8d7da;">
													<p>Incompleted</p>
													<h6 id="sprint-incomplete-issue-count"></h6>
												</div>
											</a> <a href="#" class="text-decoration-none">
												<div class="Project-card" style="background-color: #e2d9f3;">
													<p>Total Story Points</p>
													<h6 id="sprint-total-story-points"></h6>
												</div>
											</a> <a href="#" class="text-decoration-none">
												<div class="Project-card" style="background-color: #cff4fc;">
													<p>Completed Story Points</p>
													<h6 id="sprint-completed-story-points"></h6>
												</div>
											</a> <a href="#" class="text-decoration-none">
												<div class="Project-card" style="background-color: #fff3cd;">
													<p>Incompleted Story Points</p>
													<h6 id="sprint-incomplete-story-points"></h6>
												</div>
											</a> <a href="#" class="text-decoration-none">
												<div class="Project-card scrum-team-card"
													style="background-color: #ffe5d0;">
													<p id="sprint-scrum-team-list-1">Scrum Development Team</p>
													<h6 id="current-sprint-scrum-team-list"></h6>
												</div>
											</a>
										</div>
									</div>
								</div>

								<div class="col-md-4  p-0">
									<div class=" m-2 bg-light rounded p-2 text-center mx-auto  border"
										style="height: 250px;">
										<div id="piechart" class="border bg-white"></div>
									</div>
								</div>

								<div class="col-md-4  p-0">
									<div class=" m-2 bg-light rounded p-2  border" style="height: 250px;">
										<div id="columnchart_values" class="border bg-white"></div>
									</div>
								</div>

							</div>

							<div class="row">

								<div class="col-md-12 p-0">
								       <div  id="no-data-div" class=" mx-2 my-1 bg-light rounded p-2  border" style="  height: 250px; position: relative;">
									    <div style=" position: absolute;  top: 44%; left: 44%;">No data available</div>
									   </div>
									   <div id="data-div" class=" mx-2 my-1 bg-light rounded p-2  border" style="height: 250px;">
										<div id="chart_div" class="border"></div>
									   </div>
								</div>

							</div>
							<div class="card col-md-12 border my-1 p-0">

								<div class="card-body card-height d-flex justify-content-between">
									<button style="display: none;"
										id="all-tasks-sprint-status"></button>
									<div style="width: 108px;">
										<select class="form-select"
											onchange="taskFilter('${pageContext.request.contextPath}',${sprint.id},this)">
											<option selected value="All">All Task</option>
											<option value="Resolved">Completed</option>
											<option value="Incomplete">Incomplete</option>
										</select>
									</div>

								</div>
								<div class="px-3 mb-2">
									<ul class="list-group" id="sprint-task-top">
									</ul>
								</div>
							</div>


							<div class="mb-12 row">
								<div class="mt-3">
									<button type="button" class="btn btn-secondary btn-sm"
									data-bs-dismiss="modal">Close</button>
								</div>
							</div>
						</form>

					</div>
				</div>
			</div>
		</div>
		<script src="https://code.jquery.com/ui/1.13.0/jquery-ui.min.js"></script>
	</body>

	<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
	<script
		src="https://cdnjs.cloudflare.com/ajax/libs/magnific-popup.js/1.1.0/jquery.magnific-popup.min.js"></script>
	<script>
		var coll = document.getElementsByClassName( "collapsible-block" );
		var i;

		for ( i = 0; i < coll.length; i++ ) {
			coll[ i ].addEventListener( "click", function () {
				this.classList.toggle( "active" );
				var content = this.nextElementSibling;
				if ( content.style.maxHeight ) {
					content.style.maxHeight = null;
				} else {
					content.style.maxHeight = content.scrollHeight + 116 + "px";
				}
			} );
		}
	</script>

	<script type="text/javascript">
		google.charts.load( 'current', {
			'packages': [ 'corechart' ]
		} );
		google.charts.setOnLoadCallback( drawVisualization );
		function drawVisualization () {
			// Some raw data (not necessarily accurate)
			let mydata = google.visualization.arrayToDataTable( [
				[ 'User', 'total', 'complete', 'incomplete' ],
				[ 'Manohar', 21, 4, 17 ], [ 'Sachin', 27, 20, 7 ],
				[ 'Vaibahv', 13, 8, 5 ], [ 'Pournima', 31, 17, 15 ],
				[ 'Sagar', 40, 25, 15 ] ] );

			var options = {
				title: 'User Assignment Status',
				vAxis: {
					title: 'Tasks'
				},
				hAxis: {
					title: 'User'
				},
				seriesType: 'bars',
				series: {
					5: {
						type: 'line'
					}
				}
			};

		}
	</script>