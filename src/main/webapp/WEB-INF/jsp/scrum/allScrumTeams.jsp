<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head> 
</head>
<body>
	<jsp:include page="../common/header.jsp"></jsp:include>

	<%
	if (session.getAttribute("username") == null) {
		response.sendRedirect("/login");
	}
	%>

	<div class="main-content " >
		<div class="card">
			<div class="card-body">
			<input type="hidden" id="contextPathInput"  value="${pageContext.request.contextPath}">
				<div class="d-flex justify-content-between align-items-center">
					<div>
						<small>Scrum Teams</small>
					</div>
					<div class="form-outline search-scrum-teams">
							<input type="input" id="searchInput" placeholder="Search Team" class="form-control" />
							<i class='bx bx-search'></i>
					</div>
				</div>
				
				<div class="my-2" style="height:75vh;">
					<table class="table-new " id="tableID" style="width: 100% !important; ">
						<thead>
							<tr>
								<th scope="col">Name</th>
								<th scope="col">Team</th>
								<th scope="col">Memeber</th>
								<th scope="col">Action</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach items="${teams}" var="team">
								<tr id="scrumTeam${team.id }">
									<td  ><a
										href="${pageContext.request.contextPath}/scrums/details/${team.id }">
											<h5 class="card-title title text-dark">${team.name}</h5>
									</a></td>
									<td>
										<div class="scrum-user-list" >
									<c:choose> 
										<c:when test="${team.members > 3 }">
												<c:forEach var="user" begin="1" end="3"
													items="${team.users}">
													<span>${user.firstName.substring(0, 1).toUpperCase()}${user.lastName.substring(0, 1).toUpperCase()}</span>
													<br>
												</c:forEach>
											</c:when>
											<c:otherwise>
												<c:forEach var="user" items="${team.users}">
													<span>${user.firstName.substring(0, 1).toUpperCase()}${user.lastName.substring(0, 1).toUpperCase()}</span>
													<br>
												</c:forEach>
											</c:otherwise>
										</c:choose>
										<c:if test="${team.members > 3 }">
												<span>+${team.members-3 }</span>
											</c:if> 
									</div>
											
										
										</td>
									<td><b>Members : </b>${team.members }</td>
									<td><i class="fa-solid fa-trash text-danger "
										onclick="deleteTeam(${team.id })"></i></td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>
		</div>

		<%-- <div class="row" >
			<div class="col-md-12 title">
				<h4>All Scrum Teams</h4>
			</div>
			<div class="input-group">
			  <div class="form-outline">
			    <input type="input" id="searchInput"  placeholder="Search Team" class="form-control" />
			  </div>
			</div>
			<div class="row row-cols-1 row-cols-md-4 gx-2 "
				style="max-height: 70vh; overflow-y: auto;">
				<c:forEach items="${teams}" var="team">
				
				
				
					<div class="scrum-user-card card shadow-sm " id="scrumTeam${team.id }"> 
					<div><i class="fa-solid fa-trash text-danger " onclick="deleteTeam(${team.id })"></i></div>
						<div >
							<div class="card-body">
							<a
								href="${pageContext.request.contextPath}/scrums/details/${team.id }">
								<h5 class="card-title title text-dark"
									style="color: #5c5cc7 !important">${team.name}</h5>
									
								<div class="scrum-user-list my-1">
									<c:choose>
										<c:when test="${team.members > 3 }">
											<c:forEach var="user" begin="1" end="3" items="${team.users}">
												<span style="padding: 6px 7px !important">${user.firstName.substring(0, 1).toUpperCase()}${user.lastName.substring(0, 1).toUpperCase()}</span>
												<br>
											</c:forEach>
										</c:when>
										<c:otherwise>
											<c:forEach  var="user" items="${team.users}">
												<span style="padding: 6px 7px !important">${user.firstName.substring(0, 1).toUpperCase()}${user.lastName.substring(0, 1).toUpperCase()}</span>
												<br>
											</c:forEach>
										</c:otherwise>
									</c:choose>

									<c:if test="${team.members > 3 }">
										<span style="background-color: #89aecc;">+${team.members-3 }</span>
									</c:if>

								</div>
								<small class="card-text text-dark"> <b>Members : </b>${team.members }
								</small>
								</a>
							</div>
						</div>
					</div>
				</c:forEach>
			</div>
		</div> --%>

	</div>
	<script src="${pageContext.request.contextPath}/js/allScrumTeams.js"></script>	
</body>
</html>