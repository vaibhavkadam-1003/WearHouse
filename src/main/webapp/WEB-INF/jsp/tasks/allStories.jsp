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

<!-- jQuery library file -->
<script type="text/javascript"
	src="https://code.jquery.com/jquery-3.5.1.js">
	
</script>

<!-- Datatable plugin JS library file -->
<script defer type="text/javascript"
	src="https://cdn.datatables.net/1.10.22/js/jquery.dataTables.min.js">
	
</script>
<script src="${pageContext.request.contextPath}/js/common.js"></script>
<link href="${pageContext.request.contextPath}/css/table.css" rel="stylesheet">

<style type="text/css">

table.dataTable thead th, table.dataTable thead td {
    padding: 10px 5px!important;
    border-bottom: 1px solid #838282;
    font-size: 13px;
    font-weight: 600;
}

	.ellipsis-info {
  white-space: nowrap;
  overflow: hidden;
  max-width: 550px !important;
  text-overflow: hidden;
  margin-left: 10px;
   
}
</style>

</head>
<body>
	<jsp:include page="../common/header.jsp"></jsp:include>
	<div class="main-content ">



		<div class="row">
			<table
				class="table table align-middle table-nowrap table-hover table-borderless"
				id="tableID" style="max-width: 100% !important;">
				<thead>
					
					<tr>
					<td class="ps-3" style="width:60%;"> Name</td>
					<td class="ps-2" style="width:10%;"> Type</td>
					<td class="ps-2" style="width:10%;"> Priority</td>
					<td class="ps-2" style="width:10%;"> Status</td>
					<td class="ps-2" style="width:10%;"> Assigned-To</td>
					<td class="ps-3 text-center" style="width:10%;">Action</td>
					</tr>
					
				</thead>
				<tbody>
				
					<c:forEach items="${list.content}" var="story">

						<tr>

							<td style="width:60%;">
								<div class=" d-flex justify-content-start align-items-center">
									<a class="project-badge bg-secondary ">${story.task.ticket}</a> 
											<a class="colorLight pluck-capitalize ellipsis-info">${story.task.title}</a>
									
									
								</div>
							</td>

							<td class="font-size-12 mb-1" style="width:10%;"> <span class="badge priority">  ${story.storyType} </span></td>
							<td class="font-size-12 mb-1"   style="width:10%;"><span class="">
												<c:choose>
													<c:when test="${story.task.priority eq 'Low'}">
														<span class="badge priority-low">  ${story.task.priority} </span>
													</c:when>
													<c:when test="${story.task.priority eq 'Medium'}">
														<span class="badge priority-medium">  ${story.task.priority} </span>
													</c:when>
													<c:otherwise>
														<span class="badge priority-high">  ${story.task.priority} </span>
													</c:otherwise>
												</c:choose>
											</span> </td>
   
							<td class="font-size-12 mb-1 " style="width: 10%;"><c:choose>
									<c:when test="${story.task.status eq 'TO-DO'}">
										<span class="badge lavender-pinocchio">
											${story.task.status} </span>
									</c:when>
									<c:when test="${story.task.status eq 'In-Progress'}">
										<span class="badge lavender-mist"> ${story.task.status}
										</span>
									</c:when>
									<c:when test="${story.task.status eq 'Open'}">
										<span class="badge lavender-pinocchio">
											${story.task.status} </span>
									</c:when>
									<c:when test="${story.task.status eq 'Rejected'}">
										<span class="badge aqua-spring"> ${story.task.status} </span>
									</c:when>
									<c:when test="${story.task.status eq 'Active'}">
										<span class="badge badge-soft-primary "> ${story.task.status} </span>
									</c:when>
									<c:when test="${story.task.status eq 'Inactive'}">
										<span class="badge in-active"> ${story.task.status} </span>
									</c:when>
									<c:otherwise>
										<span class="badge aqua-spring"> ${story.task.status} </span>
									</c:otherwise>
								</c:choose></td>
								
								<td class="font-size-12 mb-1 px-0" style="width:10%; text-transform:capitalize;">${story.task.assigneName}</td>

							<td  class="font-size-12 mb-1 text-center" style="width:10%;">
								<a href="${pageContext.request.contextPath}/stories/updateStoryForm/${story.id}" class="text-success"> 
								<i class="fa fa-pencil-square text-primary" aria-hidden="true"></i></a>
							</td>
						</tr>
					</c:forEach>

				</tbody>

			</table>
		</div>
	</div>
	
	<script> 		
		$(document).ready( function() {
			loadTable(${list.number}, ${list.numberOfElements});
		}); 
	</script>
</body>
</html>