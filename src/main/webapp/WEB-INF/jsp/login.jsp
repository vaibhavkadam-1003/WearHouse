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
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
<link href="https://use.fontawesome.com/releases/v5.7.2/css/all.css"
	rel="stylesheet" />
<link href="${pageContext.request.contextPath}/css/style.css"
	rel="stylesheet" />
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
	<!-- Include Toastr CSS and JS files -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/css/toastr.min.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/js/toastr.min.js"></script>
<style type="text/css">
.mandatory-sign {
	color: red;
}
</style>
</head>
<body style="font-family: 'Poppins', sans-serif;">

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

	<div class="container">
		<div class="row g-0 my-5">
			<div class="col-md-10 mx-auto  my-2" >
				<div class="row g-0 " style="height: 67vh;">
					<div class="col-md-4 login-logo">
						<div class="m-2 p-4">
							<h2 class="mb-3 ">Welcome To Pluck</h2>
							<p >Pluck Software is project management tool used by teams to plan, track, release and support world-class software with confidence. </p>
						</div>
					</div>
					<div class="col-md-8 border" style="background-color:#eef1f7; ">
						<div class="row">
							<div class="col-md-7 mx-auto my-4">
									<div  style="background-color:#fff;  margin: 40px 0px;  padding: 30px 30px; box-shadow: 0 0.12rem 0.35rem rgb(18 38 63/ 15%);">
											<small class="mb-1 welcome-msg"> Welcome to Pluck </small>
											<h2 class="my-2">Log in to Your Account</h2>
											<form action="login" method="post" class="">
														<div class="my-3 ">
														<div class="text-center">
															<span style="color: red; font-size: 1rem;"><b>${errorMsg}</b></span>
														</div>
													
													<div class="mb-3 ">
															<label class="col-form-label">User Name</label><span
																class="mandatory-sign">*</span> <input type="text" required
																class="form-control form-control-sm bg-white" name="userName"
																id="email" placeholder="Enter username" oninvalid="this.setCustomValidity('Please Enter email-Id')"  oninput="setCustomValidity('')">
														</div>

														<div class="mb-3 ">
															<label class="col-form-label">Password</label><span
																class="mandatory-sign">*</span> <input type="password" required
																name="password" class="form-control form-control-sm bg-white"
																id="pwd" placeholder="Password" oninvalid="this.setCustomValidity('Please Enter Password')"  oninput="setCustomValidity('')">
														</div>

														<div class=" text-center mt-4  d-grid ">
															<button type="submit" class="btn mt-3"
																class="btn btn-primary btn-sm mt-2"
																style="background-color: #0052cc; font-size: 0.9rem; color: #fff;">Login</button>

															<small class=" text-center  my-2"> <a href="${pageContext.request.contextPath}/forgotPassword"
																style="color: dodgerblue; font-weight: 500;">Forgot
																	password?</a> or <a
																style="color: dodgerblue; font-weight: 500;"
																href="${pageContext.request.contextPath}/signUp">Sign
																	up</a>
															</small>
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
	</div>


</body>
</html>
