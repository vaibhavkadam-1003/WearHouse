<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<script src="https://code.jquery.com/jquery-3.6.1.js"
	integrity="sha256-3zlB5s2uwoUzrXK3BT7AX3FyvojsraNFxCc2vC/7pNI="
	crossorigin="anonymous"></script>
<link href="${pageContext.request.contextPath}/css/addCompany.css"
	rel="stylesheet">

<jsp:include page="../common/header.jsp"></jsp:include>

<%
if (session.getAttribute("username") == null) {
	response.sendRedirect("/login");
}
%>
<div class="main-content ">
	<div class="col-md-12">
		<div class="row">
			<div class="col-md-12 title">
				<h4>SMTP Settings</h4>
			</div>
		</div>
		<form action="${pageContext.request.contextPath}/smtp" method="post" name="addSmtpSettingsForm">
			<div class="my-4">
				<div class="row">
				
				<div class="col-6">
						<div class="mb-3">
							<label class="col-form-label">Email ID</label> <input
								type="email" class="form-control form-control-sm"
								placeholder="eg.pluck@veracity-india.com"
								name="mailId" id="emailId" value="${smtp.mailId}"
								onblur="this.value=validateSecondaryEmail(this,'email','secondaryEmail-validation-span-id');">
							<span id="email-validation-span-id"
								class="validation-span-c"></span>
						</div>
					</div>
					
				</div>
				<div class="row">
				<div class="col-6">
						<div class="mb-3 ">
							<label class="col-form-label">Password</label> <input type="password"
								class="form-control form-control-sm" 
								name="password" id="password"  value="${smtp.password }"/>
							<span id="password-validation-id" class="validation-span-c"></span>
						</div>
					</div>
					<div class="col-6">
						<div class="mb-3 ">
							<label class="col-form-label">Authentication
								Enabled</label><span class="mandatory-sign">*</span> <input type="checkbox"
								 name="authenticationEnabled"
								id="authenticationEnabled" checked="${smtp.authenticationEnabled }"> <span id="authentication-validation-id"
								class="validation-span-c"></span>
						</div>

					</div>

				</div>
				<div class="row">
					
					<div class="col-6">
						<div class="mb-3 ">
							<label class="col-form-label">SMTP Host</label> <span
								class="mandatory-sign">*</span><input type="text"
								class="form-control form-control-sm" id="smtpHost"
								placeholder="eg. Smtp.gmail.com" name="smtpHost" value="${smtp.smtpHost }"
								required> <span id="smtpHost-validation-span-id"
								class="validation-span-c"></span>
						</div>
					</div>
					
					<div class="col-6">
						<div class="mb-3">
							<label class="col-form-label">Enabled</label><span
								class="mandatory-sign">*</span> <input type="checkbox"
								name="enabled" id="enabled" checked="${smtp.enabled}">
							<span id="enabled-validation-span-id"
								class="validation-span-c"></span>
						</div>
					</div>
				</div>
				
				<div class="row">
					<div class="col-6">
						<div class="mb-3 ">
							<label class="col-form-label">SMTP Port</label> <input type="number"
								class="form-control form-control-sm"  placeholder="8080"
								name="smtpPort" id="smtpPort" value="${smtp.smtpPort }"/>
							<span id="smtpPort-validation-id" class="validation-span-c"></span>
						</div>
					</div>
					
					<div class="col-6">
						<div class="mb-3 ">
							<label class="col-form-label">Tls Enabled</label> <span
								class="mandatory-sign">*</span> <input type="checkbox"
								id="tlsEnabled" name="tlsEnabled" checked="${smtp.tlsEnabled}"> 
								<span id="tlsEnabled-validation-span-id"
								class="validation-span-c"></span>
						</div>
					</div>
						 <input type="hidden" class="form-control" value="${smtp.id}" name="id">
				</div>
				
				<div class="col text-center my-4">
					<button id="smtp-cancel" type="reset" color="primary" class="btn btn-secondary btn-sm" onclick="window.location.href='${pageContext.request.contextPath}/smtp/all/smtp'">Cancel</button>
					<button id="smtp-add" type="submit" color="primary" class="btn btn-primary Pluck-btn btn-sm">Submit</button>
				</div>
				
			</div>
		</form>
	</div>
</div>
