<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="com.pluck.dto.LoginUserDto"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link href="${pageContext.request.contextPath}/css/changePassword.css"
	rel="stylesheet">

<script>
	$(document)
			.ready(
					function() {
						$('#newPassword')
								.on(
										'input',
										function() {
											var password = $(this).val();

											// Define regular expressions for each requirement
											var regexCapital = /[A-Z]/;
											var regexSmall = /[a-z]/;
											var regexSpecial = /[!@#$%^&*()_+{}\[\]:;<>,.?~\\/-]/;
											var regexNumber = /[0-9]/;

											// Check password length and individual requirements
											var isLengthValid = password.length >= 8;
											var isCapitalValid = regexCapital
													.test(password);
											var isSmallValid = regexSmall
													.test(password);
											var isSpecialValid = regexSpecial
													.test(password);
											var isNumberValid = regexNumber
													.test(password);

											// Update the UI based on validation results
											$('#lengthCheck').text(
													isLengthValid ? '✅' : '❌');
											$('#capitalCheck').text(
													isCapitalValid ? '✅' : '❌');
											$('#smallCheck').text(
													isSmallValid ? '✅' : '❌');
											$('#specialCheck').text(
													isSpecialValid ? '✅' : '❌');
											$('#numberCheck').text(
													isNumberValid ? '✅' : '❌');

											// Enable or disable the submit button based on overall validation
											var isFormValid = isLengthValid
													&& isCapitalValid
													&& isSmallValid
													&& isSpecialValid
													&& isNumberValid;
											$('#submitButton').prop('disabled',
													!isFormValid);
										});
					});
</script>

<body>

	<jsp:include page="../common/header.jsp"></jsp:include>

	<div class="mainDiv">
		<div class="cardStyle">
			<form action="${pageContext.request.contextPath}/change-password" method="post"
				name="changePasswordForm" id="changePasswordForm">

				<h6 class="formTitle" style="color: #556ee6">Reset password</h6>

				<div class="inputDiv">
					<label class="inputLabel" for="password">Old password <span
						class="mandatory-sign">*</span></label> <input type="password"
						id="oldPassword" name="oldPassword" required>
				</div>

				<div class="inputDiv">
					<label class="inputLabel" for="password">New password <span
						class="mandatory-sign">*</span></label> <input type="password"
						id="newPassword" name="newPassword" required>
				</div>

				<div class="inputDiv">
					<label class="inputLabel" for="confirmPassword">Confirm
						password <span class="mandatory-sign">*</span>
					</label> <input type="password" id="confirmPassword" name="confirmPassword">
				</div>

				<div class="w-50 mx-auto my-3">
					<div class="  mb-2 fw-bold">Password Requirements:</div>
				<div class="  mb-2  form-text"> Length (8 characters): <span id="lengthCheck">❌</span>
				</div>
				<div class="  mb-2  form-text"> At least 1 Capital Letter: <span id="capitalCheck">❌</span>
				</div>
				<div class="  mb-2  form-text"> At least 1 Small Letter: <span id="smallCheck">❌</span>
				</div>
				<div class="  mb-2  form-text"> At least 1 Special Symbol: <span id="specialCheck">❌</span>
				</div>
				<div class="  mb-2  form-text"> At least 1 Number: <span id="numberCheck">❌</span>
				</div>
				</div>

				<div class="buttonWrapper">
					<button type="submit" id="submitButton"
						onclick="validateChangePasswordForm()"
						class="submitButton pure-button pure-button-primary" style="border: none">
						<span>Continue</span> <span id="loader"></span>
					</button>
				</div>

			</form>
		</div>
	</div>
</body>

<script src="${pageContext.request.contextPath}/js/changePassword.js"></script>
<jsp:include page="../common/footer.jsp"></jsp:include>