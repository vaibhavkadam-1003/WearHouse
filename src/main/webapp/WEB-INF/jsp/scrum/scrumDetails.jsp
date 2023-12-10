<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
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
	
		<div class="card" style="height:90vh;">
			<div class="card-body">
				<div>
					<div class="col-md-12 title" id="titleDiv">
					<h4>${team.name } Details <i class='bx bxs-edit ms-3 text-primary' id="editTeam" 
					data-bs-toggle="tooltip" data-bs-placement="top"  title="Update team name"></i></h4>
				</div>
				<div class="input-group d-none" id="editTeam1">
				  <input type="text" class="form-control" value="${team.name }" id="teamName">
				  <button class="btn btn-success" type="button" id="submitBtn" onclick="updateTeam(${team.id })">Submit</button>
				  <button class="btn btn-secondary"  id="cancelEdit" type="button">Cancel</button>
				</div>
				
					
				</div>

				<div class='my-4'>
					<div class="row row-cols-1 row-cols-md-5 g-4 ">
					<c:forEach items="${team.users}" var="user">

						
							  
								<div class="col ">
								<a
								href="${pageContext.request.contextPath}/dashboard/user/${user.id}"
								class=" scrum-list">
									<div class="card scrum-user-card">
										 <i class='bx bxs-user mx-auto'></i>
											<div class="card-body">
												<h5 class="card-title text-dark">${user.firstName }
													${user.lastName }</h5>
												<p class="card-text">${user.role.get(0) }</p>

											</div>
										</a>
										<div class="multi-scrume-team">
											<a
												href="${pageContext.request.contextPath}/scrums/delete/${team.id}/${user.id}">
												<span class="bx bx-trash remove text-danger mx-2"
												aria-hidden="true"></span>  
											</a>
											<c:choose>
												<c:when test="${user.sharedResource == true }">
													<span class="bx bx-command " data-bs-toggle="tooltip" 
														data-bs-placement="top" title="User shared in multiple projects">
													</span>
												</c:when>
											</c:choose>
										</div>
									</div> 
								</div>
							 
						
					</c:forEach>
					
					<c:if test="${sessionScope.role.equals('Scrum Master') || sessionScope.role.equals('Project Manager') }">
					<c:choose>
					  <c:when test="${userCount == adddedUserCount }">
					  <div class="col ">
					  	<div class="card scrum-user-card" style="display: none;">
						<div class="card-body text-center" 
							data-bs-toggle="modal" data-bs-target="#exampleModal">
							<i class="bx bx-plus text-dark mb-2" aria-hidden="true"
								style="color: #6ea8fe;"></i> <br/>
									<h5 class="card-title text-dark pb-3"> Add User</h5>
								    
						</div>
					</div>
					</div>
					  </c:when>
					  <c:otherwise>
					  <div class="col ">
					  	<div class="card scrum-user-card">
						<div class="card-body text-center" 
							data-bs-toggle="modal" data-bs-target="#exampleModal">
							<i class="bx bx-plus text-dark mb-2" aria-hidden="true" 
								style="color: #6ea8fe;"></i>   <h5 class="card-title text-dark pb-3">Add User </h5>      
						</div>
					</div>
					</div>
					  </c:otherwise>
					</c:choose>
					
				</c:if>
					</div>
				
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
				<div class="input-group ms-3 mt-2">
				  <div class="form-outline All-search-user"> 
				    <input type="input" id="searchInput"  placeholder="Search User" class="form-control" />
				    <i class='bx bx-search' ></i>
				  </div>
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
						<div class=" ">
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
											<div class="user-info" id="tableID">



												<li class="list-group-item d-flex justify-content-between align-items-center">

													<div
														class=" d-flex justify-content-start align-items-center">
														<div class=" ">
															<span class="avatar-title">N</span>
														</div>
														<div>

															<h5 class="user-name text-capitalize m-0 p-0">
																${list.firstName}&nbsp;${list.lastName}</h5>
															<p class=" mb-0">${list.username}</p>
														</div> 
													</div> 
													
													<div>
															<c:choose>
																<c:when test="${list.sharedResource == true }">
																<span class="bx bx-command " data-bs-toggle="tooltip" 
																	data-bs-placement="top" title="User shared in multiple projects">
																</span>
																</c:when>
															</c:choose>

															<input class="addUser" id="userId" name="users"
																type="checkbox" onclick="addNewUser(this)"
																value="${list.id}-${list.role}"> <input
																type="hidden" name="roles" id="scrumRolesInput">
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
								id="addUserBtn" disabled="disabled" onclick="sbmt(${team.id}, '${pageContext.request.contextPath}')" data-bs-dismiss="modal">Add</button>
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
						action="${pageContext.request.contextPath}/scrums/addUser/${team.id}"
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

