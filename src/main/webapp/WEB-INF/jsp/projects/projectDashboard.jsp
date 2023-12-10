<%@page import="com.pluck.dto.LoginUserDto"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<script src="https://code.jquery.com/jquery-3.6.1.js"
	integrity="sha256-3zlB5s2uwoUzrXK3BT7AX3FyvojsraNFxCc2vC/7pNI="
	crossorigin="anonymous"></script>
<
<style>
.badge-soft-inActive {
	color: #e65555 !important;
	font-size: 0.7rem !important;
	border: 1px solid #dc3545 !important;
}

.project-bar {
	background-color: #f2f2f2;
	height: 30px;
	width: 300px;
	border: 1px solid #ccc;
}

.completed-tasks {
	background-color: #5cb85c;
	height: 100%;
	width: 0;
	transition: width 0.5s;
}

.project-details-all h4 {
	font-size: 14px;
	font-weight: 600;
	color: #222;
	border-bottom: 10px;
}

.project-details-all h5 {
	font-size: 17px;
	font-weight: 600;
	color: #0052cc;
}

.project-details-all h6 {
	font-size: 14px;
	font-weight: 600;
	color: #333;
	margin-bottom: 20px;
}

.project-details-all p {
	font-size: 13px;
	font-weight: 500;
	color: #333;
	margin-bottom: 20px;
}

.project-details-all small {
	font-size: 11px;
	font-weight: 500;
	color: #333;
	margin-bottom: 10px;
}

.project-details-all .project-avatar-title {
	align-items: center;
	background-color: #556ee6;
	color: #fff;
	display: flex;
	font-weight: 500;
	height: 30px;
	width: 30px;
	border-radius: 50px;
	justify-content: center;
	border: 1px solid #192e96;
	margin-right: 15px;
	text-transform: capitalize;
}

.project-details-all ul li {
	font-size: 13px;
	font-weight: 500;
	color: #666;
	margin-bottom: 10px;
	margin-right: 50px;
	cursor: pointer;
	padding: 5px 7px;
	border-radius: 5px;
	border: 1px solid #0000;
}

.project-details-all ul li:hover {
	background-color: #eee;
	color: #0052cc;
	border: 1px solid #e0e0e0;
}

.project-details-all .list-group-item-action {
	width: 16rem;
}

.project-details-all .list-group-item-action:hover {
	background-color: #e0e0e0;
	color: #0052cc;
	border: 1px solid #ccc;
}
</style>
<body>
	<jsp:include page="../common/header.jsp"></jsp:include>



	<div class="main-content" style="margin-top: -30px;">
		<div class="project-details-all ">
			<div class="row border-bottom mb-2 pb-2">
				<div
					class="col-md-3 border-end py-2 px-3  bg-light d-flex align-items-center justify-content-center">
					<i class="fa fa-briefcase" aria-hidden="true"
						style="font-size: 100px; color: #ccc"></i>

					<%-- <img src="${pageContext.request.contextPath}/images/images.png"
						class="img-thumbnail" alt="..."> --%>
				</div>
				<div class="col-md-9">
					<div class="ms-2">
						<h5>${project.name}</h5>
						<p>${project.description}</p>

						<ul>
							<li>The project started on : <b> ${project.startDate } </b></li>
							<li>The project last date is : <b> ${project.lastDate } </b>
							</li>
							<li>The project is <span class="text-success fw-bold">
									<c:choose>
										<c:when test="${project.status eq 'Active'}">
											<a class="badge badge-soft-primary font-size-11 m-1">${project.status}</a>
										</c:when>
										<c:otherwise>
											<button type="button"
												class="badge in-active font-size-11 m-1"
												style="color: #e65555; font-size: 0.7rem; border: 1px solid rgb(230 85 85/ 40%">
												${project.status}</button>
										</c:otherwise>
									</c:choose>
							</span></li>
						</ul>
					</div>
				</div>
			</div>





			<div class="row">
				<div class="col-md-12 py-3  border-bottom">
					<h4>Project Owners</h4>


					<div
						class=" d-flex justify-content-start align-item-centar flex-wrap">


						<c:forEach items="${project.owners}" var="owner">
							<div class="col-md-3 ">
								<a
									href="${pageContext.request.contextPath}/dashboard/user/${owner.id}"
									class="list-group-item list-group-item-action me-2 border rounded"
									style="background-color: #e0cffc;">
									<div class="d-flex w-100 justify-content-start">
										<div class="project-avatar-title pluck-capitalize">
											<i class="fa fa-user" aria-hidden="true"></i>
										</div>
										<div class="ps-2 border-start">
											<h6 class="mb-1">${owner.firstName } ${owner.lastName }
											</h6>
											<small class="text-muted">${owner.role }
												${owner.username}</small>
										</div>
									</div>
								</a>
							</div>
						</c:forEach>



					</div>
				</div>
				<div class="col-md-12 py-3 border-bottom">
					<h4>Project Users</h4>
					<div>
						<div
							class=" d-flex justify-content-start align-item-centar flex-wrap">
							<c:forEach items="${project.users}" var="users">
								<a
									href="${pageContext.request.contextPath}/dashboard/user/${users.id}"
									class="list-group-item list-group-item-action me-2 mb-2 border rounded"
									style="background-color: #d1e7dd;">
									<div class="d-flex w-100 justify-content-start">
										<div class="project-avatar-title pluck-capitalize">
											<i class="fa fa-user" aria-hidden="true"></i>
										</div>
										<div class="ps-2 border-start">
											<h6 class="mb-1">${users.firstName }${users.lastName }</h6>
											<small class="text-muted">${users.role }
												${users.username}</small>
										</div>
									</div>
								</a>
							</c:forEach>

						</div>
					</div>
				</div>
				<c:if test="${activeSprints != null}">
				<div class="col-md-12 py-3 border-bottom">
					<h4>Active Sprint</h4>
					<div>
						<div
							class=" d-flex justify-content-start align-item-centar flex-wrap">

							<a
								href="${pageContext.request.contextPath}/dashboard/stories/${project.id}/${activeSprints.id}"
								class="list-group-item list-group-item-action me-2 border rounded"
								style="background-color: #cfe2ff;">
								<div class="d-flex w-100 justify-content-start">
									<div class="project-avatar-title pluck-capitalize">
										<i class="fa fa-hourglass-half" aria-hidden="true"></i>
									</div>
									<div class="ps-2 border-start">
										<h6 class="mb-1 mt-2">${activeSprints.name}</h6>
									</div>
								</div>
							</a>

						</div>		
					</div>
				</div>
				</c:if>
				<div class="col-md-12 py-3 border-bottom">
					<h4>Previous Sprint</h4>
					<div>
						<div
							class=" d-flex justify-content-start align-item-centar flex-wrap">


							<c:forEach items="${previousSprints}" var="sprint">
								<a
									href="${pageContext.request.contextPath}/sprints/sprint-history/${sprint.id}"
									class="list-group-item list-group-item-action me-2 border rounded"
									style="background-color: #f8d7da;">
									<div class="d-flex w-100 justify-content-start">
										<div class="project-avatar-title pluck-capitalize">
											<i class="fa fa-hourglass-end" aria-hidden="true"></i>
										</div>
										<div class="ps-2 border-start">
											<h6 class="mb-1 mt-2">${sprint.name}</h6>
										</div>
									</div>
								</a>
							</c:forEach>

						</div>
					</div>
				</div>
				<div class="col-md-12 py-3 border-bottom">
					<h4>Project Scrum Team</h4>
					<div>
						<div
							class=" d-flex justify-content-start align-item-centar flex-wrap">

							<c:forEach var="entry" items="${scrumTeams}">
								<a href="${pageContext.request.contextPath}/scrums/details/${entry.id}/${project.id}"
									class="list-group-item list-group-item-action me-2 border rounded"
									style="background-color: #ffe5d0;">
									<div class="d-flex w-100 justify-content-start">
										<div class="project-avatar-title pluck-capitalize">
											<i class="fa fa-users" aria-hidden="true"></i>
										</div>
										<div class="ps-2 border-start">
											<h6 class="mb-1 mt-2">${entry.name}</h6>
											<small class="text-muted">Member : ${entry.members }</small>
										</div>
									</div>
								</a>
							</c:forEach>

						</div>
					</div>
				</div>

				<div class="col-md-12 bg-light p-2 border">
					<h4>Project Tasks</h4>
					<div class="card col-md-12 border my-1 p-0">
						<div class="card-body card-height">
							<div class="d-flex justify-content-between align-items-center">
								<button type="button"
									class="btn btn-outline-secondary btn-sm my-2"
									onclick="getTask(${projectId})" id="all-tasks-sprint-status"
									style="padding: 1px 10px">All Task</button>
								<div style="width: 120px;">
									<select class="form-select"
										onchange="taskFilter('${projectId}',this)">
										<option selected value="All">All</option>
										<option value="Resolved">Completed</option>
										<option value="Incomplete">Incomplete</option>
									</select>
								</div>
							</div>
							<div class="px-3 mb-2">
								<ul class="list-group" id="sprint-task-top">
								</ul>
							</div>
							</ul>
							<div class="text-end">
								<div class="text-end">
									<button type="button"
										onclick="getMoreTaskForProject(${projectId})"
										class="btn btn-link text-end more-btn mb-2">Show
										More...</button>
								</div>
							</div>
						</div>
					</div>
				</div>

			</div>
		</div>
	</div>

	<script type="text/javascript">
		  /*   var completedTasksElement = document.getElementById('completedTasks');
		    var completedTasksWidth = ${activeSprints.completedTasksWidth}
		    completedTasksElement.style.width = completedTasksWidth + '%'; */
		   
			function getTask(projectId){
			 	$
				.ajax({
					type : "GET",
					url :'${pageContext.request.contextPath}/tasks/top-five-tasks-by-project/'
						+ projectId,
					async : false,
					success : function(data) {
						document.getElementById('all-tasks-sprint-status').setAttribute('disabled','disabled');
						for (var i = 0; i < data.length; i++) {
							let temp = data[i];
							let li = document.createElement('li');
							li.setAttribute('class','draggable py-1 list-group-item ui-draggable ui-draggable-handle border m-0 rounded-0');
							li.setAttribute('id','draggable');
							
						   var tag = document.createElement("a");
						   let taskId=temp.id;
						   tag.setAttribute('href',"${pageContext.request.contextPath}/tasks/updateTaskForm/"+taskId);
						  
							
							let div1 = document.createElement('div');
							div1.setAttribute('class','row');
							
							
							let div2 = document.createElement('div');
							div2.setAttribute('class','col-md-9');
							
							
							let span1 = document.createElement('span');
							span1.setAttribute('class',' sprintBox-title ');
							span1.innerHTML=temp.title;
							div2.appendChild(span1);
							div1.appendChild(div2);
							
							
							let div3 = document.createElement('div');
							div3.setAttribute('class','col-md-3 ');
							
							let div4 = document.createElement('div');
							div4.setAttribute('class','d-flex justify-content-between align-items-center');
							
							let div5 = document.createElement('div');
							div5.setAttribute('class','col-md-3 ');
							let span2 = document.createElement('span');
							span2.setAttribute('class','badge severity-high ');
							span2.innerHTML=temp.story_point;
							div5.appendChild(span2);
							
							let div6 = document.createElement('div');
							div6.setAttribute('class','col-md-4 ');
							let span3 = document.createElement('span');
							span3.setAttribute('class','badge sprintBox-priority');
							span3.innerHTML=temp.priority;
							div6.appendChild(span3);
							
							let div7 = document.createElement('div');
							div7.setAttribute('class','col-md-5 ');
							let span4 = document.createElement('span');
							span4.setAttribute('class','badge rounded-pill bg-success ');
							span4.innerHTML=temp.status;
							div7.appendChild(span4);
							
							div4.appendChild(div5);
							div4.appendChild(div6);
							div4.appendChild(div7);
							div3.appendChild(div4);
							div1.appendChild(div2);
							div1.appendChild(div3);
							
							li.appendChild(div1);
							tag.appendChild(li);
							
							document.getElementById('sprint-task-top').appendChild(tag);
							
					}
					}
				});
		 }
			
			function buildTaskList(data) {
				for (var i = 0; i < data.length; i++) {
					let temp = data[i];
					let li = document.createElement('li');
					li.setAttribute('class',
							'draggable py-1 list-group-item ui-draggable ui-draggable-handle border');
					li.setAttribute('id', 'draggable');
					let div1 = document.createElement('div');
					div1.setAttribute('class', 'row');
					let div2 = document.createElement('div');
					div2.setAttribute('class', 'col-md-9');
					let span1 = document.createElement('span');
					span1.setAttribute('class', ' sprintBox-title ');
					span1.innerHTML = temp.title;
					div2.appendChild(span1);
					div1.appendChild(div2);
					let div3 = document.createElement('div');
					div3.setAttribute('class', 'col-md-3 ');
					let div4 = document.createElement('div');
					div4
						.setAttribute('class',
							'd-flex justify-content-between align-items-center');
					let div5 = document.createElement('div');
					div5.setAttribute('class', 'col-md-3 ');
					let span2 = document.createElement('span');
					span2.setAttribute('class', 'badge severity-high ');
					span2.innerHTML = temp.story_point;
					div5.appendChild(span2);
					let div6 = document.createElement('div');
					div6.setAttribute('class', 'col-md-4 ');
					let span3 = document.createElement('span');
					span3.setAttribute('class',
						'badge sprintBox-priority');
					span3.innerHTML = temp.priority;
					div6.appendChild(span3);
					let div7 = document.createElement('div');
					div7.setAttribute('class', 'col-md-5 ');
					let span4 = document.createElement('span');
					span4.setAttribute('class',
						'badge rounded-pill bg-success ');
					span4.innerHTML = temp.status;
					div7.appendChild(span4);
					div4.appendChild(div5);
					div4.appendChild(div6);
					div4.appendChild(div7);
					div3.appendChild(div4);
					div1.appendChild(div2);
					div1.appendChild(div3);
					li.appendChild(div1);
					document.getElementById('sprint-task-top')
						.appendChild(li);
				}
			}
			var selectedPojectIdForProject = ${projectId};

			  function getMoreTaskForProject(projectId) {
					let a = document.createElement('a');
					let url ="${pageContext.request.contextPath}/tasks/all-tasks/"+selectedPojectIdForProject+"?pageNo=0"
					a.setAttribute('href',url);
					a.click();
				}
			  
			  function taskFilter(projectId, e) {
					document.getElementById('sprint-task-top').innerHTML = "";
					$
						.ajax({
							type: "GET",
							url: "${pageContext.request.contextPath}/tasks/tasks/filter?project=" + projectId+"&&status="+e.value,
							async: false,
							
						    contentType: "application/json",
							success: function(data) {
								document.getElementById('all-tasks-sprint-status').setAttribute('disabled', 'disabled');
								if (data.length == 0) {
									var div4 = document.createElement('div');
									div4.style.height = "17vh";
									div4.setAttribute('class', 'scrume-add-msg');
									var i1 = document.createElement('i');
									i1.setAttribute('class', 'fa fa-tasks ');
									i1.setAttribute('aria-hidden', 'true');
									div4.appendChild(i1);
									var h3 = document.createElement('h3');
									h3.innerHTML = "No Tasks are available for this category";
									div4.appendChild(h3);
									document.getElementById('sprint-task-top').appendChild(div4);
								} else {
									buildTaskList(data);
								}
							}
						});
				}
			
			</script>
</body>
<jsp:include page="../common/footer.jsp"></jsp:include>