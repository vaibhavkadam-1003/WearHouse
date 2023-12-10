
$(document).ready(function() {

	let signUpInputs = document.querySelectorAll('input');
	let signUpSubmitButton = document.getElementById('signUp-add');

	let signUpInputValidator = {
		"firstName": false,
		"lastName": false,
		"username": false,
		"companyId": false,
	}
	signUpInputs.forEach((input) => {
		input.addEventListener('input', () => {
			let allTrue = checkSignUp(signUpInputValidator);
			if (allTrue) {
				signUpSubmitButton.disabled = false;
			} else {
				signUpSubmitButton.disabled = true;
			}
		})
	})

	var form = document.getElementById("signUpForm");
	form.addEventListener("submit", function() {
		setTimeout(function() {
			form.reset();
		}, 0);
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




