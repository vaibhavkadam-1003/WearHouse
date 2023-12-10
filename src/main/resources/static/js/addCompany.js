$(document).ready(function() {

	let companyAddInputs = document.querySelectorAll('input:not(#shortName):not(#website):not(#alternate-work-phone):not(#alternate-email)');
	let companyAddButton = document.getElementById('register');
	let allSelects = document.querySelectorAll('select');
		
		let companyInputValidator = {
		"name": false,
		"email": false,
		"firstName": false,
		"lastName": false,
		"username": false,
		
	}
		
		$('select').on('change', function() {
			if(checkAdd(companyInputValidator) && dropdownValidationCheck(allSelects))
				 companyAddButton.disabled = false;
			else
				companyAddButton.disabled = true;
		});
		
	companyAddInputs.forEach((input) => {
		input.addEventListener('input', () => {
			let allTrue = checkAdd(companyInputValidator);
			if (allTrue && dropdownValidationCheck(allSelects)) {
				companyAddButton.disabled = false;
			} else {
				companyAddButton.disabled = true;
			}
		})
	})
	
	const phoneNumberInput = document.querySelector('#countryCode');
	const iti = window.intlTelInput(phoneNumberInput, {
		initialCountry: 'auto',
		preferredCountries: [],
		separateDialCode: true,
		utilsScript: 'https://cdnjs.cloudflare.com/ajax/libs/intl-tel-input/17.0.8/js/utils.js',

	});

	phoneNumberInput.addEventListener("change", function() {

		let countryData = iti.getSelectedCountryData();
		let number = iti.getNumber();

		var input = document.getElementById('countryCode1');
		var contactNo = number;

		let removeCountryCode = countryData.dialCode.replaceAll("+" + contactNo, '');
		input.value = removeCountryCode;
 
        var input = document.getElementById('contactNumber');
		var contactNo1 = number;
        let contactNumber = contactNo1.replaceAll("+" + countryData.dialCode, '');
		input.value = contactNumber;

	});
	 
	iti.setCountry("in");

   const phoneNumberInput1 = document.querySelector('#countryCode2');
	const iti1 = window.intlTelInput(phoneNumberInput1, {
		initialCountry: 'in',
		preferredCountries: [],
		separateDialCode: true,
		utilsScript: 'https://cdnjs.cloudflare.com/ajax/libs/intl-tel-input/17.0.8/js/utils.js',

	});

	phoneNumberInput1.addEventListener("change", function() {

		let countryData = iti1.getSelectedCountryData();
		let number = iti1.getNumber();

		var input = document.getElementById('countryCodeForWorkPhone');
		var contactNo = number;

		let removeCountryCode = countryData.dialCode.replaceAll("+" + contactNo, '');
		input.value = removeCountryCode;
 
        var input = document.getElementById('contact');
		var contactNo1 = number;
        let contactNumber = contactNo1.replaceAll("+" + countryData.dialCode, '');
		input.value = contactNumber;
   
   
   
	});
 
 const phoneNumberInput2 = document.querySelector('#countryCode3');
	const iti2 = window.intlTelInput(phoneNumberInput2, {
		initialCountry: 'in',
		preferredCountries: [],
		separateDialCode: true,
		utilsScript: 'https://cdnjs.cloudflare.com/ajax/libs/intl-tel-input/17.0.8/js/utils.js',

	});

	phoneNumberInput1.addEventListener("change", function() {

		let countryData = iti2.getSelectedCountryData();
		let number = iti2.getNumber();

		var input = document.getElementById('countryCodeForAlternatePhone');
		var contactNo = number;

		let removeCountryCode = countryData.dialCode.replaceAll("+" + contactNo, '');
		input.value = removeCountryCode;
 
        var input = document.getElementById('alternatePhone');
		var contactNo1 = number;
        let contactNumber = contactNo1.replaceAll("+" + countryData.dialCode, '');
		input.value = contactNumber;
   
   
   
	});

	
});