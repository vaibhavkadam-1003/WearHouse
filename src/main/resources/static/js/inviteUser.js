$(document).ready(function() {
	let contextPath = $("#id-context-path").val();
	
	$('#email1').on('keyup', () => {
		if($('#email1').val().length >= 5 && $('#email1').val().length < 64)
			$('#invite-add').removeAttr('disabled');
		else
			$('#invite-add').attr('disabled', true);
	})
	
	$('#userFilter').on('change', function(){
		if($('#userFilter').val() === "allUsers"){
			window.location.href = contextPath+"/users?pageNo=0";
		}else if($('#userFilter').val() === "projectUsers"){
			window.location.href = contextPath+"/users/getUsersProject?pageNo=0";
		}
	})
	
	const form = document.getElementById('invite-user-form');
    const submitButton = document.getElementById('invite-add');
    let isSubmitting = false;

    form.addEventListener('submit', function(event) {
      if (isSubmitting) {
        event.preventDefault();
      } else {
        submitButton.disabled = true;
        isSubmitting = true;
      }
    });
})