<script src="https://code.jquery.com/jquery-3.6.1.js"
	integrity="sha256-3zlB5s2uwoUzrXK3BT7AX3FyvojsraNFxCc2vC/7pNI="
	crossorigin="anonymous"></script>
<link href="${pageContext.request.contextPath}/css/addCompany.css"
	rel="stylesheet">
<script src="${pageContext.request.contextPath}/js/addCompany.js"></script>
<script src="${pageContext.request.contextPath}/js/common.js"></script>
<script src="${pageContext.request.contextPath}/js/validation.js"></script>

<link href="https://cdnjs.cloudflare.com/ajax/libs/intl-tel-input/17.0.17/css/intlTelInput.css" rel="stylesheet"/>
<link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.0.2/css/bootstrap.min.css" rel="stylesheet"/>
<script src="https://cdnjs.cloudflare.com/ajax/libs/intl-tel-input/17.0.17/js/intlTelInput.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.1.3/js/bootstrap.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.1.3/js/bootstrap.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/intl-tel-input/17.0.17/js/intlTelInput.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>


<jsp:include page="../common/header.jsp"></jsp:include>
<div class="main-content " id="main-content-div">
	<div class="col-md-12" id="column-content-div">
		<div class="row" id="div-content-row">
			<div class="col-md-12 title" id="company-title">
				<h4 id="company-title-text">Add Company</h4>
			</div>
		</div>
		<div class="col-md-12 table-wrapper " id="form-main-div">
			<form action="${pageContext.request.contextPath}/company"
				method="post" class="p-3" onsubmit="return addCompanyValidation()" id="addCompanyForm">
				<h5 class="sub-title" id="sub-title-company">Company Details</h5>
				<div class="row mb-4" id="form-sub-div1">
					<div class="col-md-6 position-relative" id="form-div-name">
						<label class="col-form-label" id="label-name">Name</label> <span id="name-mandatory-sign"
							class="mandatory-sign">*</span><input type="text"
							class="form-control form-control-sm" id="name"
							placeholder="Enter name" name="company.name"
							onblur="this.value=validateCompanyName(this,'name','company-validation-id');"
							required> <span id="company-validation-id"
							class="validation-span-c"></span>
					</div>
					<div class="col-md-3 position-relative" id="form-div-short-name">
						<label class="col-form-label" id="label-short-name">Short Name</label> <input
							type="text" class="form-control form-control-sm" id="shortName"
							onblur="this.value=nameValidate(this,'shortName-validation-id');"
							placeholder="Enter short name" name="company.shortName">
							<span id="shortName-validation-id"
							class="validation-span-c"></span>
					</div>
					<div class="col-md-3 position-relative" id="form-div-website">
						<label class="col-form-label" id="label-website">Website</label> <input type="url"
							class="form-control form-control-sm" id="website"
							placeholder="Enter website" name="company.website"
							onblur="this.value=validateWebsite(this,'Website','website-validation-span-id');" />
						<span id="website-validation-span-id" class="validation-span-c"></span>
					</div>
				</div>
				
				<div class="row mb-4">
					<div class="col-md-3">
						<label class="col-form-label">Work Phone </label> <span
							class="mandatory-sign">*</span> <br /> <input id="countryCode2"
							type="text" name="Contact" value=" "
							class="form-control form-control-sm w-100" /> <span
							id="primaryPhone1-validation-span-id" class="validation-span-c"></span>
					</div>
					
					<div class="col-md-3 ">
						<label class="col-form-label">Alternate Work Phone </label> <br />
						<input id="countryCode3" type="text" name="Contact" value=" "
							class="form-control form-control-sm w-100" /> <span
							id="primaryPhone1-validation-span-id" class="validation-span-c"></span>
					</div>


					<div class="col-md-3 d-none"  >
						<label class="col-form-label" id="label-workphone"> </label><span
							class="mandatory-sign" id="workphone-mandatory-sign"></span> <input
							type="hidden" class="form-control form-control-sm" id="contact"
							placeholder="Enter work phone" name="company.workPhone"
							onblur="this.value=validatePhone(this,'primaryPhone-validation-span-id');"
							required /> <span id="primaryPhone-validation-span-id"
							class="validation-span-c"></span>
					</div>

					<div class="col-md-3 d-none"  >
						<label class="col-form-label" id="label-workphone">
							</label> <input type="hidden"class="form-control form-control-sm"
							id="countryCodeForWorkPhone" placeholder="Enter work phone"
							name="company.countryCodeForWorkPhone" />
					</div>
					
					<div class="col-md-3 position-relative" id="form-div-emailId">
						<label class="col-form-label" id="label-emailId">Email ID</label><span
							class="mandatory-sign" id="emailId-mandatory-sign">*</span> <input
							type="email" class="form-control form-control-sm" id="email"
							placeholder="Enter email" name="company.emailId"
							onblur="this.value=validateUsername(this,' email ','primaryEmailId-validation-span-id');"
							required> <span id="primaryEmailId-validation-span-id"
							class="validation-span-c"></span>
					</div>
					<div class="col-md-3 position-relative"
						id="form-div-alternate-emailId">
						<label class="col-form-label" id="label-alternate-email-id">Alternate
							Email ID</label> <input type="email" class="form-control form-control-sm"
							id="alternate-email" placeholder="Enter alternate email"
							name="company.alternateMailId"
							onblur="this.value=validateSecondaryEmail(this,'email','secondaryEmail-validation-span-id');">
						<span id="secondaryEmail-validation-span-id"
							class="validation-span-c"></span>
					</div>
					
				</div>
				
				
				<div class="row mb-4" >
					
					
					

					

					<div class="col-6 d-none">
						<div class="col-md-3 position-relative"
							id="form-div-alternate-workphone">
							<label class="col-form-label" id="label-alternate-workphone">Alternate
								Phone</label> <input type="text" class="form-control form-control-sm"
								id="alternatePhone" placeholder="Enter alternate work phone"
								name="company.alternatePhone" />

						</div>

						<div class="col-md-3 position-relative"
							id="form-div-alternate-workphone">
							<label class="col-form-label" id="label-alternate-workphone">Alternate
								country code</label> <input type="text"
								class="form-control form-control-sm"
								id="countryCodeForAlternatePhone"
								placeholder="Enter alternate work phone"
								name="company.countryCodeForAlternatePhone" />

						</div>
					</div>

					
				</div>

				<div class="row " id="form-div-select">
					<div class="col-md-6 position-relative" id="form-div-plan-type">
						<label class="col-form-label" id="label-plan-type">Subscription Type</label><span id="sub-type-mandatory-sign"
							class="mandatory-sign">*</span> <select
							class="form-select form-select-sm form-control form-control-sm"
							name="company.subscriptionType" id="subscriptionType">
							<option value="" selected disabled>Select Plan Type</option>
							<option value="basic">Basic</option>
							<option value="advance">Advance</option>
							<option value="ultimate">Ultimate</option>
						</select> <span class="error-message-text-color" id="subscriptiontype_error_message"></span>
					</div>
					<div class="col-md-6 position-relative" id="form-div-plan">
						<label class="col-form-label" id="label-subscription-plan">Subscription Plan</label><span id="sub-plan-mandatory-sign"
							class="mandatory-sign">*</span> <select
							name="company.subscriptionPlan"
							class="form-select form-select-sm form-control form-control-sm"
							id="subscriptionPlan">
							<option value="" selected disabled>Select Plan</option>
							<option value="10">1-10 Users</option>
							<option value="20">11-20 Users</option>
						</select> <span class="error-message-text-color" id="subscriptionplan_error_message"></span>
					</div>

				</div>

				<h5 class="sub-title mt-4 pt-3" id="admin-title">Company Admin Information</h5>
				<div class="row mb-4" id="sub-div-admin">
					<div class="col-md-3 position-relative" id="form-div-first-name">
						<label class="col-form-label" id="label-first-name">First Name</label><span id="firstName-mandatory-sign"
							class="mandatory-sign">*</span> <input type="text"
							class="form-control form-control-sm" id="firstName"
							placeholder="Enter first name" name="admin.firstName"
							onblur="this.value=nameValidate(this,'firstName-validation-id');"
							required> <span id="firstName-validation-id"
							class="validation-span-c"></span>
					</div>
					<div class="col-md-3 position-relative" id="form-div-last-name">
						<label class="col-form-label" id="label-last-name">Last Name</label><span id="lastName-mandatory-sign"
							class="mandatory-sign">*</span> <input type="text"
							class="form-control form-control-sm" id="lastName"
							placeholder="Enter last name" name="admin.lastName"
							onblur="this.value=nameValidate(this,'lastName-validation-id');"
							required> <span id="lastName-validation-id"
							class="validation-span-c"></span>
					</div>

					<div class="col-md-3 position-relative" id="form-div-username">
						<label class="col-form-label" id="label-username">Username</label><span id="username-mandatory-sign"
							class="mandatory-sign">*</span> <input type="email"
							class="form-control form-control-sm" id="username"
							placeholder="Enter username" name="admin.username"
							onblur="this.value=validateUsername(this,' username ','primaryEmailId1-validation-span-id');"
							required> <span id="primaryEmailId1-validation-span-id"
							class="validation-span-c"></span>
					</div>

					<div class="col-md-3 " >
						<label class="col-form-label">Contact Number </label> <span
							class="mandatory-sign">*</span> <br /> <input id="countryCode"
							type="text" name="Contact" value=" "
							class="form-control form-control-sm w-100" /> <span
							id="primaryPhone1-validation-span-id" class="validation-span-c"></span>
					</div>

					<div class="col-6 d-none">
						<div class="col-md-3 position-relative" id="form-div-contact">
							<label class="col-form-label" id="label-contact">Contact</label>
							<span id="contact-mandatory-sign" class="mandatory-sign">*</span><input
								type="hidden" class="form-control form-control-sm"
								id="contactNumber" placeholder="Enter contact"
								name="admin.contactNumber"
								onblur="this.value=validatePhone(this,'primaryPhone1-validation-span-id');"
								required /> <span id="primaryPhone1-validation-span-id"
								class="validation-span-c"></span>
						</div>

						<div class="col-md-3 position-relative" id="form-div-contact">
							<label class="col-form-label" id="label-contact"></label> <input
								 type="hidden" class="form-control form-control-sm"
								id="countryCode1" placeholder="Enter contact"
								name="admin.countryCode" />
						</div>
					</div>
				</div>

				<div class="row mt-5" id="form-div-submit">
						<div class="col text-center " id="form-div-sub-submit">
							<button type="button" id="button-cancel"
								class="btn btn-secondary btn-sm"
								onclick="window.location.href='${pageContext.request.contextPath}/company?pageNo=0'">Cancel</button>
							<button type="submit"
								class="btn btn-primary Pluck-btn btn-sm"
								id="register" disabled="disabled">Add</button>
							<span id="submit-error"></span>
						</div>
					</div>
			</form>
		</div>

	</div>
</div>
<!-- Phone no js -->
 <script src="https://cdnjs.cloudflare.com/ajax/libs/intl-tel-input/17.0.8/js/intlTelInput.min.js"></script>