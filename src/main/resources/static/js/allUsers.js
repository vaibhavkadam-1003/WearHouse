$(document).ready(function(){
	
	let contextPath = $("#id-context-path").val();
	
	$('#filter').on('change', function() {
  		const selectedOption = $(this).val();
  		filterData(selectedOption);
		let status = $(this).val(); 
  		$.ajax( {
        type: 'GET',
        url: contextPath+'/users/getUsersByStatus?pageNo=0',
		data:{
			status:status
		},
			success: function ( response ) {
				
				if(status === 'all')
					location.reload();
				
				console.log();
				let table1 = $('#tableID').DataTable();
                table1.clear().draw();
                const data = response.content;
                const table = $('<table>').addClass('table-new').attr('id', 'tableID').css('max-width', '100% !important');
                const thead = $('<thead>');
                const tbody = $('<tbody>').attr('id', 'user_body');
                const headerRow = $('<tr>');
                headerRow.append($('<th>').addClass('ps-3').text('Name'));
                headerRow.append($('<th>').text('Username'));
                headerRow.append($('<th>').text('Contact Number'));
                headerRow.append($('<th>').text('Status'));
                headerRow.append($('<th>').text('Action'));
                thead.append(headerRow);
				data.forEach(function (user) {
                  
					let first = user.firstName;
					let last = user.lastName; 
					let firstNameFirstChar = first.substring(0,1);
					let lastNameFirstChar = last.substring(0,1);	
					
					let editLink = user.isEditable
					    ? `<td><a href="/pluck/users/update/form/${user.id}" class="text-success">
								<i class="fa fa-pencil-square text-primary" aria-hidden="true"></i></a></td>`
					    : '';
					let bodyRow = `
								<tr class="iterativeRow">
								<td style="width: 25%;">
									<div class=" d-flex justify-content-start align-items-center">
										<div class=" ">
											<span class="avatar-title">${firstNameFirstChar}</span>
										</div>
										<div>
											<h5 class="m-0">
												<a class=" ">${user.firstName}&nbsp;${user.lastName}</a>
											</h5>
											<p class="text-muted mb-0">${user.highestRole}</p>
										</div>
									</div>
								</td>
								<td style="width: 25%;">${user.username}</td>
	
								<td style="width: 25%;">${user.contactNumber}</td>
								<td class=" status" style="width: 20%;">		
									<a class="${getStatusClass(user.status)}">${user.status}</a>														
								</td>
								${editLink}		
									
							</tr>
						
					`;
					console.log(bodyRow);
                    tbody.append(bodyRow);
                });
				
				table.append(thead);
                table.append(tbody);
                
                $('#tableContainer').empty().append(table);
               
                $('#tableID').DataTable();
            },
            error: function (error) {
             
            }
		});
	});
	if (window.history && window.history.pushState) {
   let loc =  window.history.pushState('forward', null);
    $(window).on('popstate', function() {
          window.location.reload();
    });
  }
	
	$('#userFilter').on('change', function(){
		if($('#userFilter').val() === "projectUsers"){
			window.location.href = contextPath+"/users/getUsersProject?pageNo=0"
		}else if($('#userFilter').val() === "invetedUsers"){
			window.location.href = contextPath+"/invite/getInvitedUsers"
		}
	})

})
function getStatusClass(status) {
    switch (status) {
        case "Active":
            return "badge badge-soft-primary";
        case "Inactive":
            return "badge in-active";
        case "Pending":
            return "badge in-active";
		case "Pending Approval":
            return "badge in-active";
        default:
            return "badge";
    }
}