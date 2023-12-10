<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html>
<head>
<meta content="initial-scale=1, maximum-scale=1, user-scalable=0"
	name="viewport" />
<meta name="viewport" content="width=device-width" />
<link href="${pageContext.request.contextPath}/css/sprintReport.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/css/bootstrap.min.css"
	integrity="sha384-TX8t27EcRE3e/ihU7zmQxVncDAy5uIKz4rEkgIXeMed4M0jlfIDPvg6uqKI2xXr2"
	crossorigin="anonymous">
<!-- Import jquery cdn -->
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"
	integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj"
	crossorigin="anonymous">
    </script>
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/js/bootstrap.bundle.min.js"
	integrity="sha384-ho+j7jyWK8fNQe+A12Hb8AhRq26LrZ/JpcUGGOn+Y7RsweNrtN/tE3MoK7ZeZDyx"
	crossorigin="anonymous">
    </script>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<script src="https://code.jquery.com/jquery-3.6.1.js"
	integrity="sha256-3zlB5s2uwoUzrXK3BT7AX3FyvojsraNFxCc2vC/7pNI="
	crossorigin="anonymous"></script>
<script src="${pageContext.request.contextPath}/js/charts.js"></script>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
</head>
<style>
.project-report-card {
	padding: 20px;
	background-color: #FFFFFF;
	border-radius: 5px;
	min-width: 120px;
	min-height: 120px;
	margin: 10px;
}

@media ( min-width : 420px) and (max-width: 659px) {
	.container-new {
		grid-template-columns: repeat(2, 160px);
	}
}

@media ( min-width : 660px) and (max-width: 899px) {
	.container-new {
		grid-template-columns: repeat(3, 160px);
	}
}

@media ( min-width : 900px) {
	.container-new {
		grid-template-columns: repeat(4, 160px);
	}
}

.container-new .box {
	width: 100%;
}

.container-new .box h2 {
	display: block;
	text-align: center;
	color: #333;
}

.container-new .box .chart {
	position: relative;
	width: 100%;
	height: 100%;
	text-align: center;
	font-size: 10px;
	line-height: 160px;
	height: 160px;
	color: #e81515;
}

.container-new .box canvas {
	position: absolute;
	top: 0;
	/* left: 0; */
	left: 50%;
	width: 100%;
	width: 100%;
}

.container-new {
	 /*  display: grid;
	grid-template-columns: repeat(1, 160px); 
	grid-gap: 80px;
	margin: auto 0; */ 
	width: 100%;
}

@media ( min-width : 420px) and (max-width: 659px) {
	.container-new {
		grid-template-columns: repeat(2, 160px);
	}
}

@media ( min-width : 660px) and (max-width: 899px) {
	.container-new {
		grid-template-columns: repeat(3, 160px);
	}
}

@media ( min-width : 900px) {
	.container-new {
		grid-template-columns: repeat(4, 160px);
		text-align: center !important;
	}
}

.container-new .box {
	width: 100%;
}

.container-new .box h2 {
	display: block;
	color: #333;
	font-size: 13px;
	margin-left: 30px;
}

.container-new .box .chart {
	width: 100%;
	height: 100%;
	text-align: center;
	font-size: 20px;
	height: 160px;
	color: #57616b;
	font-weight: 700;
	margin: 20px 0px 10px 15px;
}

.container-new .box canvas {
	/* position: absolute;
	top: 0;
	left: 35%;
	width: 100%;
	width: 100%; */
	position: absolute;
    top: -8%;
    left: 40%;
    width: 100%;
    width: 20%;
}

 
.info-div {
	width: 180px;
	padding: 10px 10px;
	background: #fbfbfb;
	margin: 10px 5px;
	border-radius: 3px;
}

.info-div span, .project-short-decription span , .user-rol-info span {
	font-size: 16px;
	font-weight: 600;
	margin: 0px;
}

.info-div p, .project-short-decription p , .user-rol-info p {
	font-size: 13px;
	font-weight: 500;
	margin: 0px;
	color: #363636;
}

.project-info-report h5 {
	font-size: 16px;
	font-weight: 600;
	padding-bottom: 10px;
	margin: 0px;
}

.project-info-report small {
	font-size: 13px;
	font-weight: 500;
	padding-bottom: 10px;
	margin: 0px 0px 0px 0px;
	color: #363636;
}

.project-info-report ul li {
	font-size: 13px;
	font-weight: 500;
	padding-bottom: 10px;
	margin: 0px;
	color: #363636;
}

.project-short-decription {
	  padding: 10px 0px 10px;
    margin: 35px 0px 35px; 
}

.project-short-decription i {
	padding: 15px 17px;
	border-radius: 30px;
	border: 1px solid #c5c5c5;
	color: #b3b3b3;
	font-size: 18px;
	background-color:#fff;
	z-index:1000;
}
.line{
	border-left: 2px dashed #b3b3b3;
    height: 450px;
    position: absolute;
    top: 100px;
    left: 48px;
    z-index: 0;
}

/* .user-rol-info{ 
	display:flex;
	justify-content: start;
	align-items: center;
	margin: 0px 10px 10px 0px;
} 
	.user-rol-info .card {
	  min-width: 290px; 
	} 

*/

	.user-rol-info{ 
	width:270px;
	display:flex;
	justify-content: start;
	align-items: center;
	margin: 15px 10px 10px 0px;
}

.user-rol-info span{
	font-size:14px;
	font-weight: 600;
	color:#423d3d;
}

.user-rol-info p{
	font-size:12px;
	font-weight: 400;
	color:#6f6c6c;
}
 	 
	
	.avatar-title{
		align-items: center;
    background-color: #556ee6;
    color: #fff !important;
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

</style>

</head>
<body>
	<jsp:include page="../common/header.jsp"></jsp:include>
	<%
	if (session.getAttribute("username") == null) {
		response.sendRedirect("/loginForm");
	}
	%>

	
	<div class="main-content "
		style="background-color: #eee !important; padding: 10px 10px; overflow-y: scroll !important;">
		<div class="container-fuild">

			<div class="row">
				<div class="col-md-12  project-info-report">
					<div class="card">
						<div class="card-body">
							<h5>${project.name} Project Report</h5>
							<small>${project.description}</small>
							<ul class="mt-3">
									<li>The project started on : <b> ${project.startDate } </b></li>
									<li>The project last date is : <b> ${project.lastDate }
									</b></li>
								</ul>
						</div>
					</div>
				</div>
			</div>
			
			<div class="row my-2">
				<div class="col-md-3"> 
				
					<div class="card mb-2">
						<div class="card-body">
							<a href="${pageContext.request.contextPath}/tasks?pageNo=0" class="d-flex justify-content-start align-items-center project-short-decription p-0 m-0">
							<i class="fa fa-file-text-o ms-2" aria-hidden="true"></i>
								<div class="ms-4">
									<span class="my-2">${taskList.size() }</span>
									<p>Tasks</p>
								</div> 
							</a>
						</div>
					</div>
					
					<div class="card my-2">
						<div class="card-body">
							<a href="${pageContext.request.contextPath}/users?pageNo=0" class="d-flex justify-content-start align-items-center project-short-decription p-0 m-0">
							<i class="fa fa-user ms-2" aria-hidden="true"></i>
								<div class="ms-4">
									<span class="my-2">${userListByProject.size()}</span>
									<p>Users</p>
								</div> 
							</a>
						</div>
					</div>
					
					<div class="card my-2">
						<div class="card-body">
							<a href="${pageContext.request.contextPath}/sprints/activeSprints" class="d-flex justify-content-start align-items-center project-short-decription p-0 m-0">
							<i class="fa fa-sun-o ms-2" aria-hidden="true"></i>
								<div class="ms-4">
									<span class="my-2">${totalActiveSprintCount }</span>
									<p>Active Sprints</p>
								</div> 
							</a>
						</div>
					</div>
					
					<div class="card my-2">
						<div class="card-body">
						 	<a href="${pageContext.request.contextPath}/sprints/previous" class="d-flex justify-content-start align-items-center project-short-decription p-0 m-0">
							<i class="fa fa-file-text ms-2" aria-hidden="true"></i>
								<div class="ms-4">
									<span class="my-2">${totalPervoiusSprintCount}</span>
									<p>Previous Sprints</p>
								</div> 
							</a>
						</div>
					</div>
					
					<div class="card my-2">
						<div class="card-body">
							<div class="d-flex justify-content-start align-items-center project-short-decription p-0 m-0">
							<i class="fa fa-user-secret ms-2" aria-hidden="true"></i>
								<div class="ms-4">
									<span class="my-2">${totalScrumCount }</span>
									<p>Scrum Team</p>
								</div> 
							</div>
						</div>
					</div>
					
					
				</div>
				<div class="col-md-6">
					<div class="card pb-1">
						<div class="card-body"> 
							<div class="row mt-1">
								<div class="container-new ">
									<div class="box text-center w-100 ">
										<div class="chart" data-percent="${completedTasksWidth}%"
											data-scale-color="#ffb400">${completedTasksWidth}%</div>
										<h2>Project Progress</h2>
									</div>
								</div>
								<div class="col-md-12">
									<div
										class="d-flex justify-content-center align-items-center flex-wrap mt-4">
										<div class="info-div" style="background-color: #cfe2ff;">
											<span class="my-2">${taskList.size() }</span>
											<p>Total Tasks</p>
										</div>

										<div class="info-div" style="background-color: #d1e7dd;">
											<span class="my-2">${completedTasks.size()}</span>
											<p>Completed Task</p>
										</div>

										<div class="info-div" style="background-color: #f8d7da;">
											<span class="my-2">${incompletedTasksCount == null ? 0 : incompletedTasksCount}</span>
											<p>Incomplete Tasks</p>
										</div>

										<div class="info-div" style="background-color: #e2d9f3;">
											<span class="my-2">${storyCount.totalStroryPoints == null ? 0 : storyCount.totalStroryPoints}</span>
											<p>Total Story Points</p>
										</div>

										<div class="info-div" style="background-color: #cff4fc;">
											<span class="my-2">${storyCount.completedStoryPoints == null ? 0 : storyCount.completedStoryPoints}</span>
											<p>Completed Story Points</p>
										</div>

										<div class="info-div" style="background-color: #fff3cd;">
											<span class="my-2">${storyCount.incompleteStoryPoints == null ? 0 : storyCount.incompleteStoryPoints}</span>
											<p>Incomplete Story Points</p>
										</div>
									</div>
								</div>
							</div>
							
						</div>
					</div>
				</div>
				<div class="col-md-3" style="max-height:445px; overflow-y:auto;"> 
					
					<c:forEach items="${userListByProject}" var="users">
						<div class="">
							<div class="card mb-2">
								<div class="card-body">
									<div class="user-rol-info m-0 p-0">
										<div class="d-flex justify-content-start align-items-center">
										<div class="avatar-circle">
										<span class="avatar-title pluck-capitalize">${fn:substring(users.firstName, 0, 1)}</span>
									</div>
									<div class="ms-3">
										<span class="my-2 text-capitalize">${users.firstName} ${users.lastName}</span>
										<p>${users.highestRole}</p>
									</div>
									</div>
									</div> 
								</div>
							</div>
						</div>
					</c:forEach> 
				</div>
			</div>
			
			<div class="row">
				<div class="col-md-12">
					<div class="card">
						<div class="card-body">
							<div class="border-bottom pb-2 text-capitalize"><h5>${project.name} Project tasks </h5></div>
							<ul class="list-group" style="max-height:300px; overflow-y: auto;">
									<c:forEach items="${taskList}" var="tasks">
										<li class="list-group-item d-flex justify-content-start align-items-center px-1">
											<div class="col-11 p-0 m-0">
												<c:choose>
													<c:when test="${tasks.taskType eq 'Task'}">
														<i class="fa fa-check-square text-primary" aria-hidden="true"></i>
													</c:when>
													<c:when test="${tasks.taskType eq 'Bug'}">
														<i class="fa fa-stop-circle text-danger" aria-hidden="true"></i>
													</c:when>
													<c:when test="${tasks.taskType eq 'User Story'}">
														<i class="fa fa-bookmark text-success" aria-hidden="true"></i>
													</c:when>
													<c:when test="${tasks.taskType eq 'Epic'}">
														<i class="fa-solid fa-bolt" aria-hidden="true" style="color: #904ee2; font-size: 17px"></i>
													</c:when>
												</c:choose>
												<a class="project-initial-name" href="${pageContext.request.contextPath}/tasks/updateTaskForm/${tasks.id}"
													class="text-success">${tasks.ticket}</a> <a
													class="colorLight"  href="${pageContext.request.contextPath}/tasks/updateTaskForm/${tasks.id}"class="text-success">${tasks.title}</a>
											</div>
											
											<div class="col-1 p-0 m-0">
												<span class="scrum-sprint-action d-none" id="task-priority">
													${tasks.priority} </span>
													 <span class="scrum-sprint-action mx-2"
													id="task-storyPoint"> ${tasks.story_point} </span> <span
													class="scrum-sprint-action" id="task-status">${tasks.status}</span>
											</div>

										</li>
									</c:forEach>

								</ul>
							
						</div>
					</div>
				</div>				
			</div>
		</div>
	</div>



	


	

		<script
			src="https://cdn.jsdelivr.net/gh/bbbootstrap/libraries@main/choices.min.js"></script>
		<script src="${pageContext.request.contextPath}/js/ScrumValidation.js"></script>
		<script type="text/javascript"
			src="https://www.gstatic.com/charts/loader.js"></script>
		<script
			src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.9.4/Chart.js"></script>


		<script
			src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.9.4/Chart.js"></script>
		<script
			src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
		<script
			src="https://cdnjs.cloudflare.com/ajax/libs/easy-pie-chart/2.1.6/jquery.easypiechart.min.js"></script>
			<c:if test="${not empty successMessage || not empty errorMsg}">
	
			<script type="text/javascript">
				var successMessage = "${successMessage}";
		        if (successMessage) {
		            toastr.success(successMessage);
		        }
		
		        var errorMessage = "${errorMsg}";
		        if (errorMessage) {
		            toastr.error(errorMessage);
		        }		
	        </script>
	
		</c:if>
		<script>
        $(function() {
  $('.chart').easyPieChart({
    size: 160,
    barColor: "#17d3e6",
    scaleLength: 0,
    lineWidth: 15,
    trackColor: "#373737",
    lineCap: "circle",
    animate: 2000,
  });
});
      </script>
		<script>

var xValues = ["Completed", "InComplete"];
var yValues = [ ${completedTasks.size()},   ${incompletedTasksCount}];
var barColors = [
  "#00aba9",
  "#b91d47"

];
new Chart("pieChart", {
  type: "pie",
  data: {
    labels: xValues,
    datasets: [{
      backgroundColor: barColors,
      data: yValues
    }]
  },
  options: {
    title: {
      display: true,
      text: "Task Status"
    }
  }
});
</script>
</body>