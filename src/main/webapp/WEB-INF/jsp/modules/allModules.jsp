<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>

<meta content="initial-scale=1, maximum-scale=1, user-scalable=0"
	name="viewport" />
<meta name="viewport" content="width=device-width" />
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.12.1/css/all.css" crossorigin="anonymous" />


</head>
<body>
	<input type="hidden" id="contextPathInput"
		value="${pageContext.request.contextPath}">
	<jsp:include page="../common/header.jsp"></jsp:include>
	<div class="main-content ">
		<div class="card">
			<div class="card-body">
				<div class="d-flex justify-content-between align-items-center">
					<div>
						<small>All Modules</small>
					</div>
					<button type="button" class="btn btn-sm btn-primary" id="addBtnModel">
							<i class="fa fa-plus"></i> Add
						</button>
				</div>


				<div id="tableContainer" class="my-2" style="height:75vh;">
					<table class="table-new dataTable no-footer" id="tableID"
						style="width: 100% !important;">
						<thead>
							<tr class="text-center">
								<th>Name</th>
								<th>Action</th>
							</tr>
						</thead>
						<tbody class="text-center">
							<c:forEach items="${modules}" var="module">
								<tr class="odd" role="row" id="row${module.id}">
									<td class="d-none" style="width: 25%;">${module.id}</td>
									<td id="moduleNameData-${module.id}" class="moduleNameData"
										style="width: 40%;">${module.name}</td>
									<td><a class="text-success p-2"> <i
											class="fa fa-pencil-square text-primary" aria-hidden="true"
											style="color: #0d6efd !important;"></i> <i
											class="fa-solid fa-trash text-danger me-2"
											onclick="deleteModule(${module.id})"></i>
									</a></td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>
				<div class="modal fade" id="updateModal" tabindex="-1" role="dialog"
					aria-labelledby="exampleModalLabel" aria-hidden="true">
					<div class="modal-dialog" role="document">
						<div class="modal-content">
							<div class="modal-header">
								<h5 class="modal-title" id="exampleModalLabel">Update
									Module</h5>
								 
								
								<button type="button" class="btn fs-4" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
							</div>
							<div class="modal-body"></div>
							<div class="modal-footer">
								<div class="col text-center mt-3 mb-3">
									<button type="button" color="primary"
										class="btn btn-secondary btn-sm " id="closeModalBtn">Cancel</button>
									<button type="button" color="primary"
										class="btn btn-primary Pluck-btn btn-sm " id="updateModuleBtn">Update</button>
								</div>
							</div>
						</div>
					</div>
				</div>
				<!-- Modal -->
				<div class="modal fade" id="addModuleModel" tabindex="-1"
					aria-labelledby="exampleModalLabel" aria-hidden="true">
					<div class="modal-dialog">
						<div class="modal-content">
							<div class="modal-header">
								<h5 class="modal-title" id="exampleModalLabel">Add Module</h5>
								<button type="button" class="btn fs-4" data-dismiss="modal"
									aria-label="Close" id="closeAddModal">
									<span aria-hidden="true">&times;</span>
								</button>
							</div>
							<div class="modal-body">
								<div class="mb-3 row">
									<label for="title" class="col-sm-2 col-form-label ">Name</label>
									<div class="col-sm-10">
										<input type="text" class="form-control form-control-sm"
											placeholder="eg.company" name="name" id="title">
									</div>
								</div>
							</div>
							<div class="modal-footer">
								<div class="mb-3 row">
									<div class="mx-auto text-center mt-3">
										<button type="button" class="btn btn-secondary btn-sm"
											id="addCancelBtn">Cancel</button>
										<button type="submit" class="btn btn-primary Pluck-btn btn-sm"
											id="addBtnModule">Add</button>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>

			</div>
		</div>
	</div>
	<script src="${pageContext.request.contextPath}/js/allModule.js"></script>
	<script type="text/javascript">
	$(window).on('load', function() {
        $('#addModuleModel').modal('show');
    });
</script>
</body>
</html>