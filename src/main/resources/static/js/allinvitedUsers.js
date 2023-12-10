$(document).ready(function(){
	$('#filter').on('change', function() {
  		const selectedOption = $(this).val();
  		filterDataForInvitedUser(selectedOption);
	});
	
	$('#userFilter').on('change', function(){
		let contextPath = $("#contextPathInput").val();
		if($('#userFilter').val() === "allUsers"){
			window.location.href = contextPath+"/users?pageNo=0";
		}else if($('#userFilter').val() === "projectUsers"){
			window.location.href = contextPath+"/users/getUsersProject?pageNo=0";
		}
	})
	
})