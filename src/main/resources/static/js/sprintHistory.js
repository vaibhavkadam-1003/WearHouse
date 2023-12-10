function closeTeamBlock(){
	document.getElementById('scrum-team-history-for-sprint').style.display="none";
}

function getUserDetails(basePath,sprintId){
	$
		.ajax({
			type: "GET",
			url: basePath + "/sprints/sprint-history-user-chart-details?sprintId="+sprintId,
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
}

function taskFilter(basePath, e,sprintId) {
	document.getElementById('sprint-task-top').innerHTML = "";

	$
		.ajax({
			type: "GET",
			url: basePath + "/sprints/history/tasks/filter?sprintId="+sprintId+"&"+"status=" + e.value,
			async: false,
			success: function(data) {
				document.getElementById('all-tasks-history').setAttribute('disabled', 'disabled');
				if(data.length == 0){
					var div4 = document.createElement( 'div' );
							div4.style.height="17vh";
			                div4.setAttribute( 'class', 'scrume-add-msg' );
			                var i1 = document.createElement( 'i' );
			                i1.setAttribute( 'class', 'fa fa-tasks ' );
			                i1.setAttribute( 'aria-hidden', 'true' );
			                div4.appendChild( i1 );

			                var h3 = document.createElement( 'h3' );
			                h3.innerHTML = "No Tasks are available for this category";
			                div4.appendChild(h3);
			                document.getElementById('sprint-task-top').appendChild(div4);
				}else{
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