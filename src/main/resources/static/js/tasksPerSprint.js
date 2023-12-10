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

function completeSprint(basePath, sprintId) {
	$
		.ajax({
			type: "GET",
			url: basePath + "/sprints/close-sprint-info/" + sprintId,
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
						url: basePath + "/sprints/tasks/" + sprintId,
						async: false,
						success: function(data) {
							if (data.tasks.length === 0) {
								$('#taskContainer').hide();
							} else {
								$('#taskContainer').show();
							}
							$('#complete-sprint-tasks').empty();
							for (const element of data.tasks) {
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
								backlogAnchor.setAttribute('class', 'carry-forward-task-links');
								backlogAnchor.setAttribute('onclick', "addToBacklog('" + temp.id + "')");
								backlogAnchor.innerHTML = "Backlog";
								let hiddenTaskElement = '<input type="hidden" name="taskIdsToDelete[' + index + ']" id="sprintId" value="' + temp.id + '" />';
								$('#id-backlog-task-ids').append(hiddenTaskElement);
								index++;
								div7.appendChild(backlogAnchor);

								let nextSprintAnchor = document.createElement('select');
								
								var sprintOptions = "<option selected='selected'>Next Sprint</option>";
								for (const sprint of data.nextSprints) {
									if(sprintId != sprint.id){
										sprintOptions += "<option value='"+sprint.id+"'>" + sprint.name + "</option>";
									}
								}
								nextSprintAnchor.innerHTML = sprintOptions;
								nextSprintAnchor.setAttribute('onchange', "addToSprint(" + temp.id + ")");
								nextSprintAnchor.setAttribute('id', "sprint"+temp.id);
								div7.appendChild(nextSprintAnchor);
								div4.appendChild(div5);
								div4.appendChild(div6);
								div4.appendChild(div7);
								div3.appendChild(div4);
								div1.appendChild(div2);
								div1.appendChild(div3);
								li.appendChild(div1);
								document.getElementById('complete-sprint-tasks').appendChild(li);

							}
						}
					});
				$('#sprintInfoModal').modal('show');
			}
		});
}

function sprintStatus(basePath, sprintId) {
	$
		.ajax({
			type: "GET",
			url: basePath + "/sprints/current-sprint-status/" + sprintId,

			async: false,
			success: function(data) {
				$('#current-sprint-scrum-team-list').empty();
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
					+ "  days remaining";

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
			url: basePath + "/sprints/current-sprint-user-chart-details/" + sprintId,
			async: false,
			success: function(data) {

				if(data.length >  0){
					let mainArray = [['User', 'total', 'incomplete',
									'complete']];
								for (var i = 0; i < data.length; i++) {
									let temp = [data[i].name,
									data[i].totalStoryPoints,
									data[i].incompleteStoryPoints,
									data[i].completedStoryPoints];
									mainArray.push(temp);
								}
				
								let combodata = google.visualization.arrayToDataTable(mainArray);
								combochartFunction(combodata, 'chart_div');
								$("#data-div").show();
								$("#no-data-div").hide();
				} else{
					
					$("#no-data-div").show();
					$("#data-div").hide();
				}
				
			}
		});




	$
		.ajax({
			type: "GET",
			url: basePath + "/sprints/current-sprint-scrum-teams/" + sprintId,
			async: false,
			success: function(data) {
				$('#sprint-scrum-team-list').empty();
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

function taskFilter(basePath,sprintId, e) {
	document.getElementById('sprint-task-top').innerHTML = "";

	$
		.ajax({
			type: "GET",
			url: basePath + "/sprints/tasks/filter/" + sprintId + "?status=" + e.value,
			   
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

function addToSprint(taskId) {
	const element = document.getElementById('draggable' + taskId);
	var val = $('#sprint'+taskId+' option:selected').val();
	let hiddenTaskElement = '<input type="hidden" name="newSprintTasks[' + val + ']"  value="' + taskId + '" />';
	$('#newSprintasks').append(hiddenTaskElement);
	element.remove();
}

let index = 0;
function addToBacklog(taskId) {
	const element = document.getElementById('draggable' + taskId);
	element.remove();
	let hiddenTaskElement = '<input type="hidden" name="taskIdsToDelete[' + index + ']" id="sprintId" value="' + taskId + '" />';
	$('#id-backlog-task-ids').append(hiddenTaskElement);
	index++;
}


$(document).ready(function() {

	$('#sprintInfoModal').modal({ backdrop: 'static', keyboard: false }, 'show');
	$('#sprintStatusModal').modal({ backdrop: 'static', keyboard: false }, 'show');


});

