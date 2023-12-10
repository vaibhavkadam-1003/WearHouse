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
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/magnific-popup.js/1.1.0/magnific-popup.min.css">

<!-- jQuery library file -->
<script type="text/javascript"
	src="https://code.jquery.com/jquery-3.5.1.js">
	
</script>

<!-- Datatable plugin JS library file -->
<script defer type="text/javascript"
	src="https://cdn.datatables.net/1.10.22/js/jquery.dataTables.min.js">
	
</script>
<script src="${pageContext.request.contextPath}/js/common.js"></script>
<link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
<jsp:include page="../tasks/updateTaskModal.jsp"></jsp:include>
</head>
<body>
	<jsp:include page="../common/header.jsp"></jsp:include>

	<div class="main-content"
		style="position: relative; height: 90vh !important; overflow-y: auto;">
		

		<div class="row project-scrum-team">
			<c:if test="${scrumTeams.size()>0}">
			<p
				class="d-flex justify-content-center align-items-center field-status">Scrum
				Teams</p>
			</c:if>
			<c:forEach var="entry" items="${scrumTeams}">
				<c:forEach var="team" items="${entry.value}">
					<div class="col-md-3 rounded my-2">
						<a
							href="${pageContext.request.contextPath}/scrums/details/${team.id }/${team.project.id}">
							<div
								class="d-flex justify-content-start align-item-center rounded border"
								style="background-color: #fff;">
								<i class="fa fa-users " aria-hidden="true"></i>
								<div class="scrum-master-project-text text-start ">
									<span>${entry.key }</span>
									<h6>${team.name }</h6>
									<p>Member : ${team.members }</p>
								</div>
							</div>
						</a>

					</div>
				</c:forEach>
			</c:forEach>


		</div>
		<div class="row my-2">
		
			<c:forEach items="${projectReports }" var="report">
     <c:if test="${report.sprintName !=null}">
			<p
				class="d-flex justify-content-center align-items-center field-status">Active
				Sprint Details</p>
				</c:if>

				<div class="col-md-4">
					<div class="card">
						<div
							class="d-flex justify-content-start align-item-center flex-wrap">
							<div class=" bg-white m-1" style="width: 100%;">
								<h5 class="title border-bottom p-2"
									style="font-size: 13px; font-weight: 600">${report.projectName } <span style="float: right;">${report.sprintName }</span> </h5>
								<div
									class=" d-flex justify-content-evenly align-item-center flex-wrap mb-2">
									<a href="${pageContext.request.contextPath}/scrum-master/all-task-active-sprint/${report.projectId}" class="text-decoration-none">
										<div class="Project-card" style="background-color: #cfe2ff;">
											<p>All Task</p>
											<h6>${report.totalTasks }</h6>
										</div>
									</a> <a href="${pageContext.request.contextPath}/scrum-master/completed-task/${report.projectId}" class="text-decoration-none">
										<div class="Project-card" style="background-color: #d1e7dd;">
											<p>Completed</p>
											<h6>${report.completedTasks }</h6>
										</div>
									</a> <a href="${pageContext.request.contextPath}/scrum-master/inComplete-task/${report.projectId}" class="text-decoration-none">
										<div class="Project-card" style="background-color: #f8d7da;">
											<p>Incompleted</p>
											<h6>${report.inCompleteTasks }</h6>
										</div>
									</a> 
										<div class="Project-card" style="background-color: #e2d9f3;">
											<p>Total Story Point</p>
											<h6>${report.totalStoryPoints }</h6>
										</div>
									
										<div class="Project-card" style="background-color: #cff4fc;">
											<p>Completed Story Point</p>
											<h6>${report.completedStoryPoints }</h6>
										</div>
									
										<div class="Project-card" style="background-color: #fff3cd;">
											<p>Incompleted Story Point</p>
											<h6>${report.incompleteStoryPoints }</h6>
										</div>
									</a> <a href="${pageContext.request.contextPath}/scrums/all-teams-by-active-sprint/${report.projectId }" class="text-decoration-none">
										<div class="Project-card scrum-team-card"
											style="background-color: #ffe5d0;">
											<p>Scrum Development Team</p>
											<h6>${report.scrumTeams }</h6>
										</div>
									</a>
								</div>
							</div>

						</div>
					</div>

				</div>
			</c:forEach>


			<div class="col-md-4">
				<div class="card  " style="height: 272px">
					<div class="d-flex justify-content-end">
						<select class="form-select project-dropdown"
							onchange="getTaskCount(this)">
							<c:forEach items="${projectList }" var="project">
								<c:choose>
									<c:when test="${defaultProjectId == project.id}">
										<option value="${project.id}" selected>${project.name }</option>
									</c:when>
									<c:otherwise>
										<option value="${project.id}">${project.name }</option>
									</c:otherwise>
								</c:choose>
							</c:forEach>
						</select>
					</div>
					<div id="piechart" class="bg-white"></div>
				</div>
			</div>


			<div class="col-md-4">
				<div class="card " style="height: 272px">
					<div class="d-flex justify-content-end">
						<select class="form-select project-dropdown"
							onchange="getStoryCount(this)">
							<c:forEach items="${projectList }" var="project">
								<c:choose>
									<c:when test="${defaultProjectId == project.id}">
										<option value="${project.id}" selected>${project.name }</option>
									</c:when>
									<c:otherwise>
										<option value="${project.id}">${project.name }</option>
									</c:otherwise>
								</c:choose>
							</c:forEach>
						</select>
					</div>
					<div id="barchart" class="bg-white" width="100%" height="200px"></div>
				</div>
			</div>


		</div>
		

		<div class="row">
			<div class="col-md-6 mt-2">
				<div class="card scrum-task">
					<div
						class="d-flex justify-content-between align-item-center border-bottom">
						<h5 class="p-0 mt-2 ms-3"
							style="font-size: 13px; font-weight: 500">Scrum Master Task</h5>
						<select class="form-select project-dropdown"
							onchange="getScrumTask(this)">
							<c:forEach items="${projectList }" var="project">
								<c:choose>
									<c:when test="${defaultProjectId == project.id}">
										<option value="${project.id}" selected>${project.name }</option>
									</c:when>
									<c:otherwise>
										<option value="${project.id}">${project.name }</option>
									</c:otherwise>
								</c:choose>
							</c:forEach>
						</select>
					</div>
					<ul class="list-group p-2 border-0" id="scrum-master-ul">
					 
					</ul>
					<div class="text-end">
						<button type="button" onclick="getMoreScrumMasterTasks()" 
						class="btn btn-link text-end more-btn mb-2">Show More...</button>
					</div>
				</div>
			</div>

			<div class="col-md-6 my-2">
				<div class="card  project-task">
					<div
						class="d-flex justify-content-between align-item-center border-bottom mb-2">
						<h5 class="p-0 mt-2 ms-3"
							style="font-size: 13px; font-weight: 500">Task For Project</h5>
						<select class="form-select  project-dropdown"
							onchange="getProjectTask(this)">
							<c:forEach items="${projectList }" var="project">
								<c:choose>
									<c:when test="${defaultProjectId == project.id}">
										<option value="${project.id}" selected>${project.name }</option>
									</c:when>
									<c:otherwise>
										<option value="${project.id}">${project.name }</option>
									</c:otherwise>
								</c:choose>
							</c:forEach>
						</select>
					</div>
					<ul class="list-group p-2 border-0" id="tasks-per-project-ul">

					</ul>
					<div class="text-end">
						<button type="button" onclick="getMoreTaskForProject()"
							class="btn btn-link text-end more-btn mb-2">Show More...</button>
					</div>
				</div>
			</div>
		</div>

	</div>
	<script type="text/javascript"
		src="https://www.gstatic.com/charts/loader.js"></script>
	<script
		src="https://cdnjs.cloudflare.com/ajax/libs/magnific-popup.js/1.1.0/jquery.magnific-popup.min.js"></script>
	<script>
		
		function getTaskCount(e) {
			laodProjectTaskCount(e.value);
		}
		function laodProjectTaskCount(projectId) {
			google.charts.load("current", {packages:["corechart"]});
		      google.charts.setOnLoadCallback(drawChart);
		      function drawChart() {
		    	  $
					.ajax({
						url : '${pageContext.request.contextPath}/scrum-master/project/task-count/'
								+ projectId,
						method : 'GET',
						contentType : 'application/json',
						success : function(d) {
							data = google.visualization.arrayToDataTable([
					        	['Language', 'Speakers (in millions)'],
								['Completed', d['completed']],
								['InComplete', d['incomplete']],]);
						
						    var options = {
					          title: 'Tasks status',
					          is3D: true,
							 };
		
					        var chart = new google.visualization.PieChart(document.getElementById('piechart'));
					        chart.draw(data, options);
						}
					});
		    
		      }
		}
		laodProjectTaskCount(${defaultProjectId});
		function getStoryCount(e) {
			laodProjectStoryPointCount(e.value);
		}
		function laodProjectStoryPointCount(projectId) {
			 google.charts.load("current", {packages:['corechart']});
			    google.charts.setOnLoadCallback(drawChart);
			    function drawChart() {
			    	 $
						.ajax({
							url : '${pageContext.request.contextPath}/scrum-master/project/story-point-count/'
									+ projectId,
							method : 'GET',
							contentType : 'application/json',
							success : function(d) {
								let data1 = google.visualization.arrayToDataTable([
									["Element", "Density", {
										role: "style"
									}],
									["Total", d['totalStroryPoints'],
										"#000"],
									["Completed", d['completedStoryPoints'],
										"#44af69"],
									["Incomplete", d['incompleteStoryPoints'],
										"#b3b3b3"]]);
								var view = new google.visualization.DataView(data1);
							      view.setColumns([0, 1,
							                       { calc: "stringify",
							                         sourceColumn: 1,
							                         type: "string",
							                         role: "annotation" },
							                       2]);

							      var options = {
							        title: 'story point',
							        width: 250,
							        height: 230,
							        bar: {groupWidth: "95%"},
							        legend: { position: "none" },
							      };
							      var chart = new google.visualization.ColumnChart(document.getElementById('barchart'));
							      chart.draw(view, options);
							}
						});
			    }
			      
		}
		laodProjectStoryPointCount(${defaultProjectId});
		
		function getScrumTask(e) {
			selectedPojectIdForProject=e.value;
			loadScrumMasterTasks(e.value)
		}
		function getMoreTaskForUser() {
			let a = document.createElement('a');
			let url ="${pageContext.request.contextPath}/tasks/all-tasks/user/"+selectedPojectIdForProject+"?pageNo=0"
			a.setAttribute('href',url);
			a.click();
		}
	function loadScrumMasterTasks(projectId){
		    	  $
					.ajax({
						url : '${pageContext.request.contextPath}/scrum-master/top-five-tasks/'
								+ projectId,
						method : 'GET',
						contentType : 'application/json',
						success : function(d) {
							let ul = document.getElementById('scrum-master-ul');
							ul.innerHTML="";
							for (var i = 0; i < d.length; i++) {
								let temp = d[i];
								let li = document.createElement('li');
								li.setAttribute('class','draggable py-1 list-group-item ui-draggable ui-draggable-handle');
								li.setAttribute('id', 'draggable');
								li.addEventListener('click', function() {
				                    updateTask(temp.id,projectId); 
				                });
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
								div4.setAttribute('class','d-flex justify-content-end align-items-center');
								
								let div5 = document.createElement('div');
								div5.setAttribute('class','col-md-3 ');
								let span2 = document.createElement('span');
								span2.setAttribute('class','badge severity-high ');
								span2.innerHTML=temp.story_point;
								div5.appendChild(span2);
								
							 	let div6 = document.createElement('div');
								div6.setAttribute('class','col-md-6 ');
								let span3 = document.createElement('span');
								span3.setAttribute('class','badge sprintBox-priority d-none');
								span3.innerHTML=temp.priority;
								div6.appendChild(span3);  
								
								let div7 = document.createElement('div');
								div7.setAttribute('class','col-md-6 ');
								let span4 = document.createElement('span');
								span4.setAttribute('class','badge rounded-pill bg-success');
								span4.innerHTML=temp.status;
								div7.appendChild(span4);
								
								div4.appendChild(div5);
				 				div4.appendChild(div6); 
								div4.appendChild(div7);
								div3.appendChild(div4);
								div1.appendChild(div2);
								div1.appendChild(div3);
								
								li.appendChild(div1);
								ul.appendChild(li);
							}
						}
					});
		    
		}
		
		loadScrumMasterTasks(${defaultProjectId});
		var selectedPojectIdForProject = ${defaultProjectId};
		function getProjectTask(e) {
			selectedPojectIdForProject=e.value;
			loadTasksPerProject(e.value);
		}
		function getMoreTaskForProject() {
			let a = document.createElement('a');
			let url ="${pageContext.request.contextPath}/tasks/all-tasks1/"+selectedPojectIdForProject+"?pageNo=0"
			a.setAttribute('href',url);
			a.click();
		}
		
		function getMoreScrumMasterTasks() {
			let a = document.createElement('a');
			let url ="${pageContext.request.contextPath}/tasks/all-tasks/user/"+selectedPojectIdForProject+"?pageNo=0"
			a.setAttribute('href',url);
			a.click();
		}
		
		function loadTasksPerProject(projectId){
	    	  $
				.ajax({
					url : '${pageContext.request.contextPath}/tasks/top-five-tasks-by-project/'
							+ projectId,
					method : 'GET',
					contentType : 'application/json',
					success : function(d) {
						let ul = document.getElementById('tasks-per-project-ul');
						ul.innerHTML="";
						for (var i = 0; i < d.length; i++) {
							let temp = d[i];
							let li = document.createElement('li');
							li.setAttribute('class','draggable py-1 list-group-item ui-draggable ui-draggable-handle');
							li.setAttribute('id', 'draggable');
							li.addEventListener('click', function() {
			                    updateTask(temp.id,projectId); 
			                });
							let div1 = document.createElement('div');
							div1.setAttribute('class','row');
							
							let div2 = document.createElement('div');
							div2.setAttribute('class','col-md-8');
							
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
							div6.setAttribute('class','col-md-6 ');
							let span3 = document.createElement('span');
							span3.setAttribute('class','badge sprintBox-priority d-none');
							span3.innerHTML=temp.priority;
							div6.appendChild(span3); 
							
							let div7 = document.createElement('div');
							div7.setAttribute('class','col-md-6 ');
							let span4 = document.createElement('span');
							span4.setAttribute('class','badge rounded-pill bg-success');
							span4.innerHTML=temp.status;
							div7.appendChild(span4);
							
							
							div4.appendChild(div6);
							div4.appendChild(div5);
							div4.appendChild(div7);
							div3.appendChild(div4);
							div1.appendChild(div2);
							div1.appendChild(div3);
							
							li.appendChild(div1);
							ul.appendChild(li);
						}
					}
				});
	    
	    }
	
		loadTasksPerProject(${defaultProjectId});
		
		
	</script>
	<script>
	$(".status-priority-floting").mouseover(function(){ 
		console.log("it working")
		   $(".status-priority-floting").css("width", "120px"); 
		});
	
	$(".status-priority-floting").mouseout(function(){ 
		   $(".status-priority-floting").css("width", "40px"); 
		});
	
	$(".status-severity-floting").mouseover(function(){ 
		console.log("it working")
		   $(".status-severity-floting").css("width", "120px"); 
		});
	
	$(".status-severity-floting").mouseout(function(){ 
		   $(".status-severity-floting").css("width", "40px"); 
		});
	
	$(".status-stutus-floting").mouseover(function(){ 
		console.log("it working")
		   $(".status-stutus-floting").css("width", "120px"); 
		});
	
	$(".status-stutus-floting").mouseout(function(){ 
		   $(".status-stutus-floting").css("width", "40px"); 
		});
	
	$(".status-story-points-floting").mouseover(function(){ 
		console.log("it working")
		   $(".status-story-points-floting").css("width", "140px"); 
		});
	
	$(".status-story-points-floting").mouseout(function(){ 
		   $(".status-story-points-floting").css("width", "40px"); 
		});
	</script>
		
</body>

</html>