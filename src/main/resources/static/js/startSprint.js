$(document).ready(function() {

	$("#sprintSelect").change(function() {
		var selectedOption = $(this).find("option:selected");
		var selectedStartDate = new Date(selectedOption.data("start"));
		var currentDate = new Date();
		if (selectedStartDate > currentDate) {
			$('#sprint-start').removeAttr('disabled');
		} else {
	 var daysDifference = Math.ceil((selectedStartDate - currentDate) / (1000 * 60 * 60 * 24));

			Swal.fire({
				title: "Warning",
                 text: "Your sprint start date is " + selectedOption.data("start") +
                        " but today is today's local date. The start date is " + daysDifference +
                        " day(s) in the past. Do you want to keep it or change it?",				
                icon: "warning",
				showCancelButton: true,
				confirmButtonText: "Keep",
				cancelButtonText: "Change",
			}).then((result) => {
				var selectedOption = $(this).find("option:selected");
				if (result.isConfirmed) {
					$("#startDate").val(selectedOption.data("start"));
					$("#endDate").val(selectedOption.data("end"));
					$('#sprint-start').removeAttr('disabled');
				} else {
					var newStartDate = new Date(currentDate);
					var selectedEndDate = new Date(selectedOption.data("end"));
					var difference = selectedEndDate - selectedStartDate;
					var newEndDate = new Date(newStartDate);
					newEndDate.setDate(newEndDate.getDate() + (difference / (1000 * 60 * 60 * 24)));
					var newStartDateFormatted = newStartDate.toISOString().split("T")[0];
					var newEndDateFormatted = newEndDate.toISOString().split("T")[0];
					$("#startDate").val(newStartDateFormatted);
					$("#endDate").val(newEndDateFormatted);
					$('#sprint-start').removeAttr('disabled');
				}
			});
		}
	});
	
	$('#name').on('change', () => $('#sprint-start').removeAttr('disabled'));
});

function checkIdMatch() {
    var selectedSprintId = document.getElementById("sprintSelect").value;
    var checkboxes = document.querySelectorAll('input[name="scrumTeams"]');
    checkboxes.forEach(function(checkbox) {
        var scrumTeamId = checkbox.value;        
        var selectedSprintScrumId = document.querySelector('option[value="' + selectedSprintId + '"]').getAttribute('data-scrum-id');
        if (selectedSprintScrumId === scrumTeamId) {
            checkbox.checked = true;
        } else {
            checkbox.checked = false;
        }
    });
}