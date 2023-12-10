<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<style>
	.NO-SPRINT-ACTIVE{
		    display: flex;
    height: 100vh;
    /* justify-content: center; */
    align-items: center;
    flex-direction: column;
        margin-top: 50px;
	}
	
	.NO-SPRINT-ACTIVE img{
		width: 35%;
	}
</style>

</head>
<body>
<jsp:include page="../common/header.jsp"></jsp:include>
	<div class="main-content">
	<div class=" NO-SPRINT-ACTIVE">
	<img src="${pageContext.request.contextPath}/images/NO-SPRINT-ACTIVE.png " >
	 <!-- <h1> NO SPRINT ACTIVE </h1> -->
	</div>
	</div>


</body>
</html>