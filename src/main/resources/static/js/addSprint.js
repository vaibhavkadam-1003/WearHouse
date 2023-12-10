
$(document).ready(function() {
	
	
const durationSelect = document.getElementById('duration');
const startDateInput = document.getElementById('start_date');
const endDateInput = document.getElementById('end_date');

durationSelect.addEventListener('change', function () {
    const selectedOption = durationSelect.value;
    const currentDate = new Date(startDateInput.value || new Date()); // Use the current start date if available

    if (selectedOption === 'Custom') {
        startDateInput.value = '';
        endDateInput.value = '';
        endDateInput.disabled = false;
        
    } else {
        const duration = parseInt(selectedOption);
        if (!isNaN(duration)) {
            // Calculate the end date by adding the number of days (duration * 5) to the current date
            currentDate.setDate(currentDate.getDate() + (duration * 5));
            startDateInput.value = new Date().toISOString().split('T')[0];
            endDateInput.value = currentDate.toISOString().split('T')[0];
            endDateInput.disabled = true; 
        }
    }
});

myForm.addEventListener('submit', function() {
    endDateInput.disabled = false;
});

	let sprintAddInputs = document.querySelectorAll('input');
	let sprintAddButton = document.getElementById('sprint-add');
	
	$('#addSprintModal').modal({ backdrop: 'static', keyboard: false }, 'show');
	
	let sprintInputValidator = {
		"title": false,
		
	}

	sprintAddInputs.forEach((input) => {
		input.addEventListener('input', () => {
			 if (input.type === 'radio' && input.id === 'flexCheckDefault') {
            return;
        }
			let allTrue = checkAdd(sprintInputValidator);
			if (allTrue && $('#duration').val() != null && $('#description').val().length <= 1023) {
				sprintAddButton.disabled = false;
			} else {
				sprintAddButton.disabled = true;
			}
		})
	})

	$('#duration').on('change', function() {
		if ($('#title').val().length >= 2 && $('#description').val().length <= 1023) 
			$('#sprint-add').removeAttr('disabled');
		if ($('#duration').val() > 0) 
			$('#duration_error_message').text("");
	})
	
	$('#description').on('input',() =>{
		if($('#description').val().length >= 1023)
			sprintAddButton.disabled = true;
		else if($('#title').val().length >= 2 && $('#description').val().length <= 1023 && $('#duration').val() != null)
			sprintAddButton.disabled = false;
			
	})
	
	
	

	
});




