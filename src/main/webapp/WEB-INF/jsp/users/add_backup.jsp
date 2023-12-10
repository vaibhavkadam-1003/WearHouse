
<%@page import="com.pluck.dto.LoginUserDto"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<script src="https://code.jquery.com/jquery-3.6.1.js"
	integrity="sha256-3zlB5s2uwoUzrXK3BT7AX3FyvojsraNFxCc2vC/7pNI="
	crossorigin="anonymous"></script>
<link href="${pageContext.request.contextPath}/css/addCompany.css"
	rel="stylesheet">
<link href="${pageContext.request.contextPath}/css/user.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/css/choices.css" rel="stylesheet">
<script src="${pageContext.request.contextPath}/js/addUser.js"></script>
<script src="${pageContext.request.contextPath}/js/common.js"></script>
<script src="${pageContext.request.contextPath}/js/profileUpload.js"></script>
<script src="${pageContext.request.contextPath}/js/validation.js"></script>
<script src="https://cdn.jsdelivr.net/gh/bbbootstrap/libraries@main/choices.min.js"></script>

</head>
<body>
	<jsp:include page="../common/header.jsp"></jsp:include>

	<%
	if ( session.getAttribute( "username" ) == null ) {
		response.sendRedirect( "/loginForm" );
	}
	%>
	<div class="main-content ">
		<div class="col-md-12">
			<div class="row">
				<div class="col-md-12 title">
					<h4>Add User</h4>
				</div>
			</div>
			<form action="${pageContext.request.contextPath}/users" method="post"
				class="" name="myform" onsubmit="return addUserValidation()"
				enctype="multipart/form-data" id="addUserForm">

				<div class="my-4">
					<div class="row">
						<div class="col-md-3 userProfileLogo mt-4 text-center">
							<figure class="figure p-2 border">
								<img src="${pageContext.request.contextPath}/images/images.png"
									class="figure-img img-fluid rounded profile-pic" alt="...">
							</figure>
							<div class="text-center">
								<button type="button" id="delete-button"
									class="btn  btn-sm  p-2 mx-2">
									<i class="fa fa-trash text-danger fs-5 upload-button"
										aria-hidden="true"></i>
								</button>

								<div class="btn  btn-sm  p-2 mx-2">
									<label class="" for="inputGroupFile01"><i
										class="fa fa-pencil-square text-primary fs-5"
										aria-hidden="true"></i></label> <input type="file"
										id="inputGroupFile01" class="file-upload"
										name="profilePicFile" style="display: none;"
										accept=".png, .jpg, .jpeg" />

								</div>


							</div>
						</div>

						<div class="col-md-9 ">
							<div class="row">
								<div class="col-6">
									<div class="mb-3 ">
										<label class="col-form-label">First Name</label><span
											class="mandatory-sign">*</span> <input type="text"
											class="form-control form-control-sm" placeholder="eg.John"
											name="firstName" id="firstName"
											onblur="this.value=nameValidate(this,'firstName-validation-id');"
											required> <span id="firstName-validation-id"
											class="validation-span-c"></span>
									</div>
								</div>
								<div class="col-6">
									<div class="mb-3 ">
										<label class="col-form-label">Last Name</label><span
											class="mandatory-sign">*</span> <input type="text"
											class="form-control form-control-sm" placeholder="eg.Carten"
											name="lastName" id="lastName"
											onblur="this.value=nameValidate(this,'lastName-validation-id');"
											required> <span id="lastName-validation-id"
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
											required> <span
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
									<div class="mb-3 ">
										<label class="col-form-label">Job Title</label> <input
											type="text" class="form-control form-control-sm"
											placeholder="eg.Java Developer" name="jobTitle" id="jobTitle"
											onblur="this.value=validateJobTitle(this,'job-validation-id');" />
										<span id="job-validation-id" class="validation-span-c"></span>
									</div>
								</div>
								<div class="col-6">

									<div class="mb-3 ">
										<label class="col-form-label">Contact Number</label> <span
											class="mandatory-sign">*</span><input type="text"
											class="form-control form-control-sm" id="contactNumber"
											placeholder="eg.1234567890" name="contactNumber"
											onblur="this.value=validatePhone(this,'primaryPhone1-validation-span-id');"
											required> <span id="primaryPhone1-validation-span-id"
											class="validation-span-c"></span>

									</div>

								</div>
							</div>
							<div class="row">
								<div class="col-12">
									<div class="mb-3 ">
										<label class="col-form-label">Role</label><span
											class="mandatory-sign">*</span> <select name="role"
											id="role"
											class=" form-control form-control-sm form-select users choices-multiple-remove-button"
											placeholder="Select user" multiple>

											<c:forEach items="${LowerRoles }" var="roleObj">
												<option value="${roleObj.value}">${roleObj.label}</option>
											</c:forEach>	

										</select> <span class=error-message-text-color id="user_role_id"></span>
									</div>
								</div>
							</div>
							<div class="col text-center my-4">
								<button id="user-cancel" type="reset" color="primary"
									class="btn btn-secondary btn-sm"
									onclick="window.location.href='${pageContext.request.contextPath}/users?pageNo=0'">Cancel</button>
								<button id="user-add" type="submit" color="primary"
									class="btn btn-primary Pluck-btn btn-sm" disabled="disabled"
									onClick="return userProfileUpload();">Add</button>

							</div>
						</div>
					</div>
				</div>
			</form>

		</div>
	</div>
</body>
<script>
        $(document).ready(function(){
        
    var multipleCancelButton = new Choices('.choices-multiple-remove-button', {
       removeItemButton: true,
       searchResultLimit:5,
       renderChoiceLimit:5
     }); 
    
});
    </script>
</html>