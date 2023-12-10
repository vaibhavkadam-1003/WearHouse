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

</head>

<body style="padding-left:0px; background: #f2edf3"  >

	<c:if test="${not empty message}">

		<script type="text/javascript">
			swal({
				position : 'top-end',
				icon : 'success',
				title : "${message}",
				showConfirmButton : false,
			// timer: 1500
			})
		</script>
	</c:if>

	<div   >
		<div class="row  ">

			<div class=" col-4 mx-auto  py-5 px-5">

				<form action="${pageContext.request.contextPath}/forgot-password"
					method="post" id="signUpForm">

					<div class="sign-up-form">
						<div style="background: #f2edf3; padding: 10px; box-shadow: 0 0.12rem 0.35rem rgb(18 38 63/ 15%);">
							<div class="mx-auto text-center rounded">
								<i class=" fa fa-lock fa-2x"></i>
							</div>
							<div class=" mt-2 text-center ">
								<h6 class="text-dark fw-bolder m-0 p-0">Forgot password?</h6>
								<span class="small-text  text-center  m-0 p-0  text-center ">
									You can reset your password here.</span><br/>
								<span class="small-text  text-center  m-0 p-0  text-center ">
									Enter your registered Email address. We'll Email you with a temporary password.</span>
							</div>
						</div>

						<div style="padding: 20px 30px 10px;">
							
							<div class=" " style="padding: 10px 10px;">
							<div class="text-center"><p class="text-danger">${errorMsg}</p></div>
								<div class="mb-2 ">
									<label class="col-form-label">Email</label><span
										class="mandatory-sign">*</span> <input type="email"
										class="form-control form-control-sm"
										placeholder="eg.pluck@veracity-india.com" name="username"
										id="username" required
										onblur="this.value=validateUsername(this,' username ','primaryEmailId1-validation-span-id');">
									<span id="primaryEmailId1-validation-span-id"
										class="validation-span-c"></span>
								</div>

								<div class=" text-center my-4  d-grid ">

									<button type="submit" class="btn btn-primary btn-sm mt-2"
										style="color: #fff; background-color: #337ab7; border-color: #2e6da4;">Reset
										my password</button>
									<small class=" text-center  small-text mt-2"> By
										creating an account you agree to our <a href="#"
										style="color: dodgerblue; font-weight: 500;">Terms &
											Privacy</a>.
									</small>
								</div>

								<div class="text-center">
									<p class=" m-0" style="font-size: 13px;">
										Already have an account ? <a
											href="${pageContext.request.contextPath}/loginForm"
											style="color: dodgerblue; font-weight: 600;">Login here</a>
									</p>
									<p class=" m-0" style="font-size: 13px;">
										Don't have an account ? <a
											href="${pageContext.request.contextPath}/signUp"
											style="color: dodgerblue; font-weight: 600;">Create new
											account</a>
									</p>
									<p class=" mt-3 " style="font-size: 13px;">
										&#169;2023 Pluck. <span style="color: red; font-size: 20px">&hearts;</span>
										Crafted with Veracity Software Pvt. Ltd.
									</p>
								</div>


							</div>

						</div>
					</div>

				</form>

			</div>
		</div>
	</div>
</body>
</html>
