

$(document).ready(function() {

	let userAddInputs = document.querySelectorAll('input:not(#alternateEmailId):not(#jobTitle):not(#inputGroupFile01)');
	let userAddButton = document.getElementById('user-add');
	let allSelects = document.querySelectorAll('select:not(#defaultProject)');

		$('select').on('change', function() {
		if (checkAddForUserModul(userInputValidator) && dropdownValidationCheck(allSelects))
			userAddButton.disabled = false;
		else
			userAddButton.disabled = true;
	});

	let userInputValidator = {
	  "firstName": false,
	  "lastName": false,
	  "username": false

	}
	userAddInputs.forEach((input) => {
		input.addEventListener('input', () => {
			let allTrue = checkAddForUserModul(userInputValidator);
			if (allTrue && dropdownValidationCheck(allSelects)) {
				userAddButton.disabled = false;
			} else {
				userAddButton.disabled = true;
			}
		})
	})

	var form = document.getElementById("addUserForm");
	form.addEventListener("submit", function() {
		let dataLength = $('#role').val();
		setTimeout(function() {
			if (dataLength != null) {
				form.reset();
			}
		}, 0);
	});

	$("#delete-button").on('click', function() {
		var resourceUrl = contextPath ;
		$('.profile-pic').attr('src', resourceUrl+'/images/images.png');
		$("#inputGroupFile01").val('');
		$("#user-update").removeAttr("disabled");
		$("#delete-button").attr('disabled', true);
	});

	
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

});




