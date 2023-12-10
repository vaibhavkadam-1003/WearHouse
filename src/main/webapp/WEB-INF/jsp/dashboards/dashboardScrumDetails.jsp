<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
</head>
<body>
	<jsp:include page="../common/header.jsp"></jsp:include>
	<script src="${pageContext.request.contextPath}/js/scrumDetails.js"></script>

	<%
	if ( session.getAttribute( "username" ) == null ) {
		response.sendRedirect( "/login" );
	}
	%>

	<div class="main-content ">
		<div class="col-md-12">
			<div class="row">
				<div class="col-md-12 title" id="titleDiv">
					<h4>${team.name } Details <i class='bx bxs-edit ms-3 text-primary' id="editTeam" 
					data-bs-toggle="tooltip" data-bs-placement="top"  title="Update team name"></i></h4>
				</div>
				<div class="input-group d-none" id="editTeam1">
				  <input type="text" class="form-control" value="${team.name }" id="teamName">
				  <button class="btn btn-success" type="button" id="submitBtn" onclick="updateTeam(${team.id })">Submit</button>
				  <button class="btn btn-secondary"  id="cancelEdit" type="button">Cancel</button>
				</div>
				
				<c:forEach items="${team.users}" var="user">

					<div class="col-md-3 ">
						<a
							href="${pageContext.request.contextPath}/dashboard/user/${user.id}"
							class=" scrum-list">
							<div class="priority-status"
								style="background-color: #edf2fb; border: 1px solid #d4e6ff;">
								<h5>
									<i class="fa fa-user me-2" aria-hidden="true"
										style="color: #6ba8ff;"></i> ${user.firstName } ${user.lastName }
									<c:choose>
										<c:when test="${user.sharedResource == true }"> 
											<img src="${pageContext.request.contextPath}/images/share-resource.png" 
											class="fa fa-share-alt-square"  data-bs-toggle="tooltip" data-bs-placement="top"  
											title="User shared in multiple projects" width="27px" height="22px" aria-hidden="true"/>
										</c:when>
									</c:choose>
								</h5>
								<small>${user.role.get(0) }</small> 
								<c:if test="${sessionScope.role.equals('Scrum Master') || sessionScope.role.equals('Project Manager') }">
									<a
										href="${pageContext.request.contextPath}/scrums/delete/${team.id}/${user.id}/${projectId}"><i
										class="fa fa-trash remove" aria-hidden="true"></i> </a>
								</c:if>
							</div>
						</a>
					</div>
				</c:forEach>
				<c:if test="${sessionScope.role.equals('Scrum Master') || sessionScope.role.equals('Project Manager') }">
				<div class="col-md-3">
					<div class="priority-status text-center"
						style="background-color: #eef5ff; border: 1px solid #cfe2ff;"
						data-bs-toggle="modal" data-bs-target="#exampleModal">
						<i class="fa fa-plus mb-2" aria-hidden="true"
							style="color: #6ea8fe;"></i> <br> <small>Add Users</small>
					</div>
				</div>
				</c:if>
				<c:if test="${userDetails != null}">
					<div class="row mt-3">
						<div class="col-md-12 p-2 border" style="background-color: #eee;">
							<div class="">
								<h6 class="my-0">${userDetails.firstName }
									${userDetails.lastName }</h6>
								<small style="font-size: 12px; color: #8e8e8e;">All Task</small>
							</div>
							<c:choose>
								<c:when test="${taskList.size() == 0}">
									<div style="height: 17vh" class="scrume-add-msg">
										<i class="fa fa-tasks" aria-hidden="true"></i>
										<h3>No Tasks are available for this User</h3>
									</div>
								</c:when>
								<c:otherwise>
									<div class="list-group">
										<c:forEach items="${taskList}" var="task">
											<div
												class="list-group-item list-group-item-action scrum-task-list px-2 py-0 m-0">

												<div class="row">
													<div class="col-md-10">
														<span class=" sprintBox-title "> ${task.title}</span>
													</div>
													<div class="col-md-2 text-end">
														<span class="badge priority">${task.story_point}</span> <span
															class="badge priority">${task.status}</span>
													</div>
												</div>

											</div>
										</c:forEach>

									</div>
								</c:otherwise>
							</c:choose>
						</div>
					</div>
				</c:if>
			</div>
		</div>
	</div>

	<div class="modal fade" id="exampleModal" tabindex="-1"
		aria-labelledby="exampleModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="exampleModalLabel">Add Users</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal"
						aria-label="Close"></button>
				</div>
				<div class="modal-body">
					<%-- <form
						action="${pageContext.request.contextPath}/scrums/addUser/${team.id}"
						method="post"> --%>
						<div class="mb-3 mt-3" style="display: none;">
							<label class="col-form-label" for="email">Id:</label> <span
								class="mandatory-sign">*</span> <input type="text"
								class="form-control form-control-sm" id="projectId"
								placeholder="Enter name" name="id" value="">
						</div>
						<div class="border-top form-control">
							<ul class="list-group list-group-flush">
								<c:choose>
									<c:when test="">
										<li class="list-group-item d-flex justify-content-between ">
											<p>No Data Available</p>
										</li>
									</c:when>
									<c:otherwise>
										<c:forEach items="${userListByProject}" var="list">
											<c:forEach items="${team.users}" var="teamUser">
												<c:if test="${teamUser.id eq list.id}">
													<c:set var="userAlreadyInList" value="true" />
												</c:if>
											</c:forEach>
											<c:if test="${not userAlreadyInList}">
											<div class="user-info">
												<li class="list-group-item d-flex justify-content-between ">
													<b class="user-name"> ${list.firstName}&nbsp;${list.lastName}
													<span class="btn btn-secondary btn-sm" style="padding:0px; font-size:0.55rem; 
														margin-left:0px;">${list.username}</span></b>
														<div>
															<c:choose>
						  										<c:when test="${list.sharedResource == true }">
						  											<img src="${pageContext.request.contextPath}/images/share-resource.png" 
																	class="fa fa-share-alt-square"  data-bs-toggle="tooltip" data-bs-placement="top"  
																	title="User shared in multiple projects" width="27px" height="22px" aria-hidden="true"/>
						  										</c:when>
						  									</c:choose>
															
															<input class="addUser" id="userId" 
																name="users" type="checkbox"  onclick="addNewUser(this)" value="${list.id}-${list.role}">
															<input type="hidden" name="roles" id="scrumRolesInput">  
														</div>
												</li>
											</div>
											</c:if>
											<c:set var="userAlreadyInList" value="false" />
										</c:forEach>
									</c:otherwise>
								</c:choose>
							</ul>


						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-secondary btn-sm"
								data-bs-dismiss="modal">Close</button>
							<button type="submit" class="btn btn-success btn-sm"
								id="addUserBtn" disabled="disabled" onclick="submitClick(${team.id},${projectId}, '${pageContext.request.contextPath}')" data-bs-dismiss="modal">Add</button>
						</div>
					<!-- </form> -->
				</div>
			</div>
		</div>
	</div>

	<div class="modal fade" id="exampleModal" tabindex="-1"
		aria-labelledby="exampleModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="exampleModalLabel">Add Users</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal"
						aria-label="Close"></button>
				</div>
				<div class="modal-body">
					<form
						action="${pageContext.request.contextPath}/scrums/addUser/${team.id}/${projectId}"
						method="post">
						<div class="mb-3 mt-3" style="display: none;">
							<label class="col-form-label" for="email">Id:</label> <span
								class="mandatory-sign">*</span> <input type="text"
								class="form-control form-control-sm" id="projectId"
								placeholder="Enter name" name="id" value="">
						</div>
						<div class="border-top form-control">
							<ul class="list-group list-group-flush">
								<c:choose>
									<c:when test="">
										<li class="list-group-item d-flex justify-content-between ">
											<p>No Data Available</p>
										</li>
									</c:when>
									<c:otherwise>
										<c:forEach items="${userListByProject}" var="list">
											<c:forEach items="${team.users}" var="teamUser">
												<c:if test="${teamUser.id eq list.id}">
													<c:set var="userAlreadyInList" value="true" />
												</c:if>
											</c:forEach>
											<c:if test="${not userAlreadyInList}">
												<li class="list-group-item d-flex justify-content-between ">
													<b> ${list.firstName}&nbsp;${list.lastName}</b> <input
													class="addUser" name="users" type="checkbox"
													value="${list.id}">
												</li>
											</c:if>
											<c:set var="userAlreadyInList" value="false" />
										</c:forEach>
									</c:otherwise>
								</c:choose>
							</ul>


						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-secondary btn-sm"
								data-bs-dismiss="modal">Close</button>
							<button type="submit" class="btn btn-success btn-sm"
								id="addUserBtn" disabled="disabled" data-bs-dismiss="modal">Add</button>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
</body>
</html>

