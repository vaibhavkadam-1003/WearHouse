$(document).ready(function() {

	let detailedStoryAddInputs = document.querySelectorAll('#title');
	let detailedStoryAddButton = document.getElementById('submit');
	
	let detailedStoryInputValidator = {
		"title": true
	}
	
	addEventListener('change', (event) => {
		let titleCheck = $('#title').val().length >= 2 ? true : false;
	    if (titleCheck) 
	      detailedStoryAddButton.disabled = false;
	    else 
	      detailedStoryAddButton.disabled = true;    
	})
	
	detailedStoryAddInputs.forEach((input) => {
		input.addEventListener('input', () => {
			let allTrue = checkUpdate(detailedStoryInputValidator);
			if (allTrue && $('#description').val().length < 2048) {
				detailedStoryAddButton.disabled = false;
			} else {
				detailedStoryAddButton.disabled = true;
			}
		})
	})
	
	
	$('#title').on('keyup', function(){
		if($('#title').val().length > 255)
			$('#nextBtn').attr('disabled', true);
		else if($('#title').val().length < 2)
			$('#nextBtn').attr('disabled', true);
		else
			 $('#nextBtn').attr('disabled', false);
	})
	
	$('#description').on('keyup', function(){
		if($('#description').val().length >= 2048){
			$('#description-validation-id').text("Description should be maximum 2048 charaters");
			$('#nextBtn').attr('disabled', true);
		}else if($('#description').val().length < 2048 && $('#title').val().length >= 2){
			$('#nextBtn').removeAttr('disabled');
			$('#description-validation-id').text("");
		}
	})	
	
	var select = document.getElementById("storytype");
    for (var i = 0; i < select.options.length; i++) {
        var option = select.options[i];
        option.textContent = option.textContent.charAt(0).toUpperCase() + option.textContent.slice(1).toLowerCase();
    }
	
});
function clearFile() {
  var fileInput = document.getElementById('inputAttachment');
  fileInput.value = ''; // Clear the selected file
}