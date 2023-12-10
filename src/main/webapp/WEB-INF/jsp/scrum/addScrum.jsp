



<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/css/bootstrap.min.css"
	integrity="sha384-TX8t27EcRE3e/ihU7zmQxVncDAy5uIKz4rEkgIXeMed4M0jlfIDPvg6uqKI2xXr2"
	crossorigin="anonymous">
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/select2@4.0.13/dist/css/select2.min.css"
	integrity="sha256-FdatTf20PQr/rWg+cAKfl6j4/IY3oohFAJ7gVC3M34E="
	crossorigin="anonymous" />
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/@ttskch/select2-bootstrap4-theme/dist/select2-bootstrap4.min.css">
<!-- Import jquery cdn -->
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"
	integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj"
	crossorigin="anonymous">
	
</script>

<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/js/bootstrap.bundle.min.js"
	integrity="sha384-ho+j7jyWK8fNQe+A12Hb8AhRq26LrZ/JpcUGGOn+Y7RsweNrtN/tE3MoK7ZeZDyx"
	crossorigin="anonymous">
	
</script>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<script src="https://code.jquery.com/jquery-3.6.1.js"
	integrity="sha256-3zlB5s2uwoUzrXK3BT7AX3FyvojsraNFxCc2vC/7pNI="
	crossorigin="anonymous"></script>

<jsp:include page="../common/header.jsp"></jsp:include>
<div class="container mt-2">

	<!-- Modal -->
	<div class="modal fade" id="addScrumModel" tabindex="-1"
		aria-labelledby="exampleModalLabel" aria-hidden="true" style="z-index: 1050;">

		<div class="modal-dialog modal-lg">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="exampleModalLabel">Add Scrum Team
					</h5>

					<button type="button" class="close" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true"
							onclick="window.location.href='${pageContext.request.contextPath}/tasks?pageNo=0'">
							&times; </span>
					</button>
				</div>

				<div class="modal-body">
					<form action="${pageContext.request.contextPath}/scrums/addScrum"
						method="post" class="my-2 p-3" name="addModule">
						<input type="hidden" id="userRole" value="${sessionScope.role}">

						<div class="mb-3 row">
							<label for="title" class="col-sm-2 col-form-label ">Name<span
								class="mandatory-sign">*</span></label>
							<div class="col-sm-10">
								<input type="text" class="form-control form-control-sm"
									placeholder="Scrum Team 1" name="name" id="title"> <input
									type="hidden" name="roles" id="scrumRolesInput">
							</div>
						</div>
						<c:if test="${projectManagersProjects.size()>0}">
							<div class="mb-3 row">
								<label for="scrumMaster" class="col-sm-2 col-form-label">Project<span
									class="mandatory-sign">*</span></label>
								<div class="col-sm-10">
									<select class=" form-control form-control-sm form-select"
										aria-label="Default select example" name="project"
										id="add-scrum-project"
										onchange="getSelectedProject(`${sessionScope.role}`)">
										<option selected class="pluck-radio-option form-control-sm"
											value="0" disabled>Select Project</option>
										<c:forEach items="${projectManagersProjects}" var="project">
											<option value="${project.id }">${project.name }</option>
										</c:forEach>
									</select>
								</div>
							</div>
						</c:if>
						<c:if test="${sessionScope.role == 'Scrum Master'}">
							<input type="hidden" name="scrumMasterId" id="scrumMasterId"
								value="${sessionScope.loggedInUser.id}">
						</c:if>
						<c:if test="${sessionScope.role == 'Project Manager'}">
							<input type="hidden" name="projectManagerId"
								id="projectManagerId" value="${sessionScope.loggedInUser.id}">
						</c:if>
						<div class="mb-3 row" id="scrum-master-block">
							<div class="col-sm-2">
								<label for="scrumMaster" class="col-form-label">Scrum
									Master</label>
							</div>
							<div class="col-sm-10">
								<select class=" form-control form-control-sm form-select"
									aria-label="Default select example" name="scrumMaster"
									id="scrumMaster">
								</select>
							</div>
						</div>
						<div class="mb-3 row">
							<label for="tasks" class="col-sm-2 col-form-label">Users</label>
							<div class="col-sm-10">
								<select class="js-select2" multiple="multiple" id="users" onchange="getSelectedUser(this)">
								</select>
								
								<div class="card mt-2 d-none"  id="selectedUsersDiv">
									<div class="d-flex justify-content-between aline-items-center"></div>
								</div>
								
							</div>
						</div>

						<div class="mb-3 row">
							<div class="mx-auto text-center mt-3">
								<button type="button" class="btn btn-secondary btn-sm"
									id="user-cancel"
									onclick="window.location.href='${pageContext.request.contextPath}/tasks?pageNo=0'">Cancel</button>
								<button type="button" class="btn btn-primary Pluck-btn btn-sm"
									id="Scrum-add" disabled="disabled" onclick="sbmt()">Add</button>
							</div>
						</div>

					</form>

				</div>
			</div>
		</div>
	</div>
</div>

<script
	src="https://cdn.jsdelivr.net/gh/bbbootstrap/libraries@main/choices.min.js"></script>
<script
	src="${pageContext.request.contextPath}/js/ScrumTeamValidation.js"></script>

<script
	src="https://cdn.jsdelivr.net/npm/select2@4.0.13/dist/js/select2.min.js"
	integrity="sha256-AFAYEOkzB6iIKnTYZOdUf9FFje6lOTYdwRJKwTN5mks="
	crossorigin="anonymous"></script>
<script type="text/javascript">
	$(window).on('load', function() {
		$('#addScrumModel').modal('show');
	});
	$(document).ready(
			function() {

				$("#users").select2(
						{
							theme : 'bootstrap4',
							width : $(this).data('width') ? $(this).data(
									'width')
									: $(this).hasClass('w-100') ? '100%'
											: 'style',
							placeholder : $(this).data('placeholder'),
							allowClear : Boolean($(this).data('allow-clear')),
							closeOnSelect : !$(this).attr('multiple'),
						});

				var multipleCancelButton = new Choices(
						'.choices-multiple-remove-button', {
							removeItemButton : true,
						});
				let box = document.getElementById('scrum-master-block');
				box.style.display = "none";

			});
	var selectedUsers = [];
	var userIds = [];
	function getSelectedUser(e) {
		var dropdown = document.getElementById("users");
		selectedUsers = [];
		let selectedUserDiv = document.getElementById("selectedUsersDiv");
		if(dropdown.selectedOptions.length != 0 ){
			selectedUserDiv.innerHTML = "";
		}else{
			selectedUserDiv.innerHTML = "";
			selectedUserDiv.setAttribute("class", "d-none");
		}
			
		for (var i = 0; i < dropdown.options.length; i++) {
			selectedUserDiv.classList.remove("d-none");
			if (dropdown.options[i].selected) {
				let role = dropdown.options[i].value.split("-")[1];
				let userId = dropdown.options[i].value.split("-")[0]
				let username = dropdown.options[i].text;
								
				let newDiv = document.createElement("div");
				 newDiv.classList.add("d-flex" , "justify-content-between" , "align-item-center"); 
				let headingSix = document.createElement("h6");
				 let userRole = document.createElement("p");
				headingSix.innerHTML = username ;
				userRole.innerHTML = role ;
								
				newDiv.appendChild(headingSix);
				newDiv.appendChild(userRole); 
				
				let mainDiv = document.getElementById("selectedUsersDiv");
				mainDiv.append(newDiv);
			
				let obj = {
					'role' : role,
					'userId' : userId
				};
				selectedUsers.push(obj);
				document.getElementById('scrumRolesInput').value = JSON
						.stringify(selectedUsers);

			}
		}
	}

	function getSelectedProject(role) {
		let projectSelect = document.getElementById('add-scrum-project');
		let selectedProject = projectSelect.value;
		var dropdown = document.getElementById("users");
		dropdown.innerHTML="";
		if (role == 'Project Manager') {
			let box = document.getElementById('scrum-master-block');
			box.style.display = "flex";
			$
					.ajax({
						type : "GET",
						url : "${pageContext.request.contextPath}/scrums/scrum-masters-for-project/"
								+ selectedProject,
						async : false,
						success : function(data) {
							let select = document.getElementById('scrumMaster');
							select.innerHTML = "";
							for (let i = 0; i < data.length; i++) {
								let temp = data[i];
								let option = document.createElement('option');
								if(i == 0){
									let option1 = document.createElement('option');
									option1.setAttribute('value', 0);
									option1.innerHTML = 'Select Scrum Master'; 
									select.appendChild(option1);
								}
								option.setAttribute('value', temp.id);
								option.innerHTML = temp.firstName + " "
										+ temp.lastName;
								
								select.appendChild(option);
							}
						}
					});
		}

		$.ajax({
			type : "GET",
			url : "${pageContext.request.contextPath}/scrums/users-by-project/"
					+ selectedProject,
			async : false,
			success : function(data) {
				 for (let i = 0; i < data.length; i++) {
					let temp = data[i];
					var option = document.createElement("option");
					option.innerHTML = temp.firstName + " " + temp.lastName;
					option.value = temp.id + "-" + temp.highestRole;
					dropdown.appendChild(option)
				} 
			}
		});

	}
	function sbmt() {
		let team = document.getElementById('title');
		let scrumMasterInput = document.getElementById('scrumMasterId');
		let scrumMasterSelect = document.getElementById('scrumMaster');
		let projectManagerInput = document.getElementById('projectManagerId');
		let scrumMasterId;
		let projectManagerId;
		let projectSelect = document.getElementById('add-scrum-project');
		let selectedProject;
		if (projectSelect != null) {
			selectedProject = projectSelect.value;
		}
		if (scrumMasterInput != null) {
			scrumMasterId = scrumMasterInput.value;
		}
		if (scrumMasterSelect != null && projectManagerInput != null) {
			scrumMasterId = scrumMasterSelect.value;
		}
		if (projectManagerInput != null) {
			projectManagerId = projectManagerInput.value;
		}

		for (let i = 0; i < selectedUsers.length; i++) {
			userIds.push(selectedUsers[i].userId);
		}

		let obj = {
			name : team.value,
			users : userIds,
			roles : selectedUsers,
			projectId : selectedProject,
			scrumMasterId : scrumMasterId,
			projectManagerId : projectManagerId
		}
		$.ajax({
			url : "${pageContext.request.contextPath}/scrums/addScrum",
			type : "POST",
			contentType : "application/json;",
			data : JSON.stringify(obj),
			success : function(result) {
				if (result == "Scrum team already exists for project") {
					var dialogConfig = {
						title : 'Scrum Team',
						body : result,
						buttons : {
							ok : {
								label : 'OK',
								action : function() {
									window.location.href = "${pageContext.request.contextPath}/scrums"

								}
							}
						}
					};
					let dialog = xdialog.create(dialogConfig);
					dialog.show();
				}
				else if(result == "Scrum team added successfully"){
					
					 toastr.success("Scrum team added successfully");
						 setTimeout(function() {
							    window.location.href = "${pageContext.request.contextPath}/scrums";
							}, 1000); // 1000 milliseconds = 1 seconds
				}
				else {
					let a = document.createElement('a');
					a.href = "${pageContext.request.contextPath}/scrums";
					a.click();
				}
			},
			error : function(err) {
				let a = document.createElement('a');
				a.href = "${pageContext.request.contextPath}/scrums";
				a.click();
			}
		});

	}
</script>
