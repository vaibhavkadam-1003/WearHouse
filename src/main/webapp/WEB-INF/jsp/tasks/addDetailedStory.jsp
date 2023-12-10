<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%-- <link href="${pageContext.request.contextPath}/css/style.css"
	rel="stylesheet"> --%>

<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/gh/bbbootstrap/libraries@main/choices.min.css">
<script
	src="https://cdn.jsdelivr.net/gh/bbbootstrap/libraries@main/choices.min.js"></script>

<script src="https://code.jquery.com/jquery-3.6.1.js"
	integrity="sha256-3zlB5s2uwoUzrXK3BT7AX3FyvojsraNFxCc2vC/7pNI="
	crossorigin="anonymous"></script>

<script src="${pageContext.request.contextPath}/js/common.js"></script>
<script src="${pageContext.request.contextPath}/js/validation.js"></script>
<script src="${pageContext.request.contextPath}/js/addDetailedStory.js"></script>

<jsp:include page="../common/header.jsp"></jsp:include>

<%
if (session.getAttribute("username") == null) {
	response.sendRedirect("/login");
}
%>

<div class="main-content " >
	<div class="container d-flex justify-content-center pt-4">
		<div class="col-12 col-offset-2">
			<div class="col-md-6 mx-auto">
				<div class=" mt-3"
					style="height: 3px; background-color: #dddddd; border: 1px solid #E8E8E8; margin: 20px 0px;">
					<div class="progress-bar  progress-bar-animated "
						style="font-weight: bold; font-size: 15px; height: 3px;"
						role="progressbar" aria-valuemin="0" aria-valuemax="100"></div>
					<nav style="height: 50px;">
						<div class="d-flex justify-content-between w-100 px-5" id="wizard"
							role="tablist" style="margin-top: -23px;">
							<a class="stepCode step-1"> 1</a> <a class="stepCode step-2"
								style="padding: 9px 14px;">2</a>
						</div>
					</nav>
				</div>
			</div>
			<form action="${pageContext.request.contextPath}/stories/detailed"
				method="post" class="my-2 p-3" name="regForm" id="regForm"
				onsubmit="return addQuickStoryValidation()">
				<div class="card mt-3 shadow-sm border" style="min-height: 67vh;">
					<div class="card-body p-4 mx-4 step">
						<div class="row">
							<div class="col-md-12 title">
								<h4>Add Detailed Story</h4>
							</div>
						</div>
						<div class="row mt-3">
							<div class="col-12">
								<div class="mb-3 ">
									<label for="title" class="form-label">Title</label><span
										class="mandatory-sign">*</span> <input type="text"
										class="form-control form-control-sm"
										placeholder="Enter Title" name="task.title"
										id="title"
										onblur="this.value=titleValidate(this,'title-validation-id');">
									<span id="title-validation-id"
										class="validation-span-c error-message-text-color"></span>
								</div>
							</div>
						</div>

						<div class="row my-2">
							<div class="col-3">
								<div class="mb-3 ">
									<label for="priority" class="form-label">Priority</label> <select
										class=" form-control form-control-sm form-select"
										name="task.priority" id="priority">
										<option selected class="pluck-radio-option form-control-sm"
											value="0">Select Priority</option>
										<c:forEach items="${priorities}" var="priority">
											<c:choose>
												<c:when test="${priority.priority == 'Medium'}">
													<option value="${priority.priority}" selected>${priority.priority}</option>
												</c:when>
												<c:otherwise>
													<option value="${priority.priority}">${priority.priority}</option>
												</c:otherwise>
											</c:choose>
										</c:forEach>
									</select>
								</div>
							</div>

							<div class="col-3">
								<label for="assignedTo" class="form-label">Assigned To
								</label> <select class=" form-control form-control-sm form-select"
									aria-label="Default select example" name="task.assignedTo"
									id="assignedTo">

									<option selected class="pluck-radio-option form-control-sm"
										value="" selected>Unassigned</option>
									<optgroup label="Scrum Team Members">
										<c:forEach items="${scrumUsers}" var="list">
											<option class="pluck-radio-option form-control-sm text-capitalize"
												value="${list.id}">${list.firstName}&nbsp;${list.lastName}</option>
										</c:forEach>
									</optgroup>
									<optgroup label="Other Users">
										<c:forEach items="${otherUsers}" var="list">
											<option class="pluck-radio-option form-control-sm text-capitalize"
												value="${list.id}">${list.firstName}&nbsp;${list.lastName}</option>
										</c:forEach>
									</optgroup>

								</select>
							</div>

							<div class="col-3">
								<div class="mb-3" style="position: relative;">
									<label id="lable-assignedTo" for="assignedTo"
										class="form-label ">Story Points</label> <select
										name="task.story_point" id="StoryPoint"
										class=" form-control form-control-sm form-select" onblur="hideStoryPointTable()"
										onclick="showStoryTable()">
										<option selected value=""
											class="pluck-radio-option form-control-sm">Select
											Story Points</option>
										<c:forEach items="${storyPoint}" var="storyPoint">
											<option class="pluck-radio-option form-control-sm"
												value="${storyPoint.storyPoint}">${storyPoint.storyPoint}</option>
										</c:forEach>
									</select>

									<div class="col-3">
										<div class="mb-3 rounded"
											style="display: none; position: absolute; top: -30px; left: -230px; width: 240px"
											id="story-point-table">
											<div class="popover fade show bs-popover-start  shadow"
												role="tooltip">
												<div class="popover-arrow"
													style="position: absolute; top: 0px; transform: translate(0px, 47px);"></div>
												<div class="popover-body story-point-table">
													<c:forEach items="${storyPoint}" var="point">
														<div
															class="d-flex justify-content-start align-items-center">
															<p>
																<small class="me-1"> Story point</small> <b>${ point.storyPoint}</b>
																<small class="mx-1">has Range</small> <b>${ point.range}</b>
															</p>
														</div>
													</c:forEach>

												</div>
											</div>
										</div>
									</div>
								</div>
							</div>

							<div class="col-3">
								<label for="assignedTo" class="form-label">Type </label> <select
									class=" form-control form-control-sm form-select"
									aria-label="Default select example" name="agile.storyType"
									id="storytype">


									<option selected class="pluck-radio-option form-control-sm"
										value="functional">Functional</option>

									<option class="pluck-radio-option form-control-sm"
										value="nonFunctional">Non-Functional</option>


								</select> <span id="assignedTo-validation-id"
									class="validation-span-c error-message-text-color"></span>
							</div>
						</div>

						<div class="row">
							<div class="col-12 mt-2">
								<div class="mb-3">
									<label class="form-label" for="description">Description</label>
									<textarea id="description" name="task.description" rows="8"
										cols="100" class=" form-control" placeholder="Enter Description"></textarea>
									<span id="description-validation-id"
										class="validation-span-c error-message-text-color"></span>
								</div>
							</div>
						</div>
					</div>

					<div id="userinfo" class="card-body px-5 py-5 step "
						style="display: none">
						<div class="row">
							<div class="col-6">
								<div class="row">
									<div class="col-md-12">
										<div class="mb-4 ">
											<label for="modules" class="form-label">Modules</label> <select
												class=" form-control form-control-sm form-select"
												aria-label="Default select example" name="agile.module"
												id="modules">

												<option selected class="pluck-radio-option form-control-sm"
													value="0">Select Modules</option>
												<c:forEach items="${modules}" var="module">
													<option value="${module.id}">${module.name}</option>
												</c:forEach>
											</select>
										</div>
									</div>
									<div class="col-md-12">
										<div class="mb-4 ">
											<label for="sprint" class="form-label">Sprint</label> <select
												class=" form-control form-control-sm form-select"
												aria-label="Default select example" name="task.sprint"
												id="sprint">

												<option selected class="pluck-radio-option form-control-sm"
													value="0">Select Sprint</option>
												<c:forEach items="${sprints}" var="sprint">
													<option value="${sprint.id}">${sprint.name}</option>
												</c:forEach>
											</select>
										</div>
									</div>

									<div class="col-md-12">
										<div class="mb-4 ">
											<label for="status" class="form-label">Status</label> <select
												class=" form-control form-control-sm form-select"
												aria-label="Default select example" name="task.status"
												id="status">


												<c:forEach items="${storyStatus}" var="storyStatus">
													<c:choose>
														<c:when test="${storyStatus == 'Open' }">
															<option selected="selected" value="${storyStatus}">${storyStatus}</option>
														</c:when>
														<c:when test="${storyStatus == 'TO-DO' }">
															<option selected="selected" value="${storyStatus}">${storyStatus}</option>
														</c:when>
													</c:choose>
												</c:forEach>
											</select>
										</div>
									</div>

									<div class="col-md-12">
										<div class="mb-3 ">
											<label for="reviewedBy" class="form-label"> Reviewed
												By/ Approved By</label> <select
												class=" form-control form-control-sm form-select"
												aria-label="Default select example" name="agile.reviewedBy"
												id="reviewedBy">

												<option selected class="pluck-radio-option form-control-sm"
													value="0">Select Assignee</option>
												<c:forEach items="${lists}" var="user">

													<option value="${user.id}"
														class="pluck-radio-option form-control-sm text-capitalize">
														${user.firstName} ${user.lastName}</option>
												</c:forEach>
											</select>
										</div>
									</div>

									<div class="col-md-12 mx-auto comment-box"
										style="position: relative;">
										<div class=" mt-3 ">
											<label for="exampleInputEmail1" class="form-label">Attachment</label>
											<input type="file" class="form-control form-control-sm"
												id="inputAttachment" disabled="disabled">
											<button type="button" id="closebtn"
												style="position: absolute; top: 60%; right: 4.5%; font-size: 12px; font-weight: 600;"
												class="comment-close-btn btn-close comment-btn"
												data-bs-dismiss="modal" onclick="clearFile()"
												aria-label="Close" style="position: relative;" ></button>
										</div>
									</div>



								</div>
							</div>


							<div class="col-6">
								<div class="row">
									<div class="col-md-12">
										<select class="form-select" style="display:none;"
											aria-label="Default select example" id="acceptanceCriteria"
											aria-label="Default select example"
											name="agile.acceptanceCriteria" multiple="multiple"></select>
										<div class="mb-3 ">
											<div
												class="d-flex justify-content-between aline-items-center ">
												<label for="acceptanceCriteria" class="form-label">Acceptance
													Criteria</label> <a href="javascript:void(0)" class="add-icon"
													id="add-new-criteria"> <i
													class="fa fa-plus-square fs-5 text-primary"> </i>
												</a>
											</div>

											<div class="card card-body"
												style="height: 280px; overflow-y: auto; padding: 10px;">
												<label for="acceptanceCriteria"
													class="form-label py-2 border-bottom mb-2">Existing
													Criteria</label>
												<ul class="list-group list-group-flush"
													id="Added-Acceptance-Criteria">
													<c:forEach items="${criterias }" var="criteria">
													<li class="list-group-item p-1  my-1 existing-criteria">
														<input class="form-check-input" value="${criteria.id }" type="checkbox" onchange="chnageCriteria(this)"> <span>${criteria.name }</span>
													</li>
													</c:forEach>

												</ul>
											</div>
											<div id="add-criteria" style="display: none;">
												<div class="input-group my-3">
													<input type="text" class="form-control form-control-sm"
														id="criteria-text">
													<button class="btn btn-secondary px-4" type="button"
														id="add-criteria-but">Add</button>
												</div>
											</div>
										</div>
									</div>


								</div>

							</div>
						</div>
					</div>



					<div class="text-end  mb-2 me-3">
						<button class="action back btn btn-sm btn-secondary mx-2"
							style="display: none">Back</button>
						<button class="action next btn btn-sm bg-primary  add-btn py-1 "
							id="nextBtn" disabled="disabled">Next</button>
						<input type="submit"
							class="action submit btn btn-sm btn-primary  "
							style="display: none" id="submit">
					</div>
				</div>
			</form>
		</div>
	</div>
</div>

<!-- partial -->
<script
	src='https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js'></script>
<script
	src='https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta2/dist/js/bootstrap.bundle.min.js'></script>

<script>
	var step = 1;
	$(document).ready(function() {
		stepProgress(step);
	});

	$(".next").on("click", function(e) {
		e.preventDefault();
		var nextstep = true;

		if (nextstep == true) {
			if (step < $(".step").length) {
				$(".step").show();
				$(".step").not(":eq(" + step++ + ")").hide();
				stepProgress(step);
			}
			hideButtons(step);
		}
	});

	// ON CLICK BACK BUTTON
	$(".back").on("click", function(e) {
		e.preventDefault();
		if (step > 1) {
			step = step - 2;
			$(".next").trigger("click");
			$(".step-2").removeClass("bg-success text-light")
		}
		hideButtons(step);

	});

	// CALCULATE PROGRESS BAR
	stepProgress = function(currstep) {
		var percent = parseFloat(100 / $(".step").length) * currstep;
		percent = percent.toFixed();
		$(".progress-bar").css("width", percent + "%").addClass("rounded");
		// .html(percent + "%");
		if (percent > "49%") {
			$(".step-1").addClass("bg-primary text-light")
		} else {
			$(".step-2").addClass("bg-primary text-light")
		}

	};

	// DISPLAY AND HIDE "NEXT", "BACK" AND "SUMBIT" BUTTONS
	hideButtons = function(step) {
		var limit = parseInt($(".step").length);
		$(".action").hide();
		if (step < limit) {
			$(".next").show();
		}
		if (step > 1) {
			$(".back").show();
		}
		if (step == limit) {
			$(".next").hide();
			$(".submit").show();
		}
	};

	$('#myOptions').change(function() {
		var val = $("#myOptions option:selected").text();
		$("#popupBtn").css("display", "block")
	});

	$("#add-new-criteria").click(function() {
		$("#add-criteria").css("display", "block");
	})

	$("#add-criteria-but").click(
			function() {
				let newlist = document.createElement('li');
				newlist.setAttribute('class',
						'list-group-item p-1  my-1 existing-criteria');

				let criteria = $("#criteria-text").val();
				let checkbox = document.createElement('input');
				checkbox.setAttribute('type', 'checkbox');
				checkbox.setAttribute('class', 'form-check-input');
				checkbox.setAttribute('onchange',"chnageCriteria(this)");
				checkbox.setAttribute('checked',"checked");

				newlist.appendChild(checkbox);
				let newSpan = document.createElement('span');
				newSpan.append(criteria);
				newlist.appendChild(newSpan);

				console.log(criteria,checkbox)

				if (criteria) {
					$("#Added-Acceptance-Criteria").append(newlist)
				}

				addCriteria(criteria,checkbox);

				$("#criteria-text").val("");

				$("#add-criteria").css("display", "none");

			});

	function chnageCriteria(e) {
	console.log(e);
	console.log(e.checked);
	console.log('called');
		if(e.checked){
			addOption(e.value);
		 }else{
			 removeOptionByValue(e.value); 
		 }
	}
	function addOption(valueToAdd) {
		/*   const selectElement = document.getElementById('acceptanceCriteria');
		  
		  // Create a new option element
		  const newOption = document.createElement('option');
		  
		  // Set the value and text for the new option
		  newOption.value = valueToAdd;
		  newOption.text = valueToAdd; // Capitalize the first letter
		  
		  // Append the new option to the select element
		  selectElement.appendChild(newOption); */
		  
		let select = document.getElementById('acceptanceCriteria');
		let option = document.createElement('option');
		option.setAttribute('class',
				'pluck-radio-option form-control-sm');
		option.setAttribute('value', valueToAdd);
		option.innerHTML = valueToAdd;
		option.setAttribute('selected', 'selected');
		//select.appendChild(option);
		let firstOption = select.options[0];
		select.insertBefore(option, firstOption);
		}

	function removeOptionByValue(valueToRemove) {
		  const selectElement = document.getElementById('acceptanceCriteria');
		  const options = selectElement.getElementsByTagName('option');

		  for (let i = 0; i < options.length; i++) {
		    if (options[i].value === valueToRemove) {
		      selectElement.removeChild(options[i]);
		      break; // Stop the loop once the option is removed to avoid unnecessary iterations
		    }
		  }
		}
	function addCriteria(criteria,e) {

		if (criteria == "") {
			toastr.error("Cannot add Empty Criteria!");
			return false;
		} else {
			$.ajax({
				type : "POST",
				url : "${pageContext.request.contextPath}/criterias/dynamic",
				data : '{"name":"' + criteria + '"}',
				contentType : "application/json",
				async : false,
				success : function(data) {
					console.log(data);
					let select = document.getElementById('acceptanceCriteria');
					let option = document.createElement('option');
					option.setAttribute('class',
							'pluck-radio-option form-control-sm');
					option.setAttribute('value', data.id);
					option.innerHTML = data.name;
					option.setAttribute('selected', 'selected');
					//select.appendChild(option);
					let firstOption = select.options[0];
					select.insertBefore(option, firstOption);
					//e.remove();
					//sibling.remove();
					e.value=data.id;
					console.log(e)
				}
			});
		}

	}

	function setValue() {
		var el = document.getElementById('acceptanceCriteria');
		var text = el.options[el.selectedIndex].innerHTML;
		let ul = document.getElementById('criteria-list');
		let li = document.createElement('li');
		li.innerHTML = text;
		li.setAttribute('class', 'list-group-item');
		ul.appendChild(li);

	}
</script>