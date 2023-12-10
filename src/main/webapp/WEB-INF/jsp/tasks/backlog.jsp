<%@page import="com.pluck.dto.LoginUserDto"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html>
<head>
<meta content="initial-scale=1, maximum-scale=1, user-scalable=0"
	name="viewport" />
<meta name="viewport" content="width=device-width" />

<!-- Datatable plugin CSS file -->
<link rel="stylesheet"
	href="https://cdn.datatables.net/1.10.22/css/jquery.dataTables.min.css" />

<!-- jQuery library file -->
<script type="text/javascript"
	src="https://code.jquery.com/jquery-3.5.1.js">
	
</script>



<!-- Datatable plugin JS library file -->
<script defer type="text/javascript"
	src="https://cdn.datatables.net/1.10.22/js/jquery.dataTables.min.js">
	
</script>


<script src="${pageContext.request.contextPath}/js/common.js"></script>

<link
	href="https://swisnl.github.io/jQuery-contextMenu/dist/jquery.contextMenu.css"
	rel="stylesheet" type="text/css" />

<script
	src="https://swisnl.github.io/jQuery-contextMenu/dist/jquery.contextMenu.js"
	defer type="text/javascript"></script>

<script
	src="https://swisnl.github.io/jQuery-contextMenu/dist/jquery.ui.position.min.js"
	defer type="text/javascript"></script>
	
	<link href="${pageContext.request.contextPath}/css/task.css" rel="stylesheet">

</head>
<body>
	<jsp:include page="../common/header.jsp"></jsp:include>
	<jsp:include page="../tasks/updateTaskModal.jsp"></jsp:include>
	<div class="main-content ">
		<div id="main-content-div">
			<div class="row">
				<div class="col-md-6" id="pendingStoryPointsDiv">
					<div class="card p-2"  id="scrum-sprint-title">
						<div class="d-flex justify-content-between align-items-center mb-2 border-bottom">
							<div  >
								<h6>Backlog <small class="text-muted">${backlogs.size()} issues</small></h6>
								<small class="me-2 fw-normal text-muted "> 
							 	<b>Total Story Points : ${pendingStoryPoints }</b>
							 </small>
							</div>
							<div>
								<select id="filterTaskType" class="btnTaskType dropdown-toggle mx-3 btn-sm" type="button" id="dropdownMenuButton" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"
								onchange="filterData()">
								<option value="" selected>All Task</option>
								<option value="Task">Task</option>
								<option value="Bug">Bug</option>
								<option value="User Story">Story</option>
								<option value="Epic">Epic</option>
							</select>
								
								<select id="filterPriority" class="btnTaskType dropdown-toggle btn-sm" type="button" id="dropdownMenuButton" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
								<option value="" selected>All Priority</option>
								<option value="High">High</option>
								<option value="Medium">Medium</option>
								<option value="Low">Low</option>
							</select>
							
							</div>
							
							
							
							  
						</div>

						<div class="bg-light">
							<ul class="list-group border-0" id="backlog-ul"> 
						<c:forEach items="${backlogs}" var="task">
							<li style="cursor: pointer;"  class="context-menu-one p-1  list-group-item list-group-item-filter" data-taskType="${task.taskType}" data-priority="${task.priority}" data-sprintId="${sprintData.id}"  data-taskId="${task.id}" onclick="updateTask(${task.id})" id="draggable" class="ui-widget-content" title="${pageContext.request.contextPath}/sprints/tasks?id=${task.id}">
							<div class="row">
								<div class="col-md-9">
								
								<c:choose>
										<c:when test="${task.taskType eq 'Task'}">
											<i class="fa fa-check-square text-primary" aria-hidden="true"></i>
										</c:when>
										<c:when test="${task.taskType eq 'Bug'}">
											<i class="fa fa-stop-circle text-danger" aria-hidden="true"></i>
										</c:when>
										<c:when test="${task.taskType eq 'User Story'}">
											<i class="fa fa-bookmark text-success" aria-hidden="true"></i>
										</c:when>
										<c:otherwise>
											<i class="fa-solid fa-bolt" aria-hidden="true" style="color: #904ee2; font-size: 17px"></i>
										</c:otherwise>
										
									</c:choose>
									<span class=" scrum-sprint-action" style="background-color: #0096889e;"> ${task.ticket}</span>
									<span style="font-weight: 400"> ${task.title}</span>
								</div>
										<div class="col-md-3 text-end"> 
											<span class="scrum-sprint-action" style="background-color: #dc35459c;">${task.priority }</span>
											<span class="scrum-sprint-action " style="background-color: #6ea8fe;">${task.status }</span>
											<c:choose>
												<c:when test="${task.story_point == null || empty task.story_point}">
													<span class="scrum-sprint-action" style="background-color: #feb272;">0</span>
												</c:when>
												<c:otherwise>
													<span class="scrum-sprint-action" style="background-color: #feb272;">${task.story_point }</span>
												</c:otherwise>
											</c:choose>
										</div>
									</div>
							</li>
						</c:forEach>
							
						</ul>
						</div>

					</div>
				</div>

				<div class="col-md-6"> 
					<div class="card p-2" id="scrum-sprint-title">
						<c:forEach items="${sprintDataList}" var="sprintData">
							<div
								class="d-flex justify-content-between align-items-center border-bottom sprint-info"
								onclick="toggleCollapsible(this)">
								<div>
									<h6 style="cursor: pointer;">Scrum ${sprintData.sprintName }</h6>
									<small class="text-muted">${sprintData.currentSprintTasks.size()}
										issues</small>
								</div>
								<small class="mx-2 fw-normal text-muted "> <b>Total
										Story Points : ${sprintData.currentSprintTotalStoryPoints }</b>
								</small>
							</div>
							<ul class="list-group border-0 sprint-tasks"
								style="display: none;" id="sprint-task-top">
								<c:forEach items="${sprintData.currentSprintTasks}" var="task">
									<li class="py-1 list-group-item " id="draggable"
										class="ui-widget-content" onclick="updateTask(${task.id})" style="cursor: pointer;">
										<div class="row">
											<div class="col-md-9">
												<c:choose>
													<c:when test="${task.taskType eq 'Task'}">
														<i class="fa fa-check-square text-primary"
															aria-hidden="true"></i>
													</c:when>
													<c:when test="${task.taskType eq 'Bug'}">
														<i class="fa fa-stop-circle text-danger"
															aria-hidden="true"></i>
													</c:when>
													<c:when test="${task.taskType eq 'User Story'}">
														<i class="fa fa-bookmark text-success" aria-hidden="true"></i>
													</c:when>
													<c:otherwise>
														<i class="fa-solid fa-bolt" aria-hidden="true"
															style="color: #904ee2; font-size: 17px"></i>
													</c:otherwise>
												</c:choose>
												<span class=" scrum-sprint-action"
													style="background-color: #0096889e;"> ${task.ticket}</span>
												<span class=" " style="font-weight: 400"> ${task.title}</span>
											</div>
											<div class="col-md-3 text-end">
												<span class="scrum-sprint-action"
													style="background-color: #dc35459c;">${task.priority }</span>
												<span class="scrum-sprint-action"
													style="background-color: #6ea8fe;">${task.status }</span>
												<c:choose>
													<c:when
														test="${task.story_point == null || empty task.story_point}">
														<span class="scrum-sprint-action"
															style="background-color: #feb272;">0</span>
													</c:when>
													<c:otherwise>
														<span class="scrum-sprint-action"
															style="background-color: #feb272;">
															${task.story_point }</span>
													</c:otherwise>
												</c:choose>
											</div>
										</div>
									</li>
								</c:forEach>
							</ul>
						</c:forEach>
					</div>
				</div>
			</div>

			</div>
		</div>
	</div>
	<script src="https://code.jquery.com/jquery-3.6.0.js"></script>
	<script src="https://code.jquery.com/ui/1.13.2/jquery-ui.js"></script>

	<script>
	
	var sprintDataList = [
	    <c:forEach items="${sprintDataList}" var="sprintData" varStatus="loop">
	        {
	            name: '${sprintData.sprintName}',
	            id: '${sprintData.sprintId}'
	        }${!loop.last ? ',' : ''}
	    </c:forEach>
	];
	
	 function generateSprintMenuItems() {
	        var items = {};

	        sprintDataList.forEach(function (sprintData) {
	        	if (sprintData.name.trim() !== '') {
	            	  items['sprint_' + sprintData.id] = {
	            	  name: sprintData.name,
	            	  id: sprintData.id,
	                    icon: 'add',
	                    callback: function (key, options) {
	                    	 var sprintId = sprintData.id;
	                         var taskId = options.$trigger.attr('data-taskId');
	                        $.ajax({
	                            type: "GET",
	                            url: options.$trigger.attr("title"),
	                            data: {
                                    taskId: taskId,
                                    sprintId: sprintId
                                },
	                            contentType: "application/json",
	                            async: false,
	                			success : function(data) {
									if (!data) {								                   
									    toastr.error("Sprint not Started yet..!");
					                } else {
									let ul = document
											.getElementById('sprint-task-top');
									let li = document
											.createElement('li');
									li
											.setAttribute(
													'class',
													'context-menu-one p-1  list-group-item d-flex justify-content-between align-items-center');
									let a = document
											.createElement('a');

									let titleSpan = document
											.createElement('span');
									titleSpan.setAttribute(
											'class',
											'sprintBox-title');
									titleSpan.innerHTML = data.title;

									let btnDiv = document
											.createElement('div');

									let storySpan = document
											.createElement('span');
									storySpan
											.setAttribute(
													'class',
													'badge severity-high p-1 mx-3');
									storySpan.innerHTML = data.story_point;

									let prioritySpan = document
											.createElement('span');
									prioritySpan
											.setAttribute(
													'class',
													'badge sprintBox-priority');
									prioritySpan.innerHTML = data.priority;

									let statusSpan = document
											.createElement('span');
									statusSpan
											.setAttribute(
													'class',
													'badge rounded-pill bg-success p-1 mx-3');
									statusSpan.innerHTML = data.status;

									a.appendChild(titleSpan);
									btnDiv
											.appendChild(storySpan);
									btnDiv
											.appendChild(prioritySpan)
									btnDiv
											.appendChild(statusSpan)
									li.appendChild(a);
									li.appendChild(btnDiv);
									ul.appendChild(li);
									
									 $("#main-content-div")
									.load(
											" #main-content-div"); 
								 	$(
											"#currentSprintTotalStoryPointsDiv")
											.load(
													" #currentSprintTotalStoryPointsDiv");
									$("#pendingStoryPointsDiv")
											.load(
													" #pendingStoryPointsDiv"); 

									var ulTag = document.getElementById('backlog-ul');
							        var liTags = ulTag.getElementsByTagName('li');
							        for (var i = 0; i < liTags.length; i++) {
							            if (liTags[i].title == options.$trigger.attr("title")) {
							                ulTag.removeChild(liTags[i]);
							            }
							        }

								}
							 },
	                        });
	                    },
	                };
	            }
	        });

	        return items;
	    }

	   $(function () {
	        $.contextMenu({
	            selector: '.context-menu-one',
	            items: generateSprintMenuItems(),
	        });
	    });
	</script>
	<script src="${pageContext.request.contextPath}/js/backlog.js"></script>
</body>

</html>
