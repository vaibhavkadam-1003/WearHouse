<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<%-- <link href="${pageContext.request.contextPath}/css/task.css" rel="stylesheet"> --%>
</head>
<body>
	<jsp:include page="../common/header.jsp"></jsp:include>


	<div class="main-content ">
	<div class="card" style="height:90vh">
		<div class=card-body>
				<div class="d-flex justify-content-between align-items-center">
					<div>
						<small>Active Sprints </small>
					</div>
					<div class="scrum-search search-scrum-teams">
						<input type="text" id="myFilter" class="form-control "
							onkeyup="sprintFilter()" placeholder="Search For Sprint Name..">
						<i class="fa fa-search" aria-hidden="true"></i>
					</div>
				</div>
				
				<div calss='my-3'>
					<div class="row row-cols-1 row-cols-md-5 g-4">
					<c:forEach items="${activeSprints}" var="sprint">
						<a href="${pageContext.request.contextPath}/sprints/active-sprint-history/${sprint.id}"
							class="scrum-user-card">
						<div class="col my-2">
							<div class="card">
								<i class='bx bx-chart mx-auto ' ></i>
								<div class="card-body my-2 p-0">
									<div class="my-2"><small>Sprint Name :</small> <strong class="card-title"> ${sprint.name}</strong></div>
									<div class="my-2"><small>scrum Name :</small> <strong class="card-title"> ${sprint.scrumId.name}</strong></div>
									 
								</div>
							</div>
						</div>
						</a> 
				</c:forEach> 
					</div>
				</div>
				
			</div>
	</div>
	
	</div>
		
	
<script src="${pageContext.request.contextPath}/js/previousSprints.js"></script>

</body>
</html>