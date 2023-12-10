$(document).ready(function() {

	let projectAddInputs = document.querySelectorAll('#name, #startDate');
	let projectAddButton = document.getElementById('project-add');
	let allSelects = document.querySelectorAll('select:not(#defaultProject)'); 
	let startDateFinal = document.getElementById("startDate");
	let endDateFinal = document.getElementById("lastDate");
	
	$('#lastDate').on('change', function(){
		if(!(endDateFinal.value  <  startDateFinal .value)&&(!endDateFinal.value.length<=0))
			$('#end_date_validation').text("");
	})

	$('select').on('change', function() {
		if(checkAddForProjectModule(projectInputValidator) && dropdownValidationCheck(allSelects))
			 projectAddButton.disabled = false;
		else
			projectAddButton.disabled = true;
	});
	
	let projectInputValidator = {
		"name": false,
		"startDate": false
	}

	projectAddInputs.forEach((input) => {
		input.addEventListener('input', () => {
			let allTrue = checkAddForProjectModule(projectInputValidator);
			if (allTrue && dropdownValidationCheck(allSelects)) {
					projectAddButton.disabled = false;
				} else {
					projectAddButton.disabled = true;
				}
		})
	})
	
	$('#description').on('input', () => {
		if($('#description').val().length < 2048)
			$('#description_error_msg').text("");
		else
			$('#description_error_msg').text("Description should be maximum 2048 charaters");
	})
	
	var form = document.getElementById("addProjectForm");
	form.addEventListener("submit", function() {
	  setTimeout(function() {
		if(!(endDateFinal.value  <  startDateFinal .value)&&(!endDateFinal.value.length<=0)){
			form.reset();
		}
	  }, 0);
	});
	
});




