<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<script src="https://code.jquery.com/jquery-3.6.1.js"
	integrity="sha256-3zlB5s2uwoUzrXK3BT7AX3FyvojsraNFxCc2vC/7pNI="
	crossorigin="anonymous"></script>

<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/css/bootstrap.min.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/addCompany.css">

<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/js/bootstrap.bundle.min.js"></script>

<link href="${pageContext.request.contextPath}/css/style.css"
	rel="stylesheet">

<jsp:include page="../common/header.jsp"></jsp:include>

<div class="container mt-2">

	<!-- Modal -->
	<div class="modal fade" id="addQuickStoryModal" tabindex="-1"
		aria-labelledby="quickModalLabel" aria-hidden="true">

		<div class="modal-dialog modal-lg">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="quickModalLabel">Status</h5>

					<button type="button" class="close" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true"
							onclick="window.location.href='${pageContext.request.contextPath}/projects/allproject?pageNo=0'">
							× </span>
					</button>
				</div>

				<div class="modal-body">
					<form id="input-form" action="your_controller_url" method="post">
						<div class="row text-center mt-3">
							<h6>Update Your Status</h6>
						</div>
						<div class="row">
							<c:forEach items="${statuses}" var="status">
								<c:if test="${status.company == -1 && status.project == 0}">
									<div class="col-md-4 ">
										<div class="priority-status"
											style="background-color: #c1cb2417; border: 1px solid #c1cb243b;">
											<h5>
												<i class="fa fa-star" aria-hidden="true"
													style="color: #f5968fe8;;"></i> ${status.status}
											</h5>
											<small  style="color: #291a1abd">System Generated</small>
										</div>
									</div>
								</c:if>
							</c:forEach>
						</div>
						<div class="row" id="user-generated-priorities">
							<c:forEach items="${statuses}" var="status">
								<c:if test="${status.company != -1 && status.project != 0}">
									<div class="col-md-4" id="priority-block-${status.id}">
										<div class="priority-status"
											style="background-color: #fbf4de; border: 1px solid #ffdf80;">
											<h5 id="h5severity">
												<i class="fa fa-star" aria-hidden="true"
													style="color: #fda75f;"></i> ${status.status}
											</h5>
											<small>User Generated</small> <i class="fa fa-trash remove" onclick="deleteStatus(${status.id})"
												aria-hidden="true"></i> <i
												class="fa fa-pencil-square-o edit" aria-hidden="true"></i>
										</div>
									</div>
								</c:if>
							</c:forEach>
						</div>
						<div class="row">
							<div class="col-md-4">
								<div class="priority-status text-center" 
										id="add-input-btn"
									style="background-color: #eef5ff; border: 1px solid #cfe2ff;">
									<i class="fa fa-plus mb-2" aria-hidden="true"
										style="color: #6ea8fe;"></i> <br> <small>Add Status</small>
								</div>
							</div>
						</div>
						<div id="input-container" class="row input-container"></div>
						<div class="text-end">
							<input type="submit" value="Submit" disabled="disabled" 
								class="btn btn-primary mt-3 text-end" />
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
	$(window).on('load', function() {
		$('#addQuickStoryModal').modal('show');
	});
</script>
<script type="text/javascript">
	$(document)
			.ready(
					function() {

						$('#add-input-btn')
								.click(
										function() {
											
											$(document).ready(function() {
												
											     $(':input[type="submit"]').prop('disabled', true);
							     				 $('input[type="text"]').keyup(function() {
											     if($(this).val() != '') {
									              $(':input[type="submit"]').prop('disabled', false);
											        }else{
												  $(':input[type="submit"]').prop('disabled', true);
											       }
											     });
												 });
											
											var newInput = $('<div class="row"> <div class="col-md-10 mx-auto py-4 px-4 my-3 border rounded"><h6> Add new Status</h6><input type="text" name="input" id="inputPassword5" class="form-control" aria-describedby="passwordHelpBlock"><div id="passwordHelpBlock" class="form-text">Add Customized Status for your project.</div></div></div>');
											$('#input-container').append(
													newInput);
										});

						$('#input-form')
								.submit(
										function(event) {
											event.preventDefault();

											var inputValues = [];

											$('input[name="input"]')
													.each(
															function() {
																inputValues
																		.push($(
																				this)
																				.val());
															});

											$
													.ajax({
														type : "POST",
														url : "${pageContext.request.contextPath}/dropdownConfiguration/saveStatus",
														data : '{"status":"'
																+ inputValues
																+ '"}',
														contentType : "application/json",
														async : false,
														success : function(
																response) {
															for(let i =0;i<response.length;i++){
																let res = response[i];
																var prio = $('<div class="col-md-4" id="priority-block-'+res.id+'"><div class="priority-status"style="background-color: #fef5ed; border: 1px solid #ffe5d0;"><h5><i class="fa fa-star" aria-hidden="true" style="color: #fd9843;"></i>'+res.status+'</h5><small>User generated</small> <i class="fa fa-trash remove" onclick="deleteStatus('+res.id+')" aria-hidden="true"></i> <i class="fa fa-pencil-square-o edit" aria-hidden="true"></i></div></div>');
																$('#user-generated-priorities').append(prio);
																document.getElementById('input-container').innerHTML="";
															}
															 toastr.success("Status added Successfully");
														},
														error : function(xhr,
																status, error) {
															 toastr.error("Unable to add Status");
														}
													});
											 $(':input[type="submit"]').prop('disabled', true);
										});
					});
	
	 function deleteStatus(id) {
		$.ajax({
			url: '${pageContext.request.contextPath}/dropdownConfiguration/deleteStatus/' + id,
			method: 'GET',
			contentType: 'application/json',
			success: function(result) {
				  if(result === 'Status delete successfully'){
					 toastr.success("Status Deleted Successfully");
					 let elementToRemove = document.getElementById('priority-block-'+id);
					 elementToRemove.remove();
				} 
				 else{
					 toastr.error("Status not Deleted");
				 }
 		}
		});
	}
</script>
<script src="${pageContext.request.contextPath}/js/dropdownConfiguration.js"></script>