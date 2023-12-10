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
<jsp:include page="../tasks/updateTaskModal.jsp"></jsp:include>

  <style>

.active-sprint-list img {
    padding: 10px 20px;
    color: #7687e1;
    border-radius: 5px 0px 0px 5px;
    font-size: 20px;
    background-color: #e7e7e7;
    width: 85px;
}
.scrum-team-list img{
          padding: 10px 5px;
          color: #7687e1;
          border-radius: 5px 0px 0px 5px;
          font-size: 20px;
           background-color: #e7e7e7;
          width: 85px;
         border: 1px solid #ba98b44a;
}

</style>  
</head>
<body>
	<jsp:include page="../common/header.jsp"></jsp:include>
	
	<div class="main-content">
		<div class="container-fuild">
			<div class="row">
				<div class="col-md-6 mt-4">
					<div class="Scrum-team-details">
						<c:if test="${scrumTeams.size()>0}">
							<small>Scrum Team</small>
						</c:if>

						<div class="row row-cols-1 row-cols-md-3 g-3 ">
							<c:forEach var="entry" items="${scrumTeams}">
								<c:forEach var="team" items="${entry.value}">  
									<a
										href="${pageContext.request.contextPath}/scrums/details/${team.id }/${team.project.id}">
										<div class="col">
											<div class="card h-100 ">
												<div class="card-body">
													<i class='bx bxs-group'></i>
													<h5 class="card-title">${team.name }</h5>
													<p class="card-text">
														Member : <strong> ${team.members } </strong>
													</p>
													<span>${entry.key }</span>
												</div>
											</div>
										</div>
									</a> 

								</c:forEach>
							</c:forEach>
						</div>
					</div>
				</div>

				<div class="col-md-6 mt-4">
					<div class="active-sparint-details">
						<c:if test="${activeSprints != null}">
							<small>Active Sprint</small>
						</c:if>

						<div class="row row-cols-1 row-cols-md-3 g-3 ">
							<c:forEach items="${activeSprints}" var="data">
								<c:if test="${data.sprint != null}">
									<c:forEach items="${data.sprint}" var="sprint">
										<a
											href="${pageContext.request.contextPath}/dashboard/stories/${data.projectId}/${sprint.id}"
											class=" scrum-list">
											<div class="col">
												<div class="card h-100 ">
													<div class="card-body">
														<i class='bx bxs-hourglass-top'></i>
														<h5 class="card-title">${sprint.name}</h5>
														<p class="card-text">
															Start Sprint : <strong> </strong>
														</p>
														<span>${data.project}</span>
													</div>
												</div>
											</div>
										</a>
									</c:forEach>
								</c:if>
							</c:forEach>
						</div>
					</div>
				</div>  
			</div>

			<div class="row informetion-card">
				<div class="col-md-4">
					<div class="card ">
						<div class="card-body">
							<div class="d-flex justify-content-between  align-items-center">
								<small>Previous Sprints</small> <select
									class="form-select project-dropdown"
									onchange="getPreviousSprints(this)">
									<c:forEach items="${projectList }" var="project">
										<c:choose>
											<c:when test="${defaultProjectId == project.id}">
												<option value="${project.id}" selected="selected">${project.name }</option>
											</c:when>
											<c:otherwise>
												<option value="${project.id}">${project.name }</option>
											</c:otherwise>
										</c:choose>
									</c:forEach>
								</select>
							</div>
							<div class=" mt-2">
								<ul class="list-group dashbord_Ul" id="previous-sprints" >
									  
								</ul>
							</div>
 
						</div>
					</div>
				</div>

				<div class="col-md-4"> 
					<div class="card ">
						<div class="card-body">
							<div class="d-flex justify-content-between  align-items-center">
								<small>Task Report</small> <select
									class="form-select project-dropdown"
									onchange="getTaskCount(this)">
									<c:forEach items="${projectList }" var="project">
										<c:choose>
											<c:when test="${defaultProjectId == project.id}">
												<option value="${project.id}" selected="selected">${project.name }</option>
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
			</div>

				<div class="col-md-4">
					<div class="card ">
						<div class="card-body">
							<div class="d-flex justify-content-between  align-items-center">
								<small>Task Report</small> 
								<select class="form-select project-dropdown"
							onchange="getStoryCount(this)">
							<c:forEach items="${projectList }" var="project">
								<c:choose>
									<c:when test="${defaultProjectId == project.id}">
										<option value="${project.id}" selected="selected">${project.name }</option>
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
				
				 
			</div>
			
			
			<div class="row">

			<div class="col-md-12 my-2">
				<div class="card  project-task">
				
				<div class="card-body">
					<div class="d-flex justify-content-between align-item-center mb-2">
						<small>Project Task</small>
						<select class="form-select "
							onchange="getProjectTask(this)">
							<c:forEach items="${projectList }" var="project">
								<c:choose>
									<c:when test="${defaultProjectId == project.id}">
										<option value="${project.id}" selected="selected">${project.name }</option>
									</c:when>
									<c:otherwise>
										<option value="${project.id}">${project.name }</option>
									</c:otherwise>
							</c:choose>
							</c:forEach>
						</select>
					</div>
					
					<ul class="list-group" id="tasks-per-project-ul">

					</ul>
					<div class="text-end">
						<button type="button" onclick="getMoreTaskForProject()"
							class="btn btn-link text-end more-btn seeMoreBtn">Show More...</button>
					</div>
				</div>
					
					
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
								
								let img = document.createElement('img');
								div.setAttribute('class','text-center '); 
								img.setAttribute('src','${pageContext.request.contextPath}/images/No-Task.svg');
								img.setAttribute('class','d-block w-50  mx-auto m-0'); 
								let h6 = document.createElement('h6');
								h6.setAttribute('class','p-0 m-0 fs-6');
								h6.innerHTML="No Task status";
								div.appendChild(img);
								div.appendChild(h6);
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
							url : '${pageContext.request.contextPath}/scrum-master/project/story-point-count/'
									+ projectId,
							method : 'GET',
							contentType : 'application/json',
							success : function(data) {
								if(data != ""){
									let data1 = google.visualization.arrayToDataTable([
										["Element", "Density", {
											role: "style"
										}],
										["Total", data['totalStroryPoints'],
											"#000"],
										["Completed", data['completedStoryPoints'],
											"#44af69"],
										["Incomplete", data['incompleteStoryPoints'],
											"#b3b3b3"]]);
									var view = new google.visualization.DataView(data1);
								      view.setColumns([0, 1,
								                       { calc: "stringify",
								                         sourceColumn: 1,
								                         type: "string",
								                         role: "annotation" },
								                       2]);

								      var options = {
								        title: 'Story Point',
								        width: 250,
								        height: 230,
								        bar: {groupWidth: "95%"},
								        legend: { position: "none" },
								      };
								      var chart = new google.visualization.ColumnChart(document.getElementById('barchart'));
								      chart.draw(view, options);
								}
							}
						});
			    }
			      
		}
		laodProjectStoryPointCount(${defaultProjectId});
		
		function getScrumTask(e) {
			loadScrumMasterTasks(e.value)
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
								
								li.innerHTML=temp.title;
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
			let url ="${pageContext.request.contextPath}/tasks/all-tasks/"+selectedPojectIdForProject+"?pageNo=0"
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
						
						if(d != ''){
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
							let ul = document.getElementById('tasks-per-project-ul');
							ul.innerHTML="";
							let li = document.createElement('li');
							li.setAttribute('class','draggable py-1 list-group-item ui-draggable ui-draggable-handle');
							li.setAttribute('id', 'draggable');
							li.innerHTML="No tasks for project";
							ul.appendChild(li);
						}
						
					}
				});
	    
	    }
	
		loadTasksPerProject(${defaultProjectId});
		
		function loadPreviousSprints(projectId){
	    	  $
				.ajax({
					url : '${pageContext.request.contextPath}/project-manager/previous-sprints/'
							+ projectId,
					method : 'GET',
					contentType : 'application/json',
					success : function(data) {
						if(data != ''){
							let main = document.getElementById('previous-sprints');
							main.innerHTML="";
							for (var i = 0; i < data.length; i++) {
								let temp = data[i];
								
								let a = document.createElement('a');
								a.href="${pageContext.request.contextPath}/project-manager/sprint-history/"+projectId+"/"+temp.id;
								let li = document.createElement('li');
								li.setAttribute('class','list-group-item d-flex justify-content-between align-items-center');
								let span = document.createElement('span');
								span.setAttribute('class','badge bg-primary rounded-pill6 fw-light');
								span.innerHTML="issue: 9";
								let h6 = document.createElement('h6');
								h6.setAttribute('class','p-0 m-0 fs-6');
								h6.innerHTML=temp.name;
								li.appendChild(h6);
								li.appendChild(span);
								a.appendChild(li);
								main.appendChild(a);
							}
						}
						else{
							let main = document.getElementById('previous-sprints');
							main.innerHTML="";
							let div = document.createElement('div');
							
							let img = document.createElement('img');
							div.setAttribute('class','text-center '); 
							img.setAttribute('src','${pageContext.request.contextPath}/images/No-sprints.svg');
							img.setAttribute('class','d-block w-50  mx-auto m-0'); 
							let h6 = document.createElement('h6');
							h6.setAttribute('class','p-0 m-0 fs-6');
							h6.innerHTML="No previous sprints";
							div.appendChild(img);
							div.appendChild(h6);
							main.appendChild(div);
						}
						
					}
				});
	    
	    }
		
		loadPreviousSprints(${defaultProjectId});
		
		function getPreviousSprints(e) {
			loadPreviousSprints(e.value)
		}
	</script>


</body>

</html>