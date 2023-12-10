$( document ).ready(function() {
	
	let userUpdateInputs = document.querySelectorAll('input:not(#alternateEmailId):not(#jobTitle):not(#inputGroupFile01):not(#userIdInput)');
	let userUpdateInputsNonMandatory = document.querySelectorAll('input:not(#firstName):not(#lastName):not(#username):not(#contactNumber)');
	let userselect = document.querySelectorAll('select');
	let userUpdateButton = document.getElementById('user-update');
      
	let userInputValidator = {
	  "firstName": true,
	  "lastName": true,
	  "username": true,
	  "contactNumber": true,
	  "role": true
	}

		addEventListener('change', (event) => {
			let role = $('#role').val().length > 0 ? true : false;
			let allTrue = checkMandatoryFields(userUpdateInputs,userInputValidator);
		    if (allTrue && role) 
		      userUpdateButton.disabled = false;
		    else 
		      userUpdateButton.disabled = true;
		    
		})
	
	userUpdateInputs.forEach((input) => {
	  input.addEventListener('input', () => {
		let allTrue = checkMandatoryFields(userUpdateInputs,userInputValidator);
		let role = $('#role').val().length > 0 ? true : false;
	    if (allTrue && role) {
	      userUpdateButton.disabled = false;
	    } else {
	      userUpdateButton.disabled = true;
	    }
	  })
	})
	
	userUpdateInputsNonMandatory.forEach((input) => {
		input.addEventListener('input', () => {
			let inputValLessThanTwo = true;
			userUpdateInputs.forEach((input) => {
				let inputValueLength = input.value.length;
				let role = $('#role').val().length > 0 ? true : false;
				if(inputValueLength <= 2 && role)
					inputValLessThanTwo = false;
			})
			if(inputValLessThanTwo)
			 	userUpdateButton.disabled = false;
			input.addEventListener('blur', () => {
				let inputValLessThanTwoAfterBlur = true;
				userUpdateInputs.forEach((input) => {
				let inputValueLength1 = input.value.length;
				let role = $('#role').val().length > 0 ? true : false;
				if(inputValueLength1 <= 2 && role)
					inputValLessThanTwoAfterBlur = false;
				})
				if(inputValLessThanTwoAfterBlur)
			 		userUpdateButton.disabled = false;
			})
		})
		
	})
	
	const phoneNumberInput = document.querySelector('#countryCode1');
	const iti = window.intlTelInput(phoneNumberInput, {
		initialCountry: 'auto',
		preferredCountries: [],
		separateDialCode: true,
		utilsScript: 'https://cdnjs.cloudflare.com/ajax/libs/intl-tel-input/17.0.8/js/utils.js',
	});

	const contactNumber = document.getElementById('contactNumber');
	const countryCode = document.getElementById('countryCode');

	iti.setNumber("+" + countryCode.value + contactNumber.value);


	phoneNumberInput.addEventListener("change", function() {
		let countryData = iti.getSelectedCountryData();
		let number = iti.getNumber();

		var input = document.getElementById('countryCode');
		var contactNo = number;

		let removeCountryCode = countryData.dialCode.replaceAll("+" + contactNo, '');
		input.value = removeCountryCode;

		var input = document.getElementById('contactNumber');
		var contactNo1 = number;
		let contactNumber = contactNo1.replaceAll("+" + countryData.dialCode, '');
		input.value = contactNumber;
	});

	});
