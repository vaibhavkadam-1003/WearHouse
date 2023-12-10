<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<script src="https://code.jquery.com/jquery-3.6.1.js"
	integrity="sha256-3zlB5s2uwoUzrXK3BT7AX3FyvojsraNFxCc2vC/7pNI="
	crossorigin="anonymous"></script>
<script src="${pageContext.request.contextPath}/js/updateCompany.js"></script>
<script src="${pageContext.request.contextPath}/js/validation.js"></script>
<script src="${pageContext.request.contextPath}/js/common.js"></script>
<link href="${pageContext.request.contextPath}/css/addCompany.css"
	rel="stylesheet">
	
	<link href="https://cdnjs.cloudflare.com/ajax/libs/intl-tel-input/17.0.17/css/intlTelInput.css" rel="stylesheet"/>
<link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.0.2/css/bootstrap.min.css" rel="stylesheet"/>
<script src="https://cdnjs.cloudflare.com/ajax/libs/intl-tel-input/17.0.17/js/intlTelInput.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.1.3/js/bootstrap.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.1.3/js/bootstrap.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/intl-tel-input/17.0.17/js/intlTelInput.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>

 
<jsp:include page="../common/header.jsp"></jsp:include>

<div class="main-content height-100 " id="main-div-content">
	<div class="col-md-12" id="main-column-div">
		<div class="row" id="heading-div-title">
			<div class="col-md-12 title" id="update-company-title-div">
				<h4 id="update-company-title">Update Company</h4>
			</div>
		</div>

		<div class="col-md-12 table-wrapper " id="form-update-div">
			<form action="${pageContext.request.contextPath}/company/update"
				method="post" onsubmit="return updateCompanyValidation()" id="updtateCompanyForm">
				<div class="row my-4" id="row-div-name">
					<div class="col-md-6 " id="col-div-name">
						<label class="col-form-label" id="label-company-name">Name</label><span class="mandatory-sign">*</span> <input
							type="text" class="form-control form-control-sm" id="name1"
							placeholder="Enter name" name="company.name"
							value="${company.name}"
							onblur="this.value=validateCompanyName(this,'name','company-validation-id');"
								onsubmit="this.value=validateCompanyName(this,'name','company-validation-id');"
							required <c:if test="${company.status == 'Inactive'}"><c:out value="readonly='readonly'" /></c:if>> <span id="company-validation-id"
							class="validation-span-c"></span>
					</div>
					<div class="col-md-6 " id="col-div-short-name">
						<label class="col-form-label" id="label-company-short-name">Short Name</label> <input type="text" class="form-control form-control-sm"
							id="shortName" placeholder="Enter short name"
							name="company.shortName" value="${company.shortName}"
							onblur="this.value=nameValidate(this,'shortName-validation-id');"
							 <c:if test="${company.status == 'Inactive'}"><c:out value="readonly='readonly'" /></c:if>>
							 <span id="shortName-validation-id"
							class="validation-span-c"></span>
					</div>
				</div>

				<div class="row mb-4" id="row-div-middle">
				
				<div class="col-md-3 mb-3 ">
					<label class="col-form-label">Work Phone</label> <span
						class="mandatory-sign">*</span><br /> <input id="countryCode1"
						type="text" name="countryCode1" value=" "
						class="form-control form-control-sm w-100" /> <span
						id="primaryPhone1-validation-span-id" class="validation-span-c"></span>
				</div>
				
				<div class=" col-md-3 mb-3 ">
					<label class="col-form-label">Alternate Work Phone</label> <br /> <input id="countryCode2"
						type="text" name="countryCode2" value=" "
						class="form-control form-control-sm w-100" /> <span
						id="AlternateWorkPhone1-validation-span-id" class="validation-span-c"></span>
				</div>
				
				
					<div class="col-md-3 d-none " id="col-div-workphone">
						<label class="col-form-label" id="label-company-workphone"> Phone</label> <span class="mandatory-sign">*</span> <input
							type="text" class="form-control form-control-sm"  id="contact"
							placeholder="Enter work phone" name="company.workPhone"
							value="${company.workPhone}"
							onblur="this.value=validatePhone(this,'primaryPhone-validation-span-id');"
							required 
							 <c:if test="${company.status == 'Inactive'}"><c:out value="readonly='readonly'" /></c:if>/> <span id="primaryPhone-validation-span-id"
							class="validation-span-c"></span>
					</div>
					
					<div class="col-md-3 d-none" id="col-div-workphone">
						<label class="col-form-label" id="label-company-workphone">code</label> <span class="mandatory-sign">*</span> <input
							type="text" class="form-control form-control-sm"  id="countryCode"
							placeholder="Enter work phone" name="company.countryCodeForWorkPhone"
							value="${company.countryCodeForWorkPhone}"
							 <c:if test="${company.status == 'Inactive'}"><c:out value="readonly='readonly'" /></c:if>/> <span id="primaryPhone-validation-span-id"
							class="validation-span-c"></span>
					</div>
					
					 
					
					<div class="col-md-3 d-none" id="col-div-alternate-workphone">
						<label class="col-form-label" id="label-company-alternate-workphone">Alternate Phone</label> <input type="text"
							class="form-control form-control-sm"  id="alternatePhone"
							placeholder="Enter alternate work phone"
							name="company.alternatePhone" value="${company.alternatePhone}"
							 <c:if test="${company.status == 'Inactive'}"><c:out value="readonly='readonly'" /></c:if>
							/>
						<span id="secondaryPhone-validation-span-id"
							class="validation-span-c error-message-text-color"></span>
					</div>
					
					<div class="col-md-3 d-none" id="col-div-workphone">
						<label class="col-form-label" id="label-company-workphone">alternate code</label> <span class="mandatory-sign">*</span> <input
							type="text" class="form-control form-control-sm"  id="countryCode3"
							placeholder="Enter work phone" name="company.countryCodeForAlternatePhone"
							value="${company.countryCodeForAlternatePhone}"
							 <c:if test="${company.status == 'Inactive'}"><c:out value="readonly='readonly'" /></c:if>/> <span id="primaryPhone-validation-span-id"
							class="validation-span-c"></span>
					</div>
					
					<div class="col-md-3 " id="col-div-emailId">
						<label class="col-form-label" id="label-company-emailId">Email ID</label> <span class="mandatory-sign">*</span> <input
							type="email" class="form-control form-control-sm"  id="email" readonly="readonly"
							placeholder="Enter emailId" name="company.emailId"
							value="${company.emailId}"
							onblur="this.value=validateEmail(this,'Email ID','primaryEmailId-validation-span-id');"
							required
							<c:if test="${company.status == 'Inactive'}"><c:out value="readonly='readonly'" /></c:if>> <span id="primaryEmailId-validation-span-id"
							class="validation-span-c"></span>
					</div>
					<div class="col-md-3 " id="col-div-alternate-emailId">
						<label class="col-form-label" id="label-company-alternate-emailId">Alternate Email ID</label> <input type="email"
							class="form-control form-control-sm"  id="alternateEmail"
							placeholder="Enter alternate email"
							name="company.alternateMailId" value="${company.alternateMailId}"
							onblur="this.value=validateSecondaryEmail(this,'email','secondaryEmail-validation-span-id');"
							<c:if test="${company.status == 'Inactive'}"><c:out value="readonly='readonly'" /></c:if>>
						<span id="secondaryEmail-validation-span-id"
							class="validation-span-c"></span>
					</div>
				</div>

				<div class="row mb-4" id="div-row-end">
					<div class="col-md-3 " id="col-div-website">
						<label class="col-form-label" id="label-company-website">Website</label> <input type="url" class="form-control form-control-sm"
							id="website" placeholder="Enter website" name="company.website"
							value="${company.website}"
							onblur="this.value=validateWebsite(this,'Website','website-validation-span-id');" 
							<c:if test="${company.status == 'Inactive'}"><c:out value="readonly='readonly'" /></c:if>/>
						<span id="website-validation-span-id" class="validation-span-c"></span>
					</div>
					<div class="col-md-3 " id="col-div-type">
						<label class="col-form-label" id="label-company-type">Subscription Type</label> <span class="mandatory-sign">*</span>
						<select class="form-select form-select-sm  form-control form-control-sm"
							name="company.subscriptionType" id="subscription_type"
							value="${company.subscriptionType}" <c:if test="${company.status == 'Inactive'}"><c:out value="readonly='readonly'" /></c:if>>
							<option selected style="text-transform: capitalize">${fn:toUpperCase(fn:substring((company.subscriptionType),0, 1))}${fn:toLowerCase(fn:substring((company.subscriptionType),1,fn:length(company.subscriptionType)))}</option>
							<c:if test="${company.status != 'Inactive'}">
							<c:choose>
								<c:when test="${company.subscriptionType=='basic'}">
									<option value="advance">Advance</option>
									<option value="ultimate">Ultimate</option>
								</c:when>
								<c:otherwise>
									<c:choose>
										<c:when test="${company.subscriptionType=='advance'}">
											<option value="basic">Basic</option>
											<option value="ultimate">Ultimate</option>
										</c:when>
										<c:otherwise>
											<c:choose>
												<c:when test="${company.subscriptionType=='ultimate'}">
													<option value="basic">Basic</option>
													<option value="advance">Advance</option>
												</c:when>
											</c:choose>
										</c:otherwise>
									</c:choose>
								</c:otherwise>
							</c:choose>
							</c:if>
						</select>
					</div>
					<div class="col-md-3 " id="col-div-plan">
						<label class="col-form-label" id="label-company-plan">Subscription Plan</label> <span class="mandatory-sign">*</span>
						<select name="company.subscriptionPlan" class="form-control form-select" value="${company.subscriptionPlan}"
						<c:if test="${company.status == 'Inactive'}"><c:out value="readonly='readonly'" /></c:if>>
								<option selected>${company.subscriptionPlan}</option>
								 <c:if test="${company.status != 'Inactive'}">
								<c:choose>
									<c:when test="${company.subscriptionPlan=='1-10 Users'}">
										<option value="11-20 Users">11-20 Users</option>
									</c:when>
									<c:otherwise>
										<option value="1-10 Users">1-10 Users</option>
									</c:otherwise>
								</c:choose>
								</c:if>
							</select>
					</div>
					<div class="col-md-3 " id="col-div-status">
						<label class="col-form-label" id="label-company-status">Status</label> <span
							class="mandatory-sign">*</span> <select class="form-select form-select-sm  form-control form-control-sm"
							name="company.status" value="${company.status}" id="status">
							<option selected>${company.status}</option>
							<c:choose>
								<c:when test="${company.status=='Active'}">
									<option value="Inactive">Inactive</option>
								</c:when>
								<c:otherwise>
									<option value="Active">Active</option>
								</c:otherwise>
							</c:choose>
						</select>
					</div>
				</div>
				
				<div class="row">
					<div class="col">
						<div>
							<div class="mb-3 mt-3" style="display: none;">
								<label for="email">Id</label> <input type="text"
									class="form-control" id="id" placeholder="Enter status"
									name="company.id" value="${company.id}">
							</div>
							<div class="mb-3 mt-3" style="display: none;">
								<label for="email">Id</label> <input type="text"
									class="form-control" id="maxUsers" placeholder="Enter status"
									name="company.maxUsers" value="${company.maxUsers}">
							</div>
							<div class="mb-3 mt-3" style="display: none;">
								<label for="email">Rate</label> <input type="text"
									class="form-control" id="subscriptionRate"
									placeholder="Enter status" name="company.subscriptionRate"
									value="${company.subscriptionRate}">
							</div>
						</div>
					</div>
				</div>
				<div class="row my-5" id="div-row-submit">
					<div class="col text-center my-4" id="div-col-submit">
						<button type="button"
							class="btn btn-secondary btn-sm"
							onclick="window.history.back()" id="update-cancel">Cancel</button>
						<button type="submit"
							class="btn btn-primary Pluck-btn btn-sm"
							id="register" disabled={disableBtn}>Update</button>
					</div>
				</div>
			</form>
		</div>

	</div>
</div>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/intl-tel-input/17.0.8/js/intlTelInput.min.js"></script>