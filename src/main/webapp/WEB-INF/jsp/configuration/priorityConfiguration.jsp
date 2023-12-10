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
					<h5 class="modal-title" id="quickModalLabel">Priority</h5>

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
							<h6>Update Your Priority</h6>
						</div>
						<div class="row">
							<c:forEach items="${priorities}" var="priority">
								<c:if test="${priority.company == -1 && priority.project == 0}">
									<div class="col-md-4 ">
										<div class="priority-status"
											style="background-color: #fff2f3; border: 1px solid #f8d7da;">
											<h5>
												<i class="fa fa-star" aria-hidden="true"
													style="color: #ea868f;"></i> ${priority.priority}
											</h5>
											<small>System Generated</small>
										</div>
									</div>
								</c:if>
							</c:forEach>
						</div>
						<div class="row" id="user-generated-priorities">
							<c:forEach items="${priorities}" var="priority">
								<c:if test="${priority.company != -1 && priority.project != 0}">
									<div class="col-md-4" id="priority-block-${priority.id}">
										<div class="priority-status"
											style="background-color: #fef5ed; border: 1px solid #ffe5d0;">
											<h5>
												<i class="fa fa-star" aria-hidden="true"
													style="color: #fd9843;"></i> ${priority.priority}
											</h5>
											<small>User Generated</small> <i class="fa fa-trash remove" onclick="deletePriority(${priority.id})"
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
										style="color: #6ea8fe;"></i> <br> <small>Add Priority</small>
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
											
											var newInput = $('<div class="row"> <div class="col-md-10 mx-auto py-4 px-4 my-3 border rounded"><h6> Add new Priority</h6><input type="text" name="input" id="inputPassword5" class="form-control" aria-describedby="passwordHelpBlock"><div id="passwordHelpBlock" class="form-text">Add Customized Priority for your project.</div></div></div>');
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
														url : "${pageContext.request.contextPath}/dropdownConfiguration/save",
														data : '{"priority":"'
																+ inputValues
																+ '"}',
														contentType : "application/json",
														async : false,
														success : function(
																response) {
															for(let i =0;i<response.length;i++){
																let res = response[i];
																var prio = $('<div class="col-md-4" id="priority-block-'+res.id+'"><div class="priority-status"style="background-color: #fef5ed; border: 1px solid #ffe5d0;"><h5><i class="fa fa-star" aria-hidden="true" style="color: #fd9843;"></i>'+res.priority+'</h5><small>User generated</small> <i class="fa fa-trash remove" onclick="deletePriority('+res.id+')" aria-hidden="true"></i> <i class="fa fa-pencil-square-o edit" aria-hidden="true"></i></div></div>');
																$('#user-generated-priorities').append(prio);
																document.getElementById('input-container').innerHTML="";
															}
																toastr.success("Priority added Successfully");
														},
														error : function(xhr,
																status, error) {
																toastr.error("Unable to add Priority");
														}
													});
											$(':input[type="submit"]').prop('disabled', true);
										});
						
					});
    

	function deletePriority(id) {
		$.ajax({
			url: '${pageContext.request.contextPath}/dropdownConfiguration/' + id,
			method: 'GET',
			contentType: 'application/json',
			success: function(result) {
				 if(result === 'Priority deleted successfully'){
					 toastr.success("Priority Deleted Successfully");
					 let elementToRemove = document.getElementById('priority-block-'+id);
					 elementToRemove.remove();
				} 
				 else{
					 toastr.error("Priority not Deleted");
				 }
			}
		});
	}
</script>
<script src="${pageContext.request.contextPath}/js/dropdownConfiguration.js"></script>