<%@page import="com.pluck.dto.LoginUserDto"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html>
<head>

<meta content="initial-scale=1, maximum-scale=1, user-scalable=0" name="viewport" />
<meta name="viewport" content="width=device-width" />
<link href="${pageContext.request.contextPath}/css/task.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/css/table.css" rel="stylesheet">
<link rel = "stylesheet" type = "text/css"   href = "https://cdn.datatables.net/1.12.1/css/jquery.dataTables.min.css" />
<link rel="stylesheet" href="https://cdn.datatables.net/1.10.22/css/jquery.dataTables.min.css" />
	
<style>
table.dataTable thead th, table.dataTable thead td {
	padding: 10px 10px;
	border-bottom: 1px solid #838282;
	font-size: 13px;
	font-weight: 600;
}

.dropdown-menu li {
    padding: 0.25rem 0.7rem !important;
}

#tableID_filter {
    position: absolute;
    top: -32px;
    right: 10px;
}
.dataTables_info{
	display: block !important;
}
 
</style>

</head>
<body>
	<jsp:include page="../common/header.jsp"></jsp:include>
	<input type="hidden" id="contextPathInput"  value="${pageContext.request.contextPath}">
	<div class="main-content"  style="position: relative">
		<jsp:include page="./queryBuilder.jsp"></jsp:include>
		
		<div class="col-md-12 title mb-2">
			<h4 class="">All Tasks</h4>
		</div>

		<div class=" ">
			<div class="d-flex justify-content-start align-items-center">


				<select id="filter" class="common_filter  form-select"
					onchange="getTaskValue(this)">
					<option value="" selected>Select Type</option>
					<option value="Task">Task</option>
					<option value="Bug">Bug</option>
					<option value="User Story">Story</option>
					<option value="Epic">Epic</option>
				</select>

				<div class="common_filter">
					<dl class="dropdown">
						<dt>
							<a href="#" class=" form-select " style="height: 30px;"> <span
								class="hida">Status</span> <span class="multiSel "></span>
							</a>
						</dt>
						<dd>
							<div class="mutliSelect ">
								<form id="statusForm">
									<ul class="dropdown-menu border status-ul"
										onchange="getStatusValue(this)">
										<c:choose>
											<c:when test="${fn:contains(selectedStatus, 'TO-DO')}">
												<li class="dropdown-item"><input type="checkbox"
													value="TO-DO" name="status" checked>TO-DO</li>
											</c:when>
											<c:otherwise>
												<li class="dropdown-item"><input type="checkbox"
													value="TO-DO" name="status">TO-DO</li>
											</c:otherwise>
										</c:choose>
										<c:choose>
											<c:when test="${fn:contains(selectedStatus, 'Open')}">
												<li class="dropdown-item"><input type="checkbox"
													value="Open" name="status" checked>Open</li>
											</c:when>
											<c:otherwise>
												<li class="dropdown-item"><input type="checkbox"
													value="Open" name="status">Open</li>
											</c:otherwise>
										</c:choose>
										<c:choose>
											<c:when test="${fn:contains(selectedStatus, 'In-Progress')}">
												<li class="dropdown-item"><input type="checkbox"
													value="In-Progress" name="status" checked>In-Progress</li>
											</c:when>
											<c:otherwise>
												<li class="dropdown-item"><input type="checkbox"
													value="In-Progress" name="status">In-Progress</li>
											</c:otherwise>
										</c:choose>

										<c:choose>
											<c:when test="${fn:contains(selectedStatus, 'Rejected')}">
												<li class="dropdown-item"><input type="checkbox"
													value="Rejected" name="status" checked>Rejected</li>
											</c:when>
											<c:otherwise>
												<li class="dropdown-item"><input type="checkbox"
													value="Rejected" name="status">Rejected</li>
											</c:otherwise>
										</c:choose>

										<c:choose>
											<c:when test="${fn:contains(selectedStatus, 'Not an Issue')}">
												<li class="dropdown-item"><input type="checkbox"
													value="Not an Issue" name="status" checked>Not an
													Issue</li>
											</c:when>
											<c:otherwise>
												<li class="dropdown-item"><input type="checkbox"
													value="Not an Issue" name="status">Not an Issue</li>
											</c:otherwise>
										</c:choose>

										<c:choose>
											<c:when test="${fn:contains(selectedStatus, 'Fixed')}">
												<li class="dropdown-item"><input type="checkbox"
													value="Fixed" name="status" checked>Fixed</li>
											</c:when>
											<c:otherwise>
												<li class="dropdown-item"><input type="checkbox"
													value="Fixed" name="status">Fixed</li>
											</c:otherwise>
										</c:choose>

										<c:choose>
											<c:when test="${fn:contains(selectedStatus, 'Resolved')}">
												<li class="dropdown-item"><input type="checkbox"
													value="Resolved" name="status" checked>Resolved</li>
											</c:when>
											<c:otherwise>
												<li class="dropdown-item"><input type="checkbox"
													value="Resolved" name="status">Resolved</li>
											</c:otherwise>
										</c:choose>


									</ul>
								</form>
							</div>
						</dd>
					</dl>
				</div>

				<div class="query-bulider">
					<button class="btn btn-sm" id="query-bulider-btn">PQL</button>
				</div>

			</div>


			<div id="tableContainer">

				<table id="tableID" class="display" style="width: 100%">
					<thead>
						<tr>
							<th style="width: 60%;">Title</th>
							<th style="width: 10%;">Priority</th>
							<th style="width: 10%;">Story Points</th>
							<th style="width: 10%;">Status</th>
							<th style="width: 10%;">Assignee</th>
							<th style="width: 10%;">Reporter</th>
							<th style="width: 10%; display: none;">Task Type</th>
						</tr>
					</thead>
					<tbody>
					
					</tbody>
				</table>
			</div>


		</div>

	</div>
<script type = "text/javascript"  src = " https://cdn.datatables.net/1.12.1/js/jquery.dataTables.min.js"></script>
<script src="${pageContext.request.contextPath}/js/datatable-lazy-loading.js"></script>
<script src="${pageContext.request.contextPath}/js/allTask.js"></script>
<script defer type="text/javascript" src="https://cdn.datatables.net/1.10.22/js/jquery.dataTables.min.js"></script>

<script> 	
		
		var suggestions ;
	
		//end of query builder
		
		var selections = [];
		if(${selectedStatus.size()  == 1} && !${fn:contains(selectedStatus, 'None')}){
			$('.multiSel').text(' ');
	    	 var html = '<span title="${selectedStatus.get(0)}" >${selectedStatus.get(0)}</span>';
	    	
			    $(".multiSel").append(html);
			    $(".multiSel").addClass("status-Badge")
			   
			    $(".hida").hide();
		}else{
			if(${selectedStatus.size()  >= 1} && !${fn:contains(selectedStatus, 'None')}){
			 $('.multiSel').text(' ');
			    var html = '<span title="Status">Status</span>' ;
			    $(".multiSel").append(html);
			    $(".hida").hide(); 	
			    $(".multiSel").removeClass('status-Badge');
			 $(".multiSel").text(${selectedStatus.size()}  + " selected");
			}
		}
		var counter ;
		$(document).ready( function() {				
			 $("#query-bulider-btn").click(function(){
				  $(".filter_dropdown").toggleClass("filter_dropdown2");
				  $(".query-bulider").toggleClass("query-bulider-new");
			    $("#query-bulider-wrapper").toggle();
			    $(".filter").toggleClass("filter_dropdown2");
			    
			  });
		}); 
	
		$(".dropdown dt a").on("click", function () {
		  $(".dropdown dd ul").slideToggle("fast");
		});

		$(".dropdown dd ul li a").on("click", function () {
		  $(".dropdown dd ul").hide();
		});

		function getSelectedValue(id) {
		  return $("#" + id)
		    .find("dt a span.value")
		    .html();
		}

		$(document).bind("click", function (e) {
		  var $clicked = $(e.target);
		  if (!$clicked.parents().hasClass("dropdown")) $(".dropdown dd ul").hide();
		});
		
		$('.mutliSelect input[type="checkbox"]').on("click", function () {
			var multiSelect = document.getElementsByClassName('mutliSelect')[0];
			var inputs =multiSelect.getElementsByTagName('input');
			var counter = 0;
			for(var i = 0;i<inputs.length;i++){
				if(inputs[i].checked){
					counter++;
				}
			}
		  var   title = $(this) .closest(".mutliSelect")
		      .find('input[type="checkbox"]:checked').val() + ",";
		  if(counter == 0){
			    $('.multiSel').text(' ');
			    var html = '<span title="Status">Status</span>' ;
			    $(".multiSel").append(html);
			    $(".hida").hide(); 	
			    $(".multiSel").removeClass('status-Badge');
			    
		    }else if(counter == 1){
			    $('.multiSel').text(' ');
		    	 var html = '<span title="' + title + '" >' + title + "</span>";
		    	
				    $(".multiSel").append(html);
				    $(".multiSel").addClass("status-Badge")
				   
				    $(".hida").hide();
		    }else{
		    	 $(".multiSel").text(counter  + " selected");
		    }
		});
		
		function getPriorityClass(priority) {
		    if (priority === 'Low') {
		        return 'priority-low';
		    } else if (priority === 'Medium') {
		        return 'priority-medium';
		    } else {
		        return 'priority-high';
		    }
		}
		
		function getStatusClass(status) {
		    switch (status) {
		        case 'TO-DO':
		            return 'lavender-pinocchio';
		        case 'In-Progress':
		            return 'lavender-mist';
		        case 'Open':
		            return 'lavender-pinocchio';
		        case 'Rejected':
		            return 'aqua-spring';
		        case 'Active':
		            return 'badge-soft-primary';
		        case 'Inactive':
		            return 'in-active';
		        default:
		            return 'aqua-spring';
		    }
		}

	
		
		function getStatusValue(e){
			
			selections = [];
			let ul_status = document.getElementsByClassName('status-ul')[0];
			let inpts = ul_status.getElementsByTagName('input');
			

			for(var i=0;i<inpts.length;i++){
				if(inpts[i].checked){
					selections.push(inpts[i].value);
				}
			} 
			
			var typeSelect = $('#filter').find(":selected").val();
			
			if (selections.length == 0 && typeSelect == "") {
				  let a = document.createElement('a');
				  a.setAttribute('href', '${pageContext.request.contextPath}/tasks?pageNo=0');
				  a.click();
				}
			else{
			        $.ajax({
			            type: 'POST', 
			            url: '${pageContext.request.contextPath}/tasks/filter/status?pageNo=0',
			            data: { 
			            	
			            	statusValues: selections,
			            	typeValue:typeSelect
			            },
			            success: function (response) {
			                
			                var table1 = $('#tableID').DataTable();
			                table1.clear().draw();

			                const data = response.content;

			                const table = $('<table>').addClass('table-new').attr('id', 'tableID').css('max-width', '100% !important');
			                const thead = $('<thead>');
			                const tbody = $('<tbody>').attr('id', 'task_body');

			                const headerRow = $('<tr>');
			                headerRow.append($('<th>').css('width', '60%').text('Title'));
			                headerRow.append($('<th>').css('width', '10%').text('Priority'));
			                headerRow.append($('<th>').css('width', '10%').text('Story Points'));
			                headerRow.append($('<th>').css('width', '10%').text('Status'));
			                headerRow.append($('<th>').css('width', '10%').text('Assignee'));
			                headerRow.append($('<th>').css('width', '10%').text('Reporter'));
			                headerRow.append($('<th>').css('width', '10%').css('display', 'none').text('Task Type'));
			                thead.append(headerRow);

			                data.forEach(function (task) {
			                    const row = $('<tr>').addClass('iterativeRow');
			                    let iconHtml = '';
			                    
			                    if (task.taskType === 'Task')
			                        iconHtml = '<i class="fa fa-check-square text-primary" aria-hidden="true"></i>';
			                    else if (task.taskType === 'Bug') 
			                        iconHtml = '<i class="fa fa-stop-circle text-danger" aria-hidden="true"></i>';
			                    else if (task.taskType === 'User Story')
			                        iconHtml = '<i class="fa fa-bookmark text-success" aria-hidden="true"></i>';
			                    else
			                    	iconHtml = '<i class="fa-solid fa-bolt" aria-hidden="true" style="color: #904ee2; font-size: 17px;"></i>';
			                    
			                    row.append($('<td>').addClass('font-size-12 mb-1 px-0').css('width', '60%')
			                        .append($('<h5>').addClass('font-size-14 mb-1 nowrap')
			                        	.append(iconHtml)
			                            .append($('<a>').addClass('project-initial-name').addClass('').attr('href', '${pageContext.request.contextPath}/tasks/updateTaskForm/' + task.id).text(task.ticket))
			                            .append($('<a>').addClass('colorLight').addClass('').attr('href', '${pageContext.request.contextPath}/tasks/updateTaskForm/' + task.id).text(task.title))));
			                    row.append($('<td>').addClass('font-size-12 mb-1 px-0').css('width', '10%')
			                        .append($('<span>').addClass('badge ' + getPriorityClass(task.priority)).text(task.priority)));
			                    row.append($('<td>').addClass('font-size-12 mb-1 px-0').css('width', '10%').text(task.story_point));
			                    row.append($('<td>').addClass('font-size-12 mb-1 px-0').css('width', '10%')
			                        .append($('<span>').addClass('badge ' + getStatusClass(task.status)).text(task.status)));
			                    row.append($('<td>').addClass('font-size-12 mb-1 px-0').css('width', '10%').text(task.assigneName));
			                    row.append($('<td>').addClass('font-size-12 mb-1 px-0').css('width', '10%').text(task.reporter));
			                    row.append($('<td>').addClass('font-size-12 mb-1 px-0 status-option').css('width', '10%').css('display', 'none').text(task.taskType));
			                    tbody.append(row);
			                });
							
			                table.append(thead);
			                table.append(tbody);
			                
			                $('#tableContainer').empty().append(table);

			               
			                $('#tableID').DataTable();
			            },
			            error: function (error) {
			             
			            }
			        });
			}

		}
		
		function getTaskValue(e){
			
			selections = [];
			let ul_status = document.getElementsByClassName('status-ul')[0];
			let inpts = ul_status.getElementsByTagName('input');
			
			var typeSelect = $('#filter').find(":selected").val();

			for(var i=0;i<inpts.length;i++){
				if(inpts[i].checked){
					selections.push(inpts[i].value);
				}
			}
			
			if (selections.length == 0 && typeSelect == "") {
				  let a = document.createElement('a');
				  a.setAttribute('href', '${pageContext.request.contextPath}/tasks?pageNo=0');
				  a.click();
				}
			else{
				
		        $.ajax({
		            type: 'POST', 
		            url: '${pageContext.request.contextPath}/tasks/filter/status?pageNo=0',
		            data: { 
		            	
		            	statusValues: selections,
		            	typeValue:typeSelect
		            },
		            success: function (response) {
		                
		                var table1 = $('#tableID').DataTable();
		                table1.clear().draw();

		                const data = response.content;

		                const table = $('<table>').addClass('table-new').attr('id', 'tableID').css('max-width', '100% !important');
		                const thead = $('<thead>');
		                const tbody = $('<tbody>').attr('id', 'task_body');

		                const headerRow = $('<tr>');
		                headerRow.append($('<th>').css('width', '60%').text('Title'));
		                headerRow.append($('<th>').css('width', '10%').text('Priority'));
		                headerRow.append($('<th>').css('width', '10%').text('Story Points'));
		                headerRow.append($('<th>').css('width', '10%').text('Status'));
		                headerRow.append($('<th>').css('width', '10%').text('Assignee'));
		                headerRow.append($('<th>').css('width', '10%').text('Reporter'));
		                headerRow.append($('<th>').css('width', '10%').css('display', 'none').text('Task Type'));
		                thead.append(headerRow);

		                data.forEach(function (task) {
		                    const row = $('<tr>').addClass('iterativeRow');
		                    
		                    let iconHtml = '';
		                    
		                    	if (task.taskType === 'Task') 
		                       		 iconHtml = '<i class="fa fa-check-square text-primary" aria-hidden="true"></i>';
		                        else if (task.taskType === 'Bug') 
		                       		 iconHtml = '<i class="fa fa-stop-circle text-danger" aria-hidden="true"></i>';
		                        else if (task.taskType === 'User Story')
		                             iconHtml = '<i class="fa fa-bookmark text-success" aria-hidden="true"></i>';
		                        else
		                    	     iconHtml = '<i class="fa-solid fa-bolt" aria-hidden="true" style="color: #904ee2; font-size: 17px;"></i>';	 
		                                    
		                    row.append($('<td>').addClass('font-size-12 mb-1 px-0').css('width', '60%')
		                        .append($('<h5>').addClass('font-size-14 mb-1 nowrap')
		                        	.append(iconHtml)
		                            .append($('<a>').addClass('project-initial-name').addClass('').attr('href', '${pageContext.request.contextPath}/tasks/updateTaskForm/' + task.id).text(task.ticket))
		                            .append($('<a>').addClass('colorLight').addClass('').attr('href', '${pageContext.request.contextPath}/tasks/updateTaskForm/' + task.id).text(task.title))));
		                    row.append($('<td>').addClass('font-size-12 mb-1 px-0').css('width', '10%')
		                        .append($('<span>').addClass('badge ' + getPriorityClass(task.priority)).text(task.priority)));
		                    row.append($('<td>').addClass('font-size-12 mb-1 px-0').css('width', '10%').text(task.story_point));
		                    row.append($('<td>').addClass('font-size-12 mb-1 px-0').css('width', '10%')
		                        .append($('<span>').addClass('badge ' + getStatusClass(task.status)).text(task.status)));
		                    row.append($('<td>').addClass('font-size-12 mb-1 px-0').css('width', '10%').text(task.assigneName));
		                    row.append($('<td>').addClass('font-size-12 mb-1 px-0').css('width', '10%').text(task.reporter));
		                    row.append($('<td>').addClass('font-size-12 mb-1 px-0 status-option').css('width', '10%').css('display', 'none').text(task.taskType));
		                    tbody.append(row);
		                });

		                table.append(thead);
		                table.append(tbody);
		                
		                $('#tableContainer').empty().append(table);

		               
		                $('#tableID').DataTable();
		            },
		            error: function (error) {
		             
		            }
		        });
		}
		    
		}
	</script>
</body>
</html>