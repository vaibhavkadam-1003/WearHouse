function sweetAlertMessage(){
	swal({
				position : 'top-end',
				icon : 'warning',
				title : "Please set default project first",
				showConfirmButton : false,
			})
}

function checkAdd(validator) {
	let name = event.target.getAttribute('id');
	if (event.target.value.trim().length >= 2) {
		validator[name] = true;
	} else {
		validator[name] = false;
	};

	let allTrue = Object.keys(validator).every((item) => {
		return validator[item] === true
	});
	return allTrue;
}

function checkAddForUserModul(validator) {
	let name = event.target.getAttribute('id');
	if(name!="role"){
		if (event.target.value.length >= 2) {
		validator[name] = true;
		} else {
			validator[name] = false;
		};
	}

	let allTrue = Object.keys(validator).every((item) => {
		return validator[item] === true
	});
	return allTrue;
}

function checkAddForProjectModule(validator) {
	let name = event.target.getAttribute('id');
	if(name!="owners" && name!="users"){
		if (event.target.value.length >= 2) {
		validator[name] = true;
		} else {
			validator[name] = false;
		};
	}

	let allTrue = Object.keys(validator).every((item) => {
		return validator[item] === true
	});
	return allTrue;
}

function checkUpdate(validator) {
	let name = event.target.getAttribute('id');
	if (event.target.value.length >= 2) {
		validator[name] = true;
	} else {
		validator[name] = false;
	};

	let allTrue = Object.keys(validator).every((item) => {
		return validator[item] === true
	});
	return allTrue;
}

function checkMandatoryFields(validator, validatorObject) {
	//let name = event.target.getAttribute('id');
	for(let field = 0; field < validator.length; field++){
		let name = validator[field];
		if (name.value.length >= 2) {
			validatorObject[field] = true;
		} else {
			validatorObject[field] = false;
		};
	}

	let allTrue = Object.keys(validatorObject).every((item) => {
		return validatorObject[item] === true
	});
	return allTrue;
}

function checkSelectDropdown(selectTag, button) {
	selectTag.forEach((select) => {
		addEventListener('change', (event) => {
			if (event.target.value.length > 0) {
				button.disabled = false;
			} else {
				button.disabled = true;
			};
		})
	});
}

function dropdownValidationCheck(selectTag) {
	let checkForTrue = true;

	for(let selectItem of selectTag){
		if(selectItem.value.length < 1)
			checkForTrue = false
	}
	return checkForTrue;
}


function defaultProjectDropdownValue() {
	document.getElementById('defaultProjectForm').submit();
}

function addProjectValidation() {
	let ownersVal = document.getElementById("owners");
	let usersVal = document.getElementById("users");
	let startDateFinal = document.getElementById("startDate");
	let endDateFinal = document.getElementById("lastDate");
	let projectDescription = document.getElementById("description");
	
	let name = validateCompanyName(document.getElementById('name'), 'name', 'name-validation-id');
	if(!name)
		return false;
	else
		$('#name').val(name);
	
	if( (endDateFinal.value  <  startDateFinal .value)&&(!endDateFinal.value.length<=0)){
		document.getElementById("end_date_validation").textContent = "Last date must be greater than start date";
		return false;
	}else if(projectDescription.value.length >= checkDescription()){
		document.getElementById("description_error_msg").textContent = "Description should be maximum 2048 charaters";
		return false;
	}
	return true;
}

function updateProjectValidation() {
	let projectDescription = document.getElementById("description");
	let startDateFinal = document.getElementById("startDate");
	let endDateFinal = document.getElementById("lastDate");
	
	let name = validateCompanyName(document.getElementById('name'), 'name', 'name-validation-id');
	if(!name)
		return false;
	else
		$('#name').val(name);
		
	if( (endDateFinal.value  <  startDateFinal .value)&&(!endDateFinal.value.length<=0)){
		document.getElementById("end_date_validation").textContent = "Last date must be greater than start date";
		return false;
	}
		
	if(projectDescription.value.length >= checkDescription()){
		document.getElementById("description_error_msg").textContent = "Description should be maximum 2048 charaters";
		return false;
 	}
 	return true;
 }

function addCompanyValidation() {
	let planVal = document.getElementById('subscriptionPlan');
	let typeVal = document.getElementById('subscriptionType');
	let contact = document.getElementById('contact');
	let contactNumber = document.getElementById('contactNumber');
	let alternateWorkPhone = document.getElementById('alternate-work-phone');
	
	let companyName = validateCompanyName(document.getElementById('name'), 'name', 'company-validation-id');
	if(!companyName)
		return false;
	else
		$('#name').val(companyName);	
	
	if (planVal.value == '') {
		document.getElementById("subscriptionplan_error_message").textContent = "Select at least one subscriptionPlan";
		return false;
	}else if (typeVal.value == '') {
		document.getElementById("subscriptiontype_error_message").textContent = "Select at least one subscriptionType";
		return false;
	}else if(contact.value.length < 10 || contact.value.length > 10){
		return false;
	}else if(contactNumber.value.length < 10 || contactNumber.value.length > 10){
		return false;
	}else if(  (alternateWorkPhone.value.length < 10 || alternateWorkPhone.value.length > 10) && (alternateWorkPhone.value.length > 1 ) ){        
		document.getElementById("secondaryPhone-validation-span-id").textContent = "Invalid contact";        
		return false;
	}
	
	let firstName = nameValidate(document.getElementById('firstName'),  'firstName-validation-id');
	if(!firstName)
		return false;
	else
		$('#firstName').val(firstName);
		
	let lastName = nameValidate(document.getElementById('lastName'),  'lastName-validation-id');
	if(!lastName)
		return false;
	else
		$('#lastName').val(lastName);
		
	return true;
}

function updateCompanyValidation(){
	let contact = document.getElementById('contact');
	let alternateWorkPhone = document.getElementById('alternate-work-phone');
	
	let companyName = validateCompanyName(document.getElementById('name1'), 'name', 'company-validation-id');
	if(!companyName)
		return false;
	else
		$('#name1').val(companyName);
		
	
	if(contact.value.length < 10 || contact.value.length > 10){
		return false;
	}else if( (alternateWorkPhone.value.length < 10 || alternateWorkPhone.value.length > 10) && (alternateWorkPhone.value.length > 1 )){
		document.getElementById("secondaryPhone-validation-span-id").textContent = "Invalid contact";
		return false;
	}
	return true;
}

function addUserValidation() {
	let userRole = document.getElementById('role');
	let contactNumber = document.getElementById("contactNumber");
	
	let firstName = nameValidate(document.getElementById('firstName'),  'firstName-validation-id');
	if(!firstName)
		return false;
	else
		$('#firstName').val(firstName);
		
	let lastName = nameValidate(document.getElementById('lastName'),  'lastName-validation-id');
	if(!lastName)
		return false;
	else
		$('#lastName').val(lastName);
	
	
	if (userRole.value ==  '') {
		document.getElementById("user_role_id").textContent = "Please select at least one role";
		return false;
	}else if(contactNumber.value.length > 10 || contactNumber.value.length < 10 ){
		return false;
	}
	return true;
}

function addQuickStoryValidation(){
	if($('#title').val().length > 255){
		$('#title-validation-id').text("Title should be maximum 255 characters");
		return false;
	}
	return true;
}

function checkDescription(){
	return 2048;
}

function loadTable(pageNo, numberOfElements) {

	$('#tableID').DataTable(
		{
			drawCallback: function() {
				if (numberOfElements <= 0) {
					$('.paginate_button.next.disabled',
						this.api().table().container()).on(
							'click', function() {
								$('.paginate_button.next.disabled').attr("disabled");
							});
				}
				else {
					$('.paginate_button.next.disabled',
						this.api().table().container()).on(
							'click', function() {
								$('.paginate_button.next.disabled').attr('href', '?pageNo=' + (pageNo + 1));
							});
				}
				$('.paginate_button.previous.disabled',
					this.api().table().container()).on(
						'click', function() {
							if (pageNo != 0) {
								$('.paginate_button.previous.disabled').attr('href', '?pageNo=' + (pageNo - 1));
							}
					});
			},
			scrollY: '70vh',
			scrollCollapse: true,
			"scrollX": true,
			"bSort": true,
			"bPaginate": true,
			"autoWidth": false,
			"ordering": false,
			dom: '<"top"i>rt<"bottom"flp><"clear">'
		});
	$(".dataTables_scroll , .dataTables_scrollHead, .dataTables_scrollHeadInner,  #tableID").css("width", "100%");
}

function addTaskValidation() {
	if($('#description').val().length >= 5000){
		$('#description-validation-id').text("Description should be maximum 5000 charaters");
		return false
	}
	return true;
}

function addSprintValidation() {
	return !($('#title').val().length >= 45);
}

function filterData(selectedOption) {
  $('#tableID tbody tr.iterativeRow').each(function() {
    const status = $(this).find('.status').text().trim();
    if (selectedOption === 'all' || status.toLowerCase() === selectedOption) {
      $(this).show();
    } else if (selectedOption === 'Active' || status.toLowerCase() === selectedOption) {
      $(this).show();
    } else {
      $(this).hide();
    } 

  });
}

function filterDataForInvitedUser(selectedOption) {
  $('#tableID tbody tr.iterativeRow').each(function() {
    const status = $(this).find('.status').text().trim();
    if (selectedOption === 'all') {
      $(this).show();
    } else if ( status === selectedOption) {
      $(this).show();
    } else {
      $(this).hide();
    } 

  });
}

function checkSignUp(validator) {
	let name = event.target.getAttribute('id');
	if (event.target.value.length >= 0) {
		validator[name] = true;
	} else {
		validator[name] = false;
	};

	let allTrue = Object.keys(validator).every((item) => {
		return validator[item] === true
	});
	return allTrue;
}