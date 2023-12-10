$(document).ready(function(){
	let contextPath = $("#id-context-path").val();
	
	$('#filter').on('change', function() {
  		const selectedOption = $(this).val();
  		filterData(selectedOption);
	});
	
	$('#userFilter').on('change', function(){
		if($('#userFilter').val() === "allUsers"){
			window.location.href = contextPath+"/users?pageNo=0";
		}else if($('#userFilter').val() === "invetedUsers"){
			window.location.href = contextPath+"/invite/getInvitedUsers";
		}
	})
});