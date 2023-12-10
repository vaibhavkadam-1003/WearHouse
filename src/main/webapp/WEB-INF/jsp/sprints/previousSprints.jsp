<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<link href="${pageContext.request.contextPath}/css/task.css" rel="stylesheet">
</head>
<body>
	<jsp:include page="../common/header.jsp"></jsp:include>


	<div class="main-content ">
		<div class="col-md-12">
			<div class="row">
				<div class="col-md-12 title d-flex justify-content-between align-item-center">
					<h4>Previous Sprints </h4>
						<div class="scrum-search">
							<input type="text" id="myFilter"
								class="form-control " onkeyup="sprintFilter()"
								placeholder="Search For Sprint Name.."> <i
								class="fa fa-search" aria-hidden="true"></i>
						</div>
					
				</div>

				<div
					class="d-flex justify-content-start d-flex align-items-start flex-wrap">
				<c:forEach items="${previousSprints}" var="sprint">
					<a
						href="${pageContext.request.contextPath}/sprints/sprint-history/${sprint.id}">
						<div class="scrum-user-card card shadow-sm m-2 ">
						 <div class="card-body">
						 	<i class="fa fa-list" aria-hidden="true"></i>
						  <h5 class="card-title text-dark" style="color: #5c5cc7 !important">${sprint.name}<br/>${sprint.scrumId.name}</h5> 
						  </div> 
						  </div>
					</a>
					</c:forEach>
				</div>
			</div>
		</div>
	</div>
<script src="${pageContext.request.contextPath}/js/previousSprints.js"></script>

</body>
</html>