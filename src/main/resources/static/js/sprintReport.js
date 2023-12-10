function selectedSprintValue() {

	var sprintId = document.getElementById('sprintsReport').value;

	var hiddenInput = document.createElement('input');
	hiddenInput.setAttribute('type', 'hidden');
	hiddenInput.setAttribute('name', 'sprintId');
	hiddenInput.setAttribute('value', sprintId);
	hiddenInput.setAttribute('value', sprintId);
	document.getElementById('sprintReportForm').appendChild(hiddenInput);
	document.getElementById('sprintReportForm').submit();
}