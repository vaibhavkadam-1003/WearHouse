$(document).ready(function() {

	let contextPath = $("#contextPathInput").val();

	let columnsInfo = [
		{
			data: 'title',
			render: function(data, type, row) {
				var icon = '';
				if (row.taskType === 'Task') {
					icon = '<i class="fa fa-check-square text-primary" aria-hidden="true"></i>';
				} else if (row.taskType === 'Bug') {
					icon = '<i class="fa fa-stop-circle text-danger" aria-hidden="true"></i>';
				} else if (row.taskType === 'User Story') {
					icon = '<i class="fa fa-bookmark text-success" aria-hidden="true"></i>';
				} else if (row.taskType === 'Epic') {
					icon = '<i class="fa-solid fa-bolt" aria-hidden="true" style="color: #904ee2; font-size: 17px"></i>';
				}

				var link = '';
				if (row.id && row.title) {
					link = '<a class="project-initial-name" href="' + contextPath + '/tasks/updateTaskForm/' + row.id + '" class="text-success">' + row.ticket + '</a>' +
						'<a class="colorLight" href="' + contextPath + '/tasks/updateTaskForm/' + row.id + '" class="text-success">' + row.title + '</a>';
				}

				return '<h5 class="font-size-14 mb-1 nowrap">' + icon + link + '</h5>';
			}
		},
		{
			data: 'priority',
			render: function(data, type, row) {
				var priorityBadge = '';
				if (row.priority === 'Low') {
					priorityBadge = '<span class="badge priority-low"> ' + row.priority + ' </span>';
				} else if (row.priority === 'Medium') {
					priorityBadge = '<span class="badge priority-medium"> ' + row.priority + ' </span>';
				} else if (row.priority === 'High') {
					priorityBadge = '<span class="badge priority-high"> ' + row.priority + ' </span>';
				} else {
					priorityBadge = '<span class="badge"> ' + (row.priority ? row.priority : 'N/A') + ' </span>';
				}
				return priorityBadge;
			}
		},
		{
			data: 'story_point',
			render: function(data, type, row) {
				if (row.story_point) {
					return row.story_point;
				} else {
					return 'NA';
				}
			}
		},
		{
			data: 'status',
			render: function(data, type, row) {
				var statusBadge = '';

				if (!row.status) {
					statusBadge = '<span class="badge">N/A</span>'; // Or any default representation for null/undefined status
				} else {
					switch (row.status) {
						case 'TO-DO':
							statusBadge = '<span class="badge lavender-pinocchio">' + row.status + '</span>';
							break;
						case 'In-Progress':
							statusBadge = '<span class="badge lavender-mist">' + row.status + '</span>';
							break;
						case 'Open':
							statusBadge = '<span class="badge lavender-pinocchio">' + row.status + '</span>';
							break;
						case 'Rejected':
							statusBadge = '<span class="badge rejected">' + row.status + '</span>';
							break;
						case 'Active':
							statusBadge = '<span class="badge badge-soft-primary ">' + row.status + '</span>';
							break;
						case 'Inactive':
							statusBadge = '<span class="badge in-active">' + row.status + '</span>';
							break;
						default:
							statusBadge = '<span class="badge aqua-spring">' + row.status + '</span>';
					}
				}
				return statusBadge;
			}
		},
		{
			data: 'assigneName',
			render: function(data, type, row) {
				if (row.assigneName) {
					return '<span class="font-size-12 mb-1 px-0" style="width: 10%; text-transform: capitalize;">' + row.assigneName + '</span>';
				} else {
					return '<span class="font-size-12 mb-1 px-0" style="width: 10%; text-transform: capitalize;">N/A</span>';
				}
			}
		},

		{
			data: 'reporter',
			render: function(data, type, row) {
				if (row.reporter) {
					return '<span class="font-size-12 mb-1 px-0" style="width: 10%; text-transform: capitalize;">' + row.reporter + '</span>';
				} else {
					return '<span class="font-size-12 mb-1 px-0" style="width: 10%; text-transform: capitalize;">N/A</span>';
				}
			}
		},

		{
			data: 'taskType',
			render: function(data, type, row) {
				if (row.taskType) {
					return '<span class="font-size-12 mb-1 px-0 status-option d-none" style="width: 10%; text-transform: capitalize;">' + row.taskType + '</span>';
				} else {
					return '<span class="font-size-12 mb-1 px-0 status-option d-none" style="width: 10%; text-transform: capitalize;">N/A</span>';
				}
			}
		}



	];

	let customDatatable = $('#tableID').lazyLoadingDatatable(contextPath + '/tasks/paginate', {
		columns: columnsInfo,
		'order': [],
		"aoColumnDefs": [{
			'bSortable': false,
			'aTargets': [0]
		}],
	});

});