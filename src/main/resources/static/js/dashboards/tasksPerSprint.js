$(function() {
	$(".draggable").draggable({

	});

	$(".droppable").droppable({
		accept: function(draggable) {
			let checkStatus = draggable.find('.inP').text();
			return checkStatus !== "Resolved" && checkStatus !== "Fixed" && checkStatus !== "In-Progress";
		},
		
		drop: function(event, ui) {
			let draggable = ui.draggable;
			let id1 = draggable.find('.inP1').text();
			$('#valueId').val(id1);
			$('#status').val("In-Progress");
			$(".dragDropForm").submit();
		},
		out: function(event, ui) {

		}
	});

	$(".resolved").droppable({
		accept: function(draggable) {
			let checkStatus = draggable.find('.inP').text();
			return checkStatus === "In-Progress";
		},
		
		drop: function(event, ui) {
			let draggable = ui.draggable;
			let id1 = draggable.find('.inP1').text();
			$('#valueId').val(id1);
			$('#status').val("Fixed");
			$(".dragDropForm").submit();
		},
		out: function(event, ui) {

		}
	});

});

function completeSprint(basePath,id,projectId) {
	$
		.ajax({
			type: "GET",
			url: basePath + "/sprints/close-sprint-info/id/"+id+"/project/"+projectId,
			async: false,
			success: function(data) {
				document.getElementById('sprint-total-task-count').innerHTML = data['totalTask'];
				document.getElementById('sprint-completed-task-count').innerHTML = data['completed'];
				document.getElementById('sprint-incomplete-task-count').innerHTML = data['incomplete'];
				document.getElementById('sprint-task-total-story-points').innerHTML = data['totalStoryPoints'];
				document.getElementById('sprint-task-completed-story-points').innerHTML = data['completedStoryPoints'];
				document.getElementById('sprint-task-incomplete-story-points').innerHTML = data['remainingStoryPoints'];
				document.getElementById('sprint-task-scrum-team').innerHTML = data['teams'];
				
				let data1 = google.visualization.arrayToDataTable([
					["Element", "Density", {
						role: "style"
					}],
					["Completed", data['completed'],
						"#b87333"],
					["Incomplete", data['incomplete'],
						"silver"]]);
				barChatFunction(data1, 'complete-sprint-bar-chart', "Tasks status");

				$
					.ajax({
						type: "GET",
						url: basePath + "/sprints/current-sprint-tasks/id/"+id+"/project/"+projectId,
						async: false,
						success: function(data) {
							if (data.length === 0) {
								$('#taskContainer').hide(); 
							} else {
								$('#taskContainer').show(); 
							}
							for (const element of data) {
								let temp = element;
								let li = document.createElement('li');
								li.setAttribute('class', 'draggable py-1 list-group-item ui-draggable ui-draggable-handle');
								li.setAttribute('id', 'draggable' + temp.id);

								let div1 = document.createElement('div');
								div1.setAttribute('class', 'row');

								let div2 = document.createElement('div');
								div2.setAttribute('class', 'col-md-8');

							
								let span1 = document.createElement('span');
								span1.setAttribute('class', ' sprintBox-title ');
								span1.innerHTML = temp.title;
								div2.appendChild(span1);
								div1.appendChild(div2);

								let div3 = document.createElement('div');
								div3.setAttribute('class', 'col-md-4 ');

								let div4 = document.createElement('div');
								div4
									.setAttribute('class',
										'd-flex justify-content-between align-items-center');

								let div5 = document.createElement('div');
								div5.setAttribute('class', 'col-md-2 ');
								let span2 = document.createElement('span');
								span2.setAttribute('class', 'badge severity-high ');
								span2.innerHTML = temp.story_point;
								div5.appendChild(span2);

								let div6 = document.createElement('div');
								div6.setAttribute('class', 'col-md-3 ');
								let span3 = document.createElement('span');
								span3.setAttribute('class',
									'badge severity-low');
								span3.innerHTML = temp.priority;
								div6.appendChild(span3);

								let div7 = document.createElement('div');
								div7.setAttribute('class', 'col-md-7');
								let backlogAnchor = document.createElement('a');
								backlogAnchor.href = "javascript:void(0)";
					            backlogAnchor.setAttribute('class','carry-forward-task-links');
					            backlogAnchor.setAttribute('onclick', "addToBacklog('draggable" + temp.id + "')");
								backlogAnchor.innerHTML = "Backlog";
								div7.appendChild(backlogAnchor);

								let nextSprintAnchor = document.createElement('a');
								nextSprintAnchor.href = "javascript:void(0)";
								nextSprintAnchor.setAttribute('onclick', "addToSprint('draggable" + temp.id + "'," + temp.id + ")");
								nextSprintAnchor.innerHTML = "Next sprint";
								nextSprintAnchor.setAttribute('class','carry-forward-task-links');
								nextSprintAnchor.style.textDecoration = "underline";
								div7.appendChild(nextSprintAnchor);

								div4.appendChild(div5);
								div4.appendChild(div6);
								div4.appendChild(div7);
								div3.appendChild(div4);
								div1.appendChild(div2);
								div1.appendChild(div3);

								li.appendChild(div1);
								document.getElementById('complete-sprint-tasks')
									.appendChild(li);

							}
						}
					});		
				$('#sprintInfoModal').modal('show');
			}
		});
}

function sprintStatus(basePath,id,projectId) {
	$
		.ajax({
			type: "GET",
			url: basePath + "/sprints/current-sprint-status/id/"+id+"/project/"+projectId,
			async: false,
			success: function(data) {
				document.getElementById('sprint-total-issue-count').innerHTML = data['totalTasks'];
				document.getElementById('sprint-completed-issue-count').innerHTML = data['completedTasks'];
				document
					.getElementById('sprint-incomplete-issue-count').innerHTML = data['inCompletedTasks'];
				document.getElementById('sprint-total-story-points').innerHTML = data['totalStoryPoints'];
				document
					.getElementById('sprint-completed-story-points').innerHTML = data['completedStoryPoints'];
				document
					.getElementById('sprint-incomplete-story-points').innerHTML = data['remainingStoryPoints'];
					
				document.getElementById('sprint-remaining-days').innerHTML = data['remainingSprintDays']
					+ "  days remain";
					
				document.getElementById('current-sprint-scrum-team-list').innerHTML = data['teams'];
				
				var data2 = google.visualization.arrayToDataTable([
					['Language', 'Speakers (in millions)'],
					['Completed', data['completedTasks']],
					['InComplete', data['inCompletedTasks']],]);
				pieChartFunction(data2, 'piechart');
				var data1 = google.visualization.arrayToDataTable([
					["Element", "Density", {
						role: "style"
					}],
					["Completed", data['completedStoryPoints'],
						"#b87333"],
					["Incomplete", data['remainingStoryPoints'],
						"silver"]]);
				barChatFunction(data1, 'columnchart_values', "Story points");

				$('#sprintStatusModal').modal('show');
			}
		});

	$
		.ajax({
			type: "GET",
			url: basePath + "/sprints/current-sprint-user-chart-details/id/"+id+"/project/"+projectId,
			async: false,
			success: function(data) {

				let mainArray = [['User', 'total', 'incomplete',
					'complete']];
				for (var i = 0; i < data.length; i++) {
					let temp = [data[i].name,
					data[i].totalStoryPoints,
					data[i].incompleteStoryPoints,
					data[i].completedStoryPoints];
					mainArray.push(temp);
				}
				let combodata = google.visualization
					.arrayToDataTable(mainArray);
				combochartFunction(combodata, 'chart_div');
			}
		});

	$
		.ajax({
			type: "GET",
			url: basePath + "/sprints/current-sprint-scrum-teams/id/"+id,
			async: false,
			success: function(data) {
				for (var i = 0; i < data.length; i++) {
					let temp = data[i];
					let li = document.createElement('li');
					li
						.setAttribute('class',
							'list-group-item d-flex align-items-center');
					let iSpan = document.createElement('i');
					iSpan.setAttribute('class',
						'fa-solid fa-people-group');

					li.appendChild(iSpan);
					let span = document.createElement('span');
					span.style.marginLeft = '10px';
					let div1 = document.createElement('div');
					div1.innerHTML = temp.name;
					div1.style.color = "cornflowerblue";
					div1.style.fontWeight = "700";
					span.appendChild(div1);

					let div2 = document.createElement('small');
					div2.innerHTML = temp.members + " members";
					div2.setAttribute('class', 'text-muted');
					span.appendChild(div2);
					li.appendChild(span);
					document.getElementById('sprint-scrum-team-list')
						.appendChild(li);
				}
			}
		});

}

function taskFilter(basePath, e,id) {
	document.getElementById('sprint-task-top').innerHTML = "";

	$
		.ajax({
			type: "GET",
			url: basePath + "/sprints/tasks/filter/id/"+id+"?status=" + e.value,
			async: false,
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
function getTask(basePath) {
	document.getElementById('sprint-task-top').innerHTML = "";
	$
		.ajax({
			type: "GET",
			url: basePath + "/sprints/current-sprint-tasks",
			async: false,
			success: function(data) {
				document.getElementById('all-tasks-sprint-status').setAttribute('disabled', 'disabled');
				buildTaskList(data);
			}
		});
}

function buildTaskList(data) {
	for (var i = 0; i < data.length; i++) {
		let temp = data[i];
		let li = document.createElement('li');
		li
			.setAttribute('class',
				'draggable py-1 list-group-item ui-draggable ui-draggable-handle');
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
var taskIdListTodelete = [];
function addToSprint(elementId, id) {
	const element = document.getElementById(elementId);
	element.remove();
	taskIdListTodelete.push(id);
	document.getElementById('taskIdListTodelete').value=taskIdListTodelete;
}
function addToBacklog(elementId){
	const element = document.getElementById(elementId);
	element.remove();
}

$(document).ready(function() {

	$('#sprintInfoModal').modal({backdrop: 'static', keyboard: false}, 'show');
	$('#sprintStatusModal').modal({backdrop: 'static', keyboard: false}, 'show');

});
