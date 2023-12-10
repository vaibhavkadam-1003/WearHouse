<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<script src="${pageContext.request.contextPath}/js/"></script>
<head>
<!-- Datatable plugin CSS file -->
<link rel="stylesheet"
	href="https://cdn.datatables.net/1.10.22/css/jquery.dataTables.min.css" />

<!-- jQuery library file -->
<script type="text/javascript"
	src="https://code.jquery.com/jquery-3.5.1.js">
</script>

<!-- Datatable plugin JS library file -->
<script defer type="text/javascript"
	src="https://cdn.datatables.net/1.10.22/js/jquery.dataTables.min.js"></script>
</head>
<jsp:include page="../common/header.jsp"></jsp:include>
<div class="main-content ">
	<div class="container-fuild">
		<div class="row"></div>
		<div class="row">
			<div class="col-md-12 px-2">
				<div class="row ">
					<table
						class="table table align-middle table-nowrap table-hover table-borderless "
						id="smtpTable">
						<thead>
							<tr>
								<th tabindex="0" aria-label="Name sortable" class="sortable" style="width:25%;">Email Id</th>
								<th tabindex="0" aria-label="Email sortable" class="sortable" style="width:15%;">SMTP Host</th>
								<th tabindex="0" aria-label="Email sortable" class="sortable text-center" style="width:15%;">SMTP Port</th>
								<th tabindex="0" class="sortable text-center" style="width:10%;">Action</th>
							</tr>
						</thead>
						
						<tbody>
							<c:forEach items="${smtp}" var="list">
								<tr>
									<td class="font-size-12 mb-1" style="width:25%;">${list.mailId}</td>
									<td class="font-size-12 mb-1" style="width:15%;">${list.smtpHost}</td>
									<td class="font-size-12 mb-1 text-center" style="width:15%;">${list.smtpPort}</td>
									<td class="font-size-12 mb-1 text-center" style="width:10%;"><a
										href="${pageContext.request.contextPath}/smtp/update/form/${list.id}"
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