
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<script src="${pageContext.request.contextPath}/js/common.js"></script>
<html>
<head>
<!-- Datatable plugin CSS file -->
<link rel="stylesheet"
	href="https://cdn.datatables.net/1.10.22/css/jquery.dataTables.min.css" />

<!-- jQuery library file -->
<script type="text/javascript" src="https://code.jquery.com/jquery-3.5.1.js"> </script>

<!-- Datatable plugin JS library file -->
<script defer type="text/javascript" src="https://cdn.datatables.net/1.10.22/js/jquery.dataTables.min.js"></script>
<link href="${pageContext.request.contextPath}/css/table.css" rel="stylesheet">
	
	<style>
	table.dataTable thead th, table.dataTable thead td {
    padding: 10px 10px;
    border-bottom: 1px solid #838282;
    font-size: 13px;
    font-weight: 600;
}
</style>

</head>
<body>
<jsp:include page="../common/header.jsp"></jsp:include>
<div class="main-content ">
	<div class="container-fuild">
		<div class="row"></div>
		<div class="row">
			<div class="col-md-12 px-2">
				<div class="row ">
				
				<select id="filter" class="filter form-select">
			         <option value="all" selected>All</option>
					 <option value="active">Active</option>
					 <option value="inactive">Inactive</option>
		       </select>
	     
					<table class="table-new " id="tableID" style="max-width: 100% !important;">
						<thead>
							<tr >
								<th tabindex="0" aria-label="Name sortable" class="sortable" style="width:25%;">Name</th>
								<th tabindex="0" aria-label="Email sortable" class="sortable" style="width:15%;">Email Id</th>
								<th tabindex="0" aria-label="Email sortable" class="sortable text-center" style="width:15%;"> Work Phone</th>
								<th tabindex="0" aria-label="Email sortable" class="sortable text-center" style="width:15%;">Subscribe Users</th>
								<th tabindex="0" aria-label="Email sortable" class="sortable text-center" style="width:10%;"> Max Users</th>
								<th tabindex="0" aria-label="Tags sortable" class="sortable text-center"  style="width:10%;"> Status</th>
								<th tabindex="0" class="sortable text-center" style="width:10%;">Action</th>
							</tr>
						</thead>
						<tbody>
								
							<c:forEach items="${list.content}" var="company">
								<tr class="iterativeRow">
									
									<td style="width:25%;">
										<div class=" d-flex justify-content-start align-items-center">
											<div class="avatar-circle">
												<span class="avatar-title " >${fn:substring(company.name, 0, 1).toUpperCase()}</span>
											</div>
											<div>
												<h5 class="font-size-14 mb-1">
													<a class="text-dark pluck-capitalize"
														href="${pageContext.request.contextPath}/company/details/${company.id}">${company.name}</a>
												</h5>
												<p class="text-muted mb-0">Website : ${company.website}</p>
											</div>
										</div>

										
									</td>
									<td class="font-size-12 mb-1" style="width:15%;">${company.emailId}</td>

									<td class="font-size-12 mb-1 text-center" style="width:15%;">${company.workPhone}</td>
									<td class="font-size-12 mb-1 text-center" style="width:15%;">${company.subscriptionPlan}</td>
									<td class="font-size-12 mb-1 text-center" style="width:10%;">${company.maxUsers}</td>
									<td  class="font-size-12 mb-1 text-center status" style="width:10%;"><c:choose>
											<c:when test="${company.status eq 'Active'}">
												<a class="badge badge-soft-primary font-size-11 m-1">${company.status}</a>
											</c:when>
											<c:otherwise>
												<a class="badge in-active font-size-11 m-1">${company.status}</a>
											</c:otherwise>
										</c:choose></td>
									<td class="font-size-12 mb-1 text-center" style="width:10%;"><a
										href="${pageContext.request.contextPath}/company/update/form/${company.id}"
										class="text-success"> <i
											class="fa fa-pencil-square text-primary"
											aria-hidden="true"></i>
									</a></td>
								</tr>
							</c:forEach>

						</tbody>

					</table>
				</div>
			</div>
		</div>
	</div>
</div>
<script src="${pageContext.request.contextPath}/js/allCompany.js"></script>
<script> 		$(document).ready( function() {
	 loadTable(${list.number}, ${list.numberOfElements});
	 }); 

</script>
</body>
</html>
