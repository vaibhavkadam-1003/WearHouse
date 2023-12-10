$(document).ready(function() {

	let detailedStoryAddInputs = document.querySelectorAll('input');
	let detailedStoryAddButton = document.getElementById('nextBtn');
	
	let detailedStoryInputValidator = {
		"title": false
	}
	
	$('#title').on('keyup',function(){
		if($('#title').val().length < 2 || $('#title').val().length > 255 )
			$('#nextBtn').attr('disabled', true);
	})
	
	detailedStoryAddInputs.forEach((input) => {
		input.addEventListener('input', () => {
			let allTrue = checkAdd(detailedStoryInputValidator);
			if (allTrue && $('#description').val().length < 2048) {
				detailedStoryAddButton.disabled = false;
			} else {
				detailedStoryAddButton.disabled = true;
			}
		})
	})
	
	$('#description').on('keyup', function(){
		if($('#description').val().length >= 2048){
			$('#description-validation-id').text("Description should be maximum 2048 charaters");
			$('#nextBtn').attr('disabled', true);
		}else if($('#description').val().length < 2048 && $('#title').val().length >= 2 && $('#assignedTo').val() != null && $('#StoryPoint').val() != null){
			$('#nextBtn').removeAttr('disabled');
			$('#description-validation-id').text("");
		}else if($('#description').val().length < 2048 && $('#title').val().length >= 2)
			$('#description-validation-id').text("");
	})
	
	let form = document.getElementById("regForm");
	form.addEventListener("submit", function() {
	  setTimeout(function() {
			detailedStoryAddButton.disabled = true;
	    	form.reset();
	  }, 0);
	});
	
});

function showStoryTable(){
	document.getElementById('story-point-table').style.display="block";
}
function hideStoryPointTable(){
	document.getElementById('story-point-table').style.display="none";
}

function clearFile() {
  var fileInput = document.getElementById('inputAttachment');
  fileInput.value = ''; // Clear the selected file
}