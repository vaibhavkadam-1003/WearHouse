$(document).ready(function() {

	let quickStoryAddInputs = document.querySelectorAll('#title');
	let quickStoryAddButton = document.getElementById('quickStory-add');
	
	$('#addQuickStoryModal').modal({backdrop: 'static', keyboard: false}, 'show');
	
	quickStoryAddInputs.forEach((input) => {
		input.addEventListener('input', () => {
			let titleCheck = $('#title').val().length >= 2 ? true : false;
			if ((titleCheck && $('#description').val().length < 2048)) {
				quickStoryAddButton.disabled = false;
			} else {
				quickStoryAddButton.disabled = true;
			}
		})
	})
		
	$('#description').on('keyup', function(){
		if($('#description').val().length >= 2048){
			$('#description-validation-id').text("Description should be maximum 2048 charaters");
			$('#quickStory-add').attr('disabled', true);
		}else if(($('#description').val().length < 2048 && $('#description').val().length > 2 ) && ($('#title').val().length >=2)){
			$('#quickStory-add').removeAttr('disabled');
			$('#description-validation-id').text("");
		}else 
			$('#description-validation-id').text("");
	})
	
	let form = document.getElementById("addQuickStoryForm");
	form.addEventListener("submit", function() {
	  setTimeout(function() {
			quickStoryAddButton.disabled = true;
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
