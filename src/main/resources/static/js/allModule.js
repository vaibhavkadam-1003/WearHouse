
function deleteModule(id) {
	let contextPath = $("#contextPathInput").val();

	$.ajax({
		url: contextPath + '/modules/delete/' + id,
		type: 'DELETE',
		data: {
			moduletId: id
		},
		success: function(data) {
			if (data === 'success') {
				let itemToDelete = document.getElementById('row' + id);
				itemToDelete.remove();
				toastr.success("Module deleted successfully");
			}
			else {
				toastr.error("Unable to delete module")
			}
		},
		error: function(xhr, status, error) {
			console.log(xhr, status, error);
		}
	});
}

$('.fa-pencil-square').on('click', function(event) {
	event.preventDefault();
	var moduleId = $(this).closest('tr').find('td:first-child').text();
	let contextPath = $("#contextPathInput").val();
	$.ajax({
		type: "GET",
		url: `${contextPath}/modules/updateModule/${moduleId}`,
		success: function(response) {
			var modalBody = $('.modal-body');
			modalBody.empty();
			modalBody.append('<input type="text" class="form-control form-control-sm d-none" id="moduleId" name="id" value="' + response.id + '">');
			modalBody.append('<label for="moduleName">Name:</label>');
			modalBody.append('<input type="text" class="form-control form-control-sm" id="moduleName" name="name" value="' + response.name + '">');
			$('#updateModal').modal('show');
		},
		error: function(xhr, textStatus, errorThrown) {
			console.error("Error:", errorThrown);
		}
	});
});

$('#updateModuleBtn').on('click', function() {
	var moduleId = $('#moduleId').val();
	var newName = $('#moduleName').val();

	let contextPath = $("#contextPathInput").val();

	$.ajax({
		type: "PUT",
		url: `${contextPath}/modules/update`,
		data: { id: moduleId, name: newName },
		success: function(response) {
			if(response == ''){
				toastr.error("Module name already exists")
			}
			else{
				var tdToUpdate = $(`#moduleNameData-${moduleId}`);
	        	tdToUpdate.text(newName);
				$('#updateModal').modal('hide');
			}
			
		},
		error: function(xhr, textStatus, errorThrown) {
			console.error("Error:", errorThrown);
		}
	});
});

$('#addBtnModule').on('click', function() {
	var newName = $('#title').val();
	let contextPath = $("#contextPathInput").val();

	$.ajax({
		type: "POST",
		url: `${contextPath}/modules/add`,
		data: { name: newName },
		success: function(response) {
			if(response == ''){
				toastr.error("Module name already exists")
			}
			else {
				$('#addModuleModel').modal('hide'); $('#addModuleModel').modal('hide');
           		 var newRow = `<tr class="odd" role="row" id="row${response.id}">
                            <td class="d-none" style="width: 25%;">${response.id}</td>
                            <td id="moduleNameData-${response.id}" class="moduleNameData" style="width: 40%;">${response.name}</td>
                            <td><a class="text-success p-2"> <i class="fa fa-pencil-square text-primary" aria-hidden="true" style="color: #0d6efd !important;"></i></a>
                            	<i class="fa-solid fa-trash text-danger me-2" onclick="deleteModule(${response.id})"></i>
                            </td>
                            
                         </tr>`;

            $('#tableID tbody').append(newRow);
			}
		},
		error: function(xhr, textStatus, errorThrown) {
			console.error("Error:", errorThrown);
		}
	});
});

$('#closeModal').on('click', function() {
    $('#updateModal').modal('hide');
});

$('#closeModalBtn').on('click', function() {
    $('#updateModal').modal('hide');
});

$('#closeAddModal').on('click', function() {
    $('#addModuleModel').modal('hide');
});

$('#addCancelBtn').on('click', function() {
    $('#addModuleModel').modal('hide');
});

$('#addBtnModel').on('click', function() {
    $('#addModuleModel').modal('show');
});