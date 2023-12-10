
<link rel="stylesheet" href=
"https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/css/bootstrap.min.css"
        integrity=
"sha384-TX8t27EcRE3e/ihU7zmQxVncDAy5uIKz4rEkgIXeMed4M0jlfIDPvg6uqKI2xXr2"
        crossorigin="anonymous">
  
    <!-- Import jquery cdn -->
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"
        integrity=
"sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj"
        crossorigin="anonymous">
    </script>
  <script src="${pageContext.request.contextPath}/js/addCriteria.js"></script>    
    <script src=
"https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/js/bootstrap.bundle.min.js"
        integrity=
"sha384-ho+j7jyWK8fNQe+A12Hb8AhRq26LrZ/JpcUGGOn+Y7RsweNrtN/tE3MoK7ZeZDyx"
        crossorigin="anonymous">
    </script>
<jsp:include page="../common/header.jsp"></jsp:include>
	<div class="container mt-2">

		<!-- Modal -->
		<div class="modal fade" id="addCriteriaModel"
			tabindex="-1"
			aria-labelledby="exampleModalLabel"
			aria-hidden="true">
			
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<h5 class="modal-title"
							id="exampleModalLabel">
							Add Criteria
						</h5>
						
						<button type="button"
							class="close"
							data-dismiss="modal"
							aria-label="Close">
							<span aria-hidden="true"
							onclick="window.location.href='${pageContext.request.contextPath}/tasks?pageNo=0'">
								×
							</span>
						</button>
					</div>

					<div class="modal-body">

					<form action="${pageContext.request.contextPath}/criterias" method="post" class="my-2 p-3" 
				name="addModule">


				<div class="mb-3 row">
					<label for="title" class="col-sm-2 col-form-label ">Name</label>
					<div class="col-sm-10">
						<input type="text" class="form-control form-control-sm"
							placeholder="eg.criterias" name="name" id="title" >
					</div>
				</div>


				<div class="mb-3 row">
					<div class="mx-auto text-center mt-3">
						<button type="button" class="btn btn-secondary btn-sm"
							id="user-cancel" onclick="window.location.href='${pageContext.request.contextPath}/tasks?pageNo=0'">Cancel</button>
						<button type="submit" class="btn btn-primary Pluck-btn btn-sm"
							id="user-add" disabled="disabled">Add</button>
					</div>
				</div>

			</form>
						
					</div>
				</div>
			</div>
		</div>
	</div>
<script type="text/javascript">
    $(window).on('load', function() {
        $('#addCriteriaModel').modal('show');
    });
</script>
