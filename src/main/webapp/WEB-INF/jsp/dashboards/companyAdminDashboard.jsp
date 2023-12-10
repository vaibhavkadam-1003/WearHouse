<%@page import="com.pluck.dto.LoginUserDto"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<style>
.badge-soft-inActive {
	color: #e65555 !important;
	font-size: 0.7rem !important;
	border: 1px solid #dc3545 !important;
}
</style>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/magnific-popup.js/1.1.0/magnific-popup.min.css">
<body>

	<jsp:include page="../common/header.jsp"></jsp:include>
	<jsp:include page="../tasks/updateTaskModal.jsp"></jsp:include>
	
	
	<div class="main-content">
		<div class="container-fuild">
			<div class="row user-informetion-Basic">
				<div class="col-md-4">
					<div class="card">
						<div class="card-body">
							<small>Scrume Team</small>
							<!-- <div class="basic-card">
								<i class='bx bxs-user'></i>
								<div>
									<h6>Scrum team name</h6>
									<small>project Name</small>
									<span>Member : 6</span>
								</div>
							</div> -->
							<c:forEach var="entry" items="${scrumTeams}">
								<c:forEach var="team" items="${entry.value}">
									<a
										href="${pageContext.request.contextPath}/scrums/details/${team.id }/${team.project.id}">
										<div class="basic-card">
											<i class='bx bxs-user' style="background-color: #ffe5d0;"></i>
											<div>
												<h6>${team.name}</h6>
												<small style="background-color: #fd7e14;">${entry.key }</small>
												<span>Member : <b>${team.members }</b></span>
											</div>
										</div>
									</a>
								</c:forEach>
							</c:forEach>
						</div>
					</div>
				</div>

				<div class="col-md-4">
					<div class="card">
						<div class="card-body">
							<small>Active Sprints</small>

							<c:forEach items="${activeSprints}" var="data">
								<c:if test="${data.sprint != null}">
									<c:forEach items="${data.sprint}" var="sprint">
										<a
											href="${pageContext.request.contextPath}/dashboard/stories/${data.projectId}/${sprint.id}"
											class="scrum-list">

											<div class="basic-card">
												<i class='bx bxs-hourglass-top'></i>
												<div>
													<h6>
														<c:choose>
															<c:when test="${data.sprint != null}">
                                    ${sprint.name} 
										</c:when>
															<c:otherwise>
                                    No Active Sprint
                                </c:otherwise>
														</c:choose>
													</h6>
													<small class="rounded-circle p-1"></small> <span>${data.project}</span>
												</div>
											</div>

										</a>

									</c:forEach>
								</c:if>
							</c:forEach> 
						</div>
					</div>
				</div>
				
				

				<div class="col-md-4">
					<div class="card">
						<div class="card-body">
							<small>Project</small>

							<c:choose>
								<c:when test="${empty projectListByUser}">
									<div class="scrum-team-card privious-sprint-list-box"
										style="width: 50%; margin-top: 65px;">
										<h6 class="p-2">No Projects Available</h6>
										<img
											src="${pageContext.request.contextPath}/images/No-sprints.svg"
											class="figure-img img-fluid rounded" alt="...">
									</div>
								</c:when>
								<c:otherwise>
									<c:forEach items="${projectListByUser}" var="project">
										<a
											href="${pageContext.request.contextPath}/projects/project/dashboard/${project.id}"
											class="scrum-list">
											<div class="basic-card">
												<i class='bx bxs-briefcase-alt-2'
													style="background-color: #e0cffc;"></i>
												<div>
													<h6>${project.name}</h6>
													<!-- <span>project Name</span>-->
													<c:choose>
														<c:when test="${project.status eq 'Active'}">
															<small>${project.status}</small>
														</c:when>
														<c:otherwise>
															<small style="background-color:#b02a37;">${project.status}</small>
														</c:otherwise>
													</c:choose>
												</div>
											</div>

										</a>
									</c:forEach>
								</c:otherwise>
							</c:choose>
						</div>
					</div>
				</div>
			</div>
			
			<div class="row my-4">
			
				<div class="col-md-4">
					<div class="card  project-task" style="height:250px;">
						<div class="card-body">
							<div class="d-flex justify-content-between  align-items-center">
								<small>Task Report</small> <select
									class="form-select project-dropdown"
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

					<div class="card project-task my-4" style="height:290px;">
						<div class="card-body">
							<div class="d-flex justify-content-between  align-items-center">
								<small>Story point</small> <select class=" project-dropdown"
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
						</div>
						<div id="barchart" class="bg-white" width="100%" height="200px"></div>
					</div>

				</div>
			
				
				<div class="col-md-8">
					<div class="card scrum-task informetion-card" style="height:80vh">
					
					<div class="card-body">
					<div class="d-flex justify-content-between  align-items-center">
								<small>User Task</small> <select class="form-select project-dropdown"
							onchange="getUserTask(this)">
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
					<ul class="list-group dashbord_Ul my-2" id="scrum-master-ul"> </ul>
					<div class="text-end">
							<button type="button" onclick="getMoreTaskForProject()"
								class="btn btn-link text-end more-btn seeMoreBtn">Show
								More...</button>
						</div>
					</div>
					
					
					 
				</div>
				</div>
			</div>
			
			
		</div>
	</div>
	
	

	

	<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js" ></script> 
	<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/magnific-popup.js/1.1.0/jquery.magnific-popup.min.js"></script>
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
					url : '${pageContext.request.contextPath}/dashboard/user/task-count/'
							+ projectId,
					method : 'GET',
					contentType : 'application/json',
					success : function(d) {
						var total = (d['total'])
						var completed = (d['completed'])
						var incomplete = (d['incomplete'])
						
						if(total != 0 || completed !=0 || incomplete !=0){
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
						else{
							let main = document.getElementById('piechart');
							main.innerHTML="";
							let div = document.createElement('div');
							div.setAttribute('class','scrum-team-card privious-sprint-list-box');
							 let h6 = document.createElement('h6');
							h6.setAttribute('class','p-2');
							h6.innerHTML="No Task status";
							div.appendChild(h6);
							main.style.height = "300px";
							main.appendChild(div);
						}
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
						url : '${pageContext.request.contextPath}/dashboard/user/story-point-count/'
								+ projectId,
						method : 'GET',
						contentType : 'application/json',
						success : function(d) {
							if(d != ''){
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
						}else {
							let main = document.getElementById('barchart');
							main.innerHTML="";
							let div = document.createElement('div');
							div.setAttribute('class','scrum-team-card privious-sprint-list-box');
							 let h6 = document.createElement('h6');
							h6.setAttribute('class','p-2');
							h6.innerHTML="No Story points";
							div.appendChild(h6);
							main.style.height = "300px";
							main.appendChild(div);
						}
						}
					});
		    }
		      
	}		
	laodProjectStoryPointCount(${defaultProjectId});

  var selectedPojectIdForProject = ${defaultProjectId};
  function getUserTask(e) {
	   selectedPojectIdForProject=e.value;
		loadUserTasks(e.value)
	}
  function getMoreTaskForProject() {
		let a = document.createElement('a');
		let url ="${pageContext.request.contextPath}/tasks/all-tasks/user/"+selectedPojectIdForProject+"?pageNo=0"
		a.setAttribute('href',url);
		a.click();
	}
  function loadUserTasks(projectId){
	    	  $
				.ajax({
					url : '${pageContext.request.contextPath}/dashboard/top-five-tasks/'
							+ projectId,
					method : 'GET',
					contentType : 'application/json',
					success : function(d) {
						if(d != ''){
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
							div2.setAttribute('class','col-md-10');
							
							let span1 = document.createElement('span');
							span1.setAttribute('class',' sprintBox-title ');
							span1.innerHTML=temp.title;
							div2.appendChild(span1);
							div1.appendChild(div2);
							
							let div3 = document.createElement('div');
							div3.setAttribute('class','col-md-2 ');
							
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
						else {
							let ul = document.getElementById('scrum-master-ul');
							ul.innerHTML="";
							let li = document.createElement('li');
							li.setAttribute('class','draggable py-1 list-group-item ui-draggable ui-draggable-handle');
							li.setAttribute('id', 'draggable');
							li.innerHTML="No tasks for Project";
							ul.appendChild(li);
						}
					}
				});
	    
	}			loadUserTasks(${defaultProjectId});
  </script>
</body>
<jsp:include page="../common/footer.jsp"></jsp:include>