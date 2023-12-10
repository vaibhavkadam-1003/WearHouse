$(document).ready(function() {

  let userAddButton = document.getElementById('Scrum-add');

  $('#addScrumModel').modal({ backdrop: 'static', keyboard: false }, 'show');

	
	$('select').on('change', function() {
		let userRole = $('#userRole').val();
		if( userRole === "Project Manager"){
			let checkTeamName = $('#title').val().length >= 2 && $('#title').val().length <= 64 ? true : false;
			if(checkTeamName && $('#add-scrum-project').val() != null )
				 userAddButton.disabled = false;
			else
				userAddButton.disabled = true;
			}else{
				let checkTeamName = $('#title').val().length >= 2 && $('#title').val().length <= 64 ? true : false;
				if(checkTeamName && $('#add-scrum-project').val() != null )
					 userAddButton.disabled = false;
				else
					userAddButton.disabled = true;
			}	
	});
	
	$('#title').on('input', () => {
		let userRole = $('#userRole').val();
		if(userRole === "Project Manager"){
			let checkTeamName = $('#title').val().length >= 2 && $('#title').val().length <= 64 ? true : false;
			if(checkTeamName && $('#add-scrum-project').val() != null )
				 userAddButton.disabled = false;
			else
				userAddButton.disabled = true;
			}else{
				let checkTeamName = $('#title').val().length >= 2 && $('#title').val().length <= 64 ? true : false;
				if(checkTeamName && $('#add-scrum-project').val() != null )
					 userAddButton.disabled = false;
				else
					userAddButton.disabled = true;
			}
	})

})
