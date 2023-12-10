<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<script src="https://code.jquery.com/jquery-3.6.1.js"
	integrity="sha256-3zlB5s2uwoUzrXK3BT7AX3FyvojsraNFxCc2vC/7pNI="
	crossorigin="anonymous"></script>
<link href="${pageContext.request.contextPath}/css/company.css"
	rel="stylesheet">
<script src="${pageContext.request.contextPath}/js/addCompany.js"></script>
<script src="${pageContext.request.contextPath}/js/common.js"></script>
<script src="${pageContext.request.contextPath}/js/validation.js"></script>
<jsp:include page="../common/header.jsp"></jsp:include>

<div class="main-content ">
	<div class="container-fuild">

		<div class="row">
			<div class="col-md-3">
				<div class="card" style="height: 85vh !important;">
					<div class="my-4 text-center">
						<img src="${pageContext.request.contextPath}/images/companyLogo.png"
							class="card-img-top rounded-circle w-50" alt="...">
					</div>
					<div class="card-body text-center">
						<h3 class="card-title">
							<a class="details-title"
								href="${pageContext.request.contextPath}/company/update/form/${data.company.id}">
								${data.company.name }</a>
						</h3>
						<small> ${data.company.website } </small>
						<p class="card-text mt-3 fw-bold">Company Description some quick
							example text to build on the card title and make up the bulk of
							the card's content. Some quick example text to build on the card
							title and make up the bulk of the card's content.</p>
						
					</div>
				</div>
			</div>

			<div class="col-md-9">
				<div class="card">
					<div class="col-md-12 title py-2 px-3 bg-light">
						<div class="d-flex justify-content-between align-items-start">
							<h5 class="mt-2">Basic information about
								${data.company.name }</h5>
							<c:choose>
								<c:when test="${data.company.status == 'Active' }">
									<button type="button"
										class="badge badge-soft-primary fs-6 mt-1 px-3 py-2">${data.company.status}
									</button>

								</c:when>
								<c:otherwise>
									<button type="button"
										style="color: #e65555; font-size: 0.7rem; border: 1px solid rgb(230 85 85/ 40%);"
										class="badge fs-6 mt-1 px-3 py-2">${data.company.status}
									</button>
								</c:otherwise>
							</c:choose>

						</div>
					</div>

					<div class="card-body text-center">
						<div class="row  pb-2">
							<div class="col-md-4">
								<ul class="list-group list-group-numbered">
									<li
										class="list-group-item d-flex justify-content-between align-items-start  border-0">
										<div class="ms-2 me-auto text-start">
											Email
											<div class="fw-bold text-start  fs-6 pt-2">${data.company.emailId }
											</div>
										</div>
									</li>
								</ul>
							</div>

							<div class="col-md-4">
								<ul class="list-group list-group-numbered">
									<li
										class="list-group-item d-flex justify-content-between align-items-start  border-0">
										<div class="ms-2 me-auto text-start">
											Short Name
											<div class="fw-bold text-start  fs-6 pt-2">${data.company.shortName }
											</div>
										</div>
									</li>
								</ul>
							</div>

							<div class="col-md-4">
								<ul class="list-group list-group-numbered">
									<li
										class="list-group-item d-flex justify-content-between align-items-start  border-0">
										<div class="ms-2 me-auto text-start">
											Contact
											<div class="fw-bold text-start  fs-6 pt-2">${data.company.workPhone }
											</div>
										</div>
									</li>
								</ul>
							</div>
						</div>

						<div class="row  pb-2">
							<div class="col-md-4">
								<ul class="list-group list-group-numbered">
									<li
										class="list-group-item d-flex justify-content-between align-items-start  border-0">
										<div class="ms-2 me-auto text-start">
											Subscription Type
											<div class="fw-bold text-start  fs-6 pt-2">
												${data.company.subscriptionType}</div>
										</div>
									</li>
								</ul>
							</div>
							<div class="col-md-4">
								<ul class="list-group list-group-numbered">
									<li
										class="list-group-item d-flex justify-content-between align-items-start  border-0">
										<div class="ms-2 me-auto text-start">
											Subscription Plan
											<div class="fw-bold text-start  fs-6 pt-2">
												${data.company.subscriptionPlan }</div>
										</div>
									</li>
								</ul>
							</div>
						</div>
						
						<div class="col-md-12 my-2">
							<div class="text-start">
								<h5 class="card-header text">${admin.role } Admin Details</h5>
							</div>
						</div>

						<div class="row text-start pluck-card">
							<div class="row d-flex justify-content-start align-items-start ">
								<c:forEach items="${data.admins }" var="admin">
									<div class="card text-center m-1 p-1" style="width: 17.5rem;">
											<img
												class="card-img-top rounded-circle w-50 mx-auto "
												src="${pageContext.request.contextPath}/images/profile-2.png"
												alt="Profile Logo">
											<div class="card-body pt-4 px-0">
												<h6 class="card-title fs-5">
													<a class="details-value"
														href="${pageContext.request.contextPath}/users/update/form/${admin.id}">${admin.firstName}
														${admin.lastName}</a>
												</h6>
												<div class="d-flex flex-column  text-start px-2 mt-2">
													 <p class="d-flex justify-content-start m-1">
														<label class=" card-text details-label  font-size-12">Username:</label> 
														<span class="font-size-12">&nbsp;${admin.username }</span>
													</p>
													  <p class=" d-flex m-1">
													 	<label class="card-text details-label font-size-12">Contact :</label> 
													 	<span class=" font-size-12">&nbsp;${admin.contactNumber }</span>
													 </p>													
												</div>
											</div>
										</div>
								</c:forEach>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>