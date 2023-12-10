<%@page import="com.pluck.dto.LoginUserDto"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<script src="https://code.jquery.com/jquery-3.6.1.js"
	integrity="sha256-3zlB5s2uwoUzrXK3BT7AX3FyvojsraNFxCc2vC/7pNI="
	crossorigin="anonymous"></script>
<script src="${pageContext.request.contextPath}/js/updateUser.js"></script>
<script src="${pageContext.request.contextPath}/js/common.js"></script>
<script src="${pageContext.request.contextPath}/js/validation.js"></script>
<script src="${pageContext.request.contextPath}/js/profileUpload.js"></script>
	
<link href="${pageContext.request.contextPath}/css/user.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/css/choices.css" rel="stylesheet">

<link
     rel="stylesheet"
     href="https://cdnjs.cloudflare.com/ajax/libs/intl-tel-input/17.0.8/css/intlTelInput.css"
   />
 <script src="https://cdnjs.cloudflare.com/ajax/libs/intl-tel-input/17.0.8/js/intlTelInput.min.js"></script>
 
 <style>
	.iti--separate-dial-code {
	width: 100% !important;
}
</style>
	
<jsp:include page="../common/header.jsp"></jsp:include>
<input type="hidden" id="contextPathInput"  value="${pageContext.request.contextPath}">
	
<%
if (session.getAttribute("username") == null) {
	response.sendRedirect("/loginForm");
}
%>
<div class="main-content ">
	<div class="col-md-12">
		<div class="row">
			<div class="col-md-12 title">
				<h4>User Profile Details</h4>
			</div>
		</div>
		<form action="${pageContext.request.contextPath}/users/update"
			method="post" class="" name="myform"
			onsubmit="return addUserValidation()" enctype="multipart/form-data">

			<div class="my-4">
				<div class="row">

					<div class="col-md-3 userProfileLogo mt-4 text-center">
						<c:choose>
							<c:when test="${not empty user.profilePic}">
								<figure class="figure p-2 border">
									<img src="${pageContext.request.contextPath}/image/${user.profilePic}"
										class="figure-img img-fluid rounded profile-pic" />
								</figure>
							</c:when>
							<c:otherwise>
								<figure class="figure p-2 border">
									<img src="${pageContext.request.contextPath}/images/images.png"
										class="figure-img img-fluid rounded profile-pic" />
								</figure>
							</c:otherwise>
						</c:choose>
						<div class="text-center">
							<button type="button" id="delete-button"
								class="btn  btn-sm  p-2 mx-2">
								<i class="fa fa-trash text-danger fs-5" aria-hidden="true"
									onclick="deleteProfileLogo(${user.id}, '${pageContext.request.contextPath}')"></i>
							</button>

							<div class="btn  btn-sm  p-2 mx-2">
								<label class="" for="inputGroupFile01"> <i
									class="fa fa-pencil-square text-primary fs-5"
									aria-hidden="true"></i>
								</label> <input type="file" id="inputGroupFile01" class="file-upload"
									name="profilePicFile" accept=".png, .jpg, .jpeg"
									style="display: none;" />
							</div>
						</div>
					</div>

					<div class="col-md-9  ">
						<div class="row">
							<div class="col-6">
								<div class="mb-3 ">
									<label class="col-form-label">First Name</label><span
										class="mandatory-sign">*</span> <input type="text"
										class="form-control form-control-sm"
										placeholder="Enter first name here" name="firstName"
										value="${user.firstName}" id="firstName"
										onblur="this.value=nameValidate(this,'firstName-validation-id');"
										required
										<c:if test="${user.status == 'Inactive'}"><c:out value="readonly='readonly'" /></c:if>>
									<span id="firstName-validation-id" class="validation-span-c"></span>
								</div>
							</div>
							<div class="col-6">
								<div class="mb-3 ">
									<label class="col-form-label">Last Name</label><span
										class="mandatory-sign">*</span> <input type="text"
										class="form-control form-control-sm"
										placeholder="Enter last name here" name="lastName"
										value="${user.lastName}" id="lastName"
										onblur="this.value=nameValidate(this,'lastName-validation-id');"
										required
										<c:if test="${user.status == 'Inactive'}"><c:out value="readonly='readonly'" /></c:if>>
									<span id="lastName-validation-id" class="validation-span-c"></span>
								</div>

							</div>
						</div>


						<div class="row">

							<div class="col-6">
								<div class="mb-3">
									<label class="col-form-label">Username</label><span
										class="mandatory-sign">*</span> <input type="email"
										class="form-control form-control-sm"
										placeholder="Enter username here" name="username"
										value="${user.username}" id="username" readonly="readonly">

								</div>
							</div>
							<div class="col-6">

								<div class="mb-3">
									<label class="col-form-label">Alternate Email ID</label> <input
										type="email" class="form-control form-control-sm"
										placeholder="Enter alternate email here"
										value="${user.alternateEmailId}" name="alternateEmailId"
										id="alternateEmailId"
										onblur="this.value=validateSecondaryEmail(this,'email','secondaryEmail-validation-span-id');"
										<c:if test="${user.status == 'Inactive'}"><c:out value="readonly='readonly'" /></c:if>>
									<span id="secondaryEmail-validation-span-id"
										class="validation-span-c"></span>
								</div>
							</div>

						</div>
						<div class="row">
							<div class="col-6">
								<div class="mb-3 ">
									<label class="col-form-label">Designation</label> <input
										type="text" class="form-control form-control-sm"
										placeholder="Enter job title here" name="jobTitle"
										onblur="this.value=validateJobTitle(this,'job-validation-id');"
										value="${user.jobTitle}" id="jobTitle"
										<c:if test="${user.status == 'Inactive'}"><c:out value="readonly='readonly'" /></c:if>>
									<span id="job-validation-id" class="validation-span-c"></span>
								</div>
							</div>

							<div class="col-6">
								<div class="mb-3 ">
									<label class="col-form-label">Contact Number </label> <span
										class="mandatory-sign">*</span><br/> 		
										<input id="countryCode1"
										type="text" name="countryCode1" value=" "
										class="form-control form-control-sm w-100" /> <span
										id="primaryPhone1-validation-span-id"
										class="validation-span-c"></span>
								</div>
							</div>

							<div class="col-6 d-none">

								<div class="mb-3 ">
									<label class="col-form-label"> </label> <span
										class="mandatory-sign">*</span><input type="hidden"
										class="form-control form-control-sm" id="contactNumber"
										placeholder="Enter contact number"
										value="${user.contactNumber}" name="contactNumber"
										onblur="this.value=validatePhone(this,'primaryPhone1-validation-span-id');"
										required
										<c:if test="${user.status == 'Inactive'}"><c:out value="readonly='readonly'" /></c:if>>
									<span id="primaryPhone1-validation-span-id"
										class="validation-span-c"></span>
								</div>

							</div>

							<div class="col-6 d-none">

								<div class="mb-3 ">
									<label class="col-form-label"> </label> <span
										class="mandatory-sign">*</span>									
										<input type="hidden"
										class="form-control form-control-sm" id="countryCode"
										placeholder="Enter contact number" value="${user.countryCode}"
										name="countryCode"
										<c:if test="${user.status == 'Inactive'}"><c:out value="readonly='readonly'" /></c:if>>
									<span id="primaryPhone1-validation-span-id"
										class="validation-span-c"></span>
								</div>

							</div>


						</div>
						<div class="row">
							<div class="col-6">
								<div class="mb-3 ">

                                    <label for="exampleInputEmail1" class="form-label">Project Role</label>
                                    <span class="mandatory-sign">*</span> 
                                    
                                    <c:choose>
                                        <c:when test="${ loggedInUser.id == user.id || 
                                    loggedInUser.role == 'Project User' ||
                                     (loggedInUser.role == 'Project Lead' && user.role == 'Company Admin')}">
												<div class="overlay" style="pointer-events: none">
													<select name="role" id="role"
														class=" form-control form-control-sm form-select users choices-multiple-remove-button1"
														aria-label="Default select example"
														style="padding: 4px 10px; pointer-events: none; cursor: default;"
														multiple
														<c:if test="${loggedInUser.id == user.id}"><c:out value="readonly='readonly'"/></c:if>>
														<c:forEach items="${assingedRoles}" var="r">
															<option value="${r.value}" selected="true">${r.label}</option>
														</c:forEach>

													</select>
												</div>
										</c:when>
                                        <c:otherwise>
                                        <select name="role"
                                        id="role"
                                        class=" form-control form-control-sm form-select users choices-multiple-remove-button"
                                        placeholder="Select user" multiple <c:if test="${loggedInUser.id == user.id}"><c:out value="readonly='readonly'"/></c:if>>
                                        <c:forEach items="${assingedRoles}" var="r">
                                            <option value="${r.value}" selected="true">${r.label}</option>
                                        </c:forEach>
                                        <c:forEach items="${remainingRoles}" var="r">                                           
										        <option value="${r.value}">${r.label}</option>
                                        </c:forEach>
                                    </select>
                                        </c:otherwise>
                                    </c:choose>

                                </div>
							</div>
							<div class="col-6">
								<div class="mb-3 ">
									<label class="col-form-label  p-0">Status</label><span
										class="mandatory-sign">*</span>
									<c:choose>
										<c:when
											test="${ loggedInUser.id == user.id || 
									loggedInUser.role == 'Project User' ||
									 (loggedInUser.role == 'Project Lead' && user.role == 'Company Admin')}">
											<select class="form-control form-control-sm form-select"
												aria-label="Default select example" name="status"
												id="status"
												<c:if test="${loggedInUser.id == user.id}"><c:out value="readonly='readonly'"/></c:if>>
												<option selected={true} value="${user.status}">${user.status}</option>

											</select>
										</c:when>
										<c:otherwise>
											<select class="form-control form-control-sm form-select"
												aria-label="Default select example" name="status"
												id="status"
												<c:if test="${loggedInUser.id == user.id}"><c:out value="readonly='readonly'"/></c:if>>
												<option selected={true} value="${user.status}">${user.status}</option>
												<c:choose>
													<c:when test="${user.status == 'Active'}">
														<option value="Inactive">Inactive</option>
													</c:when>
													<c:otherwise>
														<option value="Active">Active</option>
													</c:otherwise>
												</c:choose>
											</select>
										</c:otherwise>
									</c:choose>
								</div>
							</div>
							<div class="col-6" style="display: none">
								<div class="mb-3">
									<label class="col-form-label">Role</label> <input type="text"
										class="form-control" value="${user.id}" name="id"
										id="userIdInput">
								</div>
							</div>
						</div>

					</div>

				</div>


			</div>
			<div class="col text-center my-5">
				<c:if test="${loggedInUser.role == 'Super Admin'}">
					<button id="user-cancel" type="reset" color="primary"
						class="btn btn-secondary btn-sm"
						onclick="window.location.href='${pageContext.request.contextPath}/company?pageNo=0'">Cancel</button>
				</c:if>
				<c:if test="${loggedInUser.role != 'Super Admin'}">
					<button id="user-cancel" type="reset" color="primary"
						class="btn btn-secondary btn-sm"
						onclick="window.location.href='${pageContext.request.contextPath}/users?pageNo=0'">Cancel</button>
				</c:if>

				<button id="user-update" type="submit" color="primary"
					class="btn btn-primary Pluck-btn btn-sm" disabled="disabled"
					onClick="return userProfileUpload();">Update</button>
			</div>

		</form>

	</div>
</div>

<script
	src="https://cdn.jsdelivr.net/gh/bbbootstrap/libraries@main/choices.min.js"></script>
<script>
        $(document).ready(function(){
        
    var multipleCancelButton = new Choices('.choices-multiple-remove-button', {
       removeItemButton: true,
       searchResultLimit:5,
       renderChoiceLimit:5
     }); 
    
    var multipleCancelButton1 = new Choices('.choices-multiple-remove-button1', {
        removeItemButton: false,
        searchResultLimit:5,
        renderChoiceLimit:5
      }); 
    
});
        
   
     

    </script>


<script
	src="https://cdnjs.cloudflare.com/ajax/libs/intl-tel-input/17.0.8/js/intlTelInput.min.js"></script>

