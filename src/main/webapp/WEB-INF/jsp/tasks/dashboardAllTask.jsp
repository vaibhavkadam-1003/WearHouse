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

<!-- Datatable plugin JS library file -->
<script defer type="text/javascript"
	src="https://cdn.datatables.net/1.10.22/js/jquery.dataTables.min.js">
</script>
<script src="${pageContext.request.contextPath}/js/common.js"></script>
<link href="${pageContext.request.contextPath}/css/task.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/css/table.css" rel="stylesheet">



<style>
	table.dataTable thead th, table.dataTable thead td {
    padding: 10px 10px;
    border-bottom: 1px solid #838282;
    font-size: 13px;
    font-weight: 600;
}


 
  
</style>

</head>
<body>
	<jsp:include page="../common/header.jsp"></jsp:include>
	
	<div class="main-content" style="position: relative;">
	<jsp:include page="./queryBuilder.jsp"></jsp:include>
	<div class="col-md-12 title mb-2">
			<h4 class="">Active Sprint Tasks</h4>
		</div>
	<div class=" ">
	<div class="query-bulider" >
		<button class="btn btn-sm" id="query-bulider-btn"> PQL</button>
	</div>
<%-- 	<div class="filter_dropdown">
	<dl class="dropdown">
      <dt  >
   			<a href="#" class=" form-select "  style="height: 30px;"> <span class="hida" >Status</span> <span class="multiSel "></span>  </a>
	   </dt>
      <dd>
        <div class="mutliSelect "  >
        <form id="statusForm" action="${pageContext.request.contextPath}/tasks/filter/status?pageNo=0" method="post" onsubmit="test()">
	          
	          <ul class="dropdown-menu border status-ul" onchange="getStatusValue(this)">
	          	<c:choose>
					<c:when test="${fn:contains(selectedStatus, 'TO-DO')}">
						 <li class="dropdown-item"><input type="checkbox" value="TO-DO" name="status" checked>TO-DO</li>
					</c:when>
					<c:otherwise>
					 <li class="dropdown-item"><input type="checkbox" value="TO-DO" name="status">TO-DO</li>
					</c:otherwise>
				</c:choose>
				<c:choose>
					<c:when test="${fn:contains(selectedStatus, 'Open')}">
						 <li class="dropdown-item"><input type="checkbox" value="Open" name="status" checked>Open</li>
					</c:when>
					<c:otherwise>
					  <li class="dropdown-item"><input type="checkbox" value="Open" name="status">Open</li>
					</c:otherwise>
				</c:choose>
				<c:choose>
					<c:when test="${fn:contains(selectedStatus, 'In-Progress')}">
						<li class="dropdown-item"><input type="checkbox" value="In-Progress" name="status" checked>In-Progress</li>
					</c:when>
					<c:otherwise>
					  <li class="dropdown-item"><input type="checkbox" value="In-Progress" name="status">In-Progress</li>
					</c:otherwise>
				</c:choose>
				
				<c:choose>
					<c:when test="${fn:contains(selectedStatus, 'Rejected')}">
						 <li class="dropdown-item"><input type="checkbox" value="Rejected" name="status" checked>Rejected</li>
					</c:when>
					<c:otherwise>
					   <li class="dropdown-item"><input type="checkbox" value="Rejected" name="status">Rejected</li>
					</c:otherwise>
				</c:choose>
				
				<c:choose>
					<c:when test="${fn:contains(selectedStatus, 'Not an Issue')}">
						 <li class="dropdown-item"><input type="checkbox" value="Not an Issue" name="status" checked>Not an Issue</li>
					</c:when>
					<c:otherwise>
					   <li class="dropdown-item"><input type="checkbox" value="Not an Issue" name="status">Not an Issue</li>
					</c:otherwise>
				</c:choose>
	            
				<c:choose>
					<c:when test="${fn:contains(selectedStatus, 'Fixed')}">
						  <li class="dropdown-item"><input type="checkbox" value="Fixed" name="status" checked>Fixed</li>
					</c:when>
					<c:otherwise>
					    <li class="dropdown-item"><input type="checkbox" value="Fixed" name="status">Fixed</li>
					</c:otherwise>
				</c:choose>
	           
	            <c:choose>
					<c:when test="${fn:contains(selectedStatus, 'Resolved')}">
						  <li class="dropdown-item"><input type="checkbox" value="Resolved" name="status" checked>Resolved</li>
					</c:when>
					<c:otherwise>
					    <li class="dropdown-item"><input type="checkbox" value="Resolved" name="status">Resolved</li>
					</c:otherwise>
				</c:choose>
	           
	             
	         </ul>
         </form>
        </div>
      </dd>
    </dl>
</div> --%>



	<table class="table-new "  id="tableID" style="max-width: 100% !important;">
			<thead>
				
				<tr>
					<th>Title</th>
					<th>Priority</th>
					<th>Story Points</th>
					<th>Status</th>
					<th>Assignee</th>
					<th>Reporter</th>
				</tr>
			</thead>
			<tbody id="task_body">
			
					<c:forEach items="${taskList.content}" var="task">
						<tr>

							<td class="font-size-12 mb-1  px-0 " style="width: 60%;">
								<h5 class="font-size-14 mb-1 nowrap">
									<c:choose>
										<c:when test="${task.taskType eq 'Task'}">
											<i class="fa fa-check-square text-primary" aria-hidden="true"></i>
										</c:when>
										<c:when test="${task.taskType eq 'Bug'}">
											<i class="fa fa-stop-circle text-danger" aria-hidden="true"></i>
										</c:when>
										<c:when test="${task.taskType eq 'User Story'}">
											<i class="fa fa-bookmark text-success" aria-hidden="true"></i>
										</c:when>
										<c:otherwise>
											<i class="fa-solid fa-bolt" aria-hidden="true" style="color: #904ee2; font-size: 17px"></i>
										</c:otherwise>
									</c:choose>
									<a class="project-initial-name"
										href="${pageContext.request.contextPath}/tasks/updateTaskForm/${task.id}/${projectId}"
										class="text-success">${task.ticket}</a> <a class="colorLight"
										href="${pageContext.request.contextPath}/tasks/updateTaskForm/${task.id}/${projectId}"
										class="text-success">${task.title}</a>
								</h5>
							</td>
							<td class="font-size-12 mb-1  px-0" style="width:10%;">
							
								<c:choose>
									<c:when test="${task.priority eq 'Low'}">
										<span class="badge priority-low">  ${task.priority} </span>
									</c:when>
									<c:when test="${task.priority eq 'Medium'}">
										<span class="badge priority-medium">  ${task.priority} </span>
									</c:when>
									<c:otherwise>
										<span class="badge priority-high">  ${task.priority} </span>
									</c:otherwise>
								</c:choose>
								
							  </td>
							<td class="font-size-12 mb-1 px-0" style="width:10%;">${task.story_point}</td>
							<td class="font-size-12 mb-1 px-0" style="width:10%;">
							<c:choose>
									<c:when test="${task.status eq 'TO-DO'}">
										<span class="badge lavender-pinocchio">  ${task.status} </span>
									</c:when>
									<c:when test="${task.status eq 'In-Progress'}">
										<span class="badge lavender-mist">  ${task.status} </span>
									</c:when>
									<c:when test="${task.status eq 'Open'}">
										<span class="badge lavender-pinocchio">  ${task.status} </span>
									</c:when>
									<c:when test="${task.status eq 'Rejected'}">
										<span class="badge aqua-spring">  ${task.status} </span>
									</c:when>
									<c:when test="${task.status eq 'Active'}">
										<span class="badge badge-soft-primary ">  ${task.status} </span>
									</c:when>
										<c:when test="${task.status eq 'Inactive'}">
										<span class="badge in-active">  ${task.status} </span>
									</c:when>
									<c:otherwise>
										<span class="badge aqua-spring">  ${task.status} </span>
									</c:otherwise>
								</c:choose>
								<td class="font-size-12 mb-1 px-0" style="width:10%; text-transform:capitalize;">${task.assigneName}</td>
								<td class="font-size-12 mb-1 px-0" style="width:10%; text-transform:capitalize;">${task.reporter}</td>
						</tr>
					</c:forEach>
				</tbody>
		</table>
	</div>
</div>

<link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.min.js"></script>

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

			loadTable(${taskList.number}, ${taskList.numberOfElements});
			
			 $("#query-bulider-btn").click(function(){
				  $(".filter_dropdown").toggleClass("filter_dropdown2");
				  $(".query-bulider").toggleClass("query-bulider-new");
			    $("#query-bulider-wrapper").toggle();
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
		
		function getStatusValue(e){
			selections = [];
			let ul_status = document.getElementsByClassName('status-ul')[0];
			let inpts = ul_status.getElementsByTagName('input');
			for(var i=0;i<inpts.length;i++){
				if(inpts[i].checked){
					selections.push(inpts[i].value);
				}
			}

		  if(selections.length==0){
			  let a = document.createElement('a');
			  a.setAttribute('href','${pageContext.request.contextPath}/tasks?pageNo=0');
			  a.click();
		  }else{
			  document.getElementById('statusForm').submit();
		  }
		}
	</script>
</body>
</html>