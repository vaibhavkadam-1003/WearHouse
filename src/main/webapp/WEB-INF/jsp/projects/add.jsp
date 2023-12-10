<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<script src="https://code.jquery.com/jquery-3.6.1.js" integrity="sha256-3zlB5s2uwoUzrXK3BT7AX3FyvojsraNFxCc2vC/7pNI=" crossorigin="anonymous"></script>
<link href="${pageContext.request.contextPath}/css/addProject.css" rel="stylesheet">
<script src="${pageContext.request.contextPath}/js/addProject.js"></script>
<script src="${pageContext.request.contextPath}/js/common.js"></script>
<script src="https://code.jquery.com/jquery-3.6.1.js" integrity="sha256-3zlB5s2uwoUzrXK3BT7AX3FyvojsraNFxCc2vC/7pNI=" crossorigin="anonymous"></script>
<script src="${pageContext.request.contextPath}/js/validation.js"></script>
<link href="${pageContext.request.contextPath}/css/project.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/css/choices.css" rel="stylesheet">
</head>
<body>
	<jsp:include page="../common/header.jsp"></jsp:include>

<div class="main-content">

		<div class="container-fluid">
			<!-- <div class="main-filter">
				<button class="btn btn-sm main-btn">Add Project</button>
			</div> -->
			<div class="">
				<div class="card">
					<div class="card-body p-0">
						<div class="row">
						
					<div class="col-md-7">
					<form name="myform" id="addProjectForm" action="${pageContext.request.contextPath}/projects/addProject" method="post"
			class="" onsubmit="return addProjectValidation()">
								<div class="card-body">
									<small>Basics Project Informetion</small>

									<div class="mb-3 mt-4">
										<label class="form-label"> Project Name <span
											class="mandatory-sign">*</span></label> <input type="text"
											class="form-control choices__inner" id="name" placeholder="Enter name"
											name="name"
											onblur="this.value=validateCompanyName(this,'name','name-validation-id');"
											required> <span id="name-validation-id"
											class="validation-span-c"></span>
									</div>

									<div class="my-3">
										<label class="form-label">Project Administrator <span
											class="mandatory-sign">*</span></label> <select name="owners"
											id="owners"
											class=" form-control form-select owners choices-multiple-remove-button"
											placeholder="Select user" multiple>
											<c:forEach items="${lists}" var="list">
												<option class="pluck-radio-option form-control-sm"
													value="${list.id}">${list.firstName}
													${list.lastName} [${list.username }]</option>
											</c:forEach>
										</select> <span class="error-message-text-color"
											id="owner_error_message"></span>
									</div>


									<div class="my-3">
										<label class="form-label"> Project User <span
											class="mandatory-sign">*</span></label> <select name="users"
											id="users"
											class=" form-control form-control-sm form-select users choices-multiple-remove-button"
											placeholder="Select user" multiple>
											<c:forEach items="${lists}" var="list">
												<option class="pluck-radio-option form-control-sm"
													value="${list.id}">${list.firstName}
													${list.lastName} [${list.username }]</option>
											</c:forEach>

										</select> <span class="error-message-text-color"
											id="user_error_message"></span>

									</div>

									<div class="my-3">
										<label class="form-label"> Project Start Date <span
											class="mandatory-sign">*</span></label> <input type="date"
											class="form-control choices__inner" id="startDate" min="2023-01-01"
											placeholder="Enter StartDate" name="startDate" required
											onkeydown="return false"> <span
											id="start_date_validation" class="validation-span-c"></span>
									</div>
									
									<div class="my-3">
										<label class="form-label"> Project Last Date <span
											class="mandatory-sign">*</span></label> 
										<input type="date" class="form-control  " id="lastDate"
												max="2026-01-01" placeholder="Enter StartDate"
												name="lastDate" onkeydown="return false"> <span
												id="end_date_validation"
												class="validation-span-c 6 "></span>
									</div>

									<div class="mb-3">
										<label for="exampleFormControlTextarea1" class="form-label">
											Project Description </label> 
										<textarea rows="3" class="form-control " id="description"
											placeholder="Enter description" name="description"></textarea>
										<span class="error-message-text-color"
											id="description_error_msg"></span>
									</div>
									
									<div class=" project-added-btn text-center my-4">
						<button id="project-cancel" type="reset" color="primary" class="btn btn-secondary btn-sm mx-2" onclick="window.location.href='${pageContext.request.contextPath}/projects/allproject?pageNo=0'">Cancel</button>
						<button id="project-add" type="submit" color="primary" class="btn btn-primary Pluck-btn btn-sm" disabled="disabled">Add</button>
					</div>

								</div>
</form>
							</div>
							
 
					<div class="col-md-5 bg-light border project-img-wrapper">
						<div style="padding: 1rem 1rem;">
						 
									<div class="text-center mt-3">
										<h6>Application Features</h6>
										<p>Lorem Ipsum has been the industry's
											standard dummy text ever since the 1500s, when an unknown
											printer took a galley of type and scrambled it to make a type
											specimen book</p>
										

										<div id="carouselExampleIndicators " class="carousel slide"
											data-bs-ride="carousel">
											<div class="carousel-indicators">
												<button type="button"
													data-bs-target="#carouselExampleIndicators"
													data-bs-slide-to="0" class="active" aria-current="true"
													aria-label="Slide 1"></button>
												<button type="button"
													data-bs-target="#carouselExampleIndicators"
													data-bs-slide-to="1" aria-label="Slide 2"></button>
												<button type="button"
													data-bs-target="#carouselExampleIndicators"
													data-bs-slide-to="2" aria-label="Slide 3"></button>
											</div>
											<div class="carousel-inner" style="height:56vh;">
												<div class="carousel-item text-center   active">
													<img src="${pageContext.request.contextPath}/images/add-project.svg" class="d-block w-100 p-5">
												</div>
												<div class="carousel-item text-center  ">
													<img src="${pageContext.request.contextPath}/images/growth_analytics.svg" class="d-block w-100 p-5">
												</div>
												<div class="carousel-item text-center  ">
													<img src="${pageContext.request.contextPath}/images/informetion.svg"  class="d-block w-100 p-5">
												</div>
											</div>
											
										</div>
									</div>
								</div>
					</div>
				</div>
					</div>
				</div> 
			</div>

		</div>




		
</div>


<script src="https://cdn.jsdelivr.net/gh/bbbootstrap/libraries@main/choices.min.js"></script>
<script>
        $(document).ready(function(){
        
    var multipleCancelButton = new Choices('.choices-multiple-remove-button', {
       removeItemButton: true,
       searchResultLimit:5
     }); 
    
});
    </script>
</body>
</html>