<%@page import="com.pluck.dto.LoginUserDto"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<script src="https://code.jquery.com/jquery-3.6.1.js"
	integrity="sha256-3zlB5s2uwoUzrXK3BT7AX3FyvojsraNFxCc2vC/7pNI="
	crossorigin="anonymous"></script>
<%-- <link href="${pageContext.request.contextPath}/css/addCompany.css"
	rel="stylesheet">
<link href="${pageContext.request.contextPath}/css/user.css"
	rel="stylesheet"> --%>
<link href="${pageContext.request.contextPath}/css/choices.css"
	rel="stylesheet">
<script src="${pageContext.request.contextPath}/js/addUser.js"></script>
<script src="${pageContext.request.contextPath}/js/common.js"></script>
<script src="${pageContext.request.contextPath}/js/profileUpload.js"></script>
<script src="${pageContext.request.contextPath}/js/validation.js"></script>
<script
	src="https://cdn.jsdelivr.net/gh/bbbootstrap/libraries@main/choices.min.js"></script>
<script src="https://code.jquery.com/jquery-3.6.1.js"
	integrity="sha256-3zlB5s2uwoUzrXK3BT7AX3FyvojsraNFxCc2vC/7pNI="
	crossorigin="anonymous"></script>
	
<script src="${pageContext.request.contextPath}/js/validation.js"></script>

<link
     rel="stylesheet"
     href="https://cdnjs.cloudflare.com/ajax/libs/intl-tel-input/17.0.8/css/intlTelInput.css"
   />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.1/css/all.min.css">
  <style>
	.iti--separate-dial-code {
	width: 100% !important;
}
</style>
 
<script>
    var contextPath = "${pageContext.request.contextPath}";
</script>


</head>
<body>
	<jsp:include page="../common/header.jsp"></jsp:include>
	<input type="hidden" id="contextPathInput"  value="${pageContext.request.contextPath}">
	
	<%
	if (session.getAttribute("username") == null) {
		response.sendRedirect("/loginForm");
	}
	%>
	<div class="main-content ">
		<div class="col-md-12" id="user-add-invited">
			<nav  >
				<div class="nav nav-tabs flex-row justify-content-start border-0 pb-3"
					id="nav-tab" role="tablist">
					<button class="nav-link   border-0 active"
						id="nav-AddUser-tab" data-bs-toggle="tab"
						data-bs-target="#nav-AddUser" type="button" role="tab"
						aria-controls="nav-AddUser" aria-selected="true"
						style="outline: none;">Add User</button>
					<button class="nav-link   border-0"
						id="nav-inviteUser-tab" data-bs-toggle="tab"
						data-bs-target="#nav-inviteUser" type="button" role="tab"
						aria-controls="nav-inviteUser" aria-selected="false"
						style="outline: none;">Invite User</button>
				</div>
			</nav>
			<div class="tab-content" id="nav-tabContent">
    <div class="tab-pane fade show active" id="nav-AddUser" role="tabpanel" aria-labelledby="nav-AddUser-tab">
      <form action="${pageContext.request.contextPath}/users" method="post" class="" name="myform" onsubmit="return addUserValidation()" enctype="multipart/form-data" id="addUserForm">
        <div class="wrapper-addUser">

							<div class="row">
								<div class="col-md-3">
									<div class="card">
										<div class="card-body">
											<small>Profile Photo</small>
											<div
												class="d-flex justify-content-center align-items-center my-4 userProfileLogo">
												<img
													src="${pageContext.request.contextPath}/images/images.png"
													class="figure-img img-fluid " alt="...">
												<div class="text-center">
													<div class="img-info">
														<label class=" text-start" for="inputGroupFile01">
															<p>Pick a Photo Form Your Computer</p> <i> Add pick</i>

														</label> <input type="file" id="inputGroupFile01"
															class="file-upload" name="profilePicFile"
															style="display: none;" accept=".png, .jpg, .jpeg" />
													</div>
												</div>
											</div>
											<hr />
											<div >
												<div class="form-check form-switch d-flex justify-content-between align-items-center mx-0 my-3 p-0">
												<label class="form-check-label m-0 p-0" for="flexSwitchCheckDefault"> Notification</label>
													<input class="form-check-input" type="checkbox"
														id="flexSwitchCheckDefault"> 
												</div>
												
												<div class="form-check form-switch d-flex justify-content-between align-items-center mx-0 my-3 p-0">
												<label class="form-check-label m-0 p-0" for="flexSwitchCheckDefault"> Active</label>
													<input class="form-check-input" type="checkbox"
														id="flexSwitchCheckDefault"> 
												</div>
												
											</div>

										</div>
									</div>
								</div>
								<div class="col-md-9">
									<div class="card">
										<div class="card-body px-4 mx-3">

											<div class="row">
												<small class="mb-3">User Information</small>



												<div class="col-md-6">
													<div class="mb-3">
														<label class="col-form-label">First Name</label><span
															class="mandatory-sign">*</span> <input type="text"
															class="form-control form-control-sm"
															placeholder="eg.John" name="firstName" id="firstName"
															onblur="this.value=nameValidate(this,'firstName-validation-id');"
															required=""> <span id="firstName-validation-id"
															class="validation-span-c"></span>
													</div>
												</div>
												<div class="col-md-6">
													<div class="mb-3">
														<label class="col-form-label">Last Name</label><span
															class="mandatory-sign">*</span> <input type="text"
															class="form-control form-control-sm"
															placeholder="eg.Carten" name="lastName" id="lastName"
															onblur="this.value=nameValidate(this,'lastName-validation-id');"
															required=""> <span id="lastName-validation-id"
															class="validation-span-c"></span>
													</div>
												</div>
											</div>
											<div class="row">
												<div class="col-6">
													<div class="mb-3">
														<label class="col-form-label">Username</label><span
															class="mandatory-sign">*</span> <input type="email"
															class="form-control form-control-sm"
															placeholder="eg.pluck@veracity-india.com" name="username"
															id="username"
															onblur="this.value=validateUsername(this,' username ','primaryEmailId1-validation-span-id');"
															required=""> <span
															id="primaryEmailId1-validation-span-id"
															class="validation-span-c"></span>
													</div>
												</div>
												<div class="col-6">
													<div class="mb-3">
														<label class="col-form-label">Alternate Email ID</label> <input
															type="email" class="form-control form-control-sm"
															placeholder="eg.pluck@veracity-india.com"
															name="alternateEmailId" id="alternateEmailId"
															onblur="this.value=validateSecondaryEmail(this,'email','secondaryEmail-validation-span-id');">
														<span id="secondaryEmail-validation-span-id"
															class="validation-span-c"></span>
													</div>
												</div>
											</div>
											<div class="row">
												<div class="col-6">
													<div class="mb-3">
														<label class="col-form-label">Designation</label> <input
															type="text" class="form-control form-control-sm"
															placeholder="eg.Java Developer" name="jobTitle"
															id="jobTitle"
															onblur="this.value=validateJobTitle(this,'job-validation-id');">
														<span id="job-validation-id" class="validation-span-c"></span>
													</div>
												</div>
												<div class="col-6">
													<div class="mb-3">
														<label class="col-form-label">Contact Number</label> <span
															class="mandatory-sign">*</span><br> <input
															id="countryCode" type="text" name="Contact" value=" "
															class="form-control form-control-sm w-100"> <span
															id="primaryPhone1-validation-span-id"
															class="validation-span-c"></span>
													</div>
													<div class="col-6 d-none">
														<div class="mb-3">
															<input id="contactNumber" type="text"
																name="contactNumber" value=" number"
																class="form-control form-control-sm"
																onblur="this.value=validatePhone(this,'primaryPhone1-validation-span-id');">
															<span id="primaryPhone1-validation-span-id"
																class="validation-span-c"></span>
														</div>
													</div>
												</div>
												<div class="col-6 d-none">
													<div class="mb-3">
														<input id="countryCode1" type="text" name="countryCode"
															value="RemoveNumber" class="form-control form-control-sm">
														<span id="primaryPhone1-validation-span-id"
															class="validation-span-c"></span>
													</div>
												</div>
												<div class="row">
													<div class="col-12">
														<div class="mb-3 ">
															<label class="col-form-label">Project Role</label><span
																class="mandatory-sign">*</span> <select name="role"
																id="role"
																class=" form-control form-control-sm form-select users choices-multiple-remove-button"
																placeholder="Select User" multiple>

																<c:forEach items="${LowerRoles}" var="roleObj">
																	<option value="${roleObj.value}">${roleObj.label}</option>
																</c:forEach>

															</select> <span class=error-message-text-color id="user_role_id"></span>
														</div>
													</div>
												</div>
												<div class="col text-center mt-5 mb-3">
													<button id="user-cancel" type="reset" color="primary"
														class="btn btn-secondary btn-sm "
														onclick="window.location.href='${pageContext.request.contextPath}/users?pageNo=0'">Cancel</button>
													<button id="user-add" type="submit" color="primary"
														class="btn btn-primary Pluck-btn btn-sm "
														disabled="disabled" onclick="return userProfileUpload();">Add</button>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>





							
        </div>
      </form>
    </div><!-- add user code end -->
    <!-- invite user code start -->
				<div class="tab-pane fade" id="nav-inviteUser" role="tabpanel"
					aria-labelledby="nav-inviteUser-tab">

					<div class="col-md-12 mx-auto text-center ">

						<div class="row">
							<div class="col-7 require-Email-id">
								<div class="card shadow-lg" style="height: 80vh;">
									<div class="card-body">
										<form action="${pageContext.request.contextPath}/invite"
											method="post" id="invite-user-form">
											<div class="py-3 pe-4 my-2 ">
												<div class="mb-3">
													<label class="col-form-label">Email ID</label> <span
														class="text-danger">*</span> <input type="text"
														class="form-control form-control-sm" id="email1"
														placeholder="Email ID" name="email1"
														onblur="this.value=validateUsername(this,' email ','primaryEmailId1-validation-span-id');"
														required=""> <span
														id="primaryEmailId1-validation-span-id"
														class="validation-span-c"></span>
												</div>
												<div class="mb-3">
													<label class="col-form-label">Email ID</label> <input
														type="text" class="form-control form-control-sm" id=""
														placeholder="Email ID" name="email2"
														onblur="this.value=validateInviteUsername(this,' email ','primaryEmailId2-validation-span-id');">
													<span id="primaryEmailId2-validation-span-id"
														class="validation-span-c2"></span>
												</div>
												<div class="mb-3">
													<label class="col-form-label">Email ID</label> <input
														type="text" class="form-control form-control-sm" id=""
														placeholder="Email ID" name="email3"
														onblur="this.value=validateInviteUsername(this,' email ','primaryEmailId3-validation-span-id');">
													<span id="primaryEmailId3-validation-span-id"
														class="validation-span-c3"></span>
												</div>
												<div class="mb-3">
													<label class="col-form-label">Email ID</label> <input
														type="text" class="form-control form-control-sm" id=""
														placeholder="Email ID" name="email4"
														onblur="this.value=validateInviteUsername(this,' email ','primaryEmailId4-validation-span-id');">
													<span id="primaryEmailId4-validation-span-id"
														class="validation-span-c4"></span>
												</div>
												<div class="mb-3">
													<label class="col-form-label">Email ID</label> <input
														type="text" class="form-control form-control-sm" id=""
														placeholder="Email ID" name="email5"
														onblur="this.value=validateInviteUsername(this,' email ','primaryEmailId5-validation-span-id');">
													<span id="primaryEmailId5-validation-span-id"
														class="validation-span-c5"></span>
												</div>
												<div class="row ">
													<div class="text-center">
														<button type="reset" class="btn btn-secondary btn-sm">Clear</button>
														<button type="submit"
															class="btn btn-primary Pluck-btn btn-sm" id="invite-add"
															disabled="disabled">Add</button>
													</div>
												</div>
											</div>


										</form>
									</div>
								</div>

							</div>

							<div class="col-md-5">
								<div class="card shadow-lg  " style="height: 80vh;">
									<div class="card-body">
										<img
											src="${pageContext.request.contextPath}/images/inviteUser.svg"
											style="width: 80%; margin-top: 100px;" inviteUser"/>
									</div>
								</div> 
							</div>
						</div> 
					</div>


				</div>
				<!-- invite user code end -->
  </div>
</div>
	</div>

	<script src="${pageContext.request.contextPath}/js/inviteUser.js"></script>

	<script>
		/* 		$(document).ready( function() {
		 loadTable(${userList.number});
		 }); */

		$(document).ready(function() {
			$('#tableID').DataTable({
				scrollY : '48vh',
				scrollCollapse : true,
			});
		});
	</script>

</body>
<script>
	$(document).ready(
			function() {

				var multipleCancelButton = new Choices(
						'.choices-multiple-remove-button', {
							removeItemButton : true,
							searchResultLimit : 5,
							renderChoiceLimit : 5
						});

			});
</script>




<!-- Phone no js -->
 <script src="https://cdnjs.cloudflare.com/ajax/libs/intl-tel-input/17.0.8/js/intlTelInput.min.js"></script>




</html>