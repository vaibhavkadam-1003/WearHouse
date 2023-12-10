<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@page import="javax.validation.constraints.Size"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<script src="https://code.jquery.com/jquery-3.6.1.js"
	integrity="sha256-3zlB5s2uwoUzrXK3BT7AX3FyvojsraNFxCc2vC/7pNI="
	crossorigin="anonymous"></script>
<%-- <link href="${pageContext.request.contextPath}/css/project.css" rel="stylesheet"> --%>
<script src="${pageContext.request.contextPath}/js/updateProject.js"></script>
<script src="${pageContext.request.contextPath}/js/common.js"></script>
<script src="${pageContext.request.contextPath}/js/validation.js"></script>
<html>
<head>
<style >
.active-cyan-3 input[type=text] {
  border: 1px solid #4dd0e1;
  box-shadow: 0 0 0 1px #4dd0e1;
}

.capitalize-first-letter::first-letter {
  text-transform: uppercase;
}
</style>
</head>
<body>
<jsp:include page="../common/header.jsp"></jsp:include>
<div class="main-content">

	<div class="container-fluid"> 
		<div class="">
			<div class="card">
			<div class="row">
					<div class="col-md-7  ">
						<div class="card-body ">
							<small>Update Project</small>
							<form name="myform"
						action="${pageContext.request.contextPath}/projects/updateProject"
						method="post" class="" onsubmit="return updateProjectValidation()">
						<div>
							<div class="row">
								<div class="col">
									<div class="mb-3 mt-3" style="display: none;">
										<label class="col-form-label" for="email">Id:</label> <span
											class="mandatory-sign">*</span> <input type="text"
											class="form-control form-control-sm" id="id"
											placeholder="Enter name" name="id" value="${project.id}">
									</div>
									<div class="mb-3 mt-3">
										<label class="col-form-label" for="name">Name</label> <span
											class="mandatory-sign">*</span>  <div class="capitalize-first-letter" > <input type="text"
											class="form-control choices__inner" 
											placeholder="Enter name" name="name"  value="${project.name}" 
											onblur="this.value=validateCompanyName(this,'name','company-validation-id');"
											required
											<c:if test="${project.status == 'Inactive'}"><c:out value="readonly='readonly'" /></c:if>></div> <span id="company-validation-id"
											class="validation-span-c"></span>

									</div>
									<div class="mb-3 mt-3">
										<label class="col-form-label" for="startDate">Start
											Date</label> <span class="mandatory-sign">*</span> <input type="date" onkeydown="return false"
											class="form-control choices__inner" id="startDate"
											min="2023-01-01" style="color:#212529!important;     font-weight: 400 !important;"
											max="${project.lastDate}" 
											placeholder="Enter startDate" name="startDate"
											value="${project.startDate}" required
											<c:if test="${project.status == 'Inactive'}"><c:out value="readonly='readonly'" /></c:if>>
									</div>
									<div class="mb-3 mt-3">
										<label class="col-form-label" for="lastDate">Last Date</label>
										<input type="date" class="form-control choices__inner"
											id="lastDate" min="${project.startDate}" max="2026-01-01"
											placeholder="Enter lastDate" name="lastDate" onkeydown="return false"
											value="${project.lastDate}" style="color:#212529!important;     font-weight: 400 !important;"
											<c:if test="${project.status == 'Inactive'}"><c:out value="readonly='readonly'" /></c:if>>
											<span id="end_date_validation" class="validation-span-c error-message-text-color"></span>
									</div>	
									<div class="mb-3 ">
										<label class="col-form-label" for="status"
											class="form-control choices__inner">Status</label> <span
											class="mandatory-sign">*</span> <select class="form-select"
											aria-label="Default select example" name="status" id="status">
											<option selected>${project.status}</option>
											<c:choose>
												<c:when test="${project.status=='Active'}">
													<option value="2">Inactive</option>
												</c:when>
												<c:otherwise>
													<option value="1">Active</option>
												</c:otherwise>
											</c:choose>
										</select>
									</div>
									
									<div class="mb-3 mt-3">
										<label class="col-form-label" for="description">Description</label><textarea
											class="form-control form-control-sm" rows="6"
											id="description" placeholder="Enter description" onkeyup="updateButtonToggle()"
											name="description" 
											<c:if test="${project.status == 'Inactive'}"><c:out value="readonly='readonly'" /></c:if>>${project.description}</textarea>
											<span class="error-message-text-color" id="description_error_msg"></span>
									</div>
									
								</div>
							</div>
							<div class="row">
								<div class="col text-center my-2">
									<button id="project-cancel" type="reset"
										class="btn btn-secondary btn-sm mt-3"
										onclick="window.location.href='${pageContext.request.contextPath}/projects/allproject?pageNo=0'">Cancel</button>
									<button id="project-update" type="submit" color="primary"
										class="btn btn-primary Pluck-btn btn-sm mt-3"
										disabled="disabled">Update</button>
								</div>
							</div>
						</div>
					</form>
						</div> 
					</div>
					<div class="col-md-5 bg-light border">
							<div class="card-body updateProjectHeight">
								<div class=" ">
									<form name="myform"
										action="${pageContext.request.contextPath}/projects/removeOwner"
										method="post">
										<span style="color: red"><b>${ownerMsg}</b></span>
										<div class=" ">
											<div class="col">
												<div class="" style="display: none;">
													<label class="col-form-label" for="email">Id:</label> <span
														class="mandatory-sign">*</span> <input type="text"
														class="form-control form-control-sm" id="projectId"
														placeholder="Enter name" name="id" value="${project.id}">
												</div>
												<div class="">

													<div
														class="d-flex justify-content-between align-items-center">
														<small>Project Administrators</small>
														<div>
															<c:choose>
																<c:when test="${fn:length(ownersList) ge 1}">
																	<button type="button"
																		class="btn btn-success btn-sm mx-1 my-2"
																		data-bs-toggle="modal" data-bs-target="#Owner"
																		<c:if test="${project.status == 'Inactive'}"><c:out value="disabled='disabled'" /></c:if>>
																		<iconify-icon icon="bx:plus-circle"></iconify-icon>
																	</button>
																</c:when>
																<c:otherwise>
																	<button type="button"
																		class="btn btn-success btn-sm mx-1 my-2"
																		disabled="disabled" data-bs-toggle="modal"
																		data-bs-target="#Owner"
																		<c:if test="${project.status == 'Inactive'}"><c:out value="disabled='disabled'" /></c:if>>
																		<iconify-icon icon="bx:plus-circle"></iconify-icon>
																	</button>
																</c:otherwise>
															</c:choose>
															<Button
																class="btn btn-danger btn-sm mx-1 removeOwner my-2"
																disabled="disabled">
																<iconify-icon icon="bx:trash"></iconify-icon>
															</Button>
														</div>
													</div>

													<div>

														<c:forEach items="${project.owners}" var="list">
															<div class="project-administrators">
																<div
																	class="d-flex justify-content-start align-items-center">
																	<i class='bx bxs-user'></i>
																	<div>
																		<h6>${list.firstName} ${list.lastName}</h6>
																		<small>${list.username}</small>
																	</div>
																</div>
																<div>
																	<c:if test="${fn:length(project.owners) gt 1}">
																		<input class="form-check-input checkOwner"
																			name="users" type="checkbox" value="${list.id}"
																			identifier="owner-identifier"
																			<c:if test="${project.status == 'Inactive'}"><c:out value="disabled='disabled'" /></c:if>>
																	</c:if>
																</div>
															</div>
														</c:forEach>
													</div>


												</div>
											</div>
										</div>
									</form>

								</div>

								
								<div class="my-5"></div>


								<div class="">

									<form name="myform"
										action="${pageContext.request.contextPath}/projects/removeUser"
										method="post" class="container m-0 p-0">
										<span style="color: red"><b>${userMsg}</b></span>
										<div class="">
											<div class="col">
												<div style="display: none;">
													<label class="col-form-label" for="email">Id:</label> <span
														class="mandatory-sign">*</span> <input type="text"
														class="form-control form-control-sm" id="projectId"
														placeholder="Enter name" name="id" value="${project.id}">
												</div>
												<div class="">

													<div
														class="d-flex justify-content-between align-items-center">
														<small>Project User</small>
														<div>
															<c:choose>
																<c:when test="${fn:length(usersList) ge 1}">
																	<button type="button"
																		class="btn btn-success btn-sm mx-1 my-2"
																		data-bs-toggle="modal" data-bs-target="#exampleModal"
																		<c:if test="${project.status == 'Inactive'}"><c:out value="disabled='disabled'" /></c:if>>
																		<iconify-icon icon="bx:plus-circle"></iconify-icon>
																	</button>
																</c:when>
																<c:otherwise>
																	<button type="button"
																		class="btn btn-success btn-sm mx-1 my-2"
																		disabled="disabled" data-bs-toggle="modal"
																		data-bs-target="#exampleModal"
																		<c:if test="${project.status == 'Inactive'}"><c:out value="disabled='disabled'" /></c:if>>
																		<iconify-icon icon="bx:plus-circle"></iconify-icon>
																	</button>
																</c:otherwise>
															</c:choose>
															<Button class="btn btn-danger btn-sm remove mx-1 my-2"
																disabled="disabled">
																<iconify-icon icon="bx:trash"></iconify-icon>
															</Button>
														</div>


													</div>

													<div>
														<c:forEach items="${project.users}" var="list">
															<div class="project-administrators">
																<div
																	class="d-flex justify-content-start align-items-center">
																	<i class="bx bxs-user"></i>
																	<div>
																		<h6>${list.firstName} ${list.lastName}</h6>
																		<small>${list.username}</small>
																	</div>
																</div>
																<div>
																	<c:if test="${fn:length(project.users) gt 1}">
																		<input class="form-check-input checkbox" name="users"
																			type="checkbox" value="${list.id}"
																			identifier="user-identifier"
																			<c:if test="${project.status == 'Inactive'}"><c:out value="disabled='disabled'" /></c:if>>
																	</c:if>
																</div>
															</div>
														</c:forEach>
													</div> 
												</div>
											</div>
										</div>
									</form>
								</div> 
							</div>
						</div>
				</div>
				
			</div>
		</div>

	</div>
	

	<div class="col-md-12">
		
		
		
		<!-- Modal -->
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
						<form action="${pageContext.request.contextPath}/projects/addUser"
							method="post">
							<div class="mb-3 mt-3" style="display: none;">
								<label class="col-form-label" for="email">Id:</label> <span
									class="mandatory-sign">*</span> <input type="text"
									class="form-control form-control-sm" id="projectId"
									placeholder="Enter name" name="id" value="${project.id}">
							</div>
							<div class="border-top form-control" id="user-user">
								
								<div class="active-cyan-4 mb-2">
								<input class="form-control" type="text" id="myUsers"
									onkeyup="myFunction()" placeholder="Search" aria-label="Search">
								<div id="noUsersFoundMessage" style="display: none;">User not found</div>
							</div>
							
								<ul class="list-group list-group-flush" id="myUL">
									<c:choose>
										<c:when test="${fn:length(usersList) eq 0}">
											<li class="list-group-item d-flex justify-content-between ">
													<p>No Data Available</p>
												</li>
										</c:when>
										<c:otherwise>
											<c:forEach items="${usersList}" var="list">
												<c:forEach items="${project.users}" var="users">
													<c:if test="${users.id eq list.id}">
														<c:set var="userAlreadyInList" value="true"/>
													</c:if>
												</c:forEach>
												<div class="user-list"> 												 
												<c:if test="${not userAlreadyInList}">												
														<li class="list-group-item d-flex justify-content-between ">
														<div class="text-capitalize">	<b class="btag"> ${list.firstName}&nbsp;${list.lastName}&nbsp;<button type="button" id =" btn" class="btn btn-secondary btn-sm" style="padding:0px;font-size:0.55rem; margin-left:0px;">${list.username}</button></b> <input
															class="addUser" name="users"
															type="checkbox" value="${list.id}"> 
															</div>
														</li>														
												</c:if>												
												</div>												 
												<c:set var="userAlreadyInList" value="false"/>
											</c:forEach>
										</c:otherwise>
									</c:choose>
								</ul>


							</div>
							<div class="modal-footer">
								<button type="button" class="btn btn-secondary btn-sm"
									data-bs-dismiss="modal">Close</button>
								<button type="submit" class="btn btn-success btn-sm" id="addUserBtn" disabled="disabled">Add</button>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>

		<!-- Modal -->
		<div class="modal fade" id="Owner" tabindex="-1"
			aria-labelledby="exampleModalLabell" aria-hidden="true">
			<div class="modal-dialog">
				<div class="modal-content">
						<div class="modal-header">
						<h5 class="modal-title" id="exampleModalLabel">Add Administrators</h5>
							
							<button type="button" class="btn-close" data-bs-dismiss="modal"
							aria-label="Close"></button>
					</div>
					<div class="modal-body">
						<form
							action="${pageContext.request.contextPath}/projects/addOwner"
							method="post">
							<div class="mb-3 mt-3" style="display: none;">
								<label class="col-form-label" for="email">Id:</label> <span
									class="mandatory-sign">*</span> <input type="text"
									class="form-control" id="projectId" placeholder="Enter name"
									name="id" value="${project.id}">
							</div>
							<div class="border-top form-control" >
							<div class="active-cyan-4 mb-2">
								<input class="form-control" type="text" id="myInput"
									onkeyup="myFunction()" placeholder="Search" aria-label="Search">
								<div id="noUsersFoundMessages" style="display: none;">Administrators not found</div>
							</div>
							    <ul class="list-group list-group-flush" id="myUL">
							        <c:choose>
							           <c:when test="${fn:length(ownersList) eq 0}">
							                <li class="list-group-item d-flex justify-content-between">
							                    <p>No Data Available</p>
							                </li>
							            </c:when>
							            <c:otherwise>
							                <c:forEach items="${ownersList}" var="list">
							                    <c:forEach items="${project.owners}" var="owner">
							                        <c:if test="${owner.id eq list.id}">
							                            <c:set var="ownerAlreadyInList" value="true"/>
							                        </c:if>
							                    </c:forEach>
							                    <div class="user-info"> 
							                    <c:if test="${not ownerAlreadyInList}">						                    
							                        <li class="list-group-item d-flex justify-content-between"  >
							                        <div class="text-capitalize">    <b class="b">${list.firstName} ${list.lastName}  
							                            <button type="button" id =" btn" class="btn btn-secondary btn-sm" style="padding:0px;font-size:0.55rem; margin-left:0px;">${list.username}</button></b>
							                            <input class="form-check-input addOwner" name="users" type="checkbox" value="${list.id}"> </div>
							                        </li>							                 
							                    </c:if>
							                    </div>
							                    <c:set var="ownerAlreadyInList" value="false"/>
							                </c:forEach>
							            </c:otherwise>
							        </c:choose>
							    </ul>
							</div>

							
							<div class="modal-footer">
								<button type="button" class="btn btn-secondary btn-sm"
									data-bs-dismiss="modal">Close</button>
								<button type="submit" class="btn btn-success btn-sm" onclick="addClick()" id="addOwnerBtn"  disabled="disabled">Add</button>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>

	</div>
</div>

<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"
	integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM"
	crossorigin="anonymous"></script>
<script
	src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"
	integrity="sha384-oBqDVmMz9ATKxIep9tiCxS/Z9fNfEXiDAYTujMAeBAsjFuCZSmKbSSUnQlmh/jp3"
	crossorigin="anonymous"></script>
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.min.js"
	integrity="sha384-cuYeSxntonz0PPNlHhBs68uyIAVpIIOZZ5JqeqvYYIcEL727kskC66kF92t6Xl2V"
	crossorigin="anonymous"></script>
<script
	src="https://code.iconify.design/iconify-icon/1.0.2/iconify-icon.min.js"></script>

</body>
</html>