function deleteNoticationById(notificationId,basePath) {

	$("#item" + notificationId).attr('href', "javascript: void(0);");

	$.ajax({
		url: basePath + '/notification/' + notificationId,
		method: 'GET',
		contentType: 'application/json',
		success: function(result) {
			if(result === 'Notication deleted successfully'){
				let count = parseInt($("#notificationCount").html()) - 1;
				$("#notificationCount").html(count);
				let itemToDelete = document.getElementById('item'+notificationId);
				itemToDelete.remove();
			}
		}
	});
}

function deleteAllNotications(basePath) {

	$.ajax({
		url: basePath + '/notification/deleteAll',
		method: 'GET',
		contentType: 'application/json',
		success: function(result) {
			$("#allNotifications").remove;
			$("#collapseExample").html('');
			$("#notificationCount").html(0);
			$("#notificationHeading").html("You have 0 notifications");
			$("#collapseExample").html('');
		}
	});
}