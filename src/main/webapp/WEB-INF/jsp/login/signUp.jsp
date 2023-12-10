<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
<title>Sign In</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css"
	rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.6.1.js"
	integrity="sha256-3zlB5s2uwoUzrXK3BT7AX3FyvojsraNFxCc2vC/7pNI="
	crossorigin="anonymous"></script>
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
<link href="${pageContext.request.contextPath}/css/style.css"
	rel="stylesheet" />
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.1/css/all.min.css">
<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
<link rel='stylesheet'
	href='https://cdn.jsdelivr.net/npm/sweetalert2@7.12.15/dist/sweetalert2.min.css'></link>

<script src="${pageContext.request.contextPath}/js/signUp.js"></script>
<script src="${pageContext.request.contextPath}/js/common.js"></script>
<script src="${pageContext.request.contextPath}/js/validation.js"></script>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/css/toastr.min.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/js/toastr.min.js"></script>

<script src="https://code.jquery.com/jquery-3.6.1.js"
	integrity="sha256-3zlB5s2uwoUzrXK3BT7AX3FyvojsraNFxCc2vC/7pNI="
	crossorigin="anonymous"></script>
	
<link
     rel="stylesheet"
     href="https://cdnjs.cloudflare.com/ajax/libs/intl-tel-input/17.0.8/css/intlTelInput.css"
   />
   
</head>

<body style="font-family: 'Poppins', sans-serif; margin-top: 20px;">

	<c:if test="${not empty successMessage || not empty errorMessage}">

		<script type="text/javascript">
			var successMessage = "${successMessage}";
	        if (successMessage) {
	            toastr.success(successMessage);
	        }
	
	        var errorMessage = "${errorMessage}";
	        if (errorMessage) {
	            toastr.error(errorMessage);
	        }		
        </script>

	</c:if>

	<div>
		<div class="container">
			<div class="row">
				<div class="col-md-4 mx-auto ">
					<form action="${pageContext.request.contextPath}/sign-up"
						method="post" id="signUpForm">
						<div class="sign-up-form">
							<div
								style="background-color: #e6effc; padding: 10px; box-shadow: 0 0.12rem 0.35rem rgb(18 38 63/ 15%);">
								<div class="mx-auto text-center rounded">
									<img alt="logo" src="${pageContext.request.contextPath}/images/images.png"
										class="sign-up-logo rounded-circle">
								</div>
								<div class=" mt-2 text-center ">
									<h6 class="text-dark fw-bolder m-0 p-0">Sign up</h6>
									<span class="small-text  text-center  m-0 p-0  text-center ">Create
										an account it's Free.</span>
								</div>
							</div>

							<div style="padding: 20px 20px;">
								<div class="mb-2 ">
									<label class="col-form-label">First Name</label><span
										class="mandatory-sign">*</span> <input type="text"
										class="form-control form-control-sm" placeholder="eg.John"
										name="firstName" id="firstName" required
										onblur="this.value=nameValidate(this,'firstName-validation-id');">
									<span id="firstName-validation-id" class="validation-span-c"></span>
								</div>

								<div class="mb-2 ">
									<label class="col-form-label">Last Name</label><span
										class="mandatory-sign">*</span> <input type="text"
										class="form-control form-control-sm" placeholder="eg.Carten"
										name="lastName" id="lastName" required
										onblur="this.value=nameValidate(this,'lastName-validation-id');">
									<span id="lastName-validation-id" class="validation-span-c"></span>
								</div>


								<div class="mb-2 ">
									<label class="col-form-label">Username</label><span
										class="mandatory-sign">*</span> <input type="email"
										class="form-control form-control-sm"
										placeholder="eg.pluck@veracity-india.com" name="username"
										id="username" required
										onblur="this.value=validateUsername(this,' username ','primaryEmailId1-validation-span-id');">
									<span id="primaryEmailId1-validation-span-id"
										class="validation-span-c"></span>
								</div>

								<div class="mb-2 ">
									<label class="col-form-label">Company ID</label><span
										class="mandatory-sign">*</span> <input type="text"
										class="form-control form-control-sm" placeholder="eg.-1"
										name="companyId" id="companyId" required onblur="this.value=validateCompanyID(this,'companyID-validation-id');">
										<span id="companyID-validation-id"
										class="validation-span-c"></span>
								</div>

								<div class="mb-2">
									<div class="mb-3">
										<label class="col-form-label">Contact Number</label> <span
											class="mandatory-sign">*</span><br> <input
											id="countryCode" type="text" name="Contact" value=" "
											class="form-control form-control-sm w-100" required="required"> <span
											id="primaryPhone1-validation-span-id"
											class="validation-span-c"></span>
									</div>
									<div class="col-6 d-none">
										<div class="mb-3">
											<input id="contactNumber" type="text" name="contactNumber"
												value=" number" class="form-control form-control-sm"
												onblur="this.value=validatePhone(this,'primaryPhone1-validation-span-id');" required="required">
											<span id="primaryPhone1-validation-span-id"
												class="validation-span-c"></span>
										</div>
									</div>
								</div>

								<div class="col-6 d-none">
									<div class="mb-3">
										<input id="countryCode1" type="text" name="countryCode"
											value="RemoveNumber" class="form-control form-control-sm" required="required">
										<span id="primaryPhone1-validation-span-id"
											class="validation-span-c"></span>
									</div>
								</div>

								<div class=" text-center mt-4  d-grid ">

									<button type="submit" color="primary"
										class="btn btn-primary btn-sm mt-2"
										style="background-color: #0052cc;" id="signUp-add"
										disabled="disabled">Register</button>
									<small class=" text-center  small-text mt-2"> By
										creating an account you agree to our <a href="#"
										style="color: dodgerblue; font-weight: 500;">Terms &
											Privacy</a>.
									</small>
								</div>
							</div>
						</div>
					</form>
				</div>
				<div class="text-center mt-2">
					<small>Already have an account ? <a
						href="${pageContext.request.contextPath}/loginForm"
						style="color: dodgerblue; font-weight: 500;">Login</a></small>
					<p class=" mt-2">&#169;2023 Pluck. Crafted with Veracity Software
						Pvt. Ltd.</p>
				</div>
			</div>
		</div>
	</div>

</body>
<!-- Phone no js -->
 <script src="https://cdnjs.cloudflare.com/ajax/libs/intl-tel-input/17.0.8/js/intlTelInput.min.js"></script>
</html>
