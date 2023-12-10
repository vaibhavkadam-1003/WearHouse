<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!doctype html>
<html lang="en">

<head>
<!-- Bootstrap CSS -->
<%-- <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.1/css/all.min.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/boxicons@latest/css/boxicons.min.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css">
<link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet"> 
<link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet"> --%>

<!-- Required meta tags -->
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>

<c:choose>

	<c:when test="${ pageTitle == null || pageTitle == ''}">
		<title>Pluck</title>
	</c:when>
	<c:otherwise>
		<title>${pageTitle}</title>
	</c:otherwise>

</c:choose>

<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@200;300;400;500;600;700;800;900&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.1/css/all.min.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/boxicons@latest/css/boxicons.min.css">
<link href="${pageContext.request.contextPath}/css/bootstrap.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/css/NewStyle.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/css/toastr.min.css">
<link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">


<script src="https://code.jquery.com/jquery-3.6.1.js"></script>
<script src="https://code.iconify.design/iconify-icon/1.0.1/iconify-icon.min.js" defer></script>
<script src="${pageContext.request.contextPath}/js/common.js"></script>
<script src="${pageContext.request.contextPath}/js/header.js"></script>
<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
<!-- Include Toastr CSS and JS files -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/js/toastr.min.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.min.js"></script>

<style type="text/css">
.nav_link .sub-menu .dropdown-item:focus, .dropdown-item:hover {
	color: black !important;
	background-color: lightgrey !important;
}

.status-priority::after {
	border: none;
}

.dropdown-menu {
	font-size: 13px !important;
	color: rgb(23, 43, 77) !important;
	overflow: hidden;
	text-overflow: ellipsis;
	white-space: nowrap;
	padding-top: 0px;
	padding-bottom: 0px;
}

.dropdown-menu li {
	padding: 0.25rem 0rem;
}

.status-priority-dropdown {
	position: absolute;
	top: 100%;
	left: -30px !important;
	z-index: 1000;
	display: none;
	min-width: 7.7rem;
	padding: 0.5rem 0;
	margin: 0.125rem 0 0;
	font-size: 1rem;
	color: #212529;
	text-align: left;
	list-style: none;
	background-color: #fff;
	background-clip: padding-box;
	border: 1px solid rgba(0, 0, 0, .15);
	border-radius: 0.25rem;
	font-size: 13px;
	color: rgb(23, 43, 77);
	overflow: hidden;
	text-overflow: ellipsis;
	white-space: nowrap;
	padding-top: 0px;
	padding-bottom: 0px;
}

.status-priority-dropdown li {
	padding: 4px 0px;
}

.User-profile-btn:focus+.btn, .User-profile-btn:focus {
	outline: 0;
	box-shadow: 0 0 0 0rem rgba(13, 110, 253, .25);
}

.dropdown-toggle::after  {
    border: none;
}
</style>
</head>

<body>

	<%
	Long defaultProjectId = (Long) session.getAttribute("defaultProjectId");
	%>

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

	<div id="body-pd" class="body-pd">
		<input type="hidden" id="id-context-path"
			value="${pageContext.request.contextPath}">


		<header class="header border-bottom" id="header"> 

			<nav class="navbar navbar-expand-lg py-0  w-100">
				<ul class="navbar-nav justify-content-end upperNavbar  me-1">
					<div class="creat-upperNavbar">
						<li class="nav-item ">
							<div class="header_toggle ">
								<i class='bx bx-menu' id="header-toggle"></i>
							</div>
							<div class="header_toggle-mobile ">
								<i class='bx bx-menu' id="header-toggle"></i>
							</div>
						</li>
						
						<li class="nav-item default_project_dropdown">
							<%
                        if (!session.getAttribute("role").equals("Super Admin")) {
                        %>
							<form id="defaultProjectForm"
								action="${pageContext.request.contextPath}/projects/default">
								<select class="form-select" name="project"
									id="defaultProject" onchange="defaultProjectDropdownValue()">
									<c:forEach items="${projectList}" var="project">
										<c:choose>
											<c:when
												test="${sessionScope.defaultProjectId == project.id }">
												<option value="${project.id}" selected>${project.name}</option>
											</c:when>
											<c:otherwise>
												<option value="${project.id}">${project.name}</option>
											</c:otherwise>
										</c:choose>

									</c:forEach>
								</select>
							</form> <%
                        }
                        %>
						</li>


						
					</div>

					<div class="profile-upperNavbar">
					<li class="nav-item  global-search mx-1">
						<i class='bx bx-search' ></i>
					</li>
						
						<li class="nav-item  All-create">
							 
								<button type="button"
									class="dropdown-toggle dropdown-toggle-split "
									data-bs-toggle="dropdown" aria-expanded="false">
									<span class=" mx-1 "> <i class='bx bx-plus'></i></span> <span
										class="visually-hidden">Toggle Dropdown</span>
								</button>
								<ul class="dropdown-menu dropdown-menu-create-option">
									<c:if test="${sessionScope.role.equals('Super Admin') }">
										<li><a
											href="${pageContext.request.contextPath}/company/add/form"
											tabindex="0" role="menuitem" class="dropdown-item">Company</a></li>
									</c:if>


									<c:if
										test="${sessionScope.role.equals('Company Admin') || sessionScope.role.equals('Project Admin')  && !sessionScope.role.equals('Super Admin') }">
										<li><a
											href="${pageContext.request.contextPath}/users/add/form"
											tabindex="0" role="menuitem" class="dropdown-item">User</a></li>
									</c:if>

									<c:if
										test="${sessionScope.role.equals('Company Admin') && !sessionScope.role.equals('Super Admin') }">
										<li><a
											href="${pageContext.request.contextPath}/projects/add/form"
											tabindex="0" role="menuitem" class="dropdown-item">Project</a></li>
									</c:if>

									<c:if test="${!sessionScope.role.equals('Super Admin') }">
										<li><a
											href="${pageContext.request.contextPath}/tasks/addTaskForm"
											tabindex="0" role="menuitem" class="dropdown-item">Task </a></li>
									</c:if>

									<c:if test="${!sessionScope.role.equals('Super Admin') }">
										<li><a
											href="${pageContext.request.contextPath}/stories/addQuickStoryForm"
											tabindex="0" role="menuitem" class="dropdown-item">User
												Story </a></li>
									</c:if>

									<c:if test="${!sessionScope.role.equals('Super Admin') }">
										<li><a
											href="${pageContext.request.contextPath}/modules/addModuleForm"
											tabindex="0" role="menuitem" class="dropdown-item">Module
										</a></li>
									</c:if>

									<c:if test="${!sessionScope.role.equals('Super Admin') }">
										<li><a
											href="${pageContext.request.contextPath}/criterias/addCriteriaForm"
											tabindex="0" role="menuitem" class="dropdown-item">Criteria
										</a></li>
									</c:if>
									
									<%
									if (session.getAttribute("role").equals("Scrum Master") || session.getAttribute("role").equals("Project Manager")) {
									%>
												<li id="nav-list-sprint"><a id="nav-link-sprint"
													<% if (defaultProjectId != null ) { %>
													href="${pageContext.request.contextPath}/sprints/addSprintForm"
													<%}else{ %> onclick="sweetAlertMessage()" <%} %> tabindex="0"
													role="menuitem" class="dropdown-item">Create Sprint</a></li>
			
									<%
									}
									%>
								</ul> 
						</li>
					
						<li class="nav-item  priority-Status-info">
							 
								<button class="dropdown-toggle"   id="dropdownMenuButtonNew" data-bs-toggle="dropdown" aria-expanded="false">
									<i class='bx bx-cog' ></i>
								</button>
								<ul class="dropdown-menu" aria-labelledby="dropdownMenuButtonNew">
									<li><a class="dropdown-item"
										href="/pluck/dropdownConfiguration/priority/form">
											Priority</a></li>
									<li><a class="dropdown-item"
										href="/pluck/dropdownConfiguration/severity/form">
											Severity</a></li>
									<li><a class="dropdown-item"
										href="/pluck/dropdownConfiguration/status/form"> Status</a></li>
									<li><a class="dropdown-item"
										href="/pluck/storyPoint/addStoryForm"> Story-Point</a></li>
								</ul> 
						</li>
						
						<c:if
							test="${sessionScope.role.equals('Project Lead') || sessionScope.role.equals('Scrum Master') || sessionScope.role.equals('Project Manager') || sessionScope.role.equals('Project User') }">
							
						<li class="nav-item dropdown notification"><a
							class="nav-link dropdown-toggle" href="#" id="navbarDropdown"
							role="button" data-bs-toggle="dropdown" aria-expanded="false">
								<i class='bx bx-bell'></i><span id="notificationCount">${notifications.size()}</span>
						</a>
							<ul class="dropdown-menu" aria-labelledby="navbarDropdown">

								<li class="px-3 py-2 notification-top border-bottom">You have ${notifications.size()}  Notification</li>
								<c:forEach items="${notifications}" var="notification">-
								<a href="${pageContext.request.contextPath}/notification/details/${notification.notificationId}" 
												id="item${notification.notificationId}">
								<li class=" mt-2 border-bottom">
									<div class="d-flex justify-content-between align-items-center">
										<div class="noti-title" title="${notification.messageSubject}" id="bold-notification-messageBody">
										${notification.messageSubject}
										<small>${notification.messageBody}</small>
										</div>
											 
										<i class="fa-solid fa-xmark noti-remove"></i>
									</div>
									<p id="notification-date-span" > <fmt:formatDate pattern="MMM dd, HH:MM a" value="${notification.addedDate}" /></p>
								</li>
								</a>
								</c:forEach>

								<li class=" mt-2 border-bottom">
									<div class="d-flex justify-content-between align-items-center">
										<div class="noti-title">Sachin Anuse is added to
											Veracity India</div>
										<i class="fa-solid fa-trash noti-remove"></i>
									</div>
									<p>22 Feb 2023</p>
								</li>


								<li class="px-3 py-2 notification-top text-center">Clear
									all Notifications</li>
							</ul></li>
							</c:if>

						<li class="nav-item dropdown info-User-Profile"><a
							class="nav-link dropdown-toggle p-0 m-0  d-flex justify-content-start align-items-center"
							href="#" id="navbarDropdown" role="button"
							data-bs-toggle="dropdown" aria-expanded="false"> <i
								class='bx bxs-user-circle fa-user'></i>
								<div class="my-0 p-0  ">
									<h6 class="m-0 p-0">${sessionScope.loggedInUser.firstName}
										${sessionScope.loggedInUser.lastName}</h6>
									<p class="m-0 p-0">${role}</p>
								</div>
						</a>


							<ul class="dropdown-menu " aria-labelledby="navbarDropdown">
								<li><a
									href="${pageContext.request.contextPath}/users/update/form/${sessionScope.loggedInUser.id }"
									tabindex="0" role="menuitem" class="dropdown-item"> <i
										class="bx bx-user"></i> Profile
								</a></li>
								<li><a
									href="${pageContext.request.contextPath}/users/changePassword"
									tabindex="0" role="menuitem" class="dropdown-item"> <i
										class="bx bx-user"></i> Change
										Password
								</a></li>
								<li><a style="pointer-events: none" href="" tabindex="0"
									role="menuitem" class="dropdown-item"> <i
										class="bx bx-lock-open"></i>
										Lock Screen
								</a></li>
								<li><hr class="dropdown-divider m-0 p-0"></li>
								<li><a class="dropdown-item"
									href="${pageContext.request.contextPath}/logout"> <i
										class="bx bx-power-off text-danger"></i><span>Logout</span>
								</a></li>
							</ul></li>


					</div>

				</ul>
			</nav>
		</header>




		

		 

		<div class="l-navbar" id="nav-bar">
			<nav class="nav">
				<div class="side-navbar">
					<button type="button" class="btn-close-mobile" aria-label="Close"></button>
					<a href="#" class="nav_logo"> <i
						class='bx bx-layer nav_logo-icon'></i> <span
						class="nav_logo-name nav_name">Pluck</span>
					</a>
					<div class="nav_list">

						<ul class="list-unstyled" id="nav-bar-ul-list">

							<%
							if (!session.getAttribute("role").equals("Super Admin")) {
							%>

							<%
							if (session.getAttribute("role").equals("Project Manager")) {
							%>
							<li class=" nav-item dropdown" id="nav-bar-li-dashboard"><a
								class="nav_link" <% if (defaultProjectId != null ) { %>
								href="${pageContext.request.contextPath}/project-manager/dashboard"
								id="nav-dashboard-link" <%}else{%> onclick="sweetAlertMessage()"
								<%} %>> <i class='bx bx-home-circle nav_icon'><span
										class="nav_name" id="nav-dashboard-name">Dashboard</span></i>
							</a></li>
							<%
							} else if (session.getAttribute("role").equals("Scrum Master")) {
							%>
							<li class=" nav-item dropdown" id="nav-bar-li-dashboard"><a
								class="nav_link" <% if (defaultProjectId != null ) { %>
								href="${pageContext.request.contextPath}/scrum-master/dashboard"
								id="nav-dashboard-link"
								<%} else if(!session.getAttribute("role").equals("Super Admin")){ %>
								onclick="sweetAlertMessage()" <%} %>> <i
									class='bx bx-home-circle nav_icon'><span class="nav_name"
										id="nav-dashboard-name">Dashborad</span></i>
							</a></li>

							<%
							} else {
							%>
							<li class=" nav-item dropdown" id="nav-bar-li-dashboard"><a
								class="nav_link" <% if (defaultProjectId != null ) { %>
								href="${pageContext.request.contextPath}/dashboard/user/${sessionScope.loggedInUser.id}"
								id="nav-dashboard-link"
								<%} else if(!session.getAttribute("role").equals("Super Admin")){ %>
								onclick="sweetAlertMessage()" <%} %>> <i
									class='bx bx-home-circle nav_icon'><span class="nav_name"
										id="nav-dashboard-name">Dashborad</span></i>

							</a></li>

							<%
							}
							%>

							<%
							}
							if (session.getAttribute("role").equals("Super Admin")) {
							%>

							<li class=" nav-item dropdown" id="nav-li-company"><a
								class="nav_link " data-bs-toggle="collapse"
								href="#multiCollapseExample3" role="button"
								aria-expanded="false" aria-controls="multiCollapseExample3"
								id="nav-company-link"> <i class='bx bx-user nav_icon'><span
										class="nav_name" id="nav-company-name">Company</span></i>
							</a>
								<ul class="collapse multi-collapse sub-menu"
									id="multiCollapseExample3">
									<li id="nav-li-all-company"><a
										href="${pageContext.request.contextPath}/company?pageNo=0"
										class="dropdown-item" id="nav-all-company-link">All
											Company</a></li>
									<li id="nav-li-add-company"><a
										href="${pageContext.request.contextPath}/company/add/form"
										class="dropdown-item" id="nav-add-company-link">Add
											Company</a></li>
									<li class="disabledSmtp" id="nav-li-add-smtp"><a
										href="${pageContext.request.contextPath}/smtp/add/smtp"
										class="dropdown-item" id="nav-add-smtp-link">Add SMTP</a></li>
									<li class="disabledSmtp" id="nav-li-all-smtp"><a
										href="${pageContext.request.contextPath}/smtp/all/smtp"
										class="dropdown-item" id="nav-all-smtp-link">All SMTP</a></li>
								</ul></li>

							<%
							}
							%>

							<%
							if (session.getAttribute("role").equals("Scrum Master")) {
							%>
							<li class=" nav-item dropdown" id="nav-li-user"><a
								class="nav_link "
								href="${pageContext.request.contextPath}/users?pageNo=0"
								id="nav-user-link"> <i class='bx bxs-user-detail nav_icon'><span
										class="nav_name" id="nav-user-name">User</span></i>
							</a></li>

							<li class=" nav-item dropdown" id="nav-li-project"><a
								class="nav_link "
								href="${pageContext.request.contextPath}/projects/userProject"
								id="nav-project-link"> <i
									class='bx bx-briefcase-alt-2 nav_icon'><span
										class="nav_name" id="nav-project-name">Project</span></i>
							</a>
								<ul class="collapse multi-collapse sub-menu"
									id="multiCollapseExample2">
									<li id="all-projects-scrum"><a
										href="${pageContext.request.contextPath}/projects/allproject?pageNo=0"
										class="dropdown-item" id="all-projects-scrum-name">Projects</a></li>
								</ul></li>

							<li class=" nav-item dropdown" id="nav-li-task"><a
								class="nav_link " data-bs-toggle="collapse"
								href="#multiCollapseExample4" role="button"
								aria-expanded="false" aria-controls="multiCollapseExample4"
								id="nav-task-link"> <i class="bx bx-task nav_icon  "><span
										class="nav_name" id="nav-task-name">Task</span> </i>
							</a>
								<ul class="collapse multi-collapse sub-menu"
									id="multiCollapseExample4">
									<li id="nav-li-add-task"><a
										<% if (defaultProjectId != null ) { %>
										href="${pageContext.request.contextPath}/tasks/addTaskForm"
										<%}else{%> onclick="sweetAlertMessage()" <%} %>
										class="dropdown-item" id="nav-task-link">Add Task</a></li>
									<li id="nav-li-story"><a
										<% if (defaultProjectId != null ) { %>
										href="${pageContext.request.contextPath}/stories/addQuickStoryForm"
										<%}else{%> onclick="sweetAlertMessage()" <%} %>
										class="dropdown-item" id="nav-story-link">Add Quick Story</a></li>
									<li id="nav-li-detailed-story"><a
										<% if (defaultProjectId != null ) { %>
										href="${pageContext.request.contextPath}/stories/addDetailedStoryForm"
										<%}else{%> onclick="sweetAlertMessage()" <%} %>
										class="dropdown-item" id="nav-detailed-story-link">Add
											Detailed Story</a></li>
									<%-- <li id="nav-li-all-story"><a
										href="${pageContext.request.contextPath}/stories?pageNo=0"
										class="dropdown-item" id="nav-all-story-link">All Stories</a></li> --%>
									<li id="nav-li-all-task"><a
										href="${pageContext.request.contextPath}/tasks?pageNo=0"
										class="dropdown-item" id="nav-all-task-link">All Tasks</a></li>
								</ul></li>

							<%
							}
							%>
							<%
							if (session.getAttribute("role").equals("Project Manager")) {
							%>
							<li class=" nav-item dropdown" id="nav-item-scrum"><a
								class="nav_link " data-bs-toggle="collapse"
								href="#multiCollapseScrum" role="button" aria-expanded="false"
								aria-controls="multiCollapseExample4" id="nav-link-scrum"> <i
									class="bx bx-task nav_icon  "><span class="nav_name"
										id="nav-scrum-name">Scrum</span> </i>
							</a>
								<ul class="collapse multi-collapse sub-menu"
									id="multiCollapseScrum">
									<li id="nav-item-add-scrum"><a
										<% if (defaultProjectId != null ) { %>
										href="${pageContext.request.contextPath}/scrums/addScrumForm"
										<%}else{%> onclick="sweetAlertMessage()" <%} %>
										class="dropdown-item" id="nav-add-scrum-link">Add Scrum
											Team</a></li>

									<li id="nav-item-all-scrum"><a
										<% if (defaultProjectId != null){ %>
										href="${pageContext.request.contextPath}/scrums" <%} else{ %>
										onclick="sweetAlertMessage()" <%} %> class="dropdown-item"
										id="nav-all-scrum-link">All Scrum Teams</a></li>
								</ul></li>
							<%
							}
							%>
							<%
							if (session.getAttribute("role").equals("Scrum Master")) {
							%>
							<li class=" nav-item dropdown" id="nav-item-scrum"><a
								class="nav_link " data-bs-toggle="collapse"
								href="#multiCollapseScrum" role="button" aria-expanded="false"
								aria-controls="multiCollapseExample4" id="nav-link-scrum"> <i
									class="bx bx-task nav_icon  "><span class="nav_name"
										id="nav-scrum-name">Scrum</span> </i>
							</a>
								<ul class="collapse multi-collapse sub-menu"
									id="multiCollapseScrum">
									<li id="nav-item-add-scrum"><a
										<% if (defaultProjectId != null ) { %>
										href="${pageContext.request.contextPath}/scrums/addScrumForm"
										<%}else{%> onclick="sweetAlertMessage()" <%} %>
										class="dropdown-item" id="nav-add-scrum-link">Add Scrum
											Team</a></li>

									<li id="nav-item-all-scrum"><a
										<% if (defaultProjectId != null){ %>
										href="${pageContext.request.contextPath}/scrums" <%} else{ %>
										onclick="sweetAlertMessage()" <%} %> class="dropdown-item"
										id="nav-all-scrum-link">All Scrum Teams</a></li>
								</ul></li>
							<li class=" nav-item dropdown" id="nav-item-backlogs"><a
								class="nav_link" <% if(defaultProjectId != null){ %>
								href="${pageContext.request.contextPath}/backlogs" <%}else{ %>
								onclick="sweetAlertMessage()" <%} %> id="nav-backlogs-link">


									<i class="bx bx-food-menu nav_icon"></i> <span
									class="nav_name m-0 ms-2" id="nav-backlogs-name">
										Backlog  </span>
							</a></li>
							<%
						if (session.getAttribute("role").equals("Scrum Master") || session.getAttribute("role").equals("Project Manager")) {
						%>
							<li class=" nav-item dropdown" id="nav-start-sprint"><a
								<% if (defaultProjectId != null ) { %>
								href="${pageContext.request.contextPath}/sprints/start-sprint-form"
								<%}else{ %> onclick="sweetAlertMessage()" <%} %>
								class="nav_link start-sprint-link" id="nav-start-sprint-link">
								
								<i class='bx bx-abacus nav_icon'></i>
								 <span
									class="nav_name m-0 ms-2" id="start-sprint-name">
										Start Sprint </span>
								 
							</a>

								 </li>

							<%
						}
							%>

							<li class=" nav-item dropdown" id="nav-active-sprint"><a
								class="nav_link" <% if(defaultProjectId != null){ %>
								href="${pageContext.request.contextPath}/sprints/activeSprints"
								id="nav-active-sprint-link" <%}else{ %>
								onclick="sweetAlertMessage()" <%} %>> <i
									class="bx bx-spreadsheet nav_icon"></i> <span
									class="nav_name m-0 ms-2" id="nav-sprint-name"> Active
										Sprint </span>
							</a></li>

							<li class=" nav-item dropdown" id="li-previous-sprint"><a
								class="nav_link" <% if(defaultProjectId != null){ %>
								id="link-previous-sprint"
								href="${pageContext.request.contextPath}/sprints/previous"
								<%}else{ %> onclick="sweetAlertMessage()" <%} %>> <i
									class="bx bx-right-indent nav_icon"></i> <span
									class="nav_name m-0 ms-2" id="previous-sprint-name">
										PreviousSprints </span>
							</a></li>
							<%
							}
							%>
							<%
							if (!session.getAttribute("role").equals("Super Admin") && !session.getAttribute("role").equals("Scrum Master")) {
							%>
							<li class=" nav-item dropdown" id="nav-item-user"><a
								class="nav_link " data-bs-toggle="collapse"
								href="#multiCollapseExample1" role="button"
								aria-expanded="false" aria-controls="multiCollapseExample1"
								id="nav-linkUser"> <i class='bx bxs-user-detail nav_icon'><span
										class="nav_name" id="nav-user-text">User</span></i>
							</a>
								<ul class="collapse multi-collapse sub-menu"
									id="multiCollapseExample1">

									<%
									if (session.getAttribute("role").equals("Company Admin") || session.getAttribute("role").equals("Project Lead")
											|| session.getAttribute("role").equals("Scrum Master")
											|| session.getAttribute("role").equals("Project Manager")) {
									%>
									<li id="nav-item-user-add"><a
										href="${pageContext.request.contextPath}/users/add/form"
										class="dropdown-item" id="nav-link-add-user">Add User</a></li>
									<%
									}
									%>

									<li id="nav-item-user-all"><a
										href="${pageContext.request.contextPath}/users?pageNo=0"
										class="dropdown-item" id="nav-user-all-link">All Users</a></li>

								</ul></li>

							<li class=" nav-item dropdown" id="nav-item-project"><a
								class="nav_link " data-bs-toggle="collapse"
								href="#multiCollapseExample2" role="button"
								aria-expanded="false" aria-controls="multiCollapseExample2"
								id="nav-item-project-link"> <i
									class='bx bx-briefcase-alt-2 nav_icon'><span
										class="nav_name" id="nav-item-project-name">Project</span></i>
							</a>
								<ul class="collapse multi-collapse sub-menu"
									id="multiCollapseExample2">

									<%
									if (session.getAttribute("role").equals("Company Admin") || session.getAttribute("role").equals("Project Manager")) {
									%>
									<li id="li-add-project"><a
										href="${pageContext.request.contextPath}/projects/add/form"
										class="dropdown-item" id="link-add-project">Add Project</a></li>

									<%
									}
									%>

									<li id="all-project-li"><a
										href="${pageContext.request.contextPath}/projects/allproject?pageNo=0"
										class="dropdown-item" id="link-all-project">All Projects</a></li>

								</ul></li>

							<li class=" nav-item dropdown" id="li-task"><a
								class="nav_link " data-bs-toggle="collapse"
								href="#multiCollapseExample4" role="button"
								aria-expanded="false" aria-controls="multiCollapseExample4"
								id="link-task"> <i class="bx bx-task nav_icon  "><span
										class="nav_name" id="task-name-module">Task</span> </i>
							</a>
								<ul class="collapse multi-collapse sub-menu"
									id="multiCollapseExample4">
									<li id="li-add-task"><a
										<% if (defaultProjectId != null ) { %>
										href="${pageContext.request.contextPath}/tasks/addTaskForm"
										<%}else{%> onclick="sweetAlertMessage()" <%} %>
										class="dropdown-item" id="link-add-task">Add Task</a></li>
									<li id="li-quick-story"><a
										<% if (defaultProjectId != null ) { %>
										href="${pageContext.request.contextPath}/stories/addQuickStoryForm"
										<%}else{%> onclick="sweetAlertMessage()" <%} %>
										class="dropdown-item" id="link-quick-story">Add Quick
											Story</a></li>
									<li id="li-detailed-story"><a
										<% if (defaultProjectId != null ) { %>
										href="${pageContext.request.contextPath}/stories/addDetailedStoryForm"
										<%}else{%> onclick="sweetAlertMessage()" <%} %>
										class="dropdown-item" id="link-detailed-story">Add
											Detailed Story</a></li>
									<%-- 	<li id="li-all-stories"><a <% if (defaultProjectId != null ) { %>
										href="${pageContext.request.contextPath}/stories?pageNo=0"
										<%}else{%> onclick="sweetAlertMessage()" <%} %> class="dropdown-item" id="link-all-stories">All Stories</a></li> --%>
									<li id="li-all-task"><a
										<% if (defaultProjectId != null ) { %>
										href="${pageContext.request.contextPath}/tasks?pageNo=0"
										<%}else{%> onclick="sweetAlertMessage()" <%} %>
										class="dropdown-item" id="link-all-task">All Tasks</a></li>
								</ul></li>

							<%
							}
							%>
							<%
							if (!session.getAttribute("role").equals("Super Admin") && !session.getAttribute("role").equals("Scrum Master")) {
							%>
							<li class=" nav-item dropdown" id="li-backlogs"><a
								class="nav_link" <% if(defaultProjectId != null){ %>
								href="${pageContext.request.contextPath}/backlogs" <%}else{ %>
								onclick="sweetAlertMessage()" <%} %> id="link-backlogs"> <i
									class="bx bx-food-menu nav_icon"></i> <span
									class="nav_name m-0 ms-2" id="backlogs-name"> Backlog </span>

							</a></li>


							<li class=" nav-item dropdown" id="li-active-sprint"><a
								class="nav_link" <% if(defaultProjectId != null){ %>
								href="${pageContext.request.contextPath}/sprints/activeSprints"
								<%}else{ %> id="link-active-sprint"
								onclick="sweetAlertMessage()" <%} %>> <i
									class="bx bx-spreadsheet nav_icon"></i> <span
									class="nav_name m-0 ms-2" id="active-sprint-name">
										Active Sprint </span>
							</a></li>

							<%
						if (session.getAttribute("role").equals("Scrum Master") || session.getAttribute("role").equals("Project Manager")) {
						%>
							<li class=" nav-item dropdown" id="nav-start-sprint"><a
								href="${pageContext.request.contextPath}/sprints/start-sprint-form"
								class="nav_link start-sprint-link" id="nav-start-sprint-link">
									<!-- <iconify-icon class="fa fa-align-justify pe-1"></iconify-icon>
									<span class="nav_name" id="start-sprint-name"> Start Sprint </span> -->

									<i class="bx bx-spreadsheet nav_icon"></i> <span
									class="nav_name m-0 ms-2" id="start-sprint-name"> Start Sprint </span>
							</a>

								 </li>
							<%
						}
							%>

							<li class=" nav-item dropdown" id="li-previous-sprint"><a
								class="nav_link" <% if(defaultProjectId != null){ %>
								id="link-previous-sprint"
								href="${pageContext.request.contextPath}/sprints/previous"
								<%}else{ %> onclick="sweetAlertMessage()" <%} %>> <i
									class="bx bx-right-indent nav_icon"></i> <span
									class="nav_name m-0 ms-2" id="previous-sprint-name">
										Previous Sprints </span>
							</a></li>
							<%
							}
							%>

							<%
							if (!session.getAttribute("role").equals("Super Admin")) {
							%>

							<li class=" nav-item dropdown" id="nav-li-company"><a
								class="nav_link " <%if (defaultProjectId != null) {%>
								data-bs-toggle="collapse" href="#multiCollapseExample3"
								role="button" aria-expanded="false"
								aria-controls="multiCollapseExample3" id="nav-company-link"
								<%} else {%> onclick="sweetAlertMessage()" <%}%>> <i
									class='bx bx-line-chart nav_icon'><span class="nav_name"
										id="nav-company-name">Report</span></i>
							</a>
								<ul class="collapse multi-collapse sub-menu"
									id="multiCollapseExample3">
									<li id="nav-li-all-company"><a
										href="${pageContext.request.contextPath}/reports/sprints/active/getReportPage"
										class="dropdown-item" id="nav-all-company-link">Active
											sprint report </a></li>
									<li id="nav-li-add-company" class="disabledSmtp"><a
										href="#" class="dropdown-item" id="nav-add-company-link">Previous
											Sprint</a></li>
									<li id="nav-li-add-smtp"><a
										href="${pageContext.request.contextPath}/reports/getReportPage"
										class="dropdown-item" id="nav-add-smtp-link">Task report</a></li>
									<li class="disabledSmtp" id="nav-li-all-smtp"><a href="#"
										class="dropdown-item" id="nav-all-smtp-link">Task</a></li>
									<li id="nav-li-all-smtp"><a
										href="${pageContext.request.contextPath}/reports/getProjectReport"
										class="dropdown-item" id="nav-all-smtp-link">Project</a></li>
								</ul></li>

							<%
							}
							%>

							 

							<li class=" nav-item dropdown new-footer" id="li-footer"><a
								href="#" class="nav_link"> <i class='bx bx-log-out nav_icon'><span
										class="nav_name">SignOut</span></i>
							</a></li>


						</ul>
					</div>

				</div>
			</nav>
		</div>

	</div>


	<script>
		
	 let mobileMenu = document.querySelector(".header_toggle-mobile");
     mobileMenu.addEventListener("click", () => {
       let mobileNav = document.querySelector("#nav-bar");
       let mobileLink = document.querySelectorAll(".nav_link")
       mobileLink.forEach((item) => item.classList.add('mobile-link'))
       mobileNav.style.display = "block"; 
     })

     let menuClose = document.querySelector(".btn-close-mobile");
     menuClose.addEventListener("click", () => {
       let mobileNav = document.querySelector("#nav-bar"); 
       mobileNav.style.display = "none";
     })
	
	function profileToggel(){
		  $('#profile_panal').toggleClass('show');    
	}
	function getAvailableSprint(urlStr){
		$.ajax({
	                      type: "GET",
	                      url: urlStr,
	                      async: false,
	                      success: function (data) {
	                      	let div = document.getElementById('start-sprint-popupBox');
	                      	div.style.display="block";
	                      	let ul = document.getElementById('start-sprint-ul');
	                      	document.getElementById('start-sprint-ul').innerHTML = '';
	                      	if(data){
	                      		if(data.length != 0){
		                      		for(let i = 0;i<data.length;i++){
			                      		let li = document.createElement('li');
			                      		li.setAttribute('class','list-group-item py-1 px-2');
			                      		let a = document.createElement('a');
			                      		a.setAttribute('href','${pageContext.request.contextPath}/sprints/start-sprint/'+data[i].id);
			                      		a.innerHTML=data[i].name + "<p>"+data[i].duration+"</p> ";
			                      		li.appendChild(a);
			                      		ul.appendChild(li);
		                      		}
	                      		}else{
	                      			let li = document.createElement('li');
		                      		li.setAttribute('class','list-group-item py-1 px-2');
		                      		let a = document.createElement('a');
		                      		a.setAttribute('href','#');
		                      		a.innerHTML="No sprint to start. create sprint first";
		                      		li.appendChild(a);
		                      		ul.appendChild(li);
	                      		}
	                      	}else{
	                      		let li = document.createElement('li');
	                      		li.setAttribute('class','list-group-item py-1 px-2');
	                      		let a = document.createElement('a');
	                      		a.setAttribute('href','#');
	                      		a.innerHTML="Current sprint is active. Please complete it before starting new One";
	                      		li.appendChild(a);
	                      		ul.appendChild(li);
	                      	}
	                      }
	                  });
	}
        document.addEventListener("DOMContentLoaded", function (event) {

            const showNavbar = (toggleId, navId, bodyId, headerId) => {
                const toggle = document.getElementById(toggleId),
                    nav = document.getElementById(navId),
                    bodypd = document.getElementById(bodyId),
                    headerpd = document.getElementById(headerId)

                // Validate that all variables exist
                if (toggle && nav && bodypd && headerpd) {
                    toggle.addEventListener('click', () => {
                        // show navbar
                        nav.classList.toggle('showNavbar')
                        // change icon
                        // toggle.classList.toggle('bx-x')
                        toggle.classList.toggle('bx-x') 
                        // add padding to body
                        bodypd.classList.toggle('body-pd')
                        // add padding to header
                        headerpd.classList.toggle('body-pd')
                    })
                }
            }

            showNavbar('header-toggle', 'nav-bar', 'body-pd', 'header')

            /*===== LINK ACTIVE =====*/
            const linkColor = document.querySelectorAll('.nav_link')

            function colorLink() {
                if (linkColor) {
                    linkColor.forEach(l => l.classList.remove('active'))
                    this.classList.add('active')
                }
            }
            linkColor.forEach(l => l.addEventListener('click', colorLink))

            // Your code to run since DOM is loaded and ready
        });

        $(".header_toggle").click(function () {
            $(".header_toggle").toggleClass("header_toggle_margin")
        });
        
        $(".header_toggle").click(function () {
            $(".main-content ").toggleClass("main-content-left")
        });
        
        $(".dataTables_scrollHeadInner").css("width" , "100%")
        
        $(document).ready(function(){
        	let defaultProject = document.getElementById('defaultProject');
        	if (defaultProject.length > 0) {
				
				defaultProject.style.display ="block";
			} else {
				defaultProject.style.display ="none";
			};
					

});
       
</script>
	<script
		src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js"></script>
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.min.js"></script>


</body>

</html>