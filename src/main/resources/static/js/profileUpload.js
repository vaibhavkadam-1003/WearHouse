$(document).ready(function() {
	var readURL = function(input) {
		if (input.files && input.files[0]) {
			var reader = new FileReader();

			reader.onload = function(e) {
				$('.profile-pic').attr('src', e.target.result);
			}
			reader.readAsDataURL(input.files[0]);
		}
	}
	$(".file-upload").on('change', function() {
		var flag = userProfileUpload()
		if(flag != false){
			readURL(this);
			$("#delete-button").attr('disabled', false);
		}
	});
	
		let contextPath = $("#contextPathInput").val();

	const pathCheck = contextPath+"/images/images.png";
	
	if ($('.profile-pic').attr('src') == pathCheck)
		$("#delete-button").attr('disabled', true);

});

function userProfileUpload() {
	var file = myform.profilePicFile.value;
	var reg = /\.(jpe?g|png)$/i;
	var uploadFileSize = document.getElementById("inputGroupFile01").files;

	if (uploadFileSize.length != 0) {
		var fileSize = uploadFileSize[0].size;
		var requiredFileSize = 5242880;
		if (!file.match(reg)) {
			toastr.error("Invalid file type !! accept only images!");
			$('.inputGroupFile01').val('');
			return false;
		}
		if (fileSize > requiredFileSize) { //for 5mb
			toastr.error("Max file size limit exceeded !! max size 5MB");
			$('.inputGroupFile01').val('');
			return false;
		}
		return true;
	}
}

function deleteProfileLogo(userId, basePath) {
	
	$.ajax({
		url:  basePath+'/users/deleteUserProfile/' + userId,
		method: 'GET',
		contentType: 'application/json',
		success: function(result) {
			if(result == "success"){
				toastr.success("Profile picture deleted successfully");
				setTimeout(function() {
				location.reload(true);
			}, 3000)
			}
			else{
				setTimeout(function() {
				location.reload(true);
			}, 1000)
			}
		}
	});
}