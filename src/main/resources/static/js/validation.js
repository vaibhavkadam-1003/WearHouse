var companyNamePattern = /(?=.*[a-zA-Z_ ])([a-zA-Z0-9_ ]+)$/
var emailID = /^(d*[a-zA-Z]{1,}\d*)([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$/;
var name_regex = /^[A-Za-z ]*$/;
var usNo = /^\(?([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$/;
var websitePattern = (/^(http(s)?:\/\/)[\w.-]+(?:\.[\w\.-]+)+[\w\-\._~:/?#[\]@!\$&'\(\)\*\+,;=.]+$/);
var sprintNamePattern = /^[`! @#$%^&*()_+\-=\[\]{};':"\\|,. <>\/?~\d]*$/g;
var companyIdPattern = (/^[0-9]+$/);
function nameValidate(node, spanIdName) {

	const name = node.value.trim();

	$('#' + spanIdName).empty();
	$('#' + spanIdName).removeClass('fa fa-exclamation-triangle');
	if (name.length > 0) {
		if (!name.match(name_regex)) {
			$('#' + spanIdName).empty();
			$('#' + spanIdName).css("color", "red").css("font-size", "0.8rem");
			$('#' + spanIdName).append(
				' <span> Please Enter Valid data' + '</span>');
			return "";
		}
		else if (name.length < 2) {
			$('#' + spanIdName).css("color", "red").css("font-size", "0.8rem");
			$('#' + spanIdName).append(
				' <span> Too short!' + '</span>');
			return "";
		}
		if(node.id == 'firstName' && name.length > 16){
			$('#' + spanIdName).css("color", "red").css("font-size", "0.8rem");
		    $('#' + spanIdName).append(
		        ' <span>Too long!' + '</span>');
		    return "";
		}
		if(node.id == 'lastName' && name.length > 24){
			$('#' + spanIdName).css("color", "red").css("font-size", "0.8rem");
		    $('#' + spanIdName).append(
		        ' <span>Too long!' + '</span>');
		    return "";
		}
		if(node.id == 'shortName' && name.length > 16){
			$('#' + spanIdName).css("color", "red").css("font-size", "0.8rem");
		    $('#' + spanIdName).append(
		        ' <span>Too long!' + '</span>');
		    return "";
		}
		
		$('#' + spanIdName).empty();
		$('#' + spanIdName).removeClass('fa fa-exclamation-triangle');
		return name;

	}
	if(node.id != 'shortName'){
		$('#' + spanIdName).css("color", "red").css("font-size", "0.8rem");
		$('#' + spanIdName).append(' <span>Cannot be blank' + '</span>');
		return "";
	}
	return "";
}

function validateCompanyName(node, displayValue, spanId) {
	
	const name = node.value.trim();
	$('#' + spanId).empty();
	if (name.length > 0) {
		if (name.length <= 1) {
			$('#' + spanId).css("color", "red").css("font-size", "0.8rem");
			$('#' + spanId).append(
				' <span> Too short!' + '</span>');
			return "";
		}
		else if (name.length > 64 ) {
			$('#' + spanId).css("color", "red").css("font-size", "0.8rem");
			$('#' + spanId).append(
				' <span>Too long!' + '</span>');
			return "";
		}
		else if (!name.match(companyNamePattern)) {
			$('#' + spanId).empty();
			$('#' + spanId).css("color", "red").css("font-size", "0.8rem");
			$('#' + spanId).append(
				' <span> Please Input Valid ' + displayValue + '</span>');
			return "";
		}
		$('#' + spanId).empty();
		return name;
	}
	$('#' + spanId).css("color", "red").css("font-size", "0.8rem");
	$('#' + spanId).append(
		' <span>Cannot be blank' + '</span>');
	return "";
}


function validateEmail(node, displayValue, spanIdName) {

	const email = node.value.trim();

	$('#' + spanIdName).empty();
	if (email.match(emailID) || email == "") {
		$('#' + spanIdName).empty();
		return email;
	}
	else if (email.length < 2) {
		$('#' + spanIdName).css("color", "red").css("font-size", "0.8rem");
		$('#' + spanIdName).append(
			' <span> Too short!' + '</span>');
		return "";
	}
	else if (email.length > 50) {
		$('#' + spanIdName).css("color", "red").css("font-size", "0.8rem");
		$('#' + spanIdName).append(
			' <span> Too long!' + '</span>');
		return "";
	}
	else {
		$('#' + spanIdName).empty();
		$('#' + spanIdName).css("color", "red").css("font-size", "0.8rem");
		$('#' + spanIdName).append(
			' <span> Invalid email ' + '</span>');
		$('#alreadyExistingRegularEmailID-validation-span-id').empty();
		return "";
	}
	$('#' + spanIdName).empty();
	$("input").removeClass("mande")
	return email;
}

function validateSecondaryEmail(node, displayValue, spanIdName) {

	const secondaryEmail = node.value.trim();

	if (secondaryEmail.length > 64) {
		$('#' + spanIdName).empty();
		$('#' + spanIdName).css("color", "red").css("font-size", "0.8rem");
		$('#' + spanIdName)
			.append(
				' <span> Enter valid Alternate email id</span>');
		secondaryEmail.substring(0, 63);
		return "";
	}
	if (secondaryEmail.match(emailID) || secondaryEmail == "") {

		$('#' + spanIdName).empty();
		$('#' + spanIdName).css("color", "red").css("font-size", "0.8rem");
		return secondaryEmail;
	} else {
		$('#' + spanIdName).empty();
		$('#' + spanIdName).css("color", "red").css("font-size", "0.8rem");
		$('#' + spanIdName).append(
			' <span> Please Input Valid ' + displayValue + '</span>');
		return "";
	}
	$('#' + spanIdName).empty();
	$('#' + spanIdName).css("color", "red").css("font-size", "0.8rem");

	return secondaryEmail;
}

function validatePhone(node, spanId) {

	const contact = node.value.trim();

	$('#' + spanId).empty();
	if (contact.length > 0) {
		$('#' + spanId).empty();

		if (!contact.match(usNo)) {
			$('#' + spanId).css("color", "red").css("font-size", "0.8rem");
			$('#' + spanId).append(
				' <span> Invalid contact' + '</span>');
			return "";
		}
		$('#' + spanId).empty();
		return contact;
	}
	$('#' + spanId).css("color", "red").css("font-size", "0.8rem");
	$('#' + spanId).append(
		' <span>Please Enter Your Contact' + '</span>');
	return "";
}

function validateSecondaryPhone(node, spanId) {

	const secondaryContact = node.value.trim();

	if (secondaryContact.match(usNo) || secondaryContact == "") {
		$('#' + spanId).empty();
		return secondaryContact;
	} else {
		$('#' + spanId).empty();
		$('#' + spanId).css("color", "red").css("font-size", "0.8rem");
		$('#' + spanId).append(
			' <span> Invalid contact' + '</span>');
		return "";
	}
	$('#' + spanId).empty();
	return secondaryContact;
}


function validateWebsite(node, displayValue, spanIdName) {

	const website = node.value.trim();

	if (website == "") {
		$('#' + spanIdName).empty();
		return website;
	}else if (website.length > 64) {
			$('#' + spanIdName).css("color", "red").css("font-size", "0.8rem");
			$('#' + spanIdName).append(
				' <span> Too long!' + '</span>');
			return "";
	} else if (!websitePattern.test(website)) {
		$('#' + spanIdName).empty();
		$('#' + spanIdName).css("color", "red").css("font-size", "0.8rem");
		$('#' + spanIdName).append(' <span>Enter valid website</span>');
		$(".website").val(" ");
		website.substring(0, 44);
		return "";
	} else {

		$('#' + spanIdName).empty();
		return website;
	}
}

function validateJobTitle(node, spanIdName) {

	const jobTitle = node.value.trim();

	$('#' + spanIdName).empty();
	if (jobTitle.length > 0) {
		if (jobTitle.length < 2) {
			$('#' + spanIdName).css("color", "red").css("font-size", "0.8rem");
			$('#' + spanIdName).append(
				' <span> Too short!' + '</span>');
			return "";
		}
		else if (jobTitle.length > 32) {
			$('#' + spanIdName).css("color", "red").css("font-size", "0.8rem");
			$('#' + spanIdName).append(
				' <span>Too long!' + '</span>');
			return "";
		}
		else if (!jobTitle.match('^[A-Za-z0-9 _]*[A-Za-z0-9][A-Za-z0-9 _]*$')) {
			$('#' + spanIdName).empty();
			$('#' + spanIdName).css("color", "red").css("font-size", "0.8rem");
			$('#' + spanIdName).append(
				' <span> Please Enter Valid data' + '</span>');
			return "";
		}
		$('#' + spanIdName).empty();
		return jobTitle;
	}
	return "";

}

function validateUsername(node, displayValue, spanIdName) {

	const username = node.value.trim();

	$('#' + spanIdName).empty();
	if (username.length > 0) {

		if (username.length < 2) {
			$('#' + spanIdName).css("color", "red").css("font-size", "0.8rem");
			$('#' + spanIdName).append(
				' <span> Too short!' + '</span>');
			return "";
		}
		else if (username.length > 64 ) {
			$('#' + spanIdName).css("color", "red").css("font-size", "0.8rem");
			$('#' + spanIdName).append(
				' <span> Too long!' + '</span>');
			return "";
		}
		else if (!username.match(emailID)) {
			$('#' + spanIdName).empty();
			$('#' + spanIdName).css("color", "red").css("font-size", "0.8rem");
			$('#' + spanIdName).append(
				' <span>Invalid' + displayValue + '</span>');
			$('#alreadyExistingRegularEmailID-validation-span-id').empty();
			return "";
		}
		$('#' + spanIdName).empty();
		return username;
	}
	$('#' + spanIdName).css("color", "red").css("font-size", "0.8rem");
	$('#' + spanIdName).append(
		' <span>Please Enter Your Email Id' + '</span>');
	return "";

}

function validateSprint(node, spanIdName) {

	const name = node.value.trim();

	$('#' + spanIdName).empty();
	
	if (name.length > 0) {

		 if (name.length < 2) {
			$('#' + spanIdName).css("color", "red").css("font-size", "0.8rem");
			$('#' + spanIdName).append(
				' <span> Too short!' + '</span>');
			return "";
		}
		else if(name.length > 16){
			$('#' + spanIdName).css("color", "red").css("font-size", "0.8rem");
		    $('#' + spanIdName).append(
		        ' <span>Too long!' + '</span>');
		    return "";
		}	
		else if (name.match(sprintNamePattern)) {
			$('#' + spanIdName).empty();
			$('#' + spanIdName).css("color", "red").css("font-size", "0.8rem");
			$('#' + spanIdName).append(
				' <span> Please Enter Valid data' + '</span>');
			return "";
		}
		$('#' + spanIdName).empty();
		return name;
	}
		$('#' + spanIdName).css("color", "red").css("font-size", "0.8rem");
		$('#' + spanIdName).append(' <span>Cannot be blank' + '</span>');
		return "";
}

function validateTask(node, spanIdName) {

	const name = node.value.trim();

	$('#' + spanIdName).empty();
	
	if (name.length > 0) {

		 if (name.length < 2) {
			$('#' + spanIdName).css("color", "red").css("font-size", "0.8rem");
			$('#' + spanIdName).append(
				' <span> Too short!' + '</span>');
			return "";
		}
		else if(name.length > 255){
			$('#' + spanIdName).css("color", "red").css("font-size", "0.8rem");
		    $('#' + spanIdName).append(
		        ' <span>Too long!' + '</span>');
		    return "";
		}	
		else if (name.match(sprintNamePattern)) {
			$('#' + spanIdName).empty();
			$('#' + spanIdName).css("color", "red").css("font-size", "0.8rem");
			$('#' + spanIdName).append(
				' <span> Please Enter Valid data' + '</span>');
			return "";
		}
		$('#' + spanIdName).empty();
		$("#update").submit();	
		return name;
	}
		$('#' + spanIdName).css("color", "red").css("font-size", "0.8rem");
		$('#' + spanIdName).append(' <span>Title Cannot be blank' + '</span>');
		return "";
}

function titleValidate(node, spanIdName){
	const title = node.value.trim();
	$('#' + spanIdName).empty();
	$('#' + spanIdName).removeClass('fa fa-exclamation-triangle');
	if (title.length > 0) {
		if (title.length < 2) {
			$('#' + spanIdName).css("color", "red").css("font-size", "0.8rem");
			$('#' + spanIdName).append(
				' <span> Too short!' + '</span>');
			return "";
		}else if (title.length > 255) {
			$('#' + spanIdName).css("color", "red").css("font-size", "0.8rem");
			$('#' + spanIdName).append(
				' <span> Too long!' + '</span>');
			return "";
		}
			$('#' + spanIdName).empty();
			$('#' + spanIdName).removeClass('fa fa-exclamation-triangle');
			return title;
	}
		$('#' + spanIdName).css("color", "red").css("font-size", "0.8rem");
		$('#' + spanIdName).append(' <span>Cannot be blank' + '</span>');
		return "";
}

function validateInviteUsername(node, displayValue, spanIdName) {

	const username = node.value.trim();

	$('#' + spanIdName).empty();
	if (username.length > 0) {

		if (username.length < 2) {
			$('#' + spanIdName).css("color", "red").css("font-size", "0.8rem");
			$('#' + spanIdName).append(
				' <span> Too short!' + '</span>');
			return "";
		}
		else if (username.length > 64 ) {
			$('#' + spanIdName).css("color", "red").css("font-size", "0.8rem");
			$('#' + spanIdName).append(
				' <span> Too long!' + '</span>');
			return "";
		}
		else if (!username.match(emailID)) {
			$('#' + spanIdName).empty();
			$('#' + spanIdName).css("color", "red").css("font-size", "0.8rem");
			$('#' + spanIdName).append(
				' <span>Invalid' + displayValue + '</span>');
			$('#alreadyExistingRegularEmailID-validation-span-id').empty();
			return "";
		}
		$('#' + spanIdName).empty();
		return username;
	}
	return "";
}
function validateCompanyID(node, spanId) {

	const id = node.value.trim();

	$('#' + spanId).empty();
	if (id.length > 0) {
		$('#' + spanId).empty();

		if (!id.match(companyIdPattern)) {
			$('#' + spanId).css("color", "red").css("font-size", "0.8rem");
			$('#' + spanId).append(
				' <span> Invalid Company ID' + '</span>');
			return "";
		}
		$('#' + spanId).empty();
		return id;
	}
	$('#' + spanId).css("color", "red").css("font-size", "0.8rem");
	$('#' + spanId).append(
		' <span>Please Enter Your Company ID' + '</span>');
	return "";
}

function endDateValidate(node, spanIdName) {
    const endDate = new Date(node.value.trim());
    const endDateErrorMessage = $('#' + spanIdName);
    endDateErrorMessage.empty();
    endDateErrorMessage.removeClass('fa fa-exclamation-triangle');
    if (!isNaN(endDate.getTime())) {
        const startDate = new Date($('#start_date').val());
        
        if (startDate > endDate) {
            endDateErrorMessage.css("color", "red").css("font-size", "0.8rem");
            endDateErrorMessage.append('<span> End date must be after the start date' + '</span>');
            return null;
        } else {
            endDateErrorMessage.empty();
            endDateErrorMessage.removeClass('fa fa-exclamation-triangle'); 
            return node.value.trim();
        }
    } else {
        
        endDateErrorMessage.css("color", "red").css("font-size", "0.8rem");
        endDateErrorMessage.append('<span> Invalid date format' + '</span>');
        return null;
    }
}