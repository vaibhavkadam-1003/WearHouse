$( document ).ready(function() {
	
	let companyUpdateInputs = document.querySelectorAll('input:not(#shortName):not(#website):not(#alternate-work-phone):not(#alternateEmail):not(#id):not(#maxUsers):not(#subscriptionRate)');
	let companyUpdateInputsNonMandatory = document.querySelectorAll('input:not(#name1):not(#contact):not(#email):not(#id):not(#maxUsers):not(#subscriptionRate)');
	let companyUpdateButton = document.getElementById('register');
	let companySelect = document.querySelectorAll('select');
      
	const companyInputValidator = {
	  "name": true,
	  "contact": true,
	  "email": true
	}

	//let dropdownSelected = dropdownValidationCheck(companySelect); 
	addEventListener('change', (event) => {
		let allTrue = checkMandatoryFields(companyUpdateInputs,companyInputValidator);
	    if (allTrue && dropdownValidationCheck(companySelect)) 
	      companyUpdateButton.disabled = false;
	    else 
	      companyUpdateButton.disabled = true;
	    
	})

	companyUpdateInputs.forEach((input) => {
		console.log(input);
	  input.addEventListener('input', () => {
		let allTrue = checkMandatoryFields(companyUpdateInputs,companyInputValidator);
	    if (allTrue) {
	      companyUpdateButton.disabled = false;
	    } else {
	      companyUpdateButton.disabled = true;
	    }
	  })
	})
	
	companyUpdateInputsNonMandatory.forEach((input) => {
		input.addEventListener('input', () => {
			let inputValLessThanTwo = true;
			companyUpdateInputs.forEach((input) => {
				let inputValueLength = input.value.length;
				if(inputValueLength <= 2)
					inputValLessThanTwo = false;
				})
				if(inputValLessThanTwo)
				 	companyUpdateButton.disabled = false;
			 
			input.addEventListener('blur', () => {
				let inputValLessThanTwoAfterBlur = true;
				companyUpdateInputs.forEach((input) => {
				let inputValueLength = input.value.length;
				if(inputValueLength <= 2)
					inputValLessThanTwoAfterBlur = false;
				})
				if(inputValLessThanTwoAfterBlur)
				 	companyUpdateButton.disabled = false;
			 //companyUpdateButton.disabled = false;
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

	const contactNumber = document.getElementById('contact');
	const countryCode = document.getElementById('countryCode');

	iti.setNumber("+" + countryCode.value + contactNumber.value);

	phoneNumberInput.addEventListener("change", function() {
		let countryData = iti.getSelectedCountryData();
		let number = iti.getNumber();

		var input = document.getElementById('countryCode');
		var contactNo = number;

		let removeCountryCode = countryData.dialCode.replaceAll("+" + contactNo, '');
		input.value = removeCountryCode;

		var input = document.getElementById('contact');
		var contactNo1 = number;
		let contactNumber = contactNo1.replaceAll("+" + countryData.dialCode, '');
		input.value = contactNumber;
	});

	const phoneNumberInput1 = document.querySelector('#countryCode2');
	const iti1 = window.intlTelInput(phoneNumberInput1, {
		initialCountry: 'auto',
		preferredCountries: [],
		separateDialCode: true,
		utilsScript: 'https://cdnjs.cloudflare.com/ajax/libs/intl-tel-input/17.0.8/js/utils.js',
	});

	const contactNumber2 = document.getElementById('alternatePhone');
	const countryCode2 = document.getElementById('countryCode3');

	iti1.setNumber("+" + countryCode2.value + contactNumber2.value);

	phoneNumberInput1.addEventListener("change", function() {
		let countryData = iti1.getSelectedCountryData();
		let number = iti1.getNumber();

		var input1 = document.getElementById('countryCode3');
		var contactNo = number;

		let removeCountryCode = countryData.dialCode.replaceAll("+" + contactNo, '');
		input1.value = removeCountryCode;

		var input1 = document.getElementById('alternatePhone');
		var contactNo1 = number;
		let contactNumber = contactNo1.replaceAll("+" + countryData.dialCode, '');
		input1.value = contactNumber;
	});

});