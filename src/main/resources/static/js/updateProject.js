$( document ).ready(function() {
	
	let projectUpdateInputs = document.querySelectorAll('#name, #startDate');
	let projectUpdateInputsNonMandatory = document.querySelectorAll('#lastDate, #description');
	let projectUpdateButton = document.getElementById('project-update');
	let userCheckBoxes = document.querySelectorAll('input[identifier="user-identifier"]')
	let ownercheckBoxes = document.querySelectorAll('input[identifier="owner-identifier"]');
				
	let projectInputValidator = {
	  "name": true,
	  "startDate": true,
	  "status":true
	}
	
	$('#lastDate').on('change', function(){
		if($('#lastDate').val() >= $('#startDate').val())
			$('#end_date_validation').text("");
	})
	
	addEventListener('change', (event) => {
		let allTrue = checkMandatoryFields(projectUpdateInputs,projectInputValidator);
	    if (allTrue) 
	      projectUpdateButton.disabled = false;
	    else 
	      projectUpdateButton.disabled = true; 
	})
	
	projectUpdateInputs.forEach((input) => {
	  input.addEventListener('input', () => {
		let allTrue = checkMandatoryFields(projectUpdateInputs,projectInputValidator);
	    if (allTrue) {
	      projectUpdateButton.disabled = false;
	    } else {
	      projectUpdateButton.disabled = true;
	    }
	  })
	})

	projectUpdateInputsNonMandatory.forEach((input) => {
		input.addEventListener('input', () => {
			let inputValLessThanTwo = true;
			projectUpdateInputs.forEach((input) => {
				let inputValueLength = input.value.length;
				if(inputValueLength <= 2)
					inputValLessThanTwo = false;
				})
				if(inputValLessThanTwo)
				 	projectUpdateButton.disabled = false;
			 
			input.addEventListener('blur', () => {
				let inputValLessThanTwoAfterBlur = true;
				projectUpdateInputs.forEach((input) => {
				let inputValueLength = input.value.length;
				if(inputValueLength <= 2)
					inputValLessThanTwoAfterBlur = false;
				})
				if(inputValLessThanTwoAfterBlur)
				 	projectUpdateButton.disabled = false;
			})
		})
		
	})
	
	$('#description').on('input', () => {
		if($('#description').val().length < 2048)
			$('#description_error_msg').text("");
		else
			$('#description_error_msg').text("Description should be maximum 2048 charaters");
	})

	//user
	$(".checkbox").on('change', function() {
			if(!$('input.checkbox:checked').length == 0 ){
				$(".remove").removeAttr('disabled');
			}
			if($('input.checkbox:checked').length == userCheckBoxes.length ){
				$('.remove').prop('disabled', $('input.checkbox:checked'));
			}
			if(!$('input.checkbox:checked').length == 1 ){
				$('.remove').prop('disabled', $('input.checkOwner:checked'));
			}
		})	
	
	//owner
	$(".checkOwner").on('change', function() {
			if(!$('input.checkOwner:checked').length == 0 ){
				$(".removeOwner").removeAttr('disabled');
			}
			if($('input.checkOwner:checked').length == ownercheckBoxes.length ){
				$('.removeOwner').prop('disabled', $('input.checkOwner:checked'));
			}
			if(!$('input.checkOwner:checked').length == 1 ){
				$(".removeOwner").prop('disabled', $('input.checkOwner:checked'));
			}
			
		})	
	
	//OwnerAddButtonCode
	$(".addOwner").on('change', function() {
		if(!$('input.addOwner:checked').length == 0 ){
				$("#addOwnerBtn").removeAttr('disabled');
			}
			if(!$('input.addOwner:checked').length == 1 ){
				$("#addOwnerBtn").prop('disabled', $('input.addOwner:checked'));
			}
	})
	
	//UserAddButtonCode
	$(".addUser").on('change', function() {
		if(!$('input.addUser:checked').length == 0 ){
				$("#addUserBtn").removeAttr('disabled');
			}
			if(!$('input.addUser:checked').length == 1 ){
				$("#addUserBtn").prop('disabled', $('input.addUser:checked'));
			}
	})
	
	$('#myInput').on('keyup', function() {
		var searchText = $(this).val().toLowerCase().trim();
		var found = false;

		$('.user-info').each(function() {
			var cardTitle = $(this).find('.b').text().toLowerCase().trim();

			if (cardTitle.includes(searchText)) {
				$(this).show();
				found = true;
			} else {
				$(this).hide();
			}
		});

		if (!found) {
			$('#noUsersFoundMessages').show();
		} else {
			$('#noUsersFoundMessages').hide();
		}
	});
	
	
	$('#myUsers').on('keyup', function() {
		var searchText = $(this).val().toLowerCase().trim();
		var found = false;

		$('.user-list').each(function() {
			var cardTitle = $(this).find('.btag').text().toLowerCase().trim();

			if (cardTitle.includes(searchText)) {
				$(this).show();
				found = true;
			} else {
				$(this).hide();
			}
		});

		if (!found) {
			$('#noUsersFoundMessage').show();
		} else {
			$('#noUsersFoundMessage').hide();
		}
	});

});







