$( document ).ready(function() {
	
		$('#searchInput').on('keyup', function() {
			var searchText = $(this).val().toLowerCase().trim();
	
			$('.user-info').each(function() {
				var cardTitle = $(this).find('.user-name').text().toLowerCase().trim();
	
				if (cardTitle.includes(searchText)) {
					$(this).show();
				} else {
					$(this).hide();
				}
			});
		});
	
	$('#editTeam').on('click', function(){
		$('#editTeam1').removeClass('d-none')
		$('#titleDiv').addClass('d-none');
	})
	$('#cancelEdit').on('click', function(){
		$('#editTeam1').addClass('d-none')
		$('#titleDiv').removeClass('d-none')
	})
	
	//UserAddButtonCode
	$(".addUser").on('change', function() {
		if(!$('input.addUser:checked').length == 0 ){
				$("#addUserBtn").removeAttr('disabled');
			}
			if(!$('input.addUser:checked').length == 1 ){
				$("#addUserBtn").prop('disabled', $('input.addUser:checked'));
			}
	})
});

function updateTeam( teamId ){
	let contextPath = $("#contextPathInput").val();
	let teamName = $('#teamName').val();
	if(teamName.length < 2){
		toastr.error('Name must be at least 2 characters long.');
		return;
	}
	var formData = new FormData();
		formData.append('id', teamId);
		formData.append('name', teamName);
	$.ajax( {
         url: contextPath+'/scrums/update',
		 type: 'POST',
        data: formData,
         processData: false,
		 contentType: false,
        success: function ( data ) {
			let updatedTeamName = data.name;
			let h4Element = $('#titleDiv h4');
			h4Element.text(updatedTeamName);
			h4Element.append(" Details <i class='bx bxs-edit ms-3 text-primary' id='editTeam'></i></h4>");
			$('#editTeam1').addClass('d-none')
			$('#titleDiv').removeClass('d-none')
			$('#titleDiv').on('click', '#editTeam', function() {
                $('#editTeam1').removeClass('d-none')
				$('#titleDiv').addClass('d-none');
            });
            toastr.success('Scrum Team Updated', '', { timeOut: 1000 });
        },
        error: function ( xhr, status, error ) {
            console.log( xhr, status, error );
        }
    } );
}

var selectedUsers = [];
var userIds = [];
function addNewUser(e) {
	let checkboxes = document.querySelectorAll("input[type='checkbox']:checked");
	let arr = [];
	 selectedUsers = [];
	for (let i = 0; i < checkboxes.length; i++) {
		arr.push(checkboxes[i].value)

		let role =  arr[i].split("-")[1].trim();
		let modifiedRole = role.replace(/[\[\]']/g,'' )

		let userId = arr[i].split("-")[0]
		let obj = {
			'role': modifiedRole,
			'userId': userId
		};

		selectedUsers.push(obj);
		document.getElementById('scrumRolesInput').value = JSON
			.stringify(selectedUsers);
			
			
	}
	return selectedUsers.filter((item,
        index) => selectedUsers.indexOf(item) === index);
}

function sbmt(id, basePath) {
	for (let i = 0; i < selectedUsers.length; i++) {
		userIds.push(selectedUsers[i].userId);
	}
	 
	let obj = {
		users: userIds,
		roles: selectedUsers,

	}
	
	$.ajax({
		url:  basePath+"/scrums/addUser/" + id,
		type: 'POST',
		contentType: "application/json;",
		data: JSON.stringify(obj),
		success: function(result) {
			let a = document.createElement('a');
					a.href = basePath+"/scrums/details/"+id,
					a.click();
					
					
			
		
		},

	});
}

function submitClick(id,projectId, basePath) {
	for (let i = 0; i < selectedUsers.length; i++) {
		userIds.push(selectedUsers[i].userId);
	}
	 
	let obj = {
		users: userIds,
		roles: selectedUsers,

	}
	
	$.ajax({
		url: basePath+"/scrums/addUser/" + id + "/" +projectId,
		type: 'POST',
		contentType: "application/json;",
		data: JSON.stringify(obj),
		success: function(result) {
			let a = document.createElement('a');
					a.href =  basePath+"/scrums/details/"+id+"/"+projectId,
					a.click();
		},

	});
}