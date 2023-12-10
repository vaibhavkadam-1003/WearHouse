<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/css/bootstrap.min.css"
	integrity="sha384-TX8t27EcRE3e/ihU7zmQxVncDAy5uIKz4rEkgIXeMed4M0jlfIDPvg6uqKI2xXr2"
	crossorigin="anonymous">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/addCompany.css">

<!-- Import jquery cdn -->
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"
	integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj"
	crossorigin="anonymous">
	
</script>

<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/js/bootstrap.bundle.min.js"
	integrity="sha384-ho+j7jyWK8fNQe+A12Hb8AhRq26LrZ/JpcUGGOn+Y7RsweNrtN/tE3MoK7ZeZDyx"
	crossorigin="anonymous">
	
</script>
<link href="${pageContext.request.contextPath}/css/style.css"
	rel="stylesheet">
<jsp:include page="../common/header.jsp"></jsp:include>

<div class="main-content ">
	<div class="col-md-12">
	<div class="alert alert-success" role="alert">		
		<h4 class="alert-heading">Notification Details</h4>
 		 <hr>
			<div>
				<b>Added date : </b> <span>${notificationList.addedDate}</span> </br>
				
		   					 <%
							if (session.getAttribute("role").equals("Project Manager")) {
							%>
								<a style="float: right; top: 0"  href="${pageContext.request.contextPath}/project-manager/dashboard">
							<i class="fa fa-times" style="font-size:24px"></i>
								</a>
							<%
							}else if (session.getAttribute("role").equals("Company Admin")){
							%>
							<a style="float: right; top: 0"  href="${pageContext.request.contextPath}/scrum-master/dashboard">
							<i class="fa fa-times" style="font-size:24px"></i>
								</a>
							<%
							}
		   					%>
		    	<b>Message subject : </b> <span>${notificationList.messageSubject}</span></br>
		    	<b>Message body : </b> <span>${notificationList.messageBody}</span>
				</div>

		</div>
	</div>
</div>
