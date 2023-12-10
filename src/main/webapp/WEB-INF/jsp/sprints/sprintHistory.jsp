<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html>
<head>
<meta content="initial-scale=1, maximum-scale=1, user-scalable=0"
	name="viewport" />
<meta name="viewport" content="width=device-width" />
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

<script src="${pageContext.request.contextPath}/js/scrumTeam.js"></script>
<script src="${pageContext.request.contextPath}/js/charts.js"></script>
<script src="${pageContext.request.contextPath}/js/sprintHistory.js"></script>
<link href="${pageContext.request.contextPath}/css/task.css" rel="stylesheet">
</head>
<body>
	<jsp:include page="../common/header.jsp"></jsp:include>
	<div class="main-content" style="height: 170vh !important;">
		<div class="row">
			<div class="col-md-12 title">
				<h4 id="sprint-history-sprint-name"></h4>
			</div>
		</div>

		<div class="row  border" style="background-color: #f3f5f9 !important;">
			<div class="d-flex justify-content-start align-items-center">
				<c:forEach items="${teams}" var="team">
					<div class="shadow-sm scrum-team"
						onclick="getScrumTeamDetails('${team.id}','${sprintId}')">
						<small>${team.name }</small>
						<h4>Member :-${team.members }</h4>
					</div>
				</c:forEach>
			</div>

			<div class="col-md-12 mb-3 " id="scrum-team-history-for-sprint"
				style="display: none;">
				<label id="sprint-history-scrum-team-name" class="m-0"
					style="font-size: 0.9rem; font-weight: 600; color: blueviolet; text-transform: capitalize;"></label>
				<span
					style="float: right; font-weight: 600; color: chocolate; border: 1px solid chocolate; height: 26px; width: 26px; text-align: center; border-radius: 50%;cursor: pointer;" onclick="closeTeamBlock()">X</span>
				<div class="accordion bg-light" id="accordionExample"></div>
			</div>

		</div>

		<div class="row my-2 border"
			style="background-color: #f3f5f9 !important;">
			<div class="col-md-4 bg-light p-2 border">
				<div class="row Rbg-light rounded"
									style="height: 250px;">
									<div
										class=" d-flex justify-content-evenly align-item-center flex-wrap">
										<a href="#" class="text-decoration-none">
											<div class="Project-card" style="background-color: #cfe2ff;">
												<p>All Task</p>
												<h6> ${totalTasks }</h6>
											</div>
										</a> <a href="#" class="text-decoration-none">
											<div class="Project-card" style="background-color: #d1e7dd;">
												<p>Completed</p>
												<h6>${completedTasks }</h6>
											</div>
										</a> <a href="#" class="text-decoration-none">
											<div class="Project-card" style="background-color: #f8d7da;">
												<p>Incomplete</p>
												<h6>${incompletedTasks } </h6>
											</div>
										</a> <a href="#" class="text-decoration-none">
											<div class="Project-card" style="background-color: #e2d9f3;">
												<p>Total Story Point</p>
												<h6>${totalStoryPoints}</h6>
											</div>
										</a> <a href="#" class="text-decoration-none">
											<div class="Project-card" style="background-color: #cff4fc;">
												<p>Completed</p>
												<h6>${completedStoryPoints }</h6>
											</div>
										</a> <a href="#" class="text-decoration-none">
											<div class="Project-card" style="background-color: #fff3cd;">
												<p>Incomplete</p>
												<h6>${incompletedStoryPoints }</h6>
											</div>
										</a> <a href="#" class="text-decoration-none">
											<div class="Project-card scrum-team-card"
												style="background-color: #ffe5d0;">
												<p>Scrum Development Team</p>
												<h6>${teams.size()}</h6>
											</div>
										</a>
									</div>
								</div>
			</div>


			<div class="col-md-4  bg-light p-2 border">
				<div id="columnchart_values" class="p-3 m-1"></div>
			</div>
			<div class="col-md-4  bg-light p-2 border">
				<div id="piechart" class="p-3 mx-1"
					style="width: 100%; height: 270px;"></div>
			</div>
		</div>

		<div class="row">
			<div class="col-md-12 bg-light p-2" style="height: 258px">
				<div class=" mx-2 my-1 bg-light rounded p-2" style="height: 200px;">
					<div id="no-data-div"
						class=" mx-2 my-1 bg-light rounded p-2  border"
						style="height: 250px; position: relative;">
						<div style="position: absolute; top: 44%; left: 44%;">No
							data available</div>
					</div>
					<div id="data-div" class=" mx-2 my-1 bg-light rounded p-2  border"
						style="height: 250px;">
						<div id="chart_div" class="border"></div>
					</div>
				</div>
			</div>
		</div>

		<div class="row">
			<div class="col-md-12 bg-light p-2 border">
				<div class="card col-md-12 border my-1 p-0">
					<div class="card-body card-height">
						<div class="d-flex justify-content-between align-items-center">
						
							<button type="button" id="all-tasks-history" style="display: none;">All Task</button>

							<div style="width: 120px;">
								<select class="form-select" onchange="taskFilter('${pageContext.request.contextPath}',this,'${sprintId }')">
									<option selected value="All">All Tasks</option>
									<option value="Resolved">Completed</option>
									<option value="Incomplete">Incomplete</option>
								</select>
							</div>
						</div>

						<ul class="list-group" id="sprint-task-top">

						</ul>
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
	<script type="text/javascript">
      google.charts.load("current", {packages:["corechart"]});
      google.charts.setOnLoadCallback(drawChart);
      function drawChart() {
        var data = google.visualization.arrayToDataTable([
          ['Language', 'Speakers (in millions)'],
          ['Completed',  ${completedTasks}],
          ['InComplete',  ${incompletedTasks}],
        ]);

      var options = {
        legend: 'none',
        pieSliceText: 'label',
        title: 'Task Status',
        pieStartAngle: 100,
      };

        var chart = new google.visualization.PieChart(document.getElementById('piechart'));
        chart.draw(data, options);
      }
    </script>

	<script type="text/javascript">
    google.charts.load("current", {packages:['corechart']});
    google.charts.setOnLoadCallback(drawChart);
    function drawChart() {
      var data = google.visualization.arrayToDataTable([
        ["Element", "Density", { role: "style" } ],
        ["Completed", ${completedStoryPoints}, "#b87333"],
        ["Incomplete", ${incompletedStoryPoints}, "silver"]
      ]);

      var view = new google.visualization.DataView(data);
      view.setColumns([0, 1,
                       { calc: "stringify",
                         sourceColumn: 1,
                         type: "string",
                         role: "annotation" },
                       2]);

      var options = {
        title: "Story points",
        width: 320,
        height: 310,
        bar: {groupWidth: "95%"},
        legend: { position: "none" },
      };
      var chart = new google.visualization.ColumnChart(document.getElementById("columnchart_values"));
      chart.draw(view, options);
  }
  </script>
	<script type="text/javascript">
	function getTask(id){

		$
		.ajax({
			type : "GET",
			url : "${pageContext.request.contextPath}/sprints/previous-sprint-tasks/"+id,
			async : false,
			success : function(data) {
				document.getElementById('all-tasks-history').setAttribute('disabled','disabled');
				for (var i = 0; i < data.length; i++) {
					let temp = data[i];
					let li = document.createElement('li');
					li.setAttribute('class','draggable py-1 list-group-item ui-draggable ui-draggable-handle');
					li.setAttribute('id','draggable');
					
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
					document.getElementById('sprint-task-top').appendChild(li);
					
			}
			}
		});
	}
    $(window).on('load', function() {
        $('#sprintHistoryModel').modal('show');
        $
		.ajax({
			type : "GET",
			url : "${pageContext.request.contextPath}/sprints/history/sprint-name?sprintId=${sprintId}",
			async : false,
			success : function(data) {
				document.getElementById('sprint-history-sprint-name').innerHTML=data;
			}
		});
        getUserDetails('${pageContext.request.contextPath}',${sprintId});
			
    });
    
    function getScrumTeamDetails(scrumId,sprintId) {
    	 $
 		.ajax({
 			type : "GET",
 			url : "${pageContext.request.contextPath}/scrums/sprint/history/scrum?scrumId="+scrumId,
 			async : false,
 			success : function(data) {
 				document.getElementById('sprint-history-scrum-team-name').innerHTML=data;
 			}
 		});
    	$
		.ajax({
			type : "GET",
			url : "${pageContext.request.contextPath}/scrums/sprint/history/scrum/members?scrumId="+scrumId+"&sprintId="+sprintId,
			async : false,
			success : function(data) {
				document.getElementById('scrum-team-history-for-sprint').style.display="block";
				document.getElementById('accordionExample').innerHTML="";
				for (const p of data) {
					  let username = p.user;
					  let tasks = p.tasks;
					  let div = document.createElement( 'div' );
		                div.setAttribute( 'class', 'accordion-item' );

		                let h2 = document.createElement( 'h2' );
		                h2.setAttribute( 'class', 'accordion-header' );

		                let button = document.createElement( 'button' );
		                button.setAttribute( 'class', 'accordion-button' );
		                button.setAttribute( 'type', 'button' );
		                button.setAttribute( 'data-bs-toggle', 'collapse' );
		                let temp = username.split(" ");
		                let tempStr = temp[0]+""+temp[1];
		                button.setAttribute( 'data-bs-target', '#collapse'+tempStr );
		                button.setAttribute( 'aria-controls', 'collapse'+username  );
		                button.style.height = '30px';
		                button.innerHTML = username;
		                h2.appendChild( button );
		                div.appendChild(h2);

		                let div1 = document.createElement( 'div' );
		                div1.setAttribute( 'id', 'collapse'+tempStr  );
		                div1.setAttribute( 'class', 'accordion-collapse collapse' );
		                div1.setAttribute( 'data-bs-parent', '#accordionExample' );

		                let div2 = document.createElement( 'div' );
		                div2.setAttribute( 'class', 'accordion-body' );

						let ul = document.createElement('ul');
						if(tasks.length == 0){
							var div4 = document.createElement( 'div' );
							div4.style.height="17vh";
			                div4.setAttribute( 'class', 'scrume-add-msg' );
			                var i1 = document.createElement( 'i' );
			                i1.setAttribute( 'class', 'fa fa-tasks' );
			                i1.setAttribute( 'aria-hidden', 'true' );
			                div4.appendChild( i1 );

			                var h3 = document.createElement( 'h3' );
			                h3.innerHTML = "No Tasks are available for this user";
			                div4.appendChild(h3);
			                ul.appendChild(div4);
						}else{
							for(task of tasks){
								let li = document.createElement('li');
								li.setAttribute('class','draggable py-1 list-group-item ui-draggable ui-draggable-handle');
								li.setAttribute('id','draggable');
								
								let div1 = document.createElement('div');
								div1.setAttribute('class','row');
								
								let div2 = document.createElement('div');
								div2.setAttribute('class','col-md-9');
								
								let span1 = document.createElement('span');
								span1.setAttribute('class',' sprintBox-title ');
								span1.innerHTML=task.title;
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
								span2.innerHTML=task.story_point +"/10";
								div5.appendChild(span2);
								
								let div6 = document.createElement('div');
								div6.setAttribute('class','col-md-4 ');
								let span3 = document.createElement('span');
								span3.setAttribute('class','badge sprintBox-priority');
								span3.innerHTML=task.priority;
								div6.appendChild(span3);
								
								let div7 = document.createElement('div');
								div7.setAttribute('class','col-md-5 ');
								let span4 = document.createElement('span');
								span4.setAttribute('class','badge rounded-pill bg-success ');
								span4.innerHTML=task.status;
								div7.appendChild(span4);
								
								div4.appendChild(div5);
								div4.appendChild(div6);
								div4.appendChild(div7);
								div3.appendChild(div4);
								div1.appendChild(div2);
								div1.appendChild(div3);
								
								li.appendChild(div1);
								
								ul.setAttribute('class','list-group');
								ul.setAttribute('class','sprint-scrum-history-ul');
								ul.appendChild(li);
								
							}
						}
					
						
		                div2.appendChild( ul );
		                div1.appendChild( div2 );

		                div.appendChild( div1 );
		                document.getElementById('accordionExample').appendChild(div);
					} 
			}
		});
	}
    
</script>

</body>
</html>
