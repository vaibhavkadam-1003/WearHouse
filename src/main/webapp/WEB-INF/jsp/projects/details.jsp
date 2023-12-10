<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<script src="https://code.jquery.com/jquery-3.6.1.js"
	integrity="sha256-3zlB5s2uwoUzrXK3BT7AX3FyvojsraNFxCc2vC/7pNI="
	crossorigin="anonymous"></script>
 
<script src="${pageContext.request.contextPath}/js/addCompany.js"></script>
<script src="${pageContext.request.contextPath}/js/common.js"></script>
<script src="${pageContext.request.contextPath}/js/validation.js"></script>
<jsp:include page="../common/header.jsp"></jsp:include>


<div class="main-content ">

	<div class="container-fluid"> 
		<div class="">
			<div class="card">
			<div class="row">
					<div class="col-md-7  ">
						<div class="card-body Project-Informetion">
							<small>Project Information</small>
							<div
								class="d-flex justify-content-start align-items-start flex-column my-4">
								<img
									src="${pageContext.request.contextPath}/images/triservicepro-logo.svg "
									class="figure-img img-fluid" alt="project Logo">
								<h5>${project.name}</h5>
								<p>${project.description}</p>
								
								<ul>
									<li class="my-2">The project started on : <b> ${project.startDate } </b></li>
									<li class="my-2">The project last date is : <b> ${project.lastDate }
									</b></li>
								</ul>
								
								<c:choose>
									<c:when test="${project.status eq 'Active'}">
										<a class="project-active">${project.status} </a>
									</c:when>
									<c:otherwise>
										<a   class="project-inactive" > ${project.status} </a>
									</c:otherwise>
								</c:choose>
								
								
							</div>
						</div> 
					</div>
					<div class="col-md-5 bg-light border">
						<div class="card-body project-administrators-wrapper">
							<small>Project Administrators</small>
							<c:forEach items="${project.owners}" var="owner">
							<div class="project-administrators">
								<div class="d-flex justify-content-start align-items-center">
									<i class='bx bxs-user'></i>
									<div>
									<h6>${owner.firstName} ${owner.lastName}</h6>
									<small> ${owner.username} is a ${owner.role }</small>
									</div> 
								</div> 
								<div>
									<div class="form-check form-switch">
										<input class="form-check-input" type="checkbox"
											id="flexSwitchCheckDefault">
									</div>
								</div>
							</div>
							</c:forEach>
							
							<div class="my-4"></div>
							
							<small>Project User</small>
							<c:forEach items="${project.users}" var="user">
							<div class="project-administrators">
								<div class="d-flex justify-content-start align-items-center">
									<i class='bx bxs-user'></i>
									<div>
									<h6>${user.firstName}${user.lastName}</h6>
									<small> ${user.username} is a ${user.role }</small>
									</div> 
								</div> 
								<div>
									<div class="form-check form-switch">
										<input class="form-check-input" type="checkbox"
											id="flexSwitchCheckDefault">
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